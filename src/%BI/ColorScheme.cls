Class %BI.ColorScheme Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FontColor As %String(MAXLEN = 15, TRUNCATE = 1);

Property BackColor As %String(MAXLEN = 15, TRUNCATE = 1);

Property SeriesColor As array Of %String(TRUNCATE = 1);

Property SeriesColor2 As array Of %String(TRUNCATE = 1);

Property SeriesColor3 As array Of %String(TRUNCATE = 1);

Property Border As %Boolean;

Property BorderColor As %String(MAXLEN = 15, TRUNCATE = 1);

Property SchemeName As %String(MAXLEN = 15, TRUNCATE = 1);

Property SeriesClrList As list Of %List;

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,SchemeName,FontColor,BackColor,SeriesColor,Border, BorderColor
FROM %BI.ColorScheme
}

Property SeriesPattern As array Of %String(TRUNCATE = 1);

Property SeriesPattern2 As array Of %String(TRUNCATE = 1);

Property SeriesPattern3 As array Of %String(TRUNCATE = 1);

Storage Default
{
<Data name="ColorSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BackColor</Value>
</Value>
<Value name="3">
<Value>Border</Value>
</Value>
<Value name="4">
<Value>BorderColor</Value>
</Value>
<Value name="5">
<Value>FontColor</Value>
</Value>
<Value name="6">
<Value>SchemeName</Value>
</Value>
<Value name="7">
<Value>SeriesColor</Value>
</Value>
<Value name="8">
<Value>SeriesColors</Value>
</Value>
<Value name="9">
<Value>SeriesClrList</Value>
</Value>
<Value name="10">
<Value>SeriesPattern1</Value>
</Value>
<Value name="11">
<Value>SeriesPattern2</Value>
</Value>
<Value name="12">
<Value>SeriesPattern3</Value>
</Value>
<Value name="13">
<Value>SeriesPattern</Value>
</Value>
</Data>
<Data name="SeriesColor2">
<Attribute>SeriesColor2</Attribute>
<Structure>subnode</Structure>
<Subscript>"SeriesColor2"</Subscript>
</Data>
<Data name="SeriesColor3">
<Attribute>SeriesColor3</Attribute>
<Structure>subnode</Structure>
<Subscript>"SeriesColor3"</Subscript>
</Data>
<DataLocation>^BI.ColorSchemeD</DataLocation>
<DefaultData>ColorSchemeDefaultData</DefaultData>
<IdLocation>^BI.ColorSchemeD</IdLocation>
<IndexLocation>^BI.ColorSchemeI</IndexLocation>
<StreamLocation>^BI.ColorSchemeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
