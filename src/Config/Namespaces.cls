Include %syConfig

/// This class allows you to modify and view the [Namespaces] section of the CPF file through
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
/// %SYS>s Name="ABC"
/// %SYS>s Properties("Globals")="USER"
/// %SYS>s Status=##Class(Config.Namespaces).Create(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.Namespaces).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("Globals")="USER"
/// Properties("Library")="CACHELIB"
/// Properties("Routines")="USER"
/// Properties("SysGlobals")="CACHESYS"
/// Properties("SysRoutines")="CACHESYS"
/// Properties("TempGlobals")="CACHETEMP"
/// %SYS>s Properties("Globals")="SAMPLES"
/// %SYS>s Status=##Class(Config.Namespaces).Modify(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.Namespaces).Open(Name)
/// ; We could have used i ##Class(Config.Namespaces).Exists(Name,.Obj) instead of Open()
/// %SYS>w Obj.Globals
/// SAMPLES
/// %SYS>s Obj.Routines="USER"
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.Namespaces).Delete(Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.Namespaces Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Namespace name is always capitalized.<br>
Parameter CAPITALNAME = 1;

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// Default database for globals.<br>
Property Globals As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Force the Globals name to be uppercase.<br>
Method GlobalsSet(Val) As %Status [ Internal ]
{
}

/// Default database for system library routines.<br>
Property Library As %String(MAXLEN = 64, MINLEN = 1) [ InitialExpression = "CACHELIB", Required ];

/// Force Library name to be uppercase.<br>
Method LibrarySet(Val) As %Status [ Internal ]
{
}

/// Force the Namespace name to be uppercase.<br>
Method NameSet(Val) As %Status [ Internal ]
{
}

/// Default database for routines.<br>
Property Routines As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Force the Routines name to be uppercase.<br>
Method RoutinesSet(Val) As %Status [ Internal ]
{
}

/// Default database for system globals.<br>
Property SysGlobals As %String(MAXLEN = 64, MINLEN = 1) [ InitialExpression = "CACHESYS", Required ];

/// Force the system globals to be uppercase.<br>
Method SysGlobalsSet(Val) As %Status [ Internal ]
{
}

/// Default database for system routines.<br>
Property SysRoutines As %String(MAXLEN = 64, MINLEN = 1) [ InitialExpression = "CACHESYS", Required ];

/// Force the system routines name to be uppercase.<br>
Method SysRoutinesSet(Val) As %Status [ Internal ]
{
}

/// Default database for temporary globals.<br>
Property TempGlobals As %String(MAXLEN = 64, MINLEN = 1) [ InitialExpression = "CACHETEMP", Required ];

/// Force the temporary globals name to be uppercase.<br>
Method TempGlobalsSet(Val) As %Status [ Internal ]
{
}

/// Copy a namespace to new namespace including mappings, and activate them.<br>
/// Parameters:<br>
/// <b>SourceNamespace</b> - Namespace to copy.<br>
/// <b>DestinationNamespace</b> - New namespace to copy to.<br>
/// <b>CPFFile</b> - Name of the CPF file to copy mappings in, "" = active CPF file.<br>
/// <b>Flags</b> - Not used.<br>
/// <b>CopyMappings</b> - Whether to call CopyMaps. 1 by default. (0 for SMP page because mappings are copied in the background.)<br>
ClassMethod Copy(SourceNamespace, DestinationNamespace, CPFFile As %String = "", Flags As %Integer = 0, CopyMappings As %Boolean = 1) As %Status [ Internal ]
{
}

/// Copy all mapping from a namespace to another namespace, and activate them.<br>
/// Parameters:<br>
/// <b>SourceNamespace</b> - Source of the namespace mappings to copy.<br>
/// <b>DestinationNamespace</b> - namespace to copy mappings to. Namespace must already exist.<br>
/// <b>CPFFile</b> - name of the CPF file to copy mappings in.<br>
ClassMethod CopyMaps(SourceNamespace, DestinationNamespace, CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Write a default Namespaces section in a CPF file.<br>
/// This method assumes that a CPF file has been opened, and that a U CPFFile command
/// has been executed before this is called.
ClassMethod Default(CPFFile As %String, Platform As %String) As %Status [ Internal ]
{
}

/// Returns a list of namespaces that reference a given database.<br>
/// If CheckSynonyms is true, the search is also performed for all datasets that reference
/// the same .DAT file. Otherwise, the search is only performed for the given datset name.<br>
/// If Mappings is defined and different than zero, then the following array is returned in addition:
/// When Mappings value is 1, it returned the mappings for the namespaces DO NOT include the database for its definition.
/// When Mappings value is 2, it also returned the mappings for the namespaces include the database for its definition.
/// When Mappings value is 3, only check against default routine and default global database, and don't return mappings.
/// Mappings(<nsp>,"GBL",<global>,<subscripts>)=""
/// Mappings(<nsp>,"RTN",<routine>,<type>)=""
/// Mappings(<nsp>,"CLS",<class>,<library>)=""
ClassMethod NamespacesByDB(Name As DBName, ByRef NspList As %String, CheckSynonyms As %Boolean = 1, ByRef Mappings As %String, CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Return a list of namespaces which contain the database in its mappings.<br>
/// Parameters:<br>
/// Server - ECP Server where the directory resides. Default = "" (Local system)<br>
/// Directory - Directory where the database resides<br>
/// Flags = 1 - Check only default global and default routine database for each namespace<br>
/// Flags = 2 - Check all databases and mappings for each namespace<br>
/// Return values:<br>
/// Namespaces(Name)=""<br>
/// Note: This function is useful for taking an implied namespace, and determining which
/// namespaces reference its database. For example, given an implied namespace of
/// nsp="^^C:\cache\mgr\" (Manager directory), NamespacesByDir($p(nsp,"^",1),$p(nsp,"^,3),1,.Namespaces)
/// will return Namespaces("%SYS").<br>
/// Note that if a Server is specified, then the Directory specified must be in the same case as defined
/// on the server as no directory normalization is performed for remote databases.
ClassMethod NamespacesByDir(Server As %String = "", Directory As %String, Flags As %Integer = 1, ByRef Namespaces As %String) As %Status [ Internal ]
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the namespace of the item which was deleted
/// since the oject itself has already been deleted. Note that Obj can either be
/// a Config.Namespace object or a Config.Map* object.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Build the ^SYS("NSMAP") global based on the ^CONFIG global.<br>
ClassMethod LoadMappings(Namespace = "") As %Status [ Internal, Private ]
{
}

/// Activate All NameSpaces mapping from the ^SYS("NSMAP") global.<br>
ClassMethod ActivateAll() As %Status [ Internal ]
{
}

/// Activate one specific NameSpace mapping from the ^SYS("NSMAP") global.<br>
ClassMethod ActivateOne(Namespace) As %Status [ Internal ]
{
}

/// Called from  %Delete().<br>
/// Any error returned here will keep the object from being deleted.<br>
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status [ Internal ]
{
}

/// Move the CPF data into the active config global. This also check if any namespace is added/removed/updated in CPF file since last shutdown.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Placeholder for Map classes. Pass as "".<br>
ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Rename a namespace to new namespace including mappings, and activate them.<br>
/// Parameters:<br>
/// <b>OldNamespace</b> - Namespace to rename.<br>
/// <b>NewNamespace</b> - New namespace to copy to.<br>
/// <b>CPFFile</b> - Name of the CPF file to copy mappings in, "" = active CPF file.<br>
ClassMethod Rename(OldNamespace, NewNamespace, CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// This is called from %Save().<br>
/// Any error returned from this will cause the object to not be saved.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List Namespaces in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Namespace names<br>
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
Query List(Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Namespace:%String,Globals:%String,Routines:%String,System Globals:%String,System Routines:%String,Library:%String,Temp Storage:%String") [ SqlProc ]
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

/// List Namespaces in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Filter</b> - Filter to select columns<br>
/// <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
/// <b>Flags</b> - Currently ignored.<br>
/// <b>Format</b> <br>
/// <var>0</var> - Standard report list format<br>
/// <var>1</var> - ^CONFIG global format<br>
/// <var>2</var> - CPF file format format<br>
/// Note: This query may change in future versions<br>
Query ListFilter(Filter As %String = "", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Namespace:%String,Globals:%String,Routines:%String,System Globals:%String,System Routines:%String,Library:%String,Temp Storage:%String") [ SqlProc ]
{
}

ClassMethod ListFilterExecute(ByRef qHandle As %Binary, Filter As %String = "", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListFilterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

ClassMethod ListFilterClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

Storage Default
{
<Data name="NamespaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comments</Value>
</Value>
<Value name="3">
<Value>Globals</Value>
</Value>
<Value name="4">
<Value>Library</Value>
</Value>
<Value name="5">
<Value>Routines</Value>
</Value>
<Value name="6">
<Value>SysGlobals</Value>
</Value>
<Value name="7">
<Value>SysRoutines</Value>
</Value>
<Value name="8">
<Value>TempGlobals</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>NamespaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
