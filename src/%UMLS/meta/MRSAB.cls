/// Source Metadata
Class %UMLS.meta.MRSAB Extends %Persistent [ DdlAllowed, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Attribute name list for a source // MAXLEN = 743
Property ATNL As %String(COLLATION = "SqlUpper(150)", MAXLEN = 1024);

/// Character encoding of a source as specified by IANA // MAXLEN = 5
Property CENC As %String(MAXLEN = 8);

/// CUI frequency for a source // MAXLEN = 6
Property CFR As %String(MAXLEN = 8);

/// Current Version flag // MAXLEN = 1
Property CURVER As %String(MAXLEN = 1);

/// Context type for a source // MAXLEN = 31
Property CXTY As %String(MAXLEN = 32);

/// Version of the Metathesaurus that a source was added // MAXLEN = 6
Property IMETA As %String(MAXLEN = 8);

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String(MAXLEN = 4);

/// Unique identifier for root SRC concept // MAXLEN = 8
Property RCUI As %String(MAXLEN = 8);

/// Version of the Metathesaurus where a version is removed // MAXLEN = 6
Property RMETA As %String(MAXLEN = 8);

/// Root source abbreviation // MAXLEN = 15
Property RSAB As %String(MAXLEN = 16);

/// Source in current subset // MAXLEN = 1
Property SABIN As %String(MAXLEN = 1);

/// Content contact info for a source // MAXLEN = 354
Property SCC As %String(COLLATION = "SqlUpper(150)", MAXLEN = 512);

/// Source citation // MAXLEN = 445
Property SCIT As %String(COLLATION = "SqlUpper(150)", MAXLEN = 512);

/// Source Family // MAXLEN = 13
Property SF As %String(MAXLEN = 16);

/// License contact info for a source // MAXLEN = 354
Property SLC As %String(COLLATION = "SqlUpper(150)", MAXLEN = 512);

/// Source Official Name // MAXLEN = 145
Property SON As %String(COLLATION = "SqlUpper(150)", MAXLEN = 256);

/// Source Restriction Level // MAXLEN = 1
Property SRL As %String(MAXLEN = 1);

/// Source short name // MAXLEN = 89
Property SSN As %String(MAXLEN = 128);

/// Release date or version number of a source // MAXLEN = 15
Property SVER As %String(MAXLEN = 20);

/// Term frequency for a source // MAXLEN = 7
Property TFR As %String(MAXLEN = 8);

/// Term type list for a source // MAXLEN = 352
Property TTYL As %String(COLLATION = "SqlUpper(150)", MAXLEN = 512);

/// Unique identifier for versioned SRC concept // MAXLEN = 8
Property VCUI As %String(MAXLEN = 8);

/// Valid end date for a source // MAXLEN = 0
Property VEND As %String(MAXLEN = 1);

/// Versioned source abbreviation // MAXLEN = 20
Property VSAB As %String(MAXLEN = 32);

/// Valid start date for a source // MAXLEN = 8
Property VSTART As %String(MAXLEN = 8);

Index XMRSABPK On VSAB [ PrimaryKey, SqlName = X_MRSAB_PK, Type = index, Unique ];

Index XMRSABRSAB On RSAB [ SqlName = X_MRSAB_RSAB, Type = index ];

Storage Default
{
<Data name="MRSABDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ATNL</Value>
</Value>
<Value name="3">
<Value>CENC</Value>
</Value>
<Value name="4">
<Value>CFR</Value>
</Value>
<Value name="5">
<Value>CURVER</Value>
</Value>
<Value name="6">
<Value>CXTY</Value>
</Value>
<Value name="7">
<Value>IMETA</Value>
</Value>
<Value name="8">
<Value>LAT</Value>
</Value>
<Value name="9">
<Value>RCUI</Value>
</Value>
<Value name="10">
<Value>RMETA</Value>
</Value>
<Value name="11">
<Value>RSAB</Value>
</Value>
<Value name="12">
<Value>SABIN</Value>
</Value>
<Value name="13">
<Value>SCC</Value>
</Value>
<Value name="14">
<Value>SCIT</Value>
</Value>
<Value name="15">
<Value>SF</Value>
</Value>
<Value name="16">
<Value>SLC</Value>
</Value>
<Value name="17">
<Value>SON</Value>
</Value>
<Value name="18">
<Value>SRL</Value>
</Value>
<Value name="19">
<Value>SSN</Value>
</Value>
<Value name="20">
<Value>SVER</Value>
</Value>
<Value name="21">
<Value>TFR</Value>
</Value>
<Value name="22">
<Value>TTYL</Value>
</Value>
<Value name="23">
<Value>VCUI</Value>
</Value>
<Value name="24">
<Value>VEND</Value>
</Value>
<Value name="25">
<Value>VSAB</Value>
</Value>
<Value name="26">
<Value>VSTART</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRSABD</DataLocation>
<DefaultData>MRSABDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRSABD</IdLocation>
<IndexLocation>^%UMLS.meta.MRSABI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRSABS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
