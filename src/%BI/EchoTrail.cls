Class %BI.EchoTrail Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index EchoRID On EchoRID As Exact;

Property EchoRID As %String(TRUNCATE = 1);

Property EchoDate As %String(TRUNCATE = 1);

Property EchoAction As %String(TRUNCATE = 1);

Property EchoStaff As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EchoTrailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EchoAction</Value>
</Value>
<Value name="3">
<Value>EchoDate</Value>
</Value>
<Value name="4">
<Value>EchoRID</Value>
</Value>
<Value name="5">
<Value>EchoStaff</Value>
</Value>
</Data>
<DataLocation>^BI.EchoTrailD</DataLocation>
<DefaultData>EchoTrailDefaultData</DefaultData>
<IdLocation>^BI.EchoTrailD</IdLocation>
<IndexLocation>^BI.EchoTrailI</IndexLocation>
<StreamLocation>^BI.EchoTrailS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
