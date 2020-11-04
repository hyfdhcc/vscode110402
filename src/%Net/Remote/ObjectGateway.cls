Include %occJava

/// Object Gateway Server definitions.
Class %Net.Remote.ObjectGateway Extends %Persistent [ System = 3 ]
{

// --------------- Queries and methods ---------------

/// Lookup by Gateway name.
Query ByName(name As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name,Type,Server,Port,Interface") [ SqlProc ]
{
 SELECT %ID, Name, %EXTERNAL(Type), Server, Port, AllowedIPAddresses AS Interface
 FROM ObjectGateway
 WHERE Name %STARTSWITH :name
 ORDER BY Name
}

/// Lookup all Gateways; include current state.
Query ByGateway() As %Query(ROWSPEC = "Name,Type,Server,Port,State,StateExt") [ SqlProc ]
{
}

ClassMethod ByGatewayExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tRS = ##class(%ResultSet).%New("%Net.Remote.ObjectGateway:ByName")
		Kill ^||gateways
		Set tSC = tRS.Execute()
		For {
			Quit:'tRS.Next()
			Set name = tRS.Get("Name")
			Set ^||gateways(name) = $LB(name,tRS.Get("Type"),tRS.Get("Server"),tRS.Get("Port"),tRS.Get("Interface"))
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$GeneralError, $ZE)
	}
	Set qHandle = $LB("")
	Quit tSC
}

ClassMethod ByGatewayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetAllClassesExecute ]
{
	Set index = $List(qHandle,1)
	Set index = $O(^||gateways(index))
	If index="" {
		Set Row = ""
		Set AtEnd = 1
	}
	Else {
		Set Row = ^||gateways(index)
		If ##class(%Net.Remote.Utility).IsServerLocal($List(Row,3)) {
			Set stInt = ..GatewayState($List(Row,4),$List(Row,5),$List(Row,3))
			Set stExt = $Case(stInt,0:"Inactive",1:"Active",:"")
		}
		Else {
			Set stInt = 2
			Set stExt = "Remote"
		}
		Set $List(Row,5) = stInt, $List(Row,6) = stExt // discard the "Interface" column
	}
	Set qHandle = $LB(index)
	Quit $$$OK
}

ClassMethod ByGatewayClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetAllClassesExecute ]
{
	Set qHandle = ""
	Kill ^||gateways
	Quit $$$OK
}

/// See method ##class(%Net.Remote.Service).IsGatewayRunning(pServer, pPort, pVerbose, .status, pPing, pInterface).
ClassMethod GatewayState(port As %String, interface As %String = "", server As %String = "127.0.0.1") As %Integer [ Internal ]
{
	If '$G(port) Quit 0
	Quit ##class(%Net.Remote.Service).IsGatewayRunning(server, +port, 0, .tSC, 1, interface)
}

/// Check if there exists a Gateway with a given name.
ClassMethod GatewayExists(name As %String) As %Boolean
{
	&sql( SELECT %ID INTO :tID FROM ObjectGateway WHERE Name=:name )
	If (SQLCODE=0) && ($G(tID)'="") Quit 1
	Quit 0
}

/// This method checks if Gateway Name "JDBC_Default" already exists, and if it doesn't exist,
/// creates it with default settings.
ClassMethod InitJDBCDefault() [ Internal ]
{
	Quit  // Note: Currently this method is not in use, nevertheless we are keeping this gateway name reserved
	Try {
		If '(..GatewayExists("JDBC_Default")) {
			&sql( INSERT INTO ObjectGateway 
			(Name, Type, Server, Port) 
			VALUES ('JDBC_Default', 1 ,'127.0.0.1', 22972) 
			)
		}
	}
	Catch {
	}
	Quit
}

// --------------- These properties are common to all types of gateways ---------------

/// Index for property Name
Index ID On Name [ IdKey ];

/// Index for property Port
Index PortIndex On Port [ Unique ];

/// Type of the Object Gateway.  It can have one of the following values:
/// <br>Type = 1 for Object Gateway for Java
/// <br>Type = 2 for Object Gateway for .NET
Property Type As %String(DISPLAYLIST = ",Java,.NET", VALUELIST = ",1,2") [ Required ];

Property Name As %String [ Required ];

/// IP address or name of the machine where the JVM to be used by the Gateway Server is located.
Property Server As %String [ InitialExpression = "127.0.0.1", Required ];

/// TCP port number for communication between the Java Gateway Server and the proxy classes in Ensemble.
Property Port As %String [ Required ];

/// Fully qualified name of a file to log all communication between Caché/Ensemble and the Gateway Server.
/// Usually this setting should be left blank, and used only for trouble-shooting.
Property LogFile As %String(MAXLEN = 1023);

/// A non-zero value for this property enables heartbeat, which is periodic communication with the Gateway Server to check if it's active. 
/// The default is 10 seconds. 
/// When enabled, the minimum value is 5 seconds and the maximum value is 3600 seconds or 1 hour. <br>
/// When heartbeat is disabled the monitor process won't be started and the related settings are ignored. <br>
/// See also properties <property>HeartbeatFailureTimeout</property>, <property>HeartbeatFailureAction</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatInterval As %Integer(MAXVAL = 3600, MINVAL = 0) [ InitialExpression = 10 ];

/// When heartbeat is enabled, this is the number of seconds without responding to the heartbeat, to consider that 
/// the Gateway Server is in failure state.
/// If this value is smaller than property <property>HeartbeatInterval</property>, it will be considered in
/// failure state every time the Gateway communication check fails.
/// The default is 30 seconds. 
/// The maximum value is 86400 seconds or 1 day. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureAction</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatFailureTimeout As %Integer(MAXVAL = 86400, MINVAL = 0) [ InitialExpression = 30 ];

/// When heartbeat is enabled, this defines what action(s) to take if the Gateway Server goes into failure state.
/// Setting it to <b>Restart</b> (default) will cause the Gateway Server to be restarted.
/// Setting it to <b>Alert</b> will generate an Alert entry in the Ensemble Event Log -- this option is
/// only available for Ensemble, and is independent of the <b>Alert on Error</b> setting. <br>
/// Note: If <property>Server</property> points to a remote system, this feature can't be set to restart the Server. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureTimeout</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatFailureAction As %String(DISPLAYLIST = ",None,Restart,Alert,Restart and Alert", VALUELIST = ",N,R,A,RA") [ InitialExpression = "R" ];

/// When heartbeat is enabled, in case the Gateway Server goes into failure state, and stays in failure state, 
/// this setting defines how much time to wait before retrying the <property>HeartbeatFailureAction</property>.
/// The default value is 300 seconds or 5 minutes.  The maximum value is 86400 seconds or 1 day. 
/// A value of 0 disables this retry, meaning that once there is a failure that can't be immediately recovered,
/// there won't be automatic attempts to recovery. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureTimeout</property>
/// and <property>HeartbeatFailureAction</property>.
Property HeartbeatFailureRetry As %Integer(MAXVAL = 86400, MINVAL = 0) [ InitialExpression = 300 ];

/// Number of seconds to wait for a response during initialization of the Gateway Server.
Property InitializationTimeout As %Integer(MAXVAL = 300, MINVAL = 2) [ InitialExpression = 5 ];

/// Number of seconds to wait for a connection to be established with the Gateway Server.
Property ConnectionTimeout As %Integer(MAXVAL = 300, MINVAL = 2) [ InitialExpression = 5 ];

// --------------- These properties are only for Type = 1 (Java) ---------------

/// Location of the JVM (similar to the JAVA_HOME environment variable).  It is used to find the target JVM
/// and assemble the command to start the Gateway. <br>
/// Note: If there is a default JVM on the machine that is usable without the need to specify its location,
/// this setting may be left blank.
/// <br>(This property applies only to Java Gateways.)
Property JavaHome As %String(MAXLEN = 1023);

/// Version of JDK used to select the intended version of InterSystems .jar files. 
/// It is used to locate and assemble the command to start the Gateway.
/// <br>(This property applies only to Java Gateways.)
Property JDKVersion As %String(DISPLAYLIST = ",Java 1.7,Java 1.8", VALUELIST = ",JDK17,JDK18") [ InitialExpression = "JDK17" ];

/// CLASSPATH containing the files required to be passed as an argument when starting the JVM.
/// The user should typically provide here the files containing the classes used via the Java Gateway.
/// There is no need to include InterSystems' .jar files used by the Java Gateway.
/// We assume that the user has properly quoted the classpath and supplied the correct separators for the platform
/// in case of multiple files.
/// <br>(This property applies only to Java Gateways.)
Property ClassPath As %String(MAXLEN = 32000);

/// Optional arguments to be passed to the Java Virtual Machine (JVM) to include when assembling the 
/// command to start the Gateway. <br>
/// For example, you can specify system properties: <b>Dsystemvar=value</b> <br>
/// or set the maximum heap size: <b>Xmx256mb</b> <br>
/// and so on, as needed.
/// <br>(This property applies only to Java Gateways.)
Property JVMArgs As %String(MAXLEN = 32000);

/// Name of the Java class that will be specified in the command to launch the gateway.
/// This is the class whose main method launches the server.
Property MainClassName As %String [ InitialExpression = {$$$javaGatewayClass} ];

// --------------- These properties are only for Type = 2 (.NET) ---------------

/// Which IP address, among the several IP addresses that the machine has, that allows incoming connections.
/// The default is 127.0.0.1.
/// Specify 0.0.0.0 to listen on all IP addresses local to the machine (127.0.0.1, VPN address, etc.).
/// You can also specify a single existing local IP address to restrict the listener to that IP address.
/// <br>(This property applies only to .NET Gateways.)
Property AllowedIPAddresses As %String [ InitialExpression = "127.0.0.1" ];

/// Location of the Gateway Server executable.
/// It is used to find the target executable and assemble the command to start the Gateway
/// on a local machine. <br>
/// If this setting is not specified, the default directory used is ...\dev\dotnet\bin\ under 
/// the instance's installation directory.
/// <br>(This property applies only to .NET Gateways.)
Property FilePath As %String(MAXLEN = 1023);

/// On 64-bit platforms, indicates if the Object Gateway server is to be executed as 32-bit (default) or 64-bit.
/// <br>(This property applies only to .NET Gateways and to 64-bit platforms.)
Property Exec64 As %Boolean [ InitialExpression = 0 ];

/// Version of .NET used to select the directory for the intended Gateway server executable.
/// The default is version 2.0.
/// <br>(This property applies only to .NET Gateways.)
Property DotNetVersion As %String(DISPLAYLIST = ",4.0,2.0", VALUELIST = ",4.0,2.0") [ InitialExpression = "2.0" ];

// --------------- Callback methods ---------------

/// This callback method is invoked when the current object is added to the SaveSet,
/// either because %Save() was invoked on this object or on an object that references this object.
/// %OnAddToSaveSet can modify the current object. It can also add other objects to the current
/// SaveSet by invoking %AddToSaveSet or remove objects by calling %RemoveFromSaveSet.
/// 
/// <P>If this method returns an error status then %Save() will fail and the transaction
/// will be rolled back.
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Private, ServerOnly = 1 ]
{
	// Normalize property DotNetVersion
	If (..DotNetVersion?.1"v"1"2.0.".n) || ( ..DotNetVersion="2") || ( ..DotNetVersion="v2.0") {
		Set ..DotNetVersion = "2.0"
	}
	ElseIf (..DotNetVersion?.1"v"1"4.0.".n) || ( ..DotNetVersion="4") || ( ..DotNetVersion="v4.0") {
		Set ..DotNetVersion = "4.0"
	}
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ServerOnly = 1 ]
{
	If ..Name="JDBC_Default" Quit $$$ERROR($$$GeneralError,"Name 'JDBC_Default' is reserved, please choose a different name")
	If +..Port=$G(^%SYS("sql","sys","JDBC Gateway Port"),22972) Quit $$$ERROR($$$GeneralError,"Port conflict with the JDBC Gateway default port")
	Quit $$$OK
}

Storage Default
{
<Data name="ObjGatewayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Server</Value>
</Value>
<Value name="5">
<Value>Port</Value>
</Value>
<Value name="6">
<Value>LogFile</Value>
</Value>
<Value name="7">
<Value>InitializationTimeout</Value>
</Value>
<Value name="8">
<Value>ConnectionTimeout</Value>
</Value>
<Value name="9">
<Value>HeartbeatInterval</Value>
</Value>
<Value name="10">
<Value>HeartbeatFailureTimeout</Value>
</Value>
<Value name="11">
<Value>HeartbeatFailureAction</Value>
</Value>
<Value name="12">
<Value>HeartbeatFailureRetry</Value>
</Value>
<Value name="13">
<Value>JavaHome</Value>
</Value>
<Value name="14">
<Value>JDKVersion</Value>
</Value>
<Value name="15">
<Value>ClassPath</Value>
</Value>
<Value name="16">
<Value>JVMArgs</Value>
</Value>
<Value name="17">
<Value>DotNetServer</Value>
</Value>
<Value name="18">
<Value>AllowedIPAddresses</Value>
</Value>
<Value name="19">
<Value>FilePath</Value>
</Value>
<Value name="20">
<Value>Mode64Bit</Value>
</Value>
<Value name="21">
<Value>Exec64</Value>
</Value>
<Value name="22">
<Value>DotNetVersion</Value>
</Value>
<Value name="24">
<Value>MainClassName</Value>
</Value>
</Data>
<DataLocation>^%SYS("gateway","DEFINITION","DATA")</DataLocation>
<DefaultData>ObjGatewayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%SYS("gateway","DEFINITION","DATA")</IdLocation>
<IndexLocation>^%SYS("gateway","DEFINITION","INDEX")</IndexLocation>
<StreamLocation>^%SYS("gateway","DEFINITION","STREAM")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
