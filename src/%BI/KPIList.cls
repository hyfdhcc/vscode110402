Class %BI.KPIList Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property KPI As %String(MAXLEN = 10, TRUNCATE = 1);

Property Caption As %String(MAXLEN = 2500, TRUNCATE = 1);

Property KPIName As %String(TRUNCATE = 1) [ Calculated ];

Method KPINameGet() As %String
{
 i ..KPI="" q ""
 quit $LG(^BI.KPID(..KPI),1)
}

Storage Default
{
<Data name="KPIListState">
<Subscript>"%BI.KPIList"</Subscript>
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>KPI</Value>
</Value>
</Data>
<State>KPIListState</State>
<StreamLocation>^BI.KPIListS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
