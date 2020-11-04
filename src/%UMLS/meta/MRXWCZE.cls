/// Czech Word Index
Class %UMLS.meta.MRXWCZE Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_CZE, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 52
Property WD As %String(MAXLEN = 128);

Index XMRXWCZEWD On WD [ SqlName = X_MRXW_CZE_WD, Type = index ];

Storage Default
{
<Data name="MRXWCZEDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWCZED</DataLocation>
<DefaultData>MRXWCZEDefaultData</DefaultData>
<ExtentSize>370701</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWCZED</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWCZEI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999617:</OutlierSelectivity>
<Selectivity>0.0038%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0016%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999617:"CZE"</OutlierSelectivity>
<Selectivity>0.0038%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0009%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0009%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0434%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-11228</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_CZE_WD">
<BlockCount>-1816</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWCZES</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
