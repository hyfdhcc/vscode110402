Class %BI.Period Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Period As %Integer;

Index Period On Period [ IdKey, Unique ];

Index PeriodName On PeriodName [ Unique ];

Property PeriodName As %String(MAXLEN = 5000, TRUNCATE = 1);

Property ExeStatus As %Date;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT Period,PeriodName,ExeStatus
FROM Period
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="PeriodDefaultData">
<Value name="1">
<Value>PeriodName</Value>
</Value>
<Value name="2">
<Value>ExeStatus</Value>
</Value>
</Data>
<DataLocation>^BI.PeriodD</DataLocation>
<DefaultData>PeriodDefaultData</DefaultData>
<IdLocation>^BI.PeriodD</IdLocation>
<IndexLocation>^BI.PeriodI</IndexLocation>
<StreamLocation>^BI.PeriodS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
