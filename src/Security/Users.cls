Include (%syAudit, %sySecurity, %sySystem, %msql, %syDatabase, %occErrors, %syEMS, %ems)

/// Define the security User database, and methods which manipulate them.<br>
/// The system includes a set of pre-defined System users.<br><br>
/// User names have the following properties:<br>
/// 1) User names are not case sensitive.<br>
/// 2) Maximum length of a user name is 128 characters.<br>
/// 3) User name cannot contain "*"
/// A user cannot have duplicate roles defined<br>
/// At least one user must hold the %All role<br>
/// All the roles granted to a user must exist in the roles database.<br><br>
/// Note: The speed at which a single process can create several users at a time
/// is limited by the PBKDF2 encryption method which hashes the password.
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Users Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Parameter EMSSERVICE [ Internal ] = "Users";

Index NameLowerCaseIndex On NameLowerCase [ IdKey ];

/// Account Expiration behavior.<br>
/// 0 - Account expires normally.<br>
/// 1 - Account will never expire.<br>
Property AccountNeverExpires As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// Attributes to apply to user when they log in.
Property Attributes As list Of %Binary(MAXLEN = "");

/// Two factor Authentication options which are enabled for this user.<br>
/// Options are:<br>
/// $$$AutheTwoFactorSMS - SMS Text authentication<br>
/// $$$AutheTwoFactorPW	- Time-based One-time Password<br>
Property AutheEnabled As %Integer [ InitialExpression = 0 ];

/// Change password on next login.<br>
/// 0 - Password change not required.<br>
/// 1 - Password change required before next login.<br>
Property ChangePassword As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// Comment.<br>
Property Comment As %String(MAXLEN = 256);

/// Account creation date and time.<br>
/// $H format in utc.<br>
Property CreateDateTime As %String [ InitialExpression = {$zts} ];

/// $username of user who created the account.<br>
Property CreateUsername As %String [ InitialExpression = {$username} ];

/// Email address of the user.<br>
Property EmailAddress As %String(MAXLEN = 256);

/// Allow user to log in.<br>
/// 0 - Disable login.<br>
/// 1 - Enable login.<br>
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// Last date an account can be used.<br>
/// $H date value of when an account becomes disabled.<br>
Property ExpirationDate As %Date;

/// In 2015.1, we change the date from type %Integer to %Date so that SQL would
/// format it correctly for an ad-hoc query. However, we must support the
/// older style date when we try to import an XML output file of users. So first call
/// the %Date translation, then if it fails, the %Integer format.
ClassMethod ExpirationDateXSDToLogical(%val) As %Library.Date [ Internal ]
{
}

/// Flags associated with user.<br>
/// Bit 0 - User created via normal security mechanisms (Cache Password User).<br>
/// Bit 1 - User created via LDAP.<br>
/// Bit 2 - User created via Delegated Authentication.<br>
Property Flags As %Integer [ InitialExpression = 1 ];

/// Full name of the user.<br>
Property FullName As %String(MAXLEN = 128);

/// Time-based One-time Password key.<br>
/// This property is automatically generated when the user is created using the 
/// $System.Encryption.GenCryptRand() method.<br>
Property HOTPKey As %Binary(MAXLEN = 20, MINLEN = 20) [ InitialExpression = {$System.Encryption.GenCryptRand(20)} ];

/// 0 - Do not generate a new Time-based One-time Password key when user is saved.<br>
/// 1 - Generate a new Time-based One-time Password key when user is saved.<br>
Property HOTPKeyGenerate As %Boolean [ InitialExpression = 0, Transient ];

/// Display the Time-based One-time Password QR code or key on next login for the
/// user to scan with their authentication device.<br>
Property HOTPKeyDisplay As %Boolean [ InitialExpression = 0 ];

/// Number of invalid login attempts since last successfull one.<br>
Property InvalidLoginAttempts As %Integer(MINVAL = 0, XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

/// Last invalid login date and time
Property InvalidLoginDateTime As %String(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

/// Last invalid login device
Property InvalidLoginDevice As %String(MAXLEN = 256, XMLPROJECTION = "NONE");

/// Last login error
Property InvalidLoginStatus As %Status(XMLPROJECTION = "NONE") [ InitialExpression = {$$$OK} ];

/// Last invalid login Service
Property InvalidLoginService As %String(MAXLEN = 64, XMLPROJECTION = "NONE");

/// Account modified date and time.<br>
/// $H format in utc.<br>
Property LastModifiedDateTime As %String [ InitialExpression = {$zts} ];

/// Information describing last modification of the user.<br>
Property LastModifiedInfo As %String(MAXLEN = 1024);

/// $username of the person who last modified it.<br>
Property LastModifiedUsername As %String(MAXLEN = 128) [ InitialExpression = {$username} ];

/// Legacy password from Windows Telnet or CacheDirect
Property LegacyPassword As %String(MAXLEN = 64) [ Internal ];

/// Last Successfull login date and time.<br>
/// $H format in utc.
Property LoginDateTime As %String(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

/// Last Successfull login device
Property LoginDevice As %String(MAXLEN = 256, XMLPROJECTION = "NONE");

/// Last Successfull login Service.<br>
Property LoginService As %String(MAXLEN = 64, XMLPROJECTION = "NONE");

/// User Name.<br>
/// Includes domain if multiple domains are enabled in the
/// format username@domain.
Property Name As %String(MAXLEN = 128) [ Required ];

/// User Name Lowercased.<br>
/// Includes domain if multiple domains are enabled, in the
/// format username@domain.
Property NameLowerCase As %String(MAXLEN = 128, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// NameSpace to run in only if a terminal session.<br>
Property NameSpace As %String(MAXLEN = 64);

/// PBKDF2 hashed password for Cache Authentication.<br>
/// This is used with a salt function obtained from 
/// $System.Encryption.GenCryptRand. This property is set by the class when the
/// PasswordExternal property is modified. Do not set this property directly.<br>
/// To modify the password for a user using objects, get an instance of the object and
/// modify the PasswordExternal property:<br>
/// i '..Exists(Username,.User,.Status) q Status<br>
/// s User.PasswordExternal=Password<br>
/// s Status=User.%Save()<br>
Property Password As Security.Datatype.Password(MAXLEN = 20);

/// Clear text password.<br>
/// This property is not stored in permanent storage. It is initially set to
/// the value of $c(0). When it is modified, the Password property is updated
/// to the PBKDF2 salted hashed value.
Property PasswordExternal As %String(MAXLEN = 128, XMLPROJECTION = "NONE") [ InitialExpression = {$c(0)}, Transient ];

/// Method to set the password.<br>
/// Input is a clear text string that is hashed into the Password property.
/// If the input argument is prefixed with $c(0), don't validate the password pattern.
/// PasswordExternal begins as $c(0).  If it changes, the password pattern will be validated.
Method PasswordExternalSet(Arg As %String) As %Status [ Internal ]
{
}

/// Password expires behavior.<br>
/// 0 - Password expires normally.<br>
/// 1 - Password never expires.<br>
Property PasswordNeverExpires As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// For internal use only
Property PasswordUpdated As %Boolean [ Internal, Private, Transient ];

/// Last password change date and time.<br>
/// $H format in utc.<br>
Property PasswordChangedDateTime As %String [ InitialExpression = {$zts} ];

/// Phone number for two-factor authentication
Property PhoneNumber As %String;

/// Mobile phone service provider for two-factor authentication
Property PhoneProvider As %String;

/// Roles assigned to the user.<br>
Property Roles As list Of %String(MAXLEN = 64);

/// Routine to run only if terminal session, ""=Programmer mode.<br>
Property Routine As %String(MAXLEN = 64);

/// Salt value for Hashed password from $System.Encryption.GenCryptRand.<br>
Property Salt As %Binary(MAXLEN = 8);

/// User holds the %All role.<br>
Property SuperUser As Security.Datatype.BooleanYN(XMLPROJECTION = "NONE") [ InitialExpression = 0, ReadOnly ];

/// Comma delimited list of last TimeStepLimit valid TOTP passwords entered .<br>
Property TOTPLastValidPasswords As %String(XMLPROJECTION = "NONE") [ Internal, ReadOnly ];

/// EMS 'forced' enable/disabled for all Instances. Override of Enabled property.
Property EMSGroupEnabled As %String(VALUELIST = ",Y,N") [ Internal ];

/// Add role(s) to the User's definition.<br>
/// Parameters:<br>
/// Username - Name of the user to add roles to<br>
/// Roles - Comma delimited list of roles<br>
/// Admin - SQL ADMIN OPTION, TRUE if this user can GRANT the Role to another user/role.  Only applicable in SQL.
ClassMethod AddRoles(Username As %String, ByRef Roles As %String, Admin As %Boolean = 0) As %Status
{
}

/// Log in a Cache Direct process using Cache' Authentication.<br>
/// Parameters:<br>
/// ProgName - Name of the executable (e.g. test.exe)
/// Signature - Cache direct calculated hash value of the executable.
/// Username - Username<br>
/// LegacyPassword - Old format Cache Direct hashed password<br>
/// Password - Plain text new password<br>
/// Return values:
/// 0 - Username/pw invalid<br>
/// 1 - Username/pw is valid<br>
ClassMethod CacheDirectLogin(ProgName As %String, Signature As %Integer, Username As %String, LegacyPassword As %String, Password As %String) As %Boolean [ Internal ]
{
}

/// Given a string, change the old Domain to the New Domain.<br>
/// Return the str with the new domain
ClassMethod ChangeDomain(str As %String, old As %String, new As %String) As %String [ Internal ]
{
}

/// Check access to SQL and Objects.<br>
ClassMethod CheckBindingsAccess(ns = "") As %Status [ Internal ]
{
}

/// Hashes the input clear text password and compares it to the user record's hashed password.<br>
/// Returns 1 if they match, 0 otherwise.<br>
ClassMethod CheckPassword(ByRef User As %ObjectHandle, Password As %String = "") As %Boolean [ Internal ]
{
}

/// Converts Legacy Cache Direct users into the Cache Security database.<br>
/// This method converts old Cache Direct users into the new security database.
/// It should only be run at installation time. It will also enable the Cache direct
/// service. This only gets called on an upgrade from 5.0.
ClassMethod ConvertLegacyCacheDirect() As %Status [ Internal ]
{
}

/// Converts Legacy windows telnet users into the Cache Security database.<br>
/// This method converts old windows telnet users users into the new security database.<br>
/// It should only be run at installation time.
ClassMethod ConvertLegacyTerminal() As %Status [ Internal ]
{
}

/// Converts Legacy SQL users into the Cache Security database.<br>
/// This method converts old SQL users into the new security database.<br>
/// It should only be run at installation time.
ClassMethod ConvertLegacySQL(ByRef ns As %String, debug As %Library.Integer = 0) As %Status [ Internal ]
{
}

/// Copy a User.<br>
/// Copy an existing User in the Security database to a new one.<br>
/// Parameters:<br>
/// Name - Name of the User to be copied.<br>
/// NewName - Name of the user to be created.<br>
/// NewFullName - Full name of the new user.<br>
/// SQLSysPrivs - Copy SQL system privileges.<br>
/// SQLObjPrivs - Copy SQL object provileges.<br>
ClassMethod Copy(Name As %String, NewName As %String, NewFullName As %String = "", SQLSysPrivs As %Boolean = 1, SQLObjPrivs As %Boolean = 1) As %Status
{
}

/// Create a User.<br>
/// Create a User in the Security database.<br>
/// There are 2 ways to call this method and pass the parameters:<br><br>
/// s x=##Class(Security.Users).Create(User,Roles,Password,FullName,...)<br>
/// or<br>
/// s x=##Class(Security.Users).Create(User,.Properties)<br><br>
/// Where Properties are contained in an array subscripted by 
/// property name, passed by reference.
/// See the Get() method for a description of the Properies array. Valid
/// properties for the Create() method are described below, other 
/// values are ignored.<br>
/// Parameters:<br>
/// Name - Name of the user to create<br>
/// UserRoles - List format of roles to assign to the user<br>
/// Roles are in the format:<br>
/// "Role1,Role2"
/// For example:<br>
/// s Roles="%Developer,%Operator"<br>
/// s Roles="" would create a user with no roles<br>
/// Password - Cache authentication password for the user in clear text. <br>
/// Create() will set it into PasswordExternal which will set Password to the hashed value.<br>
/// FullName - Full name of the user<br>
/// NameSpace - Namespace of the user for terminal access<br>
/// Routine - Routine the user runs for terminal access. Routine="" means programmer mode.<br>
/// ExpirationDate - ODBC date format of when the user account expires, or ""=no expiration<br>
/// ChangePassword - 0/1, User cannot log in until the password is changed<br>
/// Enabled - 0/1, account is disabled/enabled<br>
/// Comment - Comment<br>
/// Flags - Internal use only, pass 1 for this<br>
///  Bit 0 - User created normally for Cache authentication<br>
///  Bit 1 - User created by LDAP authentication<br>
///  Bit 2 - User created by User Defined authentication<br>
/// PhoneNumber - Phone number for two-factor authentication
/// PhoneProvider - Mobile phone service provider for two-factor authentication
/// EmailAddress - Email address of the user.<br>
/// HOTPKey - HOTP key used for Display Time-Based One-time Password<br>
/// HOTPKeyDisplay - 0/1 - Display QR Code and key on next login<br>
/// Attributes (byref) - Array of attributes to be associated with the user<br>
///  Attribute(Name)=Value<br>
/// AccountNeverExpires - 0/1, Account will never expire<br>
/// PasswordNeverExpires - 0/1, Password will never expire<br>
ClassMethod Create(Username As %String, UserRoles As %String, Password As %String, FullName As %String, NameSpace As %String, Routine As %String, ExpirationDate As %String, ChangePassword As %Boolean, Enabled As %Boolean, Comment As %String, Flags As %String = 1, PhoneNumber As %String, PhoneProvider As %String, ByRef Attributes As %String, AccountNeverExpires As %Boolean, PasswordNeverExpires As %Boolean) As %Status
{
}

/// Log in CSP server process.<br>
/// Log in a CSP server process by validating the username/password.
/// Username - Username <br>
/// Password - Plain text password<br>
/// Return values:<br>
/// 1 - Success<br>
/// Failure will halt the process
ClassMethod CSPServiceLogin(Username As %String, Password As %String) As %Boolean [ Internal ]
{
}

/// Delete a User.<br>
/// This method will delete a User from the security database.<br>
/// Parameters:<br>
/// Username - Username to delete
ClassMethod Delete(Username As %String) As %Status
{
}

/// Legacy method to encrypt the Windows Telnet user's password.
ClassMethod EncryptLegacyTerminalPassword(pw As %String) As %String [ Internal ]
{
}

/// User exists.<br>
/// This method checks for the existence of a user in the security database.<br>
/// Parameters:<br>
/// Username - Name of the user to check existence of<br>
/// Flag - Internal use only, must be 0 or not passed<br>
/// Requires the %Admin_Secure:USE privilege to change the $USERNAME value.<br>
/// Return values:<br>
/// If Value of the method = 0 (User does not exist, or some error occured)<br>
/// User = Null<br>
/// Status = User "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (User exists)<br>
/// User = Object handle to user<br>
/// ActualUserName = exact-case of user's name (used by SQL)
/// Status = User "x" already exists<br>
ClassMethod Exists(Username As %String, ByRef User As %ObjectHandle, ByRef Status As %Status, Flag As %Integer = 0) As %Boolean
{
}

/// Set selected users accounts as having to change their
/// password on next login.<br>
/// This does not affect LDAP or Delegated authentication accounts.
/// It also does not affect users who have the PasswordNeverExpires flag set.<br>
/// Parameters:<br>
/// Names - Comma separated list of user names, "*" = All<br>
/// Count - Return value of number of users expired.<br>
/// This method requires %Admin_Secure:USE permission to run.
ClassMethod ExpireUserPasswords(Names As %String, ByRef Count As %Integer) As %Status
{
}

/// This method exports User records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// Usernames - Comma separated list of Usernames to export, "*" = All<br>
/// Roles - Comma separated list of Roles, "*" = All. Export Users
/// containing only these roles<br>
/// SQLPrivileges - 1/0 flag.  If 1, export all SQL Privileges from all namespace on this system that have been directly granted to this Role<br>
/// NumSQLPrivilegesExported *byref) - Returns number of SQL Privileges and SQL Admin Privilege Set records exported
ClassMethod Export(FileName As %String = "UsersExport.xml", ByRef NumExported As %Integer = 0, Usernames As %String = "*", Roles As %String = "*", SQLPrivileges As %Boolean = 0, ByRef NumSQLPrivilegesExported As %Integer) As %Status
{
}

/// Get a User's properties.<br>
/// Gets a User's properties from the security database.<br>
/// Parameters:<br>
/// Username - Name of the user to get<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// Properties("AccountNeverExpires") - 0=Expires normally, 1=Never expires<br>
/// Properties("Attributes",Name) = $lb(Value1,Value2) - Attributes and values to associate with process<br>
/// Properties("ChangePassword") - 0=Don't change, 1=Change before next login
/// Properties("Comment") - Comment<br>
/// Properties("EmailAddress") - Email Address<br>
/// Properties("Enabled") - 0=Disabled, 1=Enabled<br>
/// Properties("ExpirationDate") - Expiration date of account, ODBC date format<br>
/// Properties("Flags") - Flags of the user<br>
/// Properties("FullName") - Full name of the user<br>
/// Properties("InvalidLoginAttempts") - Number of invalid login attempts since last success<br>
/// Properties("InvalidLoginDateTime") - $h value of last invalid login attempt<br>
/// Properties("InvalidLoginDevice") - Last device for invalid login attempt<br>
/// Properties("InvalidLoginStatus") - Last error status for an invalid login attempt<br>
/// Properties("InvalidLoginService") - Last service used for an invalid login attempt<br>
/// Properties("LegacyPassword") - Legacy password for Cache Direct<br>
/// Properties("LoginDateTime") - $h value for last valid login attempt<br>
/// Properties("LoginDevice") - Last valid login device<br>
/// Properties("LoginService") - Last valid login service<br>
/// Properties("NameSpace") - Default Namespace for terminal login<br>
/// Properties("Password") - Cache Authentication password hashed value<br>
/// properties("PasswordNeverExpires") - 0=Expires normally, 1=Never expires<br>
/// Properties("PhoneNumber") - Phone number for two-factor authentication<br>
/// Properties("PhoneProvider") - Mobile phone service provider for two-factor authentication<br>
/// Properties("Roles")- Comma-separated List format of roles<br>
/// Roles are in the format:<br>
/// "Role1,Role2"<br>
/// For example:<br>
/// s Properties("Roles")="%Developer,%Operator"<br>
/// Properties("Routine") - Routine the user runs for terminal access. Routine="" means programmer mode.<br>
/// Properties("Salt") - Salt used to generate password.<br>
/// Properties("SuperUser") - 0=No, 1=Yes.<br>
ClassMethod Get(Username As %String, ByRef Properties As %String) As %Status
{
}

/// Get a User's properties.<br>
/// Gets a User's properties from the security database.<br>
/// Parameters:<br>
/// Username - Object handle to a User record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(User As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Get a User's or Roles set of resources.<br>
/// Gets a User's set of resource/permission pairs he would be granted if logged in.<br>
/// Parameters:<br>
/// Username - Name of the user to get<br>
/// Roles - Comma delimited list of roles to return resources for<br>
/// Resources - Comma delimited list of resource:permission pairs<br>
ClassMethod GetResourceSet(Username As %String = "", Roles As %String = "", ByRef Resources As %String) As %Status
{
}

/// Get a User's set of roles.<br>
/// Gets a User's set of roles he would be granted if logged in.<br>
/// Parameters:<br>
/// Username - Name of the user to get<br>
/// Return value:<br>
/// Roles - Comma delimited list of roles a user would be granted if logged in<br>
ClassMethod GetRoleSet(Username As %String, ByRef Roles As %String) As %Status
{
}

/// Determines if a user owns a resource which permits terminal login.<br>
/// Parameters:<br>
/// Username - Name of the user<br>
/// Roles - Comma delimited list of roles to check for the resource<br>
/// Either Username or Roles can be passed here (but not both). You would pass a list
/// of roles if the current user role info was not saved to disk.
/// Return value:<br>
/// Roles - Comma delimited list of roles a user would be granted if logged in<br>
ClassMethod GetTerminalLoginStatus(Username As %String = "", Roles As %String = "", ByRef Enabled As %String) As %Status [ Internal ]
{
}

/// Return Information about the server for the specified user<br>
/// Parameters:<br>
/// Username - Name of the user<br>
/// Password - Password of the user<br>
/// Type - Type of information to return<br>
/// 0 - $list of namespaces the user has some privileges in<br>
/// 1 - $list of namespaces the user has some privileges in, including SQL privileges<br>
/// 2 - 0/1 of whether the user has %Development:Use permission<br>
/// 3 - $list of namespaces the user has Read and Write permission in <br>
/// 4 - $list of all namespaces
/// 5 - Returns $list of namespaces the user has some privileges in plus unmounted remote ones
/// Note: If doing kerberos authentication, username and password may be ""<br>
/// Return values:<br>
/// 0 - Call failed for some reason (invalid user/pw, etc.), Real error may be in %objlasterror<br>
/// 1 - Call succeded, Info returned<br>
/// Info - Returned information<br>
/// Note: It is assumed that this method is called by a process holding the %All role<br>
ClassMethod GetInfo(Username As %String, Password As %String, Type As %Integer, ByRef Info As %String) As %Boolean [ Internal ]
{
}

/// Prompt for a Username/PW
ClassMethod GetUsernameAndPassword(ByRef Username As %String, ByRef Password As %String, Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Import User records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import User records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "UsersExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0, ByRef NumSQLPrivsImported As %Integer) As %Status
{
}

/// Initialize the user database at installation time.
ClassMethod Initialize() As %Status [ Internal ]
{
}

/// Check and see if the user has root access to the O/S.
ClassMethod IsAdministrator() As %Boolean [ Internal ]
{
}

/// Returns where a user is a SuperUser or not (has %All Role).<br>
/// Parameters:<br>
/// Username -  Name of the user<br>
/// Status   -  Function's Status Code<br>
ClassMethod IsASuperUser(Username As %String, ByRef Status As %Status) As %Boolean [ Internal ]
{
}

/// Modify a User's properties.<br>
/// Modifies a User's properties from the security database.<br>
/// Parameters:<br>
/// Username - Name of the user to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
/// If a value is unchanged it is not set to prevent the property modified state from being set.<br>
/// Note that if a new password is passed in, then the hashed value of the password
/// will be returned in the properties array.
ClassMethod Modify(Username As %String, ByRef Properties As %String) As %Status
{
}

/// Given a User name, return its description
ClassMethod NameToDescription(Name As %String, Description As %String) As %String [ Internal ]
{
}

/// Prompts for a new password.<br>
/// This method prompts for and confirms a new password on the current device (terminal)<br>
/// Note that this method will validate the new password against any defined system
/// password pattern.<br>
/// Password - If the old password is passed in, then the new password must be different than the old one.<br>
/// Flags - Validate entered password against system patterns
/// Return Values:<br>
/// Password - New password
ClassMethod PromptForNewPassword(ByRef Password As %String = "", Username As %String = "", Flags = 1) As %Status [ Internal ]
{
}

/// Prompts for a Password<br>
/// This method will prompt for and return a password<br>
/// Flags - Flags for prompting<br>
/// Bit 0 - Validate against system password pattern<br>
/// Bit 1 - Passed in when the system is hung so we don't reference a
/// process private global and hang ourselves.<br>
/// Return Values:<br>
/// Password - Password
ClassMethod PromptForPassword(Flags As %Boolean, ByRef Password As %String, Username As %String = "") As %Status [ Internal ]
{
}

/// Prompts for a username<br>
/// This method will prompt for and return a username<br>
/// Flags - Flags for prompting<br>
/// Bit 1 - Passed in when the system is hung so we don't reference a
/// process private global and hang ourselves.<br>
/// Return Values:<br>
/// Username - Username
ClassMethod PromptForUsername(ByRef Username As %String, Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Remove role(s) from the User's definition.<br>
/// Parameters:<br>
/// Username - Name of the user to remove roles from<br>
/// Roles - Comma delimited list of roles.<br>
ClassMethod RemoveRoles(Username As %String, ByRef Roles As %String) As %Status [ Internal ]
{
}

/// Take a Username, and see if a role by the same name exists.<br>
/// Returns $$$OK if the role does not exist.
ClassMethod RoleExists(Name As %String) As %Status [ Internal ]
{
}

/// Given a convert the old Domain name to the New Domain name in the ^%SYS("sql") structures
ClassMethod SQLChangeDomainSYS(OldDomain As %String, NewDomain As %String) As %Status [ Internal, ProcedureBlock = 1 ]
{
}

/// Given a database name (db), convert the old Domain name to the New Domain name
ClassMethod SQLChangeDomainDB(db As %String = "", OldDomain As %String, NewDomain As %String) As %Status [ Internal, ProcedureBlock = 1 ]
{
}

ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// Update Security.Users class data on the EMS Server to reflect changes made on the client.
/// Action - 1=Modification made on EMS
ClassMethod UpdateEMSClient(Username As %String, Action As %Integer) As %Status [ Internal ]
{
}

/// Update Security.Users class data on the EMS Server to reflect changes made on the client.
ClassMethod UpdateOne(GUID As %String, Username As %String, ClientUserRecord As %List) As %Status [ Internal ]
{
}

/// Upload Security.Users class data (a single global node) to the requesting client.
ClassMethod UploadOne(GUID As %String, Username As %String, ByRef UserRecord As %List) As %Status [ Internal ]
{
}

/// Log in an ODBC process using Cache Authentication<br>
/// Log in an ODBC process by validating the username/password against 
/// Cache Authentication. If validated, set $username to the user along the with 
/// user's security context.<br>
/// Parameters:<br>
/// Namespace - Namespace we are trying to connect to<br>
/// Username - Username <br>
/// Password - Plain text password<br>
/// Return values:<br>
/// 0 - Failure<br>
/// 1 - Success
ClassMethod XDBCLogin(Namespace As %String = "", Username As %String, Password As %String, ByRef UserRecord As %String) As %Boolean [ Internal ]
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
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

/// List all user records, brief display. <br>
/// Names - Comma separated list of user names, "*" = All<br>
/// Roles - Comma separated list of Role names, "*"=ALL <br>
/// LastLoginOlderThan - Select users who haven't logged in in more than x days, "*"=ALL
/// Flags - 0 - Use "Startswith" as the selection on the name.<br>
/// Flags - 1 - Use "Contains" as the selection on the name.<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String, Roles As %String, LastLoginOlderThan As %Integer, Flags As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Enabled:%String,Roles:%String,LastLoginTime") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", Roles As %String = "*", LastLoginOlderThan As %Integer = 0, Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// List all user records, brief display. <br>
/// Names - Comma separated list of user names, "*" = All<br>
/// Roles - Comma separated list of Role names, "*"=ALL<br>
/// LastLoginOlderThan - Select users who haven't logged in in more than x days, "*"=ALL
/// Flags - 0 - Use "Startswith" as the selection on the name.<br>
/// Flags - 1 - Use "Contains" as the selection on the name.<br>
/// Note: This query may change in future versions<br>
Query Detail(Names As %String, Roles As %String, LastLoginOlderThan As %Integer, Flags As %Integer = 0) As %Query(ROWSPEC = "Name:%String,FullName:%String,Comment:%String,Enabled:%String,ExpirationDate:%String,Roles:%String,GrantedRoles:%String,Namespace:%String,Routine:%String,LastPasswordChangeTime:%String,LastLoginTime:%String,LastLoginService:%String,LastLoginDevice:%String,LastInvalidLoginTime:%String,LastLoginError:%String,InvalidLoginAttempts:%String,LastInvalidLoginService:%String,LastInvalidLoginDevice:%String,Type:%String,EmailAddress:%String,PhoneNumber:%String,PhoneProvider:%String,AccountNeverExpires:%String,PasswordNeverExpires:%String,AutheEnabled:%String,CreateDateTime:%String,CreateUsername:%String,LastModifiedDateTime:%String,LastModifiedUsername:%String,LastModifiedInfo:%String") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Names As %String = "*", Roles As %String = "*", LastLoginOlderThan As %Integer = "*", Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

/// A list of system Users to exclude from EMS management.
/// The actual User names are converted to lower case so they match the internal IdKey of the record. 
ClassMethod EMSExclude() As %List [ Internal ]
{
}

/// Used for download of all Users to EMS. Exclude Users which should not be managed by EMS.
Query EMSExtent() As %Query(ROWSPEC = "ID:%String") [ Internal ]
{
}

ClassMethod EMSExtentExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod EMSExtentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = EMSExtentExecute ]
{
}

ClassMethod EMSExtentClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = EMSExtentExecute ]
{
}

Storage Default
{
<Data name="UsersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChangePassword</Value>
</Value>
<Value name="3">
<Value>Comment</Value>
</Value>
<Value name="4">
<Value>Enabled</Value>
</Value>
<Value name="5">
<Value>EventFlags</Value>
</Value>
<Value name="6">
<Value>ExpirationDate</Value>
</Value>
<Value name="7">
<Value>FullName</Value>
</Value>
<Value name="8">
<Value>InvalidLoginAttempts</Value>
</Value>
<Value name="9">
<Value>InvalidLoginDateTime</Value>
</Value>
<Value name="10">
<Value>InvalidLoginDevice</Value>
</Value>
<Value name="11">
<Value>InvalidLoginService</Value>
</Value>
<Value name="12">
<Value>InvalidLoginStatus</Value>
</Value>
<Value name="13">
<Value>LegacyPassword</Value>
</Value>
<Value name="14">
<Value>LoginDateTime</Value>
</Value>
<Value name="15">
<Value>LoginDevice</Value>
</Value>
<Value name="16">
<Value>LoginService</Value>
</Value>
<Value name="17">
<Value>Name</Value>
</Value>
<Value name="18">
<Value>NameSpace</Value>
</Value>
<Value name="19">
<Value>Password</Value>
</Value>
<Value name="20">
<Value>PasswordChangedDateTime</Value>
</Value>
<Value name="21">
<Value>Roles</Value>
</Value>
<Value name="22">
<Value>Routine</Value>
</Value>
<Value name="23">
<Value>SuperUser</Value>
</Value>
<Value name="24">
<Value>Salt</Value>
</Value>
<Value name="25">
<Value>Flags</Value>
</Value>
<Value name="26">
<Value>Attributes</Value>
</Value>
<Value name="27">
<Value>PhoneNumber</Value>
</Value>
<Value name="28">
<Value>PhoneProvider</Value>
</Value>
<Value name="29">
<Value>AccountNeverExpires</Value>
</Value>
<Value name="30">
<Value>PasswordNeverExpires</Value>
</Value>
<Value name="31">
<Value>EMSGroupEnabled</Value>
</Value>
<Value name="32">
<Value>AutheEnabled</Value>
</Value>
<Value name="33">
<Value>CreateDateTime</Value>
</Value>
<Value name="34">
<Value>CreateUsername</Value>
</Value>
<Value name="35">
<Value>LastModifiedDateTime</Value>
</Value>
<Value name="36">
<Value>LastModifiedInfo</Value>
</Value>
<Value name="37">
<Value>LastModifiedUsername</Value>
</Value>
<Value name="38">
<Value>HOTPKey</Value>
</Value>
<Value name="39">
<Value>HOTPKeyDisplay</Value>
</Value>
<Value name="40">
<Value>EmailAddress</Value>
</Value>
<Value name="41">
<Value>TOTPLastValidPasswords</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,6))@("Security","UsersD")</DataLocation>
<DefaultData>RolesDefaultData</DefaultData>
<ExtentSize>10</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,6))@("Security","UsersD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,6))@("Security","UsersI")</IndexLocation>
<Property name="%%CLASSNAME">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="AccountNeverExpires">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Attributes">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ChangePassword">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Comment">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Enabled">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ExpirationDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Flags">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="FullName">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="InvalidLoginAttempts">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="InvalidLoginDateTime">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="InvalidLoginDevice">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="InvalidLoginService">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="InvalidLoginStatus">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LegacyPassword">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LoginDateTime">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="LoginDevice">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LoginService">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="Name">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="NameSpace">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Password">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="PasswordChangedDateTime">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="PasswordNeverExpires">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PhoneNumber">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PhoneProvider">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Roles">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="Routine">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Salt">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="SuperUser">
<Selectivity>50.0000%</Selectivity>
</Property>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,6))@("Security","UsersS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

/// Test populate a Users database
/// 'Count' indicates how many Users records to create
/// 'User' is a User.Name to use as a base for most of the Properties
/// Create this User first with Roles, Namespace, Privs , etc.
/// Names are generated from %PopulateUtils, and Password is always set to "Password0123456789"
ClassMethod TestPopulate(Count As %Integer, User As %String) As %Status [ Internal ]
{
}

/// Remove all Users created by  TestPopulate().
ClassMethod TestRemove() As %Status [ Internal ]
{
}

/// Before Delete trigger, call %OnDelete method and if error, don't allow the DELETE
Trigger BDTrigger [ Event = DELETE ]
{
}

}
