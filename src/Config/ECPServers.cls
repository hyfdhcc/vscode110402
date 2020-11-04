Include %syConfig

/// This class allows you to modify and view the [ECPServers] section of the CPF file through
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
/// %SYS>s Name="SERVERA"
/// %SYS>s Properties("Address")="127.0.0.10"
/// %SYS>s Status=##Class(Config.ECPServers).Create(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.ECPServers).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("Address")="127.0.0.1"
/// Properties("Port")=1973
/// %SYS>s Properties("Port")=1972
/// %SYS>s Status=##Class(Config.ECPServers).Modify(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.ECPServers).Open(Name)
/// ; We could have used i ##Class(Config.ECPServers).Exists(Name,.Obj) instead of Open()
/// %SYS>w Obj.Port
/// 1972
/// %SYS>s Obj.Port=1975
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.ECPServers).Delete(Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.ECPServers Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Server name is always capitalized.<br>
Parameter CAPITALNAME = 1;

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// IP Address to connect to.<br>
Property Address As Config.Host(MAXLEN = 256, MINLEN = 1) [ Required ];

/// Force the Server name to be uppercase.<br>
Method NameSet(Val) As %Status [ Internal ]
{
}

/// Connection is to a mirror set.<br>
Property MirrorConnection As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

/// IP Port to connect to.<br>
Property Port As %Integer [ InitialExpression = 1972, Required ];

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

/// handle ECP definitions.<br>
ClassMethod NetIsECP(Name As %String, Data As %String) As %Status [ Internal ]
{
}

ClassMethod ValidateIP(host As %String) As %String [ Internal ]
{
}

ClassMethod Debug() [ Internal ]
{
}

/// Called from %OnDelete().<br>
/// Any error returned here will cause the delete to fail.<br>
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status [ Internal ]
{
}

/// This method is called during %Save().<br>
/// Any error returned here will cause the save to fail.<br<
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List ECPServers in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of ECPServer names<br>
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
Query List(Names As %String, CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Address:%String,Port:%Integer,MirrorConnection:%Integer") [ SqlProc ]
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

/// Return the status of ECP servers.<br>
/// Internal use only.<br>
Query StatusList() As %Query(ROWSPEC = "Name:%String,RemoteAddress:%String,RemotePort:%Integer,MirrorConnection:%Integer,Status:%String,StatusEnglish:%String") [ Internal ]
{
}

ClassMethod StatusListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod StatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = StatusListExecute ]
{
}

ClassMethod StatusListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = StatusListExecute ]
{
}

/// Return the status of ECP servers for SMP display.<br>
/// Internal use only.<br>
Query StatusListSMP() As %Query(ROWSPEC = "Name:%String,RemoteAddress:%String,RemotePort:%Integer,Status:%String,StatusEnglish:%String,MirrorConnection:%String") [ Internal ]
{
}

ClassMethod StatusListSMPExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod StatusListSMPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = StatusListSMPExecute ]
{
}

ClassMethod StatusListSMPClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = StatusListSMPExecute ]
{
}

Query StatusListSMPFilter(Filter As %String = "") As %Query(ROWSPEC = "Name:%String,RemoteAddress:%String,RemotePort:%Integer,Status:%String,StatusEnglish:%String,MirrorConnection:%String") [ Internal ]
{
}

ClassMethod StatusListSMPFilterExecute(ByRef qHandle As %Binary, Filter As %String = "") As %Status [ Internal ]
{
}

ClassMethod StatusListSMPFilterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = StatusListSMPFilterExecute ]
{
}

ClassMethod StatusListSMPFilterClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = StatusListSMPFilterExecute ]
{
}

Storage Default
{
<Data name="ECPServerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comments</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
<Value name="4">
<Value>MirrorConnection</Value>
</Value>
<Value name="5">
<Value>Port</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>ECPServerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
