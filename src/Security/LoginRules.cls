Include (%syAudit, %sySecurity, %sySystem, %occErrors, %ems)

/// Manipulate the LoginRules security settings.
/// <br><br>
/// This class should not be modified directly, its setting must be modified through the
/// Security.System class.
Class Security.LoginRules Extends (%Persistent, %SYSTEM.Help, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

Parameter EMSSERVICE [ Internal ] = "Users";

Index NameIndex On Name [ IdKey, Internal ];

/// Default domain system belongs to.<br>
/// This property is the default kerberos security domain which the system will
/// use for kerberos authentication. During installation, the system will attempt 
/// to set this property to the correct value. If you decide to use kerberos
/// authentication, you may need to modify this value. If you are not using kerberos,
/// do not change this value.
Property DefaultSecurityDomain As %String(MAXLEN = 64, MINLEN = 1) [ Internal ];

/// Description of the system parameters.<br>
Property Description As %String [ InitialExpression = "Login rules security parameters", Internal, Required ];

/// Inactive login limit.<br>
/// This property is the number of days a Cache security user account can be inactive
/// before it is disabled. Setting this property to 0 will disable account inactivation.
Property InactiveLimit As %Integer(MINVAL = 0) [ InitialExpression = 90, Internal, Required ];

/// Action to take when the InvalidLoginLimit is reached for a user.<br>
/// Bit 0 - Disable user account<br>
Property InvalidLoginAction As %Integer(MAXVAL = 1, MINVAL = 0) [ InitialExpression = 0, Internal ];

/// Invalid login limit.<br>
/// This property is the number of consecutive times a user can attempt to log 
/// into a Cache security account and fail. Once this limit is reached, the process
/// attempting to log in will start to "hang" for longer periods of time before an
/// access denied message is returned to the user. Setting this property to 0 will
/// disable this feature.
Property InvalidLoginLimit As %Integer(MINVAL = 0) [ InitialExpression = 5, Internal, Required ];

/// LDAP attribute name where the "Comment" field is retrieved.<br>
Property LDAPAttributeComment As %String(MAXLEN = 64) [ InitialExpression = "description", Internal ];

/// LDAP attribute name where the "FullName" field is retrieved.<br>
Property LDAPAttributeFullName As %String(MAXLEN = 64) [ InitialExpression = "displayName", Internal ];

/// LDAP attribute name where the "NameSpace" field is retrieved.<br>
Property LDAPAttributeNameSpace As %String(MAXLEN = 64) [ InitialExpression = "intersystems-Namespace", Internal ];

/// LDAP attribute name where the "Roles" field is retrieved.<br>
Property LDAPAttributeRoles As %String(MAXLEN = 64) [ InitialExpression = "intersystems-Roles", Internal ];

/// LDAP attribute name where the "Routine" field is retrieved.<br>
Property LDAPAttributeRoutine As %String(MAXLEN = 64) [ InitialExpression = "intersystems-Routine", Internal ];

/// List of additional LDAP attributes to return from LDAP Server.<br>
/// This property contains a list of additional LDAP User attributes for which 
/// you want values returned when a user authenticates himself via LDAP. For example,
/// you may want to return a user's mail address from the LDAP server. You would
/// set one of the list values to "mail" which is an LDAP attribute for a user. The
/// values for the set of attributes are written to the user's authentication record,
/// and may be retrieved by using the Security.Users class, Attributes property.
Property LDAPAttributes As list Of %String(MAXLEN = 64) [ Internal ];

Property LDAPBaseDN As %String(MAXLEN = 128) [ Internal ];

Property LDAPCACertFile As %String(MAXLEN = 256) [ Internal ];

Property LDAPClientTimeout As %Integer [ InitialExpression = {$$$LDAPDefaultClientTimeout}, Internal ];

Property LDAPDomainName As %String(MAXLEN = 128) [ Internal ];

Property LDAPFlags As %Integer [ InitialExpression = 0, Internal ];

Property LDAPHostNames As %String(MAXLEN = 128) [ Internal ];

Property LDAPSearchPassword As Security.Datatype.Password(MAXLEN = 64) [ Internal ];

/// Method to Get the LDAP Search Password.<br>
Method LDAPSearchPasswordGet() As %String [ Internal ]
{
}

/// Method to set the password.<br>
/// Input is a clear text string that is base64 encoded LDAPSearchPassword property.
Method LDAPSearchPasswordSet(Arg As %String) As %Status [ Internal ]
{
}

Property LDAPSearchUsername As %String(MAXLEN = 256) [ Internal ];

Property LDAPServerTimeout As %Integer [ InitialExpression = {$$$LDAPDefaultServerTimeout}, Internal ];

Property LDAPUniqueDNIdentifier As %String(MAXLEN = 128) [ Internal ];

/// By default "SYSTEM".<br>
/// It must not be modified.
Property Name As %String [ InitialExpression = {$$$SystemSecurityName}, Internal, Required ];

/// Password expiration period.<br>
/// This property governs how long a password for a user can be used
/// before it expires. Once a password expires, the user must change their
/// password before they can log in the next time. If this property is set to 0,
/// passwords will not expire on the system.
Property PasswordExpirationDays As %Integer [ InitialExpression = 0, Internal ];

/// Password Pattern.<br>
/// When a user is created in the Cache security database, or a user changes 
/// their password, the password is pattern matched
/// against the pattern stored in this property to determine if it matches. If it matches,
/// then the password is allowed. By default, the password must be between 3 and 32
/// characters, with alphanumerics and punctuations. A security setting of
/// "locked down" selected during install requires it to be a minimum of 8 characters long.
/// The Password pattern may be set to null meaning no pattern match on the password.
Property PasswordPattern As %String(MAXLEN = 64) [ InitialExpression = "3.32ANP", Internal ];

/// Password validation routine.<br>
/// When a user is created in the Cache security database, or a user changes their
/// password, the specified routine
/// is called to validate the password. A tag reference may also be included in the
/// property. The routine should be provided by the
/// user, and must exist in the %SYS namespace (it may be mapped to a different
/// database however.) The routine will take 2 parameters, a Username and new passsword,
/// and should return a %Status code of $$$OK for successfull password validation, or
/// an error code formatted into a %Status variable. The username passed into the 
/// function will be in all lowercase, and will contain the domain name if
/// multiple domains are enabled for the system.<br><br>
/// Here is an example of a password validation routine. Enter CHECK^PASSWORD into this property
/// to call it:<br>
/// <pre>
/// PASSSWORD ; Validate a user's password
/// #include %occInclude
/// CHECK(Username,Password) PUBLIC {
///   ; See if the password was previously used. If it was, return an error.
///   ; Allow the user to change it to the same one as current.
///   ; Store the list of previously used passwords for the user as a hashed value.
///   s PasswordHash=$System.Encryption.SHA1Hash(Password)
///   i $d(^PASSWORDLIST(Username,PasswordHash)){
///     i ^PASSWORDLIST(Username,"Current")=PasswordHash {
///       q $$$ERROR($$$GeneralError,"Password was previously used")
///     }
///   }
///   s ^PASSWORDLIST(Username,PasswordHash)=$h
///   s ^PASSWORDLIST(Username,"Current")=PasswordHash
///   q $$$OK
/// }
/// </pre>
Property PasswordValidationRoutine As %String(MAXLEN = 128) [ Internal ];

/// Allow multiple security domains.<br>
/// This property should only be set to 1 if you are using kerberos, and wish to 
/// allow cross domain realm authentication. Turning it on will cause all usernames to
/// include the domain from which they are logging in. Thus a $username such as "Steve"
/// will then be displayed and used as Steve@domainname.com.
Property SecurityDomains As Security.Datatype.BooleanYN [ InitialExpression = 0, Internal ];

/// Save value of DefaultSecurityDomain when object is opened
Property OldDefaultSecurityDomain As %String [ Internal, Transient ];

/// Save value of SecurityDomains when object is opened
Property OldSecurityDomains As %Boolean [ Internal, Transient ];

/// System LoginRules configuration exists.<br>
/// Used to get a handle to the Security.SystemRules object.<br>
/// Parameters:<br>
/// Name - Always "SYSTEM".<br>
/// Return values:<br>
/// If Value of the method = 0 (LoginRules config does not exist, or some error occured)<br>
/// System = Null<br>
/// Status = System does not exist, or other error message<br><br>
/// If Value of the method = 1 (System config exists)<br>
/// System = Object handle to System config<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String = {$$$SystemSecurityName}, ByRef System As %ObjectHandle, ByRef Status As %Status) As %Boolean [ Internal ]
{
}

/// Get the LoginRules security properties.<br>
/// Parameters:<br>
/// Name - Name of LoginRules parameter record, currently always "SYSTEM"
/// Properties (byref) - Array of system properties<br>
ClassMethod Get(Name As %String = {$$$SystemSecurityName}, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Get the system security properties.<br>
ClassMethod GetProperties(System As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// Save the current value of DefaultSecurityDomain
Method %OnOpen() As %Status [ Private, ServerOnly = 1 ]
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

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
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

/// Modify a User record to reflect a change in Domain
ClassMethod ChangeDomain(User As Security.Users, OldDomainName As %String, NewDomainName As %String) As %Status [ Internal ]
{
}

/// Note: This query may change in future versions<br>
Query List() As %Query(ROWSPEC = "Name:%String,DefaultSecurityDomain:%String,InactiveLimit:%String,InvalidLoginLimit:%String,InvalidLoginAction:%String,PasswordExpirationDays:%String,PasswordPattern:%String,PasswordValidationRoutine:%String,SecurityDomains:%String") [ Internal, SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<Data name="LoginRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefaultSecurityDomain</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>InactiveLimit</Value>
</Value>
<Value name="5">
<Value>InvalidLoginAction</Value>
</Value>
<Value name="6">
<Value>InvalidLoginLimit</Value>
</Value>
<Value name="7">
<Value>LDAPAttributeComment</Value>
</Value>
<Value name="8">
<Value>LDAPAttributeFullName</Value>
</Value>
<Value name="9">
<Value>LDAPAttributeNameSpace</Value>
</Value>
<Value name="10">
<Value>LDAPAttributeRoles</Value>
</Value>
<Value name="11">
<Value>LDAPAttributeRoutine</Value>
</Value>
<Value name="12">
<Value>LDAPAttributes</Value>
</Value>
<Value name="13">
<Value>LDAPBaseDN</Value>
</Value>
<Value name="14">
<Value>LDAPCACertFile</Value>
</Value>
<Value name="15">
<Value>LDAPClientTimeout</Value>
</Value>
<Value name="16">
<Value>LDAPDomainName</Value>
</Value>
<Value name="17">
<Value>LDAPFlags</Value>
</Value>
<Value name="18">
<Value>LDAPHostNames</Value>
</Value>
<Value name="19">
<Value>LDAPSearchPassword</Value>
</Value>
<Value name="20">
<Value>LDAPSearchUsername</Value>
</Value>
<Value name="21">
<Value>LDAPServerTimeout</Value>
</Value>
<Value name="22">
<Value>LDAPUniqueDNIdentifier</Value>
</Value>
<Value name="23">
<Value>PasswordExpirationDays</Value>
</Value>
<Value name="24">
<Value>PasswordPattern</Value>
</Value>
<Value name="25">
<Value>PasswordValidationRoutine</Value>
</Value>
<Value name="26">
<Value>SecurityDomains</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","LoginRulesD")</DataLocation>
<DefaultData>LoginRulesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","LoginRulesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","LoginRulesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","LoginRulesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
