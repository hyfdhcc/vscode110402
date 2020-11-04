/// File Description
Class %UMLS.lex.LRFIL Extends %Persistent [ DdlAllowed, Not ProcedureBlock, System = 4 ]
{

/// Size in Bytes
Property BTS As %String(MAXLEN = 50);

/// Number of Columns
Property CLS As %String(MAXLEN = 50);

/// Description
Property DES As %String(MAXLEN = 50);

/// File Name(s)
Property FIL As %String(MAXLEN = 128);

/// Format
Property FMT As %String(MAXLEN = 50);

/// Number of Rows
Property RWS As %String(MAXLEN = 50);

Storage Default
{
<Data name="LRFILDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTS</Value>
</Value>
<Value name="3">
<Value>CLS</Value>
</Value>
<Value name="4">
<Value>DES</Value>
</Value>
<Value name="5">
<Value>FIL</Value>
</Value>
<Value name="6">
<Value>FMT</Value>
</Value>
<Value name="7">
<Value>RWS</Value>
</Value>
</Data>
<DataLocation>^%UMLS.lex.LRFILD</DataLocation>
<DefaultData>LRFILDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.lex.LRFILD</IdLocation>
<IndexLocation>^%UMLS.lex.LRFILI</IndexLocation>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^%UMLS.lex.LRFILS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
