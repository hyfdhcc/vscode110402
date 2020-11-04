/// The class OAuth2.Server.Token implements the token endpoint, as specified
/// in RFC 6749, for the Authorization Code, Password Credentials and Client Credentials grant types,
/// and for refreshing the access token.<br>
/// This class also serves as the endpoint for token management requests from the resource server and client.<br>
/// All requests to this endpoint are of Content-Type "application/x-www-form-urlencoded".
/// The requests from a confidential client must be authenticated using basic authentication
/// with the client id and client secret as specified in RFC 6749.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Server.Token Extends %RegisteredObject [ System = 4 ]
{

Parameter HTTP200OK As %String = "200 OK";

Parameter HTTP400BADREQUEST As %String = "400 Bad Request";

Parameter HTTP401UNAUTHORIZED As %String = "401 Unauthorized";

Parameter HTTP500INTERNALSERVERERROR As %String = "500 Internal Server Error";

/// Event handler for <b>PreHTTP</b> event: this is invoked before
/// the HTTP headers for a CSP page have been sent.  All changes to the
/// <class>%CSP.Response</class> class, such as adding cookies, HTTP headers,
/// setting the content type etc. must be made from within the OnPreHTTP() method.
/// Return <b>0</b> to prevent <method>OnPage</method> from being called.<br><br>
/// OnPreHttp is used to control flow and redirect back to the requester.
/// OnPage is where the actual authentication takes place.
ClassMethod Process() As %Status [ Internal, ServerOnly = 1 ]
{
	Try {
		Kill %OAuthResponse
		Set error=""
		If $$$SysLogLevel>=3 {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Process]","")
			Do ##class(%OAuth2.Utils).LogCSPRequest("[OAuth2.Server.Token:Process]",1)
		}
		
		// Setup response
		Set %response.ContentType="application/json"
		Set %response.CharSet="utf-8"
		Do %response.SetHeader("Cache-Control","no-store")
		Do %response.SetHeader("Pragma","no-cache")
		Set %response.Status=..#HTTP200OK

		// Server must be configured
		Set %server=##class(OAuth2.Server.Configuration).Open(.sc)
		If $$$ISERR(sc) {
			Set error=..StatusError(sc)
			Quit
		}
		If '$isobject(%server) {
			Set error=##class(%OAuth2.Error).%New("invalid_request","Server not configured")
			Quit
		}
		
		// Handle grant types
		Set grantType=$get(%request.Data("grant_type",1))
		If grantType="authorization_code" {
			Set error=..ProcessAuthorizationCode()

		} ElseIf grantType="password" {
			Set error=..ProcessPassword()

		} ElseIf grantType="client_credentials" {
			Set error=..ProcessClientCredentials()

		} ElseIf grantType="refresh_token" {
			Set error=..ProcessRefreshToken()

		} ElseIf grantType="get_certificate" {
			Set error=..ProcessGetCertificate()

		} Else {
			Set error=##class(%OAuth2.Error).%New("invalid_request","Unknown grant_type")
		}

	} Catch ex {
		Set sc=ex.AsStatus()
		Set error=..StatusError(sc)
	}
	
	If error'="" {
		Do ..ReturnError(error)
	}

	// Output the token
	If $isobject($get(%OAuthResponse)) {
		Set sc=##class(%OAuth2.Utils).ObjectToJSON(%OAuthResponse)
		If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Token:Process]",1,sc)

	} Else {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Process]","Internal error -- missing %OAuthResponse")
	}

	Quit $$$OK
}

/// Process authorization_code grant type token request
ClassMethod ProcessAuthorizationCode() As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:ProcessAuthorizationCode]","")
	// Process authorization
	Set error=..Authorize(0,.client)
	If error'="" Quit error
	
	// Client_id must be specified
	If '$isobject(client) {
		Quit ##class(%OAuth2.Error).%New("invalid_client")
	}
	
	// Check for duplicates
	Set error=..CheckDuplicate("grant_type,code,redirect_uri")
	If error'="" Quit error
	
	// Make sure client can support authorization code grant type
	If client.SupportedGrantTypes'["A" {
		Quit ##class(%OAuth2.Error).%New("unauthorized_client")
	}
	If %server.SupportedGrantTypes'["A" {
		Quit ##class(%OAuth2.Error).%New("unsupported_grant_type")
	}
	
	// Make sure this is the correct redirect uri
	If '$data(%request.Data("redirect_uri",1),redirect) {
		Quit ##class(%OAuth2.Error).%New("invalid_request","redirect_uri is required")
	}
	
	// Find the token
	If '$data(%request.Data("code",1),code) {
		Quit ##class(%OAuth2.Error).%New("invalid_request","authorization_code is required")
	}
	Set token=##class(OAuth2.Server.AccessToken).OpenByCode(code,.sc)
	If $$$ISERR(sc) Quit ..StatusError(sc)
	If '$isobject(token) {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Token not found")
	}

	// redirect uri in this request must match that of original authorization request	
	If redirect'=token.RedirectURL {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Unexpected redirect_uri")
	}

	// Make sure authorization code has not been previously used and is not expired
	If token.AuthorizationCodeExpires=0 {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Authorization Code has previously been used")
	}
	If ##class(%OAuth2.Utils).TimeInSeconds($ztimestamp)>token.AuthorizationCodeExpires {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Authorization Code has expired")
	}

	// Validate that specified client issued code
	If token.ClientId'=client.ClientId {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Client did not issue this authorization code")
	}

	// Generate a new access token
	Set sc=##class(OAuth2.Server.Auth).GenerateAccessToken(token)
	If $$$ISERR(sc) Quit ..StatusError(sc)

	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogServerToken("ProcessPassword",token)
	}

	// Now save and return the token
	Quit ..ReturnToken(client,token)
}

/// Process password credentials grant type token request
ClassMethod ProcessPassword() As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:ProcessPassword]","")
	// Process authorization
	Set error=..Authorize(0,.client)
	If error'="" Quit error
	
	// Check for duplicates
	Set error=..CheckDuplicate("grant_type,username,password,scope,aud")
	If error'="" Quit error
	
	// Make sure client can support password grant type
	If client.SupportedGrantTypes'["P" {
		Quit ##class(%OAuth2.Error).%New("unauthorized_client")
	}
	If %server.SupportedGrantTypes'["P" {
		Quit ##class(%OAuth2.Error).%New("unsupported_grant_type")
	}
	
	// Get a new access token object
	Set token=##class(OAuth2.Server.AccessToken).%New()
		
	// Initialize the access token object
	Set token.Stage=""
	Set token.GrantType="P"
	Set token.Issuer=%server.GetIssuerURL()

	// Scope must be specified or defaulted
	Set scope=$get(%request.Data("scope",1))
	Set error=##class(OAuth2.Server.Auth).ProcessScope(%server,client,.scope)
	If error'="" Quit error
	Do ##class(OAuth2.Server.Auth).SetScope(token,scope)
	Set token.AuthorizationCodeExpires=0

	// Remember if client authentication	
	If $isobject(client) {
		Set token.ClientId=client.ClientId
		Do ..GenerateRefreshToken(client,token)
	}

	// Get aud from request to use in validating token.
	Set aud=$get(%request.Data("aud",1))
	If aud="",%server.AudRequired {
		Quit ##class(%OAuth2.Error).%New("invalid_request","No aud was specified")
	}
	If aud="",$isobject(client) Set aud=client.ClientId
	If aud'="" Do token.Aud.Insert(aud)

	// Validate username/password and generate token
	If '$data(%request.Data("username",1),username) || '$data(%request.Data("password",1),password) {
		Quit ##class(%OAuth2.Error).%New("invalid_request","username and password must be specified")
	}
	If username'="" {
		Set sc=$$$OK
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:ProcessPassword]","username="_username)
		Set token.Username=username
		If password'="",##class(OAuth2.Server.Auth).ValidateUser(token,username,password,.sc) {
			// Generate access token
			Set sc=##class(OAuth2.Server.Auth).GenerateAccessToken(token)
			If $$$ISERR(sc) Quit ..StatusError(sc)

		} Else {
			If $$$ISERR(sc) Quit ..StatusError(sc)
			Quit ##class(%OAuth2.Error).%New("access_denied")
		}

	} Else {
		Quit ##class(%OAuth2.Error).%New("invalid_request","username must not be blank")
	}
	
	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogServerToken("ProcessPassword",token)
	}

	// Now save and return the token
	Quit ..ReturnToken(client,token)
}

/// Process client credentials grant type token request
ClassMethod ProcessClientCredentials() As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:ProcessProcessClientCredentials]","")
	// Process authorization.  Require client_id and client_secret
	Set error=..Authorize(1,.client)
	If error'="" Quit error
	
	// Client_id must be specified
	If '$isobject(client) {
		Quit ##class(%OAuth2.Error).%New("invalid_client")
	}
	
	// Check for duplicates
	Set error=..CheckDuplicate("grant_type,scope")
	If error'="" Quit error
	
	// Make sure client can support password grant type
	If client.SupportedGrantTypes'["C" {
		Quit ##class(%OAuth2.Error).%New("unauthorized_client")
	}
	If %server.SupportedGrantTypes'["C" {
		Quit ##class(%OAuth2.Error).%New("unsupported_grant_type")
	}
	
	// Get a new access token object
	Set token=##class(OAuth2.Server.AccessToken).%New()
		
	// Initialize the access token object
	Set token.Stage=""
	Set token.GrantType="C"
	Set token.Issuer=%server.GetIssuerURL()
	Set token.ClientId=client.ClientId

	// Scope must be specified or defaulted
	Set scope=$get(%request.Data("scope",1))
	Set error=##class(OAuth2.Server.Auth).ProcessScope(%server,client,.scope)
	If error'="" Quit error
	Do ##class(OAuth2.Server.Auth).SetScope(token,scope)

	Set token.AuthorizationCodeExpires=0
	
	// Get aud from request to use in validating token.
	Set aud=$get(%request.Data("aud",1))
	If aud="",%server.AudRequired {
		Quit ##class(%OAuth2.Error).%New("invalid_request","No aud was specified")
	}
	If aud="" Set aud=client.ClientId
	Do token.Aud.Insert(aud)

	If ##class(OAuth2.Server.Auth).ValidateClient(token,client.ClientId,client.ClientSecret,.sc) {
		// Generate access token
		Set sc=##class(OAuth2.Server.Auth).GenerateAccessToken(token)
		If $$$ISERR(sc) Quit ..StatusError(sc)

	} Else {
		If $$$ISERR(sc) Quit ..StatusError(sc)
		Quit ##class(%OAuth2.Error).%New("access_denied")
	}

	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogServerToken("ProcessClientCredentials",token)
	}

	// Now save and return the token
	Quit ..ReturnToken(client,token)
}

/// Process a request for a new access token based on the refresh token
ClassMethod ProcessRefreshToken() As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:ProcessRefreshToken]","")
	// Process authorization.  Require client_id and client_secret
	Set error=..Authorize(1,.client)
	If error'="" Quit error
	
	// Client_id must be specified
	If '$isobject(client) {
		Quit ##class(%OAuth2.Error).%New("invalid_client")
	}
	
	// Check for duplicates
	Set error=..CheckDuplicate("grant_type,refresh_token,scope")
	If error'="" Quit error
	
	// Find the token
	If '$data(%request.Data("refresh_token",1),refreshToken) {
		Quit ##class(%OAuth2.Error).%New("invalid_request","refresh_token is required")
	}
	Set token=##class(OAuth2.Server.AccessToken).OpenByRefresh(refreshToken,.sc)
	If $$$ISERR(sc) Quit ..StatusError(sc)
	If '$isobject(token) {
		Quit ##class(%OAuth2.Error).%New("invalid_request","Token not found")
	}
	
	// Validate specified issued code
	If token.ClientId'=client.ClientId {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Client did not issue this refresh token")
	}

	// Validate that the refresh token has not expired
	Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
	If token.RefreshTokenExpires'="",token.RefreshTokenExpires<now {
		Quit ##class(%OAuth2.Error).%New("invalid_grant","Refresh token has expired")
	}

	// If scope not specified, then just keep current scope
	Set scope=##class(%OAuth2.Utils).NormalizeScope($get(%request.Data("scope",1)))
	If scope'="" {
		Set error=##class(%OAuth2.Utils).CheckScope(token.Scope,scope)
		If error'="" Quit error
		Do ##class(OAuth2.Server.Auth).SetScope(token,scope)
	}

	Set token.AuthorizationCodeExpires=0
	Do token.Properties.RemoveClaimValue("exp")

	// Generate a new refresh token	
	Set token.RefreshToken=..MakeRefreshToken()

	// Generate a new access token
	Set sc=##class(OAuth2.Server.Auth).GenerateAccessToken(token)
	If $$$ISERR(sc) Quit ..StatusError(sc)
	
	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogServerToken("ProcessRefreshToken",token)
	}

	// Now save and return the token
	Quit ..ReturnToken(client,token)
}

ClassMethod ProcessGetCertificate() As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:GetCertificate]","")
	// Process authorization
	Set error=..Authorize(0,.client)
	If error'="" Quit error
	
	// Client_id must be specified
	If '$isobject(client) {
		Quit ##class(%OAuth2.Error).%New("invalid_client")
	}
	
	// Check for duplicates
	Set error=..CheckDuplicate("grant_type")
	If error'="" Quit error
	
	// Find the server certificate
	Set cert=""
	If %server.ServerCredentials'="" {
		Set credentials=##class(%SYS.X509Credentials).GetByAlias(%server.ServerCredentials)
		If $isobject(credentials),credentials.Certificate'="",credentials.PrivateKey'="" {
			Set cert="-----BEGIN CERTIFICATE-----"_$c(13,10)
			Set cert=cert_$system.Encryption.Base64Encode(credentials.Certificate)
			Set cert=cert_$c(13,10)_"-----END CERTIFICATE-----"
		}
	}
	If cert="" {
		Quit ##class(%OAuth2.Error).%New("invalid_request","No certificate configured")
	}

	// Create the proxy object for the token
	Set %OAuthResponse=##class(%DynamicObject).%New()
	Set %OAuthResponse.certificate=cert

	Quit ""
}

/// Return the access token
ClassMethod ReturnToken(client As OAuth2.Server.Client, token As OAuth2.Server.AccessToken) As %OAuth2.Error [ Internal ]
{
	Set error=""
	
	// Create the proxy object for the token
	Set json=##class(%DynamicObject).%New()
	If token.AccessToken'="" {
		Set json."access_token"=token.AccessToken
		Set json."token_type"="bearer"
	}
	If token.IDToken'="" {
		Set json."id_token"=token.IDToken
	}
	Set json."expires_in"=%server.AccessTokenInterval
	If token.RefreshToken'="" {
		Set json."refresh_token"=token.RefreshToken
	}
	Set json.scope=token.Scope
	// Add the customized response properties
	Set key=""
	For {
		Set value=token.Properties.ResponseProperties.GetNext(.key)
		If key="" Quit
		Set $property(json,key)=value
	}
	
	// Remember token to output in OnPage method
	Set %OAuthResponse=json

	// Mark authorization code as having been used.
	Set token.AuthorizationCodeExpires=0

	// Set expires property if it is not already set
	If token.Properties.GetClaimValue("exp")="" {
		Do token.Properties.SetClaimValue("exp",token.AccessTokenExpires,"number")
	}

	// Save token
	Set token.Stage=""
	Set sc=token.Save()
	
	If $$$ISERR(sc) Set error=..StatusError(sc)
	Quit error
}

/// Generate an refresh token if needed
ClassMethod GenerateRefreshToken(client As OAuth2.Server.Client, token As OAuth2.Server.AccessToken) [ Internal ]
{
	#dim %server As OAuth2.Server.Configuration
	Set offlineAccess=((" "_token.Scope_" ")[" offline_access ")
	If (offlineAccess && (token.IsOpenID() || (%server.ReturnRefreshToken["f"))) ||
	   (%server.ReturnRefreshToken["a") ||
	   ((%server.ReturnRefreshToken["c") && (client.ClientType="confidential")) {
			Set token.RefreshToken=..MakeRefreshToken()
			Set token.RefreshTokenExpires=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,%server.RefreshTokenInterval)
	} Else {
		Set token.RefreshToken=""
	}
}

/// Just make a random refresh token
ClassMethod MakeRefreshToken() [ Internal ]
{
	Quit ##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(32))
}

/// Return error response
ClassMethod ReturnError(error As %OAuth2.Error) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:ReturnError]","error="_error.Error_", error_description="_error.ErrorDescription)
	
	// Set status code
	If %response.Status=..#HTTP200OK {
		Set %response.Status=..#HTTP400BADREQUEST
	}

	// Create the proxy object for the error
	Set json=##class(%DynamicObject).%New()
	Set json.error=error.Error
	If error.ErrorDescription'="" {
		Set json."error_description"=error.ErrorDescription
	}

	// Remember error to output in OnPage method
	Set %OAuthResponse=json
}

/// Check the client credentials for a request
ClassMethod Authorize(secretRequired As %Boolean, Output client As OAuth2.Server.Client, requireTLS As %Boolean = 1) As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","secretRequired="_secretRequired)
	Set client=""
	
	// Request must use TLS/SSL.
	If requireTLS,'%request.Secure {
		Quit ##class(%OAuth2.Error).%New("invalid_request","Request must be secured with TLS/SSL")
	}
	
	// Make sure form encoded body
	If %request.ContentType'="application/x-www-form-urlencoded" {
		Quit ##class(%OAuth2.Error).%New("invalid_request","Request must have form encoded body")
	}
	
	// No duplicate client_id or client_secret
	Set error=..CheckDuplicate("client_id,client_secret")
	If error'="" Quit error
	
	// Process Authorize header if it exists
	If $data(%request.CgiEnvs("HTTP_AUTHORIZATION"),httpauth),$zconvert($piece(httpauth," "),"l")="basic" {
		// Make sure no client_secret in body
		If $data(%request.Data("client_secret",1)) {
			Quit ##class(%OAuth2.Error).%New("invalid_request","Unexpected client_secret")
		}
		
		// Check Authorization header
		Set httpauth=$system.Encryption.Base64Decode($piece(httpauth," ",2))
		Set clientId=##class(%CSP.Page).UnescapeURL($piece(httpauth,":",1))
		Set clientSecret=##class(%CSP.Page).UnescapeURL($piece(httpauth,":",2))
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","header ClientId="_clientId_$select(clientSecret'="":", ClientSecret=*****",1:""))

		Set client=##class(OAuth2.Server.Client).Open(clientId,.sc)
		If $$$ISERR(sc) Quit ..StatusError(sc)
	
		// Check basic authorization	
		If '$isobject(client) || (clientSecret'=client.ClientSecret) {
			// Basic Authorization failed with header,  Need to respond with 401
			Set %response.Status=..#HTTP401UNAUTHORIZED
			Do %response.SetHeader("WWW-Authenticate","Basic")
			If '$isobject(client) {
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","Client not found")
			} Else {
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","ClientSecret does not match")
			}
			Quit ##class(%OAuth2.Error).%New("invalid_client")
		}
		// Correct authorization header found if we get here
	
	// Authorization in form encoded body
	} ElseIf $data(%request.Data("client_id",1),clientId) {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","body ClientId="_clientId)
		Set client=##class(OAuth2.Server.Client).Open(clientId,.sc)
		If $$$ISERR(sc) Quit ..StatusError(sc)
		
		// Check form body Authorization.
		If '$isobject(client) {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","Client not found")
			Quit ##class(%OAuth2.Error).%New("invalid_client")
		}

		// If client_secret is present it must match
		If $data(%request.Data("client_secret",1),clientSecret) {
			If clientSecret'=client.ClientSecret {
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","ClientSecret does not match")
				Quit ##class(%OAuth2.Error).%New("invalid_client")
			}
		} ElseIf (client.ClientType'="public") || secretRequired {
			// if public client or client_secret not required, not including the secret is OK
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","ClientSecret required unless public client")
			Quit ##class(%OAuth2.Error).%New("invalid_client")
		}

	// No client id specified. Return client="" and no error
	} Else {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:Authorize]","No Client_id specified")
	}
	
	Quit ""
}

/// Check for duplicate query parameters
ClassMethod CheckDuplicate(parameters As %String) As %OAuth2.Error [ Internal ]
{
	Set error=""
	For i=1:1:$length(parameters,",") {
		Set param=$piece(parameters,",",i)
		If $data(%request.Data($piece(parameters,",",i),2)) {
			Set error=##class(%OAuth2.Error).%New("invalid_request","Multiple response_type parameters")
			Quit
		}
	}
	Quit error
}

/// Return an internal server error
ClassMethod StatusError(sc As %Status) As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:StatusError]",$system.Status.GetErrorText(sc))
	Set %response.Status=..#HTTP500INTERNALSERVERERROR
	Quit ##class(%OAuth2.Error).%New("server_error")
}

}
