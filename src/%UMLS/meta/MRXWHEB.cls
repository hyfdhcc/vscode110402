/// Hebrew Word Index
Class %UMLS.meta.MRXWHEB Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_HEB, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 8
Property LUI As %String(MAXLEN = 16);

/// Unique identifier for string // MAXLEN = 8
Property SUI As %String(MAXLEN = 16);

/// Word in lower-case // MAXLEN = 19
Property WD As %String(MAXLEN = 64);

Index XMRXWHEBWD On WD [ SqlName = X_MRXW_HEB_WD, Type = index ];

Storage Default
{
<Data name="MRXWHEBDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWHEBD</DataLocation>
<DefaultData>MRXWHEBDefaultData</DefaultData>
<ExtentSize>1617</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWHEBD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWHEBI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.994215:</OutlierSelectivity>
<Selectivity>0.0618%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.2165%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.994215:"HEB"</OutlierSelectivity>
<Selectivity>0.0618%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.2165%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.2165%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.4019%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-48</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_HEB_WD">
<BlockCount>-12</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWHEBS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
