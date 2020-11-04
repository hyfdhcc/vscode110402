Class %BI.EmailTrail Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Class As %String(TRUNCATE = 1);

Property Message As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DateTime As %String(TRUNCATE = 1);

Property ToAddr As list Of %String(TRUNCATE = 1);

Property Cc As list Of %String(TRUNCATE = 1);

Property UserID As %String(MAXLEN = 100, TRUNCATE = 1);

Property Subject As %String(MAXLEN = 1000, TRUNCATE = 1);

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
<Value name="1"/>
</Data>
<Data name="EmailTrailDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>Cc</Value>
</Value>
<Value name="2">
<Value>Subject</Value>
</Value>
<Value name="3">
<Value>DateTime</Value>
</Value>
<Value name="4">
<Value>Class</Value>
</Value>
<Value name="5">
<Value>ToAddr</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
</Data>
<Data name="Message">
<Attribute>Message</Attribute>
<Structure>node</Structure>
<Subscript>"m"</Subscript>
</Data>
<DataLocation>^BI.EmailTrailD</DataLocation>
<DefaultData>EmailTrailDefaultData</DefaultData>
<IdLocation>^BI.EmailTrailD</IdLocation>
<IndexLocation>^BI.EmailTrailI</IndexLocation>
<StreamLocation>^BI.EmailTrailS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
