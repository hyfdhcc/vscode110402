Include (%sySecurity, %sySystem, %syAudit, %occSystemMessages, %occErrors, %syEMS, %ems)

/// Define the security Role database, and methods which manipulate them.<br>
/// The system includes a set of pre-defined System roles. System roles cannot
/// be deleted. Legacy system roles may be deleted.<br><br>
/// Role names have the following properties:<br>
/// 1) Role names are case insensitive.<br>
/// 2) Maximum length of a role name is 64 characters.<br>
/// 3) Role name cannot contain a "," or ":"<BR>
/// 4) Role name cannot start with a "%" unless it is a pre-defined system role<br>
/// A role may exist which has no resources.<BR>
/// %DB_* implicit roles cannot be modified<br>
/// The %Admin Secure:USE permission is required to operate on a resource
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Roles Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index NameIndex On NameLowerCase [ IdKey ];

Parameter EMSSERVICE [ Internal ] = "Security";

/// Description of the role.
Property Description As %String(MAXLEN = 256);

/// Roles assigned to the Role.
Property GrantedRoles As list Of %String(MAXLEN = 64);

/// Role Name
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Role Name in lowercase<br>
/// Used for indexing, not to be displayed or modified.
Property NameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// Resource/Permission pairs the role holds
Relationship Resources As Resource [ Cardinality = children, Inverse = TheRole ];

/// Copy a Role.<br>
/// Copy an existing role in the Security database to a new one.<br>
/// Parameters:<br>
/// Name - Name of the role to be copied<br>
/// NewName - Name of the role to be created<br>
/// Description - Description of the new role<br>
ClassMethod Copy(Name As %String, NewName As %String, NewDescription As %String) As %Status
{
}

/// CopySQLPrivileges will copy SQL Admin Privileges and SQL Object Privileges from pFromRole to pToRole.
/// Parameters:<br>
/// pFromRole - Name of the role to copy SQL privileges from<br>
/// pToRole - Name of the role to copy SQL privileges to<br>
/// pNamespaceList - is a $Lb(namespace names).  If pNamespaceList is not specified or is "", the copy will be performed for ALL namespaces. 
///                              Otherwise supply a specific list of namespace you want to copy the privileges for.<br>
/// The privilege will be copied with the SAME grantor and grantee.  This means if UsersA granted a privilege to UserB, and UserC calls CopySQLPrivileges to
/// copy privs from UserB to UserD, the privileges UserD gets will have been granted by UserA.
/// You must have the %Admin_Secure resource in order to call this API. 
/// CopySQLPrivileges returns a %Status code
ClassMethod CopySQLPrivileges(pFromRole As %String, pToRole As %String, pNamespaceList As %List = "") As %Status
{
}

/// Create a Role.<br>
/// Create a Role in the Security database.<br>
/// Parameters:<br>
/// Name - Name of the role to create<br>
/// Description - Description of the role<br>
/// Resources - Resource/permission pairs to assign to the role<br>
/// Resources are in the format:<br>
/// ResourceName:Permission,ResourceName:Permission<br>
/// For example:<br>
/// s Resources="MyResource:RW,MyResource1:RWU"<br>
/// s Resources="" would create a role with no resources.<br>
/// Permision values are as follows:<br>
/// "R"<br>
/// "W"<br>
/// "U"<br>
/// GrantedRoles - Additional roles granted when this role is granted to a user<br>
/// GrantedRoles are in the format:<br>
/// "GrantedRole1,GrantedRole2"
ClassMethod Create(Name As %String, Description As %String, Resources As %String, GrantedRoles As %String) As %Status
{
}

/// Create LegacyRights Role.<br>
/// dbResources is a list of db resources to grant access to.
/// This method should only be called during an upgrade installation from 5.0 or earlier.
ClassMethod CreateLegacyRights(dbResources As %String) As %Status [ Internal ]
{
}

/// Delete a role.<br>
/// This method will delete a role from the security database and
/// remove the role from all the users which hold this role. It will then update
/// the in memory security database to mark this role as "No access" for
/// all resources this role holds. Pre-defined system roles cannot be deleted.<br>
/// Parameters:<br>
/// Name - Name of role to delete
ClassMethod Delete(Name As %String) As %Status
{
}

/// Role exists.<br>
/// This method checks for the existence of a role in the security database.<br>
/// Parameters:<br>
/// Name - Name of the role to check existence of<br>
/// Return values:<br>
/// If Value of the method = 0 (Role does not exist, or some error occured)<br>
/// Role = Null<br>
/// Status = Role "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Role exists)<br>
/// Role = Object handle to role<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String, ByRef Role As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports Role records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// Roles - Comma separated list of Roles to export, "*" = All<br>
/// Resources - Comma separated list of Resource names, "*" = All. Export
/// Roles containing only these resources<br>
/// SQLPrivileges - 1/0 flag.  If 1, export all SQL Privileges from all namespace on this system that have been directly granted to this Role<br>
/// NumSQLPrivilegesExported *byref) - Returns number of SQL Privileges and SQL Admin Privilege Set records exported
ClassMethod Export(FileName As %String = "RolesExport.xml", ByRef NumExported As %Integer, Roles As %String = "*", Resources As %String = "*", SQLPrivileges As %Boolean = 0, ByRef NumSQLPrivilegesExported As %Integer) As %Status
{
}

/// Get a role's properties.<br>
/// Gets a role's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the role to get<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// Properties("Description") - Description of the role<br>
/// Properties("Resources") -  Resource names/permission pairs
/// Resources are in the format:<br>
/// ResourceName:Permission,ResourceName:Permission<br>
/// For example:<br>
/// Properties("Resources")="MyResource:RW,MyResource1:RWU"<br>
/// Properties("GrantedRoles")=List of granted roles<br>
/// For example:<br>
/// Properties("GrantedRoles")="GrantedRole,GrantedRole1"<br>
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Get a role's properties.<br>
/// Gets a role's properties from the security database.<br>
/// Parameters:<br>
/// Role - Object handle to a role record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(Role As %ObjectHandle, ByRef Properties As %String) As %Status
{
}

/// Import Role records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Role records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String, ByRef NumImported As %Integer, Flags As %Integer = 0, ByRef NumSQLPrivsImported As %Integer) As %Status
{
}

/// Initialize the system with default roles.
ClassMethod Initialize() As %Status [ Internal, ProcedureBlock = 0 ]
{
}

/// Add role(s) to the Role's definition.<br>
/// Parameters:<br>
/// Rolename - Name of the Role to add roles to<br>
/// Roles - Comma delimited list of roles<br>
/// Admin - SQL ADMIN OPTION, TRUE if this user with this role can GRANT the Role to another user/role.  Only applicable in SQL.
ClassMethod AddRoles(Rolename As %String, ByRef Roles As %String, Admin As %Boolean = 0) As %Status [ Internal ]
{
}

/// Remove role(s) from the Role's definition.<br>
/// Parameters:<br>
/// Rolename - Name of the Role to remove roles from<br>
/// Roles - Comma delimited list of roles.<br>
ClassMethod RemoveRoles(Rolename As %String, ByRef Roles As %String) As %Status [ Internal ]
{
}

/// Checks if the role is in use.<br>
/// Checks if the role specified is used by any user.<br>
/// Parameters:<br>
/// Name - Name of the role to check.<br>
/// Return values:<br>
/// InUse = 0 Not used<br>
/// InUse = 1 Used<br>
/// Users = $list of users the role is used by or null if none<br>
/// MoreUsers = 0 - Entire list of users owning the role returned<br>
/// MoreUsers = 1 - Entire list of users owning the role Not returned<br>
/// Roles = $list of users the role is used by or null if none<br>
/// MoreRoles = 0 - Entire list of roles granting the role returned<br>
/// MoreRoles = 1 - Entire list of roles granted the role Not returned<br>
/// If MoreUsers=1, and you wish to get the entire list of users owning the role, 
/// use the following code:<br>
/// s x=##Class(Security.Roles).InUse("Role1",.InUse,.Users,.MoreUsers,.Roles,.MoreRoles)<br>
/// While (MoreUsers) {<br>
/// s SaveUsers($i(i))=Users<br>
/// s x=##Class(Security.Roles).InUse("Role1",.InUse,.Users,.MoreUsers.Roles,.MoreRoles)<br>
/// Flags - Bit string of options.<br>
/// Bit 0 - Only count and return Users which are enabled
/// Bit 1 - Return first two users with %All
/// 
/// }
ClassMethod InUse(Name As %String, ByRef InUse As %Boolean = 0, ByRef Users As %List, ByRef MoreUsers As %Boolean = 0, ByRef Roles As %List, ByRef MoreRoles As %Boolean = 0, Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Modify a role.<br>
/// Modify an existing role's properties in the security database.<br>
/// Parameters:<br>
/// Name - Name of the role to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// Properties("Resources")="" removes all resources from a role.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Given a role name, return its description
ClassMethod NameToDescription(Name As %String, Description As %String) As %String [ Internal ]
{
}

/// Get a recursed set of roles.<br>
/// Parameters:<br>
/// Roles - Comma delimited list of roles to recurse<br>
/// Return value:<br>
/// Roles - Comma delimited list of recursed roles<br>
ClassMethod RecurseRoleSet(Roles, ByRef RecurseRoles As %String) As %Status [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%AddToSaveSet</METHOD> method to 
/// provide notification that the current object is being included in a SaveSet, either
/// because %Save() was invoked on this object or an object that references this object.
/// 
/// <P>If this method returns an error status then %Save() will fail and the transaction
/// will be rolled back.
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

/// Initialize an EMS client when an event changes
ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// Return detailed information about a role.<br>
/// Names - Comma separated list of Role names, "*" = All<br>
/// Flags - Flags passed to query<br>
/// Bit 0 - Do not include read only system roles (%DB_*, %All)
/// Note: This query may change in future versions<br>
Query Detail(Names As %String, Flags As %Integer) As %Query(ROWSPEC = "Name:%String,Description:%String,GrantedRoles:%String,Resources:%String,CreatedBy:%String") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Names As %String = "*", Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 1 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

/// List all user records, brief display. <br>
/// Names - Comma separated list of Role names, "*" = All<br>
/// Resources - Comma separated list of resources names, "*"=ALL.
/// Resource names may be in the format "Resource1:RW,Resource2,Resource3:R". In
/// this example, the criteria for selection is passed if any role has one of the following:<br>
/// 1) RW on Resource1<br>
/// 2) Any access on Resource2<br>
/// 3) Read access on Resource3<br>
/// Flags - Flags passed to query<br>
///  Bit 0 - Do not include read only system roles (%DB_*, %All)
Query List(Names As %String, Resources As %String, Flags As %Integer) As %Query(ROWSPEC = "Name:%String,Description:%String,GrantedRoles:%String,CanBeEdited:%Boolean") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef %qHandle As %Binary, Names As %String = "*", Resources As %String = "*", Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef %qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef %qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Query ListAll1() As %SQLQuery
{
SELECT *  FROM Roles
 ORDER BY Name
}

/// List all user records, brief display. <br>
/// Names - Comma separated list of Role names, "*" = All<br>
/// Resources - Comma separated list of resources names, "*"=ALL.
/// Resource names may be in the format "Resource1:RW,Resource2,Resource3:R". In
/// this example, the criteria for selection is passed if any role has one of the following:<br>
/// 1) RW on Resource1<br>
/// 2) Any access on Resource2<br>
/// 3) Read access on Resource3<br>
/// Flags - Flags passed to query<br>
///  Bit 0 - Do not include read only system roles (%DB_*, %All)
Query ListAll(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String,GrantedRoles:%String,Resources:%String") [ SqlProc ]
{
}

ClassMethod ListAllExecute(ByRef %qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListAllFetch(ByRef %qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListAllExecute ]
{
}

ClassMethod ListAllClose(ByRef %qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListAllExecute ]
{
}

/// List all roles and their Resources and Permissions. <br>
/// Names - Comma separated list of Role names, "*" = All<br>
/// Resources - Comma separated list of resources names, "*"=ALL.
/// Resource names may be in the format "Resource1:RW,Resource2,Resource3:R". In
/// this example, the criteria for selection is passed if any role has one of the following:<br>
/// 1) RW on Resource1<br>
/// 2) Any access on Resource2<br>
/// 3) Read access on Resource3<br>
/// Flags - Flags passed to query<br>
///  Bit 0 - Do not include read only system roles (%DB_*, %All)
Query ListResources(Names As %String, Resources As %String, Flag As %Integer) As %Query(ROWSPEC = "Name:%String,Resource:%String,Permission:%String")
{
}

ClassMethod ListResourcesExecute(ByRef qHandle As %Binary, Names As %String = "*", Resources As %String = "*", Flag As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListResourcesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListResourcesExecute ]
{
}

ClassMethod ListResourcesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListResourcesExecute ]
{
}

Storage Default
{
<Data name="RolesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>GrantedRoles</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>NameLowerCase</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","RolesD")</DataLocation>
<DefaultData>RolesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","RolesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","RolesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","RolesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
