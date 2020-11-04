Class %ZEN.Report.Display.COSChart.token Extends %RegisteredObject
{

Property type As %String;

Property value As %String;

Method %OnNew(type, value) As %Status
{
	Set ..type=type
	Set ..value=value
	quit $$$OK
}

}
