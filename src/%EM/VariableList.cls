/// A list of %EM.Variable objects
Class %EM.VariableList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of %EM.Variable objects
Property List As list Of %EM.Variable(XMLPROJECTION = "element");

}
