/// Relation Relation
Class %UMLS.meta.MRFILES Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRFILES, System = 4 ]
{

/// Size in Bytes // MAXLEN = 10
Property BTS As %String(MAXLEN = 16);

/// Number of columns // MAXLEN = 2
Property CLS As %String(MAXLEN = 2);

/// Descriptive Name // MAXLEN = 42
Property DES As %String(MAXLEN = 64);

/// Physical FILENAME // MAXLEN = 21
Property FIL As %String(MAXLEN = 32);

/// Comma separated list of COL // MAXLEN = 190
Property FMT As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

/// Number of rows // MAXLEN = 8
Property RWS As %String(MAXLEN = 8);

Storage Default
{
<Data name="MRFILESDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTS</Value>
</Value>
<Value name="3">
<Value>CLS</Value>
</Value>
<Value name="4">
<Value>DES</Value>
</Value>
<Value name="5">
<Value>FIL</Value>
</Value>
<Value name="6">
<Value>FMT</Value>
</Value>
<Value name="7">
<Value>RWS</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRFILESD</DataLocation>
<DefaultData>MRFILESDefaultData</DefaultData>
<ExtentSize>46</ExtentSize>
<IdLocation>^%UMLS.meta.MRFILESD</IdLocation>
<IndexLocation>^%UMLS.meta.MRFILESI</IndexLocation>
<Property name="%%CLASSNAME">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="BTS">
<Selectivity>2.3256%</Selectivity>
</Property>
<Property name="CLS">
<OutlierSelectivity>.5:5</OutlierSelectivity>
<Selectivity>3.8462%</Selectivity>
</Property>
<Property name="DES">
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="FIL">
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="FMT">
<OutlierSelectivity>.456522:"LAT,WD,CUI,LUI,SUI"</OutlierSelectivity>
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="RWS">
<Selectivity>2.3256%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRFILESS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
