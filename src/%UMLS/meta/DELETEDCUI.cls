/// Deleted concepts
Class %UMLS.meta.DELETEDCUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = DELETEDCUI, System = 4 ]
{

/// Concept unique identifier in the previous Metathesaurus // MAXLEN = 8
Property PCUI As %String(MAXLEN = 8);

/// Preferred name in the previous Metathesaurus // MAXLEN = 4
Property PSTR As %String(MAXLEN = 4);

Storage Default
{
<Data name="DELETEDCUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCUI</Value>
</Value>
<Value name="3">
<Value>PSTR</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.DELETEDCUID</DataLocation>
<DefaultData>DELETEDCUIDefaultData</DefaultData>
<ExtentSize>3442</ExtentSize>
<IdLocation>^%UMLS.meta.DELETEDCUID</IdLocation>
<IndexLocation>^%UMLS.meta.DELETEDCUII</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.996023:</OutlierSelectivity>
<Selectivity>0.0398%</Selectivity>
</Property>
<Property name="PCUI">
<Selectivity>0.0291%</Selectivity>
</Property>
<Property name="PSTR">
<OutlierSelectivity>.996023:"null"</OutlierSelectivity>
<Selectivity>0.0398%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-48</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.DELETEDCUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
