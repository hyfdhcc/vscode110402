Class %BI.TCWFTempStation Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property StationName As %String(MAXLEN = 5000);

Property StationCode As %String(MAXLEN = 10);

Property InitCode As %String(MAXLEN = 25000);

Property LoopCode As %String(MAXLEN = 25000);

Property LoopStoredRecord As %String(MAXLEN = 1);

Property CloseCode As %String(MAXLEN = 25000);

Property RuleID As %String(MAXLEN = 100);

Relationship Header As %BI.TCWFTempHeader [ Cardinality = parent, Inverse = Stations ];

Index MainIdx On StationCode [ IdKey, Unique ];

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CloseCode">
<Attribute>CloseCode</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="InitCode">
<Attribute>InitCode</Attribute>
<Structure>node</Structure>
<Subscript>"I"</Subscript>
</Data>
<Data name="LoopCode">
<Attribute>LoopCode</Attribute>
<Structure>node</Structure>
<Subscript>"L"</Subscript>
</Data>
<Data name="TCWFStationDefaultData">
<Value name="1">
<Value>StationName</Value>
</Value>
<Value name="2">
<Value>RuleID</Value>
</Value>
<Value name="3">
<Value>LoopStoredRecord</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("S")</DataLocation>
<DefaultData>TCWFStationDefaultData</DefaultData>
<IdLocation>{%%PARENT}("S")</IdLocation>
<IndexLocation>^BI.TCWFTempStationI</IndexLocation>
<StreamLocation>^BI.TCWFTempStationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
