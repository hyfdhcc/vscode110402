Include (%syConfig, SHDW)

/// This class allows you to modify and view global mappings in the [Map.xxx] section of the CPF file through
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
/// </pre>
Class Config.MapShadows Extends (%Persistent, Config.GenericMapMethods, Config.GenericMapProperties, %SYSTEM.Help) [ Final, Inheritance = right, LegacyInstanceContext, System = 4 ]
{

Index CPFNameSectionHeaderIDName On (CPFName, SectionHeader, ID, Name) [ IdKey, Unique ];

/// Determines if the Name specified in the index should be capitalized.<br>
Parameter CAPITALNAME = 0;

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// Database to map global to.<br>
Property Directory As %SysPath [ Required ];

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

ClassMethod WriteSection(CPFFile As %String) As %Status [ Internal ]
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the shadow of the item which was deleted
/// since the oject itself has already been deleted. Note that Obj can either be
/// a Config.Shadows object or a Config.Map* object.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Stub method, may be overwritten by the individual class.
ClassMethod %OnBeforeSaveCallBack(insert As %Integer, Obj As %ObjectHandle) As %Status [ Internal, Private ]
{
}

/// Called from  %Delete().<br>
/// Any error returned here will keep the object from being deleted.<br>
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status
{
}

/// List MapGlobals in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of MapGlobal names<br>
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
Query List(ID As %String, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Directory:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, ID As %String, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
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
<Data name="MapShadowsDefaultData">
<Value name="1">
<Value>Directory</Value>
</Value>
<Value name="2">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MapShadowsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
