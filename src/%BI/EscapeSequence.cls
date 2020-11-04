Class %BI.EscapeSequence Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(TRUNCATE = 1);

Property EscSeq As %String(TRUNCATE = 1);

Query All() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Description FROM EscapeSequence ORDER BY Description
}

Storage Default
{
<Data name="EscapeSequenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>EscSeq</Value>
</Value>
</Data>
<DataLocation>^BI.EscapeSequenceD</DataLocation>
<DefaultData>EscapeSequenceDefaultData</DefaultData>
<IdLocation>^BI.EscapeSequenceD</IdLocation>
<IndexLocation>^BI.EscapeSequenceI</IndexLocation>
<StreamLocation>^BI.EscapeSequenceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
