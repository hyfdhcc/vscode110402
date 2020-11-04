Class %BI.ListAttachForm Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FormDef As %BI.FormDef;

Property FormName As %String(TRUNCATE = 1);

Relationship DetailList As %BI.DetailList [ Cardinality = parent, Inverse = ListAttachForm ];

Storage Default
{
<Data name="ListAttachFormClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="ListAttachFormDefaultData">
<Value name="1">
<Value>FormName</Value>
</Value>
<Value name="2">
<Value>FormDef</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("AF")</DataLocation>
<DefaultData>ListAttachFormDefaultData</DefaultData>
<IdLocation>{%%PARENT}("AF")</IdLocation>
<IndexLocation>^BI.ListAttachFormI</IndexLocation>
<StreamLocation>^BI.ListAttachFormS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
