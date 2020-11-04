Class %SYS.PTools.SQLBenchMarkResults Extends %Persistent [ System = 4 ]
{

Property Run As %Integer;

Property StartTS As %TimeStamp;

/// Number of Global References for all rows
Property GlobalRefs As %Integer;

/// Number of Global References to fetch the first row
Property FRGlobalRefs As %Integer;

/// Number of lines executed for all rows
Property Lines As %Integer;

/// Number of lines executed to fetch the first row
Property FRLines As %Integer;

/// Number of rows returned by the query
Property Rowcount As %Integer;

/// Time to fetch all rows
Property RunTime As %Time;

/// Time to fetch the first row
Property FRRunTime As %Time;

Property QueryId As %SYS.PTools.SQLBenchMarkQueries;

Storage Default
{
<CounterLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Results","C")</CounterLocation>
<Data name="SQLBenchMarkResultsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Run</Value>
</Value>
<Value name="3">
<Value>StartTS</Value>
</Value>
<Value name="4">
<Value>GlobalRefs</Value>
</Value>
<Value name="5">
<Value>Lines</Value>
</Value>
<Value name="6">
<Value>Rowcount</Value>
</Value>
<Value name="7">
<Value>RunTime</Value>
</Value>
<Value name="8">
<Value>QueryId</Value>
</Value>
<Value name="9">
<Value>FRGlobalRefs</Value>
</Value>
<Value name="10">
<Value>FRLines</Value>
</Value>
<Value name="11">
<Value>FRRunTime</Value>
</Value>
</Data>
<DataLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Results","D")</DataLocation>
<DefaultData>SQLBenchMarkResultsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Results","D")</IdLocation>
<IndexLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Results","I")</IndexLocation>
<StreamLocation>^%sqlcq($NAMESPACE,"PTools","Bench","Results","S")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
