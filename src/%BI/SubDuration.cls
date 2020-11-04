Class %BI.SubDuration Extends %BI.EdmundPage [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FromDate As %Date;

Property ToDate As %Date;

Storage Default
{
<Data name="SubDurationDefaultData">
<Subscript>"SubDuration"</Subscript>
<Value name="1">
<Value>FromDate</Value>
</Value>
<Value name="2">
<Value>ToDate</Value>
</Value>
</Data>
<DefaultData>SubDurationDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
