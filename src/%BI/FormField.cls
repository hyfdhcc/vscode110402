Class %BI.FormField Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property ControlType As %SmallInt;

Property Caption As %String(TRUNCATE = 1);

Property FieldID As %String(TRUNCATE = 1);

Property FieldLeft As %Numeric;

Property FieldTop As %Numeric;

Property FieldWidth As %Numeric;

Property FieldHeight As %Numeric;

Property LabelLeft As %Numeric;

Property LabelTop As %Numeric;

Property LabelWidth As %Numeric;

Property LabelHeight As %Numeric;

Property DefaultValue As %String(TRUNCATE = 1);

Storage Default
{
<Data name="FormFieldState">
<Subscript>"%BI.FormField"</Subscript>
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>ControlType</Value>
</Value>
<Value name="3">
<Value>FieldHeight</Value>
</Value>
<Value name="4">
<Value>FieldID</Value>
</Value>
<Value name="5">
<Value>FieldLeft</Value>
</Value>
<Value name="6">
<Value>FieldTop</Value>
</Value>
<Value name="7">
<Value>FieldWidth</Value>
</Value>
<Value name="8">
<Value>LabelHeight</Value>
</Value>
<Value name="9">
<Value>LabelLeft</Value>
</Value>
<Value name="10">
<Value>LabelTop</Value>
</Value>
<Value name="11">
<Value>LabelWidth</Value>
</Value>
<Value name="12">
<Value>DefaultValue</Value>
</Value>
</Data>
<State>FormFieldState</State>
<StreamLocation>^BI.FormFieldS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
