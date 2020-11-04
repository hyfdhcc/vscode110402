Class %DeepSee.XMLA.PropertiesRestrictions Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Property PropertyName As String;

Property PropertyNameList As list Of String(XMLPROJECTION = "none");

Method Normalize() As %Status
{
	quit ##class(Server).ParseRestrictions("PropertyName", ..PropertyName, ..PropertyNameList)
}

}
