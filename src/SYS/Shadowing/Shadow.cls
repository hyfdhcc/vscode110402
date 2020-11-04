Include (SHDW, %syJrninc, %syGluedef, %syAudit, %occFile)

/// API for the shadow (aka "Destination of Shadowing", the opposite of the data source) <p>
/// Example 1: creating a shadow, the short version, assuming identical Cache 
/// configurations (down to the directory level) on the shadow and the source 
/// <example>
///   s MyShadow=##class(SYS.Shadowing.Shadow).%New()
///   s MyShadow.Name="123.45.67.89"  ;source IP address
///   s rc=MyShadow.%Save()
/// </example>
/// Example 2: creating a shadow, the longer version 
/// <example>
///   s MyShadow=##class(SYS.Shadowing.Shadow).%New()
///   s MyShadow.Name="Shadow of a local Cache system"
///   s MyShadow.SourceName="localhost"
///   s MyShadow.SourcePort=50019
///   s MyShadow.JournalStore="d:\shadow\"
///   d MyShadow.SetDatabaseToShadow("c:\cachesys\mgr\user\","d:\shadow\user\")
///   s rc=MyShadow.%Save()
/// </example>
/// Example 3: controlling and monitoring a shadow 
/// <example>
///   s MyShadow=##class(SYS.Shadowing.Shadow).%OpenId("Shadow of a local Cache system")
///   w MyShadow.SourceName," ",MyShadow.SourcePort
///   s rc=MyShadow.Start($lb("","",0,"0,"_$zu(78,3))) i 'rc d $System.Status.DisplayError(rc)
///   w ##class(%ShadowState).LogicalToDisplay(MyShadow.Status)
///   s rc=MyShadow.Suspend() i 'rc d $System.Status.DisplayError(rc)
///   w ##class(%ShadowState).LogicalToDisplay(MyShadow.Status)
///   s rc=##class(SYS.Shadowing.Shadow).CheckPointInfo(MyShadow.Name,.cpinfo) i rc zw cpinfo
///   s rc=MyShadow.Resume() i 'rc d $System.Status.DisplayError(rc)
///   s rc=MyShadow.Stop() i 'rc d $System.Status.DisplayError(rc) 
///   s rc=MyShadow.Restart() i 'rc d $System.Status.DisplayError(rc) 
/// </example>
Class SYS.Shadowing.Shadow Extends (%Persistent, %SYSTEM.Help) [ Inheritance = right, StorageStrategy = ShadowStorage, System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Name ("ID") of the shadow <br>
/// The character "~" (tilde) is NOT allowed in the name as it is used as 
/// delimiter in cache.cpf and for cluster shadow <br>
/// A name in the form of HostName:Port (e.g., "localhost:1972") also 
/// defines SourceName and SourcePort, if they are not specified explicitly <br>
Property Name As %String [ Required ];

/// IP address or DNS name of the source (aka "database server") <br>
/// The default value is either derived from shadow ID (the 1st ":"-delimited 
/// field, see Name property) or "localhost", if shadow ID doesn't contain a 
/// <em>valid</em> IP address or DNS name.
Property SourceName As Config.Host;

/// DefaultPort of the source (aka "database server") <br>
/// The default value is derived from shadow ID (the 2nd ":"-delimited field, see
/// Name property) or DefaultPort of the shadow, if shadow ID doesn't contain one.
Property SourcePort As %Integer;

/// [OPTIONAL] Name of SSL Configuration to use for connection <br>
/// Set this to the name of a SSL Configuration if SSL/TLS communications are to be used.
Property SSLConfig As %String;

/// The property has been deprecated. It is ignored when you start shadowing via ^SHADOW or System Management Portal. You should always specify StartPoint in the Start() method.
Property StartPoint As %String [ MultiDimensional ];

/// The directory for storing temporary journal files copied from the source <br>
/// For cluster shadow, this is the parent directory; actual journal files are 
/// stored in its subdirectories named numerically (1, 2, 3, etc.), one
/// for each node of the source cluster. <br>
/// Default = "shadow" subdirectory of the manager directory <br>
Property JournalStore As %SysPath;

/// How many days of old shadow copies of source journal files to keep <br>
/// By default, the shadow copies are purged as soon as they are no longer
/// in use, i.e., have been completely dejournaled and contain no existing
/// open transactions, etc.
Property KeepOld As %Integer [ InitialExpression = 0 ];

/// Whether it is OK to use either primary or alternate journal directory to 
/// store shadow journal files <br>
/// Default: NO (recommended). You may change it to YES only if you can be sure 
/// that the local journal files don't conflict the shadow ones because of, for 
/// example, different prefixes. <br>
Property ShareJournalDirectory As %Boolean [ InitialExpression = 0 ];

/// Database redirections for dejournaling (i.e., applying SETs and KILLs) <br>
/// This is an array with keys being the source database directories and values,
/// the corresponding shadow database directories. An entry for a cluster-mounted 
/// source database also contains a secondary key indicating the cluster mount state <br>
/// Default = all user databases mounted on the shadow, on the assumption that
/// the shadow is identical to the source, down to the database level.  <br>
Property DatabaseRedirection As %SysPath [ MultiDimensional ];

/// Transient property (not saved to disk) <br>
/// SourceDatabaseMountState(SourceDatabaseDirectory)=MountState, where MountState
/// can be obtained from SourceDatabase() query <br>
/// Modified by SetDatabaseToShadow() and SetDatabaseNotToShadow() methods <br>
/// Retrieved by GetSourceDatabaseMountState() classmethod
/// 
Property SourceDatabaseMountState As %String [ MultiDimensional ];

/// Max number of unique error messages to keep <br>
/// Default = 10
Property ErrorMax As %Integer [ InitialExpression = 10 ];

/// Name of a user routine that decides whether a journal record should 
/// be dejournaled. (Optional)
Property Filter As %VarString;

/// Status of the shadow (active, inactive, etc.)
Property Status As %ShadowState [ Calculated ];

/// Type of the shadow (cluster or not), determined dynamically
Property Type As %ShadowState [ Calculated ];

/// Latency of shadowing (dejournaling) <br>
/// The latency is the time (in seconds) needed to apply the journal data copied 
/// from the source to shadow databases, based on current applying rate. 
/// -1 if latency is (temporarily) unavailable.
Property Latency As %Integer [ Calculated ];

/// the node ^SYS("shdwcli",ShadowID) <br>
/// This is set in NameSet() and loaded in %LoadData()
Property shdw As %VarString [ Internal, Private ];

/// when caught up, how long (in seconds) does shadow wait before polling the 
/// source for any updates
Property ProbeInterval As %Integer [ InitialExpression = 1 ];

/// If true, updates that the shadow applies to the shadow databases are NOT
/// journaled, regardless of the journal settings on the databases. By default,
/// this is false, that is, shadow updates are journaled.
Property DisableJournalUpdates As %Boolean [ InitialExpression = 0 ];

/// Is it a valid shadow configuration (i.e., ready to start)
ClassMethod IsValid(ShadowID As %CacheString) As %Status
{
}

/// Start or resume shadows as a group for better memory allocation <br>
/// Generally, <em>GroupOperation</em> is an array with keys being the IDs of 
/// the shadows to resume or start and values, the respective operations. 
/// Possible operation values are: <ul><li>
/// "RESUME" - to resume the suspended shadow from last checkpoint; </li><li>
/// "RESTART" - to restart the stopped shadow from last checkpoint; </li><li>
/// "" - to start the stopped shadow from default startpoint; </li><li>
/// startpoint - to start the stopped shadow from the given startpoint. </li></ul>
/// See Start() method for startpoint format.<br>
/// Note that subnodes of GroupOperation are not necessarily preserved.<br>
/// Alternatively, <em>GroupOperation</em> can be assigned one of the values
/// described below (for backward compatibility purpose): <ul><li>
/// "SUSPENDED" - to resume all suspended shadows; </li><li>
/// "ALL" - to resume all suspended shadows and start all stopped shadows. </li></ul>
/// The shared memory allocated for shadowing starts at half of the available
/// gmheap (for 1 shadow) and gradually increases as the number of shadows in
/// the group, but never exceeds two thirds of the available gmheap.<br>
/// On return, <em>GroupOperation</em> is an array with keys being the IDs of 
/// the shadows and values, the status of the specified operations on
/// individual shadows, i.e., <tt>GroupOperation(ShadowID)=Status</tt>.<br>
/// Return: <ul><li>
///  0, if there is no shadow in the specified group; </li><li>
/// >0 (= the number of shadows in the group), if every shadow in the group
/// started successfully;</li><li>
///  error(s), if at least one shadow failed to start.</li></ul>
ClassMethod StartGroup(ByRef GroupOperation As %String) As %Status
{
}

/// Start the shadow <br>
/// StartPoint should have one of the following nodes defined: <ul><li>
/// StartPoint("jrnloc") = JournalOffset,JournalFilePath  OR </li><li>
/// StartPoint("cluseq") = ClusterSessionID,ClusterSequence# </li><li>
/// Alternatively, StartPoint can be a $LIST string with the following elements: <ul><li>
/// Time - Timestamp in the form of YYYY-MM-DD HH:MM:SS or "" </li><li>
/// EventName - Name of the corresponding <em>source</em> event (e.g., journal switch, cluster start, etc.) or "" </li><li>
/// IsClusterSequence - 1 if the next element is a cluster sequence; 0 otherwise (that is, a journal location) </li><li>
/// JournalOffset,JournalFilePath or ClusterSessionID,ClusterSequence#, depending on IsClusterSequence value </li></ul>
/// Note: <ol><li>
/// The journal location or cluster sequence in StartPoint is of the <em>source</em> of the shadowing.</li><li>
/// The Time and EventName elements are for mnemonic purpose and can be given as "". </li></ol>
Method Start(ByRef StartPoint As %String) As %Status
{
}

/// Stop the shadow <br>
Method Stop(Forced As %Boolean = 0, RollBack As %Boolean = 0) As %Status
{
}

/// Suspend the shadow
Method Suspend() As %Status
{
}

/// Resume the shadow, if it is in suspended state <br>
Method Resume() As %Status
{
}

/// Restart the shadow, if it is in stopped state <br>
Method Restart() As %Status
{
}

/// Erase traces of prior shadowing session, including checkpoints, journal files, etc.,
/// resetting the shadow to a clean state in preparation for a new START or failover. <br>
/// The shadow must be in stopped state.
Method Clear() As %Status
{
}

/// Test connection to the source without actually shadowing it <br>
/// WaitTime: how long to wait (in seconds) for test to complete (either fail or succeed)
Method Test(WaitTime As %Integer = 10) As %Status
{
}

/// Set the name of the shadow, checking for nonpermissible characters "~"
Method NameSet(Name As %String) As %Status
{
}

/// <pre>
/// CheckPointInfo:
///   Return information (journal location, open transaction, etc.) about
///   the latest checkpoint of a shadow as given by 'ShadowID'.
/// Return success (1) or failure (0).
/// Output (by reference):
///   cpinfo = CheckPoint# (of the latest checkpoint)
///     Below, csn is always 0 for non-cluster shadow. For cluster shadow,
///     csn = 0, 1, 2, ..., corresponding to each node of the source cluster.
///   cpinfo(csn,"JournalLocation") = Offset,FilePath
///   cpinfo(csn,"JournalLocation","Offset") = Offset  [*]
///   cpinfo(csn,"JournalLocation","File") = FilePath
///     [*] For non-cluster shadow, Offset is always the last one processed;
///     for cluster shadow, Offset can be either the last one processed or the
///     next one to process (queued), distinguished by a sign -- in the former
///     case, the (last processed) offset is prefixed by a negative sign (-).
/// 
///     If there is any open transaction, the following gives the journal
///     location of the earliest open transaction (TSTART):
///   cpinfo(csn,"OldestOpenTranLoc") = Offset,FilePath
///   cpinfo(csn,"OldestOpenTranLoc","Offset") = Offset
///   cpinfo(csn,"OldestOpenTranLoc","File") = FilePath
/// 
///     -- for Cluster Shadow only --
///   cpinfo(csn,"ClusterSequence") = ClusterSessionID,ClusterSequence#
///   cpinfo(csn,"ClusterSequence","SessionID") = ClusterSessionID
///   cpinfo(csn,"ClusterSequence","Sequence#") = ClusterSequence#
/// </pre>
ClassMethod CheckPointInfo(ShadowID As %String, ByRef cpinfo As %String) As %Status [ CodeMode = expression ]
{
}

/// Return the start point of the shadow based on the Time, Name, and Location 
/// of an event, as given by SourceEvents query.
ClassMethod StartPointFromEvent(Time As %TimeStamp = "", Event As %String = "", Location As %String = "", ByRef StartPoint As %List) As %Status [ Internal ]
{
}

/// Deprecated. See property StartPoint.
Method SetStartPoint(Time As %TimeStamp = "", Event As %String = "", Location As %String = "") As %Status
{
}

/// Deprecated. See property StartPoint.
Method GetStartPoint(ByRef Time As %TimeStamp, ByRef Event As %String, ByRef location As %String, ByRef LocationTranslated As %String) As %Status
{
}

/// Status of a shadow (running or not running)
Method StatusGet() As %ShadowState [ CodeMode = expression ]
{
}

/// Status of a shadow (running or not running)
ClassMethod GetStatus(ShadowID) As %ShadowState
{
}

/// Type of a running shadow
Method TypeGet() As %ShadowType
{
}

/// Allowing journaled updates to the <em>SourceDatabase</em> on the data server 
/// to be applied to a <em>ShadowDatabase</em> on the shadow
Method SetDatabaseToShadow(SourceDatabase As %String, ShadowDatabase As %String, MountState As %String = "") As %Status
{
}

/// Preventing updates to the <em>SourceDatabase</em> on the data server 
/// from being applied to the shadow
Method SetDatabaseNotToShadow(SourceDatabase As %String) As %Status
{
}

Method GetSourceDatabaseMountState(SourceDatabase As %SysPath = "") As %String
{
}

ClassMethod GetLatency(ShadowID As %String) As %Integer
{
}

Method LatencyGet() As %Integer
{
}

ClassMethod GetGapFileSize(ShadowID As %String, CluShadowID As %String) As %Integer
{
}

ClassMethod Stat(ShadowID As %String, ByRef Latency As %Integer, ByRef shdwstat As %String, ByRef gapsiz As %Integer, ByRef shdwrate As %Integer, ByRef shdwraterec As %Integer, ByRef shdwrateavg As %Integer) As %Status [ Internal ]
{
}

/// errors is not part of the shadow configuration; it is generated at run-time
/// thus, we don't need to go through the Property/%Save() route to clear it
/// since errors is not a property, we expose it via query
Method ClearErrors() As %Status
{
}

Method %LoadData(id As %String) As %Status [ Internal, Private ]
{
}

Method %SaveData(id As %String) As %Status [ Internal, Private ]
{
}

/// This is meant for propogating changes from the config object to the
/// shadow object. See ActSHADOW^%SYS.Wsys. <br>
/// 
/// shdw.%Save() would fail if it is being performed in another process or
/// if the shadow is in a running state.
/// <br> TODO: AutoStart parameter is obsolete. Update %SYS.Wsys too.
ClassMethod SaveConfig(Name As %String, SourceName As %String, SourcePort As %Integer, SSLConfig As %Integer, AutoStart As %Boolean) As %Status [ Internal ]
{
}

/// Delete a shadow configuration (incl. the working copy in ^SYS("shdwcli"))
ClassMethod Delete(ShadowID As %String, GlobalOnly As %Boolean = 0) As %Status
{
}

/// Initialize SourceName and SourcePort if they haven't been set up yet
Method InitializeSource() As %Status [ Internal, Private ]
{
}

Method InitializeJournalStore() As %Status [ Internal, Private ]
{
}

Method InitializeDatabaseRedirection() As %Status [ Internal ]
{
}

/// Translate comma-delimited Latency value to text
ClassMethod TranslateLatency(latency As %String) As %String
{
}

/// Upgrade shadows from 5.0 or earlier
ClassMethod Upgrade() As %Status
{
}

/// Upgrade a shadow from 5.0 or earlier
ClassMethod UpgradeOne(ShadowID As %String) As %Status
{
}

/// Upgrade shadows to new format of checkpoints and open transaction entries (in 2008.1?)
ClassMethod UpgradeCheckPoint() As %Status
{
}

/// Returns a list of shadows with some snapshot info, most of which are unlikely to change on the fly
Query List() As %Query(ROWSPEC = "Name:%String,Status:%ShadowState,Source Name:%String,Source Port:%Integer,SSL Config:%String,Start Point:%String,Filter:%String,LogicalStatus:%ShadowState")
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// Returns details about shadows that tend to change on the fly <br><ul><li>
/// Name: Name of the shadow </li><li>
/// Status: see <class>%ShadowState</class> </li><li>
/// CheckPoint: Checkpoint number </li><li>
/// Errors: Number of errors </li><li>
/// Open Transactions: [yes/no] Any transaction open? </li><li>
/// Latency: Estimated delay in applying updates </li><li>
/// LogicalStatus: Logical value of Status </li><li>
/// Applying Journal: Path of the shadow journal file currently being applied to databases along with the percentage of completion; on a cluster shadow, it is a comma-delimited list of such (one for each source cluster node)</li><li>
/// Transfering Journal: Path of the shadow journal file currently being copied to from the source; on a cluster shadows, it is a comma-delimited list of such (one for each source cluster node)</li></ul>
Query Progress(ShadowID As %String = "") As %Query(ROWSPEC = "Name:%String,Status:%ShadowState,Checkpoint:%String,Errors:%Integer,Open Transactions:%Boolean, Latency:%String,LogicalStatus:%Integer,Applying Journal:%String:Applying Journal (Percentage Complete),Transfering Journal:%String")
{
}

/// Start with ShadowID if it is specified and defined; otherwise,
/// start with next one if ShadowID is not specified or not defined.
/// ShadowID containing "~" are filtered out.
ClassMethod ProgressExecute(ByRef qHandle As %Binary, ShadowID As %String = "") As %Status [ Internal ]
{
}

ClassMethod ProgressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ProgressClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// On success, return the path of the shadow journal file currently being applied (aka dejournaled) and its completion status as a fraction between 0 and 1, with "" being a special (usually transient) case where the completion status is not available at the moment (e.g., if the file is empty).
ClassMethod FilesInProgress(ShadowID As %String, ByRef FileInProcess As %String, ByRef Completion As %Numeric, ByRef FileInTransfer As %String) As %Status [ Internal ]
{
}

/// On success, return an array with indices being the paths of the shadow journal files currently being applied (aka dejournaled) and values being the completion status of the corresponding files. The completion status is a fraction between 0 and 1, with "" being a special (usually transient) case where the completion status is not available at the moment (e.g., if the file is empty).
ClassMethod ClusterFilesInProgress(ShadowID As %String, ByRef FilesInProcess, ByRef Completion As %Numeric, ByRef FilesInTransfer) As %Status [ Internal ]
{
}

/// Given a numeric value, return percentage
ClassMethod NumericToPercentage(Value As %Numeric = "", TotalDigits As %Integer, AfterDecimal As %Integer) As %String [ CodeMode = expression, Internal ]
{
}

ClassMethod ValidateShadowID(ByRef ShadowID As %String) As %Status [ Internal ]
{
}

/// Returns error info (if any) about a shadow configuration, in reverse order of time (i.e., latest error first).
/// Examples:<example>
/// s rs=##class(%ResultSet).%New("SYS.Shadowing.Shadow:Error")
/// w rs.Execute("MyShadow")
/// </example>
Query Errors(ShadowID As %String, PriorToError As %Integer = "") As %Query(ROWSPEC = "Time:%TimeStamp,PID:%Integer,$ZERROR:%String,Text:%String,Reoccurrences:%Integer,First Occurred At:%TimeStamp")
{
}

ClassMethod ErrorsExecute(ByRef qHandle As %Binary, ShadowID As %String, PriorToError As %Integer = "") As %Status [ Internal ]
{
}

ClassMethod ErrorsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ErrorsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// Returns info about transactions that are not yet committed in a shadow
Query IncompleteTransactions(ShadowID As %String) As %Query(ROWSPEC = "Process ID:%Integer,Remote System ID:%Integer,Journal File:%String,Journal Offset:%Integer")
{
}

ClassMethod IncompleteTransactionsExecute(ByRef qHandle As %Binary, ShadowID As %String) As %Status [ Internal ]
{
}

ClassMethod IncompleteTransactionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod IncompleteTransactionsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// Returns info about database redirections of a shadow
Query DatabaseRedirections(ShadowID As %String) As %Query(ROWSPEC = "Source Database:%String,Shadow Database:%String")
{
}

ClassMethod DatabaseRedirectionsExecute(ByRef qHandle As %Binary, ShadowID As %String) As %Status [ Internal ]
{
}

ClassMethod DatabaseRedirectionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod DatabaseRedirectionsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

/// Returns info about journal redirections of a shadow
Query JournalRedirections(ShadowID As %String) As %Query(ROWSPEC = "Source Journal Directory:%String,Shadow Journal Directory:%String")
{
}

ClassMethod JournalRedirectionsExecute(ByRef qHandle As %Binary, ShadowID As %String) As %Status [ Internal ]
{
}

ClassMethod JournalRedirectionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod JournalRedirectionsClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod GetSource(ShadowID As %String, ByRef Host As %String, ByRef Port As %Integer) As %Status
{
}

/// Returns info about source databases
Query SourceDatabases(ShadowID As %String, Host As %String, Port As %Integer) As %Query(ROWSPEC = "Directory:%String,Mount State:%String")
{
}

ClassMethod SourceDatabasesExecute(ByRef qHandle As %Binary, ShadowID As %String, Host As %String, Port As %Integer) As %Status
{
}

ClassMethod SourceDatabasesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

ClassMethod SourceDatabasesClose(ByRef qHandle As %Binary) As %Status
{
}

/// Returns a list of source events (journal switches, markers, etc.)
Query SourceEvents(ShadowID As %String, Host As %String, Port As %Integer) As %Query(ROWSPEC = "Time:%TimeStamp,Event:%String,Location:%String")
{
}

ClassMethod SourceEventsExecute(ByRef qHandle As %Binary, ShadowID As %String, Host As %String, Port As %Integer) As %Status
{
}

ClassMethod SourceEventsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

ClassMethod SourceEventsClose(ByRef qHandle As %Binary) As %Status
{
}

/// (Obsolete)
Query SourceClusterEvents(ShadowID As %String, Host As %String, Port As %Integer) As %Query(ROWSPEC = "Time:%TimeStamp,Event:%String,Location:%String")
{
}

ClassMethod SourceClusterEventsExecute(ByRef qHandle As %Binary, ShadowID As %String, Host As %String, Port As %Integer) As %Status
{
}

ClassMethod SourceClusterEventsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

ClassMethod SourceClusterEventsClose(ByRef qHandle As %Binary) As %Status
{
}

Storage ShadowStorage
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%SYSTEM.ShadowS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
