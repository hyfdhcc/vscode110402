Class %BI.BPMKPI Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property KPI As %String(MAXLEN = 20, TRUNCATE = 1);

Property Message As %String(MAXLEN = 2500, TRUNCATE = 1);

Property KPIName As %String(TRUNCATE = 1) [ Calculated ];

Property Targets As %String(TRUNCATE = 1);

Property AcceptableVariance As %String(TRUNCATE = 1);

Method KPINameGet() As %String
{
 i ..KPI="" q ""
 quit $LG($G(^BI.KPID(..KPI)),1)
}

Storage Default
{
<Data name="BPMKPIState">
<Subscript>"%BI.BPMKPI"</Subscript>
<Value name="1">
<Value>KPI</Value>
</Value>
<Value name="2">
<Value>Message</Value>
</Value>
<Value name="3">
<Value>Targets</Value>
</Value>
<Value name="4">
<Value>AcceptableVariance</Value>
</Value>
</Data>
<State>BPMKPIState</State>
<StreamLocation>^BI.BPMKPIS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
