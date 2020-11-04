/// Related Concepts
Class %UMLS.meta.MRREL Extends %Persistent [ DdlAllowed, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for first atom // MAXLEN = 9
Property AUI1 As %String(MAXLEN = 16);

/// Unique identifier for second atom // MAXLEN = 9
Property AUI2 As %String(MAXLEN = 16);

/// Unique identifier for first concept // MAXLEN = 8
Property CUI1 As %String(MAXLEN = 8);

/// Unique identifier for second concept // MAXLEN = 8
Property CUI2 As %String(MAXLEN = 8);

/// Content view flag // MAXLEN = 0
Property CVF As %String(MAXLEN = 1);

/// Source asserted directionality flag // MAXLEN = 1
Property DIR As %String(MAXLEN = 1);

/// Relationship label // MAXLEN = 3
Property REL As %String(MAXLEN = 4);

/// Additional relationship label // MAXLEN = 54
Property RELA As %String(MAXLEN = 64);

/// Relationship group // MAXLEN = 4
Property RG As %String(MAXLEN = 4);

/// Unique identifier for relationship // MAXLEN = 10
Property RUI As %String(MAXLEN = 16);

/// Source abbreviation // MAXLEN = 15
Property SAB As %String(MAXLEN = 16);

/// Source of relationship labels // MAXLEN = 15
Property SL As %String(MAXLEN = 16);

/// Source attributed relationship identifier // MAXLEN = 36
Property SRUI As %String(MAXLEN = 64);

/// The name of the column in MRCONSO.RRF that contains the first identifier to which the relationship is attached // MAXLEN = 4
Property STYPE1 As %String(MAXLEN = 4);

/// The name of the column in MRCONSO.RRF that contains the second identifier to which the relationship is attached // MAXLEN = 4
Property STYPE2 As %String(MAXLEN = 4);

/// Suppressible flag // MAXLEN = 1
Property SUPPRESS As %String(MAXLEN = 1);

Index XMRRELAUI1 On AUI1 [ SqlName = X_MRREL_AUI1, Type = index ];

Index XMRRELAUI2 On AUI2 [ SqlName = X_MRREL_AUI2, Type = index ];

Index XMRRELCUI1 On CUI1 [ SqlName = X_MRREL_CUI1, Type = index ];

Index XMRRELCUI2 On CUI2 [ SqlName = X_MRREL_CUI2, Type = index ];

Index XMRRELPK On RUI [ PrimaryKey, SqlName = X_MRREL_PK, Type = index, Unique ];

Index XMRRELSAB On SAB [ SqlName = X_MRREL_SAB, Type = index ];

Index RELIdx On REL [ Type = bitmap ];

Index RELAIdx On RELA [ Type = bitmap ];

Index CUI1RELIdx On (CUI1, REL, RELA);

Index CUI1RELAIdx On (CUI1, RELA);

Index AUI1RELIdx On (AUI1, REL, RELA);

Index AUI1RELAIdx On (AUI1, RELA);

Storage Default
{
<Data name="MRRELDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AUI1</Value>
</Value>
<Value name="3">
<Value>AUI2</Value>
</Value>
<Value name="4">
<Value>CUI1</Value>
</Value>
<Value name="5">
<Value>CUI2</Value>
</Value>
<Value name="6">
<Value>CVF</Value>
</Value>
<Value name="7">
<Value>DIR</Value>
</Value>
<Value name="8">
<Value>REL</Value>
</Value>
<Value name="9">
<Value>RELA</Value>
</Value>
<Value name="10">
<Value>RG</Value>
</Value>
<Value name="11">
<Value>RUI</Value>
</Value>
<Value name="12">
<Value>SAB</Value>
</Value>
<Value name="13">
<Value>SL</Value>
</Value>
<Value name="14">
<Value>SRUI</Value>
</Value>
<Value name="15">
<Value>STYPE1</Value>
</Value>
<Value name="16">
<Value>STYPE2</Value>
</Value>
<Value name="17">
<Value>SUPPRESS</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRRELD</DataLocation>
<DefaultData>MRRELDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRRELD</IdLocation>
<IndexLocation>^%UMLS.meta.MRRELI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRRELS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
