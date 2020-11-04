Class %BI.OCRRule Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property endPos As %String;

Property line As %String;

Property prop As %String;

Property startPos As %String;

Relationship form As %BI.OCRForm [ Cardinality = parent, Inverse = rule ];

Index MainIndex On prop [ IdKey ];

Storage Default
{
<Data name="OCRRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>endPos</Value>
</Value>
<Value name="3">
<Value>line</Value>
</Value>
<Value name="4">
<Value>startPos</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("rule")</DataLocation>
<DefaultData>OCRRuleDefaultData</DefaultData>
<IdLocation>^BI.OCRFormC("rule")</IdLocation>
<IndexLocation>^BI.OCRRuleI</IndexLocation>
<StreamLocation>^BI.OCRRuleS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
