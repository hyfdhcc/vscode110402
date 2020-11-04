Class %BI.IJNSMSLog Extends %Persistent [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DateCreated As %String;

Property TimeCreated As %String;

Property DateSent As %String;

Property TimeSent As %String;

Property Message As %String;

Property Receiver As %String;

Index DateTimeLookup On (DateSent, TimeSent);

Index ReceiverLookup On Receiver;

Storage Default
{
<Data name="IJNSMSLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateCreated</Value>
</Value>
<Value name="3">
<Value>DateSent</Value>
</Value>
<Value name="4">
<Value>Message</Value>
</Value>
<Value name="5">
<Value>Receiver</Value>
</Value>
<Value name="6">
<Value>TimeCreated</Value>
</Value>
<Value name="7">
<Value>TimeSent</Value>
</Value>
</Data>
<DataLocation>^BI.IJNSMSLogD</DataLocation>
<DefaultData>IJNSMSLogDefaultData</DefaultData>
<IdLocation>^BI.IJNSMSLogD</IdLocation>
<IndexLocation>^BI.IJNSMSLogI</IndexLocation>
<StreamLocation>^BI.IJNSMSLogS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
