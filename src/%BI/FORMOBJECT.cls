Class %BI.FORMOBJECT Extends %SerialObject [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Caption As %String;

Property Style As %String;

Property Type As %String;

Storage Default
{
<Data name="FORMOBJECTState">
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>Style</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
</Data>
<State>FORMOBJECTState</State>
<StreamLocation>^BI.FORMOBJECTS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
