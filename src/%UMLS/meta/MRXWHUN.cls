/// Hungarian Word Index
Class %UMLS.meta.MRXWHUN Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_HUN, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 28
Property WD As %String(MAXLEN = 64);

Index XMRXWHUNWD On WD [ SqlName = X_MRXW_HUN_WD, Type = index ];

Storage Default
{
<Data name="MRXWHUNDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWHUND</DataLocation>
<DefaultData>MRXWHUNDefaultData</DefaultData>
<ExtentSize>252045</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWHUND</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWHUNI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999535:</OutlierSelectivity>
<Selectivity>0.0046%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0024%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999535:"HUN"</OutlierSelectivity>
<Selectivity>0.0046%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0012%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0012%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0617%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-7676</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_HUN_WD">
<BlockCount>-1200</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWHUNS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
