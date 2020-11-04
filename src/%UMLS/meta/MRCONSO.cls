/// Concept names and sources
Class %UMLS.meta.MRCONSO Extends %Persistent [ System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %Library.String(MAXLEN = 8) [ Required, SqlColumnNumber = 2 ];

/// Language of Term(s) // MAXLEN = 3
Property LAT As %Library.String(MAXLEN = 3) [ Required, SqlColumnNumber = 3 ];

/// Term status // MAXLEN = 1
Property TS As %Library.String(MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// Unique identifier for term // MAXLEN = 9
Property LUI As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// String type // MAXLEN = 3
Property STT As %Library.String(MAXLEN = 3) [ Required, SqlColumnNumber = 6 ];

/// Unique identifier for string // MAXLEN = 9
Property SUI As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

/// Indicates whether AUI is preferred // MAXLEN = 1
Property ISPREF As %Library.String(MAXLEN = 1) [ Required, SqlColumnNumber = 8 ];

/// Unique identifier for atom // MAXLEN = 9
Property AUI As %Library.String(MAXLEN = 9) [ Required, SqlColumnNumber = 9 ];

/// Source asserted atom identifier // MAXLEN = 10
Property SAUI As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 10 ];

/// Source asserted concept identifier // MAXLEN = 20
Property SCUI As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// Source asserted descriptor identifier // MAXLEN = 13
Property SDUI As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// Source abbreviation // MAXLEN = 15
Property SAB As %Library.String(MAXLEN = 20) [ Required, SqlColumnNumber = 13 ];

/// Term type in source // MAXLEN = 11
Property TTY As %Library.String(MAXLEN = 20) [ Required, SqlColumnNumber = 14 ];

/// Unique Identifier or code for string in source // MAXLEN = 30
Property CODE As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 15 ];

/// String // MAXLEN = 2864
Property STR As %String(COLLATION = "SQLUPPER(150)", MAXLEN = 4096) [ Required, SqlColumnNumber = 16 ];

/// Source Restriction Level // MAXLEN = 1
Property SRL As %Library.Integer [ Required, SqlColumnNumber = 17 ];

/// Suppressible flag // MAXLEN = 1
Property SUPPRESS As %Library.String(MAXLEN = 1) [ Required, SqlColumnNumber = 18 ];

/// Content view flag // MAXLEN = 4
Property CVF As %Library.Integer [ SqlColumnNumber = 19 ];

Property L1 As %Integer [ Calculated, SqlComputeCode = {set {*} = $l({STR})}, SqlComputed ];

Property L2 As %Integer [ Calculated, SqlComputeCode = {set {*} = $l({STR}," ")}, SqlComputed ];

Property BM25 As %Double;

Index i1 On SUI;

Index i2 On CUI;

Index iAUI On AUI;

Index iCODE On CODE;

/// cuicoll.%ID value corresponding to this CUI
Property cuiID As CUICOLL [ Calculated, SqlComputeCode = { s cui={cui}
  &SQL(SELECT %ID INTO :%ci FROM %UMLS_meta.cuicoll WHERE cui=:cui)
  s {*}=$g(%ci)}, SqlComputed ];

Index i3 On cuiID [ Data = (CUI, STR, SAB) ];

Property suiID As SUICOLL [ Calculated, SqlComputeCode = { s sui={sui}
  &SQL(SELECT %ID INTO :%si FROM %UMLS_meta.suicoll WHERE sui=:sui)
  s {*}=$g(%si)}, SqlComputed ];

Index i4 On suiID [ Data = (SUI, CUI, STR, SAB) ];

Index iSAB On SAB [ Type = bitmap ];

Index iL1 On L1 [ Type = bitmap ];

Index iL2 On L2 [ Type = bitmap ];

Index iLANG On LAT [ Type = bitmap ];

Index iStr On STR As SqlUpper(150);

Storage Default
{
<Data name="MRCONSODefaultData">
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
<Value>TS</Value>
</Value>
<Value name="5">
<Value>LUI</Value>
</Value>
<Value name="6">
<Value>STT</Value>
</Value>
<Value name="7">
<Value>SUI</Value>
</Value>
<Value name="8">
<Value>ISPREF</Value>
</Value>
<Value name="9">
<Value>AUI</Value>
</Value>
<Value name="10">
<Value>SAUI</Value>
</Value>
<Value name="11">
<Value>SCUI</Value>
</Value>
<Value name="12">
<Value>SDUI</Value>
</Value>
<Value name="13">
<Value>SAB</Value>
</Value>
<Value name="14">
<Value>TTY</Value>
</Value>
<Value name="15">
<Value>CODE</Value>
</Value>
<Value name="16">
<Value>STR</Value>
</Value>
<Value name="17">
<Value>SRL</Value>
</Value>
<Value name="18">
<Value>SUPPRESS</Value>
</Value>
<Value name="19">
<Value>CVF</Value>
</Value>
<Value name="20">
<Value>L1</Value>
</Value>
<Value name="21">
<Value>L2</Value>
</Value>
<Value name="22">
<Value>BM25</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRCONSOD</DataLocation>
<DefaultData>MRCONSODefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRCONSOD</IdLocation>
<IndexLocation>^%UMLS.meta.MRCONSOI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRCONSOS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
