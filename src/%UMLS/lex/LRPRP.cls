/// Properties
Class %UMLS.lex.LRPRP Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Features
Property FEA As %String(MAXLEN = 50);

/// Syntactic Category
Property SCA As %String(MAXLEN = 50);

/// String
Property STR As %String(MAXLEN = 1024);

Index EUIIdx On EUI;

Index STRIdx On STR;

Storage Default
{
<Data name="LRPRPDefaultData">
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
<Value>SCA</Value>
</Value>
<Value name="6">
<Value>STR</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRPRPD</DataLocation>
<DefaultData>LRPRPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRPRPD</IdLocation>
<IndexLocation>^%UMLS.lex.LRPRPI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-804</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-3824</BlockCount>
</SQLMap>
<SQLMap name="STRIdx">
<BlockCount>-1076</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRPRPS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
