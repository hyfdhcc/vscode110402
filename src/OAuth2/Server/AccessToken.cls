/// Access tokens are managed by the persistent class OAuth2.Server.AccessToken.
/// OAuth2.Server.AccessToken stores the access token and related properties.
/// This class is also the means of communication between the various parts of the authorization server.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Server.AccessToken Extends %Persistent [ System = 4 ]
{

/// The IDKEY for the access token class.
Index AuthIndex On AuthorizationCode [ IdKey, Unique ];

/// The access token is indexed by it value
Index ATIndex On Hash [ Internal, Unique ];

/// The access token is indexed by the RefreshToken property
Index RIndex On RefreshToken [ Internal, Unique ];

/// Order by time
Index ExpiresIndex On AccessTokenExpires [ Internal ];

/// AuthorizationCode is a random number which serves as the IDKey for this class and
/// as the Authorization Code when required by the Authorization Code grant type.
/// We use AuthorizationCode as the IDKey because it comes into existence first in the process of creating an access token
Property AuthorizationCode As %String(COLLATION = "EXACT", MAXLEN = 128) [ Required ];

/// AccessToken is the access token as a string.  The default access token is a random string.
/// However, the access token is easily customized to have any structure required by the using
/// application - for example a signed JWT.
Property AccessToken As %String(COLLATION = "EXACT", MAXLEN = 2048);

Method AccessTokenSet(accessToken As %String) As %Status [ Internal ]
{
	Set i%AccessToken=accessToken
	Set i%Hash=$system.Encryption.SHAHash(512,accessToken)
}

/// SHA512 hash of the AccessToken to be used for indexing
Property Hash As %String(COLLATION = "EXACT", MAXLEN = 64);

/// AccessTokenExpires is the time in seconds from beginning of the Unix epoch when the access expires.
Property AccessTokenExpires As %Integer;

/// RefreshToken is the refresh token as a random string that is used to refresh the access token.
Property RefreshToken As %String(COLLATION = "EXACT", MAXLEN = 128);

/// RefreshTokenExpires is the time in seconds from beginning of the Unix epoch when
/// the refresh expires, or "" means does not expire.
Property RefreshTokenExpires As %Integer;

/// IDToken is the IDToken which is returned forf OpenID Connect requests
Property IDToken As %String(MAXLEN = 2048);

/// ClientId is the client id for the client for which this token was issued.
Property ClientId As %String(MAXLEN = 1024);

/// Scope is a blank separated list of scopes that were used to issue this token.
Property Scope As %String(MAXLEN = 1024);

/// An array of scopes and associated descriptions.  This matches the scopes in the Scope property.
Property ScopeArray As array Of %String(MAXLEN = 256);

/// Properties is a %OAuth2.Server.Properties object that holds the various kinds of properties
/// and claims that are used by the auhtorization server.
/// The various classes which are involved in the authorization and authentication code flow
/// use the properties argument (which is this token property) to communicate amongst
/// themselves and with the authorization server.<br>
/// See the definition of the %OAuth2.Server.Properties class for details about the propertyies and claims.
Property Properties As %OAuth2.Server.Properties;

/// AuthorizationCodeExpires is the time in seconds from the bginning of the Unix epoch when the
/// Authorization code passed to the client expires for the Authorization Code grant type.
Property AuthorizationCodeExpires As %Integer;

/// GrantType is the grant type that was used to create this access token:
/// - "A" - Authorization Code
/// - "I" - Implicit
/// - "P" - Resource Owner Password Credentials
/// - "C" - Client Credentials
Property GrantType As %String(VALUELIST = ",A,I,P,C");

/// Stage reflects the stage of the authentication process and is used for error checking.
/// Possible values of Stage: "new", "login:<n>", "permission", "".<br>
/// "" means process completed or not started.<br>
/// <n> in login:<n> is the integer count of which login attempt is taking place.
Property Stage As %String;

/// State to be returned to requester in redirected response
Property State As %String(MAXLEN = 1024);

/// aud property from request which will be checked when validating token.
Property Aud As list Of %String(MAXLEN = 1024);

/// Username is the username specified and validated by during authentication.
/// $char(0) means that authentication failed.
Property Username As %String;

/// The issuer of this access token.
Property Issuer As %String(MAXLEN = 1024);

/// The redirect used for the current token authorization
Property RedirectURL As %String(MAXLEN = 1024);

/// The time when the user was authenticated.
Property AuthTime As %Integer;

/// The response_type of the access token request
Property ResponseType As %String;

/// The response_mode of the access token request: query or fragment
Property ResponseMode As %String;

/// Get a new OAuth2.Server.AccessToken instance with a newly generated AuthorizationCode as IDKey.
Method %OnNew() As %Status [ Internal, Private ]
{
	Set ..AuthorizationCode=##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(64))
	Set ..Properties=##class(%OAuth2.Server.Properties).%New()
	Quit $$$OK
}

/// Is this an OpenID authorization request?  Find out by looking for openid scope.
Method IsOpenID() As %Boolean [ CodeMode = expression ]
{
##class(OAuth2.Server.OpenID).IsOpenID(..Scope)
}

/// Set the time when authenticated.
Method SetAuthTime(time As %Integer) [ Internal ]
{
	If $get(time)="" Set time=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
	
	Set ..AuthTime=time
	Do ..Properties.SetClaimValue("auth_time",time,"number")
}

/// Open the OAuth2.Server.AccessToken instance using AuthorizationCode.
ClassMethod OpenByCode(authorizationCode As %String, Output sc As %Status) As OAuth2.Server.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	
	Try {
		Set token=..%OpenId(authorizationCode,,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$LoadObjectNotFound) {
			Set sc=$$$OK
			Set token=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set token=""		
	Quit token
}

/// Open the OAuth2.Server.AccessToken instance using AccessToken.
ClassMethod OpenByToken(accessToken As %String, Output sc As %Status) As OAuth2.Server.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	If accessToken="" Quit ""
	
	Try {
		Do ..Cleanup()
		
		Set token=..ATIndexOpen($system.Encryption.SHAHash(512,accessToken),,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$KeyValueNotFoundOpen) {
			Set sc=$$$OK
			Set token=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set token=""		
	Quit token
}

/// Open the OAuth2.Server.AccessToken instance using IDToken.
ClassMethod OpenByIDToken(IDToken As %String, Output sc As %Status) As OAuth2.Server.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	If IDToken="" Quit ""
	
	Try {
		&sql(SELECT AuthorizationCode INTO :authorizationCode 
			FROM OAuth2_Server.AccessToken 
	    	WHERE IDToken = :IDToken)
	    
	    If SQLCODE=0 {
		    Set token=..OpenByCode(authorizationCode,.sc)
	    } Else {
		    Set token=""
	    }

	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set token=""		
	Quit token
}

/// Open the OAuth2.Server.AccessToken instance using RefreshToken
ClassMethod OpenByRefresh(refreshToken As %String, Output sc As %Status) As OAuth2.Server.AccessToken
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	
	Try {
		Do ..Cleanup()
		
		Set token=..RIndexOpen(refreshToken,,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$KeyValueNotFoundOpen) {
			Set sc=$$$OK
			Set token=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set token=""		
	Quit token
}

/// Clean up all expired tokens
ClassMethod Cleanup() [ Internal, Private ]
{
	Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)

	// Loop over expired tokens and delete them
	&sql(DECLARE TOKEN CURSOR FOR 
		SELECT ID, AccessToken INTO :id, :at FROM OAuth2_Server.AccessToken
		WHERE (RefreshToken IS NULL OR (RefreshTokenExpires < :now)) AND AccessTokenExpires IS NOT NULL AND AccessTokenExpires < :now)
	&sql(OPEN TOKEN)

	For {
		&sql(FETCH TOKEN)
		If SQLCODE'=0 Quit

		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.AccessToken:Cleanup]","Delete for AuthorizationCode="_id_", AccessToken="_at)
		Set token=..%OpenId(id,,.sc)
		If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.AccessToken:Cleanup]",1,sc)
		If $isobject(token) Do token.Delete()
	}

	&sql(CLOSE TOKEN)
}

/// Save this OAuth2.Server.AccessToken instance.
Method Save() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Try {
		Do ..Cleanup()
		
		Set sc=..%Save()

	} Catch ex {
		Set sc=ex.AsStatus()
	}
		
	Quit sc
}

/// Delete this access token
Method Delete() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Try {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.AccessToken:Delete]","Delete for AuthorizationCode="_..AuthorizationCode_", AccessToken="_..AccessToken)
		Set sc=##class(%OAuth2.Server.Properties).%Delete(..Properties."%%OID")
		If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.AccessToken:DeleteProperties]",1,sc)
		Set sc=..%Delete(.."%%OID")
		If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.AccessToken:Delete]",1,sc)

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

Storage Default
{
<Data name="AccessTokenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccessToken</Value>
</Value>
<Value name="3">
<Value>Hash</Value>
</Value>
<Value name="4">
<Value>AccessTokenExpires</Value>
</Value>
<Value name="5">
<Value>RefreshToken</Value>
</Value>
<Value name="6">
<Value>RefreshTokenExpires</Value>
</Value>
<Value name="7">
<Value>IDToken</Value>
</Value>
<Value name="8">
<Value>ClientId</Value>
</Value>
<Value name="9">
<Value>Scope</Value>
</Value>
<Value name="10">
<Value>ScopeArray</Value>
</Value>
<Value name="11">
<Value>Properties</Value>
</Value>
<Value name="12">
<Value>AuthorizationCodeExpires</Value>
</Value>
<Value name="13">
<Value>GrantType</Value>
</Value>
<Value name="14">
<Value>Stage</Value>
</Value>
<Value name="15">
<Value>State</Value>
</Value>
<Value name="16">
<Value>Aud</Value>
</Value>
<Value name="17">
<Value>Username</Value>
</Value>
<Value name="18">
<Value>Issuer</Value>
</Value>
<Value name="19">
<Value>RedirectURL</Value>
</Value>
<Value name="20">
<Value>AuthTime</Value>
</Value>
<Value name="21">
<Value>ResponseType</Value>
</Value>
<Value name="22">
<Value>ResponseMode</Value>
</Value>
</Data>
<DataLocation>^OAuth2.Server.AccessTokenD</DataLocation>
<DefaultData>AccessTokenDefaultData</DefaultData>
<IdLocation>^OAuth2.Server.AccessTokenD</IdLocation>
<IndexLocation>^OAuth2.Server.AccessTokenI</IndexLocation>
<StreamLocation>^OAuth2.Server.AccessTokenS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
