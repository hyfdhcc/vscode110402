Class %Net.Remote.Java.XSLTGateway Extends %Net.Remote.Gateway [ StorageStrategy = "" ]
{

Parameter XSLTREQUEST [ Final ] = "YX";

Parameter DONE [ Final ] = 1;

Parameter COMPILEFILE [ Final ] = 2;

Parameter COMPILESTREAM [ Final ] = 3;

Parameter INVOKECALLBACK [ Final ] = 4;

Parameter RESOLVEENTITY [ Final ] = 5;

Parameter WARNING [ Final ] = 6;

Parameter ERROR [ Final ] = 7;

Parameter FATALERROR [ Final ] = 8;

Parameter TRANSFORMFILEFILEFILE [ Final ] = 9;

Parameter TRANSFORMFILECOMPILEDFILE [ Final ] = 10;

Parameter TRANSFORMSTREAMSTREAMSTREAM [ Final ] = 11;

Parameter TRANSFORMSTREAMCOMPILEDSTREAM [ Final ] = 12;

Parameter TRANSFORMSTRINGCOMPILEDSTRING [ Final ] = 13;

Parameter RELEASECOMPILEDXSLT [ Final ] = 14;

/// Default host
Parameter Host = "127.0.0.1";

/// Default port is Superserver port + 5000 if it does not exceed 65535, otherwise 61972
Parameter Port As COSEXPRESSION = "$S($ZU(172,0)<60635:$ZU(172,0)+5000,1:61972)";

/// Default JDK version
Parameter JDKVersion = "JDK17";

/// Default log file
Parameter LogFile;

/// Default JavaHome directory
Parameter JavaHome;

/// Default additional JVM arguments
Parameter JVMArgs;

ClassMethod TransformStream(source As %XML.SAX.StreamAdapter, xslt As %ObjectHandle, target As %XML.SAX.StreamAdapter, errorHandler As %ObjectHandle, callbackHandler As %ObjectHandle, parameters As %ObjectHandle, entityResolver As %ObjectHandle) As %Status [ Final ]
{
	Try {
		Set gateway=..StartGateway(.status)
		If status'=$$$OK Quit
		If (xslt.%IsA("%XML.SAX.StreamAdapter")) {
			Set x=$zobjexport(..#TRANSFORMSTREAMSTREAMSTREAM,2)
			Set x=$zobjexport(source.Stream.Read(source.Stream.Size),18)
			Set x=$zobjexport(xslt.Stream.Read(xslt.Stream.Size),18)
		} ElseIf (xslt.%IsA("%XML.XSLT2.CompiledStyleSheet")) {
			Set x=$zobjexport(..#TRANSFORMSTREAMCOMPILEDSTREAM,2)
			Set x=$zobjexport(source.Stream.Read(source.Stream.Size),18)
			Set x=$zobjexport(xslt,18)
		} Else {
			Set status=$$$ERROR($$$XSLTError,"Unknown stylesheet type")
			Quit
		}
		Set status=..Transform(gateway,errorHandler,callbackHandler,parameters,entityResolver,.target)
		Do ..StopGateway(gateway)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

ClassMethod TransformFileFile(source As %String, xslt As %String, target As %String, errorHandler As %ObjectHandle, callbackHandler As %ObjectHandle, parameters As %ObjectHandle, entityResolver As %ObjectHandle) As %Status [ Final ]
{
	Try {
		Set gateway=..StartGateway(.status)
		If status'=$$$OK Quit
		Set x=$zobjexport(..#TRANSFORMFILEFILEFILE,2)
		Set x=$zobjexport(source,18)
		Set x=$zobjexport(xslt,18)
		Set x=$zobjexport(target,18)
		Set status=..Transform(gateway,errorHandler,callbackHandler,parameters,entityResolver)
		Do ..StopGateway(gateway)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

ClassMethod TransformFileCompiled(source As %String, xslt As %XML.XSLT2.CompiledStyleSheet, target As %String, errorHandler As %ObjectHandle, callbackHandler As %ObjectHandle, parameters As %ObjectHandle, entityResolver As %ObjectHandle) As %Status [ Final ]
{
	Try {
		Set gateway=..StartGateway(.status)
		If status'=$$$OK Quit
		Set x=$zobjexport(..#TRANSFORMFILECOMPILEDFILE,2)
		Set x=$zobjexport(source,18)
		Set x=$zobjexport(xslt,18)
		Set x=$zobjexport(target,18)
		Set status=..Transform(gateway,errorHandler,callbackHandler,parameters,entityResolver)
		Do ..StopGateway(gateway)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

ClassMethod Transform(gateway As %Net.Remote.Gateway, errorHandler As %ObjectHandle, callbackHandler As %ObjectHandle, parameters As %ObjectHandle, entityResolver As %ObjectHandle, ByRef outputStream As %XML.XSLT.StreamAdapter = {$$$NULLOREF}) As %Status [ Final ]
{
	Set x=$zobjexport(callbackHandler,18)
	Set x=$zobjexport(entityResolver,18)
	Set x=$zobjexport(parameters,18)
	Set status=..CallXSLTProcessor(gateway,errorHandler,.outputStream)
	Do ..StopGateway(gateway)
	Quit status
}

ClassMethod CompileXSLFile(xslt As %String, compiledStyleSheet As %XML.XSLT2.CompiledStyleSheet, errorHandler As %ObjectHandle) As %Status [ Final ]
{
	Try {
		Set gateway=..StartGateway(.status)
		If status'=$$$OK Quit
		Set x=$zobjexport(..#COMPILEFILE,2)
		Set x=$zobjexport(xslt,18)
		Set x=$zobjexport(compiledStyleSheet,18)
		Set status=..CallXSLTProcessor(gateway,errorHandler,.outputStream)
		Do ..StopGateway(gateway)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

ClassMethod ReleaseCompiledXSLT(compiledStyleSheet As %XML.XSLT2.CompiledStyleSheet, errorHandler As %ObjectHandle = {$$$NULLOREF}) As %Status [ Final ]
{
	Try {
		Set gateway=..StartGateway(.status)
		If status'=$$$OK Quit
		Set x=$zobjexport(..#RELEASECOMPILEDXSLT,2)
		Set x=$zobjexport(compiledStyleSheet,18)
		Set status=..CallXSLTProcessor(gateway,errorHandler)
		Do ..StopGateway(gateway)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

ClassMethod CompileXSLStream(xslt As %XML.SAX.StreamAdapter, compiledStyleSheet As %XML.XSLT2.CompiledStyleSheet, errorHandler As %ObjectHandle) As %Status [ Final ]
{
	Try {
		Set gateway=..StartGateway(.status)
		If status'=$$$OK Quit
		Set x=$zobjexport(..#COMPILESTREAM,2)
		Set x=$zobjexport(xslt.Stream.Read(xslt.Stream.Size),18)
		Set x=$zobjexport(compiledStyleSheet,18)
		Set status=..CallXSLTProcessor(gateway,errorHandler,.outputStream)
		Do ..StopGateway(gateway)
	} Catch exception {
		Set status=..%SetStatus(exception)
	}
	Quit status
}

ClassMethod ProcessCallback(gateway As %Net.Remote.Gateway)
{
	Set callback=$zobjref($zobjexport(12)),arg=$zobjexport(12)
	For i=1:1:arg {
		Set arg(i)=$zobjexport(12) 
	}
	Set retValue=$method(callback,"evaluate",arg...)
	Use gateway.GatewayDevice
	Set x=$zobjexport(retValue,18)
	Set x=$zobjexport(..#XSLTREQUEST,8)
}

ClassMethod CallXSLTProcessor(gateway As %Net.Remote.Gateway, errorHandler As %ObjectHandle = {$$$NULLOREF}, ByRef outputStream As %XML.XSLT.StreamAdapter = {$$$NULLOREF}) As %Status [ Final ]
{
	Set status=$$$OK
	Set x=$zobjexport(errorHandler,18)
	Set x=$zobjexport(..#XSLTREQUEST,8)
Loop Set msg=$zobjexport(9),type=$zobjexport(10),fun=$zobjexport(15)
	If fun'="YX" {
		Quit status=..%SetStatus("Not an XSLT request: "_fun)
	}
	If (type=..#TRANSFORMFILEFILEFILE)||(type=..#TRANSFORMFILECOMPILEDFILE)||(type=..#DONE)||(type=..#COMPILEFILE)||(type=..#COMPILESTREAM)||(type=..#RELEASECOMPILEDXSLT) {
		Quit status
	}
	If (type=..#TRANSFORMSTREAMSTREAMSTREAM)||(type=..#TRANSFORMSTREAMCOMPILEDSTREAM) {
		If outputStream'="" {
			//Set streamSize=$zobjexport(16),stream=$zobjexport(streamSize,13)
			Set streamSize=$zobjexport(12),stream=$zobjexport(streamSize,13)
			Do outputStream.Write(stream)
		}
		Quit status
	}
	If type=..#INVOKECALLBACK {
		Do ..ProcessCallback(gateway)
	} ElseIf (type=..#WARNING)||(type=..#ERROR)||(type=..#FATALERROR) {
		Do ..ProcessError(gateway,type)
		Quit:type=..#FATALERROR status
	}
	Goto Loop
}

ClassMethod ProcessError(gateway As %Net.Remote.Gateway, type As %Integer)
{
	Set errorHandler=$zobjref($zobjexport(12))
	Set errorText=$zobjexport(12)
	Use gateway.CurrentDevice
	If (type=..#WARNING) {
		Do $zobjmethod(errorHandler,"warning",errorText)
	} ElseIf (type=..#ERROR) {
		Do $zobjmethod(errorHandler,"error",errorText)
	} ElseIf (type=..#FATALERROR) {
		Do $zobjmethod(errorHandler,"fatalError",errorText)
	}
	Use gateway.GatewayDevice
}

/// Instantiate a temporary in-memory Object Gateway for Java to be used by XSLT 2.0.
/// A missing parameter assume the corresponding configured value or in the absence of it, the default value for the parameter.
ClassMethod GetObjectGateway(Output status As %Status, port As %String, host As %String, jdk As %String, javahome As %String, logfile As %String, jvmargs As %String) As %Net.Remote.ObjectGateway
{
	Set status=$$$OK
	Try {
		// Adjust parameter values
		If '$D(host) {
			If '$D(^%SYS("XSLTGateway","Host"),host) {
				Set host=..#Host
			}
		}
		If '$D(port) {
			If '$D(^%SYS("XSLTGateway","Port"),port) {
				Set port=..#Port
			}
		}
		If '$D(jdk) {
			If '$D(^%SYS("XSLTGateway","JDKVersion"),jdk) {
				Set jdk=..#JDKVersion
			}
		}
		If '$D(javahome) {
			If '$D(^%SYS("XSLTGateway","JavaHome"),javahome) {
				Set javahome=..#JavaHome
			}
		}
		If '$D(logfile) {
			If '$D(^%SYS("XSLTGateway","LogFile"),logfile) {
				Set logfile=..#LogFile
			}
		}
		If '$D(jvmargs) {
			If '$D(^%SYS("XSLTGateway","JVMArgs"),jvmargs) {
				Set jvmargs=..#JVMArgs
			}
		}

		// Instantiate a new object gateway and set properties
		Set objectGateway=##class(%Net.Remote.ObjectGateway).%New()
		Set objectGateway.Server=host
		Set objectGateway.Port=port
		Set objectGateway.JDKVersion=$G(jdk)
		Set delimiter = $S($$$isWINDOWS:";", 1:":")
		Set objectGateway.ClassPath="."_delimiter_$ZU(147,##class(%File).NormalizeFilename($SYSTEM.Util.InstallDirectory()_"dev/java/lib/xml/saxon9.jar"))
		Set objectGateway.LogFile=logfile
		Set objectGateway.JavaHome=javahome
		Set objectGateway.JVMArgs=jvmargs
		Set objectGateway.Type=1 				// Indicates an Object Gateway for Java
		Set objectGateway.HeartbeatInterval=0 	// No monitor needed
		Set objectGateway.InitializationTimeout=5
		Set objectGateway.ConnectionTimeout=2
		Set objectGateway.Name="XSLTGateway"
	} Catch exception {
		Set status=exception.AsStatus()
	}

	Quit objectGateway
}

/// Start a Gateway for XSLT 2.0 if not already started, and return a gateway connection
ClassMethod StartGateway(Output status As %Status, port As %String, host As %String, jdk As %String, javahome As %String, logfile As %String, jvmargs As %String) As %Net.Remote.Gateway
{
	Set gateway=$$$NULLOREF
	Set status=$$$OK

	Set objectGateway=..GetObjectGateway(.status, .port, .host, .jdk, .javahome, .logfile, .jvmargs)
	If $$$ISERR(status) {
		Set status=$$$ERROR($$$RemoteGatewayError,$system.Status.GetErrorText(status))
		Quit $$$NULLOREF
	}

	Set error=""

	// If gateway is not running, then start it
	If '(##class(%Net.Remote.Service).IsGatewayRunning(objectGateway.Server,objectGateway.Port,0,.rc,0)) {
		Set rc=##class(%Net.Remote.Service).StartGatewayObject(objectGateway,0,.output)
		If $$$ISERR(rc) {
			Set error="XSLT Gateway failed to start: "_$system.Status.GetErrorText(rc)
			Set:$G(output)'="" error = error_$C(13,10)_"Return: "_output
		}
	}

	// Get a gateway connection
	If error="" {
		Set rc=..ConnectGateway(objectGateway,.gateway)
		If $$$ISERR(rc) {
			Set error="Unable to connect to the XSLT Gateway: "_$system.Status.GetErrorText(rc)
		}
	}

	If (error'="") {
		Set status=$$$ERROR($$$RemoteGatewayError,error)
	} Else {
		Set status=$$$OK
	}

	Quit gateway
}

/// Connect
ClassMethod ConnectGateway(pGateway As %Net.Remote.ObjectGateway, ByRef pGatewayConn As %Net.Remote.Gateway) As %Status [ Internal ]
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	Try {
		Set tSC = ##class(%Net.Remote.Service).ConnectGateway(pGateway, .pGatewayConn, "", 0)
		If $$$ISERR(tSC) Quit
		Use "|TCP|"_+pGateway.Port
	} Catch e {Set tSC = e.AsStatus()}
	Quit tSC
}

/// Disconnect
ClassMethod StopGateway(gateway As %Net.Remote.Gateway)
{
	Use gateway.CurrentDevice
	Set x=gateway.%Disconnect()
	Kill x
}

/// Shutdown the gateway
ClassMethod ShutdownGateway(port As %String, host As %String) As %Status
{
	Set objectGateway = ..GetObjectGateway(.status,$G(port),$G(host)) // Only host and port are relevant for shutdown
	If $$$ISERR(status) {
		Quit status=$$$ERROR($$$RemoteGatewayError,$system.Status.GetErrorText(status))
	}
	Quit ##class(%Net.Remote.Service).StopGatewayObject(objectGateway, 0, 0)
}

ClassMethod %SetStatus(exception As %Exception.StatusException) As %Status
{
	Quit $$$ERROR($$$XSLTError,exception.Name_exception.Location_$Select(exception.Data'="":" *"_exception.Data,1:""))
}

}
