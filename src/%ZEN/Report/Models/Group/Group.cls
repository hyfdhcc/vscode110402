/// 
Class %ZEN.Report.Models.Group.Group Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

Parameter XMLNAME = "group";

/// field which defines group
Property field As %String(XMLPROJECTION = "attribute");

/// whether field appears in table as well before table
Property inTable As %Boolean(XMLPROJECTION = "attribute");

}
