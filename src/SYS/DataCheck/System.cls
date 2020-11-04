Include (%syDataCheck, %syDataCheckMsg)

/// <u>DataCheck Overview</u>
/// <p>
/// The DataCheck system provides a mechanism to compare the state of data on two
/// systems and determine whether they are the matched or discrepant.  It is assumed 
/// that the global states on both systems may be in transition and the system provides
/// a mechansim to recheck discrepant ranges. 
/// <p>
/// One of the two systems must be defined as the destination.  All control and output
/// from the system is provided through the destination system.  Typically, the destination
/// system is the destination of shadowing or a non-primary mirror member, while the source
/// system is the source of shadowing or another mirror member.  See <CLASS>Destination</CLASS>
/// for detail on creating and configuring a DataCheck system.
/// <p>
/// The system operates in units called queries.  The query specifies a database, an initial 
/// global reference, a target global reference, and a number of nodes.  The query is sent
/// by the destination system to the source system.  Both systems calculate an answer by
/// traversing N global nodes starting with the initial global reference, and hashing
/// the keys/value pairs. The destination compares the query answers from both systems
/// and records the results in a set of <CLASS>RangeList</CLASS> objects.  
/// <p>
/// Queries are created automatically on the destination system based on its settings.  The 
/// destination system has a <CLASS>Workflow</CLASS> object to specify a strategy
/// for checking globals.  The Workflow consists of a number of phases to begin a check,
/// recheck discrepancies, etc.  The settings that define what globals to check are stored on the 
/// Destination in the <CLASS>RunParameters</CLASS> object.
/// <p>
/// This class, <CLASS>System</CLASS>, is an abstract class containing elements common to both 
/// <CLASS>Destination</CLASS> and <CLASS>Source</CLASS> systems.
Class SYS.DataCheck.System Extends %Persistent [ Abstract ]
{

/// Type of system job or "User" if not a system job
Property JobType As %String [ InitialExpression = {$$$JobTypeUser}, Private, Transient ];

/// Static parameter loaded by configuration on the destination
/// If true, detailed messages will by logged to the cconsole.log
Property Debug As %Integer [ InitialExpression = 0, Internal, Private ];

/// Protocol version used by our peer
Property PeerProtocolVersion As %String [ Internal, Private ];

/// Unique name of the system
Property Name As SystemName [ ReadOnly ];

/// Versioning for storage definitions of the DataCheck persistent classes
Property StorageVersion As %String [ Internal ];

/// Name of the mirror that this system is checking or null if not mirrorized
Property MirrorName As %String [ ReadOnly ];

Index NameIndex On Name [ IdKey, Unique ];

Method %OnNew(name As %String, mirrorname As %String = "") As %Status [ Internal ]
{
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal ]
{
}

Method SpawnJob(jobtype As %String, batch As %Boolean = 1) [ Internal, Private ]
{
}

/// Become a daemon job of the specified type for the specified system name.
ClassMethod JobEntry(name As %String, jobtype As %String, batch As %Boolean = 1, notifypid As %Integer = 0) [ Internal ]
{
}

/// This is the instance method called by the JobEntry() method and by Source:StartJobFromServer.  
/// It sets the process up to act as a DataCheck daemon job of the specified type.  This method
/// provides the base level of exception handling for all jobs.  Any unexpected exceptions caught
/// by this method will attempt to force all other jobs to stop by deleting the message queues.  
/// This method always halts, never returns.
Method JobMain(jobtype As %String, batch As %Boolean = 1, notifypid As %Integer = 0) [ Internal ]
{
}

/// Initialize a message queue for this system with the specified queue name
Method InitMessageQueue(qname As %String) [ Internal ]
{
}

/// Delete a message queue for this system with the specified queue name
Method DeleteMessageQueue(qname As %String) [ Internal ]
{
}

/// Throw a <ZQDEL> error in the specified queue name doesn't exist for this system
Method AssertMessageQueue(qname As %String) [ Internal ]
{
}

/// Enqueue a message on the specified message queue for this system
Method EnqueueMessage(qname As %String, message As %String) [ Internal ]
{
}

/// Dequeue a message from the specified message queue for this system.  Timeout in seconds or -1 for unlimited
Method DequeueMessage(qname As %String, timeout As %Integer = -1) As %List [ Internal ]
{
}

/// Called by <METHOD>JobMain</METHOD> to take out a lock associated with this job's
/// JobType stored in the transient <PROPERTY>JobType</PROPERTY> property.  Each
/// DataCheck job holds this lock for the duration of its lifetime.
Method LockJob(timeout As %Integer = -1) As %Boolean [ Internal, Private ]
{
}

/// Removes the lock associated with this job's job type.
Method UnlockJob() [ Internal, Private ]
{
}

/// Obtains a lock on the specified job type.  This method is used to wait for a particular job type to exit.
Method LockJobType(jobtype As %Integer, shared As %Boolean, timeout As %Integer = -1) As %Boolean [ Internal, Private ]
{
}

/// Removes a lock on the specified job type.
Method UnlockJobType(jobtype As %Integer, shared As %Boolean) [ Internal, Private ]
{
}

/// Obtains a lock on this system.  This lock will only be granted when the system
/// has stopped and all DataCheck daemons have exited.  This lock will prevent the 
/// system from being restarted.  This lock only conflicts with the lock held by 
/// running DataCheck daemons and the lock required to start the system; it does not
/// conflict with the lock used by the object concurrency control for this object itself.
/// <p>
/// Input Parameters:
/// <li>timeout: Time to wait in seconds. -1 (default) waits forever
/// <p>
/// Returns: true if successful, false otherwise
Method LockSystem(timeout As %Integer = -1) As %Boolean [ Internal ]
{
}

/// Releases the lock acquired by <METHOD>LockSystem</METHOD>.
Method UnlockSystem() [ Internal ]
{
}

/// Waits for all other DataCheck daemon jobs to exit (release their running locks).
/// This is used by the manager jobs to ensure that we don't more than one instance
/// of any system running at the same time.
Method WaitForJobs(timeout As %Integer = -1) As %Boolean [ Internal, Private ]
{
}

/// Set the running state and reason
Method SetState(state As %String, reason As StateReason = {$$$StateReasonUnknown}) [ Internal, Private ]
{
}

/// Returns the current running state of the system.
/// Values are constants, defined for convenience in %syDataCheck.inc
/// <li>"Starting" ($$$StateStarting) - System is in the initial phases of startup
/// <li>"Stopping" ($$$StateStopping) - System is stopping and will not process any more queries but may not be completely stopped
/// <li>"Stopped"  ($$$StateStopped) - System is stopped
/// <li>"Connecting" ($$$StateConnecting) - (destination only) System is attempting to establish a connection to the source
/// <li>"Running" ($$$StateRunning) - System is in the normal running state
/// <li>"Waiting" ($$$StateWaiting) - System is waiting for a condition in order to resume the check
/// <p>
/// Returns a reason code by reference to describe why the system is in its current state
/// (particularly the Stopping and Stopped states on the destination system).
/// Reason codes are not provided for all states.  The reason will be $$$ReasonUnknown
/// if a specific reason is not provided or not available.  
/// <p>
/// The reason code on the destination of DataCheck can be used to determine
/// whether the system has stopped due to a Workflow stop phase, a user-requested stop
/// or an error. Upon successful return from the <METHOD>Start</METHOD> method on the 
/// destination system, its state will be changed to $$$StateStarting.  On any subsequent
/// call to this method, the caller can determine whether the system has reached a 
/// workflow stop phase by checking the reason code for $$$StateReasonWorkflowStop.
/// While there is no guarantee that a reason will be provided when the system is
/// stopped in all cases, it is guaranteed that if the system stops due to a workflow
/// stop phase, the reason will be set to $$$StateReasonWorkflowStop.
/// <p>
/// See <CLASS>StateReason</CLASS> for possible reason codes.
Method GetState(Output reason As StateReason) As %String
{
}

/// Returns current running state of specified system or null on error.
/// Possible state values returned are identical to <METHOD>GetState()</METHOD> 
ClassMethod GetStateBySystem(systemname As SystemName, Output reason As StateReason) As %String [ SqlProc ]
{
}

/// Returns a string of performance metrics aggregated for all worker jobs.
/// 
Method GetWorkerMetrics() As %String [ Internal ]
{
}

/// Log a message to the cconsole.log
Method Log(type As %String, msg As %String) [ Internal ]
{
}

/// Called by the manager jobs to dynamically change the number of workers and/or
/// their batch flag.
Method NewNumWorkers(current As %Integer, new As %Integer, curbatch As %Boolean, newbatch As %Boolean) [ Internal, Private ]
{
}

/// Receive a message on the current device and return it.  Timeout in seconds, or -1 for untimed
ClassMethod RecvMessage(timeout As %Integer = -1) [ Internal ]
{
}

/// Send a message on the current device
ClassMethod SendMessage(msg) [ Internal ]
{
}

Method SendMirrorInfoMessage() [ Internal ]
{
}

/// Workers wait for queries on the WorkQ message queue, calculate the answers and send the answers back to the MainQ
Method Worker() [ Internal, Private ]
{
}

/// Version of the DataCheck protocol
Parameter ProtocolVersion [ Internal ] = 1.2;

/// Version for the DataCheck persistent classes
Parameter StorageVersion [ Internal ] = 1.0;

Storage Default
{
<Data name="SystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Debug</Value>
</Value>
<Value name="3">
<Value>PeerProtocolVersion</Value>
</Value>
<Value name="4">
<Value>StorageVersion</Value>
</Value>
<Value name="5">
<Value>MirrorName</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^SYS.DataCheck.SystemD</DataLocation>
<DefaultData>SystemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.DataCheck.SystemD</IdLocation>
<IndexLocation>^SYS.DataCheck.SystemI</IndexLocation>
<StreamLocation>^SYS.DataCheck.SystemS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
