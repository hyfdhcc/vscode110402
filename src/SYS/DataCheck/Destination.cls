/// The destination system directs the datacheck protocol.
/// This class provides control methods for starting and stopping the system.
/// See <CLASS>System</CLASS> for overview.
/// <p>
/// <u>To create a new DataCheck system:</u>
/// <li>Create a new DataCheck Destination object on the destination system, 
/// passing the appropriate parameters to the %New constructor 
/// (see <METHOD>%OnNew</METHOD>).  Its related objects will be created
/// automatically.</li>
/// <li>Set up information about the source system in the 
/// <CLASS>Configuration</CLASS> object, referenced by the 
/// <PROPERTY>Configuration</PROPERTY> property.
/// <li>Modify the <CLASS>RunParameters</CLASS> object, referenced
/// by the <PROPERTY>RunParameters</PROPERTY> property.  It defines performance
/// characteristics and what globals should be checked, with conservative but
/// usable defaults.</li>
/// <li>If needed, modify the <CLASS>Workflow</CLASS> object, referenced
/// by the <PROPERTY>Workflow</PROPERTY> property.  It defines the strategy for
/// performing the check and has defaults that are often suitable.</li>
/// <li>Call %Save on the destination object to save it and, implicitly, its 
/// referenced objects.</li>
/// <li>Ensure that the source system has %Service_DataCheck enabled</li>
/// <li>Use <METHOD>Start</METHOD> to start the check.</li>
/// <p>
/// <b>Important:</b> Once created, the destination object is modified by the DataCheck
/// daemons on a running system only, and should be treated as read-only for all
/// other purposes.  Users should call %Save on this object only once as part of
/// creating the DataCheck destination system.
/// <p>
/// <u>To modify an existing DataCheck system,</u> modify the <CLASS>Configuration</CLASS>, 
/// <CLASS>RunParameters</CLASS>, or <CLASS>Workflow</CLASS> objects as needed,
/// adhering to the following guidelines:
/// <li>All of the referenced objects (as well as the Destination object itself)
/// have, as their ID, the name of the Destination object.  Each object can be
/// opened with %OpenId(name) directly or referenced through the namesake property
/// of the destination object.</li>
/// <li>Call the %Save method of the referenced object that has been modified 
/// only. Do not call %Save on the destination object.</li>
/// <li>The <CLASS>RunParameters</CLASS> and <CLASS>Workflow</CLASS> objects can be
/// saved while the system is running to change it's behavior dynamically.  The
/// system must be stopped to save changes to the Configuration object.</li>
/// <li>The referenced objects should not be deleted or recreated, only modified.
/// <p>
/// <u>To delete a Datacheck system</u>, call %DeleteId(name).  All related objects and
/// DataCheck results are deleted automatically.
/// 
Class SYS.DataCheck.Destination Extends SYS.DataCheck.System
{

/// Configuration object for this system
Property Configuration As Configuration;

/// Used on the Source to compute a unique name for this connection
Property GUID As %String;

/// Running Parameters object for this system
Property RunParameters As RunParameters;

/// Statistics object for this system
Property Stats As Statistics [ Internal ];

/// Workflow object for this system
Property Workflow As Workflow;

/// Current phase of workflow.  This property is modified by the DataCheck daemons 
/// on a running system only, and should be treated as read-only for all other purposes.
Property Phase As Phase(CLASSNAME = 1);

/// Current phase number.  This property is modified by the DataCheck daemons 
/// on a running system only, and should be treated as read-only for all other purposes.
Property PhaseNumber As %Integer;

/// Constructor for creating a new DataCheck destination system.  Specify a unique
/// name for this DataCheck system as the first parameter.  If this DataCheck
/// system is to be based on a mirror configuration, pass the mirror name as the
/// second parameter.
Method %OnNew(name As %String, mirrorname = "") As %Status
{
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal ]
{
}

/// Starts the system if not already started.  Returns %Status.  If the 'restartworkflow' 
/// parameter is set to true, the workflow will be set to restart at phase #1 rather
/// than resume where it left off.
/// <p>
/// Any changes to the destination object or related objects must be saved
/// before calling this method.
/// <p> 
/// Note: A return of $$$OK return here does not indicate the system started successfully
///       See the <METHOD>GetState()</METHOD> method to check the running state
Method Start(restartworkflow As %Boolean) As %Status
{
}

/// Requests the system to stop if running.  Upon restart, the system will resume
/// processing the queries that it was last running.
/// <p>
/// Note: The system is not necessarily stopped upon returning from this method
///       See the <METHOD>GetState()</METHOD> method to check the running state
Method Stop() As %Status
{
}

/// Returns true if the system has been requested to stop.
/// On returning true, 'reason' will be set to the reason code.
Method StopRequested(Output reason As StateReason) As %Boolean [ Internal, Private ]
{
}

/// Given a message of type $$$MsgTypeMirrorInfo, checks the state of the 
/// mirror with the configured DataCheck options.  Returns true if the
/// system is okay to continue operating, false otherwise.  On returning
/// false, the output parameter 'reason' stores the reason and 'wait' is
/// true if the system should wait for the mirror to be ready.
Method CheckMirror(message As %String, Output reason As StateReason, Output wait As %Boolean) As %Boolean [ Internal, Private ]
{
}

/// Initiate connection to Source and handle the initial handshake.  
/// <p>
/// On success, this method returns $$$OK, the current device is the 
/// TCP socket, and the 'message' output parameter contains the
/// $$$MsgTypeVersion message sent from the Source system.
/// <p>
/// If the OPEN to the source timed out, the status code returned will be 
/// $$$DCConnectTimeout, and the caller may decide to retry indefinitely.  
/// Other status codes are $$$DCAccessDenied, if access is denied by the
/// Source, and $$$DCFeatureNotSupportedByPeer.  There is typically no
/// reason to retry on such an error
/// <p>
/// Any other exceptions are thrown to the caller's exception handler
/// so that they can be handled just as the caller will handle exceptions
/// for the duration of the communication.  This includes the disconnect
/// SystemException codes <READ> and <WRITE> and the timeout StatusException
/// code $$$DCPeerTimeout (timeout after the connection is established).  
/// Though all these exceptions are retyable, it must be done carefully, 
/// as this could indicate a problem on the Source.
/// <p>
/// The TCP socket is closed on exception or error status return	.
/// <p>
/// Warning: the implementation doesn't support multiple simultaneous connections from a singe process
Method Connect(jobtype As %String, timeout As %Integer, Output message As %String) As %Status [ Internal ]
{
}

/// The Destination Query Manager manages startup and shutdown of the connection,
/// dispatches queries to the Source Query Manager and Destination Workers, 
/// and accumulates the results into the RangeList.  
/// 
/// <p>This is the main loop for the Destination Query Manager.  This method handles
/// startup, shutdown and reconnection attempts.  The connection initiation
/// and bulk of the work happens in ManagerSub()
Method Manager() [ Internal ]
{
}

/// This method implements the main connection mechanism and work loop for the
/// Destination Query Manager.  It first initiates a connection to the Source Manager,
/// and starts the Destination Receiver and Destination Worker processes.  Once the 
/// connection is initiated, it reloads any formerly active queries from disk,
/// and sends them out for answers, then enters its work loop.
/// 
/// <p>In the work loop, the Destination manager waits for query answers and control
/// messages on the main message queue.  Local answers will be queued there
/// by workers and remote answers will be queued there by the Destination receiver.
/// The manager takes the system through the defined workflow, and periodically
/// checks for updates to the workflow and queries submitted by the user.
/// 
/// This method returns if a stop is requested, the connection is lost, or an error
/// occurs.  If the connection should be retried, it will return true otherwise
/// it returns false.  The reason for returning is returned by reference in the
/// 'reason' parameter.
Method ManagerSub(Output reason As StateReason) [ Internal, Private ]
{
}

/// Returns the amount of time (in s) remaining before the workflow timeout expires. 
/// Returns -1 if the workflow timeout does not apply. 
/// Returns 0 if the workflow timeout has expired.
Method WorkflowTimeoutRemaining() As %Integer [ Internal ]
{
}

/// Important: ManagerSave() must be called before calling this method
Method ManagerWorkflow(firsttime As %Boolean) [ Internal, Private ]
{
}

Method ManagerFindGlobals(usesystemselection As %Boolean = 1) [ Internal ]
{
}

/// Releases all query and rangelist orefs and deletes all queries from the database
/// Returns the number deleted
Method ManagerDeleteQueries() As %Integer [ Internal, Private ]
{
}

/// Releases all query and rangelist orefs and clears the Active flag for all queries
Method ManagerRequeueActiveQueries() As %Integer [ Internal, Private ]
{
}

/// Called by the manager when we have received both local and remote answer
/// to a query.  Compares the answers, updates the rangelist and submits the
/// next queries if we haven't reached the end of the target range
Method ManagerCompletedQuery(query As Query) [ Internal, Private ]
{
}

/// Execute the SQL statement to find the queries for the specified queue.
Method ManagerFindQueries(queue As %String) [ Internal, Private ]
{
}

/// Manager subroutine to load queries of the specified queue,
/// put them into %querycache and submit them for answers.
/// <p>Input Parameters:
/// <li>queue: queue to load from (always $$$QueryQueueNormal right now)</li>
/// <li>replacequery: a query object that is completed and whose slot in the querycache
/// is being replaced by a new query.</li>
Method ManagerLoadQueries(queue As %String, replacequery As Query = "") [ Internal, Private ]
{
}

/// Manager subroutine to submit a query for answers.  It sends the query to
/// the peer and if there are no workers or if the query is very small, this
/// method will compute the local answer directly.  Otherwise it will send 
/// it to a worker job.
Method ManagerRunQuery(query As Query) [ Internal, Private ]
{
}

/// Manager subroutine to split a query into two for greater parallelism.
/// Adds the new query to the querycache array and runs it.
Method ManagerSplitQuery(query As Query) As Query [ Internal, Private ]
{
}

/// Called periodically by the manager to save queries, save rangelists 
/// and delete queries that have been processed already.  
Method ManagerSave() [ Internal, Private ]
{
}

/// The Destination Receiver receives query answers from the Source Sender and
/// passes the messages to the Destination Query Manager
Method Receiver() [ Internal ]
{
}

/// Get worker metrics from the source.
Method GetSourceWorkerMetrics(keepopen As %Boolean, Output device As %String) [ Internal ]
{
}

Query SourceDatabases(systemname As %String) As %Query(ROWSPEC = "Directory:%String") [ Internal ]
{
}

ClassMethod SourceDatabasesExecute(ByRef qHandle As %Binary, systemname As %String) As %Status [ Internal ]
{
}

ClassMethod SourceDatabasesClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod SourceDatabasesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

/// Returns a row for every database that appears in the specified DataCheck configuration.
/// Databases returned include all databases that: have a database mapping if the DataCheck configuration
/// is not based on mirroring; are in the mirror if the DataCheck configuration is based on mirroring; have
/// a global selection mask defined if the configuration is set to use global selection masks; have subscript
/// ranges to include/exclude defined if the configuration is set to use subscript ranges.
/// <p>
/// A database may be returned because it has global selection criteria defined even though it is not currently
/// available, and thus will not be checked by the DataCheck system.  
/// Databases that are not available will have a null in the 'Directory' column.
/// Databases may be unavailable because they do not have a mapping configured (non-mirror), or because they are
/// not in the list of mirrored databases (for mirror-based DataCheck).
/// <p>
/// Columns:
/// <li>Database: LocalDatabase datatype for database, a database path for non-mirror, or Mirror database name
/// <li>Directory: directory of the database, or null indicating that the database is not currently available. 
/// <li>Mask: global selection mask that will be used for this database (based on current configuration)
/// <li>HasMaskDefined: true if this database has a defined mask (and the system is set to use masks); false if it is using default
/// <li>HasSubscriptRanges: true if this database has subscript ranges defined (and the system is set to use them); false otherwise
Query DatabasesToCheck(systemname As %String) As %Query(ROWSPEC = "Database:LocalDatabase,Directory:LocalDatabase,Mask:%String,HasMaskDefined:%Boolean,HasSubscriptRanges:%Boolean") [ Internal ]
{
}

ClassMethod DatabasesToCheckExecute(ByRef qHandle As %Binary, systemname As %String) As %Status [ Internal ]
{
}

ClassMethod DatabasesToCheckClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod DatabasesToCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

Storage Default
{
<Data name="DestinationDefaultData">
<Subscript>"Destination"</Subscript>
<Value name="1">
<Value>Configuration</Value>
</Value>
<Value name="2">
<Value>GUID</Value>
</Value>
<Value name="3">
<Value>RunParameters</Value>
</Value>
<Value name="4">
<Value>Stats</Value>
</Value>
<Value name="5">
<Value>Workflow</Value>
</Value>
<Value name="6">
<Value>Phase</Value>
</Value>
<Value name="7">
<Value>PhaseNumber</Value>
</Value>
</Data>
<DefaultData>DestinationDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
