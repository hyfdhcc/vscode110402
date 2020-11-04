/// Typed key value metadata map
Class %UMLS.meta.MRDOC Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRDOC, System = 4 ]
{

/// Key to be documented // MAXLEN = 8
Property DOCKEY As %String(MAXLEN = 8);

/// Detailed explanation // MAXLEN = 941
Property EXPL As %String(COLLATION = "SqlUpper(150)", MAXLEN = 1024);

/// Type of information // MAXLEN = 21
Property TYPE As %String(MAXLEN = 32);

/// Value // MAXLEN = 62
Property VALUE As %String(MAXLEN = 64);

Storage Default
{
<Data name="MRDOCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DOCKEY</Value>
</Value>
<Value name="3">
<Value>EXPL</Value>
</Value>
<Value name="4">
<Value>TYPE</Value>
</Value>
<Value name="5">
<Value>VALUE</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRDOCD</DataLocation>
<DefaultData>MRDOCDefaultData</DefaultData>
<ExtentSize>2863</ExtentSize>
<IdLocation>^%UMLS.meta.MRDOCD</IdLocation>
<IndexLocation>^%UMLS.meta.MRDOCI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.995652:</OutlierSelectivity>
<Selectivity>0.0435%</Selectivity>
</Property>
<Property name="DOCKEY">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="EXPL">
<Selectivity>0.1709%</Selectivity>
</Property>
<Property name="TYPE">
<OutlierSelectivity>.559006:"expanded_form"</OutlierSelectivity>
<Selectivity>8.8199%</Selectivity>
</Property>
<Property name="VALUE">
<Selectivity>0.0531%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-120</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRDOCS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
