/// This class is for InterSystems internal use.
/// Helper methods for %Net.Remote classes.
Class %Net.Remote.Utility Extends %RegisteredObject [ System = 4 ]
{

/// This query returns all classes found inside pFilename (passed to Execute() as the 1st argument).
/// Must also pass the name/IP of the server (2nd argument) and port (3rd argument) of a running Object Gateway Server.
Query GetAllClasses(pFilename As %String, pServer As %String, pPort As %String) As %Query(ROWSPEC = "Classname:%String")
{
}

ClassMethod GetAllClassesExecute(ByRef qHandle As %Binary, pFilename As %String, pServer As %String, pPort As %String) As %Status
{
	Set tSC = $$$OK
	Kill ^||classes
	Set classes = ""
	Try {
		Set tGateway = ##class(%Net.Remote.Gateway).%New()
		Set tSC = tGateway.%Connect(pServer, pPort, $ZU(5), 5)
		Quit:'tSC
		Set tSC = tGateway.%GetAllClasses(pFilename, .classes)
		Do tGateway.%Disconnect()
		Quit:'tSC
		For i = 1:1:classes.Count() {
			Set ^||classes(i) = classes.GetAt(i)
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Set classes = ""
	Set qHandle = $LB("")
	Quit tSC
}

ClassMethod GetAllClassesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllClassesExecute ]
{
	Set index = $List(qHandle,1)
	Set index = $O(^||classes(index))
	If index="" {
		Set Row = ""
		Set AtEnd = 1
	}
	Else {
		Set Row = $LB(^||classes(index))
	}
	Set qHandle = $LB(index)
	Quit $$$OK
}

ClassMethod GetAllClassesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllClassesExecute ]
{
	Set qHandle = ""
	Kill ^||classes
	Quit $$$OK
}

/// Run a command using a CPIPE device.
/// The first unused CPIPE device is allocated and returned in pDevice.  Upon exit the device is open; 
/// it is up to the caller to close that device when done with it. <br/>
/// <var>pTimeoutOpen</var> indicates how long to wait for the initial OPEN and <var>pTimeoutRead</var> indicates how long to wait between reading the output chunks</var>. <br/>
/// Note that CPIPE (and PIPE) devices are supported on Unix and Windows, but not on VMS.  If this method is invoked
/// on an instance installed on VMS, execution flow will be diverted to method <method>RunCommandViaZF</method>
/// which uses a different technique.
ClassMethod RunCommandViaCPIPE(pCmd As %String, Output pDevice As %String, Output pOutput As %String, pTimeoutOpen As %Integer = 10, pTimeoutRead As %Integer = 5, ByRef pCmdArgs) As %Status
{
	If $system.Version.GetBuildOS()="VMS" Quit ..RunCommandViaZF($G(pCmd), .pDevice, .pOutput, pTimeoutOpen, 1, .pRetCode, .pCmdArgs)

	Set tSC = $$$OK
	Set pOutput = ""
	Set IO = $IO
	Set ZEOFMode = $ZU(68,40,1)
	Set pDevice = "|CPIPE|"
	
	Try {
		Set p = ##class(%SYS.ProcessQuery).Open($J)
		Set od = ","_p.OpenDevices_","
		For x = "",1:1:100 If od'[(",|CPIPE|"_x_",") Set pDevice = "|CPIPE|"_x Quit
		Set p = ""
	}
	Catch {
	}
	
	Try {
		Open pDevice:(/COMMAND=pCmd:/ARGS=pCmdArgs...:"R"):pTimeoutOpen
		If '$T Set tSC = $$$ERROR($$$CacheError, "Failed to open |CPIPE| device in read mode for command: '"_pCmd_"'") Quit
		Set TooMuch = 0
		Use pDevice
		For {
			// Keep reading through end of input; save only first 32,000 characters
			Set tLine = "" Read tLine:pTimeoutRead
			If '$T { // Exit by timeout
				// reached end of input
				Quit:(tLine=$C(-1))
				
				// read timed out before end of input
				Set tSC = $$$ERROR($$$CacheError, "Read from |CPIPE| device timed out for command: '"_pCmd_"'")
				Quit
			}
			If 'TooMuch {
				Set:pOutput'="" pOutput = pOutput_$C(13,10)
				If $L(pOutput)+$l(tLine)<32000 {
					Set pOutput = pOutput_tLine
				}
				Else {
					Set pOutput = pOutput_$E(tLine,1,32000-$L(pOutput))_" (more...)"
					Set TooMuch = 1
				}
			}
			If ($ZEOF=-1) Quit  // Exit by EOF
		}
	}
	
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	
	If 'ZEOFMode Do $ZU(68,40,0) // Restore ZEOF mode
	Use IO
	
	Quit tSC
}

/// Run a command using $ZF(-100) and an external temporary file to store the command output. <br>
/// If <var>pDeleteTempFile</var> is 0 (false), the temporary file is not deleted; in this case, it is up to the caller to delete it when done with it.
ClassMethod RunCommandViaZF(pCmd As %String, Output pTempFileName As %String, Output pOutput As %String, pOpenTimeout As %Integer = 5, pDeleteTempFile As %Boolean = 1, Output pRetCode As %String, ByRef pCmdArgs, pAsynchronous As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Set pOutput = ""
	Set pRetCode = ""
	Set IO = $IO
	Set ZEOFMode = $ZU(68,40,1)
	Set pTempFileName = ""

	Try {
		Set (tFile,pTempFileName) = ##class(%File).TempFilename("txt")
		If tFile="" Set tSC = $$$ERROR($$$CacheError, "Failed to obtain a temporary file name") Quit
		Set cmdFlags = $Select(pAsynchronous:"/ASYNC",1:"") _"/STDOUT="""_tFile_"""/STDERR="""_tFile_""""
		Set pRetCode = $ZF(-100,cmdFlags,pCmd,.pCmdArgs)

		Close tFile Open tFile:("RS"):pOpenTimeout
		If '$T Set tSC = $$$ERROR($$$CacheError, "Failed to open temporary file '"_tFile_"'") Quit
		Set TooMuch = 0
		Use tFile
		For {
			// Keep reading through end of file; save only first 32,000 characters
			Set tLine = "" Read tLine:1
			If '$T && (tLine=$C(-1)) Quit  // Exit by timeout
			If 'TooMuch {
				Set:pOutput'="" pOutput = pOutput_$C(13,10)
				If $L(pOutput)+$l(tLine)<32000 {
					Set pOutput = pOutput_tLine
				}
				Else {
					Set pOutput = pOutput_$E(tLine,1,32000-$L(pOutput))_" (more...)"
					Set TooMuch = 1
				}
			}
			If ($ZEOF=-1) Quit  // Exit by EOF
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}

	Try {
		If pDeleteTempFile {
			Close tFile:"D"
		}
		Else {
			Close tFile
		}
	} Catch (ex) {
		// don't overwrite the error status if it's already populated
		Set:$$$ISOK(tSC) tSC = ex.AsStatus()
	}

	If 'ZEOFMode Do $ZU(68,40,0) // Restore ZEOF mode
	Use IO
	
	Quit tSC
}

/// Check if Gateway is running and optionally if it is responding to PING. <br/>
/// Same as method ##class(%Net.Remote.Service).IsGatewayRunning(pServer, pPort, pVerbose, pPing, pInterface).
ClassMethod CheckGateway(pServer As %String, pPort As %String, pVerbose As %Boolean = 0, pPing As %Boolean = 1, pInterface As %String = "") As %Boolean
{
	Quit ##class(%Net.Remote.Service).IsGatewayRunning($G(pServer), $G(pPort), pVerbose, .tSC, pPing, pInterface)
}

/// Check if the server address or name corresponds to the local machine.
ClassMethod IsServerLocal(pServer As %String) As %Boolean
{
	Set tLocal = 0
	Try {
		If $D(^CacheTemp.Gateway.Server("IsLocal",pServer),tLocal) Quit
		If pServer?1.3n1"."1.3n1"."1.3n1"."1.3n {
			// Normalize
			For i = 1:1:4 Set $P(pServer,".",i) = +$P(pServer,".",i)
		}
		Set tHost = $system.INetInfo.LocalHostName()
		Set tIP = $system.INetInfo.HostNameToAddr(tHost)
		Set tLB = $system.INetInfo.HostNameToAddr("localhost")
		If (pServer="127.0.0.1") || ($ZCVT(pServer,"l")="localhost") || (pServer=tLB) || ($ZCVT(pServer,"l")=$ZCVT(tHost,"l")) {
			Set tLocal = 1
		} Else {
			Set tLocalList=##class(%SYSTEM.INetInfo).GetListOfConfiguredInterfaces()	
			Set tPos = 0
			While $LISTNEXT(tLocalList,tPos,tData) {
				Set tServerIPv4 = $system.INetInfo.HostNameToAddr(pServer,1,0)
				If (tServerIPv4'="")&&((tServerIPv4=$P($LG(tData,2),"/"))||(tServerIPv4=$P($LG(tData,3),"/"))) {Set tLocal = 1  Quit}
			}
		}
		If tLocal Set ^CacheTemp.Gateway.Server("IsLocal",pServer)=tLocal
	}
	Catch {
	}
	Quit tLocal
}

/// Checks for Ensemble-enabled namespace.
ClassMethod IsEnsembleNamespace() As %Boolean
{
	Quit ##class(%Library.EnsembleMgr).IsEnsembleNamespace()
}

}
