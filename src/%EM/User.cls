/// The %EM.User class represents an Enterprise Manager user for the remote API
Class %EM.User Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Name of the user
Property Username As %String;

/// Password of the user when setting.  Cannot be retrieved.
Property Password As %String;

/// Bit string of system wide privileges assigned to this user: $$$EMSUserEdit, $$$EMSUserApprove, $$$EMSUserActivate.
/// Default is $$$EMSUserNone
Property Privileges As %Integer;

/// true if this user is an EM super user
Property IsSuperUser As %Boolean;

/// true if this user is an EM system administrator
Property IsAdmin As %Boolean;

/// Bit string of privileges for a particular group: $$$EMSUserEdit, $$$EMSUserApprove, $$$EMSUserActivate.
/// Default is $$$EMSUserNone.
/// The group name is the array index.
Property GroupPrivileges As array Of %Integer;

}
