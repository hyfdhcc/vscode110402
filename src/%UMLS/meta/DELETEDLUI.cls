/// Deleted terms
Class %UMLS.meta.DELETEDLUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = DELETEDLUI, System = 4 ]
{

/// Lexical unique identifier in the previous Metathesaurus // MAXLEN = 0
Property PLUI As %String(MAXLEN = 1);

/// Preferred name in the previous Metathesaurus // MAXLEN = 0
Property PSTR As %String(MAXLEN = 1);

Storage Default
{
<Data name="DELETEDLUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PLUI</Value>
</Value>
<Value name="3">
<Value>PSTR</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.DELETEDLUID</DataLocation>
<DefaultData>DELETEDLUIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.DELETEDLUID</IdLocation>
<IndexLocation>^%UMLS.meta.DELETEDLUII</IndexLocation>
<StreamLocation>^%UMLS.meta.DELETEDLUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
