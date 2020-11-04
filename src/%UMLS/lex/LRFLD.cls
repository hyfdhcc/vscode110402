/// Field Description
Class %UMLS.lex.LRFLD Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Three Letter Field Name
Property COL As %String(MAXLEN = 50);

/// Description
Property DES As %String(MAXLEN = 50);

/// File Name(s)
Property FIL As %String(MAXLEN = 128);

/// Cross Reference to Document
Property REF As %String(MAXLEN = 50);

Storage Default
{
<Data name="LRFLDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>COL</Value>
</Value>
<Value name="3">
<Value>DES</Value>
</Value>
<Value name="4">
<Value>FIL</Value>
</Value>
<Value name="5">
<Value>REF</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRFLDD</DataLocation>
<DefaultData>LRFLDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRFLDD</IdLocation>
<IndexLocation>^%UMLS.lex.LRFLDI</IndexLocation>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRFLDS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
