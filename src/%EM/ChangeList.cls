/// %EM.ChangeList is a list of %EM.Change objects
Class %EM.ChangeList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of %EM.Change objects
Property List As list Of %EM.Change(XMLPROJECTION = "element");

}
