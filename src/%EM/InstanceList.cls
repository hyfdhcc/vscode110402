/// A list of %EM.Instance objects
Class %EM.InstanceList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of %EM.Instance objects
Property List As list Of %EM.Instance(XMLPROJECTION = "element");

}
