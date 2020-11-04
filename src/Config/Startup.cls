Include (%syConfig, USTART, FILEINC, LANG11)

/// This class allows you to modify and view the [Startup] section of the CPF file through
/// programmatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, specify the CPF file you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters, or use Object syntax to open and directly manipulate the config
/// objects.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.Startup).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("MaxConsoleLogSize")
/// Properties("MaxConsoleLogSize")=5
/// %SYS>s Properties("MaxConsoleLogSize")=10
/// %SYS>s Status=##Class(Config.Startup).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.Startup).Open()
/// %SYS>w Obj.MaxConsoleLogSize
/// 10
/// %SYS>s Obj.MaxConsoleLogSize=20
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.Startup Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Execute the CALLIN^%ZSTOP routine entry during calling Halt.<br>
Property CallinHalt As %Boolean [ InitialExpression = 1, Required ];

/// Executes the CALLIN^%ZSTART routine entry during Callin startup.<br>
Property CallinStart As %Boolean [ InitialExpression = 1, Required ];

/// Name used to append to $J when Config.Miscellaneous.NodeNameInPid is set.<br>
Property CliSysName As %String(MAXLEN = 64, MINLEN = 0);

/// Stores a list of allowed database block sizes.<br>
Property DBSizesAllowed As %String(MINLEN = 4) [ InitialExpression = "8192", Required ];

/// Port for the SuperServer.<br>
Property DefaultPort As %Integer [ InitialExpression = 1972, Required ];

/// IP Address SuperServer will bind to.<br>
/// By default, the SuperServer accepts requests on all addresses, but if a DefaultPortBindAddress is specified it will accept requests only on that address.
/// You should insure that all clients, including the CSP Gateway, are also configured to connect to the address you specify.
/// If no address is specified, the SuperServer will accept requests directed to any address on the server.
Property DefaultPortBindAddress As Config.Host(MAXLEN = 256, MINLEN = 0);

/// Auto start the Ensemble productions.<br>
Property EnsembleAutoStart As %Boolean [ InitialExpression = 0, Required ];

/// Number of days to store application error logs before purging them.<br>
Property ErrorPurge As %Integer(MAXVAL = 1000, MINVAL = 1) [ InitialExpression = 30, Required ];

/// System is operating in an IPv6 network, with IPv6 addresses.<br>
/// 0 - IPv6 is not enabled.<br>
/// 1 - IPv6 is enabled.<br>
Property IPv6 As %Boolean [ InitialExpression = 0, Required ];

/// Execute the JOB^%ZSTOP routine entry during JOB process Halt.<br>
Property JobHalt As %Boolean [ InitialExpression = 1, Required ];

/// Number of job servers you want the system to start up with.<br>
Property JobServers As %Integer(MAXVAL = 2000, MINVAL = 0) [ InitialExpression = 0, Required ];

/// Execute the JOB^%ZSTART routine entry during JOB process startup.<br>
Property JobStart As %Boolean [ InitialExpression = 1, Required ];

/// Maximum size in megabytes the CacheTemp database will be when the system is
/// restarted.<br> When the system restarts, the CacheTemp database will be truncated to
/// this size. If 0, the CacheTemp database will not be truncated.<br>
Property MaxCacheTempSizeAtStart As %Integer(MAXVAL = 1000000, MINVAL = 0) [ InitialExpression = 0, Required ];

/// Maximum size in megabytes of the cconsole.log after which it will be automatically switched.<br>
Property MaxConsoleLogSize As %Integer(MAXVAL = 500, MINVAL = 1) [ InitialExpression = 5, Required ];

/// Execute the LOGIN^%ZSTOP routine entry during terminal user Halt.<br>
Property ProcessHalt As %Boolean [ InitialExpression = 1, Required ];

/// Execute the LOGIN^%ZSTART routine entry during terminal user startup.<br>
Property ProcessStart As %Boolean [ InitialExpression = 1, Required ];

/// Enter the time, in seconds, Caché should wait for shutdown to complete normally before
/// timing out and forcing a shutdown.<br>
Property ShutdownTimeout As %Integer(MAXVAL = 100000, MINVAL = 120) [ InitialExpression = 300, Required ];

/// Directory for temporary files.<br>
Property TempDirectory As %SysPath [ InitialExpression = "Temp" ];

/// Execute the SYSTEM^%ZSTOP routine entry during system shutdown.<br>
Property SystemHalt As %Boolean [ InitialExpression = 1, Required ];

/// Executes the SYSTEM^%ZSTART routine entry during system startup.<br>
Property SystemStart As %Boolean [ InitialExpression = 1, Required ];

/// Set the format of the terminal prompt.<br>
/// This is a comma separated string of values which set the default terminal prompt for the system.<br>
/// Values:<br>
/// 0 - Use only ">" for the prompt.<br>
/// 1 - Host name, also known as the current system name. The name assigned to your
/// computer. For example, LABLAPTOP&gt;. This is the same for all of your terminal
/// processes.<br>
/// 2 - Namespace name. For example, %SYS&gt;. The current namespace name is contained
/// in the $NAMESPACE special variable. It can be an explicit namespace name or an
/// implied namespace name.<br>
/// 3 - Config name. The name of your system installation. For example, CACHE2&gt;.
/// This is the same for all of your terminal processes.<br>
/// 4 - Current time, expressed as local time in 24-hour format with whole seconds.
/// For example, 15:59:36&gt;. This is the static time value for when the prompt was
/// returned. This value changes for each prompt.<br>
/// 5 - pid. The Process ID for your terminal. For example, 2336&gt;. This is different
/// for each terminal process. This value can also be returned from the $JOB special
/// variable.<br>
/// 6 - Username. For example, fred&gt;. This is the same for all of your terminal
/// processes.<br>
/// 7 - Elapsed time executing the last command, in seconds.milliseconds. For example,
/// .000495&gt;. Leading and trailing zeros are suppressed. This changes for each prompt.<br>
/// 8 - Transaction Level. For example, TL1&gt;.<br><br>
/// The order of the values in the string determines the order the values appear in the prompt.
/// For example TerminalPrompt="2,1" will give you a terminal prompt of "%SYS:HostName>"
Property TerminalPrompt As %String [ InitialExpression = "8,2", Required ];

/// Start the private WebServer.<br>
Property WebServer As %Boolean [ InitialExpression = 1, Required ];

/// Webserver name or IP address the private web server is running on.<br>
/// If not specified, it defaults to localhost. For Unix and Windows, the
/// private web server will be started on this node, on the specified IP address
/// and port. For VMS, This is the IP address of the node where the webserver
/// is running.
Property WebServerName As %String;

/// Private WebServer port.<br>
Property WebServerPort As %Integer [ InitialExpression = 57772, Required ];

/// URL prefix.<br>
Property WebServerURLPrefix As %SysPath;

/// Run the user defined startup from the ZSTU routine at system startup.<br>
Property ZSTU As %Boolean [ InitialExpression = 1, Required ];

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

/// Load CliSysName and longid into memory.<br>
ClassMethod InitCliSysName() As %Status [ Internal ]
{
}

/// Purge old application errors.<br>
ClassMethod ErrorPurge() As %Status [ Internal ]
{
}

/// Restart the super server.<br>
ClassMethod RestartSuperServer() As %Status
{
}

/// Restart the private webserver.<br>
ClassMethod RestartWebServer() As %Status
{
}

/// Request a test page (ping) from the private webserver.<br><br>
/// This is valid only for Windows and Unix. 
/// If run on VMS, or the web server is configured to not start, it always returns success.<br>
/// Parameters:<br>
/// Delay - Number of seconds to wait before making request.<br>
ClassMethod CheckWebServerStatus(Delay As %Integer = 0) As %Status
{
}

/// Set the terminal prompt to the system default.<br>
ClassMethod SetTerminalPrompt() As %Status
{
}

/// Restart the private webserver.<br>
ClassMethod StopWebServer(Restart As %Integer = 0) As %Status
{
}

/// Switch the cconsole.log file if it is larger than the max size defined.<br>
/// On a MultiValue system, it will also switch the mv.log file if it grows too large.<br>
ClassMethod SwitchConsoleLog() As %Status
{
}

Method %OnValidateObject() As %Status [ Internal ]
{
}

Storage Default
{
<Data name="StartupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CallinHalt</Value>
</Value>
<Value name="3">
<Value>CallinStart</Value>
</Value>
<Value name="4">
<Value>CliSysName</Value>
</Value>
<Value name="5">
<Value>DBSizesAllowed</Value>
</Value>
<Value name="6">
<Value>DefaultPort</Value>
</Value>
<Value name="7">
<Value>DefaultPortBindAddress</Value>
</Value>
<Value name="8">
<Value>EnsembleAutoStart</Value>
</Value>
<Value name="9">
<Value>ErrorPurge</Value>
</Value>
<Value name="10">
<Value>IPv6</Value>
</Value>
<Value name="11">
<Value>JobHalt</Value>
</Value>
<Value name="12">
<Value>JobServers</Value>
</Value>
<Value name="13">
<Value>JobStart</Value>
</Value>
<Value name="14">
<Value>MaxCacheTempSizeAtStart</Value>
</Value>
<Value name="15">
<Value>MaxConsoleLogSize</Value>
</Value>
<Value name="16">
<Value>ProcessHalt</Value>
</Value>
<Value name="17">
<Value>ProcessStart</Value>
</Value>
<Value name="18">
<Value>ShutdownTimeout</Value>
</Value>
<Value name="19">
<Value>TempDirectory</Value>
</Value>
<Value name="20">
<Value>SystemHalt</Value>
</Value>
<Value name="21">
<Value>SystemStart</Value>
</Value>
<Value name="22">
<Value>TerminalPrompt</Value>
</Value>
<Value name="23">
<Value>WebServer</Value>
</Value>
<Value name="24">
<Value>WebServerName</Value>
</Value>
<Value name="25">
<Value>WebServerPort</Value>
</Value>
<Value name="26">
<Value>WebServerURLPrefix</Value>
</Value>
<Value name="27">
<Value>ZSTU</Value>
</Value>
<Value name="28">
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
