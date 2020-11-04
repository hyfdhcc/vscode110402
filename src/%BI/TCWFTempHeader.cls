Class %BI.TCWFTempHeader Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property HeaderName As %String(MAXLEN = 5000);

Property Remarks As %String(MAXLEN = 25000);

Property QueryVar As %String(MAXLEN = 25000);

Relationship Stations As %BI.TCWFTempStation [ Cardinality = children, Inverse = Header ];

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="Data">
<Value name="1">
<Value>HeaderName</Value>
</Value>
</Data>
<Data name="QueryVar">
<Attribute>QueryVar</Attribute>
<Structure>node</Structure>
<Subscript>"Q"</Subscript>
</Data>
<Data name="Remarks">
<Attribute>Remarks</Attribute>
<Structure>node</Structure>
<Subscript>"R"</Subscript>
</Data>
<DataLocation>^BI.TCWFTempHeaderD</DataLocation>
<DefaultData>TCWFHeaderDefaultData</DefaultData>
<IdLocation>^BI.TCWFTempHeaderD</IdLocation>
<IndexLocation>^BI.TCWFTempHeaderI</IndexLocation>
<StreamLocation>^BI.TCWFTempHeaderS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
