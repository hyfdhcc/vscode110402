/// used by dsFormulaParser
Class %ZEN.Report.Display.COSChart.function Extends %RegisteredObject
{

Property instance As %String;

Property methodname As %String;

Property key As %String;

Method %OnNew(key, instance, methodname) As %Status
{
	Set ..instance = instance
	Set ..methodname = methodname
	Set ..key = key
	quit $$$OK
}

}
