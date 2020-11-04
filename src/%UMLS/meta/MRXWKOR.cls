/// Korean Word Index
Class %UMLS.meta.MRXWKOR Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_KOR, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 64);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 32);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 128);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 128);

/// Word in lower-case // MAXLEN = 15
Property WD As %String(MAXLEN = 128);

Index XMRXWKORWD On WD [ SqlName = X_MRXW_KOR_WD, Type = index ];

Storage Default
{
<Data name="MRXWKORDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWKORD</DataLocation>
<DefaultData>MRXWKORDefaultData</DefaultData>
<ExtentSize>45604</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWKORD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWKORI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.998908:</OutlierSelectivity>
<Selectivity>0.0109%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0072%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.998908:"KOR"</OutlierSelectivity>
<Selectivity>0.0109%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0072%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0072%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.1203%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-1324</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_KOR_WD">
<BlockCount>-228</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWKORS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
