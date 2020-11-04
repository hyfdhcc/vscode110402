Class %BI.SMSession Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Method Get(index As %String, default As %String = "") As %String [ CodeMode = expression, Final ]
{
$get(i%Data(index),default)
}

Property Data As %String(TRUNCATE = 1) [ MultiDimensional ];

Property SessionId As %String(TRUNCATE = 1);

Property Key As %String(TRUNCATE = 1);

Method SessionIdGet() As %String
{
 q $J
}

Method %Id() As %String [ Final ]
{
 q $J
}

Method SessionId() As %String [ Final ]
{
 q $J
}

Storage Default
{
<Data name="SMSessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="SMSessionState">
<Subscript>"%BI.SMSession"</Subscript>
<Value name="1">
<Value>SessionId</Value>
</Value>
<Value name="2">
<Value>Key</Value>
</Value>
</Data>
<DataLocation>^BI.SMSessionD</DataLocation>
<DefaultData>SMSessionDefaultData</DefaultData>
<IdLocation>^BI.SMSessionD</IdLocation>
<IndexLocation>^BI.SMSessionI</IndexLocation>
<State>SMSessionState</State>
<StreamLocation>^BI.SMSessionS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
