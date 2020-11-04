Class %BI.SMS Extends (%Persistent, %XML.Adaptor, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/* The recepient number, can be saparated with comma "," for more than one contact */
Property ContactNumber As %String(MAXLEN = 200, TRUNCATE = 1);

/* SendRecvFlag = S,R */
Property SendRecvFlag As %String(TRUNCATE = 1);

/* The SMS message */
Property SMSMessage As %String(MAXLEN = 32000, TRUNCATE = 1);

/* ProcStatus = C,E,P */
Property ProcStatus As %String(TRUNCATE = 1);

/* Date and time when the SMS are actually sent out */
Property ProcDateTime As %String(TRUNCATE = 1);

/* Date and time when the user send this SMS */
Property SMSDateTime As %String(TRUNCATE = 1);

/* Number of trial used to send the SMS */
Property TrialCount As %Integer;

Property StatusFile As %String(MAXLEN = 200);

Index STAT On (SendRecvFlag As Exact, ProcStatus As Exact);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,SendRecvFlag,ProcStatus,SMSDateTime,ProcDateTime FROM SMS
 ORDER BY %ID DESC
}

Storage Default
{
<Data name="CLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="Msg">
<Attribute>SMSMessage</Attribute>
<Structure>node</Structure>
<Subscript>"M"</Subscript>
</Data>
<Data name="SMSDefaultData">
<Value name="1">
<Value>ContactNumber</Value>
</Value>
<Value name="2">
<Value>SendRecvFlag</Value>
</Value>
<Value name="3">
<Value>ProcStatus</Value>
</Value>
<Value name="4">
<Value>ProcDateTime</Value>
</Value>
<Value name="5">
<Value>SMSDateTime</Value>
</Value>
<Value name="6">
<Value>TrialCount</Value>
</Value>
<Value name="7">
<Value>StatusFile</Value>
</Value>
</Data>
<DataLocation>^BIlog.SMSD</DataLocation>
<DefaultData>SMSDefaultData</DefaultData>
<IdLocation>^BIlog.SMSD</IdLocation>
<IndexLocation>^BIlog.SMSI</IndexLocation>
<StreamLocation>^BIlog.SMSS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
