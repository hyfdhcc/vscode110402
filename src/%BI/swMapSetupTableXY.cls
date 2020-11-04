Class %BI.swMapSetupTableXY Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
		Author : Steven :P
		Purpose: Table store map points,details,link other map etc
		Note   : This is an embedded object in a persistent object(from swMapSetupTable)
		Created: 23.06.2005
		Updated: 14.09.2005
*/
Property ParentMapID As %Integer;

//primary key to Mainmap table (swMapSetupTable)

//xy point of city/state

Property X As %Numeric;

Property Y As %Numeric;

//Name of the point

Property PointName As %String(TRUNCATE = 1);

//KPI value

Property KPI As %String(TRUNCATE = 1);

//additional sql condition

Property Condition As %String(MAXLEN = 100, TRUNCATE = 1);

//link other map when user click

Property MapRef As %String(TRUNCATE = 1);

Property Tooltip As %String(MAXLEN = 100, TRUNCATE = 1);

Property QueryName As %String(TRUNCATE = 1);

Property QueryValue As %String(TRUNCATE = 1);

Property ImageID As %Integer;

Storage Default
{
<Data name="swMapSetupTableXYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Condition</Value>
</Value>
<Value name="3">
<Value>KPI</Value>
</Value>
<Value name="4">
<Value>MapRef</Value>
</Value>
<Value name="5">
<Value>ParentMapID</Value>
</Value>
<Value name="6">
<Value>PointName</Value>
</Value>
<Value name="7">
<Value>X</Value>
</Value>
<Value name="8">
<Value>Y</Value>
</Value>
<Value name="9">
<Value>Filter</Value>
</Value>
<Value name="10">
<Value>Tooltip</Value>
</Value>
<Value name="11">
<Value>QueryName</Value>
</Value>
<Value name="12">
<Value>QueryValue</Value>
</Value>
<Value name="13">
<Value>ImageID</Value>
</Value>
</Data>
<DataLocation>^BI.swMapSetupTableXYD</DataLocation>
<DefaultData>swMapSetupTableXYDefaultData</DefaultData>
<IdLocation>^BI.swMapSetupTableXYD</IdLocation>
<IndexLocation>^BI.swMapSetupTableXYI</IndexLocation>
<StreamLocation>^BI.swMapSetupTableXYS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
