Class %DeepSee.XMLA.SchemasRestrictions Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Property SchemaName As String;

Property SchemaNameList As list Of String(XMLPROJECTION = "none");

Method Normalize() As %Status
{
	quit ##class(Server).ParseRestrictions("SchemaName", ..SchemaName, ..SchemaNameList)
}

}
