/// Deleted strings
Class %UMLS.meta.DELETEDSUI Extends %Persistent [ DdlAllowed, Not ProcedureBlock, SqlTableName = DELETEDSUI, System = 4 ]
{

/// Language of Term(s) // MAXLEN = 0
Property LAT As %String(MAXLEN = 1);

/// Preferred name in the previous Metathesaurus // MAXLEN = 0
Property PSTR As %String(MAXLEN = 1);

/// String unique identifier in the previous Metathesaurus // MAXLEN = 0
Property PSUI As %String(MAXLEN = 1);

Storage Default
{
<Data name="DELETEDSUIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LAT</Value>
</Value>
<Value name="3">
<Value>PSTR</Value>
</Value>
<Value name="4">
<Value>PSUI</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.DELETEDSUID</DataLocation>
<DefaultData>DELETEDSUIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%UMLS.meta.DELETEDSUID</IdLocation>
<IndexLocation>^%UMLS.meta.DELETEDSUII</IndexLocation>
<StreamLocation>^%UMLS.meta.DELETEDSUIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
