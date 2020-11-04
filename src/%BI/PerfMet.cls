Class %BI.PerfMet Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/* 
	Type of alert in performance metrics 
 	1 = 'Metrics', 2 = 'Performance Alert', 3 = 'General Alert' 
*/
Property alertType As %String(TRUNCATE = 1);

/* Folder id */
Property fldrId As %String(TRUNCATE = 1);

/* Node name, if the node is a KPI, there will be no perfMetName, just perfMetNodes */
Property perfMetName As %String(TRUNCATE = 1);

Property perfMetNodes As array Of %BI.PerfMetNode;

/* Query for pivotList.csp */
Query QAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,perfMetName,fldrId FROM PerfMet
ORDER BY perfMetName
}

Query QFolder(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,perfMetName FROM PerfMet
WHERE fldrId = :folder
ORDER BY perfMetName
}

Storage Default
{
<Data name="ClassName">
<Subscript>"X"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="PerfMetDefaultData">
<Value name="1">
<Value>perfMetName</Value>
</Value>
<Value name="2">
<Value>fldrId</Value>
</Value>
<Value name="3">
<Value>alertType</Value>
</Value>
</Data>
<Data name="perfMetNodes">
<Attribute>perfMetNodes</Attribute>
<Structure>subnode</Structure>
<Subscript>"perfMetNodes"</Subscript>
</Data>
<DataLocation>^BI.PerfMetD</DataLocation>
<DefaultData>PerfMetDefaultData</DefaultData>
<IdLocation>^BI.PerfMetD</IdLocation>
<IndexLocation>^BI.PerfMetI</IndexLocation>
<StreamLocation>^BI.PerfMetS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
