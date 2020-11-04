Class %BI.MailOutBox Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property MailTo As %String(MAXLEN = 100);

Property MailSubject As %String(MAXLEN = 1000);

Property MailDate As %String;

Property MailMsg As %String(MAXLEN = 10000);

Property MailUID As %String;

Property MailSysUser As %String;

Property MailAtt As %String;

Property MailBcc As %String(MAXLEN = 1000);

Property MailCc As %String(MAXLEN = 1000);

Index UID On (MailSysUser As Exact, MailUID As Exact);

Index Usr On MailSysUser As Exact;

Query MailByUID() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,MailTo,MailSubject,MailDate FROM %BI.MailOutBox ORDER BY MailUID
}

Storage Default
{
<Data name="Attach">
<Subscript>"Att"</Subscript>
<Value name="1">
<Value>MailAtt</Value>
</Value>
</Data>
<Data name="MailDet">
<Value name="1">
<Value>MailTo</Value>
</Value>
<Value name="2">
<Value>MailBcc</Value>
</Value>
<Value name="3">
<Value>MailCc</Value>
</Value>
<Value name="4">
<Value>MailDate</Value>
</Value>
<Value name="5">
<Value>MailSubject</Value>
</Value>
<Value name="6">
<Value>MailUID</Value>
</Value>
</Data>
<Data name="MailOutBoxDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MailSysUser</Value>
</Value>
<Value name="3">
<Value>MailRead</Value>
</Value>
<Value name="4">
<Value>MailFrom</Value>
</Value>
</Data>
<Data name="Msg">
<Attribute>MailMsg</Attribute>
<Structure>node</Structure>
<Subscript>"Msg"</Subscript>
<Value name="1">
<Value>MailMsg</Value>
</Value>
</Data>
<DataLocation>^BI.MailOutBoxD</DataLocation>
<DefaultData>MailOutBoxDefaultData</DefaultData>
<IdLocation>^BI.MailOutBoxD</IdLocation>
<IndexLocation>^BI.MailOutBoxI</IndexLocation>
<StreamLocation>^BI.MailOutBoxS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
