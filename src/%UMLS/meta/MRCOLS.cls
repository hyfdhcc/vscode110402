/// Attribute Relation
Class %UMLS.meta.MRCOLS Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRCOLS, System = 4 ]
{

Property AV As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property COL As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property DES As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property DTY As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property FIL As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property MAX As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property MIN As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Property REF As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Storage Default
{
<Data name="MRCOLSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AV</Value>
</Value>
<Value name="3">
<Value>COL</Value>
</Value>
<Value name="4">
<Value>DES</Value>
</Value>
<Value name="5">
<Value>DTY</Value>
</Value>
<Value name="6">
<Value>FIL</Value>
</Value>
<Value name="7">
<Value>MAX</Value>
</Value>
<Value name="8">
<Value>MIN</Value>
</Value>
<Value name="9">
<Value>REF</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRCOLSD</DataLocation>
<DefaultData>MRCOLSDefaultData</DefaultData>
<ExtentSize>309</ExtentSize>
<IdLocation>^%UMLS.meta.MRCOLSD</IdLocation>
<IndexLocation>^%UMLS.meta.MRCOLSI</IndexLocation>
<Property name="%%CLASSNAME">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="AV">
<OutlierSelectivity>.165049:"8.00"</OutlierSelectivity>
<Selectivity>0.5457%</Selectivity>
</Property>
<Property name="COL">
<Selectivity>0.8130%</Selectivity>
</Property>
<Property name="DES">
<Selectivity>0.8130%</Selectivity>
</Property>
<Property name="DTY">
<OutlierSelectivity>.203883:"varchar(10)"</OutlierSelectivity>
<Selectivity>3.4614%</Selectivity>
</Property>
<Property name="FIL">
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="MAX">
<OutlierSelectivity>.177994:8</OutlierSelectivity>
<Selectivity>1.4173%</Selectivity>
</Property>
<Property name="MIN">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="REF">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-16</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRCOLSS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
