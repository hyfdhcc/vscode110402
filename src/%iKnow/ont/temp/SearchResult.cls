Class %iKnow.ont.temp.SearchResult Extends %Persistent [ System = 4 ]
{

Property term As %String(MAXLEN = 4096);

Property mask As %Binary(MAXLEN = 256);

Property sid As %String(MAXLEN = 128);

Property CUI As %String;

Property SUI As %String;

Property ft As %String;

Property Dist As %Double;

Property BM25 As %Double;

Property Dist2 As %Double;

Index SIDIdx On sid [ Type = bitmap ];

Storage Default
{
<Data name="SearchResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>term</Value>
</Value>
<Value name="3">
<Value>mask</Value>
</Value>
<Value name="4">
<Value>CUI</Value>
</Value>
<Value name="5">
<Value>Dist</Value>
</Value>
<Value name="6">
<Value>BM25</Value>
</Value>
<Value name="7">
<Value>Dist2</Value>
</Value>
<Value name="8">
<Value>ft</Value>
</Value>
<Value name="9">
<Value>SUI</Value>
</Value>
<Value name="10">
<Value>sid</Value>
</Value>
</Data>
<DataLocation>^CacheTemp.IK.Ont.SearchResultD</DataLocation>
<DefaultData>SearchResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CacheTemp.IK.Ont.SearchResultD</IdLocation>
<IndexLocation>^CacheTemp.IK.Ont.SearchResultI</IndexLocation>
<StreamLocation>^CacheTemp.IK.Ont.SearchResultS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
