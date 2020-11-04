Class %BI.EdmundPage Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Category As %String [ Required ];

Property NumElement As %Integer;

Property Duration As %Date;

Relationship ChildCat As %BI.SubCategory [ Cardinality = children, Inverse = MainCat ];

Query GetCategory() As %SQLQuery
{
SELECT Category,NumElement FROM EdmundPage
}

Query GetSubCategory(Name As %String) As %SQLQuery
{
	
SELECT %ID,Category,NumElement FROM EdmundPage
 WHERE (Category %STARTSWITH :Name)
}

Storage Default
{
<Data name="EdmundPageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>Duration</Value>
</Value>
<Value name="4">
<Value>MainName</Value>
</Value>
<Value name="5">
<Value>NumElement</Value>
</Value>
</Data>
<DataLocation>^BI.EdmundPageD</DataLocation>
<DefaultData>EdmundPageDefaultData</DefaultData>
<IdLocation>^BI.EdmundPageD</IdLocation>
<IndexLocation>^BI.EdmundPageI</IndexLocation>
<StreamLocation>^BI.EdmundPageS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
