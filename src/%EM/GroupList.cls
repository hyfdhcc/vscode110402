/// A list of %EM.Group objects
Class %EM.GroupList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of %EM.Group objects
Property List As list Of %EM.Group(XMLPROJECTION = "element");

}
