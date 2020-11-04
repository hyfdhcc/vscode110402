/// Used to retrieve information about the current ISCAgent instance on this system (if any)
Class SYS.Agent Extends %RegisteredObject
{

/// Returns true if an instance of the ISCAgent is running on this system, false otherwise
ClassMethod IsRunning() As %Boolean
{
}

/// Returns the version string of the ISCAgent if it is running, an empty string otherwise
ClassMethod GetVersion() As %String
{
}

/// Verifies the ISCAgent is running available on its reported application port
/// Returns $$$OK if the ISCAgent is available and responding to requests, and an
/// error status if not.
ClassMethod VerifyConnection(timeout As %Integer = 10) As %Status
{
}

/// Returns the application port of the ISCAgent if it is running, an empty string otherwise
ClassMethod GetApplicationPort() As %Integer
{
}

/// Returns the application interface adddress of the ISCAgent if it is running, "*" if bound on all ports, and an empty string otherwise
ClassMethod GetApplicationInterface() As %String
{
}

/// Returns true if the mirroring application is enabled, false otherwise
ClassMethod IsMirroringEnabled() As %Boolean
{
}

/// Check for the existence and non-0 size of the candidate file
ClassMethod CheckStatusFile(fileName As %String) As %Boolean [ Private ]
{
}

/// Retrieves the default status file name for this OS
ClassMethod StatusFileName() As %String [ Private ]
{
}

/// Gets the PID on VMS via the QueryAgent script
ClassMethod GetVMSPid() As %String [ Private ]
{
}

/// Retrieve the value of a status file property
ClassMethod StatusFileValue(property As %String) As %String [ Private ]
{
}

}
