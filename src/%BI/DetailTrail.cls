Class %BI.DetailTrail Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property dat As %Date;

Property class As %String(TRUNCATE = 1);

Property DashId As %String(TRUNCATE = 1);

Property sv As %SmallInt;

Property tim As %Time;

Property usrId As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DetailTrailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dat</Value>
</Value>
<Value name="3">
<Value>descr</Value>
</Value>
<Value name="4">
<Value>fldr</Value>
</Value>
<Value name="5">
<Value>rptId</Value>
</Value>
<Value name="6">
<Value>sv</Value>
</Value>
<Value name="7">
<Value>tim</Value>
</Value>
<Value name="8">
<Value>usrId</Value>
</Value>
<Value name="9">
<Value>DashId</Value>
</Value>
<Value name="10">
<Value>class</Value>
</Value>
</Data>
<DataLocation>^BI.DetailTrailD</DataLocation>
<DefaultData>DetailTrailDefaultData</DefaultData>
<IdLocation>^BI.DetailTrailD</IdLocation>
<IndexLocation>^BI.DetailTrailI</IndexLocation>
<StreamLocation>^BI.DetailTrailS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
