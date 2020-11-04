Include %syConfig

/// This class allows you to modify and view class package mappings in the [Map.xxx] section of the CPF file through
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
/// ; Use class methods to create a package mapping in namespace USER to the SAMPLES database
/// %SYS>s Namespace="USER"
/// %SYS>s Name="PackageA"
/// %SYS>s Properties("Database")="SAMPLES"
/// %SYS>s Status=##Class(Config.MapPackages).Create(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.MapPackages).Get(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("Database")="SAMPLES"
/// %SYS>s Properties("Database")="TEST"
/// %SYS>s Status=##Class(Config.MapPackages).Modify(Namespace,Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.MapPackages).Open(Namespace,Name)
/// ; We could have used i ##Class(Config.MapPackages).Exists(Namespace,Name,.Obj) instead of Open()
/// %SYS>w Obj.Database
/// TEST
/// %SYS>s Obj.Database="SAMPLES"
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.MapPackages).Delete(Namespace,Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.MapPackages Extends (%Persistent, Config.CommonMapMethods, Config.CommonMapProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderNspName On (CPFName, SectionHeader, Namespace, Name) [ IdKey, Unique ];

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// Database to map Package to.<br>
Property Database As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Force the Database name to be uppercase.<br>
Method DatabaseSet(Val) As %Status [ Internal ]
{
}

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// This method is called from %Save().<br>
/// Any error returned here will cause the object not to be saved.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List MapPackages in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of MapPackage names<br>
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
Query List(Namespace As %String, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Package:%String,Database:%String") [ SqlProc ]
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

/// Get a list of all packaged in a database.<br>
/// Parameters:<br>
/// <b>Database</b> - Database name to get list of packages from.<br>
Query ListPackages(Database As %String) As %Query(ROWSPEC = "Name:%String") [ SqlProc ]
{
}

ClassMethod ListPackagesExecute(ByRef qHandle As %Binary, Database) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListPackagesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListPackagesExecute ]
{
}

ClassMethod ListPackagesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListPackagesExecute ]
{
}

Storage Default
{
<Data name="MapPackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Database</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MapPackageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
