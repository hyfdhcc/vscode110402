Class %BI.TransBitMap Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property BitMapDescription As %String(MAXLEN = 50000, TRUNCATE = 1);

Property ImageID As %String(TRUNCATE = 1);

Property BitMapName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TransBitMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BitMapDescription</Value>
</Value>
<Value name="3">
<Value>BitMapName</Value>
</Value>
<Value name="4">
<Value>ImageID</Value>
</Value>
</Data>
<Data name="TransBitMapState">
<Subscript>"%BI.TransBitMap"</Subscript>
<Value name="1">
<Value>BitMapDescription</Value>
</Value>
<Value name="2">
<Value>BitMapName</Value>
</Value>
<Value name="3">
<Value>ImageID</Value>
</Value>
</Data>
<DataLocation>^BI.TransBitMapD</DataLocation>
<DefaultData>TransBitMapDefaultData</DefaultData>
<IdLocation>^BI.TransBitMapD</IdLocation>
<IndexLocation>^BI.TransBitMapI</IndexLocation>
<State>TransBitMapState</State>
<StreamLocation>^BI.TransBitMapS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
