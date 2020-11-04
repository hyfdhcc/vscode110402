Class %BI.TCWFHeader Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property WorkFlowID As %String;

Property HeaderName As %String(MAXLEN = 5000);

Property Remarks As %String(MAXLEN = 25000);

Property QueryVar As %String(MAXLEN = 25000);

Relationship Stations As %BI.TCWFStation [ Cardinality = children, Inverse = Header ];

Index WFID On WorkFlowID As Exact;

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="Data">
<Value name="1">
<Value>WorkFlowID</Value>
</Value>
<Value name="2">
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
<DataLocation>^BI.TCWFHeaderD</DataLocation>
<DefaultData>TCWFHeaderDefaultData</DefaultData>
<IdLocation>^BI.TCWFHeaderD</IdLocation>
<IndexLocation>^BI.TCWFHeaderI</IndexLocation>
<StreamLocation>^BI.TCWFHeaderS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
