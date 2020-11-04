Class %BI.TemplateObject Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property LibraryID As %String(TRUNCATE = 1);

Property Spacing As %String(TRUNCATE = 1);

Property CoordinateTop As %String(TRUNCATE = 1);

Property CoordinateLeft As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TemplateObjectState">
<Subscript>"%BI.TemplateObject"</Subscript>
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>LibraryID</Value>
</Value>
<Value name="3">
<Value>CoordinateTop</Value>
</Value>
<Value name="4">
<Value>CoordinateLeft</Value>
</Value>
<Value name="5">
<Value>Spacing</Value>
</Value>
</Data>
<State>TemplateObjectState</State>
<StreamLocation>^BI.TemplateObjectS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
