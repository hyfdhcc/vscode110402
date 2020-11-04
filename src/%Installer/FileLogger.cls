/// Implements a file based logger for %Installer.
Class %Installer.FileLogger Extends %Installer.AbstractLogger [ System = 3 ]
{

/// IO Device to write to
Property Device As %String(MAXLEN = "");

Method %OnNew(pCaptureIO As %Boolean, pFilename As %String, pMode As %String = "WNS") As %Status [ Internal, ProcedureBlock = 1, ServerOnly = 1 ]
{
	#dim tSC As %Status
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		// Open the requested file
		Open pFilename:pMode
		
		// Remember it!
		Set ..Device = pFilename
		
		// Allow AbstractInstaller to setup for I/O redirection
		Set tSC = ##super(pCaptureIO)
		
	} While (0)
Exit
	Quit tSC
Trap
	Set tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

Method %OnClose() As %Status [ Internal, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Close ..Device
	Quit ##super()
}

/// Log a message to the install log
Method LogEntry(pLevel As %Integer, pTopic As %String, ByRef pArgs)
{
	#dim tIO As %String = $IO
	Set $ZT="Trap"
	Do {
		// Switch to the log device
		If $IO '= ..Device {
			Use ..Device
		}

		// Use the default implementation to write the message out to
		// the current device.
		Do ##super(pLevel, pTopic, .pArgs)
		
	} While (0)
Exit
	// Switch back to the previous device
	If tIO'=$IO {
		Use tIO
	}
	Quit
Trap
	Goto Exit
}

}
