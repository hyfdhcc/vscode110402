Include %sySystem

Class Provider.Defaults Extends (%Persistent, Provider.CommonMethods, Provider.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index NameLowerCaseIndex On NameLowerCase [ IdKey ];

Property CacheGroup As %String [ InitialExpression = "cacheusr" ];

Property CacheUser As %String [ InitialExpression = "cacheusr" ];

Property InstanceName As %String(MAXLEN = 64, MINLEN = 1) [ InitialExpression = "Cache", Required ];

Property InstallDirectory As %SysPath [ InitialExpression = "/cachesys", Required ];

Property KeyFile As %SysPath;

Property KitDirectory As %SysPath [ InitialExpression = {##Class(%File).SubDirectoryName($zu(12),"kits",1)}, Required ];

Property ManagerGroup As %String [ InitialExpression = "root" ];

Property ManifestDirectory As %SysPath [ InitialExpression = {##Class(%File).SubDirectoryName($zu(12),"manifests",1)}, Required ];

Property Password As %String;

Property SecurityType As %String [ InitialExpression = "Minimal" ];

Property Unicode As %Boolean [ InitialExpression = 1 ];

Property Username As %String(MAXLEN = 64);

ClassMethod Initialize() As %Status [ Internal ]
{
}

Method Validate() As %Status [ Internal ]
{
}

/// Called from %Save().<br>
/// Verify that the property values are ok.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List Defaults.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String = "*") As %Query(ROWSPEC = "InstanceName:%String,InstallDirectory:%String,KitDirectory:%String,ManifestDirectory:%String,Username:%String,KeyFile:%String,ManagerGroup:%String,CacheGroup:%String,CacheUser:%String,SecurityType:%String,Unicode:%Boolean") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
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
<Data name="DefaultsDefaultData">
<Value name="1">
<Value>CacheGroup</Value>
</Value>
<Value name="2">
<Value>CacheUser</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>InstanceName</Value>
</Value>
<Value name="5">
<Value>InstallDirectory</Value>
</Value>
<Value name="6">
<Value>KeyFile</Value>
</Value>
<Value name="7">
<Value>KitDirectory</Value>
</Value>
<Value name="8">
<Value>ManagerGroup</Value>
</Value>
<Value name="9">
<Value>ManifestDirectory</Value>
</Value>
<Value name="10">
<Value>Name</Value>
</Value>
<Value name="11">
<Value>Password</Value>
</Value>
<Value name="12">
<Value>SecurityType</Value>
</Value>
<Value name="13">
<Value>Unicode</Value>
</Value>
<Value name="14">
<Value>Username</Value>
</Value>
</Data>
<DataLocation>^Provider("DefaultsD")</DataLocation>
<DefaultData>DefaultsDefaultData</DefaultData>
<IdLocation>^Provider("DefaultsD")</IdLocation>
<IndexLocation>^Provider("DefaultsI")</IndexLocation>
<StreamLocation>^Provider("DefaultsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
