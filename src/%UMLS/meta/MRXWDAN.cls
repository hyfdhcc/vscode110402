/// Danish Word Index
Class %UMLS.meta.MRXWDAN Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_DAN, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 8
Property LUI As %String(MAXLEN = 16);

/// Unique identifier for string // MAXLEN = 8
Property SUI As %String(MAXLEN = 16);

/// Word in lower-case // MAXLEN = 25
Property WD As %String(MAXLEN = 64);

Index XMRXWDANWD On WD [ SqlName = X_MRXW_DAN_WD, Type = index ];

Storage Default
{
<Data name="MRXWDANDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWDAND</DataLocation>
<DefaultData>MRXWDANDefaultData</DefaultData>
<ExtentSize>2466</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWDAND</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWDANI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.995302:</OutlierSelectivity>
<Selectivity>0.0470%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.1312%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.995302:"DAN"</OutlierSelectivity>
<Selectivity>0.0470%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.1312%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.1312%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.4464%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-72</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_DAN_WD">
<BlockCount>-16</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWDANS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
