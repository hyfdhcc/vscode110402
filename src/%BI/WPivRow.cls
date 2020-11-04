Class %BI.WPivRow Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

// Usage for either individual cell or individual row query.

Property Content As %String(MAXLEN = 10000, TRUNCATE = 1);

Storage Default
{
<Data name="WPivRowState">
<Subscript>"R"</Subscript>
<Value name="1">
<Value>Content</Value>
</Value>
</Data>
<State>WPivRowState</State>
<StreamLocation>^BI.WPivRowS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
