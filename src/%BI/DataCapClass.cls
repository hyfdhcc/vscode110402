Class %BI.DataCapClass Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property ClassName As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Remark As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Fields As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Filter As array Of %BI.DataCapFilter;

Query ByClassName(ClassName As %String) As %SQLQuery
{
SELECT ClassName FROM DataCapClass
 WHERE (ClassName = :ClassName)
}

Query ListClassName() As %SQLQuery(CONTAINID = 1)
{
	SELECT ID,ClassName,Description,COUNT(*) AS Cnt
	FROM %BI.DataCapClass
	ORDER BY ClassName
}

Storage Default
{
<Data name="DataCapClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>Fields</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<Data name="Filter">
<Attribute>Filter</Attribute>
<Structure>subnode</Structure>
<Subscript>"Filter"</Subscript>
</Data>
<DataLocation>^BI.DataCapClassD</DataLocation>
<DefaultData>DataCapClassDefaultData</DefaultData>
<IdLocation>^BI.DataCapClassD</IdLocation>
<IndexLocation>^BI.DataCapClassI</IndexLocation>
<StreamLocation>^BI.DataCapClassS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
