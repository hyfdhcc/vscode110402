Include %syDataCheck

/// Reason codes providing extra information about why the system
/// is in its current state.  Logical values are constants, defined 
/// for convenience in %syDataCheck.mac
/// <li>0 (StateReasonUnknown) - Reason Not Specified</li>
/// <li>1 ($$$StateReasonUserStop) - Stop Requested</li>
/// <li>2 ($$$StateReasonWorkflowStop) - Workflow Stop Phase</li>
/// <li>3 ($$$StateReasonError - Error</li>
/// <li>4 ($$$StateReasonSourceError) - Error on DataCheck Source</li>
/// <li>5 ($$$StateReasonConnectionError - Error Establishing Connection</li>
/// <li>6 ($$$StateReasonNeverStarted) - Never Started
/// <li>7 ($$$StateReasonShutdown) - System Shutdown
/// <li>8 ($$$StateReasonDisconnect) - Disconnect
/// <li>9 ($$$StateReasonBecamePrimary) - Became Primary Mirror Member
/// <li>10 ($$$StateReasonSourcePrimary) - Source is the Primary Mirror Member
/// <li>11 ($$$StateReasonSourceNotPrimary) - Source is not the Primary Mirror Member
/// <li>12 ($$$StateReasonBackupNotActive) - Backup is not Active
/// <p>
/// Reason codes are not provided for all states.  The reason will be $$$ReasonUnknown
/// if a specific reason is not provided.
Class SYS.DataCheck.StateReason Extends %Integer
{

ClassMethod LogicalToDisplay(%val As %Integer) As %String
{
	quit $case(+%val,
	           $$$StateReasonUnknown         : "Reason Not Specified",
	           $$$StateReasonUserStop        : "Stop Requested",
	           $$$StateReasonWorkflowStop    : "Workflow Stop Phase",
	           $$$StateReasonError           : "Error",
	           $$$StateReasonSourceError     : "Error on DataCheck Source",
	           $$$StateReasonConnectionError : "Error Establishing Connection",
	           $$$StateReasonNeverStarted    : "Never Started",
	           $$$StateReasonShutdown        : "System Shutdown",
	           $$$StateReasonDisconnect      : "Disconnect",
	           $$$StateReasonBecamePrimary   : "Became Primary Mirror Member",
	           $$$StateReasonSourcePrimary   : "Source is the Primary Mirror Member",
	           $$$StateReasonSourceNotPrimary: "Source is not the Primary Mirror Member",
	           $$$StateReasonBackupNotActive : "Backup is not Active"
               )
}

ClassMethod DisplayToLogical(%val As %String) As %Integer
{
	quit $case(%val,
	           "Reason Not Specified"          : $$$StateReasonUnknown,
	           "Stop Requested"                : $$$StateReasonUserStop,
	           "Workflow Stop Phase"           : $$$StateReasonWorkflowStop,
	           "Error"                         : $$$StateReasonError,
	           "Error on DataCheck Source"     : $$$StateReasonSourceError,
	           "Error Establishing Connection" : $$$StateReasonConnectionError,
	           "Never Started"                 : $$$StateReasonNeverStarted,
	           "System Shutdown"               : $$$StateReasonShutdown,
	           "Disconnect"                    : $$$StateReasonDisconnect,
	           "Became Primary Mirror Member"  : $$$StateReasonBecamePrimary,
	           "Source is the Primary Mirror Member" : $$$StateReasonSourcePrimary,
	           "Source is not the Primary Mirror Member" : $$$StateReasonSourceNotPrimary,
	           "Backup is not Active"          : $$$StateReasonBackupNotActive
               )
}

}
