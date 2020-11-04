Class %UMLS.meta.CUICOLL Extends %Persistent [ System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

Property NWD As list Of %String(MAXLEN = 100);

Property CUI As %String;

Property LAT As %String;

Index i1 On NWD(ELEMENTS) [ Type = bitmap ];

Index i3 On (CUI, LAT) [ PrimaryKey, Unique ];

Storage Default
{
<Data name="CUICOLLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NWD</Value>
</Value>
<Value name="3">
<Value>CUI</Value>
</Value>
<Value name="4">
<Value>LAT</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.CUICOLLD</DataLocation>
<DefaultData>CUICOLLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.CUICOLLD</IdLocation>
<IndexLocation>^%UMLS.meta.CUICOLLI</IndexLocation>
<StreamLocation>^%UMLS.meta.CUICOLLS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
