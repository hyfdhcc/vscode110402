Class %BI.SubjectTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

Property JoinField As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Subject As %String(MAXLEN = 1000, TRUNCATE = 1);

Property TableClass As %String(MAXLEN = 1000, TRUNCATE = 1);

Storage Default
{
<Data name="SubjectTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>JoinField</Value>
</Value>
<Value name="4">
<Value>Subject</Value>
</Value>
<Value name="5">
<Value>TableClass</Value>
</Value>
</Data>
<DataLocation>^BI.SubjectTableD</DataLocation>
<DefaultData>SubjectTableDefaultData</DefaultData>
<IdLocation>^BI.SubjectTableD</IdLocation>
<IndexLocation>^BI.SubjectTableI</IndexLocation>
<StreamLocation>^BI.SubjectTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
