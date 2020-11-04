Class %UMLS.lex.LNORM Extends %Persistent [ System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

Property STR As %String(MAXLEN = 128);

Property NRM As %String(MAXLEN = 128);

Index IDKey On STR [ IdKey, Unique ];

Storage Default
{
<Data name="LNORMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NRM</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LNORMD</DataLocation>
<DefaultData>LNORMDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LNORMD</IdLocation>
<IndexLocation>^%UMLS.lex.LNORMI</IndexLocation>
<StreamLocation>^%UMLS.lex.LNORMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
