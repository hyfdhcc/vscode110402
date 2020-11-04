Class %BI.CurrencyRate Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FromCurr As %String(TRUNCATE = 1);

Property ToCurr As %String(TRUNCATE = 1);

Property EffectDate As %String(TRUNCATE = 1);

Property CurrRate As %String(TRUNCATE = 1);

Index currIndex On (FromCurr, ToCurr, EffectDate) [ IdKey, Unique ];

Query All() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CurrRate,EffectDate,FromCurr,ToCurr FROM CurrencyRate
 ORDER BY EffectDate DESC
}

Storage Default
{
<Data name="CurrencyRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CurrRate</Value>
</Value>
<Value name="3">
<Value>EffectDate</Value>
</Value>
<Value name="4">
<Value>FromCurr</Value>
</Value>
<Value name="5">
<Value>ToCurr</Value>
</Value>
</Data>
<DataLocation>^BI.CurrencyRateD</DataLocation>
<DefaultData>CurrencyRateDefaultData</DefaultData>
<IdLocation>^BI.CurrencyRateD</IdLocation>
<IndexLocation>^BI.CurrencyRateI</IndexLocation>
<StreamLocation>^BI.CurrencyRateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

Storage StorageSQL
{
<Type>%CacheSQLStorage</Type>
}

}
