Class %BI.DataCapFilter Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Field As %String(TRUNCATE = 1);

Property Default As %String(TRUNCATE = 1);

Property InputType As %String(TRUNCATE = 1);

Property Prefix As %String(TRUNCATE = 1);

Property Routine As %String(TRUNCATE = 1);

Property Suffix As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DataCapFilterState">
<Subscript>"%BI.DataCapFilter"</Subscript>
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>Default</Value>
</Value>
<Value name="3">
<Value>Field</Value>
</Value>
<Value name="4">
<Value>ControlType</Value>
</Value>
<Value name="5">
<Value>Prefix</Value>
</Value>
<Value name="6">
<Value>Routine</Value>
</Value>
<Value name="7">
<Value>Suffix</Value>
</Value>
<Value name="8">
<Value>InputType</Value>
</Value>
</Data>
<State>DataCapFilterState</State>
<StreamLocation>^BI.DataCapFilterS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
