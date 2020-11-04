/// Merged concepts
Class %UMLS.meta.MERGEDCUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MERGEDCUI, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 8);

/// Concept unique identifier in the previous Metathesaurus // MAXLEN = 8
Property PCUI As %String(MAXLEN = 8);

Storage Default
{
<Data name="MERGEDCUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUI</Value>
</Value>
<Value name="3">
<Value>PCUI</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MERGEDCUID</DataLocation>
<DefaultData>MERGEDCUIDefaultData</DefaultData>
<ExtentSize>2829</ExtentSize>
<IdLocation>^%UMLS.meta.MERGEDCUID</IdLocation>
<IndexLocation>^%UMLS.meta.MERGEDCUII</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.995625:</OutlierSelectivity>
<Selectivity>0.0438%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0353%</Selectivity>
</Property>
<Property name="PCUI">
<Selectivity>0.0353%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-44</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MERGEDCUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
