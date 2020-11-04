/// Polish Word Index
Class %UMLS.meta.MRXWPOL Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_POL, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 48
Property WD As %String(MAXLEN = 128);

Index XMRXWPOLWD On WD [ SqlName = X_MRXW_POL_WD, Type = index ];

Storage Default
{
<Data name="MRXWPOLDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWPOLD</DataLocation>
<DefaultData>MRXWPOLDefaultData</DefaultData>
<ExtentSize>105308</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWPOLD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWPOLI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999281:</OutlierSelectivity>
<Selectivity>0.0072%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0076%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999281:"POL"</OutlierSelectivity>
<Selectivity>0.0072%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0024%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0024%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0299%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-3276</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_POL_WD">
<BlockCount>-588</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWPOLS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
