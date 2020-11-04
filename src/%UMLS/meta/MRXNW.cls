/// Normalized Word Index
Class %UMLS.meta.MRXNW Extends %Persistent [ SqlTableName = MRXNW_ENG, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String;

/// Normalized word // MAXLEN = 80
Property NWD As %String(MAXLEN = 100);

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String;

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String;

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String;

Property CUITF As %Integer [ SqlFieldName = cui_tf ];

Property CUITF2 As %Integer [ SqlFieldName = cui_tf2 ];

Property CUIDF As %Integer [ SqlFieldName = cui_df ];

Property CUIDL As %Integer [ SqlFieldName = cui_dl ];

Index i1 On NWD [ Type = bitmap ];

Index i2 On CUI;

Index i3 On SUI;

Index i12 On (NWD, CUI);

// Index TfIdx On CUITF;

// Index DfIdx On CUIDF [ Type = bitmap ];

// Index DlIdx On CUIDL [ Type = bitmap ];

Property tfIsNull As %Boolean(SELECTIVITY = "50.00000%") [ Calculated, SqlComputeCode = {Set {*} = ({cui_tf} = "")}, SqlComputed ];

Property tf2IsNull As %Boolean(SELECTIVITY = "50.00000%") [ Calculated, SqlComputeCode = {Set {*} = ({cui_tf2} = "")}, SqlComputed ];

Property dfIsNull As %Boolean(SELECTIVITY = "50.00000%") [ Calculated, SqlComputeCode = {Set {*} = ({cui_df} = "")}, SqlComputed ];

Property dlIsNull As %Boolean(SELECTIVITY = "50.00000%") [ Calculated, SqlComputeCode = {Set {*} = ({cui_dl} = "")}, SqlComputed ];

Index TfIdx1 On tfIsNull [ Type = bitmap ];

Index TfIdx2 On tf2IsNull [ Type = bitmap ];

Index DfIdx1 On dfIsNull [ Type = bitmap ];

Index DlIdx1 On dlIsNull [ Type = bitmap ];

Storage Default
{
<Data name="MRXNWDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LAT</Value>
</Value>
<Value name="3">
<Value>NWD</Value>
</Value>
<Value name="4">
<Value>CUI</Value>
</Value>
<Value name="5">
<Value>LUI</Value>
</Value>
<Value name="6">
<Value>SUI</Value>
</Value>
<Value name="7">
<Value>CUITF</Value>
</Value>
<Value name="8">
<Value>CUITF2</Value>
</Value>
<Value name="9">
<Value>CUIDF</Value>
</Value>
<Value name="10">
<Value>CUIDL</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRXNWD</DataLocation>
<DefaultData>MRXNWDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRXNWD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXNWI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRXNWS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
