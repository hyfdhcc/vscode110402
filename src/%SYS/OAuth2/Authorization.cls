/// The %SYS.OAuth2.Authorization class contains the operations which are used to authorize
/// a client by obtaining an access token.<br><br>
/// 
/// The underlying token is stored in OAuth2.AccessToken in the CACHESYS database.
/// OAuth2.AccessToken is indexed by the combination of SessionId and ApplicationName.
/// Therefore, only one scope may be requested for each SessionId/ApplicationName.
/// If a second request is made with a different scope and access token has yet been granted,
/// the scope in the new request becomes the expected scope.<br>
/// Note that this class is in CACHELIB and thus available everywhere.
/// However, token storage storage is in CACHESYS and thus not difrectly available to most code.
Class %SYS.OAuth2.Authorization Extends %RegisteredObject [ System = 4 ]
{

/// SetEndpoints will update the authorization endpoint and the token endpoint for the
/// specified client application.  If either endpoint is not specified, then it will not be modified.
ClassMethod SetEndpoints(applicationName As %String, authorizationEndpoint As %String, tokenEndpoint As %String) As %Status
{
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:SetEndpoints]","applicationName="_applicationName_$select($data(authorizationEndpoint):", authorizationEndpoint="_authorizationEndpoint,1:"")_$select($data(tokenEndpoint):", tokenEndpoint="_tokenEndpoint,1:""))
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit
		
		If $data(authorizationEndpoint) {
			Set client.ServerDefinition.AuthorizationEndpoint=authorizationEndpoint
		}
		If $data(tokenEndpoint) {
			Set client.ServerDefinition.TokenEndpoint=tokenEndpoint
		}
		
		Set sc=client.%Save()
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Authorization:SetEndpoints]",0,sc)
	Quit sc
}

/// Create a new base64 encoded random nonce value.
ClassMethod CreateNonce() As %String [ Internal ]
{
	Quit ##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(20))
}

/// Create a new base64 encoded random state value.
ClassMethod CreateState() As %String [ Internal ]
{
	Quit ##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(20))
}

/// GetAuthorizationEndpoint returns the URL to be used to redirect authorization requests to the
/// Authorization Server based on the authorization code grant type.  The location part of the URL
/// will be a class in this Cache instance which will further redirect to the authorization server.
/// This URL should be used for a button, anchor or in Javascript code in a page.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.
/// The default for scope is the DefaultScope property of OAuth2.Client for applicationName.<br>
/// The redirectURL argument is the URL of the CSP page which should be invoked after the request
/// for the access token is completed and the access token is stored indexed by the ApplicationName and SessionId.<br>
/// The responseMode argument specifies the mode of the response as either query or fragment.
/// The default is query.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.  To add a request parameter which is a JSON object,
/// you may either create a properties element which is a %DynamicObject or is a string that is the
/// UTF-8 encoded serialized object.  For example the claims parameter that is defined by OpenID Connect.
/// If the request or request_uri request parameters are to be used, then the %SYS.OAuth2.Request class
/// is used to create  the JWT.  The the JWT is assigned to properties("request") or the URL for the
/// JWT is assigned to properties("request_uri")<br>
/// isAuthorized is an output argument which is returned true if an access token has already been 
/// granted for this SessionId/ApplicationName combiation.
ClassMethod GetAuthorizationCodeEndpoint(applicationName As %String, scope As %String, redirectURL As %String, ByRef properties As %String, Output isAuthorized As %Boolean, Output sc As %Status, responseMode As %String) As %String
{
	Quit ..GetRequestEndpoint(applicationName,.scope,$get(redirectURL),"code",$get(responseMode),.properties,.isAuthorized,.sc)
}

/// GetRequestEndpoint returns the URL to be used to redirect authorization requests to the
/// Authorization Server for the authorization code grant type or the implicit grant type.
/// The location part of the URL
/// will be a class in this Cache instance which will further redirect to the authorization server.
/// This URL should be used for a button, anchor or in Javascript code in a page.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.
/// The default for scope is the DefaultScope property of OAuth2.Client for applicationName.<br>
/// The idtokenOnly argument should be specified as true in order to get an IDToken but not an access token.<br>
/// The responseMode argument specifies the mode of the response as either query or fragment.<br>
/// The redirectURL argument is the URL of the CSP page which should be invoked after the request
/// for the access token is completed and the access token is stored indexed by the ApplicationName and SessionId.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.  To add a request parameter which is a JSON object,
/// you may either create a properties element which is a %DynamicObject or is a string that is the
/// UTF-8 encoded serialized object.  For example the claims parameter that is defined by OpenID Connect.
/// If the request or request_uri request parameters are to be used, then the %SYS.OAuth2.Request class
/// is used to create  the JWT.  The the JWT is assigned to properties("request") or the URL for the
/// JWT is assigned to properties("request_uri")<br>
/// isAuthorized is an output argument which is returned true if an access token has already been 
/// granted for this SessionId/ApplicationName combination.
ClassMethod GetRequestEndpoint(applicationName As %String, scope As %String, redirectURL As %String, responseType As %String, responseMode As %String = "", ByRef properties As %String, Output isAuthorized As %Boolean, Output sc As %Status) As %String [ Internal ]
{
	Set sc=$$$OK
	Set isAuthorized=0
	Set url=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetRequestEndpoint]","applicationName="_applicationName_", scope="_$get(scope)_", redirectURL="_redirectURL_", responseType="_responseType_", responseMode="_responseMode)

		Set sessionId=$select($isobject($get(%session)):%session.SessionId,1:"")
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetRequestEndpoint]","applicationName="_applicationName_", scope="_$get(scope)_", redirectURL="_$get(redirectURL)_", SessionId="_sessionId)
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit
		
		If redirectURL="" Set redirectURL=%request.URL
		If $data(scope)=0 Set scope=client.DefaultScope

		// Get random state for request
		Set state=..CreateState()

		// Use Response.cls as theredirect
		Set redirect=##class(OAuth2.Response).GetRedirectURL(client,.sc)
		If $$$ISERR(sc) Quit
		
		// Get existing or new token
		Set accessToken=##class(OAuth2.AccessToken).SAIndexOpen(sessionId,applicationName,4,.sc)
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetRequestEndpoint]","accessToken="_accessToken)
		If '$isobject(accessToken) {
			If $$$ISERR(sc),$$$GETERRORCODE(sc)'=$$$ERRORCODE($$$KeyValueNotFoundOpen) Quit
			// No access token object found, create one
			Set accessToken=##class(OAuth2.AccessToken).%New()
		} ElseIf accessToken.AccessToken'="" {
			// Access token has already been granted.  No need to change.
			Set isAuthorized=1
		}
		
		// Initialize the token
		Set accessToken.ResponseType=responseType
		Set accessToken.ApplicationName=applicationName
		Set accessToken.SessionId=sessionId
		Set accessToken.State=state
		Set accessToken.Scope=scope
		Set accessToken.RedirectURL=redirectURL
		Do accessToken.ClearError()
		
		// Add nonce if OpenID Connect request
		If accessToken.IsOpenID() {
			Set nonce=..CreateNonce()
		} Else {
			Set nonce=""
		}
		Set accessToken.Nonce=nonce

		// Set GrantType and response_mode		
		If responseType="code" {
			Set grantType="A"
		} ElseIf responseType="token" {
			Set grantType="I"
		} ElseIf responseType="id_token token" {
			If 'accessToken.IsOpenID() {
				Set sc=$$$ERROR($$$OAuth2RequestArgument,"response_type",responseType)
				Quit
			}
			Set grantType="I"
		} ElseIf responseType="id_token" {
			If 'accessToken.IsOpenID() {
				Set sc=$$$ERROR($$$OAuth2RequestArgument,"response_type",responseType)
				Quit
			}
			Set grantType="I"
		} Else {
				Set sc=$$$ERROR($$$OAuth2RequestArgument,"response_type",responseType)
			Quit
		}
		If $case(responseMode,"query":0,"fragment":0,:1) {
			If responseMode="" {
				Set responseMode=$select(grantType="A":"query",1:"fragment")
			} Else {
				Set sc=$$$ERROR($$$OAuth2RequestArgument,"response_mode",responseMode)
			}
		}
		Set accessToken.GrantType=grantType
		Set accessToken.ResponseMode=responseMode

		// Create the request URL
		Set url=..MakeAuthorizationCodeURL(client, accessToken, redirect,.properties,.sc)
		If $$$ISERR(sc) Quit
		
		// Save the token
		Set sc=accessToken.%Save()
		
		// Create Session Events subclass to cleanup access token
		If $$$ISOK(sc),sessionId'="" {
			Set sc=%session.EventClassAdd("OAuth2.SessionEvents","%SYS")
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetRequestEndpoint]","url="_url_", state="_$get(state)_", isAuthorized="_isAuthorized_", SessionId="_$get(sessionId))
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Authorization:GetRequestEndpoint]",0,sc)
	
	Quit url
}

/// Make the URL for authorization code request
ClassMethod MakeAuthorizationCodeURL(client As OAuth2.Client, token As OAuth2.AccessToken, redirect As %String, ByRef properties As %String, Output sc As %Status) As %String [ Internal ]
{
	Set sc=$$$OK
	Set url=client.ServerDefinition.AuthorizationEndpoint
	Set url=url_$select(url["?":"&",1:"?")_"response_type="_##class(%CSP.Page).EscapeURL(token.ResponseType)_
		"&client_id="_##class(%CSP.Page).EscapeURL(client.ClientId)_
		"&redirect_uri="_##class(%CSP.Page).EscapeURL(redirect)_
		"&scope="_##class(%CSP.Page).EscapeURL(token.Scope)_
		"&state="_##class(%CSP.Page).EscapeURL(token.State)
	If token.Nonce'="" {
		Set url=url_"&nonce="_##class(%CSP.Page).EscapeURL(token.Nonce)
	}
	If token.ResponseMode'=$select(token.GrantType="I":"fragment",1:"query") {
		set url=url_"&response_mode="_##class(%CSP.Page).EscapeURL(token.ResponseMode)
	}
	
	// Add user supplied properties
	Set name=""
	For {
		Set name=$order(properties(name),1,value)
		If name="" Quit
		
		// If aud is "" use client_id as default
		If name="aud",value="" Set value=client.ClientId
		// If object, then convert to JSON
		If $isobject(value) Set value=$zcvt(value.%ToJSON(),"O","UTF8")
		// URL escape the property value.
		Set url=url_"&"_name_"="_##class(%CSP.Page).EscapeURL(value)
	}
	
	If $extract(url,1,6)="http://" {
		Set $piece(url,"://",1)="s://"
	}
	Quit url
}

/// GetAccessTokenAuthorizationCode may be called from the OnPreHttp method of a CSP page to redirect
/// authorization requests to the Authorization Server based on the authorization code grant type.<br>
/// GetAccessTokenAuthorizationCode will only request a new access token if their is no existing
/// access toekn which includes all the scopes that are being requested.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.
/// The default for scope is the DefaultScope property of OAuth2.Client for applicationName.<br>
/// The redirectURL argument is the URL of the CSP page which should be invoked after the request
/// for the access token is completed and the access token is stored indexed by the ApplicationName and SessionId.
/// The responseMode argument specifies the mode of the response as either query or fragment.
/// The default is query.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.  To add a request parameter which is a JSON object,
/// you may either create a properties element which is a %DynamicObject or is a string that is the
/// UTF-8 encoded serialized object.  For example the claims parameter that is defined by OpenID Connect.
/// If the request or request_uri request parameters are to be used, then the %SYS.OAuth2.Request class
/// is used to create  the JWT.  The the JWT is assigned to properties("request") or the URL for the
/// JWT is assigned to properties("request_uri")<br>
ClassMethod GetAccessTokenAuthorizationCode(applicationName As %String, scope As %String, redirectURL As %String, ByRef properties As %String, responseMode As %String) As %Status
{
	Set sc=$$$OK
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenAuthorizationCode]","applicationName="_applicationName_", scope="_$get(scope)_", redirectURL="_$get(redirectURL))

		If '##class(%SYS.OAuth2.AccessToken).IsAuthorized(applicationName,,,,.error) {
			// Only get a new token if current one is not authorized
			Set url=..GetAuthorizationCodeEndpoint(applicationName,.scope,.redirectURL,.properties,.isAuthorized,.sc,.responseMode)
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenAuthorizationCode]","url="_url_", isAuthorized="_$get(isAuthorized))
			If $$$ISOK(sc) {
				Set %response.Redirect=url
			}
		} Else {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenAuthorizationCode]","Keep access token."_$select($isobject(error):" error: "_error.AsString(),1:""))
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Authorization:GetAccessTokenPassword]",0,sc)
	Quit sc
}

/// GetImplicitEndpoint returns the URL to be used to redirect authorization requests to the
/// Authorization Server based on the implicit grant type.  The location part of the URL
/// will be a class in this Cache instance which will further redirect to the authorization server.
/// This URL should be used for a button, anchor or in Javascript code in a page.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.
/// The default for scope is the DefaultScope property of OAuth2.Client for applicationName.<br>
/// The idtokenOnly argument should be specified as true in order to get an IDToken but not an access token.<br>
/// The responseMode argument specifies the mode of the response as either query or fragment.
/// The default is fragment.<br>
/// The redirectURL argument is the URL of the CSP page which should be invoked after the request
/// for the access token is completed and the access token is stored indexed by the ApplicationName and SessionId.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.  To add a request parameter which is a JSON object,
/// you may either create a properties element which is a %DynamicObject or is a string that is the
/// UTF-8 encoded serialized object.  For example the claims parameter that is defined by OpenID Connect.
/// If the request or request_uri request parameters are to be used, then the %SYS.OAuth2.Request class
/// is used to create  the JWT.  The the JWT is assigned to properties("request") or the URL for the
/// JWT is assigned to properties("request_uri")<br>
/// isAuthorized is an output argument which is returned true if an access token has already been 
/// granted for this SessionId/ApplicationName combination.
ClassMethod GetImplicitEndpoint(applicationName As %String, scope As %String, redirectURL As %String, idtokenOnly As %Boolean = 0, responseMode As %String, ByRef properties As %String, Output isAuthorized As %Boolean, Output sc As %Status) As %String
{
	If (" "_scope_" ")[" openid " {
		If idtokenOnly {
			Set responseType="id_token"
		} Else {
			Set responseType="id_token token"
		}
	} Else {
		Set responseType="token"
	}
	
	Quit ..GetRequestEndpoint(applicationName,.scope,$get(redirectURL),responseType,$get(responseMode),.properties,.isAuthorized,.sc)
}

/// GetAccessTokenImplicit may be called from the OnPreHttp method of a CSP page to redirect
/// authorization requests to the Authorization Server based on the implicit grant type.<br>
/// GetAccessTokenAuthorizationCode will only request a new access token if their is no existing
/// access token which includes all the scopes that are being requested.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.
/// The default for scope is the DefaultScope property of OAuth2.Client for applicationName.<br>
/// The idtokenOnly argument should be specified as true in order to get an IDToken but not an access token.<br>
/// The responseMode argument specifies the mode of the response as either query or fragment.
/// The default is fragment.<br>
/// The redirectURL argument is the URL of the CSP page which should be invoked after the request
/// for the access token is completed and the access token is stored indexed by the ApplicationName and SessionId.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.  To add a request parameter which is a JSON object,
/// you may either create a properties element which is a %DynamicObject or is a string that is the
/// UTF-8 encoded serialized object.  For example the claims parameter that is defined by OpenID Connect.
/// If the request or request_uri request parameters are to be used, then the %SYS.OAuth2.Request class
/// is used to create  the JWT.  The the JWT is assigned to properties("request") or the URL for the
/// JWT is assigned to properties("request_uri")<br>
ClassMethod GetAccessTokenImplicit(applicationName As %String, scope As %String, redirectURL As %String, idtokenOnly As %Boolean, responseMode As %String, ByRef properties As %String) As %Status
{
	Set sc=$$$OK
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenImplicit]","applicationName="_applicationName_", scope="_$get(scope)_", redirectURL="_$get(redirectURL))
		
		If '##class(%SYS.OAuth2.AccessToken).IsAuthorized(applicationName,,,,.error) {
			// Only get a new token if current one is not authorized
			Set url=..GetImplicitEndpoint(applicationName,.scope,.redirectURL,.idtokenOnly,.responseMode,.properties,.isAuthorized,.sc)
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenImplicit]","url="_url_", isAuthorized="_$get(isAuthorized))
			If $$$ISOK(sc) {
				Set %response.Redirect=url
			}
		} Else {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenImplicit]","Keep access token."_$select($isobject(error):" error: "_error.AsString(),1:""))
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Authorization:GetAccessTokenImplicit]",0,sc)
	Quit sc
}

/// GetAccessTokenPassword may be called from any method to send authorization requests to the
/// Authorization Server based on the resource owner password credentials grant type.
/// The access token will be stored indexed by the ApplicationName and SessionId before this method returns.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.<br>
ClassMethod GetAccessTokenPassword(applicationName As %String, username As %String, password As %String, scope As %String, ByRef properties As %String, Output error As %OAuth2.Error) As %Status
{
	Set sc=$$$OK
	Set error=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenPassword]","applicationName="_applicationName_", username="_username_", scope="_scope)
		Set httpRequest=##class(%Net.HttpRequest).%New()
		Set httpRequest.ContentType="application/x-www-form-urlencoded"
		Set sc=##class(%SYS.OAuth2.AccessToken).AddAuthentication(applicationName,httpRequest)
		If $$$ISERR(sc) Quit
		
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit
		If $data(scope)=0 Set scope=client.DefaultScope
		
		Do httpRequest.InsertFormData("grant_type","password")
		Do httpRequest.InsertFormData("username",username)
		Do httpRequest.InsertFormData("password",password)
		Do httpRequest.InsertFormData("scope",scope)
		Set name=""
		For {
			Set name=$order(properties(name),1,value)
			If name="" Quit
			If name="aud",value="" Set value=client.ClientId
			Do httpRequest.InsertFormData(name,value)
		}
		
		If $$$SysLogLevel>=3 {
			Set formData("grant_type")="password"
			Set formData("username")=username
			Set formData("password")=password
			Set formData("scope")=scope
			Set name=""
			For {
				Set name=$order(properties(name),1,value)
				If name="" Quit
				If name="aud",value="" Set value=client.ClientId
				Set formData(name)=value
			}
			Do ##class(%OAuth2.Utils).LogHTTPRequest("[%SYS.OAuth2.Authorization:GetAccessTokenPassword]",0,
				httpRequest,"POST",client.ServerDefinition.TokenEndpoint,.formData)
		}

		Set sc=httpRequest.Post(client.ServerDefinition.TokenEndpoint)
		
		If $$$ISOK(sc) {
			Set sc=##class(OAuth2.Response).ProcessResponse(httpRequest,applicationName,scope,,,"P",.error)
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Authorization:GetAccessTokenPassword]",0,sc)
	Quit sc
}

/// GetAccessTokenClient may be called from any method to send authorization requests to the
/// Authorization Server based on the resource owner client credentials grant type.
/// The access token will be stored indexed by the ApplicationName and SessionId before this method returns.<br>
/// The scope argument is a blank separated list of scopes for which access is requested.<br>
/// properties is a local array specifying additional properties to be included in a token request
/// in the form properties(name)=value.<br>
ClassMethod GetAccessTokenClient(applicationName As %String, scope As %String, ByRef properties As %String, Output error As %OAuth2.Error) As %Status
{
	Set sc=$$$OK
	Set error=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenClient]","applicationName="_applicationName_", scope="_scope)
		Set httpRequest=##class(%Net.HttpRequest).%New()
		Set httpRequest.ContentType="application/x-www-form-urlencoded"
		Set sc=##class(%SYS.OAuth2.AccessToken).AddAuthentication(applicationName,httpRequest)
		If $$$ISERR(sc) Quit
		
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit
		If $data(scope)=0 Set scope=client.DefaultScope
		
		Do httpRequest.InsertFormData("grant_type","client_credentials")
		Do httpRequest.InsertFormData("scope",scope)
		Set name=""
		For {
			Set name=$order(properties(name),1,value)
			If name="" Quit
			If name="aud",value="" Set value=client.ClientId
			Do httpRequest.InsertFormData(name,value)
		}
		
		If $$$SysLogLevel>=3 {
			Set formData("grant_type")="client_credentials"
			Set formData("scope")=scope
			Set name=""
			For {
				Set name=$order(properties(name),1,value)
				If name="" Quit
				If name="aud",value="" Set value=client.ClientId
				Set formData(name)=value
			}
			Do ##class(%OAuth2.Utils).LogHTTPRequest("[%SYS.OAuth2.Authorization:GetAccessTokenClient]",0,
				httpRequest,"POST",client.ServerDefinition.TokenEndpoint,.formData)
		}

		Set sc=httpRequest.Post(client.ServerDefinition.TokenEndpoint)
		
		If $$$ISOK(sc) {
			Set sc=##class(OAuth2.Response).ProcessResponse(httpRequest,applicationName,scope,,,"C",.error)
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Authorization:GetAccessTokenClient]",0,sc)
	Quit sc
}

/// GetAccessTokenRefresh sends a request to the
/// Authorization Server in order to get a new access token based on the refresh token.
/// The access token will be stored indexed by the ApplicationName and SessionId before this method returns.<br>
ClassMethod GetAccessTokenRefresh(accessToken As OAuth2.AccessToken, Output refreshed As %Boolean, Output error As %OAuth2.Error) As %Status [ Final ]
{
	Set sc=$$$OK
	Set error=""
	Set refreshed=0
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Authorization:GetAccessTokenRefresh]","applicationName="_accessToken.ApplicationName_", sessionId="_accessToken.SessionId_", hasRefreshToken="_(accessToken.RefreshToken'=""))
		// If no refresh token, then nothing to do
		If accessToken.RefreshToken="" Quit
				
		// Find the access token object
		// Get http request object and add authentication per RFC 6750
		Set httpRequest=##class(%Net.HttpRequest).%New()
		Set httpRequest.ContentType="application/x-www-form-urlencoded"
		Set sc=##class(%SYS.OAuth2.AccessToken).AddAuthentication(accessToken.ApplicationName,httpRequest)
		If $$$ISERR(sc) Quit
		
		Set client=##class(OAuth2.Client).Open(accessToken.ApplicationName,.sc)
		If client="" Quit
		
		Do httpRequest.InsertFormData("grant_type","refresh_token")
		Do httpRequest.InsertFormData("refresh_token",accessToken.RefreshToken)
		
		If $$$SysLogLevel>=3 {
			Set formData("grant_type")="refresh_token"
			Set formData("refresh_token")=accessToken.RefreshToken
			Do ##class(%OAuth2.Utils).LogHTTPRequest("[%SYS.OAuth2.Authorization:GetAccessTokenRefresh]",0,
				httpRequest,"POST",client.ServerDefinition.TokenEndpoint,.formData)
		}

		Set sc=httpRequest.Post(client.ServerDefinition.TokenEndpoint)
		
		If $$$ISOK(sc) {
			Set sc=##class(OAuth2.Response).ProcessResponse(httpRequest,accessToken.ApplicationName,accessToken.Scope,accessToken.SessionId,,,.error)
		}
		
		If $$$ISOK(sc) Set refreshed=1
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:GetAccessTokenRefresh]",0,sc)
	Quit sc
}

}
