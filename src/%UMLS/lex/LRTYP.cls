/// Inflection Type
Class %UMLS.lex.LRTYP Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Syntactic Category
Property SCA As %String(MAXLEN = 50);

/// Inflectional Type
Property TYP As %String(MAXLEN = 1024);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRTYPDefaultData">
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
<Value>SCA</Value>
</Value>
<Value name="5">
<Value>TYP</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRTYPD</DataLocation>
<DefaultData>LRTYPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRTYPD</IdLocation>
<IndexLocation>^%UMLS.lex.LRTYPI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-4880</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-24112</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRTYPS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
