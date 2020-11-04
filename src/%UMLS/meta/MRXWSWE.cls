/// Swedish Word Index
Class %UMLS.meta.MRXWSWE Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_SWE, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 8
Property LUI As %String(MAXLEN = 16);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 38
Property WD As %String(MAXLEN = 128);

Index XMRXWSWEWD On WD [ SqlName = X_MRXW_SWE_WD, Type = index ];

Storage Default
{
<Data name="MRXWSWEDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWSWED</DataLocation>
<DefaultData>MRXWSWEDefaultData</DefaultData>
<ExtentSize>43977</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWSWED</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWSWEI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.998887:</OutlierSelectivity>
<Selectivity>0.0111%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0038%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.998887:"SWE"</OutlierSelectivity>
<Selectivity>0.0111%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0038%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0038%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0307%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-1336</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_SWE_WD">
<BlockCount>-308</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWSWES</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
