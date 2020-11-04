/// A list of %EM.User objects
Class %EM.UserList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of %EM.User objects
Property List As list Of %EM.User(XMLPROJECTION = "element");

}
