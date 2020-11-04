/// The authorization server configuration is maintained by the OAuth2.Server.Configuration class.
/// We supply an SMP page, %CSP.UI.Portal.OAuth2.Server, which configures the OAuth2 server as part
/// of the SMP.  It is possible customize the authorization server by replacing this page by a
/// user written page which maintains the OAuth2.Server.Configuration class instance.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Server.Configuration Extends %Persistent [ System = 4 ]
{

/// The IDKEY for the singleton configuration class.
Index IDIndex On Key [ IdKey, Unique ];

/// Key for singleton
Property Key As %String [ InitialExpression = "singleton", Internal, Private ];

/// IssuerEndpoint is the endpoint for this authorization server.
Property IssuerEndpoint As OAuth2.Endpoint [ Required ];

/// Description is a human readable of this authorization server.
Property Description As %String(MAXLEN = 1024);

/// AccessTokenInterval is the interval in seconds after which an access token issued by this
/// server will expire.  The default is 3600 seconds.
Property AccessTokenInterval As %Integer(MINVAL = 1) [ InitialExpression = 3600, Required ];

/// AuthorizationCodeInterval is the interval in seconds after which an authorization code issued
/// by this server will expire.  The default is 60 seconds.
Property AuthorizationCodeInterval As %Integer(MINVAL = 1) [ InitialExpression = 60, Required ];

/// RefreshTokenInterval is the interval in seconds after which a refresh token issued
/// by this server will expire.  The default is 24 hours = 86400 seconds.
Property RefreshTokenInterval As %Integer(MINVAL = 1) [ InitialExpression = 86400, Required ];

/// SessionInterval is the interval in seconds after which a user session will be
/// automatically terminated.  The value 0 means the session will not be automatically terminated.
/// The default is 24 hours = 86400 seconds.
Property SessionInterval As %Integer(MINVAL = 0) [ InitialExpression = 86400, Required ];

/// SupportedScopes is a %ArrayOfDatatypes which specifies all scopes supported by this Authorization Server.
/// The index for each array element is the scope and the value is the description of the scope for display.
Property SupportedScopes As array Of %String(MAXLEN = 1024) [ Required ];

/// DefaultScope is a blank separated list containing the default for access token scope
/// if scope is not specified in the access token request or in the client configuration.
Property DefaultScope As %String(MAXLEN = 1024);

/// If AllowUnsupportedScope is true (1), then unsupported scope values will be ignored.
/// Otherwise, an error will be returned.
Property AllowUnsupportedScope As %Boolean [ InitialExpression = 0 ];

/// SupportedGrantTypes is the grant types that are supported to create an access token.
/// This property is a string of 1 to 4 characters with one character for each supported grant type as follows:<br>
/// - "A" - Authorization Code
/// - "I" - Implicit
/// - "P" - Resource Owner Password Credentials
/// - "C" - Client Credentials
Property SupportedGrantTypes As %String(MAXLEN = 4, MINLEN = 1) [ Required ];

/// ReturnRefreshToken defines the conditions under which a refresh token is returned along with the access token.
/// This property is a string of multiple condition characters which are OR'ed.
/// "" means only return a RefreshToken as required by OpenID Connect.<br>
/// - "a" - Always
/// - "c" - Confidential client
/// - "f" - if offline_access scope requested
Property ReturnRefreshToken As %String;

/// If SupportSession is true, then OAuth 2.0 user sessions will be supported using
/// the specified SessionClass.
Property SupportSession As %Boolean;

/// If AudRequired is true, then an authorization code and implicit requests require the aud property.
Property AudRequired As %Boolean;

/// CustomizationRoles is a comma separated list of roles that are set for any call
/// to user supplied customization code.
Property CustomizationRoles As %String(MAXLEN = 1024, MINLEN = 1) [ Required ];

/// CustomizationNamespace is the Cache namespace where the customization code is to be run.
Property CustomizationNamespace As %String [ Required ];

/// AuthenticateClass is the name of a subclass of %OAuth2.Server.Authenticate which will be used
/// to allow override of the DirectLogin, DisplayLogin and DisplayPermissions methods during user authorization.
Property AuthenticateClass As %String(MAXLEN = 256, MINLEN = 1) [ InitialExpression = "%OAuth2.Server.Authenticate", Required ];

/// SessionClass is the name of a class with the same signatures as OAuth2.Server.Session
/// which includes GetUser, Login and Logout methods.  These methods maintain an OAuth 2.0
/// session using any appropriate means.  The default OAuth2.Session class uses an httpOnly cookie.
Property SessionClass As %String(MAXLEN = 256, MINLEN = 1) [ InitialExpression = "OAuth2.Server.Session", Required ];

/// ValidateUserClass is the name of a class with the same signatures as %OAuth2.Server.Validate which may override the
/// ValidateUser method which validates a user and associates a set of properties with this user.
Property ValidateUserClass As %String(MAXLEN = 256, MINLEN = 1) [ InitialExpression = "%OAuth2.Server.Validate", Required ];

/// GenerateTokenClass is the name of a class with the same signatures as OAuth2.Server.Generate which overrides
/// the GenerateToken method.  The GenerateToken method of OAuth2.Server.AccessToken generates
/// an opaque token consisting of a random number.  We will also supply an %OAuth2.Server.JWT
/// subclass of OAuth2.Server.AccessToken which will generate a signed JWT based on the token properties.
Property GenerateTokenClass As %String(MAXLEN = 256, MINLEN = 1) [ InitialExpression = "%OAuth2.Server.Generate", Required ];

/// ServerCredentials is the alias of the %SYS.X509Credentials object which contains the authoriization server's
/// certificate and private key.
Property ServerCredentials As %String;

/// ServerPassword is the password for the private key in ServerCredentials if the password is not in the %SYS.X5009Credentials object
Property ServerPassword As %String(MAXLEN = 128);

/// SigningAlgorithm specifies the signing algorithm used to create JWSs or "" if JWTs are not to be signed.
/// See %OAuth2.JWT for the list of supported algorithms.
Property SigningAlgorithm As %String(VALUELIST = ",RS256,RS384,RS512");

/// EncryptionAlgorithm specifies the encryption algorithm used to create JWEs or "" if JWTs are not to be encrypted.
/// See %OAuth2.JWT for the list of supported algorithms.
/// If EncryptionAlgorithm is specified, KeyAlgorithm must also be specified.
Property EncryptionAlgorithm As %String(VALUELIST = ",A128CBC-HS256,A192CBC-HS384,A256CBC-HS512");

/// KeyAlgorithm specifies the key management algorithm used to create JWEs or "" if JWTs are not to be encrypted.
/// See %OAuth2.JWT for the list of supported algorithms.
/// If KeyAlgorithm is specified, EncryptionAlgorithm must also be specified.
Property KeyAlgorithm As %String(VALUELIST = ",RSA1_5,RSA-OAEP");

/// The name of the activated TLS/SSL configuration to use loading a request object.<br>
/// Chosen by user during configuration.
Property SSLConfiguration As %String(MAXLEN = 64);

/// Get the issuer URL 
Method GetIssuerURL() As %String [ Internal ]
{
	Quit ..IssuerEndpoint.GetServerURL()_..GetCSPApplication(1)
}

/// Open the single OAuth2.Server.Configuration instance.
ClassMethod Open(Output sc As %Status) As OAuth2.Server.Configuration
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	
	Try {
		Set configuration=..%OpenId("singleton",,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$LoadObjectNotFound) {
			Set sc=$$$OK
			Set configuration=""
		}
		
		// Upgrade existing configuration as needed
		If $$$ISOK(sc),$isobject(configuration),configuration.ValidateUserClass="OAuth2.Server.Validate" {
			Set configuration.ValidateUserClass="%OAuth2.Server.Validate"
			Set sc=configuration.Save()
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set configuration=""		
	Quit configuration
}

/// Save the single OAuth2.Server.Configuration instance.
/// If this is the first time the configuration is saved, the Save method will
/// also create a CSP application for this authorization server.
/// The CSP application will be /csp/oauth2server.
Method Save() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	
	Try {
		Set sc=..CreateCSPApplication(1)

		// Upgrade existing configuration as needed
		If ..ValidateUserClass="OAuth2.Server.Validate" {
			Set ..ValidateUserClass="%OAuth2.Server.Validate"
		}

		// Save		
		If $$$ISOK(sc) Set sc=..%Save()
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
		
	Quit sc
}

/// Delete this configuration.
Method Delete() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Try {
		// Delete all he clients
		&sql(DELETE FROM OAuth2_Server.Client)

		// Now delete the configuration object
		Set sc=..%Delete(.."%%OID")
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	Quit sc
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
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal ]
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	Quit $$$OK
}

/// Get the CSP application name for OAuth2
ClassMethod GetCSPApplication(server As %Boolean) As %String [ Internal ]
{
	Quit $select(server:"/oauth2",1:"/csp/sys/oauth2")
}

/// Create CSP application that is used by OAuth2
ClassMethod CreateCSPApplication(server As %Boolean) As %Status [ Internal ]
{
	Set sc=$$$OK
	// Create the application if it does not already exist
	Set application=..GetCSPApplication(server)
	If '##class(Security.Applications).Exists(application) {
		Set Properties("AutheEnabled")=$$$AutheUnauthenticated
		Set Properties("AutoCompile")=0
		Set Properties("ChangePasswordPage")=""
		Set Properties("CookiePath")=application_"/"
		Set Properties("CSPZENEnabled")=1
		Set Properties("ErrorPage")=""
		Set Properties("EventClass")=""
		Set Properties("GroupById")=""
		Set Properties("HyperEvent")=0
		Set Properties("InbndWebServicesEnabled")=0
		Set Properties("IsNameSpaceDefault")=0
		Set Properties("LockCSPName")=1
		Set Properties("LoginPage")=""
		Set Properties("MatchRoles")=":%All"
		Set Properties("NameSpace")="%SYS"
		Set Properties("Package")=""
		Set Properties("Path")=""
		If server {
			Set Properties("Description")="OAuth 2.0 Authorization Server."
			Set Properties("DispatchClass")="OAuth2.Server.REST"
		} Else {
			Set Properties("Description")="Response URL for OAuth 2.0.  For internal usage only."
			Set Properties("PermittedClasses")="1(1""OAuth2.Response"",1""OAuth2.JWTServer"")"
		}
		Set Properties("Recurse")=1
		Set Properties("Resource")=""
		Set Properties("ServeFiles")=0
		Set Properties("ServeFilesTimeout")=3600
		Set Properties("SuperClass")=""
		Set Properties("Timeout")=900
		Set Properties("Type")=2
		Set Properties("UseCookies")=1
		Set sc=##class(Security.Applications).Create(application,.Properties)
	}
	
	Quit sc
}

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IssuerEndpoint</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>AccessTokenInterval</Value>
</Value>
<Value name="5">
<Value>AuthorizationCodeInterval</Value>
</Value>
<Value name="6">
<Value>SupportedScopes</Value>
</Value>
<Value name="7">
<Value>DefaultScope</Value>
</Value>
<Value name="8">
<Value>AllowUnsupportedScope</Value>
</Value>
<Value name="9">
<Value>SupportedGrantTypes</Value>
</Value>
<Value name="10">
<Value>ReturnRefreshToken</Value>
</Value>
<Value name="11">
<Value>CustomizationRoles</Value>
</Value>
<Value name="12">
<Value>AuthenticateClass</Value>
</Value>
<Value name="13">
<Value>ValidateUserClass</Value>
</Value>
<Value name="14">
<Value>GenerateTokenClass</Value>
</Value>
<Value name="15">
<Value>ServerCredentials</Value>
</Value>
<Value name="16">
<Value>CustomizationNamespace</Value>
</Value>
<Value name="17">
<Value>RefreshTokenInterval</Value>
</Value>
<Value name="18">
<Value>AudRequired</Value>
</Value>
<Value name="19">
<Value>SigningAlgorithm</Value>
</Value>
<Value name="20">
<Value>EncryptionAlgorithm</Value>
</Value>
<Value name="21">
<Value>KeyAlgorithm</Value>
</Value>
<Value name="22">
<Value>ServerPassword</Value>
</Value>
<Value name="23">
<Value>SessionInterval</Value>
</Value>
<Value name="24">
<Value>SupportSession</Value>
</Value>
<Value name="25">
<Value>SessionClass</Value>
</Value>
<Value name="26">
<Value>SSLConfiguration</Value>
</Value>
</Data>
<DataLocation>^OAuth2.Server.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<IdLocation>^OAuth2.Server.ConfigurationD</IdLocation>
<IndexLocation>^OAuth2.Server.ConfigurationI</IndexLocation>
<StreamLocation>^OAuth2.Server.ConfigurationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
