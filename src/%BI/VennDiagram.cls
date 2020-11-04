Class %BI.VennDiagram Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property VennName As %String(TRUNCATE = 1);

Property VennSchema As %String(TRUNCATE = 1);

Property VennFolder As %String(TRUNCATE = 1);

Property VennQry As %String(TRUNCATE = 1);

Property VennMeasure As %String(TRUNCATE = 1);

Property ColorID As %String(TRUNCATE = 1);

Property VennQuery As array Of %String(MAXLEN = 10000, TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,VennName,VennSchema,VennFolder,VennQry,VennMeasure
FROM VennDiagram
ORDER BY VennName
}

Query ListFolder(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,VennName
FROM VennDiagram
WHERE (VennFolder = :folder)
ORDER BY VennName
}

Storage Default
{
<Data name="VennDiagramDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VennFolder</Value>
</Value>
<Value name="3">
<Value>VennName</Value>
</Value>
<Value name="4">
<Value>VennQry</Value>
</Value>
<Value name="5">
<Value>VennSchema</Value>
</Value>
<Value name="6">
<Value>VennMeasure</Value>
</Value>
<Value name="7">
<Value>ColorID</Value>
</Value>
</Data>
<Data name="VennQuery">
<Attribute>VennQuery</Attribute>
<Structure>subnode</Structure>
<Subscript>"Q"</Subscript>
</Data>
<DataLocation>^BI.VennDiagramD</DataLocation>
<DefaultData>VennDiagramDefaultData</DefaultData>
<IdLocation>^BI.VennDiagramD</IdLocation>
<IndexLocation>^BI.VennDiagramI</IndexLocation>
<StreamLocation>^BI.VennDiagramS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
