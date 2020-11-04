/// This class provides several instance methods which operate on a process instance.<br>
/// Properties/Storage/Queries are inherited from the %SYS.ProcessQuery class. The methods
/// declared here are protected methods which can only be executed on a process if they
/// have write access to the %DB_CACHESYS resource (i.e. can write to the CACHESYS 
/// database.) The process executing this query must be in the %SYS namespace.
Class SYS.Process Extends %SYS.ProcessQuery [ System = 4 ]
{

/// Release ALL locks.<br>
/// Release all locks for the process.
Method ReleaseAllLocks() As %Status
{
}

/// Resume a process.<br>
/// Resumes a process after it had previously been suspended.
Method Resume() As %Status
{
}

/// Suspend a process.<br>
/// Put a process into a wait state so it stops executing code.
Method Suspend() As %Status
{
}

/// Terminate a process.<br>
/// Kills a process by sending it a halt message.<br>
/// If SendError is 1 the killed job will issue a <Escape><</Escape>RESJOB<Escape>></Escape> error 
/// and invoke the ^%ETN utility.
Method Terminate(SendError As %Integer = 0) As %Status
{
}

/// Current size of the process table (number of process slots).
ClassMethod ProcessTableSize() As %Integer
{
}

Storage Process
{
<Type>%Library.CacheSQLStorage</Type>
}

}
