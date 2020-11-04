Include %syConfig

/// This class allows you to modify and view the [DeviceSubTypes] section of the CPF file through
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
/// %SYS>s Name="P-NEW"
/// %SYS>s Properties("Backspace")="$C(8)"
/// %SYS>s Properties("FormFeed")="#"
/// %SYS>s Properties("RightMargin")=132
/// %SYS>s Properties("ScreenLength")=66
/// %SYS>s Status=##Class(Config.DeviceSubTypes).Create(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.DeviceSubTypes).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("FormFeed")
/// Properties("FormFeed")="#"
/// %SYS>s Properties("FormFeed")="#,#"
/// %SYS>s Status=##Class(Config.DeviceSubTypes).Modify(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.DeviceSubTypes).Open(Name)
/// ; We could have used i ##Class(Config.DeviceSubTypes).Exists(Name,.Obj) instead of Open()
/// %SYS>w Obj.FormFeed
/// #,#
/// %SYS>s Obj.FormFeed="#"
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.DeviceSubTypes).Delete(Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.DeviceSubTypes Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Enter the ASCII code that represents the backspace character on the selected<br>
/// device in this form: $C(code1). Default depends on the device type.<br>
Property Backspace As %String(MAXLEN = 128, MINLEN = 0);

/// Enter the cursor control keys for the selected device.<br>
/// Default depends on the device type.<br>
Property CursorControl As %String(MAXLEN = 128, MINLEN = 0);

/// Enter the ASCII code that represents erasing to the end of file on the<br>
/// selected device in this form: $C(code1,code2...).<br>
/// Default depends on the device type.<br>
Property EraseEOF As %String(MAXLEN = 128, MINLEN = 0);

/// Enter the ASCII code that represents erasing to the end of line on this device<br>
/// in the form $C(code1,code2).<br>
/// Default depends on the device type.<br>
Property EraseEOL As %String(MAXLEN = 128, MINLEN = 0);

/// Enter the ASCII code that represents a form feed on the selected device in this form:<br>
/// #,$C(code1,code2...).<br>
/// Default depends on the device type.<br>
Property FormFeed As %String(MAXLEN = 128, MINLEN = 0);

/// Enter the number that represents the location of the right margin.<br>
/// Device output will wrap at that number of characters.<br>
/// Default depends on the device type.<br>
Property RightMargin As %Integer(MAXVAL = 256, MINVAL = 0) [ InitialExpression = 80 ];

/// Enter the number of lines that comprise one screen or page for the device.<br>
Property ScreenLength As %Integer [ InitialExpression = 0, Required ];

/// Enter the ASCII code that represents a backspace on the selected device in the form $C(code).<br>
/// Default depends on the device type.<br>
Property ZU22Backspace As %String(MAXLEN = 128, MINLEN = 0);

/// Enter the ASCII code that represents a form feed on the selected device in the form $C(code1,code2).<br>
/// Default depends on the device type.<br>
Property ZU22FormFeed As %String(MAXLEN = 128, MINLEN = 0);

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Write a default DeviceSubTypes section in a CPF file.<br>
/// This method assumes that a CPF file has been opened, and that a U CPFFile command
/// has been executed before this is called.
ClassMethod Default(CPFFile As %String, Platform As %String) As %Status [ Internal ]
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

/// List DeviceSubTypes in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of DeviceSubType names<br>
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
Query List(Names As %String, CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,RightMargin:%Integer,FormFeed:%String,ScreenLength:%Integer,Backspace:%String,CursorControl:%String,EraseEOL:%String,EraseEOF:%String,ZU22FormFeed:%String,ZU22Backspace:%String") [ SqlProc ]
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
<Data name="DeviceSubTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Backspace</Value>
</Value>
<Value name="3">
<Value>CursorControl</Value>
</Value>
<Value name="4">
<Value>EraseEOF</Value>
</Value>
<Value name="5">
<Value>EraseEOL</Value>
</Value>
<Value name="6">
<Value>FormFeed</Value>
</Value>
<Value name="7">
<Value>RightMargin</Value>
</Value>
<Value name="8">
<Value>ScreenLength</Value>
</Value>
<Value name="9">
<Value>ZU22Backspace</Value>
</Value>
<Value name="10">
<Value>ZU22FormFeed</Value>
</Value>
<Value name="11">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>DeviceSubTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
