/// The %EM.Variable class represents an Enterprise Manager variable in service data for the remote API
Class %EM.Variable Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Group for which variable is defined
Property GroupName As %String;

/// Service for which variable is defined
Property ServiceName As %String;

/// Instance for which variable is defined or 0 if variable is for entire service
Property GUID As %String;

/// Name of the variable
Property VariableName As %String;

/// Value of the variable
Property Value As %String(MAXLEN = "");

}
