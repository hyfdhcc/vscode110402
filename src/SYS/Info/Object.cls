/// SYS.Info.Objects are deliberately generic: Anything that is persistent and %XML.Exportable
/// can be used. 
Class SYS.Info.Object Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Storage Default
{
<Data name="ObjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^SYS("Info","ObjectD")</DataLocation>
<DefaultData>ObjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Info","ObjectD")</IdLocation>
<IndexLocation>^SYS("Info","ObjectI")</IndexLocation>
<StreamLocation>^SYS("Info","ObjectS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
