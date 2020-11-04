/// Word Index
Class %UMLS.lex.LRWD Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Word
Property WRD As %String(MAXLEN = 1024);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRWDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EUI</Value>
</Value>
<Value name="3">
<Value>WRD</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRWDD</DataLocation>
<DefaultData>LRWDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRWDD</IdLocation>
<IndexLocation>^%UMLS.lex.LRWDI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-8376</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-18848</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRWDS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
