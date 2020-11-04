Include (%sySystem, FILEINC, %syMirror, %sySecurity, %syJrninc, %syPidtab, %syEMS)

///  This class contains the public interface (unless otherwise noted) to 
///  the Mirroring subsystem. It contains methods that return information and
///  provide control for customer scripts. 
///  <br><br>
///  This class can only be used by
///  programs running in %SYS. <class>%SYSTEM.Mirror</class> contains public
///  methods which can be called by programs running in any namespace.
Class SYS.Mirror Extends %SYSTEM.Help [ System = 4 ]
{

///  Default Localization Domain
Parameter DOMAIN = "%Utility";

///  Mirror journal purge wait duration
Parameter JrnPurgeDefaultWaitDuration = 14;

///  <p>
///  Turn the local node into the primary mirror member when 
///  it is currently the backup.
///  <br><br> This method does not force the node
///  to become the primary "at all costs", it is designed for normal takeover when
///  some external code has determined that the other node is either
///  down or has failed, or the user simply wants this node to become the primary.
///  This method will override the "cstop nofailover"
///  state which may have been declared when the other node shut down. This method
///  works by forcing the other node down.
///  </p>
///  <p>
///  Return Value: 
///  <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///  TRUE = node is now the primary (could have already been the primary)
///  <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///  FALSE = failed to become the primary
ClassMethod BecomePrimary() As %Boolean
{
}

/// Adds a database to the mirror.<br>
/// Can only be run on the primary mirror member.<br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>Directory</parameter> is the path to the database to add to the mirror. This
///   database must be listed in the dataset section of the configuration file or an
///   error is returned. 
///  <li><parameter>MirrorDBName</parameter> if specified is the name to assign to the
///  database in the mirror. If omitted this defaults to the database name which points
///  to this database in the [Databases]
///  section of the configuration file. This must be between 1 and 62 characters and must
///  not contain any ':' characters.
///  <li><parameter>enableJournalOK</parameter> if specified as FALSE means that if the
///  target database does not have journaling enabled, the operation will fail. If this 
///  parameter is omitted or specified as TRUE, then journaling will be enabled for the
///  target database (if it isn't already) as part of adding it to the mirror.
///  </ul>
///  <br>
///  If the operation succeeds, the database will be mounted and journaling
///  will be enabled. If the operation fails, the target database may be mounted and
///  journaling may be enabled (assuming EnableJournalOK is not FALSE) depending on
///  where the error occured.
ClassMethod AddDatabase(Directory As %String, MirrorDBName As %String = "", enableJournalOK As %Boolean = 1) As %Status
{
}

/// Adds a database to the mirror.<br>
/// Can only be run on the NON-primary mirror member.<br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>Directory</parameter> is the path to the database to add to the mirror. This
///   database must be listed in the dataset section of the configuration file or an
///   error is returned. 
///  <li><parameter>MirrorSetName</parameter> The mirror set name of the database to be converted
///   to.
///  <li><parameter>MirrorDBName</parameter> if specified is the name to assign to the
///  database in the mirror. This must be between 1 and 62 characters and must
///  not contain any ':' characters.
///  <li><parameter>JrnPointMirfcnt</parameter> the mirror journal file count to be
///  recorded in the mirrored database for starting restore position.
///  <li><parameter>JrnPointOffset</parameter> the mirror journal file offset to be
///  recorded in the mirrored database for starting restore position.
///  <li><parameter>DBInfo</parameter> The database information (output from $SYSTEM.Mirror.DBGetInfo(0)).
///  If this is not specified or a null string then this method will retrieve the DB information from
///  the primary (or failover member), otherwise this method won't query from the other failover member
///  and use the information passed in. This method saved the Mirror GUID, database GUID of DBInfo into
///  the newly converted mirrored DB.
///  <li><parameter>RunCatchupDB</parameter> if TRUE, it will run CatchupDB() method after
///  successfully converted this database. Otherwise user has to run CatchupDB() method manually to
///  make the converted mirrored database active and up-to-date. The default value is TRUE.
///  <li><parameter>enableJournalOK</parameter> if specified as FALSE means that if the
///  target database does not have journaling enabled, the operation will fail. If this 
///  parameter is omitted or specified as TRUE, then journaling will be enabled for the
///  target database (if it isn't already) as part of adding it to the mirror.
///  </ul>
///  <br>
///  If the operation succeeds, the database will be mounted and journaling
///  will be enabled. If the operation fails, the target database may be mounted and
///  journaling may be enabled (assuming EnableJournalOK is not FALSE) depending on
///  where the error occured.<br>
/// <br>Warning! You have to use this method with care, you need to make sure the database
/// contained data up to the JrnPointMirfcnt,JrnPointOffset journal position, otherwise it
/// would not have synchronized data with the mirrored database in primary.<br>
ClassMethod AddDatabaseNonPrimary(Directory As %String, MirrorSetName As %String = "", MirrorDBName As %String = "", JrnPointMirfcnt As %Integer, JrnPointOffset As %Integer, DBInfo As %String = "", RunCatchupDB As %Boolean = 1, enableJournalOK As %Boolean = 1) As %Status [ Internal ]
{
}

/// Function called by primary member in SYS.Mirror.PurgeJournalFiles() or received GetJournalInfo requests
/// from connected backup/DR members to return the minimum mirror journal file count to be restained in
/// mirror journal file purge operation.
/// Type: 0 - requested by Primary's purge, 1 - requested by Backup's purge, 2 - requested by DR's purge (DR's system name appended).
ClassMethod PrimaryPurgeCriteria(mirrorname As %String, minjrnfile As %BigInt, maxdisconnecttime As %Integer, Type As %String = "0", ByRef ReasonToKeep As %String) As %BigInt [ Internal ]
{
}

ClassMethod PurgeAsyncMemberJournalFiles(ByRef Status As %Status, CheckOnly As %Boolean = 1, ByRef PurgedCount As %Integer, ByRef PurgedMB As %Integer, ByRef PurgedRange As %List, ByRef PurgedFiles As %String, SystemLimit As %String) As %Status [ Internal ]
{
}

///  <p>Optionally purges and returns information on mirror journal files which were/can be
///  purged because they are no longer required by the mirrored databases on this, or by 
///  other mirror members. 
///  <br><br>
///  Called from the purge routine in ^JRNUTIL when journal files are purged
///  to see if we can remove the mirror journal files corresponding to the same
///  criteria (e.g. a date, a backup, a filename, etc). Calling this method
///  directly bypasses the consideration of subsystems outside of mirroring
///  (eg. backups) which may require older journal files than are required to
///  support mirroring.
///  <br><br>
///  A journal file is eligible to be purged if it is not required on this node for
///  transaction rollback or journal restore and we have sent the journal file to the other
///  failover members or we can determine that they do not require it.
///  For reporting async members we only keep the journal files they require if they 
///  have connected within a certain time frame specified by the 
///  <parameter>maxdisconnecttime</parameter> parameter.
///  </p>
///  Input Parameters:
///  <ul>
///  <li><parameter>CheckOnly</parameter> TRUE means report on what files would be
///  deleted if they were purged. FALSE means purge the files and report on
///  the files which were deleted.</li>
///  <li><parameter>StartFile</parameter> if specified this is the latest file we
///  want to purge (eg. purge this file and older files). The starting point
///  of the purge can still be moved earlier if this file is required by one
///  or more of the other mirror members.</li>
///  <li><parameter>maxdisconnecttime</parameter> (0 means infinite)<br>
///    If a non-failover node has not connected within this period then we do 
///    not consider what journal files it hasn't seen when choosing files to
///    purge.</li>
///  <li><parameter>mirrorname</parameter> Not required on failover members which are only a member
///    of a single mirror. Required on non-failover members to indicate which 
///    mirror's journal files should be checked. </li>
///  </ul>
///  Output Parameters:
///  <ul>
///  <li><parameter>PurgedCount</parameter> Passed by reference receives the # of journal files deleted.</li>
///  <li><parameter>PurgedMB</parameter> Passed by reference returns the # of MB reclaimed by deleting the
///           journal files.</li>
///  <li><parameter>PurgedRange</parameter> Passed by reference has the value $LB(first,last) where first and
///           last are the mirror journal file #'s of the first and last journal 
///           files purged. This value only has meaning when PurgedCount is not 0.</li>
///  </ul>
ClassMethod PurgeJournalFiles(CheckOnly As %Boolean = 1, StartFile As %String = "", maxdisconnecttime As %String = "", mirrorname As %String = "", ByRef PurgedCount As %Integer, ByRef PurgedMB As %Integer, ByRef PurgedRange As %List, ByRef PurgedFiles As %String) As %Status
{
}

ClassMethod AddVirtualIPAddress(Interface As %String, IPAddr As %String) As %Integer [ Internal ]
{
}

ClassMethod DeleteVirtualIPAddress(Interface As %String, IPAddr As %String) As %Integer [ Internal ]
{
}

///  Invoked when this is a mirror member (backup or primary) and we have one
///  or more mirrored database which needs to be "caught up" and "linked in"
///  to the active system. This generally occurs when a database is
///  dismounted on a backup or or after a mirrored database is restored
///  from backup, copied between systems, etc.<br>
///  Input Parameters:
///  <ul>
///  <li><parameter>DBList</parameter> is a $list() of sfn's we want to "catchup".<br>
///  This is passed as a list, not an array, because that allows
///  us to job this off (a $Piece list would be fine too)</li>
///  <li><parameter>JournalLocation</parameter> is a $list() of the locations of the mirror journal files to be 
///  restored, it is only used for non-mirror member. The mirror member 
///  will ignore this because it will find the journal file through the 
///  agent of the mirror system. If this is null it defaults to the
///  current/alternate journal directories of the running system.</li>
///  <li><parameter>DBErrList</parameter> is a variable passed by reference which receives a $list() 
///  sfns which were not caught up.</li> 
///  </ul>
///  <br>Return Value:<br>
///  0 - Failed - no databases were caught up<br>
///  1 - Success, at least one database was caught up - DBErrList contains a $LIST() of<br>
///  &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp the sfn's which were not caught up as part of the operation. The list is empty<br>
///  &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp if all of the requested databases have been caught up.<br>
///  &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Additional information regarding errors might be found in the console log.<br>
///  <br>Allocates a block of dejournaling memory and uses the C
///  based dejournaler to apply journal records to the mirrored databases.<br><br> 
///  This can be used by non-mirror members, but they must have a copy
///  of the mirror journal log available so they can build a list of journal files to restore.<br><br>
///  On active mirror members the databases become "active" at the
///  end of a succesful operation. On a backup this means they're linked into the active
///  dejournaling system. On the primary this means transaction rollback is
///  performed and then the databases are marked read/write and are
///  available for use.
ClassMethod CatchupDB(DBList As %String, JournalLocation As %String = "", ByRef DBErrList As %String) As %Integer [ Final ]
{
}

///  Activate a mirrored database for use on this system<br>
///  Used when a mirrored database is moved to a home on a system
///  or when it is copied between instances (perhaps restored from
///  a backup) to mark it as "active". A database which is not marked
///  as active is read/only, even on the primary, and it is not kept
///  up to date on a backup. After a database is activated, 
///  <method>CatchupDB</method> is used to get it caught up so
///  it can become part of the active mirror.
ClassMethod ActivateMirroredDatabase(Directory As %String) As %Status
{
}

///  Remove a database from the mirror<br>
///  Updates a database so that it is no longer considered part of a mirror so
///  that it can be mounted read/write on any Cache' instance (eg. not just
///  the primary member of the mirror it was a part of).
///  <br><br>
///  Typically used in cases where a mirrored database is moved to a non-mirror
///  member or when a mirror member is removed from the mirror and the
///  former mirrored databases need to be mounted read/write. 
ClassMethod RemoveMirroredDatabase(Directory As %String) As %Status
{
}

///  List all connected Async Mirror Member in the system.
Query AsyncMemberList(Name As %String = "") As %Query(ROWSPEC = "Name:%String:Async Member Name,Type:%String:Async Member Type,X509DN:%String:X.509 DN,Status:%String")
{
}

ClassMethod AsyncMemberListExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status [ Internal ]
{
}

ClassMethod AsyncMemberListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = AsyncMemberListExecute ]
{
}

ClassMethod AsyncMemberListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = AsyncMemberListExecute ]
{
}

///  Wrapper method for GetFailoverMemberStatus so an EMS can receive this data
ClassMethod GetFailoverMemberStatusEMS(ByRef ThisMember As %String, ByRef OtherMember As %String) As %Status [ Internal, WebMethod ]
{
}

///  Return mirror failover members' status.<br>
///  Returned member information in $List format.<br>
///  It contains $LB(MirrorMemberName,AgentIP,Primary/Backup,Status,MirrorAddress,ECPAddress).
ClassMethod GetFailoverMemberStatus(ByRef ThisMember As %String, ByRef OtherMember As %String) As %Status
{
}

ClassMethod LatencyTimeToDisplay(Latency As %Integer) As %String [ Internal ]
{
}

///  Get the jbcurtim in the journal block of the offset in a journal file.
///  If the JrnCount is zero we get the last mirror journal file in log.
///  If the JrnOffset is zero we get the timestamp in the last block.
///  Return the timestamp in the block if succeed, return zero if failed.
ClassMethod GetJournalBlockTime(MirrorName As %String, JrnCount As %Integer = 0, JrnOffset As %Integer = 0) As %Integer [ Internal ]
{
}

///  Translate the information from GetNodeInfo^MIRRORCTL() to the journal latency data.
ClassMethod GetJournalLatencyFromNodeInfo(mirname As %String, latency As %String) As %Integer [ Internal ]
{
}

///  Translate the information from GetNodeInfo^MIRRORCTL() to the database latency data.
ClassMethod GetDatabaseLatencyFromNodeInfo(mirname As %String, latency As %String) As %Integer [ Internal ]
{
}

///  <p>
///  On a connected backup or async member this returns an indication
///  of how up to date the node is with respect to retrieving journal data
///  from the current primary. 
///  </p>
///  <p>
///  Return Value: 
///  <ul>
///  <li>
///  0 = Error, this node is not connected to the primary mirror member (this
///  node could be the primary or it could be disconnected).
///  </li><li>
///  1 = This node is caught up to the current end of the journal file on the 
///  primary.
///  </li><li>
///  negative # is the # of journal files behind the primary we are. -1 would
///  mean we're receiving the file prior to the current file, -2 the file
///  prior to that, etc.
///  </li><li>
///  positive # means we're receiving the current journal file on the primary
///  and this is the # of bytes in the file we're behind.
///  </li></ul>
ClassMethod DistanceFromPrimaryJournalFiles() As %Integer
{
}

///  <p>
///  On a connected backup or async member this returns an indication
///  of how up to date the active databases are with respect to the journal data
///  we've received from the primary.
///  </p>
///  <p>
///  Return Value: 
///  <ul>
///  <li>
///  0 = Error, this node is not connected to the primary mirror member (this
///  node could be the primary or it could be disconnected).
///  </li><li>
///  1 = The databases are caught up to the current end of the journal data 
///  </li><li>
///  negative # is the # of journal files behind the last one. -1 would
///  mean the journal file prior to the last file is being restore, -2 the file
///  prior to that, etc.
///  </li><li>
///  positive # means we're restoring the current journal file and this is the 
///  number of bytes remainining in the file to be restored
///  </li></ul>
ClassMethod DistanceFromPrimaryDatabases() As %Integer
{
}

///  <p>
///  On a connected backup or async member this returns an indication
///  of how up to date the node is with respect to retrieving journal data
///  from the current primary in time (seconds) 
///  </p>
///  <p>
///  Return Value: 
///  <ul>
///  <li>
///  -1 = Error, this node is not connected to the primary mirror member (this
///  node could be the primary or it could be disconnected).
///  </li><li>
///  0 = This node is caught up to the current end of the journal file on the 
///  primary.
///  </li><li>
///  Positive # is the # of seconds behind the primary we are.
///  </li></ul>
ClassMethod JournalFilesLatency(MirrorName As %String = "") As %Integer
{
}

///  <p>
///  On a connected backup or async member this returns an indication
///  of how up to date (in seconds) the active databases are with respect to the journal data
///  we've received from the primary.
///  </p>
///  <p>
///  Return Value: 
///  <ul>
///  <li>
///  -1,error text = Error, this node is not connected to the primary mirror member (this
///  node could be the primary or it could be disconnected).
///  </li><li>
///  0 = The databases are caught up to the current end of the journal data 
///  </li><li>
///  positive # means we're restoring the current journal file and this is the 
///  time remainining for the file to be restored
///  </li></ul>
ClassMethod DatabasesLatency(MirrorName As %String = "") As %Integer
{
}

///  Activate and startup a mirror.<br>
///  When MirrorName is null it must be a initial startup. Otherwise
///  it is a restart.
///  Returns $$$ERROR(reason) if we fail to startup the mirror.
///  Otherwise returns $$$OK.
ClassMethod StartMirror(MirrorName As %String = "") As %Status
{
}

///  Shutdown a mirror.<br>
///  Only Backup or Reporting node could be shutdown. Primary node
///  Shutdown is not allowed.<br>
///  When MirrorName is null it will shutdown all mirrors for Reporting node.
///  The Timeout is time (in seconds) to wait on the shutdown to be completed.
///  Returns $$$ERROR(reason) if we fail to stop the mirror.
///  Otherwise returns $$$OK.
ClassMethod StopMirror(MirrorName As %String = "", Timeout As %Integer = 10) As %Status
{
}

///  Whether the specific mirror set is started or not. It checked whether the MIRRORMGR master daemon of the specific mirror set is running or not.<br>
///  MirrorName needs to be specified and it has to be a non null value for this method.<br>
///  Returned 1 if the specific mirror set is started, otherwise returned 0.
ClassMethod IsMirrorStarted(MirrorName As %String) As %Integer
{
}

/// LocalizeMemberStatus(string) takes the mirror member status returned from 
/// ##class(%SYSTEM.Mirror).GetMemberStatus returns the localized equivilent.
/// <br<br>This used by the MemberStatusList and MirrorTrackedByAsyncMember queries. 
ClassMethod LocalizeMemberStatus(status As %String) As %String [ Internal ]
{
}

/// LocalizeGetInfoType(string) takes the mirror member type returned from 
/// $SYSTEM.Mirror.GetInfo(4), ##class(%SYSTEM.Mirror).GetMemberType and 
/// the AsyncMemberList query and returns the localized equivilent. 
/// <br<br>This is called by the MemberStatusList query. 
ClassMethod LocalizeMemberType(type As %String) As %String [ Internal ]
{
}

/// GetDisconnectedText(mirname,type): Find the latest time of ^MIRROR(mirname,"lastdisconnected",...) 
/// with matching type in the data value (PRIMARY, BACKUP or RELAY). 
ClassMethod GetDisconnectedText(mirname As %String, type As %String) As %String [ Internal ]
{
}

///  Get list of Mirror Members and its journal latency status.<br><br>
///  <ul>
///  <li><b>MemberName:</b> The system name of the mirror member.<br>
///  <li><b>CurrentRole:</b> The current role of the mirror member. It could be 'Primary', 'Backup', 'Async' or 'Unknown'.<br>
///  <li><b>CurrentStatus:</b> The current internal status of the mirror member. It could be 'Active', 'Restart', 'Trouble', 'Failover', 'Recovery', 'Deciding', 'Exit', 'Catchup', 'Async', 'Inactive' or 'Down'.<br>
///  <li><b>JournalLatency:</b> On a connected backup or async member this returns an indication
///  of how up to date the node is with respect to retrieving journal data from the current primary. For an
///  active backup, this is "Active" to indicate that it must be in sync with the primary.<br>
///  <li><b>DatabaseLatency:</b> On a connected backup or async member this returns an indication
///  of how up to date the active databases are with respect to the journal data we've received from the primary.<br>
///  <li><b>JournalTimeLatency:</b> On a connected backup or async member this returns an indication
///  of how up to date the node is with respect to retrieving journal data from the current primary in time (seconds). For an
///  active backup, this is "Active" to indicate that it must be in sync with the primary.<br>
///  <li><b>DatabaseTimeLatency:</b> On a connected backup or async member this returns an indication
///  of how up to date (in seconds) the active databases are with respect to the journal data we've received from the primary.<br>
///  <li><b>DisplayType:</b> This is similar to CurrentRole but has a slightly different set of values which match
///  the localized values returned from the GetMemberType method in <class>%SYSTEM.Mirror</class>. This is used in the mirror monitor displays.
///  <li><b>DisplayStatus:</b> This is similar to CurrentStatus but has value which match the localized values returned from
///  the GetMemberStatus method in <class>%SYSTEM.Mirror</class>. This is used in the mirror monitor displays.
///  </ul>
Query MemberStatusList(MirrorName As %String = "") As %Query(ROWSPEC = "MemberName:%String:Member Name,CurrentRole:%String:Current Role,CurrentStatus:%String:Current Status,JournalLatency:%String:Journal Transfer Latency,DatabaseLatency:%String:Dejournal Latency,JournalTimeLatency:%String:Journal Transfer Latency,DatabaseTimeLatency:%String:Dejournal Latency,DisplayType:%String:Display Type,DisplayStatus:%String:Display Status")
{
}

ClassMethod MemberStatusListExecute(ByRef qHandle As %Binary, MirrorName As %String = "", Type As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod MemberStatusListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MemberStatusListExecute ]
{
}

ClassMethod MemberStatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = MemberStatusListExecute ]
{
}

///  List of Mirror Sets tracked by the Async Member.
Query MirrorTrackedByAsyncMember(Names As %String = "*") As %Query(ROWSPEC = "Name:%String,AgentAddress:%String,AgentPort:%Integer,InstanceDirectory:%String,AsyncMemberType:%Integer,Status:%String,StatusInt:%Boolean,JournalLatency:%String:Journal Transfer Latency,DatabaseLatency:%String:Dejournal Latency,DNUpdates:%Boolean,Filter:%String")
{
}

ClassMethod MirrorTrackedByAsyncMemberExecute(ByRef qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 1 ]
{
}

ClassMethod MirrorTrackedByAsyncMemberClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MirrorSetTrackedByAsyncMemberExecute ]
{
}

ClassMethod MirrorTrackedByAsyncMemberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = MirrorSetTrackedByAsyncMemberExecute ]
{
}

/// Get the journal position of the primary member so a mirror member could check the latency of its journal file or database with this position.<br><br>
///  <b>MirrorSetName:</b> The mirror set name of the primary member.<br>
///  <b>JournalPosition:</b> Returned journal position of the primary, it will be a null string if it is not success. The returned string conatained MirrorJournalFileCount^JournalOffset^TimeStampOfJournalBlock.<br>
ClassMethod GetPrimaryJournalPosition(MirrorSetName As %String = "", ByRef JournalPosition As %String) As %Status
{
}

///  Get the list of mirrored databases for a specific mirror set or all mirror sets.<br><br>
///  <b>DBName:</b> The database name to be returned, default is "*" for all mirrored databases to be returned .<br>
///  <b>MirrorSetName:</b> The mirror set name to be retured, default is "*" for all mirror sets.<br>
///  <b>Name:</b> The database name returned in the column.<br>
///  <b>Directory:</b> The database directory path returned in the column.<br>
///  <b>MirrorName:</b> The mirror set name returned in the column.<br>
///  <b>MirrorStatus:</b> The current "mirror state" of the database, it could be one of the following values.<br>
///  'Normal' - (Primary Only) The mirrored database is writable (if not a read-only database) and global updates are being journaled.<br>
///  'Dejournaling' - (Backup and Async) The database has been activated and caught up and mirroring is applying journal data to the database.<br>
///  'Needs Catchup' - The database has been activated but not caught up yet; the Catchup operation is needed.<br>
///  'Needs Activation' - The database has not been activated yet; the Activate and Catchup operations are needed.<br>
///  'Obsolete' - The mirrored database is obsolete and should be removed from the mirror.<br>
///  'Dejournaling Stopped' - Dejournaling has been stopped by an operator or an error.<br>
///  'Database Dismounted' - The database is dismounted.<br>
///  'Catchup Running' - The Catchup operation is running on the database.<br>
///  <b>Latency:</b> This is an indication of how up to date the databases are with respect to the journal data we've received from the primary.<br>
Query MirroredDatabaseList(DBName As %String = "*", MirrorSetName As %String = "*", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Directory:%String,MirrorName:%String,MirrorStatus:%String,Latency:%String")
{
}

ClassMethod MirroredDatabaseListExecute(ByRef qHandle As %Binary, DBName As %String = "*", MirrorSetName As %String = "*", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod MirroredDatabaseListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MirroredDatabaseListExecute ]
{
}

ClassMethod MirroredDatabaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = MirroredDatabaseListExecute ]
{
}

///  Get the list of journal files for a specific mirror set, the latest file first.
Query JournalList(MirrorName As %String) As %Query(ROWSPEC = "FilePath:%String,FileCount:%Integer,Time:%TimeStamp,Reason:%String,FileGUID:%String")
{
}

ClassMethod JournalListExecute(ByRef qHandle As %Binary, MirrorName As %String) As %Status [ Internal ]
{
}

ClassMethod JournalListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = JournalListExecute ]
{
}

ClassMethod JournalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = JournalListExecute ]
{
}

///  Get the list of mirrored databases for a specific mirror set or all mirror sets for displaying.<br><br>
///  <b>DBName:</b> The database name to be returned, default is "*" for all mirrored databases to be returned .<br>
///  <b>MirrorSetName:</b> The mirror set name to be retured, default is "*" for all mirror sets.<br>
///  <b>Name:</b> The database name returned in the column.<br>
///  <b>Directory:</b> The database directory path returned in the column.<br>
///  <b>MirrorName:</b> The mirror set name returned in the column.<br>
///  <b>MirrorStatus:</b> The value of Active, NeedCatchup, Obsolete or NeedActivation which is the current "mirror state" of the database.<br>
///  'Active' - The mirrored database has been activated and caught up, Activate and CatchupDB operations are not needed.<br>
///  'NeedCatchup' - The mirrored database has been activated but not caught up yet, CatchupDB operation is needed.<br>
///  'Obsolete' - The mirrored database's GUID does not match the DB GUID in mirror journal file, it could be an old mirrored DB which was removed from the mirror.<br>
///  'NeedActivation' - The mirrored database has not been activated yet. Activate and CatchupDB operations are needed.<br>
///  <b>LastDejournalRecord:</b> This is the end offset of last dejournaled journal record applied to this mirrored database.<br>
Query MirroredDatabaseDisplay(DBName As %String = "*", MirrorSetName As %String = "*", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Directory:%String,MirrorName:%String,MirrorStatus:%String,MirrorStatusInt:%Integer,LastDejournalRecord:%String") [ Internal ]
{
}

ClassMethod MirroredDatabaseDisplayExecute(ByRef qHandle As %Binary, DBName As %String = "*", MirrorSetName As %String = "*", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod MirroredDatabaseDisplayClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MirroredDatabaseDisplayExecute ]
{
}

ClassMethod MirroredDatabaseDisplayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = MirroredDatabaseDisplayExecute ]
{
}

///  <p>
///  Set or get default value for how many days the mirror journal files are 
///  kept for non-failover/async nodes to connect and sync with failover members.
///  <br>
///  If no param specified, the current value is returned.
///  </p>
///  Note: this parameter applies to failover members only.
/// 
ClassMethod JrnPurgeDefaultWait(JrnPurgeWait As %Integer = "") As %Integer
{
}

///  This method will update the local member in MirrorSetMembers section in CPF file, it will update the DN field of the local system.
ClassMethod UpdateDNinMirrorSetMember() As %Status [ Final ]
{
}

/// Verify if ISCAgent is running, and the instance's version is less or equal the ISCAgent's version.
ClassMethod CheckISCAgent() As %Status [ Internal ]
{
}

/// Method to create a new mirror set in the system. There should be no mirror set existing in the system before this call.
/// This method will create the very first failover member of the mirror set.
/// <br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorSetName</parameter> is the name of the mirror set to be created.
///     This name is converted to uppercase before storing. Only alphanumeric
///     characters are allowed to be in the mirror set name. This name can not be a null string.
///  <li><parameter>SystemName</parameter> is the mirror system name of the local system to be created.
///   This is the name by which the system is known in the mirror. The name must
///   not contain any colons (:) and is converted to uppercase before storing. 
///   Mirror system names must be unique across all
///   mirror members as some mirror members (eg. relay and async members) may
///   participate in multiple mirrors and they will have the same system name
///   in all of the mirrors. If this name is omitted or a null string, the system will
///   create a system name for it.
///   But if the default system name (value of $SYSTEM) is over 32 in length then passing null
///   for <parameter>SystemName</parameter> will cause a failure in this call. So it is recommended that
///   caller should call <method>DefaultSystemName</method> to check its return value before passing null to this parameter.<br>
///  <li><parameter>MirrorInfo</parameter> Array of properties to create the mirror information in
///   [Mirrors], [MapMirrors] sections of configuration file. If the value is not set, system uses the default
///   value to create it. This is a pass-by-reference parameter.<br><ul>
///   <li>MirrorInfo("ArbiterNode") property in [Mirrors] section, an address for the arbiter node used by this mirror, default value is null string.<br>
///   <li>MirrorInfo("QOSTimeout") property in [Mirrors] section, default value is 8000.<br>
///   <li>MirrorInfo("UseSSL") property in [Mirrors] section, default value is 0.<br>
///   <li>MirrorInfo("VirtualAddress") property in [Mirrors] section, default value is null string.<br>
///   <li>MirrorInfo("CompressionForFailoverMembers") property in [Mirrors] section, default value is 0 as 'System Selected'.<br>
///   <li>MirrorInfo("CompressionForAsyncMembers") property in [Mirrors] section, default value is 0 as 'System Selected'.<br>
///   <li>MirrorInfo("VirtualAddressInterface") property in [MirrorMember] section, it depends on the value of 'VirtualAddress'.
///     If 'VirtualAddress' is null string then this will be a null string. If 'VirtualAddress' is not a null string then this must be
///     set as an valid network interface name in the system.<br>
///   <li>MirrorInfo("ECPAddress") property in [MapMirrors] section, this is the SuperServer Address, default value is result of $System.INetInfo.LocalHostName().<br>
///   <li>MirrorInfo("MirrorAddress") property in [MapMirrors] section, this is the Mirror Private Address, default value is same as ECPAddress.<br>
///  </ul>
///  <li><parameter>SSLInfo</parameter> Array of properties to create the Mirror SSL configuration. If MirrorInfo("UseSSL") is not set then this parameter is ignored.
///  If the Mirror SSL has been configured then users do not need to specify this parameter.
///  This is a pass-by-reference parameter. Please see detail of the array in <Method>UpdateMirrorSSL</Method>.<br>
///  </ul>
ClassMethod CreateNewMirrorSet(MirrorSetName As %String, SystemName As %String = "", ByRef MirrorInfo As %String, ByRef SSLInfo As %String) As %Status [ ProcedureBlock = 1 ]
{
}

/// Method to join an existing mirror set as a failover member. The target member should be
/// the only failover member in the mirror set.
/// This method makes the local system as the second failover member in the mirror set.<br>
/// If UseSSL is not set in the configuration then this method will automatically ask the primary
/// to add this new failover member to its configuration. So users don't need to call
/// <method>AddFailoverMember</method> method in the primary member to add this member in.
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorSetName</parameter> is the name of the mirror set to be joined.
///     This name is converted to uppercase before storing. Only alphanumeric
///     characters are allowed to be in the mirror set name. This name can not be a null string.
///  <li><parameter>SystemName</parameter> is the mirror system name of the local system to be created.
///   This is the name by which the system is known in the mirror. The name must
///   not contain any colons (:) and is converted to uppercase before storing. 
///   Mirror system names must be unique across all
///   mirror members as some mirror members (eg. relay and async members) may
///   participate in multiple mirrors and they will have the same system name
///   in all of the mirrors. If this name is omitted or a null string, the system will
///   create a system name for it.
///   But if the default system name (value of $SYSTEM) is over 32 in length then passing null
///   for <parameter>SystemName</parameter> will cause a failure in this call. So it is recommended that
///   caller should call <method>DefaultSystemName</method> to check its return value before passing null to this parameter.<br>
///  <li><parameter>InstanceName</parameter> is the instance name of the primary member to join to.
///  <li><parameter>AgentAddress</parameter> is the ISCAgent address of the primary member to join to.
///  <li><parameter>AgentPort</parameter> is the ISCAgent port of the primary member to join to, the default value is 2188 if it is omitted.
///  <li><parameter>LocalInfo</parameter> Array of properties to create the mirror information in
///   [MirrorMember], [MapMirrors] sections of configuration file of the local system. If the value is not set, system uses the default
///   value to create it.<br><ul>
///   <li>LocalInfo("VirtualAddressInterface") property in [MirrorMember] section, it depends on the value of 'VirtualAddress' retrieved from the primary.
///     If 'VirtualAddress' is null string then this will be a null string. If 'VirtualAddress' is not a null string then this must be
///     set as an valid network interface name in the system.<br>
///   <li>LocalInfo("ECPAddress") property in [MapMirrors] section, this is the SuperServer Address, default value is result of $System.INetInfo.LocalHostName().<br>
///   <li>LocalInfo("MirrorAddress") property in [MapMirrors] section, this is the Mirror Private Address, default value is same as ECPAddress.<br>
///  </ul>
///  <li><parameter>SSLInfo</parameter> Array of properties to create the Mirror SSL configuration. If "UseSSL" of remote system is not set then this parameter is ignored.
///  If the Mirror SSL has been configured then users do not need to specify this parameter.
///  This is a pass-by-reference parameter. Please see detail of the array in <Method>UpdateMirrorSSL</Method>.<br>
///  </ul>
ClassMethod JoinMirrorAsFailoverMember(MirrorSetName As %String, SystemName As %String = "", InstanceName As %String, AgentAddress As %String, AgentPort As %Integer = 2188, ByRef LocalInfo As %String, ByRef SSLInfo As %String) As %Status [ ProcedureBlock = 1 ]
{
}

/// Method to join an existing mirror set as an async member. The target member should be
/// a failover member.
/// This method makes the local system as an async member in the mirror set.
/// If this member has been setup as an async member then it could be used to add a mirror set to its tracking list.<br>
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorSetName</parameter> is the name of the mirror set to be tracked.
///     This name is converted to uppercase before storing. Only alphanumeric
///     characters are allowed to be in the mirror set name. This name can not be a null string.
///  <li><parameter>SystemName</parameter> is the mirror system name of the local system to be created.
///   This is the name by which the system is known in the mirror. The name must
///   not contain any colons (:) and is converted to uppercase before storing. 
///   Mirror system names must be unique across all
///   mirror members as some mirror members (eg. relay and async members) may
///   participate in multiple mirrors and they will have the same system name
///   in all of the mirrors. If this name is omitted or a null string, the system will
///   create a system name for it if it has not been created.
///   But if the default system name (value of $SYSTEM) is over 32 in length then passing null
///   for <parameter>SystemName</parameter> will cause a failure in this call. So it is recommended that
///   caller should call <method>DefaultSystemName</method> to check its return value before passing null to this parameter.<br>
///   If it has been created then this parameter will be ignored.<br>
///  <li><parameter>InstanceName</parameter> is the instance name of the failover member to join to.
///  <li><parameter>AgentAddress</parameter> is the ISCAgent address of the failover member to join to.
///  <li><parameter>AgentPort</parameter> is the ISCAgent port of the failover member to join to, the default value is 2188 if it is omitted.
///  <li><parameter>AsyncMemberType</parameter> is the type of this async member to be created, 0 - Disaster Recovery (DR), 1 - Read-Only Reporting, 2 - Read-Write Reporting. The default value is 0 if it is omitted.
///   This value will be ignored if the async member has been setup, that means this method is used to add new mirror set for tracking.
///  <li><parameter>LocalInfo</parameter> Array of properties to create the mirror information in
///   [MirrorMember], [MapMirrors] sections of configuration file of the local system. If the value is not set, system uses the default
///   value to create it.<br><ul>
///   <li>LocalInfo("VirtualAddressInterface") property in [MirrorMember] section, it depends on the value of 'VirtualAddress' retrieved from the primary.
///     If 'VirtualAddress' is null string then this will be a null string. If 'VirtualAddress' is not a null string then this must be
///     set as an valid network interface name in the system.<br>
///   <li>LocalInfo("ECPAddress") property in [MapMirrors] section, this is the SuperServer Address, default value is result of $System.INetInfo.LocalHostName().<br>
///   <li>LocalInfo("MirrorAddress") property in [MapMirrors] section, this is the Mirror Private Address, default value is same as ECPAddress.<br>
///   <li>LocalInfo("EncryptCommunication") property in [MapMirrors] section, this is the outgoing/incoming encryption flag,
///    see description of this property in <class>Config.MapMirrors</class> default value is 0.<br>
///  </ul>
///  <li><parameter>SSLInfo</parameter> Array of properties to create the Mirror SSL configuration. If "UseSSL" of remote system is not set then this parameter is ignored.
///  If the Mirror SSL has been configured then users do not need to specify this parameter.
///  This is a pass-by-reference parameter. Please see detail of the array in <Method>UpdateMirrorSSL</Method>.<br>
///  </ul>
ClassMethod JoinMirrorAsAsyncMember(MirrorSetName As %String, SystemName As %String = "", InstanceName As %String, AgentAddress As %String, AgentPort As %Integer = 2188, AsyncMemberType As %Integer, ByRef LocalInfo As %String, ByRef SSLInfo As %String) As %Status [ ProcedureBlock = 1 ]
{
}

/// Method to add another failover member to the existing mirror set. The target member should have
/// two failover members configured in the mirror set. One of the failover member should be this local
/// system.
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorSetName</parameter> is the name of the mirror set to be processed.
///     This name is converted to uppercase before being processed. Only alphanumeric
///     characters are allowed to be in the mirror set name. When this name is omitted or a null string
///     system will find the mirror set name configured.
///  <li><parameter>InstanceName</parameter> is the instance name of the failover member to be added.
///  <li><parameter>AgentAddress</parameter> is the ISCAgent address of the failover member to be added.
///  <li><parameter>AgentPort</parameter> is the ISCAgent port of the failover member to be added, the default value is 2188 if it is omitted.
///  </ul>
ClassMethod AddFailoverMember(MirrorSetName As %String = "", InstanceName As %String, AgentAddress As %String, AgentPort As %Integer = 2188) As %Status [ ProcedureBlock = 1 ]
{
}

/// Method to create or modify Mirror SSL configuration which includes %MirrorServer and %MirrorClient
/// SSL configurations.
///  Input Parameters:
///  <ul>
///  <li><parameter>SSLInfo</parameter> Array of properties to create the Mirror SSL configurations.
///   For creating the configuration if the property is not specified, a default value will be assigned to the property.
///   For modifying the configuration if the property is not specified, the property won't be changed.
///   This is a pass-by-reference parameter. You could see more detail of each property in <class>Security.SSLConfigs>/class>.<br><ul>
///   <li>SSLInfo("CAFile") File containing X.509 certificate(s) of trusted Certificate Authorities. This must not be a null string.<br>
///   <li>SSLInfo("CRLFile") File containing X.509 Certificate Revocation List for trusted Certificate Authorities. Default is a null string.<br>
///   <li>SSLInfo("CertificateFile") File containing this configuration's X.509 certificate. Default is a null string.
///       If not null, PrivateKeyFile must also be specified.<br>
///   <li>SSLInfo("CipherList") Colon-delimited list of enabled ciphersuites. Default is "ALL:!aNULL:!eNULL:!SSLv2".<br>
///   <li>SSLInfo("PrivateKeyFile") File containing this configuration's private key. Default is a null string.
///       If not null, CertificateFile must also be specified.<br>
///   <li>SSLInfo("PrivateKeyPassword") Optional password used to decrypt this configuration's private key. Default is a null string.
///       If not null, PrivateKeyFile and CertificateFile must also be specified.<br>
///   <li>SSLInfo("PrivateKeyType") Private key type. 1 - DSA, 2 - RSA. Default value is 2.<br>
///   <li>SSLInfo("Protocols") Protocols enabled. Sum of:  1 - SSLv2, 2 - SSLv3, 4 - TLSv1.0, 8 - TLSv1.1,
///       16 - TLSv1.2. Default value is 28 (TLSv1.0+TLSv1.1+TLSv1.2).<br>
///  </ul>
///  </ul>
ClassMethod UpdateMirrorSSL(ByRef SSLInfo As %String) As %Status
{
}

/// Default system name for the local system, it returned the value of $SYSTEM. But if the length is greater than MaxMirrorSYSLen (32) then it returned a null string.
ClassMethod DefaultSystemName() As %String
{
}

/// Create mirror journal log file for a mirror set from the mirror journal
/// 	   files located in a specific set of locations. This is called when
/// 	   the mirror journal log doesn't exist, it appears to be corrupted (can't
/// 	   be read) or the guid in the file doesn't match the local 
/// 	   system. Any existing file has been deleted and here we create
/// 	   a new one.
/// 
/// 	   mirname is the mirror set name of the mirror journal files.
/// 	   mirjrncnt is the starting journal count for the range, 0 means all.
/// 	   loc is a $list() of the directory(ies) containing the mirror journal files.
/// 	   Before this is called, make sure this mirror journal log file does not exist.
/// 	   
/// 	   Return error status,error The error could be:
/// 	                  The mirror journal log already existed.
/// 	                  Failed to access mirror log file.
/// 	                  One of the mirror journal file has different mirror set GUID.
/// 	                  The journal files are not contiguous with journal count.
/// 	                  Problem reading a journal file
/// 	   Return OK, if we built the mirror log file. The log file could be empty if
/// 	   			there are no matching journal files. 'FileCount' is the count of the # of
/// 	   			files we found
ClassMethod BuildJournalLog(mirname As %String = "", mirjrncnt As %Integer = 0, loc As %String = "", ByRef FileCount As %Integer, SaveOld As %Boolean = 0, FileLocked As %Boolean = 0) As %Status [ Internal ]
{
}

ClassMethod BuildJournalLogWithFiles(mirname As %String = "", LogFile As %SysPath, ByRef JrnFiles As %SysPath, FileLocked As %Boolean = 0) As %Status [ Internal ]
{
}

/// This method returns the current status of dejournaling on an async member for one
/// of the mirrors that the member is tracking.
/// <br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorName</parameter> is required when the async tracks more
/// than one mirror and is the name of the mirror to stop dejournaling. If omitted
/// and the async tracks multiple mirrors, "missing mirror name" is returned.
///  </ul>
/// Returns:
/// <ul>
///  <li>"" (null string) - system is not an async mirror member
///  <li>missing - dejournaling hasn't been initialized/member has not
///         established contact with its server
///  <li>running - dejournaling is up and running
///  <li>stopped - dejournaling stopped for some reason. More inforrmation is
///          recorded in the console log.
///  <li>shut down - dejournaling shut down by user requst.
///          Must be manually started before it will resume.
///  <li>error - dejournaling has shut down due to an error while
///          applying changes to a database. More information is recorded in
///          the console log and a ^%ET error trap record was generated in
///          %SYS.
///  <li>notmember - not a member of the specified mirror
///  <li>missing mirror name - the <parameter>MirrorName</parameter> parameter was
///         omitted and this async member tracks multiple mirrors.
///  </ul>
ClassMethod AsyncDejournalStatus(MirrorName As %String = "") As %String
{
}

/// This method is used on an async member to start the dejournaling processs for one
/// mirror that the member is tracking. This is useful after journaling has been
/// stopped with <method>AsyncDejournalStop</method>.
/// <br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorName</parameter> is required when the async tracks more
/// than one mirror and is the name of the mirror to stop dejournaling. If omitted
/// and the async tracks multiple mirrors, an error is returned.
///  </ul>
ClassMethod AsyncDejournalStart(MirrorName As %String = "") As %Status
{
}

/// This method is used on an async member to shut down the dejournaling for one
/// mirror that the member is tracking. Dejournaling remains stopped across
/// restarts until it is started again with either <Method>AsyncDejournalStart</Method>
/// or via the management interface. This is useful in a configuration where it is
/// desirable to update the data at some point of the day and then have it remain
/// static until the next update.
/// <br><Br>
/// Dejournaling can also be controlled on a per database basis using 
/// <Method>DejournalPauseDatabase</Method>.
/// <br><br>
///  Input Parameters:
///  <ul>
///  <li><parameter>MirrorName</parameter> is required when the async tracks more
/// than one mirror and is the name of the mirror to stop dejournaling. If omitted
/// and the async tracks multiple mirrors, an error is returned.
///  </ul>
ClassMethod AsyncDejournalStop(MirrorName As %String = "") As %Status
{
}

/// Stop dejournaling a database on a backup or on an async 
/// mirror member.
/// <br><br>
/// Dejournaling is restarted when the system is restarted or when
/// the <method>CatchupDB</method> is used to restore the missing data to the
/// database and link it into the active journaling system. It is not an
/// error to call this on a database which is requires catchup
/// or if the journaling system is shut down.
ClassMethod DejournalPauseDatabase(DatabasePath As %SysPath = "") As %Status
{
}

/// Get list of pending new members to be authorized so they could be added to this mirror set.
Query PendingNewMembers(MirrorSetName As %String = "") As %Query(ROWSPEC = "Name:%String,GUID:%String,InstanceDirectory:%String,AgentAddress:%String,MirrorAddress:%String,ECPAddress:%String,AgentPort:%Integer,MirrorSSPort:%Integer,MemberType:%String,MemberTypeDisplay:%String,SSLComputerName:%String,EncryptCommunication:%Integer,ConnectsTo:%String") [ Internal ]
{
}

ClassMethod PendingNewMembersExecute(ByRef qHandle As %Binary, MirrorSetName As %String = "") As %Status [ Internal ]
{
}

ClassMethod PendingNewMembersClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = PendingNewMembersExecute ]
{
}

ClassMethod PendingNewMembersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = PendingNewMembersExecute ]
{
}

/// Get list of pending DN updates to be authorized so they could be updated in primary's configuration.
Query PendingDNUpdates(MirrorSetName As %String = "") As %Query(ROWSPEC = "Name:%String,GUID:%String,MemberType:%String,SSLComputerName:%String") [ Internal ]
{
}

ClassMethod PendingDNUpdatesExecute(ByRef qHandle As %Binary, MirrorSetName As %String = "") As %Status [ Internal ]
{
}

ClassMethod PendingDNUpdatesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = PendingDNUpdatesExecute ]
{
}

ClassMethod PendingDNUpdatesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = PendingDNUpdatesExecute ]
{
}

/// Remove an entry from the pending approval list.
ClassMethod RemoveFromApprovalList(MemberName As %String, GUID As %String, MirrorSetName As %String = "") As %Status [ Final, Internal ]
{
}

ClassMethod GetDejournalFilterSetting(MirrorName As %String, ByRef FilterClass As %String) As %Status [ Internal ]
{
}

///  Compare configured mirrored databases with the mirrored databases listed in last mirror journal file.
///  List the databases in journal file but is not configured locally.<br><br>
///  <b>MirrorSetName:</b> The mirror set name to be retured, default is "" for first mirror sets.<br>
///  <b>Name:</b> This is the mirrored database alias name missing in local configuration.<br>
Query MissingMirroredDatabases(MirrorSetName As %String = "", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String") [ Internal ]
{
}

ClassMethod MissingMirroredDatabasesExecute(ByRef qHandle As %Binary, MirrorSetName As %String = "", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod MissingMirroredDatabasesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MirroredDatabasesValidationExecute ]
{
}

ClassMethod MissingMirroredDatabasesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = MirroredDatabasesValidationExecute ]
{
}

}
