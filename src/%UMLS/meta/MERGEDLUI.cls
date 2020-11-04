/// Merged terms
Class %UMLS.meta.MERGEDLUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = MERGEDLUI, System = 4 ]
{

/// Unique identifier for term // MAXLEN = 0
Property LUI As %String(MAXLEN = 1);

/// Lexical unique identifier in the previous Metathesaurus // MAXLEN = 0
Property PLUI As %String(MAXLEN = 1);

Storage Default
{
<Data name="MERGEDLUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LUI</Value>
</Value>
<Value name="3">
<Value>PLUI</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.MERGEDLUID</DataLocation>
<DefaultData>MERGEDLUIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.MERGEDLUID</IdLocation>
<IndexLocation>^%UMLS.meta.MERGEDLUII</IndexLocation>
<StreamLocation>^%UMLS.meta.MERGEDLUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
