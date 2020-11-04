/// Basque Word Index
Class %UMLS.meta.MRXWBAQ Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_BAQ, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 8
Property LUI As %String(MAXLEN = 16);

/// Unique identifier for string // MAXLEN = 8
Property SUI As %String(MAXLEN = 16);

/// Word in lower-case // MAXLEN = 18
Property WD As %String(MAXLEN = 64);

Index XMRXWBAQWD On WD [ SqlName = X_MRXW_BAQ_WD, Type = index ];

Storage Default
{
<Data name="MRXWBAQDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWBAQD</DataLocation>
<DefaultData>MRXWBAQDefaultData</DefaultData>
<ExtentSize>2669</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWBAQD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWBAQI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.995484:</OutlierSelectivity>
<Selectivity>0.0452%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.1753%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.995484:"BAQ"</OutlierSelectivity>
<Selectivity>0.0452%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.1753%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.1753%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.3475%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-80</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_BAQ_WD">
<BlockCount>-16</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWBAQS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
