/// Finnish Word Index
Class %UMLS.meta.MRXWFIN Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_FIN, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 8
Property LUI As %String(MAXLEN = 16);

/// Unique identifier for string // MAXLEN = 8
Property SUI As %String(MAXLEN = 16);

/// Word in lower-case // MAXLEN = 54
Property WD As %String(MAXLEN = 128);

Index XMRXWFINWD On WD [ SqlName = X_MRXW_FIN_WD, Type = index ];

Storage Default
{
<Data name="MRXWFINDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWFIND</DataLocation>
<DefaultData>MRXWFINDefaultData</DefaultData>
<ExtentSize>42922</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWFIND</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWFINI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.998875:</OutlierSelectivity>
<Selectivity>0.0113%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0032%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.998875:"FIN"</OutlierSelectivity>
<Selectivity>0.0113%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0032%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0032%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0256%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-1324</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_FIN_WD">
<BlockCount>-308</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWFINS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
