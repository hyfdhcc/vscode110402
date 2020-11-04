Class %UMLS.meta.MRXNWCOLL Extends %Persistent [ System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

Property NSTR As %String(MAXLEN = 200);

Property CUI As list Of %String;

Property SUI As list Of %String;

Index i1 On CUI(ELEMENTS) [ Type = bitmap ];

Index i2 On SUI(ELEMENTS) [ Type = bitmap ];

Index i3 On NSTR [ Unique ];

Storage Default
{
<Data name="MRXNWCOLLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NSTR</Value>
</Value>
<Value name="3">
<Value>CUI</Value>
</Value>
<Value name="4">
<Value>SUI</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MRXNWCOLLD</DataLocation>
<DefaultData>MRXNWCOLLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MRXNWCOLLD</IdLocation>
<IndexLocation>^%UMLS.meta.MRXNWCOLLI</IndexLocation>
<StreamLocation>^%UMLS.meta.MRXNWCOLLS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
