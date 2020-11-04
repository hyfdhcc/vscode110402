/// English Word Index
Class %UMLS.meta.MRXWENG Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_ENG, System = 4 ]
{

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String(MAXLEN = 32);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 80
Property WD As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

Index XMRXWENGWD On WD [ SqlName = X_MRXW_ENG_WD, Type = index ];

Storage Default
{
<Data name="MRXWENGDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWENGD</DataLocation>
<DefaultData>MRXWENGDefaultData</DefaultData>
<ExtentSize>40011716</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWENGD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWENGI</IndexLocation>
<Property name="%%CLASSNAME">
<OutlierSelectivity>.999963:</OutlierSelectivity>
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="CUI">
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="LAT">
<OutlierSelectivity>.999963:"ENG"</OutlierSelectivity>
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="LUI">
<Selectivity>0.0000255929031290161%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.0000183629579035194%</Selectivity>
</Property>
<Property name="WD">
<OutlierSelectivity>.028615:"of"</OutlierSelectivity>
<Selectivity>0.0125%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-1147820</BlockCount>
</SQLMap>
<SQLMap name="X_MRXW_ENG_WD">
<BlockCount>-178548</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.meta.MRXWENGS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
