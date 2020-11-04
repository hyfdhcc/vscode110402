Include (%syConfig, %sySite)

/// This class allows you to modify and view the [Monitor] section of the CPF file through
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
/// %SYS>s Status=##Class(Config.Monitor).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("PatrolCollectionInterval")=30
/// Properties("PatrolDisplayMode")=0
/// Properties("PatrolEnabled")=0
/// Properties("PatrolTopProcesses")=20
/// Properties("SNMPEnabled")=0
/// Properties("WMIEnabled")=0
/// %SYS>s Properties("PatrolCollectionInterval")=40
/// %SYS>s Status=##Class(Config.Monitor).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.Monitor).Open()
/// %SYS>w Obj.PatrolCollectionInterval
/// 40
/// %SYS>s Obj.PatrolCollectionInterval=60
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.Monitor Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Enter the number of seconds between each time the system collects data and sends it to Patrol.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property PatrolCollectionInterval As %Integer(MAXVAL = 900, MINVAL = 1) [ InitialExpression = 30, Required ];

/// Control how the metric data is displayed in the Patrol console.<br>
/// 0 - 'Total' displays the total counts since the collection was started.<br>
/// 1 - 'Delta' displays the count for the last collection period.<br>
/// 2 - 'Rate' displays a calculated count per second.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property PatrolDisplayMode As %Integer(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0, Required ];

/// Aautomatically starts the connection to Patrol when the system is started.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property PatrolEnabled As %Boolean [ InitialExpression = 0, Required ];

/// Number of processes to be displayed in the Process Status window on the Patrol console.<br>
/// This will show the top processes as sorted by global or routine.<br>
/// A value of 0 tells the PATROL utility to stop calculating the top processes.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property PatrolTopProcesses As %Integer(MAXVAL = 10000, MINVAL = 0) [ InitialExpression = 20, Required ];

/// Automatically starts the SNMP agent when the system is started.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property SNMPEnabled As %Boolean [ InitialExpression = 0, Required ];

/// Identifies this configuration as one that should be monitored by the WMI DLL.<br>
/// <br><br>
/// Modifying this property will require a restart of the system to make it active.
Property WMIEnabled As %Boolean [ InitialExpression = 0, Required ];

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status
{
}

Storage Default
{
<Data name="MonitorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comments</Value>
</Value>
<Value name="3">
<Value>PatrolDisplayMode</Value>
</Value>
<Value name="4">
<Value>PatrolEnabled</Value>
</Value>
<Value name="5">
<Value>PatrolTopProcesses</Value>
</Value>
<Value name="6">
<Value>SNMPEnabled</Value>
</Value>
<Value name="7">
<Value>WMIEnabled</Value>
</Value>
<Value name="8">
<Value>PatrolCollectionInterval</Value>
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
