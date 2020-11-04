Include (%sySecurity, %occInclude)

Class %SYSTEM.Security [ Abstract, System = 4 ]
{

/// Add the extra roles associated with the named application
ClassMethod AddRoles(ApplicationName As %String, Hash As %String = "") As %Status
{
}

/// Audit a user-level event.  If auditing is enabled for user level events, generate an audit record
/// with the user-specified information.
/// 
ClassMethod Audit(Source As %String, Type As %String, Name As %String, EventData As %String, Description As %String) As %Status [ Abstract ]
{
}

/// Change password for a user.<br>
/// Parameters:<br>
/// Username - Name of the User to change<br>
/// NewPassword - New password to set<br>
/// OldPassword - Old Password to validate against<br>
/// Return Value: <br>
/// 0 - Failure<br>
/// 1 - Password changed<br>
/// On failure, an error code is returned in Status.<br>
/// If the old password is not passed as a parameter, then the password will be changed
/// to the NewPassword parameter, providing the following:<br><br>
/// The calling process has Write permission on the resource that protects the 
/// CACHESYS database or the calling routine is stored in the CACHESYS database.<br>
/// If you are trying to change the password of a user who was created either through Delegated
/// authentication or through LDAP authentication, you will need to update the 
/// ChangePassword^ZAUTHENTICATE routine on your system. See the ZAUTHENTICATE routine in the
/// SAMPLES namespace for documentation.
ClassMethod ChangePassword(Username As %String, NewPassword As %String, OldPassword As %String, ByRef Status As %Status) As %Boolean
{
}

/// Determine if a specified privilege is held on a specified resource.
/// <br>
/// If called as $System.Security.Check(resource)
/// <br>
/// it returns the privileges held on that resource as a comma-separated
/// list.  For example,
/// <br>
/// $System.Security.Check("%DB_CACHETEMP") => "READ,WRITE"
/// <br><br>
/// If called as $System.Security.Check(resource,privilege) it returns 1 or
/// 0 depending on whether the specified privilege is held.  For example,
/// <br>
/// $System.Security.Check("%Development","USE") => 1
/// <br>
/// Note: If the process holds the %All role, then the method always returns "READ,WRITE,USE" for the 1-argument form
/// and 1 for the 2-argument form.<br>
/// 
ClassMethod Check(ResourceName As %String, Permissions As %String) As %CacheString [ Abstract ]
{
}

/// Determine if a specified privilege is held on a specified resource for a set of roles.
/// <br>
/// If called as $System.Security.CheckRolesPermission(Roles,Resource)
/// <br>
/// it returns the privileges held on that resource as a comma-separated
/// list. For example,
/// <br>
/// $System.Security.CheckRolesPermission("%Manager,%Operator","%DB_CACHESYS") => "READ,WRITE"
/// <br><br>
/// If called as $System.Security.CheckRolesPermission(Roles,Resource,Privilege) it returns 1 or
/// 0 depending on whether the specified privilege is held.  For example,
/// <br>
/// $System.Security.CheckRolesPermission("%Manager","%Admin_Secure","USE") => 1
/// <br>
/// The method will take the list of roles passed to this method, and for each role in the list will determine
/// if any additional roles are granted by this role. If so, it also adds this role to the list. Once the entire set of
/// roles is calculated, the list of resources and permissions which the list of roles contains is calculated. Finally,
/// any PUBLIC resources are also added to the list of resources and permission. The resource name is then checked against
/// this list to determine the return value for the method.<br>
/// Note: If one of the roles being checked is %All, then the method always returns "READ,WRITE,USE" for the 2-argument form
/// and 1 for the 3-argument form<br>
/// If the Role does not exist, or an error occurs, then the method will return "" for the 2-argument form
/// and 0 for the 3-argument form.<br>
/// 
ClassMethod CheckRolesPermission(Roles As %String, ResourceName As %String, Permissions As %String) As %CacheString
{
}

/// Determine if a specified privilege is held on a specified resource for a specific Username.
/// <br>
/// If called as $System.Security.CheckUserPermission(Username,Resource)
/// <br>
/// it returns the privileges held on that resource as a comma-separated
/// list. For example,
/// <br>
/// $System.Security.CheckUserPermission("Admin","%DB_CACHESYS") => "READ,WRITE"
/// <br><br>
/// If called as $System.Security.CheckUserPermission(Username,Resource,Privilege) it returns 1 or
/// 0 depending on whether the specified privilege is held.  For example,
/// <br>
/// $System.Security.CheckUserPermission("Operator","%Admin_Secure","USE") => 0
/// <br>
/// The method will take the Username passed to this method, and retrieve the list of roles the user is granted.
/// For each role in this list, it will determine 
/// if any additional roles are granted by this role. If so, it also adds this role to the list. Once the entire set of
/// roles is calculated, the list of resources and permissions which the list of roles contains is calculated. Finally,
/// any PUBLIC resources are also added to the list of resources and permission. The resource name is then checked against
/// this list to determine the return value for the method.<br>
/// Note: If the Username holds the %All role, then the method always returns "READ,WRITE,USE" for the 2-argument form
/// and 1 for the 3-argument form<br>
/// If the User does not exist, or an error occurs, then the method returns "" for the 2-argument form
/// and 0 for the 3-argument form<br>
/// 
ClassMethod CheckUserPermission(Username As %String, ResourceName As %String, Permissions As %String) As %CacheString
{
}

/// Validate a password against system password policy.<br>
ClassMethod ValidatePassword(Password As %String) As %Status
{
}

/// Log in a user given a valid username and password.<br>
/// Parameters:<br>
/// Username - Name of the user to log in as<br>
/// Password - Password of user to log in (optional)<br>
/// Return Value: <br>
/// 0 - Failure<br>
/// 1 - Success, user logged in<br>
/// If the password is not passed as a parameter (1 argument form), 
/// then the user will be logged in providing the following:<br><br>
/// The calling process has Write permission on the resource that protects the 
/// CACHESYS database or the calling routine is stored in the CACHESYS database
/// When the password is passed in as the second parameter (2 argument form), the 
/// method requires that the user has the %Service_Login:USE privilege.<br>
ClassMethod Login(Username As %String, Password As %String) As %Boolean
{
}

/// Return the permissions the process has for a global.<br>
/// Parameters:<br>
/// NameSpace - Namespace where the global exists.<br>
/// Global - name of the global<br>
/// Subscripts - Fully specified subscript including "()"<br>
/// Return Values:<br>
/// Comma delimited list of permissions process has on the global,
/// or "" for no access/invalid parameters.<br>
/// e.g. READ,WRITE<br>
/// Remarks:<br>
/// This method will follow the mapping of where the global actually
/// is mapped to to find out the access to it.<br>
/// Examples:<br>
/// Check the access on the source code for the %SS routine, which is stored
/// in the global ^ROUTINE("%SS")<br>
/// S x=$SYSTEM.Security.GetGlobalPermission("USER","ROUTINE","(""%SS"")")
ClassMethod GetGlobalPermission(NameSpace As %String = "", Global As %String, Subscript As %String) As %String
{
}

/// Given a set of roles, recurse through them for the entire set of roles which would be granted.<br>
/// When a role is granted to a process, the role itself may grant another role. This method takes a comma delimited
/// set of roles as input, and returns the comma delimited entire set of roles which would be granted to the process.<br>
/// Parameters:<br>
/// Roles - Comma delimited list of roles to recurse.<br>
/// Return value:<br>
/// RecursedRoles - Comma delimited list of recursed roles.<br>
ClassMethod GetRecursedRoleSet(Roles As %String, ByRef RecursedRoles As %String) As %Status
{
}

/// Given a Username, return the entire set of roles which would be granted if they logged in.<br>
/// When a role is granted to a process, the role itself may grant another role. This method takes a username 
/// as input, and returns the comma delimited entire set of roles which would be granted to the user if they logged in.<br>
/// Parameters:<br>
/// Username - Username to calculate recursed role set for.<br>
/// Return value:<br>
/// RecursedRoles - Comma delimited list of recursed roles.<br>
ClassMethod GetUserRecursedRoleSet(Username As %String, ByRef RecursedRoles As %String) As %Status
{
}

}
