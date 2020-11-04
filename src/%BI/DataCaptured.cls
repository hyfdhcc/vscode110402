Class %BI.DataCaptured Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Filter As array Of DatFilter;

Property dClass As %String(TRUNCATE = 1);

Property dName As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,dName,dClass
FROM %BI.DataCaptured
}

Storage Default
{
<Data name="DataCapturedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Filter</Value>
</Value>
<Value name="3">
<Value>dClass</Value>
</Value>
<Value name="4">
<Value>dName</Value>
</Value>
</Data>
<DataLocation>^BI.DataCapturedD</DataLocation>
<DefaultData>DataCapturedDefaultData</DefaultData>
<IdLocation>^BI.DataCapturedD</IdLocation>
<IndexLocation>^BI.DataCapturedI</IndexLocation>
<StreamLocation>^BI.DataCapturedS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
