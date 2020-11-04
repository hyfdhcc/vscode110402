/// Complementation
Class %UMLS.lex.LRCMP Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Complements
Property COM As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Syntactic Category
Property SCA As %String(MAXLEN = 50);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRCMPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BAS</Value>
</Value>
<Value name="3">
<Value>COM</Value>
</Value>
<Value name="4">
<Value>EUI</Value>
</Value>
<Value name="5">
<Value>SCA</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRCMPD</DataLocation>
<DefaultData>LRCMPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRCMPD</IdLocation>
<IndexLocation>^%UMLS.lex.LRCMPI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-360</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-1888</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRCMPS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
