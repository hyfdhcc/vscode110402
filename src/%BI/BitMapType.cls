Class %BI.BitMapType Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property BitMapDescription As %String(MAXLEN = 50000, TRUNCATE = 1);

Property ImageID As %String(TRUNCATE = 1);

Property BitMapName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BitMapTypeState">
<Subscript>"%BI.BitMapType"</Subscript>
<Value name="1">
<Value>BitMap</Value>
</Value>
<Value name="2">
<Value>BitMapName</Value>
</Value>
<Value name="3">
<Value>BitMapReference</Value>
</Value>
<Value name="4">
<Value>IsBitMap</Value>
</Value>
<Value name="5">
<Value>ImageID</Value>
</Value>
<Value name="6">
<Value>BitMapDescription</Value>
</Value>
</Data>
<State>BitMapTypeState</State>
<StreamLocation>^BI.BitMapTypeS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
