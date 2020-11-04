/// Nominalizations
Class %UMLS.lex.LRNOM Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Base Form
Property BAS1 As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Unique Identifier Number for Lexical Entries
Property EUI1 As %String(MAXLEN = 50);

/// Syntactic Category
Property SCA As %String(MAXLEN = 50);

/// Syntactic Category
Property SCA1 As %String(MAXLEN = 50);

Index EUIIdx On (EUI, EUI1);

Storage Default
{
<Data name="LRNOMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BAS</Value>
</Value>
<Value name="3">
<Value>BAS1</Value>
</Value>
<Value name="4">
<Value>EUI</Value>
</Value>
<Value name="5">
<Value>EUI1</Value>
</Value>
<Value name="6">
<Value>SCA</Value>
</Value>
<Value name="7">
<Value>SCA1</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRNOMD</DataLocation>
<DefaultData>LRNOMDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRNOMD</IdLocation>
<IndexLocation>^%UMLS.lex.LRNOMI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-276</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-1256</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRNOMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
