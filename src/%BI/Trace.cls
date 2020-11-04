Class %BI.Trace Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property accDate As %Date;

Property accTime As %Time;

Property accUser As %Integer;

Property creDate As %Date;

Property creTime As %Time;

Property creUser As %Integer;

Property delDate As %Date;

Property delTime As %Time;

Property delUser As %Integer;

Property modDate As %Date;

Property modTime As %Time;

Property modUser As %Integer;

Property objID As %String;

Property objType As %Integer;

Index MainIndex On (objType, objID) [ IdKey ];

Storage Default
{
<Data name="TraceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>accDate</Value>
</Value>
<Value name="3">
<Value>accTime</Value>
</Value>
<Value name="4">
<Value>accUser</Value>
</Value>
<Value name="5">
<Value>creDate</Value>
</Value>
<Value name="6">
<Value>creTime</Value>
</Value>
<Value name="7">
<Value>creUser</Value>
</Value>
<Value name="8">
<Value>delDate</Value>
</Value>
<Value name="9">
<Value>delTime</Value>
</Value>
<Value name="10">
<Value>delUser</Value>
</Value>
<Value name="11">
<Value>modDate</Value>
</Value>
<Value name="12">
<Value>modTime</Value>
</Value>
<Value name="13">
<Value>modUser</Value>
</Value>
</Data>
<DataLocation>^BI.TraceD</DataLocation>
<DefaultData>TraceDefaultData</DefaultData>
<IdLocation>^BI.TraceD</IdLocation>
<IndexLocation>^BI.TraceI</IndexLocation>
<StreamLocation>^BI.TraceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
