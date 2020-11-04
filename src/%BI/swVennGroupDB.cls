Class %BI.swVennGroupDB Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
		Author : Steven :P
		Purpose: Venn Group
		Note   : Represent at least one circle
		Created: 05.09.2005
		Updated: 20.09.2005
*/
Property ParentVennID As %Integer;

Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

//link other map when user click

Storage Default
{
<Data name="swVennGroupDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ParentVennID</Value>
</Value>
</Data>
<DataLocation>^BI.swVennGroupDBD</DataLocation>
<DefaultData>swVennGroupDBDefaultData</DefaultData>
<IdLocation>^BI.swVennGroupDBD</IdLocation>
<IndexLocation>^BI.swVennGroupDBI</IndexLocation>
<StreamLocation>^BI.swVennGroupDBS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
