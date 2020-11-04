Class %BI.MailV2 Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property MailFrom As %String(MAXLEN = 100);

Property MailTo As %String(MAXLEN = 100);

Property MailSubject As %String(MAXLEN = 1000);

Property MailDate As %String;

Property MailMsg As %String(MAXLEN = 10000);

Property MailUID As %String;

Property MailSize As %String;

Property MailSysUser As %String;

Property MailRead As %String;

Property MailAtt As %String;

Property MailBcc As %String(MAXLEN = 1000);

Property MailCc As %String(MAXLEN = 1000);

Property MailToDel As %String;

Index UID On (MailSysUser As Exact, MailUID As Exact);

Index Usr On MailSysUser As Exact;

Query MailByUID() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,MailFrom,MailTo,MailSubject,MailDate,MailSize FROM %BI.MailV2 ORDER BY MailUID
}

Storage Default
{
<Data name="Att">
<Subscript>"Att"</Subscript>
<Value name="1">
<Value>MailAtt</Value>
</Value>
</Data>
<Data name="Mail">
<Value name="1">
<Value>MailFrom</Value>
</Value>
<Value name="2">
<Value>MailTo</Value>
</Value>
<Value name="3">
<Value>MailDate</Value>
</Value>
<Value name="4">
<Value>MailUID</Value>
</Value>
<Value name="5">
<Value>MailSize</Value>
</Value>
<Value name="6">
<Value>MailSysUser</Value>
</Value>
<Value name="7">
<Value>MailSubject</Value>
</Value>
<Value name="8">
<Value>MailRead</Value>
</Value>
<Value name="9">
<Value>MailBcc</Value>
</Value>
<Value name="10">
<Value>MailCc</Value>
</Value>
<Value name="11">
<Value>MailToDel</Value>
</Value>
</Data>
<Data name="MailV2DefaultData1">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Msg">
<Attribute>MailMsg</Attribute>
<Structure>node</Structure>
<Subscript>"MSG"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MailFrom</Value>
</Value>
<Value name="3">
<Value>MailTo</Value>
</Value>
<Value name="4">
<Value>MailSubject</Value>
</Value>
<Value name="5">
<Value>MailDate</Value>
</Value>
<Value name="6">
<Value>MailMsg</Value>
</Value>
<Value name="7">
<Value>MailUID</Value>
</Value>
<Value name="8">
<Value>MailSize</Value>
</Value>
</Data>
<DataLocation>^BI.MailV2D</DataLocation>
<DefaultData>MailV2DefaultData1</DefaultData>
<IdLocation>^BI.MailV2D</IdLocation>
<IndexLocation>^BI.MailV2I</IndexLocation>
<StreamLocation>^BI.MailV2S</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
