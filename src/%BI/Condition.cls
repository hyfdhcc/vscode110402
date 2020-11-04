Class %BI.Condition Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index ShortName On (Class, Category, ShortName);

Index ShortNameS On (Class, Category, ShortName As SqlString);

Property Category As %BI.Category;

Property Class As %String(COLLATION = "Exact", TRUNCATE = 1);

Property CondVariables As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Condition As %BI.ConditionName(MAXLEN = 800);

Property Dynamic As %Boolean;

Property ShortName As %BI.ConditionName(COLLATION = "Exact", MAXLEN = 800);

Property Type As %String(COLLATION = "Exact", TRUNCATE = 1);

Property Visible As %Boolean;

Query CompoundConditions(Class) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Condition,ShortName")
{
	Select ID,Condition,ShortName
	from %BI.Condition
	where Class = :Class and Type = 'C'
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DefaultData">
<Value name="1">
<Value>Category</Value>
</Value>
<Value name="2">
<Value>Class</Value>
</Value>
<Value name="3">
<Value>Condition</Value>
</Value>
<Value name="4">
<Value>CondVariables</Value>
</Value>
<Value name="5">
<Value>Dynamic</Value>
</Value>
<Value name="6">
<Value>ShortName</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Visible</Value>
</Value>
</Data>
<DataLocation>^BIidx.ConditionD</DataLocation>
<DefaultData>HiConditionDefaultData</DefaultData>
<IdLocation>^BIidx.ConditionD</IdLocation>
<IndexLocation>^BIidx.ConditionI</IndexLocation>
<StreamLocation>^BIidx.ConditionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
