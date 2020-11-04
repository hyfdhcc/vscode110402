/// Croatian Word Index
Class %UMLS.meta.MRXWSCR Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_SCR, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 37
Property WD As %String(MAXLEN = 128);

Index XMRXWSCRWD On WD [ SqlName = X_MRXW_SCR_WD, Type = index ];

Storage Default
{
<Data name="MRXWSCRDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWSCRD</DataLocation>
<DefaultData>MRXWSCRDefaultData</DefaultData>
<ExtentSize>22811</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWSCRD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWSCRI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.998455:</OutlierSelectivity>
<Selectivity>0.0155%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0087%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.998455:"SCR"</OutlierSelectivity>
<Selectivity>0.0155%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0080%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0080%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.1222%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-692</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_SCR_WD">
<BlockCount>-136</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWSCRS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
