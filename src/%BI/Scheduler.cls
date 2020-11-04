Class %BI.Scheduler Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(MAXLEN = 300, TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property runFrequency As %String(TRUNCATE = 1);

Property runCriteria As %String(TRUNCATE = 1);

Property startTime As %String(TRUNCATE = 1);

Property scheduledTask As array Of SchedulerTask;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Name,Description,runFrequency,runCriteria,startTime
FROM %BI.Scheduler
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="SchedulerDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>endDate</Value>
</Value>
<Value name="4">
<Value>runCriteria</Value>
</Value>
<Value name="5">
<Value>runFrequency</Value>
</Value>
<Value name="6">
<Value>startDate</Value>
</Value>
<Value name="7">
<Value>endTime</Value>
</Value>
<Value name="8">
<Value>startTime</Value>
</Value>
</Data>
<Data name="scheduledTask">
<Attribute>scheduledTask</Attribute>
<Structure>subnode</Structure>
<Subscript>"S"</Subscript>
</Data>
<DataLocation>^BI.SchedulerD</DataLocation>
<DefaultData>SchedulerDefaultData</DefaultData>
<IdLocation>^BI.SchedulerD</IdLocation>
<IndexLocation>^BI.SchedulerI</IndexLocation>
<StreamLocation>^BI.SchedulerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
