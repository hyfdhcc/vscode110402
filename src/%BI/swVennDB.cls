Class %BI.swVennDB Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
		Author : Steven :P
		Purpose: MainTable store venn diagrams
		Note   : 
		Created: 05.09.2005
		Updated: 05.09.2005
*/
Property Name As %Integer;

Property Subject As %String(MAXLEN = 100, TRUNCATE = 1);

Property FolderID As %Numeric;

Storage Default
{
<Data name="swVennDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FolderID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Subject</Value>
</Value>
</Data>
<DataLocation>^BI.swVennDBD</DataLocation>
<DefaultData>swVennDBDefaultData</DefaultData>
<IdLocation>^BI.swVennDBD</IdLocation>
<IndexLocation>^BI.swVennDBI</IndexLocation>
<StreamLocation>^BI.swVennDBS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
