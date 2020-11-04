Class %ZEN.Report.Display.COSChart.range Extends %RegisteredObject [ System = 4 ]
{

Property minValue As %Double;

Property maxValue As %Double;

// used in x-y type charts

Property minValue2 As %Double;

// used in x-y type charts

Property maxValue2 As %Double;

Storage Default
{
<Data name="rangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>minValue</Value>
</Value>
<Value name="3">
<Value>maxValue</Value>
</Value>
<Value name="4">
<Value>minValue2</Value>
</Value>
<Value name="5">
<Value>maxValue2</Value>
</Value>
</Data>
<DataLocation>^%ZEN.Report.Display2E79.rangeD</DataLocation>
<DefaultData>rangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%ZEN.Report.Display2E79.rangeD</IdLocation>
<IndexLocation>^%ZEN.Report.Display2E79.rangeI</IndexLocation>
<StreamLocation>^%ZEN.Report.Display2E79.rangeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
