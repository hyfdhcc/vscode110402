Class %BI.PopUpCon Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property daIcon As %String(TRUNCATE = 1);

Property daMenuCap As %String(TRUNCATE = 1);

Property daPreAct As %String(MAXLEN = 10000, TRUNCATE = 1);

Property daAct As %String(MAXLEN = 10000, TRUNCATE = 1);

Property daPostAct As %String(MAXLEN = 10000, TRUNCATE = 1);

Storage Default
{
<Data name="PopUpConState">
<Subscript>"%BI.PopUpCon"</Subscript>
<Value name="1">
<Value>daAct</Value>
</Value>
<Value name="2">
<Value>daIcon</Value>
</Value>
<Value name="3">
<Value>daMenuCap</Value>
</Value>
<Value name="4">
<Value>daPostAct</Value>
</Value>
<Value name="5">
<Value>daPreAct</Value>
</Value>
</Data>
<State>PopUpConState</State>
<StreamLocation>^BI.PopUpConS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
