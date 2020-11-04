Class %BI.WorkFlow Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property WorkName As %String(MAXLEN = 100, TRUNCATE = 1);

Property Folder As %String(TRUNCATE = 1);

Property FlowStart As %String(TRUNCATE = 1);

Property PreLoadCondition As %String(MAXLEN = 10000, TRUNCATE = 1);

Property PostLoadCondition As %String(MAXLEN = 10000, TRUNCATE = 1);

Property WFlowObj As array Of WorkFlowObj;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,WorkName,Folder
FROM %BI.WorkFlow
ORDER BY WorkName
}

Query ListFolder(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,WorkName
FROM %BI.WorkFlow
WHERE (Folder = :folder)
ORDER BY WorkName
}

Storage Default
{
<Data name="CLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"x"</Subscript>
</Data>
<Data name="WFlowObj">
<Attribute>WFlowObj</Attribute>
<Structure>subnode</Structure>
<Subscript>"WF"</Subscript>
</Data>
<Data name="WorkFlowDefaultData">
<Value name="1">
<Value>WorkName</Value>
</Value>
<Value name="2">
<Value>FlowStart</Value>
</Value>
<Value name="3">
<Value>PostLoadCondition</Value>
</Value>
<Value name="4">
<Value>PreLoadCondition</Value>
</Value>
<Value name="5">
<Value>Folder</Value>
</Value>
</Data>
<DataLocation>^BI.WorkFlowD</DataLocation>
<DefaultData>WorkFlowDefaultData</DefaultData>
<IdLocation>^BI.WorkFlowD</IdLocation>
<IndexLocation>^BI.WorkFlowI</IndexLocation>
<StreamLocation>^BI.WorkFlowS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
