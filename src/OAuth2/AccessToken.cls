/// OAuth2.AccessToken stores an OAuth 2.0 access token and its related information.<br>
/// OAuth2.AccessToken is indexed by the combination of SessionId and ApplicationName.
/// Therefore, only one scope may be requested for each SessionId/ApplicationName.
/// If a second request is made with a different scope and access token has yet been granted,
/// the scope in the new request becomes the expected scope.<br>
Class OAuth2.AccessToken Extends %Persistent [ System = 4 ]
{

/// An access token is linked to the combination of a session and client application
Index SAIndex On (SessionId, ApplicationName) [ Internal, Unique ];

/// The access token is indexed by hash of its value
Index ATIndex On Hash [ Internal, Unique ];

/// The IDToken is indexed by hash of its value
Index IDIndex On IDHash [ Internal, Unique ];

/// The access token is indexed by the State during Authorization Server requests
Index SIndex On State [ Internal, Unique ];

/// This access token is linked to the session whose id is here.
Property SessionId As %String(COLLATION = "EXACT") [ Required ];

/// This access token is linked to this client application.
Property ApplicationName As %String(COLLATION = "EXACT", MAXLEN = 64, MINLEN = 1) [ Required ];

/// The base64 encoded random state associated with request to Authorization Server.
Property State As %String(COLLATION = "EXACT", MAXLEN = 1024);

/// The access token 
Property AccessToken As %String(COLLATION = "EXACT", MAXLEN = 2048);

Method AccessTokenSet(accessToken As %String) As %Status [ Internal ]
{
	Set i%AccessToken=accessToken
	If accessToken="" {
		Set i%Hash=""
	} Else {
		Set i%Hash=$system.Encryption.SHAHash(512,accessToken)
	}
}

/// SHA512 hash of the AccessToken to be used for indexing
Property Hash As %String(COLLATION = "EXACT", MAXLEN = 64);

/// The IDToken 
Property IDToken As %String(COLLATION = "EXACT", MAXLEN = 2048);

Method IDTokenSet(IDToken As %String) As %Status [ Internal ]
{
	Set i%IDToken=IDToken
	If IDToken	="" {
		Set i%IDHash=""
	} Else {
		Set i%IDHash=$system.Encryption.SHAHash(512,IDToken)
	}
}

/// SHA512 hash of the IDToken to be used for indexing
Property IDHash As %String(COLLATION = "EXACT", MAXLEN = 64);

/// The token type that is returned from the authorization server.
Property TokenType As %String;

/// The time when the token expires in seconds since December 31st, 1840 (i.e. since beginning of $h)
Property Expires As %Integer;

/// Blank separated list of scope names which this token supports
Property Scope As %String(MAXLEN = 1024);

/// The refresh token that is returned by the authorization server or "".
Property RefreshToken As %String(MAXLEN = 1024);

/// The URL of the CSP page which will be invoked after the access token is obtained.
/// By default, this is the page that began the token request workflow.
Property RedirectURL As %String(MAXLEN = 1024) [ Internal ];

/// GrantType is the grant type that was used to create this access token:
/// - "A" - Authorization Code
/// - "I" - Implicit
/// - "P" - Resource Owner Password Credentials
/// - "C" - Client Credentials
Property GrantType As %String(VALUELIST = ",A,I,P,C");

/// Nonce for OpenID Connect request.  This nonce must be included in the IDToken.
Property Nonce As %String;

/// The response_type of the access token request
Property ResponseType As %String;

/// The response_mode of the access token request: query or fragment
Property ResponseMode As %String;

/// ResponseProperties contains the response properties from the access token request
/// where the key is the property name and the value is the property value.
Property ResponseProperties As array Of %String(MAXLEN = 2048);

/// Error object for error during authorization
Property Error As %OAuth2.Error;

/// Set the error.
Method SetError(error As %OAuth2.Error)
{
	Set ..Error.Error=error.Error
	Set ..Error.ErrorDescription=error.ErrorDescription
	Set ..Error.ErrorUri=error.ErrorUri
}

/// Clear the error.
Method ClearError()
{
	Set ..Error.Error=""
	Set ..Error.ErrorDescription=""
	Set ..Error.ErrorUri=""
}

/// Return if an error been set.
Method IsError() As %Boolean
{
	Quit (..Error.Error'="")
}

/// Check if this token is expired
Method IsExpired() As %Boolean
{
	Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
	Quit (now>..Expires)
}

/// Is this an OpenID authorization request?  Find out by looking for openid scope.
Method IsOpenID() As %Boolean [ CodeMode = expression ]
{
##class(OAuth2.Server.OpenID).IsOpenID(..Scope)
}

/// Open an OAuth2.AccessToken instance based on the session and client application that it is linked to.
ClassMethod OpenForSession(applicationName As %String, sessionId As %String, Output sc As %Status) As OAuth2.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set tokenObject=""
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		Set tokenObject=..SAIndexOpen(sessionId,applicationName,,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$KeyValueNotFoundOpen) {
			Set sc=$$$OK
			Set tokenObject=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set tokenObject=""		
	Quit tokenObject
}

/// Open an OAuth2.AccessToken instance based on the AccessToken property
ClassMethod Open(accessToken As %String, Output sc As %Status) As OAuth2.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	If accessToken="" Quit ""
	Set tokenObject=""
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		Set tokenObject=..ATIndexOpen($system.Encryption.SHAHash(512,accessToken),,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$KeyValueNotFoundOpen) {
			Set sc=$$$OK
			Set tokenObject=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set tokenObject=""		
	Quit tokenObject
}

/// Open an OAuth2.AccessToken instance based on the IDToken property
ClassMethod OpenByIDToken(IDToken As %String, Output sc As %Status) As OAuth2.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	If IDToken="" Quit ""
	Set tokenObject=""
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		Set tokenObject=..IDIndexOpen($system.Encryption.SHAHash(512,IDToken),,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$KeyValueNotFoundOpen) {
			Set sc=$$$OK
			Set tokenObject=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set tokenObject=""		
	Quit tokenObject
}

/// Remove this token from the client
Method Remove() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Try {
		$$$SysLog(3,"OAuth2Server","[OAuth2.AccessToken:Remove]","Delete for AccessToken="_..AccessToken)

		Set sc=..%Delete(.."%%OID")

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	Quit sc
}

/// Clean up all expired tokens
ClassMethod Cleanup() [ Internal ]
{
	Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)

	// Loop over expired token and delete them
	&sql(DECLARE TOKEN CURSOR FOR 
		SELECT ID, AccessToken INTO :id, :at FROM OAuth2.AccessToken
		WHERE RefreshToken IS NULL AND Expires IS NOT NULL AND Expires < :now)
	&sql(OPEN TOKEN)

	For {
		&sql(FETCH TOKEN)
		If SQLCODE'=0 Quit

		$$$SysLog(3,"OAuth2Server","[OAuth2.AccessToken:Cleanup]","Delete for AccessToken="_at)
		Do ..%DeleteId(id)
	}

	&sql(CLOSE TOKEN)
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

Storage Default
{
<Data name="AccessTokenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SessionId</Value>
</Value>
<Value name="3">
<Value>ApplicationName</Value>
</Value>
<Value name="4">
<Value>State</Value>
</Value>
<Value name="5">
<Value>AccessToken</Value>
</Value>
<Value name="6">
<Value>TokenType</Value>
</Value>
<Value name="7">
<Value>Expires</Value>
</Value>
<Value name="8">
<Value>Scope</Value>
</Value>
<Value name="9">
<Value>RefreshToken</Value>
</Value>
<Value name="10">
<Value>RedirectURL</Value>
</Value>
<Value name="11">
<Value>GrantType</Value>
</Value>
<Value name="12">
<Value>Error</Value>
</Value>
<Value name="13">
<Value>Hash</Value>
</Value>
<Value name="14">
<Value>Nonce</Value>
</Value>
<Value name="15">
<Value>IDToken</Value>
</Value>
<Value name="16">
<Value>IDHash</Value>
</Value>
<Value name="17">
<Value>ResponseType</Value>
</Value>
<Value name="18">
<Value>ResponseMode</Value>
</Value>
</Data>
<Data name="ResponseProperties">
<Attribute>ResponseProperties</Attribute>
<Structure>subnode</Structure>
<Subscript>"ResponseProperties"</Subscript>
</Data>
<DataLocation>^OAuth2.AccessTokenD</DataLocation>
<DefaultData>AccessTokenDefaultData</DefaultData>
<IdLocation>^OAuth2.AccessTokenD</IdLocation>
<IndexLocation>^OAuth2.AccessTokenI</IndexLocation>
<StreamLocation>^OAuth2.AccessTokenS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
