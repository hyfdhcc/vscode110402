Class %BI.PerfMetMsg Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/* action = 1 (Alert) action = 2 (SMS) action = 3 (Email) action = 4 (Code) */
Property action As %String(MAXLEN = 1000, TRUNCATE = 1);

Property data As %String(MAXLEN = 5000, TRUNCATE = 1);

Property rules As %String(MAXLEN = 1000, TRUNCATE = 1);

Storage Default
{
<Data name="PerfMetMsgState">
<Subscript>"%BI.PerfMetMsg"</Subscript>
<Value name="1">
<Value>rules</Value>
</Value>
<Value name="2">
<Value>data</Value>
</Value>
<Value name="3">
<Value>action</Value>
</Value>
</Data>
<DataLocation>^BI.PerfMetMsgD</DataLocation>
<DefaultData>PerfMetMsgDefaultData</DefaultData>
<IdLocation>^BI.PerfMetMsgD</IdLocation>
<IndexLocation>^BI.PerfMetMsgI</IndexLocation>
<State>PerfMetMsgState</State>
<StreamLocation>^BI.PerfMetMsgS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
