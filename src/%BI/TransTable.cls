Class %BI.TransTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property OriginalText As %String(MAXLEN = 1000, TRUNCATE = 1);

Property SVG As %String(MAXLEN = 1000, TRUNCATE = 1);

Property PDF As %String(MAXLEN = 1000, TRUNCATE = 1);

Relationship TransGroupTable As %BI.TransGroupTable [ Cardinality = parent, Inverse = TransTable ];

Storage Default
{
<Data name="TransTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OriginalText</Value>
</Value>
<Value name="3">
<Value>PDF</Value>
</Value>
<Value name="4">
<Value>SVG</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TransTable")</DataLocation>
<DefaultData>TransTableDefaultData</DefaultData>
<IdLocation>^BI.TransGroupTableC("TransTable")</IdLocation>
<IndexLocation>^BI.TransTableI</IndexLocation>
<StreamLocation>^BI.TransTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
