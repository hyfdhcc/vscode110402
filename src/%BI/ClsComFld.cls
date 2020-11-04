Class %BI.ClsComFld Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property ActualField As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DocId As %String(TRUNCATE = 1);

Property FieldName As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Remark As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Roles As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Tooltip As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ClsComFldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActualField</Value>
</Value>
<Value name="3">
<Value>FieldName</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>Tooltip</Value>
</Value>
<Value name="7">
<Value>DocId</Value>
</Value>
<Value name="8">
<Value>Roles</Value>
</Value>
</Data>
<DataLocation>^BI.ClsComFldD</DataLocation>
<DefaultData>ClsComFldDefaultData</DefaultData>
<IdLocation>^BI.ClsComFldD</IdLocation>
<IndexLocation>^BI.ClsComFldI</IndexLocation>
<StreamLocation>^BI.ClsComFldS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
