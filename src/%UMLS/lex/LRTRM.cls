/// Trade Marks
Class %UMLS.lex.LRTRM Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Generic Term
Property GEN As %String(MAXLEN = 1024);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRTRMDefaultData">
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
<Value>GEN</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRTRMD</DataLocation>
<DefaultData>LRTRMDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRTRMD</IdLocation>
<IndexLocation>^%UMLS.lex.LRTRMI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-32</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-152</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRTRMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
