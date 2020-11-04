/// Modifiers
Class %UMLS.lex.LRMOD Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Features
Property FEA As %String(MAXLEN = 50);

/// Position for Adjectives<br>
/// Modification Type for Adverbs<br>
/// 
Property PSNMOD As %String(MAXLEN = 128);

/// Syntactic Category
Property SCA As %String(MAXLEN = 50);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRMODDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BAS</Value>
</Value>
<Value name="3">
<Value>EUI</Value>
</Value>
<Value name="4">
<Value>FEA</Value>
</Value>
<Value name="5">
<Value>PSNMOD</Value>
</Value>
<Value name="6">
<Value>SCA</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRMODD</DataLocation>
<DefaultData>LRMODDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRMODD</IdLocation>
<IndexLocation>^%UMLS.lex.LRMODI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-652</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-3856</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRMODS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
