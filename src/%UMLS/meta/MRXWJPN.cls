/// Japanese Word Index
Class %UMLS.meta.MRXWJPN Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_JPN, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 64);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 32);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 128);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 128);

/// Word in lower-case // MAXLEN = 93
Property WD As %String(COLLATION = "SqlUpper(150)", MAXLEN = 1024);

Index XMRXWJPNWD On WD [ SqlName = X_MRXW_JPN_WD, Type = index ];

Storage Default
{
<Data name="MRXWJPNDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWJPND</DataLocation>
<DefaultData>MRXWJPNDefaultData</DefaultData>
<ExtentSize>210742</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWJPND</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWJPNI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999492:</OutlierSelectivity>
<Selectivity>0.0051%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0032%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999492:"JPN"</OutlierSelectivity>
<Selectivity>0.0051%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0005%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0005%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0022%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-7460</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_JPN_WD">
<BlockCount>-1944</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWJPNS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
