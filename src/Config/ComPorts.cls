Include %syConfig

/// This class allows you to modify and view the [ComPorts] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Create/Get/Modify/Delete) to modify the properties by passing 
/// in the correct parameters, or use Object sytax to open and directly manipulate the config
/// objects (Open() and Exists()). Most objects created here need only to specify the Name of the object, 
/// and 1 or 2 properties since the the defaults are what are commonly used for most cases.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to create an instance
/// %SYS>s Name="COM5:"
/// %SYS>s Properties("BaudRate")=9600
/// %SYS>s Status=##Class(Config.ComPorts).Create(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.ComPorts).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("BaudRate")
/// Properties("BaudRate")=9600
/// %SYS>s Properties("BaudRate")=19200
/// %SYS>s Status=##Class(Config.ComPorts).Modify(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.ComPorts).Open(Name)
/// ; We could have used i ##Class(Config.ComPorts).Exists(Name,.Obj) instead of Open()
/// %SYS>w Obj.BaudRate
/// 19200
/// %SYS>s Obj.BaudRate=38400
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.ComPorts).Delete(Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.ComPorts Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

Parameter CAPITALNAME = 1;

/// Exclude from Config Service for now
Parameter EMSSERVICE [ Internal ] = "XConfig";

/// Baud rate the comm port is set to.<br>
/// 110<br>
/// 300<br>
/// 600<br>
/// 1200<br>
/// 2400<br>
/// 4800<br>
/// 9600<br>
/// 14400<br>
/// 19200<br>
/// 38400<br>
/// 56000<br>
/// 57600<br>
/// 115200<br>
/// 128000<br>
/// 256000<br>
Property BaudRate As %Integer [ InitialExpression = 19200, Required ];

///  "0" - Disabled<br>
///  "1" - Enabled<br>
///  " " - Use Windows Setting<br>
Property DTR As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = " ", Required ];

///  "5" - 5 Data Bits<br>
///  "6" - 6 Data Bits<br>
///  "7" - 7 Data Bits<br>
///  "8" - 8 Data Bits<
///  " " - Use Windows Setting<br>
Property DataBits As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = "8", Required ];

///  "X" - Xon-Xoff<br>
///  "C" - CTS-RTS<br>
///  "D" - DSR-DTR<br>
///  " " - Use Windows Setting<br>
Property FlowControl As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = " ", Required ];

///  "0" - Disabled<br>
///  "1" - Enabled<br>
///  " " - Use Windows Setting<br>
Property ModemControl As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = " ", Required ];

/// Force the name to be uppercase.<br>
Method NameSet(Val) As %Status [ Internal ]
{
}

///  "0" - No Parity<br>
///  "1" - Odd Parity<br>
///  "2" - Even Parity<br>
///  "3" - Mark Parity<br>
///  "4" - Space Parity<br>
///  " " - Use Windows Setting<br>
Property Parity As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = " ", Required ];

///  "1" - 1 Stop Bit<br>
///  "2" - 2 Stop Bits<br>
///  "3" - 1.5 Stop Bits<br>
///  " " - Use Windows Setting<br>
Property StopBits As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = " ", Required ];

///  "0" - Disabled<br>
///  "1" - Enabled<br>
///  " " - Windows Settings<br>
Property ZAError As %String(MAXLEN = 1, MINLEN = 1) [ InitialExpression = " ", Required ];

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the NAME of the item which was deleted
/// since the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// List ComPorts in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of ComPort names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
/// <b>Flags</b> - Currently ignored.<br>
/// <b>Format</b> <br>
/// <var>0</var> - Standard report list format<br>
/// <var>1</var> - ^CONFIG global format<br>
/// <var>2</var> - CPF file format format<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String, CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,ModemControl:%String,DataBits:%String,Parity:%String,StopBits:%String,FlowControl:%String,DTR:%String,ZAError:%String,BaudRate:%Integer") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<Data name="ComPortDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BaudRate</Value>
</Value>
<Value name="3">
<Value>DTR</Value>
</Value>
<Value name="4">
<Value>DataBits</Value>
</Value>
<Value name="5">
<Value>FlowControl</Value>
</Value>
<Value name="6">
<Value>ModemControl</Value>
</Value>
<Value name="7">
<Value>Parity</Value>
</Value>
<Value name="8">
<Value>StopBits</Value>
</Value>
<Value name="9">
<Value>ZAError</Value>
</Value>
<Value name="10">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>ComPortDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
