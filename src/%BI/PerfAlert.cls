Class %BI.PerfAlert Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Folder As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property PerfMat As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,Folder FROM PerfAlert
ORDER BY Name
}

Storage Default
{
<Data name="PerfAlertDefaultData">
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
<Value>PerfMat</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^BI.PerfAlertD</DataLocation>
<DefaultData>PerfAlertDefaultData</DefaultData>
<IdLocation>^BI.PerfAlertD</IdLocation>
<IndexLocation>^BI.PerfAlertI</IndexLocation>
<StreamLocation>^BI.PerfAlertS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
