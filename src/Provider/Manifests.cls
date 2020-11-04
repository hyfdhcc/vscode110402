Include %sySystem

Class Provider.Manifests Extends (%Persistent, Provider.CommonMethods, Provider.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index NameLowerCaseIndex On NameLowerCase [ IdKey ];

Property BuildNumber As %String;

/// Last modification time stamp.<br>
Property ModifiedTimeStamp As %String(MAXLEN = 64) [ ReadOnly ];

Property Platform As %String;

Property Product As %String;

Property Size As %Integer [ ReadOnly ];

Property TarFile As %SysPath;

/// Adhoc, Release, FT
Property Type As %String;

Property Version As %String;

ClassMethod Test(Num As %Integer = 5) As %Status [ Internal ]
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

/// List Manifests.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String,Product:%String,Version:%String,BuildNumber:%String,Platform:%String,Type:%String,Date:%String,Size:%String,TarFile:%String") [ SqlProc ]
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
<Data name="ManifestsDefaultData">
<Value name="1">
<Value>BuildNumber</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ModifiedTimeStamp</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Platform</Value>
</Value>
<Value name="6">
<Value>Product</Value>
</Value>
<Value name="7">
<Value>Size</Value>
</Value>
<Value name="8">
<Value>TarFile</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
<Value name="10">
<Value>Version</Value>
</Value>
</Data>
<DataLocation>^Provider("ManifestsD")</DataLocation>
<DefaultData>ManifestsDefaultData</DefaultData>
<IdLocation>^Provider("ManifestsD")</IdLocation>
<IndexLocation>^Provider("ManifestsI")</IndexLocation>
<StreamLocation>^Provider("ManifestsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
