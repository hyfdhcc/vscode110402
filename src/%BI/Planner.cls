Class %BI.Planner Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property VName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

Property Fldr As %String(TRUNCATE = 1);

Property ClsName As %String(TRUNCATE = 1);

Property SjArea As %Integer;

Property Flt As %String(TRUNCATE = 1);

Property QryLine As array Of %String(TRUNCATE = 1);

Query AllPlanner() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,VName,Fldr FROM Planner
ORDER BY VName
}

Query FolderPlanner(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,VName FROM Planner
WHERE fldr=:folder
ORDER BY VName
}

ClassMethod loadDimJS()
{
	d loadDimJS^%bi.SWr.Planner
	q
}

ClassMethod loadValJS(dimID, dimName, condBegin)
{
	d loadValJS^%bi.SWr.Planner(dimID, dimName, condBegin)
	q
}

ClassMethod saveDataJS(plannerId, vName, foldID, query, tbody)
{
	d saveDataJS^%bi.SWr.Planner(plannerId,vName,foldID,query,tbody)
	q
}

ClassMethod loadDataJS(id)
{
	d loadDataJS^%bi.SWr.Planner(id)
	q
}

ClassMethod getQuery(id)
{
	s newTBody = $$getQuery^%bi.SWr.Planner(id)
	q newTBody
}

ClassMethod createQuery(tbody)
{
	s newTBody = $$createQuery^%bi.SWr.Planner(tbody)
	q newTBody
}

ClassMethod deletePlanner(id)
{
	d deletePlanner^%bi.SWr.Planner(id)
	q
}

Storage Default
{
<Data name="PlannerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClsName</Value>
</Value>
<Value name="3">
<Value>Fldr</Value>
</Value>
<Value name="4">
<Value>Flt</Value>
</Value>
<Value name="5">
<Value>SjArea</Value>
</Value>
<Value name="6">
<Value>VName</Value>
</Value>
</Data>
<Data name="QryLine">
<Attribute>QryLine</Attribute>
<Structure>subnode</Structure>
<Subscript>"Q"</Subscript>
</Data>
<DataLocation>^BI.PlannerD</DataLocation>
<DefaultData>PlannerDefaultData</DefaultData>
<IdLocation>^BI.PlannerD</IdLocation>
<IndexLocation>^BI.PlannerI</IndexLocation>
<StreamLocation>^BI.PlannerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
