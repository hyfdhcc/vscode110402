Include %syConfig

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
/// ; Use class methods to create a global mapping in namespace USER to the SAMPLES database
/// %SYS>s Namespace="USER"
/// %SYS>s Name="ABC"
/// %SYS>s Properties("Database")="SAMPLES"
/// %SYS>s Status=##Class(Config.MapGlobals).Create(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now add a SLM mapping for a global XYZ(100). Note that two mappings will actually
/// ; get created, a mapping of XYZ to namespace USER, and XYZ(100) to SAMPLES. We need this
/// ; because the main mapping of XYZ will contain the collation of the entire global
/// ; (which is 5 by default, Cache Standard collation)
/// %SYS>s Namespace="USER"
/// %SYS>s Name="XYZ(100)"
/// %SYS>s Properties("Database")="SAMPLES"
/// %SYS>s Status=##Class(Config.MapGlobals).Create(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.MapGlobals).Get(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("Collation")=5
/// Properties("Database")="SAMPLES"
/// Properties("LockDatabase")=""
/// %SYS>s Properties("Database")="TEST"
/// %SYS>s Status=##Class(Config.MapGlobals).Modify(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.MapGlobals).Open(Namespace,Name)
/// ; We could have used i ##Class(Config.MapGlobals).Exists(Namespace,Name,.Obj) instead of Open()
/// %SYS>w Obj.Database
/// TEST
/// %SYS>s Obj.Database="USER"
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.MapGlobals).Delete(Namespace,Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.MapGlobals Extends (%Persistent, Config.CommonMapMethods, Config.CommonMapProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderNspName On (CPFName, SectionHeader, Namespace, Name) [ IdKey, Unique ];

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// Default collation of the global
Property Collation As %Integer(MINVAL = 0) [ InitialExpression = 5, Required ];

/// Database to map global to.<br>
Property Database As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Force the Database name to be uppercase.<br>
Method DatabaseSet(Val) As %Status [ Internal ]
{
}

/// Database to map global lock to.<br>
Property LockDatabase As %String(MAXLEN = 64, MINLEN = 0);

/// Force the Lock Database name to be uppercase.<br>
Method LockDatabaseSet(Val) As %Status [ Internal ]
{
}

/// Check whether the input Global Name Mapping entry could cause overlap in the current configuration.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace of the global mapping to be checked.<br>
/// <b>Entry</b> - a Global Name mapping entry to be checked before it is added to the configuration.<br>
/// <var>""</var> - Check all global name mapping in the namespace.<br>
/// <var>GlobalNameMapping)</var> - Check the specific Global Name Mappig entry to be added to the configuration.<br>
/// <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
/// <br>Returns true if there is no mapping overlap. Otherwise return false with error informtion.<br>
ClassMethod CheckGlobalMapOverlap(Namespace As %String, Entry As %String = "", CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Check whether the input SLM entry could cause overlap in the current configuration.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace of the global mapping to be checked.<br>
/// <b>Entry</b> - a SLM entry to be checked before it is added to the configuration.<br>
/// <var>""</var> - Check all SLM mapping for all current configured globals in the namespace.<br>
/// <var>GlobalName</var> - Check the SLM entries for specific global configured.<br>
/// <var>GlobalName(...)</var> - Check the specific SLM entry (with subscript) to be added to the configuration.<br>
/// <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
/// <br>Returns true if there is no SLM overlap. Otherwise return false with error informtion.<br>
ClassMethod CheckSLMOverlap(Namespace As %String, SLMEntry As %String = "", CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Returns true if the argument passes the Subscript/Sbscript range syntax check.<br>
/// Internal use only.<br>
/// Note that this is also called by EMS, and shouldn't reference any %SYS Config info
ClassMethod IsValidSubscript(Sub As %String, Collation As %Integer = 5) As %Status
{
}

/// Called from %Save().<br>
/// Set some fields to their defaults, and normalize begin:end.<br>
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
}

/// Called from  %Delete().<br>
/// Any error returned here will keep the object from being deleted.<br>
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status
{
}

/// This is called from %Save().<br>
/// Any error returned from this will cause the object to not be saved.<br>
Method %OnValidateObject() As %Status [ Internal ]
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
Query List(Namespace As %String, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Global:%String,Subscript:%String,Database:%String,Collation:%Integer,LockDatabase:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Namespace As %String, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute, PublicList = qHandle ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute, PublicList = qHandle ]
{
}

Storage Default
{
<Data name="MapGlobalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Collation</Value>
</Value>
<Value name="3">
<Value>Database</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>LockDatabase</Value>
</Value>
<Value name="6">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MapGlobalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
