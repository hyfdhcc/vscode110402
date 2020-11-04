Class %BI.PivotData Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Header As list Of %String(TRUNCATE = 1);

Property Row As list Of %String(TRUNCATE = 1);

Storage Default
{
<Data name="Data">
<Attribute>Row</Attribute>
<Structure>subnode</Structure>
<Subscript>"A","D*"</Subscript>
</Data>
<Data name="Header">
<Attribute>Header</Attribute>
<Structure>subnode</Structure>
<Subscript>"A","H*"</Subscript>
</Data>
<Data name="PivotDataDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^mtemp</DataLocation>
<DefaultData>PivotDataDefaultData</DefaultData>
<IdLocation>^mtemp</IdLocation>
<IndexLocation>^BI.PivotDataI</IndexLocation>
<StreamLocation>^mtempS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
