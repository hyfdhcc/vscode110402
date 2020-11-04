Include %SYS.DBSRV

Class %Net.Remote.Gateway Extends %RegisteredObject [ System = 3 ]
{

Parameter PROTOCOLVERSION [ Final ] = 0;

/// Messages
Parameter CONNECT [ Final ] = "Y0";

Parameter EXECUTEMETHOD [ Final ] = "Y1";

Parameter GENERATECLASSES [ Final ] = "Y2";

Parameter GETOBJECT [ Final ] = "Y3";

Parameter DISCONNECT [ Final ] = "Y4";

Parameter EXCEPTIONRAISED [ Final ] = "Y5";

Parameter SHUTDOWN [ Final ] = "Y6";

Parameter OBJECTCREATED [ Final ] = "Y9";

Parameter GETAVAILABLECLASSES [ Final ] = "YC";

Parameter SUCCESS [ Final ] = "YY";

Parameter JAVASERVICE [ Final ] = "YK";

Parameter LOADCOSCLASS [ Final ] = "YL";

Parameter ADDTOCURRENTCLASSPATH [ Final ] = "YP";

Parameter PING [ Final ] = "YQ";

Parameter LOADJAVACLASS [ Final ] = "YZ";

Parameter LOADJAVACLASSSYNCH [ Final ] = "YW";

Parameter GETTIMESTAMP [ Final ] = "YT";

Parameter INPUTTIMEOUT = 30;

Property GatewayDevice As %String(TRUNCATE = 1);

Property CurrentDevice As %String(TRUNCATE = 1);

Property Namespace As %String(TRUNCATE = 1);

Property ClosedProxies As list Of %String(TRUNCATE = 1);

Property Proxies As list Of %String(TRUNCATE = 1);

Property Closed As %Boolean;

Property Protocol As %Integer;

Property DBSRVProtocol As %Integer;

Method %OnNew() As %Status
{
	Set ..Closed=1
	Set ..DBSRVProtocol=$$$ProtocolVersion
	Set ..CurrentDevice=$IO
	Quit $$$OK
}

/// Connect and handshake
Method %Connect(host As %String, port As %Integer, namespace As %String = {$ZU(5)}, timeout As %Numeric = 5, additionalClassPaths As %ListOfDataTypes = "", sslConfiguration As %String = "") As %Status [ Final ]
{
	Set status=$$$OK
	Try {
		If $G(host)="" Set host = "127.0.0.1"
		Quit:(..Closed=0)&&(..GatewayDevice'="")
		Set ..GatewayDevice=..%freeTCPDevice(port)
		Set ..Namespace=namespace
		Set ..Protocol=..#PROTOCOLVERSION
		Set ..CurrentDevice=$IO
		Set ..Closed=1
		If (sslConfiguration="") {
			Open ..GatewayDevice:(host:port:"AdS"::::5):timeout
			If '$T Set status=$$$ERROR($$$RemoteGatewayError,"Connection cannot be established") Quit
		} Else {
			s doopen=0
			Try {
				Set tns=$zu(5) zn "%SYS"
				Set srv=##class(Security.SSLConfigs).%OpenId(sslConfiguration) 
				if $T,$d(srv),srv,srv.Type=0 Set doopen=1
				zn tns
			} catch {
				//Namespace error checking for SSLConfig, try anyway
				Set doopen=1
				w "%SYS Namespace access error",!,"If SSLConfig is invalid a write error will occur."
			}
			if doopen=1 {
				w ..GatewayDevice_":("_host_":"_port_":/SSL="_sslConfiguration_"::::5):"_timeout
				Open ..GatewayDevice:(host:port:/SSL=sslConfiguration::::5):timeout
				If '$T Set status=$$$ERROR($$$RemoteGatewayError,"SSL Connection cannot be established") Quit
			} else {
				Set status=$$$ERROR($$$RemoteGatewayError,"SSL Configuration: """_sslConfiguration_""" is invalid, Connection terminated") Quit
			}
		}
		Use ..GatewayDevice:(::"A-dS"::32767:32767)
		Set ..Closed=0
		Set x=$zobjexport(-1,52) // Reset timeout
		// Use new continuation logic
		Set x=$zobjexport(1,31)
		Set x=$zobjexport(..Protocol,18)
		Set x=$zobjexport($zbitget($zversion(0),1),18)
		Set x=$zobjexport($$GetCharset^%SYS.NLS(),18)
		Set x=$zobjexport($J,18)
		Set x=$zobjexport(..Namespace,18)
		// Additional class paths, if any
		If (additionalClassPaths="") {
			Set x=$zobjexport(0,18)
		} Else {
			Set size=additionalClassPaths.Count()
			Set x=$zobjexport(size,18)
			For i=1:1:size {
				Set x=$zobjexport(additionalClassPaths.GetAt(i),18)
			}
		}
		// Standard output redirection. In order to disable redirection, set below
		// global reference to 1, otherwise all Java/.Net output will be redirected to Ensemble
		Set x=$zobjexport($G(^%SYS("Gateway","Remote","DisableOutputRedirect"),0),18)
		Set x=$zobjexport(0,18)	// not used (was disable proxy deployment)
		Set x=$zobjexport(..DBSRVProtocol,18)
		Set x=$zobjexport(..#CONNECT,8)
		Set x=$zobjexport(..#INPUTTIMEOUT,52) // Use input timeout
		Set msgid=$zobjexport(9) // This may throw a TCP <READ> error if other side is not a Gateway (such as the SuperServer)
		If '$T Set status=$$$ERROR($$$RemoteGatewayError,"Communication failure on port '"_port_"', ensure there is an Object Gateway running on this port") Quit
		Set fun=$zobjexport(15)
		If '$T Set status=$$$ERROR($$$RemoteGatewayError,"Communication failure on port '"_port_"', ensure there is an Object Gateway running on this port") Quit
		Set x=$zobjexport(-1,52) // Reset timeout
		Use ..GatewayDevice
		If (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		} Else {
			Set ..Protocol=$zobjexport(12),..DBSRVProtocol=$zobjexport(12)
		}
	} Catch exception {
		If ($ZE["<READ>")||($ZE["<DSCON>") Set status=$$$ERROR($$$RemoteGatewayError,"TCP error on port '"_port_"', ensure there is an Object Gateway running on this port")
		Else  Set status=..%SetStatus(exception)
		Try { Set x=$zobjexport(-1,52) } Catch { } // Reset timeout, ignore errors here
	}
	Use ..CurrentDevice
	If (..Closed=0) && $$$ISERR(status) {
		Close ..GatewayDevice
		Set ..Closed=1
	}
	Quit status
}

/// Check if SuperServer still alive. <br/>
/// When parameter <var>reuseSocket</var> is true (the default is false), the TCP socket will not be opened or closed and
/// it is up to the caller must ensure that the device is already opened.
ClassMethod %Ping(host As %String, port As %Integer, timeout As %Numeric = 5, reuseSocket As %Boolean = 0, ByRef gatewayDevice As %String = "") As %Status [ Final ]
{
	Set status=$$$OK
	Try {
		If $G(host)="" Set host = "127.0.0.1"
		Set currentDevice=$IO
		If reuseSocket {
			#;Compatibility - some code relies on device always being "|TCP|"_port.
			If gatewayDevice="" Set gatewayDevice="|TCP|"_port
			Use gatewayDevice
		}
		Else {
			Set gatewayDevice=..%freeTCPDevice(port)
			Open gatewayDevice:(host:port:"AdS"::::5):timeout
			If '$T Set status=$$$ERROR($$$RemoteGatewayError,"Connection cannot be established") Quit
			Use gatewayDevice:(::"-d"::32767:32767)
		}
		Set x=$zobjexport(..#PING,8)
		Set x=$zobjexport(..#INPUTTIMEOUT,52) // Use input timeout
		Set msgid=$zobjexport(9)
		If '$T Set status=$$$ERROR($$$RemoteGatewayError,"Communication failure on port '"_port_"', ensure there is an Object Gateway running on this port") Quit
		Set x=$zobjexport(-1,52) // Reset timeout
		If 'reuseSocket {
			Try {
				Use gatewayDevice
				Set x=$zobjexport(..#DISCONNECT,8)
				Set msgid=$zobjexport(9),fun=$zobjexport(15)
			} Catch exception {
				Set status=..%SetStatus(exception)
			}
			Close gatewayDevice
		}
	} Catch exception {
		If ($ZE["<READ>")||($ZE["<DSCON>") Set status=$$$ERROR($$$RemoteGatewayError,"TCP error on port '"_port_"', ensure there is an Object Gateway running on this port")
		Else  Set status=..%SetStatus(exception)
		Try { Set x=$zobjexport(-1,52) } Catch { } // Reset timeout, ignore errors here
	}
	Use currentDevice
	Quit status
}

/// Close the connection
Method %Disconnect() As %Status [ Final ]
{
	Quit:..Closed $$$OK
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		Set x=$zobjexport(..#DISCONNECT,8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		//Set:fun="B1" fun=..%CallServer(fun,msgid)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Set ..Closed=1
	Try {
		Use ..CurrentDevice
		Close ..GatewayDevice
		Do ..ClosedProxies.Clear()
	} Catch exception {
		Set:$$$ISOK(status) status=..%SetStatus(exception)
	}
	Quit status
}

/// This callback method is invoked by the <METHOD>%Close</METHOD> method to 
/// provide notification that the current object is being closed.
/// 
/// <P>The return value of this method is ignored.
Method %OnClose() As %Status [ Private, ProcedureBlock = 1 ]
{
	Do ..%Disconnect()
	Quit $$$OK
}

/// Shut down the Gateway
Method %Shutdown() As %Status [ Final ]
{
	Quit:..Closed $$$ERROR($$$RemoteGatewayError,"Connection not open")
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		Set x=$zobjexport(..#SHUTDOWN,8)
		Set ..Closed=1
		Use ..CurrentDevice
		Close ..GatewayDevice
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

/// Creates all necessary proxy classes
Method %Import(javaClass As %String, ByRef javaClasses As %ListOfDataTypes, additionalClassPaths As %ListOfDataTypes = "", exclusions As %ListOfDataTypes = "") As %Status [ Final ]
{
	Quit:..Closed $$$ERROR($$$RemoteGatewayError,"Connection not open")
	Set cosClasses=##class(%ListOfDataTypes).%New()
	Set javaClasses=##class(%ListOfDataTypes).%New()
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		// name of Java class/jarFile to be imported
		Set x=$zobjexport(javaClass,18)
	
		// Additional class paths, if any
		If (additionalClassPaths="") {
			Set x=$zobjexport(0,18)
		} Else {
			Set size=additionalClassPaths.Count()
			Set x=$zobjexport(size,18)
			For i=1:1:size {
				Set x=$zobjexport(additionalClassPaths.GetAt(i),18)
			}
		}

		// list of java class package and class prefixes to be excluded
		// during dependency class generation
		If (exclusions="") {
			Set x=$zobjexport(0,18)
		} Else {
			Set size=exclusions.Count()
			Set x=$zobjexport(size,18)
			For i=1:1:size {
				Set x=$zobjexport(exclusions.GetAt(i),18)
			}
		}
		Set x=$zobjexport(..#GENERATECLASSES,8)
LoadLoop Quit:status'=$$$OK
		Use ..GatewayDevice 
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun=..#LOADCOSCLASS) {
			Set javaName=$zobjexport(12)
			Set cosName=$zobjexport(12)
			Set status=..%LoadCOSClass()
			Quit:status'=$$$OK
			Do javaClasses.Insert(javaName)
			Do cosClasses.Insert(cosName)
			Goto LoadLoop
		} ElseIf (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		} ElseIf (fun=..#GETTIMESTAMP) {
			Do ..%GetTimestamp()
			Goto LoadLoop
		}
		If status=$$$OK {
			For i=1:1:cosClasses.Count() {
				Set status=$System.OBJ.Compile(cosClasses.GetAt(i),"fr-d")
				Quit:status'=$$$OK
			}
		}
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Use ..CurrentDevice
	Quit status
}

ClassMethod %LoadCOSClass() As %Status [ Final ]
{
	Set chunks=$zobjexport(12)
	Set stream=##class(%GlobalCharacterStream).%New()
	For i=1:1:chunks {
		Do stream.Write($zobjexport(12))
	}
	Quit $System.OBJ.LoadStream(stream,"-d")
}

/// Add to current classpath
Method %AddToCurrentClassPath(paths As %ListOfDataTypes) As %Status [ Final ]
{
	If (paths="")!(paths.Count()=0) {
		Quit $$$OK
	}
	Try {
		Set status=$$$OK
		Set size=paths.Count()
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice	
		Set x=$zobjexport(size,18)
		For i=1:1:size {
			Set x=$zobjexport(paths.GetAt(i),18)
		}
		Set x=$zobjexport(..#ADDTOCURRENTCLASSPATH,8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		}
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Use ..CurrentDevice
	Quit status
}

/// Calls Class.forName
Method %ClassForName(className As %String) As %Status [ Final ]
{
	Quit:..Closed $$$ERROR($$$RemoteGatewayError,"Connection not open")
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		Set x=$zobjexport(className,18)
		Set x=$zobjexport(..#LOADJAVACLASS,8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		}
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Use ..CurrentDevice
	Quit status
}

Method %ClassForNameSynch(className As %String) As %Status [ Final ]
{
	// synchronize on DriverManager to load JDBC drivers
	Quit:..Closed $$$ERROR($$$RemoteGatewayError,"Connection not open")
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		Set x=$zobjexport(className,18)
		Set x=$zobjexport(..#LOADJAVACLASSSYNCH,8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		}
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Use ..CurrentDevice
	Quit status
}

Method %GetAllClasses(jarFileOrDirectoryName As %String, ByRef allClasses As %ListOfDataTypes) As %Status
{
	Quit:..Closed $$$ERROR($$$RemoteGatewayError,"Connection not open")
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		Set x=$zobjexport(jarFileOrDirectoryName,18)
		Set x=$zobjexport(..#GETAVAILABLECLASSES,8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		} Else {
			Use ..GatewayDevice Set count=$zobjexport(12)
			Set allClasses=##class(%ListOfDataTypes).%New()
			For i=1:1:count {
				Do allClasses.Insert($zobjexport(12))
			}
		}
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Use ..CurrentDevice
	Quit status
}

Method %GetTimestamp()
{
	Use ..GatewayDevice
	Set className=$zobjexport(12)
	Try {
		Set timestamp=$classmethod(className,"%GetParameter","IMPORTTIMESTAMP")
	} Catch {
		Set timestamp="0"
	}
	Set x=$zobjexport(timestamp,18)
	Set x=$zobjexport(..#GETTIMESTAMP,8)
}

Method %GetException() As %String [ Private ]
{
	Use ..GatewayDevice Set error=$zobjexport(12)
	Use ..CurrentDevice
	Quit $$$ERROR($$$RemoteGatewayError,error)
}

ClassMethod %SetStatus(exception As %Exception.StatusException) As %Status
{
	Quit $$$ERROR($$$RemoteGatewayError,exception.Name_exception.Location_$Select(exception.Data'="":" *"_exception.Data,1:""))
}

Method %RegUpdate()
{
	Use ..GatewayDevice Set x=$zobjexport(..ClosedProxies.Count(),18)
	For i=1:1:..ClosedProxies.Count() {
		Set x=$zobjexport(..ClosedProxies.GetAt(i),18)
	}
	Do ..ClosedProxies.Clear()
}

ClassMethod %ExpressImport(name As %String, port As %Integer, host As %String = "127.0.0.1", silent As %Boolean = 0, additionalClassPaths As %ListOfDataTypes = "", exclusions As %ListOfDataTypes = "") As %ListOfDataTypes [ Final ]
{
	Try {
		Set namespace=$zu(5),timeout=2,classes=""
		Set currentDevice=$IO
		Set gateway=##class(%Net.Remote.Gateway).%New()
		Set status=gateway.%Connect(host,port,namespace,timeout,additionalClassPaths) If status'=$$$OK { Write $system.OBJ.DisplayError(status) Quit }
		Set p=1
		For {
			Set piece=$P(name,";",p)
			Quit:piece=""
			Set status=gateway.%Import(piece,.classes,additionalClassPaths,exclusions) 
			If status'=$$$OK { Write $system.OBJ.DisplayError(status),! Quit }
			Set p=p+1
		}
		Quit:status'=$$$OK
		Set status=gateway.%Disconnect()  
		If status'=$$$OK { Write $system.OBJ.DisplayError(status) Quit }
		Quit:silent
		If $G(classes)="" Set classes="" Quit
		Use currentDevice
		If classes.Count()=0 {
			Write "No proxy classes generated/all proxies up-to-date",!
			Quit
		}
		Write !,"Generated the following proxy classes:",!
		For i=1:1:classes.Count() {
			Write "  ["_i_"] "_classes.GetAt(i),!
		}
		Write !
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
		Write $system.OBJ.DisplayError(status)
	}
	Quit classes
}

ClassMethod %RegisterSuperServer(port As %String, namespace As %String) [ Final ]
{
	l +^%SYS("Gateway","Remote","ActiveSuperServers")
	Set ^%SYS("Gateway","Remote","ActiveSuperServers")=$G(^%SYS("Gateway","Remote","ActiveSuperServers"),0)+1
	Set ^%SYS("Gateway","Remote","ActiveSuperServers",^%SYS("Gateway","Remote","ActiveSuperServers"),"Port")=port
	Set ^%SYS("Gateway","Remote","ActiveSuperServers",^%SYS("Gateway","Remote","ActiveSuperServers"),"Namespace")=namespace
	l -^%SYS("Gateway","Remote","ActiveSuperServers")
}

ClassMethod %DeregisterSuperServer(port As %String, namespace As %String) [ Final ]
{
	Set count=$G(^%SYS("Gateway","Remote","ActiveSuperServers"),0)
	Quit:count=0
	l +^%SYS("Gateway","Remote","ActiveSuperServers")
	Set count=$G(^%SYS("Gateway","Remote","ActiveSuperServers"),0)
	g:count=0 Exit
	For i=1:1:count {
		If (^%SYS("Gateway","Remote","ActiveSuperServers",i,"Port")=port)&&(^%SYS("Gateway","Remote","ActiveSuperServers",i,"Namespace")=namespace) {
			Kill ^%SYS("Gateway","Remote","ActiveSuperServers",i)
			If (i<count) {
				For j=i+1:1:count {
					Merge ^%SYS("Gateway","Remote","ActiveSuperServers",j-1)=^%SYS("Gateway","Remote","ActiveSuperServers",j)
					Kill ^%SYS("Gateway","Remote","ActiveSuperServers",j)
				}
			}
			Set ^%SYS("Gateway","Remote","ActiveSuperServers")=count-1
			Quit
		}
	}
Exit
	l -^%SYS("Gateway","Remote","ActiveSuperServers")
}

ClassMethod %TerminateSuperServer(port As %String, namespace As %String, deregister As %Boolean) [ Final ]
{
	Set gateway=##class(%Net.Remote.Gateway).%New()
#;Timeout of 1 for shutdown to make it fail fast
	Set status=gateway.%Connect("127.0.0.1",+port,namespace,1)
	Goto:'status Error
	Set status=gateway.%Shutdown()
	Goto:'status Error
	Do:deregister ..%DeregisterSuperServer(port,namespace)
	Quit
Error Quit
}

ClassMethod %TerminateAllSuperServers() [ Final ]
{
	Set count=$G(^%SYS("Gateway","Remote","ActiveSuperServers"),0)
	Quit:count=0
	l +^%SYS("Gateway","Remote","ActiveSuperServers")
	Set count=$G(^%SYS("Gateway","Remote","ActiveSuperServers"),0)
	g:count=0 Exit
	For i=1:1:count {
		Set port=$g(^%SYS("Gateway","Remote","ActiveSuperServers",i,"Port"))
		Set namespace=$g(^%SYS("Gateway","Remote","ActiveSuperServers",i,"Namespace"))
		i (port="")!(namespace="") continue
		Do ..%TerminateSuperServer(port,namespace,0)
	}
Exit
	Kill ^%SYS("Gateway","Remote","ActiveSuperServers")
	l -^%SYS("Gateway","Remote","ActiveSuperServers")
}

ClassMethod %RemoteService(host As %String, port As %Integer, serviceName As %String, arguments As %String, additionalClassPaths As %ListOfDataTypes = "") As %String [ Final ]
{
	Try {
		Set status=$$$OK,namespace=$zu(5),timeout=2
		Set gateway=##class(%Net.Remote.Gateway).%New()
		Set status=gateway.%Connect(host,port,namespace,timeout,additionalClassPaths) 
		Quit:status'=$$$OK
		Set status=gateway.%ServiceRequest(serviceName,arguments,.response)
		Quit:status'=$$$OK
		Set status=gateway.%Disconnect()
		Quit:status'=$$$OK
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
	}
	If status'=$$$OK { 
		Set response="{ ""error"" : """_status_"""}" 
	}
	Quit response
}

Method %ServiceRequest(serviceName As %String, arguments As %String, ByRef response As %String) As %Status [ Final ]
{
	Quit:..Closed $$$ERROR($$$RemoteGatewayError,"Connection not open")
	Try {
		Set status=$$$OK
		Set ..CurrentDevice=$IO
		Use ..GatewayDevice
		Set x=$zobjexport(serviceName,18)
		Set x=$zobjexport(arguments,18)
		Set x=$zobjexport(..#JAVASERVICE,8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun=..#JAVASERVICE) {
			Set response=$zobjexport(12)
		} ElseIf (fun=..#EXCEPTIONRAISED) {
			Set status=..%GetException()
		} Else {
			Set status="Unknown response: "_fun
		}
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Use ..CurrentDevice
	Quit status
}

ClassMethod %freeTCPDevice(pRequest As %Integer = 55555, pMaxTries As %Integer = 1000) As %String [ Internal ]
{
	#dim tProc As %SYS.ProcessQuery
	#dim tDevice As %String = "|TCP|"_pRequest
	#dim tOpenDevices As %String
	#dim tTries As %Integer = 0
	#dim tJob As %String = $Job
	
	Try {
		/* %SYS.ProcessQuery not available at compilation time */
		Set tOpenDevices=","_$TR($P($View(-1,$j),"^",3),"*","")_","
		While (tOpenDevices[tDevice)&&($I(tTries)<pMaxTries) {
			Set pRequest = $R(2147483647)+1
			Set tDevice = "|TCP|"_pRequest
		}
	} Catch {}

	Quit tDevice
}

}
