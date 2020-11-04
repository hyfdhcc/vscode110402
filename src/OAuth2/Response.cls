Include %occInclude

/// This is the landing page for responses from an OAuth 2.0 authorization server used from
/// Cache OAuth 2.0 client code.
/// The response is processed here and then redirected to the eventual target.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Response Extends %CSP.Page [ System = 4 ]
{

/// Should never get here.  The work is done in OnPreHttp and then redirect back to real target.
ClassMethod OnPage() As %Status [ Internal ]
{
	&html<
		<html>
	>

	If '$data(%OAuth2Error) {
		// If no error, then page is just being displayed in order to return fragment.
		&html<
			<head>
			<script language=javascript type="text/javascript">
				var hash = '?' + window.location.hash.substring(1);
				window.location.search = hash;
			</script>
			</head>
			<body>
			</body>
		>

	} Else {
		// If error, then display the error
		&html<
			<head>
			</head>
			<body bgcolor="#CCCCFF">
			<br>
			<font face="Verdana,Arial,Helvetica,sans-serif" color="#FF0000">
		>
		Write "<b>Authorization Server Error: Error Processing Response.</b><p>",!
		Write "<b>Error Description: ",..EscapeHTML($system.Status.GetErrorText(%OAuth2Error)),"</b><p>",!
		&html<
			</font>
			<br>
			</body>
		>
	}

	&html<
		</html>
	>
	Quit $$$OK
}

/// Event handler for <b>PreHTTP</b> event: this is invoked before
/// the HTTP headers for a CSP page have been sent.
ClassMethod OnPreHTTP() As %Boolean [ Internal ]
{
	Set sc=$$$OK
	Set serverError=""
	Set skipRedirect=0
	Set accessToken=""
	Kill %OAuth2Error
	
	Try {
		/// Log entry to this method
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogCSPRequest("[OAuth2.Response:OnPreHttp]",0)
		}

		// Test that request used SSL
		;; SSL SHOULD be used, but is not required.
		;;If '%request.Secure {
		;;	Set sc=$$$ERROR($$$OAuth2NotSSL)
		;;	Quit
		;;}
		
		// If no code, access_token, Id_token and no error, then must be implicit grant type response.
		// Continue on to main page to get parameters from fragment.
		If '$data(%request.Data("error")),'$data(%request.Data("code")),
		   '$data(%request.Data("access_token")),'$data(%request.Data("id_token")) {
			$$$SysLog(3,"OAuth2","[OAuth2.Response:OnPreHttp]","Fragment response mode")
			Set skipRedirect=1
			Quit
		}

		// Validate state - must be exactly one and match state from request.
		// The state is used to retrieve the access token information
		If $data(%request.Data("state",2)) {
			Set sc=$$$ERROR($$$OAuth2RedirectInvalid,"Multiple state parameters")
			Quit
		}
		Set state=$get(%request.Data("state",1))
		Set accessToken=##class(OAuth2.AccessToken).SIndexOpen(state,,.sc)
		If accessToken="" {
			If $$$ISOK(sc) || ($$$GETERRORCODE(sc)=$$$ERRORCODE($$$KeyValueNotFoundOpen)) {
				Set sc=$$$ERROR($$$OAuth2RedirectInvalid,"Unexpected state parameter: "_state)
			}
			Quit
		}

		Set error=$get(%request.Data("error",1))
		If error'="" {
			// handle error
			Set serverError=##class(%OAuth2.Error).%New(error,$get(%request.Data("error_description",1)),$get(%request.Data("error_uri",1)))
			$$$SysLog(3,"OAuth2","[OAuth2.Response:OnPreHTTP]","serverError="_serverError_", error="_error)
			Set sc=$$$ERROR($$$OAuth2ResponseError,serverError.AsString())
			Quit
		}
		
		If accessToken.GrantType="A" {
			Set sc=..ProcessCodeResponse(accessToken,.error)
			
		} ElseIf accessToken.GrantType="I" {
			Set sc=..ProcessImplicitResponse(accessToken,.error)

		} Else {
			Set sc=$$$ERROR($$$OAuth2RedirectInvalid,"Unexpected Grant Type: "_accessToken.GrantType)
			Quit
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If skipRedirect Quit 1
	
	If $$$ISOK(sc) {
		Set %response.Redirect=accessToken.RedirectURL
		$$$SysLog(3,"OAuth2","[OAuth2.Response:OnPreHttp] Redirect",%response.Redirect)

	} Else {
		Do ##class(%OAuth2.Utils).LogError("[OAuth2.Response:OnPreHttp]",0,sc)
		If '$isobject(accessToken) {
			Set %OAuth2Error=sc
		} Else {
			$$$SysLog(3,"OAuth2","[OAuth2.Response:OnPreHttp]","serverError="_serverError)
			If serverError="" {
				Set serverError=##class(%OAuth2.Error).%New("server_error",$system.Status.GetErrorText(sc))
			}
			Do accessToken.SetError(serverError)
			Set accessToken.AccessToken=""
			Set accessToken.IDToken=""
			Set scSave=accessToken.%Save()
			If $$$ISERR(scSave) {
				Set %OAuth2Error=sc
				Do ##class(%OAuth2.Utils).LogError("[OAuth2.Response:OnPreHttp:%Save]",0,sc)
			} Else {
				Set %response.Redirect=accessToken.RedirectURL
			}
		}
	}
	Quit 1
}

/// Process the response to the Authorization Code grant type
ClassMethod ProcessCodeResponse(accessToken As OAuth2.AccessToken, Output error As %OAuth2.Error) As %Status [ Final, Internal ]
{
	Try {
		$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessCodeResponse]","accessToken="_accessToken)

		If $data(%request.Data("code")) {
			// Authorization Code type response. Get the single code.
			If $data(%request.Data("code",2)) {
				Set sc=$$$ERROR($$$OAuth2RedirectInvalid,"Multiple code parameters")
				Quit
			}
			Set code=$get(%request.Data("code",1))
			
			// Request the access token
			Set applicationName=accessToken.ApplicationName
			Set httpRequest=##class(%Net.HttpRequest).%New()
			Set httpRequest.ContentType="application/x-www-form-urlencoded"
			Set sc=##class(%SYS.OAuth2.AccessToken).AddAuthentication(applicationName,httpRequest)
			If $$$ISERR(sc) Quit
			
			Set client=##class(OAuth2.Client).Open(applicationName,.sc)
			If client="" Quit
			
			Do httpRequest.InsertFormData("grant_type","authorization_code")
			Do httpRequest.InsertFormData("code",code)
			Do httpRequest.InsertFormData("redirect_uri",##class(OAuth2.Response).GetRedirectURL(client,.sc))
			
			If $$$SysLogLevel>=3 {
				Set formData("grant_type")="authorization_code"
				Set formData("code")=code
				Set formData("redirect_uri")=##class(OAuth2.Response).GetRedirectURL(client,.sc)
				Do ##class(%OAuth2.Utils).LogHTTPRequest("[OAuth2.Response:OnPreHttp]",0,
					httpRequest,"POST",client.ServerDefinition.TokenEndpoint,.formData)
			}
			Set sc=httpRequest.Post(client.ServerDefinition.TokenEndpoint)
			
			If $$$ISOK(sc) {
				Set sc=..ProcessResponse(httpRequest,applicationName,accessToken.Scope,accessToken.SessionId,1,,.error)
			}
		
		} Else {
			Set sc=$$$ERROR($$$OAuth2RedirectInvalid,"Unexpected response type")
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	Quit sc
}

/// Extract and store access token from response to access token request.
/// Access token will be stored before return.
/// If the accessToken argument is specified, then this token will be updated.
/// Otherwise a new token will be created.<br>
/// httpRequest may be a string which already contains the needed properties as query parameters
ClassMethod ProcessResponse(httpRequest As %Net.HttpRequest, applicationName As %String, requestScope As %String, sessionId As %String, inRedirect As %Boolean = 0, grantType As %String = "", Output error As %OAuth2.Error) As %Status [ Final, Internal ]
{
	Try {
		Set error=""
		$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessResponse]","")
		
		// Get the response object in case of successful response
		Set sc=..GetJSONResponse(httpRequest,.json,.error)
		
		If $$$ISOK(sc) {
			Set sc=..ProcessParsedResponse(json,applicationName,requestScope,.sessionId,inRedirect,grantType)
		}
		
		If $$$ISERR(sc) {
			If error="" {
				Set error=##class(%OAuth2.Error).%New("server_error",$system.Status.GetErrorText(sc))
			}
			If 'inRedirect {
				Do ##class(%OAuth2.Utils).GetDefaultSessionId(.sessionId)
				Set accessToken=##class(OAuth2.AccessToken).OpenForSession(applicationName,sessionId,.sc1)
				If $$$ISOK(sc1),$isobject(accessToken) {
					Do accessToken.SetError(error)
					Set accessToken.AccessToken=""
					Set accessToken.IDToken=""
					Set sc1=accessToken.%Save()
				}
			}
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Response:ProcessResponse]",0,sc)
	Quit sc
}

/// Process response from implicit grant type request.  This method exists to allow processing
/// the response on the client instead of completely in the user agent.
/// Extract and store access token from response to access token request.
/// Access token will be stored before return.
ClassMethod ProcessImplicitResponse(accessToken As OAuth2.AccessToken, Output error As %OAuth2.Error) As %Status [ Final, Internal ]
{
	Set sc=$$$OK
	Set error=""
	
	Try {
		/// Log entry to this method
		$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessImplicitResponse]","accessToken="_accessToken)

		// Test that request used SSL
		If '%request.Secure {
			Set sc=$$$ERROR($$$OAuth2NotSSL)
			Quit
		}
		
		// Get the query parameters
		Set sc=..GetQueryResponse(.params)
		If $$$ISERR(sc) Quit
		
		// Get the access token
		Set sc=..ProcessParsedResponse(params,accessToken.ApplicationName,accessToken.Scope,accessToken.SessionId,1)
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	Quit sc
}

/// Extract and store access token from access token request as JSON object.
/// Access token will be stored before return.
/// If the accessToken argument is specified, then this token will be updated.
/// Otherwise a new token will be created.
ClassMethod ProcessParsedResponse(json As %DynamicObject, applicationName As %String, requestScope As %String, sessionId As %String, clearState As %Boolean = 0, grantType As %String = "") As %Status [ Final, Internal ]
{
	Try {
		Set token=""
		Do ##class(%OAuth2.Utils).GetDefaultSessionId(.sessionId)

		$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","applicationName="_applicationName_", requestScope="_requestScope_", sessionId="_sessionId_", clearState="_clearState_", grantType="_grantType)
		
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogJSON("[OAuth2.Response:ProcessParsedResponse]",0,"json",json)
		}
		
		// Determine scope
		Set scope=##class(%OAuth2.Utils).NormalizeScope(json.scope)
		If scope="" Set scope=requestScope
		// Saved alphabetized, normalized scopes
		For i=1:1:$length(scope," ") {
			Set scopes($piece(scope," ",i))=""
		}
		Set s="",scope=""
		For {
			Set s=$order(scopes(s))
			If s="" Quit
			Set scope=scope_s_" "
		}
		Set scope=$extract(scope,1,*-1)
		
		// Note if OpenID Connect call
		Set openid=##class(OAuth2.Server.OpenID).IsOpenID(scope)

		// Look for existing token to replace
		Set token=##class(OAuth2.AccessToken).OpenForSession(applicationName,sessionId,.sc)
		If $$$ISERR(sc) Quit

		If grantType'="" {
			// OpenID Connect is not supported for password and client credentials
			If openid {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","OpenID Connect is not supported for password and client credentials grant type")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"OpenID Connect is not supported for password and client credentials grant type")
				Quit
			}
		} Else {
			// For all other flows, then token must exist
			If $isobject('token) {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","Token object not found for authorization code or implicit flow")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"Token object not found for authorization code or implicit flow")
				Quit
			}
		}
		
			// Create a new access token if no existing one.
		If '$isobject(token) {
			Set token=##class(OAuth2.AccessToken).%New()
			Set token.SessionId=sessionId
			Set token.ApplicationName=applicationName
			$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","New AccessToken")
		} Else {
			Do token.ResponseProperties.Clear()
			$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","Existing AccessToken="_token.AccessToken_", State="_token.State)
		}
		
		// Check access token
		If json."access_token"'="" {
			// If an access token is returned token_type must be bearer.
			If $zcvt(json."token_type","L")'="bearer" {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","token_type must be bearer if access_token returned")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"token_type must be bearer if access_token returned")
				Quit
			}
			// An access token may not be returned for OpenID Connect Implicit flow with response_type=id_token
			If openid,token.ResponseType="id_token" {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","access_token may not be returned for response_type=id_token")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"access_token may not be returned for response_type=id_token")
				Quit
			}
		} Else {
			// An access token must be returned unless implicit flow with response_type=id_token
			If 'openid || (token.ResponseType'="id_token") {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","access_token must be returned excpt for response_type=id_token")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"access_token must be returned except for response_type=id_token")
				Quit
			}
		}
		
		// Check IDToken
		If json."id_token"'="" {
			// An IDToken may not be returned unless OpenID Connect
			If 'openid {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","IDToken may not be returned unless OpenID Connect")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"IDToken may not be returned unless OpenID Connect")
				Quit
			}
		} Else {
			// An access token must be returned unless implicit flow with response_type=id_token
			If openid {
				$$$SysLog(3,"OAuth2","[OAuth2.Response:ProcessParsedResponse]","IDToken must be returned if OpenID Connect")
				Set sc=$$$ERROR($$$OAuth2ResponseUnsupported,"IDToken must be returned if OpenID Connect")
				Quit
			}
		}
		
		// Process the response if not an error response
		// Validate response body and save access token
		If grantType'="" Set token.GrantType=grantType
		Do token.ClearError()
		Set token.AccessToken=json."access_token"
		Set token.IDToken=json."id_token"
		Set token.TokenType="bearer"
		Set token.RefreshToken=json."refresh_token"
		Set token.Scope=scope

		// Save expiration time in seconds since start of $h
		Set expiresIn=json."expires_in"
		If +expiresIn=expiresIn,expiresIn>0 {
			Set expiresAt=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,expiresIn)
		} Else {
			Set sc=$$$ERROR($$$OAuth2ResponseInvalidExpires,expiresIn)
			Quit
		}
		Set token.Expires=expiresAt
		// Clear State when authorization code response received.
		If clearState Set token.State=""
		
		// Save the response properties
		Set iterator=json.%GetIterator()
		While iterator.%GetNext(.name,.value) {
			Do token.ResponseProperties.SetAt(value,name)
		}

		// Save access token
		Set sc=token.%Save()
				
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	// Cleanup expired access tokens
	Do ##class(OAuth2.AccessToken).Cleanup()

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Response:ProcessParsedResponse]",0,sc)
	Quit sc
}

/// Get the response object
ClassMethod GetJSONResponse(httpRequest As %Net.HttpRequest, Output json As %DynamicObject, Output error As %OAuth2.Error) As %Status [ Final, Internal ]
{
	Try {
		Set sc=$$$OK
		Set error=""
		$$$SysLog(3,"OAuth2","[OAuth2.Response:GetJSONResponse]","")
		Set httpResponse=httpRequest.HttpResponse
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogHTTPResponse("[OAuth2.Response:GetJSONResponse]",0,httpRequest)
		}

		// Response must be JSON
		Set contentType=httpResponse.ContentType
		If $zconvert($zstrip($piece(contentType,";"),">W"),"l")'="application/json" {
			Set sc=$$$ERROR($$$OAuth2ResponseContentType,contentType)
			Quit
		}

		// Get response as string
		If $isobject(httpResponse.Data) {
			Do httpResponse.Data.Rewind()
			If httpResponse.Data.Size>32000 {
				Set sc=$$$ERROR($$$OAuth2ResponseBody,"body is too large. length="_httpResponse.Data.Size)
			}
			Set body=httpResponse.Data.Read(32000)
		} Else {
			Set body=httpResponse.Data
		}

		// Convert to local charset based on Content-Type charset
		Set charset=$piece($translate($zconvert(contentType,"l"),$char(32,9)),"charset=",2)
		Set charset=$zstrip($piece(charset,";"),"<>W","""")
		If charset'="" {
			Set table=$$MapCharset^%SYS.NLS(charset)
		} Else {
			Set table="UTF8"
		}
		Set body=$zconvert(body,"I",table)
		$$$SysLog(3,"OAuth2","[OAuth2.Response:GetJSONResponse]","StatusCode="_httpRequest.HttpResponse.StatusCode_", contentType="_contentType_", charset="_charset_", body="_body)
		
		// Handle success and error cases
		Set statusCode=httpRequest.HttpResponse.StatusCode
		If $case(statusCode,200:1,400:1,500:1,:0) {
			// Parse JSON string into an object
			Set json=##class(%DynamicAbstractObject).%FromJSON(body)
		
			If json.error'="" {
				// handle error
				Set error=##class(%OAuth2.Error).%New(json.error,json."error_description",json."error_uri")
				Set sc=$$$ERROR($$$OAuth2ResponseError,error.AsString())
			} ElseIf statusCode'=200 {
				Set errorText="status="_httpRequest.HttpResponse.StatusCode_", body="_body
				Set sc=$$$ERROR($$$OAuth2ResponseBody,"Unexpected response: "_errorText)
			}
		} Else {
			Set errorText="status="_httpRequest.HttpResponse.StatusCode_", body="_body
			Set sc=$$$ERROR($$$OAuth2ResponseBody,"Unexpected response: "_errorText)
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Response:GetJSONResponse]",0,sc)
	Quit sc
}

/// Get the response object from query parameters
ClassMethod GetQueryResponse(Output json As %DynamicObject) As %Status [ Final, Internal ]
{
	Try {
		Set sc=$$$OK
		$$$SysLog(3,"OAuth2","[OAuth2.Response:GetQueryResponse]","")
		
		// Place query parameters into a JSON object
		Set json=##class(%DynamicObject).%New()
		Set name=""
		For {
			Set name=$order(%request.Data(name))
			If name="" Quit
			If $data(%request.Data(name,2)) {
				Set sc=$$$ERROR($$$OAuth2Multiple)
				Quit
			}
			Set value=%request.Data(name,1)
			Set $property(json,name)=value
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Response:GetQueryResponse]",0,sc)
	Quit sc
}

/// Get the URL without location to be used for redirect URL for authorization server requests.<br>
/// Setup /isc/oauth2 CSP application if it does not already exists.
ClassMethod GetRedirectURL(client As OAuth2.Client, Output sc As %Status) As %String [ Internal ]
{
	Set sc=$$$OK
	// URL to be returned
	Set url=client.RedirectionEndpoint.GetServerURL()_##class(OAuth2.Server.Configuration).GetCSPApplication(0)_"/OAuth2.Response.cls"
	
	Set sc=##class(OAuth2.Server.Configuration).CreateCSPApplication(0)
	
	Quit $select($$$ISOK(sc):url,1:"")
}

}
