/// Pronouns
Class %UMLS.lex.LRPRN Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Base Form
Property BAS As %String(MAXLEN = 1024);

/// Case
Property CAS As %String(MAXLEN = 50);

/// Unique Identifier Number for Lexical Entries
Property EUI As %String(MAXLEN = 50);

/// Features
Property FEA As %String(MAXLEN = 50);

/// Gender
Property GND As %String(MAXLEN = 50);

Property NUM As %String(MAXLEN = 50);

/// Possession
Property POS As %String(MAXLEN = 50);

/// Quantification
Property QNT As %String(MAXLEN = 50);

Index EUIIdx On EUI;

Storage Default
{
<Data name="LRPRNDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BAS</Value>
</Value>
<Value name="3">
<Value>CAS</Value>
</Value>
<Value name="4">
<Value>EUI</Value>
</Value>
<Value name="5">
<Value>FEA</Value>
</Value>
<Value name="6">
<Value>GND</Value>
</Value>
<Value name="7">
<Value>NUM</Value>
</Value>
<Value name="8">
<Value>POS</Value>
</Value>
<Value name="9">
<Value>QNT</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRPRND</DataLocation>
<DefaultData>LRPRNDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRPRND</IdLocation>
<IndexLocation>^%UMLS.lex.LRPRNI</IndexLocation>
<SQLMap name="EUIIdx">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRPRNS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
