Class %BI.WorkFlowObj Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DashboardID As %String(TRUNCATE = 1);

Property FlowStart As %String(TRUNCATE = 1);

Property PreLoaded As %String(TRUNCATE = 1);

Property PreLoadCondition As %String(MAXLEN = 10000, TRUNCATE = 1);

Property PostLoadCondition As %String(MAXLEN = 10000, TRUNCATE = 1);

Property FlowFrom As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Xcoord As %String(TRUNCATE = 1);

Property Ycoord As %String(TRUNCATE = 1);

Property width As %String(TRUNCATE = 1);

Property height As %String(TRUNCATE = 1);

Storage Default
{
<Data name="WorkFlowObjState">
<Subscript>"%BI.WorkFlowObj"</Subscript>
<Value name="1">
<Value>DashboardID</Value>
</Value>
<Value name="2">
<Value>FlowStart</Value>
</Value>
<Value name="3">
<Value>PostLoadCondition</Value>
</Value>
<Value name="4">
<Value>PreLoadCondition</Value>
</Value>
<Value name="5">
<Value>PreLoaded</Value>
</Value>
<Value name="6">
<Value>FlowFrom</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>Xcoord</Value>
</Value>
<Value name="9">
<Value>Ycoord</Value>
</Value>
<Value name="10">
<Value>height</Value>
</Value>
<Value name="11">
<Value>width</Value>
</Value>
</Data>
<State>WorkFlowObjState</State>
<StreamLocation>^BI.WorkFlowObjS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
