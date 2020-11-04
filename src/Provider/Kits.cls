Include %sySystem

Class Provider.Kits Extends (%Persistent, Provider.CommonMethods, Provider.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index NameLowerCaseIndex On NameLowerCase [ IdKey ];

Property BuildNumber As %String [ ReadOnly ];

/// Last modification time stamp.<br>
Property ModifiedTimeStamp As %String(MAXLEN = 64) [ ReadOnly ];

Property Platform As %String [ ReadOnly ];

Property Product As %String [ ReadOnly ];

Property Size As %Integer [ ReadOnly ];

Property TarFile As %String(MAXLEN = 256);

/// Adhoc, Release, FT
Property Type As %String [ ReadOnly ];

Property Version As %String [ ReadOnly ];

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

/// List kits.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String = "*") As %Query(ROWSPEC = "Name:%String,Description:%String,Product:%String,Version:%String,BuildNumber:%String,Platform:%String,Type:%String,Date:%String,Size:%String,TarFile:%String") [ SqlProc ]
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
<Data name="KitsDefaultData">
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
<DataLocation>^Provider("KitsD")</DataLocation>
<DefaultData>KitsDefaultData</DefaultData>
<IdLocation>^Provider("KitsD")</IdLocation>
<IndexLocation>^Provider("KitsI")</IndexLocation>
<StreamLocation>^Provider("KitsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
