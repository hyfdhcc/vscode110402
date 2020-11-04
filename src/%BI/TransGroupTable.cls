Class %BI.TransGroupTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property GroupName As %String(TRUNCATE = 1);

Relationship TransTable As %BI.TransTable [ Cardinality = children, Inverse = TransGroupTable ];

Query ListGroup() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,GroupName
	FROM %BI.TransGroupTable
	ORDER BY GroupName
}

Storage Default
{
<Data name="TransGroupTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupName</Value>
</Value>
<Value name="3">
<Value>TransTable</Value>
</Value>
</Data>
<DataLocation>^BI.TransGroupTableD</DataLocation>
<DefaultData>TransGroupTableDefaultData</DefaultData>
<IdLocation>^BI.TransGroupTableD</IdLocation>
<IndexLocation>^BI.TransGroupTableI</IndexLocation>
<StreamLocation>^BI.TransGroupTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
