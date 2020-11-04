Class %BI.Alerts Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DataMart As %String(TRUNCATE = 1);

Property Alertname As %String(TRUNCATE = 1);

Property AlertQuery As %String(TRUNCATE = 1);

Property AlertMessage As %String(TRUNCATE = 1);

Property Mesaures As %String(TRUNCATE = 1);

Property Metric As %String(TRUNCATE = 1);

Query AllAlerts() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DataMart,Alertname,AlertMessage
FROM %BI.Alerts
}

Storage Default
{
<Data name="AlertsDefaultData">
<Value name="1">
<Value>AlertMessage</Value>
</Value>
<Value name="2">
<Value>AlertQuery</Value>
</Value>
<Value name="3">
<Value>Alertname</Value>
</Value>
<Value name="4">
<Value>DataMart</Value>
</Value>
<Value name="5">
<Value>Mesaures</Value>
</Value>
<Value name="6">
<Value>Metric</Value>
</Value>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<DataLocation>^BI.AlertsD</DataLocation>
<DefaultData>AlertsDefaultData</DefaultData>
<IdLocation>^BI.AlertsD</IdLocation>
<IndexLocation>^BI.AlertsI</IndexLocation>
<StreamLocation>^BI.AlertsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
