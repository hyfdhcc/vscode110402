Class %BI.PerfMetNode Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property kpiId As %String(TRUNCATE = 1);

Property perfMetMsg As array Of %BI.PerfMetMsg;

Property perfMetNodeName As %String(TRUNCATE = 1);

Property perfMetNodes As array Of %BI.PerfMetNode;

Storage Default
{
<Data name="PerfMetNodeDefaultData">
<Value name="1">
<Value>kpiId</Value>
</Value>
<Value name="2">
<Value>perfMetNodeName</Value>
</Value>
<Value name="3">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="perfMetMsg">
<Attribute>perfMetMsg</Attribute>
<Structure>subnode</Structure>
<Subscript>"perfMetMsg"</Subscript>
</Data>
<Data name="perfMetNodes">
<Attribute>perfMetNodes</Attribute>
<Structure>subnode</Structure>
<Subscript>"perfMetNodes"</Subscript>
</Data>
<DataLocation>^BI.PerfMetNodeD</DataLocation>
<DefaultData>PerfMetNodeDefaultData</DefaultData>
<IdLocation>^BI.PerfMetNodeD</IdLocation>
<IndexLocation>^BI.PerfMetNodeI</IndexLocation>
<StreamLocation>^BI.PerfMetNodeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
