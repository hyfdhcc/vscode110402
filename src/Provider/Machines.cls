Include %sySystem

Class Provider.Machines Extends (%Persistent, Provider.CommonMethods, Provider.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index NameLowerCaseIndex On NameLowerCase [ IdKey ];

Property DiskSpace As %String [ ReadOnly ];

Property DiskSpaceFree As %String [ ReadOnly ];

Property DNSName As %String [ Required ];

Property KeyFile As %String;

Property Memory As %String [ ReadOnly ];

Property NumCPUs As %Integer [ ReadOnly ];

Property Password As %String;

Property Platform As %String [ ReadOnly ];

Property Username As %String(MAXLEN = 64);

ClassMethod Test(Num As %Integer = 5) As %Status [ Internal ]
{
}

ClassMethod CreateMany(ByRef Properties As %String) As %Status [ Internal ]
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

/// List Machines.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String,DNSName:%String,Platform:%String,Username:%String,KeyFile:%String,Memory:%String,NumCPUs:%Integer,DiskSpace:%String,DiskSpaceFree:%String") [ SqlProc ]
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
<Data name="MachinesDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>DiskSpace</Value>
</Value>
<Value name="3">
<Value>DiskSpaceFree</Value>
</Value>
<Value name="4">
<Value>DNSName</Value>
</Value>
<Value name="5">
<Value>KeyFile</Value>
</Value>
<Value name="6">
<Value>Memory</Value>
</Value>
<Value name="7">
<Value>Name</Value>
</Value>
<Value name="8">
<Value>NumCPUs</Value>
</Value>
<Value name="9">
<Value>Password</Value>
</Value>
<Value name="10">
<Value>Platform</Value>
</Value>
<Value name="11">
<Value>Username</Value>
</Value>
</Data>
<DataLocation>^Provider("MachinesD")</DataLocation>
<DefaultData>MachinesDefaultData</DefaultData>
<IdLocation>^Provider("MachinesD")</IdLocation>
<IndexLocation>^Provider("MachinesI")</IndexLocation>
<StreamLocation>^Provider("MachinesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
