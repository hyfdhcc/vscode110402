/// German Word Index
Class %UMLS.meta.MRXWGER Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MRXW_GER, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String(MAXLEN = 16);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 8);

/// Unique identifier for term // MAXLEN = 8
Property LUI As %String(MAXLEN = 16);

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String(MAXLEN = 32);

/// Word in lower-case // MAXLEN = 45
Property WD As %String(MAXLEN = 128);

Index XMRXWGERWD On WD [ SqlName = X_MRXW_GER_WD, Type = index ];

Storage Default
{
<Data name="MRXWGERDefaultData">
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
<DataLocation>^%UMLS.meta.MRXWGERD</DataLocation>
<DefaultData>MRXWGERDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRXWGERD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXWGERI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRXWGERS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
