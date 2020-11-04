/// Spanish Word Index
Class %UMLS.meta.MRXWSPA Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_SPA, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 46
Property WD As %String(MAXLEN = 128);

Index XMRXWSPAWD On WD [ SqlName = X_MRXW_SPA_WD, Type = index ];

Storage Default
{
<Data name="MRXWSPADefaultData">
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
<DataLocation>^%UMLS.meta.MRXWSPAD</DataLocation>
<DefaultData>MRXWSPADefaultData</DefaultData>
<ExtentSize>5959156</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWSPAD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWSPAI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999904:</OutlierSelectivity>
<Selectivity>0.0010%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0005%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999904:"SPA"</OutlierSelectivity>
<Selectivity>0.0010%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0002%</Selectivity>
</Property>
<Property name="WD">
<OutlierSelectivity>.079749:"de"</OutlierSelectivity>
<Selectivity>0.0285%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-171284</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_SPA_WD">
<BlockCount>-26576</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWSPAS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
