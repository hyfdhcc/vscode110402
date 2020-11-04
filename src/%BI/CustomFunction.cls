Class %BI.CustomFunction Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FnDesc As %String(TRUNCATE = 1);

Property FnCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CustomFunctionState">
<Subscript>"CF"</Subscript>
<Value name="1">
<Value>FnCode</Value>
</Value>
<Value name="2">
<Value>FnDesc</Value>
</Value>
</Data>
<State>CustomFunctionState</State>
<StreamLocation>^BI.CustomFunctionS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
