Class %BI.SubCategory Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String;

Relationship MainCat As %BI.EdmundPage [ Cardinality = parent, Inverse = ChildCat ];

Property Name As %String;

Storage Default
{
<Data name="SubCategoryDefaultData">
<Subscript>"SubCategory"</Subscript>
<Value name="1">
<Value>Desc</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildCat")</DataLocation>
<DefaultData>SubCategoryDefaultData</DefaultData>
<IdLocation>^BI.EdmundPageC("ChildCat")</IdLocation>
<IndexLocation>^BI.SubCategoryI</IndexLocation>
<StreamLocation>^BI.SubCategoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
