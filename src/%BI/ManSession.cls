Class %BI.ManSession Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Method Get(Arg1 As %String) As %String
{
	q ""
}

Storage Default
{
<Data name="ManSessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BI.ManSessionD</DataLocation>
<DefaultData>ManSessionDefaultData</DefaultData>
<IdLocation>^BI.ManSessionD</IdLocation>
<IndexLocation>^BI.ManSessionI</IndexLocation>
<StreamLocation>^BI.ManSessionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
