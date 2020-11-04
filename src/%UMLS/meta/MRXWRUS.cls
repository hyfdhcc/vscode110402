/// Russian Word Index
Class %UMLS.meta.MRXWRUS Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_RUS, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 40
Property WD As %String(MAXLEN = 128);

Index XMRXWRUSWD On WD [ SqlName = X_MRXW_RUS_WD, Type = index ];

Storage Default
{
<Data name="MRXWRUSDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWRUSD</DataLocation>
<DefaultData>MRXWRUSDefaultData</DefaultData>
<ExtentSize>278473</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWRUSD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWRUSI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999558:</OutlierSelectivity>
<Selectivity>0.0044%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0066%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999558:"RUS"</OutlierSelectivity>
<Selectivity>0.0044%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0008%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0008%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0233%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-8872</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_RUS_WD">
<BlockCount>-1508</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWRUSS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
