Class %BI.TEST Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Name As %String;

Property Age As %String;

Storage Default
{
<Data name="TESTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Age</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^BI.TESTD</DataLocation>
<DefaultData>TESTDefaultData</DefaultData>
<IdLocation>^BI.TESTD</IdLocation>
<IndexLocation>^BI.TESTI</IndexLocation>
<StreamLocation>^BI.TESTS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
