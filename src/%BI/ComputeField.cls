Class %BI.ComputeField Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FieldName As %String(TRUNCATE = 1);

Property IsStatic As %Boolean;

Query byClass(classname As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,StartClass,LinkField,PropName,FieldName,Operation,ComplexCode,IsStatic,NullReplace,AdditionalCondition 
FROM ComputeField
 WHERE (ClassName = :classname)
}

Query ComputeList(classname As %String) As %SQLQuery(CONTAINID = 0)
{
SELECT FieldName FROM ComputeField
 WHERE (ClassName = :classname)
}

Property AdditionalCondition As %String(TRUNCATE = 1);

Property ClassName As %String(TRUNCATE = 1);

Property Operation As %String(MAXLEN = 5000, TRUNCATE = 1);

Property PropName As %String(MAXLEN = 5000, TRUNCATE = 1);

Property ComplexCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property StartClass As %String(TRUNCATE = 1);

Property LinkField As %String(TRUNCATE = 1);

Property NullReplace As %String(TRUNCATE = 1);

Index ClassCompute On ClassName As Exact;

Storage Default
{
<Data name="ComputeFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdditionalCondition</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
<Value name="4">
<Value>ComplexCode</Value>
</Value>
<Value name="5">
<Value>FieldName</Value>
</Value>
<Value name="6">
<Value>IsStatic</Value>
</Value>
<Value name="7">
<Value>LinkField</Value>
</Value>
<Value name="8">
<Value>NullReplace</Value>
</Value>
<Value name="9">
<Value>Operation</Value>
</Value>
<Value name="10">
<Value>PropName</Value>
</Value>
<Value name="11">
<Value>StartClass</Value>
</Value>
</Data>
<DataLocation>^BI.ComputeFieldD</DataLocation>
<DefaultData>ComputeFieldDefaultData</DefaultData>
<IdLocation>^BI.ComputeFieldD</IdLocation>
<IndexLocation>^BI.ComputeFieldI</IndexLocation>
<StreamLocation>^BI.ComputeFieldS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
