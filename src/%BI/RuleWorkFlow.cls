Class %BI.RuleWorkFlow Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property WorkName As %String(MAXLEN = 100, TRUNCATE = 1);

Property Folder As %String(TRUNCATE = 1);

Property FlowStart As %String(TRUNCATE = 1);

Property Width As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Height As %String(MAXLEN = 1000, TRUNCATE = 1);

Property WFlowObj As array Of RuleWorkFlowObj;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,WorkName,Folder
FROM %BI.RuleWorkFlow
ORDER BY WorkName
}

Storage Default
{
<Data name="RuleWorkFlowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FlowStart</Value>
</Value>
<Value name="3">
<Value>Folder</Value>
</Value>
<Value name="4">
<Value>PostLoadCondition</Value>
</Value>
<Value name="5">
<Value>PreLoadCondition</Value>
</Value>
<Value name="6">
<Value>WorkName</Value>
</Value>
<Value name="7">
<Value>ReturnMesg</Value>
</Value>
<Value name="8">
<Value>RuleCondition</Value>
</Value>
<Value name="9">
<Value>Height</Value>
</Value>
<Value name="10">
<Value>Width</Value>
</Value>
</Data>
<Data name="WFlowObj">
<Attribute>WFlowObj</Attribute>
<Structure>subnode</Structure>
<Subscript>"WFlowObj"</Subscript>
</Data>
<DataLocation>^BI.RuleWorkFlowD</DataLocation>
<DefaultData>RuleWorkFlowDefaultData</DefaultData>
<IdLocation>^BI.RuleWorkFlowD</IdLocation>
<IndexLocation>^BI.RuleWorkFlowI</IndexLocation>
<StreamLocation>^BI.RuleWorkFlowS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
