/// A list of %EM.Version objects
Class %EM.VersionList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of %EM.Version objects
Property List As list Of %EM.Version(XMLPROJECTION = "element");

}
