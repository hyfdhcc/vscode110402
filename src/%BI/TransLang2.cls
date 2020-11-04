Class %BI.TransLang2 Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property langName As %String;

Property langCode As %String;

Query GetLang() As %SQLQuery
{
SELECT langName,langCode FROM TransLang2
}

Storage Default
{
<Data name="TransLang2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>langName</Value>
</Value>
<Value name="3">
<Value>langCode</Value>
</Value>
</Data>
<DataLocation>^%BI.TransLang2D</DataLocation>
<DefaultData>TransLang2DefaultData</DefaultData>
<IdLocation>^%BI.TransLang2D</IdLocation>
<IndexLocation>^%BI.TransLang2I</IndexLocation>
<StreamLocation>^%BI.TransLang2S</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
