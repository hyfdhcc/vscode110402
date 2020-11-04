Class %BI.MapKPI Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Alignment As %SmallInt;

Property Appearance As %SmallInt;

Property BackColor As %String(TRUNCATE = 1);

Property BorderStyle As %SmallInt;

Property ControlType As %SmallInt;

Property ForeColor As %String(TRUNCATE = 1);

Property Height As %Numeric;

Property KPI As %String(TRUNCATE = 1);

Property KPIName As %String(TRUNCATE = 1) [ Calculated ];

Property KPIQuery As %String(TRUNCATE = 1) [ Calculated ];

Property KPIValue As %String(TRUNCATE = 1) [ Calculated ];

Property Label As %String(TRUNCATE = 1);

Property LeftPos As %Numeric;

Property TopPos As %Numeric;

Property Width As %Numeric;

Method KPINameGet() As %String
{
 if ..KPI="" quit ""
 quit $LG($G(^BI.KPID(+..KPI)),1)
}

Method KPIQueryGet() As %String
{
 if ..KPI="" quit ""
 s xData=$G(^BI.KPID(..KPI))
 s kpidm=$LG(xData,2),query=$LG(xData,4)
 s kpidmD=$G(^SYS("BI","DM","Data",kpidm))
 s dmquery=$P(kpidmD,$C(3),4)
 i dmquery'="" d
 . i query="" s query=dmquery quit
 . s query="(" & dmquery & ") AND (" & query & ")"
 q query
}

Method KPIValueGet() As %String
{
 if ..KPI="" quit ""
 quit $$getKPIv^%bi.SMr.KPI3(..KPI)
}

Storage Default
{
<Data name="MapKPIState">
<Subscript>"%BI.MapKPI"</Subscript>
<Value name="1">
<Value>Alignment</Value>
</Value>
<Value name="2">
<Value>Appearance</Value>
</Value>
<Value name="3">
<Value>BackColor</Value>
</Value>
<Value name="4">
<Value>BorderStyle</Value>
</Value>
<Value name="5">
<Value>ForeColor</Value>
</Value>
<Value name="6">
<Value>Height</Value>
</Value>
<Value name="7">
<Value>KPI</Value>
</Value>
<Value name="8">
<Value>LeftPos</Value>
</Value>
<Value name="9">
<Value>TopPos</Value>
</Value>
<Value name="10">
<Value>Width</Value>
</Value>
<Value name="11">
<Value>Label</Value>
</Value>
<Value name="12">
<Value>ControlType</Value>
</Value>
</Data>
<State>MapKPIState</State>
<StreamLocation>^BI.MapKPIS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
