/// Base class for all Web Services Monitoring resources.
/// Used to conveniently group the resources and to define the WS-Management
/// resource classes as an XML-enabled %RegisteredObject (necessary to 
/// return a generic class via SOAP). All resources available via WS-Management should
/// use this. 
Class SYS.WSMon.wsResource Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

/// Generic namespace for resources
Parameter NAMESPACE = "http://schema.intersystems.com/cache/wsman/1/resource";

}
