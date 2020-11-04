/// used by dsFormulaParser
Class %ZEN.Report.Display.COSChart.parseTreeNode Extends %RegisteredObject
{

Property children As array Of %ZEN.Report.Display.COSChart.parseTreeNode;

Property type As %String;

Property value As %String;

Property inParens As %Boolean;

Method %OnNew(type, value) As %Status
{
	if '$D(type) quit $$$OK
	Set ..type=type
	if '$D(value) quit $$$OK
	Set ..value=value
	quit $$$OK
}

Method dumpTree()
{
	s ^foobar($i(^foobar))="type="_..type_" value="_..value_" inParens="_..inParens
	s ^foobar($i(^foobar))="dumping children"
	for i=1:1:..children.Count() {
		do ..children.GetAt(i).dumpTree()
	}
}

}
