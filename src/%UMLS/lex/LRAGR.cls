/// Agreement and Inflection
Class %UMLS.lex.LRAGR Extends %Persistent [ DdlAllowed, System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

/// Agreement Inflection Code
Property AGR As %String(MAXLEN = 50);

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Citation Form
Property CIT As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Syntactic Category
Property SCA As %String(MAXLEN = 50);

/// String
Property STR As %String(MAXLEN = 1024);

Index EUIIdx On EUI;

Index STRIdx On STR [ Data = BAS ];

Storage Default
{
<Data name="LRAGRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AGR</Value>
</Value>
<Value name="3">
<Value>BAS</Value>
</Value>
<Value name="4">
<Value>CIT</Value>
</Value>
<Value name="5">
<Value>EUI</Value>
</Value>
<Value name="6">
<Value>SCA</Value>
</Value>
<Value name="7">
<Value>STR</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRAGRD</DataLocation>
<DefaultData>LRAGRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRAGRD</IdLocation>
<IndexLocation>^%UMLS.lex.LRAGRI</IndexLocation>
<StreamLocation>^%UMLS.lex.LRAGRS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
