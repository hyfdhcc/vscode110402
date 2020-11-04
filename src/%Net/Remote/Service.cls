Include %occJava

/// This class contains methods to start, monitor and stop an Object Gateway Server for Java or .NET.
Class %Net.Remote.Service Extends %RegisteredObject [ System = 4 ]
{

// --------------- Methods to start a Gateway ---------------

/// Start up the Object Gateway Server whose definition is identified by pName.
/// To supress write of progress messages, pass pVerbose = 0.
ClassMethod StartGateway(pName As %String, pVerbose As %Boolean = 0, Output pOutput As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ..OpenGateway(pName, .pGateway)
		If tSC {
			Lock +^%ISC.ObjectGateway.Management(pName)
			Set tSC = ..StartGatewayObject(pGateway, pVerbose, .pOutput)
			Lock -^%ISC.ObjectGateway.Management(pName)
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

/// Start up the Object Gateway Server whose definition is an object reference variable pGateway.
/// To supress write of progress messages, pass pVerbose = 0.
ClassMethod StartGatewayObject(pGateway As %Net.Remote.ObjectGateway, pVerbose As %Boolean = 0, Output pOutput As %String) As %Status
{
	Set tSC = $$$OK
	Set tDev = $I
	Set pOutput = ""
	
	Try {
		// Set some public variables so we don't need to keep passing them around
		Set %verbose = +pVerbose
		Set %name = pGateway.Name
		Set %type = pGateway.TypeLogicalToDisplay(pGateway.Type)
		Set %ensemble = ##class(%Library.EnsembleMgr).IsEnsembleNamespace()
		
		Do ..Log(1, pGateway, "Starting "_%type_" Gateway Server '"_%name_"'")
		
		Set IsLocal = ##class(%Net.Remote.Utility).IsServerLocal(pGateway.Server)
		
		If '(..IsGatewayRunning(pGateway.Server, pGateway.Port, 0, .tSC2, 0, pGateway.AllowedIPAddresses)) {
			If IsLocal {
				If ($$$isUNIX) && (pGateway.Type=2) {
					Do ..Log(2, pGateway, "Object Gateway Server for .NET can only be started on Windows systems")
				}
				Else {
					Set tSC = ..StopMonitor(%name, pGateway.Port) // In case there is a lurking monitor, this call will take care of it
					Set tSC = ..RunStartCmd(pGateway, .tOutput)
					Set:tOutput'="" pOutput = tOutput
				}
			}
			Else {
				Do ..Log(1, pGateway, "Gateway Server is not local, won't be started by this Service")
			}
			
		}
	}
	
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	
	Try {
		If tSC {
			Do ..UpdateState(pGateway.Port,1)
			Do ..Log(1, pGateway, "Gateway Server successfully started")
			Do ##class(%Net.Remote.Gateway).%RegisterSuperServer(+pGateway.Port, "%SYS")
		}
		Else {
			Do ..LogStatus(tSC, pGateway, "StartGatewayObject")
			Do ..Log(1, pGateway, "An error occurred while trying to start the Gateway Server")
		}
	}
	Catch {
	}
	
	If tSC {
		Try {
			If pGateway.HeartbeatInterval>0 {
				Set tSC = ..StartMonitorObject(pGateway, pVerbose)
			}
			Else {
				// Do ..Log(1, pGateway, "Gateway Server not configured to be monitored (HeartbeatInterval='"_pGateway.HeartbeatInterval_"')")
				If 'IsLocal {
					// Not local and not set to be monitored
					Set tSC = $$$ERROR($$$GeneralError, "Nothing to do, please check the Gateway Server definition!")
				}
			}
		}
		Catch {
		}
	}
	
    Use:tDev'="" tDev
	Quit tSC
}

/// Run command to start the Gateway Server.
ClassMethod RunStartCmd(pGateway As %Net.Remote.ObjectGateway, Output pOutput As %String) As %Status
{
	Set tSC = $$$OK
	Set pOutput = ""
	
	Try {
		Set tCmd = ""
		If pGateway.Type=1 {
			Set tSC = ..CmdLineForJava(pGateway, .tCmd, .tCmdArgs, .tPredictedCmdStr)
		}
		ElseIf pGateway.Type=2 {
			Set tSC = ..CmdLineForDotNet(pGateway, .tCmd, .tCmdArgs, .tPredictedCmdStr)
		}
		Else  {
			Set tSC = $$$ERROR($$$GeneralError, "Unknown Object Gateway type '"_pGateway.Type_"'")
		}
		If tCmd="" Set tSC = $$$ERROR($$$GeneralError, "Command to start Gateway couldn't be identified, check if property Type is properly set")
		If 'tSC Do ..LogStatus(tSC, pGateway, "RunStartCmd") Quit
		
		Do ..Log(1, pGateway, "Executing O.S. command: "_$Get(tPredictedCmdStr))
		
		// Start the Object Gateway server
		Set tSC = ##class(%Net.Remote.Utility).RunCommandViaCPIPE(tCmd,.pDevice,.tOutput,pGateway.InitializationTimeout,1,.tCmdArgs)
		Close pDevice:"I"
		Do:$$$ISERR(tSC) ..LogStatus(tSC, pGateway, "RunStartCmd")
		Do ..Log(1, pGateway, "Execution returned: '"_tOutput_"'")
		Set pOutput = tOutput

		If (pGateway.Type=1) && (tOutput="nohup: ignoring input") {
			Set tOutput = ""
		}
		If (pGateway.Type=1) && (tOutput'="") {
			// The only output we get from Java would be errors
			Set tSC = $$$ERROR($$$GeneralError, "There were errors returned when trying to start the Java Gateway")
		}
		
		If (pGateway.Type=2) && (tOutput'?1"Listening on ".e) {
			// Warning to check output text from .NET Gateway Server
			Do ..Log(2, pGateway, "Unexpected contents returned from .NET Gateway Server, please check")
		}
	} Catch (ex) {
		// don't overwrite the error status if it's already populated
		Set:$$$ISOK(tSC) tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Assemble the command to start the Object Gateway Server for .NET based on the settings.
ClassMethod CmdLineForDotNet(pGateway As %Net.Remote.ObjectGateway, Output pCmd As %String, Output pCmdArgs, Output pPredictedCmdStr As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set pCmd = ""
	Set pPredictedCmdStr = ""

	Try {
		// .NET executable command
		Set tPath = pGateway.FilePath
		Set tExec = "DotNetGatewaySS"
		If ($system.Version.Is64Bits()) && (pGateway.Exec64) {
			Set tExec = tExec_"64"
		}
		Set tVersion = pGateway.DotNetVersion
		If (tVersion?.1"v"1"4.0.".n) || ( tVersion="4") || (tVersion="4.0") || (tVersion="v4.0") Set tDir = "v4.0.30319"
		Else  Set tDir = "v2.0.50727" // Default
		Set:$G(tPath)="" tPath = $system.Util.InstallDirectory()_"\dev\dotnet\bin\"_tDir
		Set pCmd = ##class(%File).NormalizeFilename(tPath_"\"_tExec)
		If '##class(%File).Exists(pCmd_".exe") Set tSC = $$$ERROR($$$GeneralError, ".NET Gateway Server executable not found at '"_pCmd_".exe'") Quit

		// build the command arguments
		Set pCmdArgs = ""
		
		Set pCmdArgs($increment(pCmdArgs)) = +pGateway.Port

		#dim tBindToAddr As %String = pGateway.AllowedIPAddresses
		If tBindToAddr="" Set tBindToAddr = "127.0.0.1"
		Set pCmdArgs($increment(pCmdArgs)) = tBindToAddr

		Set pCmdArgs($increment(pCmdArgs)) = pGateway.LogFile
		
		// build the predicted command string (for displaying in logs, etc.)
		Set pPredictedCmdStr = pCmd
		For ctr=1:1:pCmdArgs {
			Set cmdArg = pCmdArgs(ctr)
			Set:(cmdArg[" ")||(cmdArg="") cmdArg = $char(34)_cmdArg_$char(34)
			Set pPredictedCmdStr = pPredictedCmdStr_" "_cmdArg
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}	
	
	Quit tSC
}

/// Assemble the command to start the Object Gateway Server for Java based on the settings.
ClassMethod CmdLineForJava(pGateway As %Net.Remote.ObjectGateway, Output pCmd As %String, Output pCmdArgs, Output pPredictedCmdStr As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set pCmd = ""
	Set pPredictedCmdStr = ""

	Try {
		// Get Java executable command relative to JAVA_HOME
		Set tSC = ..GetJavaExecutableCommand(pGateway.JavaHome,.javaExecutable,0)
		Quit:$$$ISERR(tSC)
		Set pCmd = javaExecutable

		// build the command arguments
		Set pCmdArgs = ""

		// Add -Xrs to ignore OS signals and not shutdown when the user logs off
		Set pCmdArgs($increment(pCmdArgs)) = "-Xrs"

		// Add any user supplied JVM arguments
		If (pGateway.JVMArgs '= "") {
			Set jvmArgs = $listfromstring(pGateway.JVMArgs," ")

			If $listlength(jvmArgs)>0 {
				// if any substring doesn't start with a single dash, then tack it on to the previous one
				Set jvmArgsDash = $listbuild($list(jvmArgs,1))
				For ctr=2:1:$listlength(jvmArgs) {
					Set arg = $list(jvmArgs,ctr)
					If $Extract(arg,1,1)'="-" {
						Set $list(jvmArgsDash,$listlength(jvmArgsDash)) = $list(jvmArgsDash,$listlength(jvmArgsDash))_" "_arg
					} Else {
						Set jvmArgsDash = jvmArgsDash_$listbuild(arg)
					}
				}
				Set jvmArgs = jvmArgsDash
				
				// if any substring contains an odd number of un-escaped double quotes, then keep appending to it until find the pair
				Set jvmArgsQuote = ""
				For ctr=1:1:$listlength(jvmArgs) {
					Set arg = $list(jvmArgs,ctr)
					
					Set unescapedQuotesFound = 0
					Set currentSearchIndex = 1
					While currentSearchIndex<($length(arg)+2) {
						Set indexAfterQuote = $find(arg,"""",currentSearchIndex)
						Quit:(indexAfterQuote=0) // no more double quotes found

						Set isEscaped = (indexAfterQuote>2)&&($extract(arg,indexAfterQuote-2,indexAfterQuote-2)="\")
						Set:'isEscaped unescapedQuotesFound = unescapedQuotesFound+1
						Set currentSearchIndex = indexAfterQuote
					}
					
					If (unescapedQuotesFound#2=0) { // even number of double quotes found
						Set jvmArgsQuote = jvmArgsQuote_$listbuild(arg)
					} Else { // odd number of double quotes found
						If (ctr=$listlength(jvmArgs)) { // end of list, just add to command line as is (should maybe throw an error here?)
							Set jvmArgsQuote = jvmArgsQuote_$listbuild(arg)
						} Else { // append to next list item
							Set $list(jvmArgs,ctr+1)=arg_" "_$list(jvmArgs,ctr+1)
						}
					}
				}
				Set jvmArgs = jvmArgsQuote
				
				For ctr=1:1:$listlength(jvmArgs) {
					Set cmdArg = $list(jvmArgs,ctr)
					Set pCmdArgs($increment(pCmdArgs)) = $list(jvmArgs,ctr)
				}
			}
		}

		// Get the required classpath (gateway + JDBC [+ util] JARs)
		Set tJDK = pGateway.JDKVersion
		If (tJDK="") && (pGateway.Name'="JDBC_Default") {
			Set tJDK = "JDK17" // Default JDK if none specified, except for JDBC where we use the files in the lib subdirectory
		}
		Set tSC = ..GetRequiredClassPath(pGateway.JavaHome,pGateway.MainClassName,tJDK,.requiredClassPath)
		Quit:$$$ISERR(tSC)

		// Build classpath argument
		// We assume that the user has properly quoted the class path and supplied correct class path separators.
		Set tCPSep = $Select($$$isWINDOWS:";", 1:":")
		Set tClassPath = pGateway.ClassPath_$Case(pGateway.ClassPath,"":"",:tCPSep)_requiredClassPath

		// Add the classpath (user supplied and default)
		Set pCmdArgs($increment(pCmdArgs)) = "-classpath"
		Set pCmdArgs($increment(pCmdArgs)) = tClassPath

		// Add the Gateway Server class name
		Set pCmdArgs($increment(pCmdArgs)) = pGateway.MainClassName

		Set pCmdArgs($increment(pCmdArgs)) = +pGateway.Port
		
		Set pCmdArgs($increment(pCmdArgs)) = pGateway.LogFile
		
		// build the predicted command string (for displaying in logs, etc.)
		Set pPredictedCmdStr = pCmd
		For ctr=1:1:pCmdArgs {
			Set cmdArg = pCmdArgs(ctr)
			Set:(cmdArg[" ")||(cmdArg="") cmdArg = $char(34)_cmdArg_$char(34)
			Set pPredictedCmdStr = pPredictedCmdStr_" "_cmdArg
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	
	Quit tSC
}

// --------------- Methods to stop a Gateway ---------------

/// Stop the Object Gateway Server whose definition is identified by pName.
/// To supress write of progress messages, pass pVerbose = 0.
ClassMethod StopGateway(pName As %String, pVerbose As %Boolean = 0, pStopMonitor As %Boolean = 1) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ..OpenGateway(pName, .pGateway)
		If tSC Set tSC = ..StopGatewayObject(pGateway, pVerbose, pStopMonitor)
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

/// Stop the Object Gateway Server whose definition is an object reference variable pGateway.
/// To supress write of progress messages, pass pVerbose = 0.
ClassMethod StopGatewayObject(pGateway As %Net.Remote.ObjectGateway, pVerbose As %Boolean = 0, pStopMonitor As %Boolean = 1) As %Status
{
	Set tSC = $$$OK
	Set tDev = $I
	
	Try {
		// Set some public variables so we don't need to keep passing them around
		Set %verbose = +pVerbose
		Set %name = pGateway.Name
		Set %type = pGateway.TypeLogicalToDisplay(pGateway.Type)
		Set %ensemble = ##class(%Library.EnsembleMgr).IsEnsembleNamespace()
		
		Do ..Log(1, pGateway, "Stopping "_%type_" Gateway Server '"_%name_"'")
		
		If pStopMonitor {
			Set tSC = ..StopMonitor(%name, pGateway.Port)
			If ('tSC) && (pGateway.HeartbeatInterval>0) Do ..LogStatus(tSC, pGateway, "StopMonitor")
		}
		
		If ##class(%Net.Remote.Utility).IsServerLocal(pGateway.Server) {
			If $$$isVMS {
				// VMS (not supported)
				Do ..Log(1, pGateway, "This Service cannot stop a Gateway on VMS systems")
			}
			Else {
				// Windows or Unix
				Do ..Log(1, pGateway, "Shutting down the Gateway Server")
				Set tSC = ..ShutdownGateway(pGateway)
			}
		}
		Else {
			Do ..Log(1, pGateway, "Gateway Server is not local, won't be stopped by this Service")
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	
	If tSC {
		Do ..UpdateState(pGateway.Port,0)
		Do ..Log(1, pGateway, "Gateway Server stopped")
	}
	Else {
		Do ..LogStatus(tSC, pGateway, "StopGatewayObject")
		Do ..Log(1, pGateway, "An error occurred while trying to stop the Gateway Server")
	}
	
	Use:tDev'="" tDev
	Quit tSC
}

/// Shutdown the Gateway Server.
ClassMethod ShutdownGateway(pGateway As %Net.Remote.ObjectGateway) As %Status
{
	Set tSC = $$$OK
	Set tDev = $I
	Try {
		Close "|TCP|"_+pGateway.Port
		Set tGatewayConn = ""
		Set tSC = ..ConnectGateway(pGateway, .tGatewayConn, "", 0)
		If tSC {
			Do ..Log(1, pGateway, "Shutting down "_%type_" Gateway Server '"_%name_"'")
			Set tSC = tGatewayConn.%Shutdown()
			Do ..LogStatus(tSC, pGateway, "%Shutdown")
			Set tGatewayConn.Closed = 1
		}
		Else {
			Do ..Log(3, pGateway, "Connection failed, check if Gateway Server is active: "_$system.Status.GetOneErrorText(tSC))
		}
		Do ##class(%Net.Remote.Gateway).%DeregisterSuperServer(+pGateway.Port, "%SYS")
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Use:tDev'="" tDev
	Quit tSC
}

// --------------- Methods to monitor a Gateway ---------------

/// Start a monitor process for the Object Gateway Server whose definition is identified by pName, 
/// if the Gateway is configured to be monitored (HeartbeatInterval greater than 0).
/// To supress write of progress messages, pass pVerbose = 0.
ClassMethod StartMonitor(pName As %String, pVerbose As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ..OpenGateway(pName, .pGateway)
		If tSC Set tSC = ..StartMonitorObject(pGateway, pVerbose)
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

/// Monitor the Object Gateway Server whose definition is an object reference variable pGateway. 
/// If the Gateway Server has HeartbeatInterval set to a value greater than 0, then job off a background process 
/// to monitor the Gateway Server, otherwise just exit.
ClassMethod StartMonitorObject(pGateway As %Net.Remote.ObjectGateway, pVerbose As %Boolean = 0)
{
	Set tSC = $$$OK
	Try {
		Set tNamespace = $ZU(5)
		Set HeartbeatInterval = pGateway.HeartbeatInterval
		If HeartbeatInterval>0 {
			Set:'$D(%verbose) %verbose = +pVerbose
			Set:'$D(%name) %name = pGateway.Name
			Set:'$D(%type) %type = pGateway.TypeLogicalToDisplay(pGateway.Type)
			Set:'$D(%ensemble) %ensemble = ##class(%Library.EnsembleMgr).IsEnsembleNamespace()
			Do ..Log(1, pGateway, "Starting background process to monitor the Gateway Server")
			Do:tNamespace'="%SYS" $ZU(5,"%SYS")
			Job StartGatewayMonitor^STU(%name, pGateway.Type, $G(%type), pGateway.Server, pGateway.Port, pGateway.ConnectionTimeout, HeartbeatInterval, pGateway.HeartbeatFailureTimeout, pGateway.HeartbeatFailureAction, pGateway.HeartbeatFailureRetry)::10
			Set tJobOK = $Test
			Do:tNamespace'="%SYS" $ZU(5,tNamespace)
			If tJobOK Do ..Log(1, pGateway, "Job command successful, started monitor process '"_$ZChild_"'")
			Else  Do ..Log(3, pGateway, "Monitor process could not be started")
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, $ZE)
		}
	}
	Catch {
		Do:tNamespace'="%SYS" $ZU(5,tNamespace)
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

/// The Gateway Server is monitored with PING requests, according to the time interval specified by HeartbeatInterval.
/// Hourly, a record of type "Info" is logged.
ClassMethod GatewayMonitor(Name As %String, Type As %String, TypeExt As %String, Server As %String, Port As %String, Timeout As %String, HeartbeatInterval As %String, HeartbeatFailureTimeout As %String, HeartbeatFailureAction As %String, HeartbeatFailureRetry As %String)
{
	Set Port = +Port
	Set Timeout = +$G(Timeout) Set:Timeout<2 Timeout = 5
	Do ..Log(1, "", "Process '"_$Job_"' monitoring Gateway Server '"_Name_"' on port '"_Port_"'")
	Set ^CacheTemp.Gateway.Monitor(Port) = $ZDT($H,3)
	Set ^CacheTemp.Gateway.Monitor(Port,"Name") = Name
	Set ^CacheTemp.Gateway.Monitor(Port,"Job") = $Job
	Set %name = Name
	Set %type = TypeExt
	Do ..Log(1, "", "Initializing monitor process '"_$Job_"'")
	
	// Adjust heartbeat interval
	If HeartbeatInterval<5 {
		Set HeartbeatInterval = 5
		Do ..Log(0, "", "HeartbeatInterval adjusted to minimum value of 5 seconds")
	}
	ElseIf HeartbeatInterval>3600 {
		Set HeartbeatInterval = 3600
		Do ..Log(0, "", "HeartbeatInterval adjusted to maximum value of 3600 seconds")
	}
	
	Set HeartbeatFailureStart = 0 // To keep track of the elapsed failure time for the heartbeat feature
	Set HeartbeatGraceStart = 0 // To keep track of the grace time after failure before restoring the heartbeat
	Set (LastLog,LastPurge) = $ZH
	
	Try {
		// Open and use TCP device
		Set tDevice = "|TCP|"_Port
		Close tDevice
		Open tDevice:(Server:Port:"AdS"::::5):(Timeout+10) // Additional time to startup
		If '$T {
			Do ..Log(3, "", "Connection cannot be established")
			Set tSC = $$$ERROR($$$RemoteGatewayError,"Connection cannot be established")
			Quit
		}
		Use tDevice:(::"-d"::32767:32767)
		Do ..Log(1, "", "Connection established")
		
		Set tStop = 0
		Do {
			/* We are signalled to stop by StopMonitor() */
			Set tWaitMessage = $SYSTEM.Event.Wait("",HeartbeatInterval)			
			If tWaitMessage {
				Set tGatewayObj = ##class(%Net.Remote.Gateway).%New() 
				Set tGatewayObj.GatewayDevice = tDevice
				Set tGatewayObj.Closed = 0
				Do tGatewayObj.%Disconnect()
				Set tStop = 1
				Quit
			}
			
			If HeartbeatGraceStart>0 {
				If ($ZH-HeartbeatGraceStart)<HeartbeatFailureRetry Continue  // Grace period, keep waiting
				Set HeartbeatGraceStart = 0
				Set HeartbeatFailureStart = 0
			}
			
			Set s = ..PingGateway(Port, Server, Timeout, 1) // Reuse socket
			If s {
				// Succeeded; reset failure track time
				Set State = 1
				Set HeartbeatFailureStart = 0
			}
			Else {
				// Failed; check if failure timeout was reached
				Do ..Log(2, "", "Gateway Server did not respond to PING request in "_Timeout_" seconds - "_$system.Status.GetOneStatusText(s))
				Set State = 0
				Set t = $ZH
				If 'HeartbeatFailureStart {
					Set HeartbeatFailureStart = t
				}
				If (t-HeartbeatFailureStart)>HeartbeatFailureTimeout {
					// Handle the Gateway failure
					Do ..Log(3, "", "Gateway Server failure timeout on "_Server_$S(Server[":":"|",1:":")_Port)
					If HeartbeatFailureAction["A" {
						// Ensemble Alert!
					}
					If HeartbeatFailureAction["R" {
						// Stop the gateway just in case, ignoring errors
						Set tSC = ..StopGateway(Name, 0, 0) // Do not try to stop monitor, will exit on its own
						// Restart the gateway
						Do ..Log(1, "", "Restarting the Gateway Server")
						Set tSC = ..StartGateway(Name, 0)
						If tSC {
							Set tStop = 1
							Quit  // Monitor will exit; a new monitor is being started!
						}
						Else  {
							Do ..Log(3, "", "Failed to restart the Gateway Server")
							Do ..Log($system.Status.GetOneErrorText(tSC))
						}
					}
					If HeartbeatFailureRetry>HeartbeatInterval {
						// Observe grace time HeartbeatFailureRetry
						Set HeartbeatGraceStart = $ZH
					}
				}
			}
					
			If $ZH-LastLog>=3600 {
				Set LastLog = $ZH
				Do ..Log(1, "", "Monitor job active - Gateway Server is "_$Case(State, 1:"running", 0:"unresponsive", :"?"))
				If $ZH-LastPurge>=86400 {
					Set LastPurge = $ZH
					Set tSC = ##class(%Net.Remote.ActivityLog).Purge(7, .n)
					If tSC {
						Do ..Log(1, "", "Monitor process automatic purge - OK, deleted "_$G(n)_" entries")
					}
					Else  {
						Do ..Log(3, "", "Monitor process encountered error during automatic purge: "_$system.Status.GetOneErrorText(tSC))
					}
				}
			}
		} While ('tStop)
	}
	
	Catch {
		Do BACK^%ETN
		Do ..Log(3, "", "Monitor process '"_$Job_"': "_$ZE)
	}
	
	Do ..Log(1, "", "Monitor process '"_$Job_"' exited")
	Quit
}

/// "Ping" the Gateway server to check if it is alive.
/// If <var>pReuseSocket</var> is true (the default is false), it will try to reuse the TCP device and in case
/// the TCP connection has become invalid it will reconnect.
ClassMethod PingGateway(pPort As %String, pAddress As %String = "127.0.0.1", pTimeout As %Integer = 5, pReuseSocket As %Boolean = 0) As %Status
{
	If '$G(pPort) Quit $$$ERROR($$$GeneralError, "Invalid or missing Gateway port '"_$G(pPort)_"'")
	Set pPort = +pPort
	Set tSC = $$$OK
	Set tDev = $I
    Try {
	    If pReuseSocket {
		    // Check port status and reconnect if needed
		    Set tDevice = "|TCP|"_pPort
			Use tDevice
			If '$ZU(189) {
				Do ..Log(1, "", "Binding TCP socket...")
				Close tDevice
				Open tDevice:(pAddress:pPort:"AdS"::::5):pTimeout
				If '$T {
					Do ..Log(3, "", "Connection cannot be established")
					Set tSC = $$$ERROR($$$RemoteGatewayError,"Connection cannot be established")
					Quit
				}
				Use tDevice:(::"-d"::32767:32767)
				Do ..Log(1, "", "Connection established")
			}
	    }
        If tSC Set tSC = ##class(%Net.Remote.Gateway).%Ping(pAddress, pPort, pTimeout, pReuseSocket)
    }
    Catch {
	    Set tSC = $$$ERROR($$$GeneralError, $ZE)
    }
    Try { Use:tDev'="" tDev } Catch { }
	Quit tSC
}

/// Terminate process currently monitoring a Gateway Server.
ClassMethod StopMonitor(pName As %String, pPort As %String) As %Status
{
	Set tSC = ..CheckMonitor($G(pName), $G(pPort), .pJob)
	If 'tSC Quit tSC
	
	Set pPort = +pPort
	Set tSC = $$$OK
	Try {
		Do ..Log(1, "", "Stopping process '"_pJob_"' that is monitoring the Gateway Server '"_pName_"' on port '"_pPort_"'")
		Set c = $SYSTEM.Event.Signal(pJob)
		If c=1 {
			Kill ^CacheTemp.Gateway.Monitor(pPort)
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Monitor process '"_pJob_"' failed to respond to the Event Signal to stop with code '"_c_"'")
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

/// Check if Gateway is being monitored and return the monitor job number.
ClassMethod CheckMonitor(pName As %String, pPort As %String, Output pJob As %String) As %Status
{
	If $G(pName)="" Quit $$$ERROR($$$GeneralError, "Gateway name is required")
	If '$G(pPort) Quit $$$ERROR($$$GeneralError, "Invalid or missing Gateway port '"_pPort_"'")
	Set pPort = +pPort
	Set pJob = ""
	Set tSC = $$$OK
	Try {
		// Check if it's the right Gateway name
		If $G(^CacheTemp.Gateway.Monitor(pPort,"Name"))=pName {
			Set job = $G(^CacheTemp.Gateway.Monitor(pPort,"Job"))
			// Check if it's the right process
			If job && $D(^$JOB(job)) {
				Set p = ##class(%SYS.ProcessQuery).Open(job)
				If p.Routine?1"%Net.Remote.Service".e {
					Set pJob = job
				}
				Set p = ""
			}
		}
		If pJob="" {
			Set tSC = $$$ERROR($$$GeneralError, "Can't find the job that is monitoring Gateway '"_pName_"'")
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

// --------------- Methods to connect to a Gateway ---------------

/// Connect or reconnect to a running Object Gateway Server. <br/>
/// When <var>pStartOnDemand</var> is true (which is the default), the Gateway will be started if it is not running. <br/>
ClassMethod ConnectGateway(pGateway As %Net.Remote.ObjectGateway, ByRef pGatewayConn As %Net.Remote.Gateway, pAdditionalPaths As %String = "", pStartOnDemand As %Boolean = 1) As %Status
{
	Set tSC = $$$OK
	Set tDev = $I

	Try {
		If ($G(pGatewayConn)="") || '(pGatewayConn.%IsA("%Net.Remote.Gateway")) {
			Set pGatewayConn = ##class(%Net.Remote.Gateway).%New()
			If '$IsObject(pGatewayConn) Set tSC = %objlasterror Quit
		}
	
		Set tPort = +pGateway.Port
		If 'tPort Set tSC = $$$ERROR($$$GeneralError, "Invalid or missing Gateway port '"_tPort_"'") Quit
		Set tServer = pGateway.Server
		If tServer="" Set tServer = "127.0.0.1"
		Set tTime = pGateway.ConnectionTimeout

		// Convert pAdditionalPaths to %ListOfDataTypes if not null
		If pAdditionalPaths="" {
			Set tPath = ""
		}
		Else {
			Set tPath=##class(%ListOfDataTypes).%New()
			For i = 1:1:$L(pAdditionalPaths,",") {
				Do tPath.Insert($P(pAdditionalPaths,",",i))
			}
		}

		// Start Gateway if not running
		If pStartOnDemand {
			Lock +^%ISC.ObjectGateway.Management(pGateway.Name)
			Try {
				If pGateway.Type=2 {
					Set tInterface = pGateway.AllowedIPAddresses
				}
				Else {
					Set tInterface = ""
				}
				If '(..IsGatewayRunning(tServer, tPort, 0, .tSC, 0, tInterface)) {
					Set tSC = ..StartGatewayObject(pGateway)
				}
			}
			Catch {
				Set tSC = $$$ERROR($$$GeneralError, $ZE)
			}
			Lock -^%ISC.ObjectGateway.Management(pGateway.Name)
			If $$$ISERR(tSC) Quit
		}

		Do ..Log(1, pGateway, "Invoking %Connect with Server='"_tServer_"', Port='"_tPort_"', Namespace='"_$Namespace_"', Timeout='"_tTime_"', AdditionalPaths='"_pAdditionalPaths_"'")
		Set tSC = pGatewayConn.%Connect(tServer, tPort, $Namespace, tTime, tPath)
		If 'tSC Do ..Log("Error in %Connect: "_$system.Status.GetOneErrorText(tSC))
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}

	If $$$ISERR(tSC) && $IsObject(pGatewayConn) {
		Do pGatewayConn.%Disconnect()
		Set pGatewayConn = $$$NULLOREF
	}
	
	Use:tDev'="" tDev
	Quit tSC
}

// --------------- Helper methods ---------------

/// Get the Gateway definition object for a given Gateway name.
ClassMethod OpenGateway(pName As %String, Output pGateway As %Net.Remote.ObjectGateway) As %Status
{
	Set tSC = $$$OK
	Set pGateway = ""
	Try {
		Set tID = ""
		&sql( SELECT %ID INTO :tID FROM ObjectGateway WHERE Name=:pName )
		If ('SQLCODE) && (tID'="") {
			Set pGateway = ##class(ObjectGateway).%OpenId(tID)
		}
		If '$IsObject(pGateway) Set tSC = $$$ERROR($$$GeneralError, "Can't open Gateway definition for name '"_$G(pName)_"' (SQLCODE="_$G(SQLCODE)_")") Quit
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Quit tSC
}

/// Return true if Gateway is running, based on the status of the TCP port, and responsiveness to PING; or false otherwise. <br/>
/// If parameter <var>pPing</var> is false, then only the status of the TCP connection is checked.  The default is true.  <br/>
/// Parameter <var>pInterface</var> is the network interface to bind to.  The defaul is null, that is, bind to all local interfaces. <br/>
/// If the Gateway is not running, parameter <var>pSC</var> will contain a status code with more details.
ClassMethod IsGatewayRunning(pServer As %String = "127.0.0.1", pPort As %String, pVerbose As %Boolean = 0, Output pSC As %Status, pPing As %Boolean = 1, pInterface As %String = "") As %Boolean
{
	If '$G(pPort) || ($G(pPort)>65535) {
		If pVerbose { Write !,"Invalid port number: '"_$G(pPort)_"'" }
		Set pSC = $$$ERROR($$$GeneralError, "Invalid port number: '"_$G(pPort)_"'")
		Return 0
	}

	Set pSC = $$$OK
	Set tIO = $IO
	Set tDevice = "|TCP|"_+pPort

	Try {
		Set tIsServerLocal = ##class(%Net.Remote.Utility).IsServerLocal(pServer)
		If tIsServerLocal {
			If pVerbose { Write !,"Checking if TCP port '",pPort,"' is in use" }
			Close tDevice
			If $$$isWINDOWS {
				Open tDevice:(:pPort:/BINDTO=pInterface):0
				Set tTest = $T
				If tTest,(pInterface ="") {
					Close tDevice
					Set pInterface = $SYSTEM.INetInfo.HostNameToAddr(pServer,1,0)
					Open tDevice:(:pPort:/BINDTO=pInterface):0
					Set tTest = $T
				}
			}
			Else {
				Open tDevice:(pServer:pPort:/BINDTO=pInterface):0
				Set tTest = '$T
			}
			If tTest {
				Set pSC = $$$ERROR($$$GeneralError, "TCP port is not in use")
				Quit
			}
		}
		If pPing {
			If pVerbose {
				Write !,"Sending PING request to server '"_pServer_"', port '"_pPort_"'"
			}
		    Set time = $S(tIsServerLocal:5,1:10)
	  		If $$$isWINDOWS {
	 			Close tDevice
	        	Set pSC = ##class(%Net.Remote.Gateway).%Ping(pServer, pPort, time, 0)
			}
			Else {
	       		Set pSC = ##class(%Net.Remote.Gateway).%Ping(pServer, pPort, time, 1)
			}
	        If $$$ISERR(pSC) && pVerbose {
		        Write !,"PING failed"
	        }
		}
    }
    Catch ex {
	    Set pSC = ex.AsStatus()
    }

	Close tDevice
	Use:tIO'="" tIO

	If $$$ISOK(pSC) {
	    If pVerbose { Write !,"Gateway responded successfully" }
	    Quit 1
    }
    Else {
	    If pVerbose { Write !,"Gateway not running and/or not responding - ",$system.Status.GetOneErrorText(pSC) }
	    Quit 0
    }
}

/// Update local Gateway state
ClassMethod UpdateState(pPort As %String, pIsRunning As %Boolean) [ Internal ]
{
	If ('$G(pPort)="") || ($G(pIsRunning)="") Quit
	Set pPort = +pPort
	If pIsRunning {
		Set ^CacheTemp.Gateway.State(pPort) = $ZDT($H,3)
	}
	Else {
		Kill ^CacheTemp.Gateway.State(pPort)
	}
	Quit
}

/// Add the status expressed in variable 's' to the activity log as either "Info" or "Error".
ClassMethod LogStatus(s As %Status, pGateway As %Net.Remote.Gateway, pSource As %String) [ Internal ]
{
	Do ..Log($S(s:1,1:3), pGateway, $S($G(pSource)'="":"Return from "_pSource_": ",1:"")_$system.Status.GetOneErrorText(s))
	Quit
}

/// Add the text message expressed in variable pMsg to the activity log as type pRecordType, with
/// information about the Gateway that originated the message.
/// If %verbose=1, also write it to the current device.
/// If %ensemble=1, also log it in the Ensemble Event Log.
ClassMethod Log(pRecordType, pGateway As %Net.Remote.Gateway, pText As %String) [ Internal ]
{
	If $G(pText)="" Quit
	
	Try {
		Set Name = $G(%name)
		Set Type = $G(%type)
		If $IsObject(pGateway) {
			Set:Name="" Name = pGateway.Name
			Set:Type="" Type = pGatewayTypeLogicalToDisplay(pGateway.Type)
			Set Server = pGateway.Server
			Set Port = pGateway.Port
		}
		Else {
			Set Server = ""
			Set Port = ""
		}
		Set Now = $ZDT($H,3)
		Set Job = $J
		Set pRecordType = +$G(pRecordType) // 0=Debug/Trace, 1=Info, 2=Warning, 3=Error
		Set:pRecordType>3!(pRecordType<0) pRecordType = 0
		If $g(%verbose) {
			Set Tx = $Case(pRecordType,2:"*WARNING* ",3:"*ERROR* ",:"")_pText
			If ($I?1"|TCP|".e) && ($IsObject($G(%response))) {
				Write Now,"&nbsp;&nbsp;",Tx,"<br>"
				Do %response.Flush() Hang 0.1
			}
			Else  {
				Write Now,"  ",Tx,!
			}
		}
		
		If $g(%ensemble) {
			Try {
				// TO DO: Insert into Ensemble Event Log -- if in a running production?
			}
			Catch {
			}
		}
		
		&sql( INSERT INTO ActivityLog
		(DateTime, RecordType, GatewayName, GatewayType, Server, Port, Text, Job)
		VALUES (:Now, :pRecordType, :Name, :Type, :Server, :Port, :pText, :Job)
		)
	}
	
	Catch {
	}
	
	Quit
}

// --------------- Methods regarding Java version, JAR directory ---------------

ClassMethod GetJavaExecutableCommand(javaHomeDir As %String = "", Output javaExecutable As %String = "", normalizeWithSpaces As %Boolean = 1) As %Status
{
	#dim tSC As %Status = $$$OK

	Try {
		// Build the java executable path
		Set javaExecutable = "java"_$Select($$$isWINDOWS:".exe",$$$isVMS:".exe",1:"")
		If (javaHomeDir'="") {
			Set javaBinDir = ##class(%Library.File).SubDirectoryName(javaHomeDir,"bin")
			Set javaBinDir = javaBinDir_$Select($$$isWINDOWS:"\",$$$isVMS:"",1:"/")
			Set javaExecutable = ##class(%Library.File).NormalizeFilename(javaExecutable,javaBinDir)
		}
		Set:normalizeWithSpaces javaExecutable = ##class(%Library.File).NormalizeFilenameWithSpaces(javaExecutable)
	} Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Returns the numeric part of the Java version string (e.g. 1.8.0.1)
/// Rules of how the complete version string is formatted can be found here:
/// http://www.oracle.com/technetwork/java/javase/versioning-naming-139433.html
ClassMethod GetJavaVersion(javaHomeDir As %String = "", Output version As %String = "") As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tCurrentDevice As %String = $IO
	#dim pOutput As %String = ""

	Try {
		// Build the java executable path
		Set tSC = ..GetJavaExecutableCommand(javaHomeDir,.javaExecutable,0)
		Quit:$$$ISERR(tSC)

		// java -version prints to std err, not std out, so we need to read that output as well
		Set cmdArgs = ""
		Set cmdArgs($increment(cmdArgs)) = "-version"
		Set tSC = ##class(%Net.Remote.Utility).RunCommandViaCPIPE(javaExecutable,.pDevice,.pOutput,12,12,.cmdArgs)
		Close pDevice:"I"
		Quit:$$$ISERR(tSC)

		// Look for pattern : version "1.8.0.1
		// where the double quote may optionally be replaced with a single quote or ommitted
		Set regex = "version\s['""]?(\d+(\.\d+)+)"
		Set pos = $Locate(pOutput,regex,1,,versionWithPrefix)
		
		// Get just the number from the previous pattern : 1.8.0.1
		Set regex = "(\d+(\.\d+)+)"
		Set pos = $Locate($Get(versionWithPrefix),regex,1,,version)

		Set:($Get(version)="") tSC = $$$ERROR($$$GeneralError,"Java not found: "_$Get(pOutput))
	} Catch (ex) {
		Set tSC = ex.AsStatus()
	}

	// Close command pipe, restore original device
	Close:($Get(pDevice)'="") pDevice:"I"
	Use tCurrentDevice
	
	Quit tSC
}

ClassMethod CheckJavaVersionSupported(javaVersion As %String = "") As %Status
{
	#dim tSC As %Status = $$$OK

	// We only care about first two parts of version string (e.g. 1.8.x.x -> 1.8)
	Set part1 = $Piece(javaVersion,".",1)
	Set part2 = $Piece(javaVersion,".",2)
	Quit:(part1="")||(part2="") $$$ERROR($$$GeneralError,"Invalid java version")
	Set javaVersion = part1_"."_part2
	
	// The minimum and maximum supported Java versions are stored as macros
	If (javaVersion<$$$javaMinSupportedVersion)||(javaVersion>$$$javaMaxSupportedVersion) {
		Set tSC = $$$ERROR($$$BadJavaVersion,$$$javaMinSupportedVersion,$$$javaMaxSupportedVersion,javaVersion)
	}
	
	Quit tSC
}

ClassMethod GetJARDirectory(javaVersion As %String, Output JARDir As %String) As %Status
{
	#dim tSC As %Status = $$$OK

	// Check Java version is supported (otherwise there won't be a corresponding directory for its JARs)
	Set tSC = ..CheckJavaVersionSupported(javaVersion)
	Quit:$$$ISERR(tSC) tSC
	
	// We only care about first two parts of version string, without a period (e.g. 1.8.x.x -> 18)
	Set javaVersion = $Piece(javaVersion,".",1)_$Piece(javaVersion,".",2)
	
	// Internal (not third-party) core Cache JARS are in {install directory}/dev/java/lib/JDK{xx}
	// where {xx} is the first two parts of the Java version string, without a period (e.g. JDK17, JDK18)
	Set installDir = $System.Util.InstallDirectory()
	Set JARDir = ##class(%Library.File).SubDirectoryName(installDir,"dev")
	Set JARDir = ##class(%Library.File).SubDirectoryName(JARDir,"java")
	Set JARDir = ##class(%Library.File).SubDirectoryName(JARDir,"lib")
	Set JARDir = ##class(%Library.File).SubDirectoryName(JARDir,"JDK"_javaVersion)
	
	Quit tSC
}

ClassMethod GetRequiredClassPath(javaHomeDir As %String = "", javaMainClassName As %String = {$$$javaGatewayClass}, javaVersion As %String = "", Output requiredClassPath As %String = "") As %Status
{
	#dim tSC As %Status = $$$OK

	// The correct directory for the JARs depends on the version of Java (system default or the one that JAVA_HOME points to)
	Set javaVersion = $extract(javaVersion,4,4)_"."_$extract(javaVersion,5,5)_".x.x"
	If (javaVersion="..x.x") {
		Set tSC = ..GetJavaVersion(javaHomeDir,.javaVersion)
		Quit:$$$ISERR(tSC) tSC
	}
	Set tSC = ..GetJARDirectory(javaVersion,.JARDir)
	Quit:$$$ISERR(tSC) tSC

	// Get paths to Gateway and JDBC JAR paths
	Set gatewayJARPath = ##class(%Library.File).NormalizeFilename($$$javaGatewayJAR,JARDir)
	Set gatewayJARPath = ##class(%Library.File).NormalizeFilenameWithSpaces(gatewayJARPath)
	Set JDBCJARpath = ##class(%Library.File).NormalizeFilename($$$javaJDBCJAR,JARDir)
	Set JDBCJARpath = ##class(%Library.File).NormalizeFilenameWithSpaces(JDBCJARpath)
	
	Set tCPSep = $Select($$$isWINDOWS:";", 1:":")
	Set requiredClassPath = gatewayJARPath_tCPSep_JDBCJARpath
	
	Quit tSC
}

}
