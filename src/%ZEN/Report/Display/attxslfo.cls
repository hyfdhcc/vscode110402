/// Specifies an attribute-value pair for XSL-FO within a class.
Class %ZEN.Report.Display.attxslfo Extends att [ System = 4 ]
{

Method %DrawToHTML(ByRef context As %String, ByRef XSL As %GlobalCharacterStream, delay As %GlobalCharacterStream) As %Status
{
	quit $$$OK
}

Storage Default
{
<Data name="attxslfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^%ZEN.Report.Display.attxslfoD</DataLocation>
<DefaultData>attxslfoDefaultData</DefaultData>
<IdLocation>^%ZEN.Report.Display.attxslfoD</IdLocation>
<IndexLocation>^%ZEN.Report.Display.attxslfoI</IndexLocation>
<StreamLocation>^%ZEN.Report.Display.attxslfoS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
