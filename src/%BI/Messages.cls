Class %BI.Messages Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property MsgClass As %String(TRUNCATE = 1);

Property MsgCounter As %Numeric;

Property MsgModule As %String(TRUNCATE = 1);

Property MsgType As %String(TRUNCATE = 1);

Property MsgSubject As %String(MAXLEN = 2000, TRUNCATE = 1);

Property MsgDetails As %String(MAXLEN = 2000, TRUNCATE = 1);

Property MsgSiteID As %String(TRUNCATE = 1);

Property MsgRefPoint As %String(TRUNCATE = 1);

Property MsgRemarks As %String(TRUNCATE = 1);

Property RecordID As %String(TRUNCATE = 1);

Property MsgDate As %Date;

Property MsgTime As %Time;

Property MsgUser As %BI.Users;

Index IDKey On (MsgClass, MsgType, MsgCounter) [ IdKey, Unique ];

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="MessagesDefaultData">
<Value name="1">
<Value>MsgSubject</Value>
</Value>
<Value name="2">
<Value>MsgDate</Value>
</Value>
<Value name="3">
<Value>MsgTime</Value>
</Value>
<Value name="4">
<Value>MsgUser</Value>
</Value>
<Value name="5">
<Value>MsgModule</Value>
</Value>
<Value name="6">
<Value>MsgDetails</Value>
</Value>
<Value name="7">
<Value>MsgSiteID</Value>
</Value>
<Value name="8">
<Value>MsgRefPoint</Value>
</Value>
<Value name="9">
<Value>MsgRemarks</Value>
</Value>
<Value name="10">
<Value>RecordID</Value>
</Value>
</Data>
<DataLocation>^BI.MessagesD</DataLocation>
<DefaultData>MessagesDefaultData</DefaultData>
<IdLocation>^BI.MessagesD</IdLocation>
<IndexLocation>^BI.MessagesI</IndexLocation>
<StreamLocation>^BI.MessagesS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
