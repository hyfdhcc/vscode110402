Class %BI.OCRForm Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property class As %String;

Property dir As %String;

Relationship rule As %BI.OCRRule [ Cardinality = children, Inverse = form ];

Index MainIndex On class [ IdKey ];

Storage Default
{
<Data name="OCRFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dir</Value>
</Value>
</Data>
<DataLocation>^BI.OCRFormD</DataLocation>
<DefaultData>OCRFormDefaultData</DefaultData>
<IdLocation>^BI.OCRFormD</IdLocation>
<IndexLocation>^BI.OCRFormI</IndexLocation>
<StreamLocation>^BI.OCRFormS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
