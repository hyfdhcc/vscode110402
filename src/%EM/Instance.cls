/// The %EM.Instance class represents an Enterprise Manager instance for the remote API
Class %EM.Instance Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Instance GUID
Property GUID As %String;

/// Instance name for this instance <nodeName>:<instanceName>.
Property Name As %String(MAXLEN = 128);

/// State of managed instance as described in %ems.inc<br>
///    $$$EMSCStateAwaitingAccept - A management request made, but not yet accepted or rejected<br>
///    $$$EMSCStateManaged - This instance is currently actively managed by EM<br>
///    $$$EMSCStateSuspended - Suspended<br>
///    $$$EMSCStateNotUpdated - Managed but not updated<br>
///    $$$EMSCStateRejected - This instance has been rejected for management<br>
///    $$$EMSCStateRemoved - This instance has been removed from management<br>
Property State As %Integer;

/// Descriptive data associated with the instance
Property InstanceData As %EM.InstanceData;

/// Comma separated list of names of groups which manage this instance.
Property GroupList As %String(MAXLEN = 1024);

/// Comma separated list of names of services for which this instance is managed.
Property ServiceList As %String(MAXLEN = 1024);

}
