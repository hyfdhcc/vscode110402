Class %BI.RangeDisplay Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FromValue As %String(MAXLEN = 100, TRUNCATE = 1);

Property ToValue As %String(MAXLEN = 100, TRUNCATE = 1);

Property ForeColor As %String(MAXLEN = 15, TRUNCATE = 1);

Property BackColor As %String(MAXLEN = 15, TRUNCATE = 1);

Property FontName As %String(MAXLEN = 15, TRUNCATE = 1);

Property FontSize As %SmallInt;

Property FontBold As %Boolean;

Property FontItalic As %Boolean;

Property FontUnderline As %Boolean;

Property FontStrikethru As %Boolean;

Property Alignment As %String(MAXLEN = 15, TRUNCATE = 1);

Property ImageID As %String(TRUNCATE = 1);

Property InclusiveFrom As %Boolean;

Property InclusiveTo As %Boolean;

Property Text As %String;

Storage Default
{
<Data name="RangeDisplayState">
<Attribute>listnode</Attribute>
<Subscript>"%BI.RangeDisplay"</Subscript>
<Value name="1">
<Value>FromValue</Value>
</Value>
<Value name="2">
<Value>ToValue</Value>
</Value>
<Value name="3">
<Value>FontName</Value>
</Value>
<Value name="4">
<Value>FontBold</Value>
</Value>
<Value name="5">
<Value>FontItalic</Value>
</Value>
<Value name="6">
<Value>FontSize</Value>
</Value>
<Value name="7">
<Value>FontUnderline</Value>
</Value>
<Value name="8">
<Value>FontStrikethru</Value>
</Value>
<Value name="9">
<Value>ForeColor</Value>
</Value>
<Value name="10">
<Value>BackColor</Value>
</Value>
<Value name="11">
<Value>Alignment</Value>
</Value>
<Value name="12">
<Value>ImageID</Value>
</Value>
<Value name="13">
<Value>InclusiveFrom</Value>
</Value>
<Value name="14">
<Value>InclusiveTo</Value>
</Value>
<Value name="15">
<Value>Text</Value>
</Value>
</Data>
<State>RangeDisplayState</State>
<StreamLocation>^BI.RangeDisplayS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
