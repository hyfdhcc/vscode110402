Class %BI.WComputation Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/// The class name.
Property ClassName As %String(TRUNCATE = 1);

/// The display type of the return value
Property Display As %String(TRUNCATE = 1);

/// This is the formula for the computation
Property Formula As %String(MAXLEN = 50000, TRUNCATE = 1);

/// This is the post-formula for the computation
Property Formula2 As %String(MAXLEN = 50000, TRUNCATE = 1);

/// The name of the computation
Property Name As %String(MAXLEN = 500, TRUNCATE = 1);

/// The decimal point of the computation return value
Property decPoint As %String(TRUNCATE = 1);

/// The processing order of the computation return value
Property procOrder As %String(TRUNCATE = 1);

/// The Font property of the computation return value
Property fontProp As %String(TRUNCATE = 1);

/// The member prop of the computation return value
Property Member As %String(TRUNCATE = 1);

/// The new row value of the computation return value
Property newRow As %String(TRUNCATE = 1);

/// The KPI of the computation return value
Property KPI As %String(TRUNCATE = 1);

/// The drilldownable of the computation return value
Property Drilldownable As %String(TRUNCATE = 1);

Query ComputeAll(iCls As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Name,Formula,Display,decPoint,procOrder,fontProp,Member,newRow,KPI,Drilldownable,Formula2
FROM %BI.WComputation
WHERE ClassName=:iCls
}

Storage Default
{
<Data name="WComputationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Display</Value>
</Value>
<Value name="4">
<Value>Formula</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>decPoint</Value>
</Value>
<Value name="7">
<Value>Formula2</Value>
</Value>
<Value name="8">
<Value>Drilldownable</Value>
</Value>
<Value name="9">
<Value>KPI</Value>
</Value>
<Value name="10">
<Value>Member</Value>
</Value>
<Value name="11">
<Value>fontProp</Value>
</Value>
<Value name="12">
<Value>newRow</Value>
</Value>
<Value name="13">
<Value>postFormula</Value>
</Value>
<Value name="14">
<Value>procOrder</Value>
</Value>
</Data>
<DataLocation>^BI.WComputationD</DataLocation>
<DefaultData>WComputationDefaultData</DefaultData>
<IdLocation>^BI.WComputationD</IdLocation>
<IndexLocation>^BI.WComputationI</IndexLocation>
<StreamLocation>^BI.WComputationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
