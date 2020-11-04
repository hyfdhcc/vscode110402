/// Spelling Variants
Class %UMLS.lex.LRSPL Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Citation Form
Property CIT As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Spelling Variant
Property SPV As %String(MAXLEN = 1024);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRSPLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CIT</Value>
</Value>
<Value name="3">
<Value>EUI</Value>
</Value>
<Value name="4">
<Value>SPV</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRSPLD</DataLocation>
<DefaultData>LRSPLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRSPLD</IdLocation>
<IndexLocation>^%UMLS.lex.LRSPLI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-896</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-4920</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRSPLS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
