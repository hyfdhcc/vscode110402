Class %BI.SMrTask Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Name As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Property Folder As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property TaskScript As %String(MAXLEN = 5000, TRUNCATE = 1);

Query AllTasks() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,Folder,TaskScript,Description,Type FROM SMrTask
ORDER BY Name
}

Storage Default
{
<Data name="SMrTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>TaskScript</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^BI.SMrTaskD</DataLocation>
<DefaultData>SMrTaskDefaultData</DefaultData>
<IdLocation>^BI.SMrTaskD</IdLocation>
<IndexLocation>^BI.SMrTaskI</IndexLocation>
<StreamLocation>^BI.SMrTaskS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
