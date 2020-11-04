/// Norwegian Word Index
Class %UMLS.meta.MRXWNOR Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_NOR, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 44
Property WD As %String(MAXLEN = 128);

Index XMRXWNORWD On WD [ SqlName = X_MRXW_NOR_WD, Type = index ];

Storage Default
{
<Data name="MRXWNORDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWNORD</DataLocation>
<DefaultData>MRXWNORDefaultData</DefaultData>
<ExtentSize>102408</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWNORD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWNORI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999271:</OutlierSelectivity>
<Selectivity>0.0073%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0069%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999271:"NOR"</OutlierSelectivity>
<Selectivity>0.0073%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0021%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0021%</Selectivity>
</Property>
<Property name="WD">
<Selectivity>0.0290%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-3176</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_NOR_WD">
<BlockCount>-620</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWNORS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
