/// The %EM.Group class represents an Enterprise Manager group for the remote API
Class %EM.Group Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The name of the group
Property Name As %String;

/// Description of the group
Property Description As %String(MAXLEN = 128);

/// Comma separated list of service names for services assigned to group.
Property ServiceList As %String(MAXLEN = 1024);

}
