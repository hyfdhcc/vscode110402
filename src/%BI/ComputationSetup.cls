Class %BI.ComputationSetup Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Query GetComputation() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,RowFormula,RowPostFormula,ColFormula,ColPostFormula,MetricsFormula,MetricsPostFormula FROM ComputationSetup
 ORDER BY Name
}

Property Name As %String(TRUNCATE = 1);

Property RowFormula As %String(TRUNCATE = 1);

Property RowPostFormula As %String(TRUNCATE = 1);

Property ColFormula As %String(TRUNCATE = 1);

Property ColPostFormula As %String(TRUNCATE = 1);

Property MetricsFormula As %String(TRUNCATE = 1);

Property MetricsPostFormula As %String(TRUNCATE = 1);

Property DecimalPt As %Integer;

Property KPI As %String(TRUNCATE = 1);

Property Display As %String(TRUNCATE = 1);

Property DrillDown As %Boolean;

Property Member As %Boolean;

Property ProcOrder As %Integer;

Property Font As %String(TRUNCATE = 1);

Storage Default
{
<Data name="Col">
<Attribute>Col</Attribute>
<Structure>subnode</Structure>
<Subscript>"Col"</Subscript>
</Data>
<Data name="ComputationSetupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>DecimalPt</Value>
</Value>
<Value name="4">
<Value>Display</Value>
</Value>
<Value name="5">
<Value>DrillDown</Value>
</Value>
<Value name="6">
<Value>Font</Value>
</Value>
<Value name="7">
<Value>KPI</Value>
</Value>
<Value name="8">
<Value>Member</Value>
</Value>
<Value name="9">
<Value>ProcOrder</Value>
</Value>
<Value name="10">
<Value>ColFormula</Value>
</Value>
<Value name="11">
<Value>ColPostFormula</Value>
</Value>
<Value name="12">
<Value>MetricsFormula</Value>
</Value>
<Value name="13">
<Value>MetricsPostFormula</Value>
</Value>
<Value name="14">
<Value>RowFormula</Value>
</Value>
<Value name="15">
<Value>RowPostFormula</Value>
</Value>
</Data>
<Data name="Metrics">
<Attribute>Metrics</Attribute>
<Structure>subnode</Structure>
<Subscript>"Metrics"</Subscript>
</Data>
<Data name="Row">
<Attribute>Row</Attribute>
<Structure>subnode</Structure>
<Subscript>"Row"</Subscript>
</Data>
<DataLocation>^BI.ComputationSetupD</DataLocation>
<DefaultData>ComputationSetupDefaultData</DefaultData>
<IdLocation>^BI.ComputationSetupD</IdLocation>
<IndexLocation>^BI.ComputationSetupI</IndexLocation>
<StreamLocation>^BI.ComputationSetupS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
