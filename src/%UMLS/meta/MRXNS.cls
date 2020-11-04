/// Normalized String Index
Class %UMLS.meta.MRXNS Extends %Persistent [ SqlTableName = MRXNS_ENG, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Language of Term(s) // MAXLEN = 3
Property LAT As %String;

/// Normalized string // MAXLEN = 2532
Property NSTR As %String(COLLATION = "SQLUPPER(150)", MAXLEN = 4096);

/// Unique identifier for concept // MAXLEN = 8
Property CUI As %String;

/// Unique identifier for term // MAXLEN = 9
Property LUI As %String;

/// Unique identifier for string // MAXLEN = 9
Property SUI As %String;

Index i1 On SUI;

Index NstrIdx On NSTR;

Storage Default
{
<Data name="MRXNSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LAT</Value>
</Value>
<Value name="3">
<Value>NSTR</Value>
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
</Data>
<DataLocation>^%UMLS.meta.MRXNSD</DataLocation>
<DefaultData>MRXNSDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRXNSD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXNSI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRXNSS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
