Class SYS.Advertising.Predicate Extends %Persistent
{

Method Test() As %Boolean [ Abstract ]
{
}

Storage Default
{
<Data name="PredicateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^SYS("Advertising", "PredicateD")</DataLocation>
<DefaultData>PredicateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Advertising", "PredicateD")</IdLocation>
<IndexLocation>^SYS("Advertising", "PredicateI")</IndexLocation>
<StreamLocation>^SYS("Advertising", "PredicateS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
