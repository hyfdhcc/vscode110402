Class %BI.Category Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Cat On (Class, CategoryName) [ Unique ];

Property CategoryName As %String(COLLATION = "EXACT", MAXLEN = 200, TRUNCATE = 1);

Property Class As %String(COLLATION = "EXACT", MAXLEN = 200, TRUNCATE = 1);

Property Type As %String(COLLATION = "Exact", TRUNCATE = 1);

Property DimIcon As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CategoryDefaultData">
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>CategoryName</Value>
</Value>
<Value name="3">
<Value>Class</Value>
</Value>
<Value name="4">
<Value>DimIcon</Value>
</Value>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<DataLocation>^BI.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<IdLocation>^BI.CategoryD</IdLocation>
<IndexLocation>^BI.CategoryI</IndexLocation>
<StreamLocation>^BI.CategoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
