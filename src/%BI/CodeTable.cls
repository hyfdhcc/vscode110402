Class %BI.CodeTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Code As %String(TRUNCATE = 1);

Property Data As %List;

Property Type As %String(TRUNCATE = 1);

Index MainIndex On (Type, Code) [ IdKey, Unique ];

Query ByType(Type As %String) As %SQLQuery
{
SELECT Code,Data FROM CodeTable
 WHERE (Type = :Type)
 ORDER BY Code
}

Query TypeAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Type FROM CodeTable GROUP BY Type
}

Storage Default
{
<Data name="CodeTableDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Data">
<Attribute>Data</Attribute>
<Structure>subnode</Structure>
</Data>
<DataLocation>^BI.CodeTableD</DataLocation>
<DefaultData>CodeTableDefaultData</DefaultData>
<IdLocation>^BI.CodeTableD</IdLocation>
<IndexLocation>^BI.CodeTableI</IndexLocation>
<StreamLocation>^BI.CodeTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
