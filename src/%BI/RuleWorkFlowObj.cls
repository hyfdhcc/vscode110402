Class %BI.RuleWorkFlowObj Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property RetValue As %String(MAXLEN = 10000, TRUNCATE = 1);

Property anID As %String(TRUNCATE = 1);

Property FlowStart As %String(TRUNCATE = 1);

Property PreLoaded As %String(TRUNCATE = 1);

Property RuleCondition As %String(MAXLEN = 10000, TRUNCATE = 1);

Property ReturnMessage As %String(MAXLEN = 10000, TRUNCATE = 1);

Property FlowFrom As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Description As %String(MAXLEN = 10000, TRUNCATE = 1);

Property RunnableCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Xcoord As %String(TRUNCATE = 1);

Property Ycoord As %String(TRUNCATE = 1);

Property width As %String(TRUNCATE = 1);

Property height As %String(TRUNCATE = 1);

Property ruleOrNode As %String(TRUNCATE = 1);

Property ruleType As %String;

Storage Default
{
<Data name="RuleWorkFlowObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>FlowFrom</Value>
</Value>
<Value name="4">
<Value>FlowStart</Value>
</Value>
<Value name="5">
<Value>Xcoord</Value>
</Value>
<Value name="6">
<Value>Ycoord</Value>
</Value>
<Value name="7">
<Value>height</Value>
</Value>
<Value name="8">
<Value>width</Value>
</Value>
<Value name="9">
<Value>RetValue</Value>
</Value>
<Value name="10">
<Value>ReturnMessage</Value>
</Value>
<Value name="11">
<Value>RuleCondition</Value>
</Value>
<Value name="12">
<Value>anID</Value>
</Value>
<Value name="13">
<Value>PreLoaded</Value>
</Value>
<Value name="14">
<Value>ruleOrNode</Value>
</Value>
<Value name="15">
<Value>ruleType</Value>
</Value>
<Value name="16">
<Value>RunnableCode</Value>
</Value>
</Data>
<Data name="goCond">
<Attribute>goCond</Attribute>
<Structure>subnode</Structure>
<Subscript>"goCond"</Subscript>
</Data>
<DataLocation>^BI.RuleWorkFlowObjD</DataLocation>
<DefaultData>RuleWorkFlowObjDefaultData</DefaultData>
<IdLocation>^BI.RuleWorkFlowObjD</IdLocation>
<IndexLocation>^BI.RuleWorkFlowObjI</IndexLocation>
<StreamLocation>^BI.RuleWorkFlowObjS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
