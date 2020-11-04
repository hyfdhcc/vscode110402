/// French Word Index
Class %UMLS.meta.MRXWFRE Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_FRE, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 39
Property WD As %String(MAXLEN = 128);

Index XMRXWFREWD On WD [ SqlName = X_MRXW_FRE_WD, Type = index ];

Storage Default
{
<Data name="MRXWFREDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWFRED</DataLocation>
<DefaultData>MRXWFREDefaultData</DefaultData>
<ExtentSize>673811</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWFRED</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWFREI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999716:</OutlierSelectivity>
<Selectivity>0.0028%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0024%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999716:"FRE"</OutlierSelectivity>
<Selectivity>0.0028%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0009%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0009%</Selectivity>
</Property>
<Property name="WD">
<OutlierSelectivity>.056841:"de"</OutlierSelectivity>
<Selectivity>0.0420%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-19400</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_FRE_WD">
<BlockCount>-3156</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWFRES</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
