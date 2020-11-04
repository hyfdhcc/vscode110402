/// Maps selectors to information objects
Class SYS.Info.CategoryMap Extends %Persistent
{

Property Selector As %String(MAXLEN = 256) [ Required ];

Property Object As Object [ Required ];

/// Selector / Object pairs must be unique
Index Uniqueness On (Selector, Object) [ Unique ];

/// Retrieves the objects for a given selector
Query ObjectsForSelector(selector As %String) As %SQLQuery
{
SELECT Object FROM CategoryMap where Selector = :selector
}

Storage Default
{
<Data name="CategoryMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Selector</Value>
</Value>
<Value name="3">
<Value>Object</Value>
</Value>
</Data>
<DataLocation>^SYS("Info","CategoryMapD")</DataLocation>
<DefaultData>CategoryMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Info","CategoryMapD")</IdLocation>
<IndexLocation>^SYS("Info","CategoryMapI")</IndexLocation>
<StreamLocation>^SYS("Info","CategoryMapS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
