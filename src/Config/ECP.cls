Include %syConfig

/// This class allows you to modify and view the [ECP] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters, or use Object sytax to open and directly manipulate the config
/// objects.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.ECP).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("ClientReconnectDuration")=1200
/// Properties("ClientReconnectInterval")=5
/// Properties("ServerTroubleDuration")=60
/// %SYS>s Properties("ServerTroubleDuration")=90
/// %SYS>s Status=##Class(Config.ECP).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.ECP).Open()
/// %SYS>w Obj.ServerTroubleDuration
/// 90
/// %SYS>s Obj.ServerTroubleDuration=120
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.ECP Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// How long a client should keep trying to re-establish a connection before giving up
/// or declaring connection failed (in seconds).<br>
Property ClientReconnectDuration As %Integer(MAXVAL = 65535, MINVAL = 10) [ InitialExpression = 1200 ];

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// When a server is not available, how long to wait between each reconnection attempt (in seconds).<br>
Property ClientReconnectInterval As %Integer(MAXVAL = 60, MINVAL = 1) [ InitialExpression = 5 ];

/// Duration a connection will stay in troubled state (in seconds).
/// Once this period of time has elapsed, the server will declare the connection dead and
/// presume recovery is not possible.<br>
Property ServerTroubleDuration As %Integer(MAXVAL = 65535, MINVAL = 20) [ InitialExpression = 60 ];

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

Storage Default
{
<Data name="ECPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClientReconnectDuration</Value>
</Value>
<Value name="3">
<Value>ClientReconnectInterval</Value>
</Value>
<Value name="4">
<Value>ServerTroubleDuration</Value>
</Value>
<Value name="5">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>configDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
