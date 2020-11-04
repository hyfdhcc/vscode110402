Class %BI.DatFilter Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Caption As %String(TRUNCATE = 1);

Property Default As %String(TRUNCATE = 1);

Property Field As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DatFilterState">
<Subscript>"%BI.DatFilter"</Subscript>
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>Default</Value>
</Value>
<Value name="3">
<Value>Field</Value>
</Value>
</Data>
<State>DatFilterState</State>
<StreamLocation>^BI.DatFilterS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
