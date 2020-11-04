/// The %EM.Version class represents an Enterprise Manager version of service data for the remote API
Class %EM.Version Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Name of the group
Property GroupName As %String;

/// Name of the service
Property ServiceName As %String;

/// Version number of this version.
/// "Active" indicates the current active version and "Workspace" any current edits.
/// Otherwise this is a sequential integer indicating previous edits to the service.
Property VersionNumber As %String;

/// Description of this version
Property Description As %String(MAXLEN = 16000);

/// String used to identify a group of versions as a single "update", i.e. changes for a new version of an application.
/// Allows tracking of a set of changes, especially when exporting those changes to other Groups (moving from 'test' to 'production')
Property UpdateID As %String(MAXLEN = 128);

/// Date and time when this version was created
Property Created As %TimeStamp;

}
