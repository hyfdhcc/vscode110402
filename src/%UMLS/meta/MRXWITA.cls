/// Italian Word Index
Class %UMLS.meta.MRXWITA Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_ITA, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 38
Property WD As %String(MAXLEN = 128);

Index XMRXWITAWD On WD [ SqlName = X_MRXW_ITA_WD, Type = index ];

Storage Default
{
<Data name="MRXWITADefaultData">
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
<DataLocation>^%UMLS.meta.MRXWITAD</DataLocation>
<DefaultData>MRXWITADefaultData</DefaultData>
<ExtentSize>420347</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWITAD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWITAI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.99964:</OutlierSelectivity>
<Selectivity>0.0036%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0025%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.99964:"ITA"</OutlierSelectivity>
<Selectivity>0.0036%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0013%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0013%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0559%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-12184</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_ITA_WD">
<BlockCount>-1996</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWITAS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
