Class %BI.WebContacts Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property UsdID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property FName As %String(TRUNCATE = 1);

Property Email As %String(TRUNCATE = 1);

Property Tel As %String(TRUNCATE = 1);

Property Fax As %String(TRUNCATE = 1);

Property Descp As %String(TRUNCATE = 1);

Property Company As %String(TRUNCATE = 1);

Property GroupCon As %String(TRUNCATE = 1);

Index Name On Name;

Index Group On GroupCon;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Company,"Descp",Email,Fax,FName,"GroupCon",Name,Tel 
FROM %BI.WebContacts
}

Storage Default
{
<Data name="WebContactsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Company</Value>
</Value>
<Value name="3">
<Value>Desc</Value>
</Value>
<Value name="4">
<Value>Email</Value>
</Value>
<Value name="5">
<Value>FName</Value>
</Value>
<Value name="6">
<Value>Fax</Value>
</Value>
<Value name="7">
<Value>Group</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Tel</Value>
</Value>
<Value name="10">
<Value>Descp</Value>
</Value>
<Value name="11">
<Value>GroupCon</Value>
</Value>
<Value name="12">
<Value>UsdID</Value>
</Value>
</Data>
<DataLocation>^BI.WebContactsD</DataLocation>
<DefaultData>WebContactsDefaultData</DefaultData>
<IdLocation>^BI.WebContactsD</IdLocation>
<IndexLocation>^BI.WebContactsI</IndexLocation>
<StreamLocation>^BI.WebContactsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
