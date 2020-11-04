Include %sySystem

Class Provider.Installs Extends (%Persistent, Provider.CommonMethods, Provider.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index NameLowerCaseIndex On NameLowerCase [ IdKey ];

Property Kit As %String(MAXLEN = 64, MINLEN = 0);

Property Manifest As %String(MAXLEN = 64, MINLEN = 0);

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

/// List Installs.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String,Kit:%String,Manifest:%String") [ SqlProc ]
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
<Data name="InstallsDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>Manifest</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Kit</Value>
</Value>
</Data>
<DataLocation>^Provider("InstallsD")</DataLocation>
<DefaultData>MachinesDefaultData</DefaultData>
<IdLocation>^Provider("InstallsD")</IdLocation>
<IndexLocation>^Provider("InstallsI")</IndexLocation>
<StreamLocation>^Provider("InstallsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
