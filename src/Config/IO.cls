Include %syConfig

/// This class allows you to modify and view the [IO] section of the CPF file through
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
/// %SYS>s Status=##Class(Config.IO).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("File")="^%X364"
/// Properties("MagTape")="^%XMAG"
/// Properties("Other")="^%X364"
/// Properties("Terminal")="^%X364"
/// %STS>s Properties("Terminal")="^%XMYROUTINE"
/// %SYS>s Status=##Class(Config.IO).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.IO).Open()
/// %SYS>w Obj.Terminal
/// ^%XMYROUTINE
/// %SYS>s Obj.Terminal=^%ZMYROUTINE
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.IO Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Routine to use in WRITE commands for sequential files.<br>
Property File As %String(MAXLEN = 32, MINLEN = 1) [ InitialExpression = "^%X364", Required ];

/// Routine to use in WRITE commands for magnetic tapes.<br>
Property MagTape As %String(MAXLEN = 32, MINLEN = 1) [ InitialExpression = "^%XMAG", Required ];

/// Routine to use in WRITE commands for Other devices.<br>
Property Other As %String(MAXLEN = 32, MINLEN = 1) [ InitialExpression = "^%X364", Required ];

/// Routine to use in WRITE commands for terminals.<br>
Property Terminal As %String(MAXLEN = 32, MINLEN = 1) [ InitialExpression = "^%X364", Required ];

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

Method %OnValidateObject() As %Status [ Internal ]
{
}

Storage Default
{
<Data name="IODefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comments</Value>
</Value>
<Value name="3">
<Value>File</Value>
</Value>
<Value name="4">
<Value>MagTape</Value>
</Value>
<Value name="5">
<Value>Other</Value>
</Value>
<Value name="6">
<Value>Terminal</Value>
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
