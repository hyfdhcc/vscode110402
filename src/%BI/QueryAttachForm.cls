Class %BI.QueryAttachForm Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FormDef As %BI.FormDef;

Property FormName As %String(TRUNCATE = 1);

Relationship QueryCom As %BI.QueryCom [ Cardinality = parent, Inverse = QueryAttachForm ];

Storage Default
{
<Data name="QueryAttachFormClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="QueryAttachFormDefaultData">
<Value name="1">
<Value>FormName</Value>
</Value>
<Value name="2">
<Value>FormDef</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("AF")</DataLocation>
<DefaultData>QueryAttachFormDefaultData</DefaultData>
<IdLocation>{%%PARENT}("AF")</IdLocation>
<IndexLocation>^BI.QueryAttachFormI</IndexLocation>
<StreamLocation>^BI.QueryAttachFormS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
