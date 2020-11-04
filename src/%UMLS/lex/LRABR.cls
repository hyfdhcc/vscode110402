/// Abbreviations and Acronyms
Class %UMLS.lex.LRABR Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Acronym or Abbreviation
Property ABR As %String(MAXLEN = 50);

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Base Form
Property BAS1 As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Unique Identifier Number for Lexical Entries
Property EUI1 As %String(MAXLEN = 50);

Index EUIIdx On (EUI, EUI1);

Storage Default
{
<Data name="LRABRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ABR</Value>
</Value>
<Value name="3">
<Value>BAS</Value>
</Value>
<Value name="4">
<Value>BAS1</Value>
</Value>
<Value name="5">
<Value>EUI</Value>
</Value>
<Value name="6">
<Value>EUI1</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRABRD</DataLocation>
<DefaultData>LRABRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRABRD</IdLocation>
<IndexLocation>^%UMLS.lex.LRABRI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-1456</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-10556</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRABRS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
