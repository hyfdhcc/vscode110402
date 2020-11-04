/// Latvian Word Index
Class %UMLS.meta.MRXWLAV Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_LAV, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 23
Property WD As %String(MAXLEN = 64);

Index XMRXWLAVWD On WD [ SqlName = X_MRXW_LAV_WD, Type = index ];

Storage Default
{
<Data name="MRXWLAVDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CUI</Value>
</Value>
<Value name="3">
<Value>LAT</Value>
</Value>
<Value name="4">
<Value>LUI</Value>
</Value>
<Value name="5">
<Value>SUI</Value>
</Value>
<Value name="6">
<Value>WD</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRXWLAVD</DataLocation>
<DefaultData>MRXWLAVDefaultData</DefaultData>
<ExtentSize>3167</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWLAVD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWLAVI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.995858:</OutlierSelectivity>
<Selectivity>0.0414%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0751%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.995858:"LAV"</OutlierSelectivity>
<Selectivity>0.0414%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0580%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0580%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.3170%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-100</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_LAV_WD">
<BlockCount>-20</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWLAVS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
