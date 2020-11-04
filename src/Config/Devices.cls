Include (%syConfig, DEVICE)

/// This class allows you to modify and view the [Devices] section of the CPF file through
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
/// %SYS>s Name="NewDevice"
/// %SYS>s Properties("PhysicalDevice")=0
/// %SYS>s Properties("SubType")="C-Cache Terminal"
/// %SYS>s Properties("Type")="TRM"
/// %SYS>s Status=##Class(Config.Devices).Create(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.Devices).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("SubType")
/// Properties("SubType")="C-Cache Terminal"
/// %SYS>s Properties("SubType")="C-VT220"
/// %SYS>s Status=##Class(Config.Devices).Modify(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.Devices).Open(Name)
/// ; We could have used i ##Class(Config.Devices).Exists(Name,.Obj) instead of Open()
/// %SYS>w Obj.SubType
/// C-VT220
/// %SYS>s Obj.SubType="C-VT440"
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.Devices).Delete(Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.Devices Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Alternate device ID (number) for this device. <br>
/// All aliases must be unique. You can use this value to specify a device in an OPEN command, e.g 0PEN 210<br>
Property Alias As %Integer(MINVAL = 1);

/// Device ID of an alternate device.<br>
/// This allows a user using %IS to specify A as the device.
/// The alternate device must be a defined mnemonic.<br>
Property AlternateDevice As %String(MAXLEN = 128, MINLEN = 0);

/// Enter a description of where the device is located. This field is for your<br>
/// own reference to help you identify what machine you're configuring.<br>
Property Description As %String(MAXLEN = 256, MINLEN = 0);

/// Values that will be sent as the second argument for an OPEN command.<br>
/// This value allows you to specify more specific terminal information.<br>
Property OpenParameters As %String(MAXLEN = 128, MINLEN = 0);

/// Physical device name used to refer to the device.<br>
Property PhysicalDevice As %String(MAXLEN = 128, MINLEN = 1) [ Required ];

/// Number of the prompt option desired.<br>
/// Options:<br>
/// NULL (blank) = user sees the device selection prompt with the default device defined<br>
/// 1 = automatically uses this device, if it is the current device<br>
/// 2 = automatically uses this device with predefined Right Margin and Parameter settings.<br>
Property Prompt As %Integer(MAXVAL = 2, MINVAL = 1);

/// Options to refine the definition of your device SubTypes.<br>
/// SubTypes specify terminal charactistics. They are used to create the appropriate
/// OPEN command for the device. There should be SubType information for every terminal type.<br>
Property SubType As %String(MAXLEN = 128, MINLEN = 1) [ Required ];

/// Enter the type of device.<br>
/// Options:<br>
/// TRM = Terminal<br>
/// SPL = Spooling device<br>
/// MT = Magnetic Tape drive<br>
/// BT = Cartridge tape drive<br>
/// IPC = Interprocess communication<br>
/// OTH = any other device including printers and sequential files.<br>
/// Default depends on the device type.<br>
Property Type As %String(MAXLEN = 3, MINLEN = 2) [ Required ];

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Write a default Devices section in a CPF file.<br>
/// This method assumes that a CPF file has been opened, and that a U CPFFile command
/// has been executed before this is called.
ClassMethod Default(CPFFile As %String) As %Status [ Internal ]
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

/// Called from %Save().<br>
/// Verify that the property values are ok.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List Devices in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
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
Query List(Names As %String, CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,PhysicalDevice:%String,Type:%String,SubType:%String,Prompt:%String,OpenParameters:%String,AlternateDevice:%String,Description:%String,Alias:%String") [ SqlProc ]
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
<Data name="DeviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Alias</Value>
</Value>
<Value name="3">
<Value>AlternateDevice</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>OpenParameters</Value>
</Value>
<Value name="6">
<Value>PhysicalDevice</Value>
</Value>
<Value name="7">
<Value>Prompt</Value>
</Value>
<Value name="8">
<Value>SubType</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
<Value name="10">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>DeviceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
