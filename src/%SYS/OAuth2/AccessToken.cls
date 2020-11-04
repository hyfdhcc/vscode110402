/// The %SYS.OAuth2.AccessToken class defines the client operations which allow an access token
/// to be used to authorize to a resource server.<br><br>
/// 
/// The underlying token is stored in OAuth2.AccessToken in the CACHESYS database.
/// OAuth2.AccessToken is indexed by the combination of SessionId and ApplicationName.
/// Therefore, only one scope may be requested for each SessionId/ApplicationName.
/// If a second request is made with a different scope and access token has yet been granted,
/// the scope in the new request becomes the expected scope.<br>
/// Note that this class is in CACHELIB and thus available everywhere.
/// However, token storage storage is in CACHESYS and thus not difrectly available to most code.
Class %SYS.OAuth2.AccessToken Extends %RegisteredObject [ System = 4 ]
{

/// AddAccessToken adds the bearer access token associated with applicationName and sessionId
/// to the resource server request as defined by RFC 6750.
/// The sslConfiguration that is specified for the client is added to the httpRequest object.
/// This method is used to prepare requests from the Client to the Resource Server.
/// The type argument specifies one of three ways defined by RFC 6750 to send the access token to the Resource Server:<br>
/// 	"header" to use Bearer token HTTP header.<br>
/// 	"body" to use form encoded body.  In this case, request must be a POST with form encoded body.<br>
/// 	"query" to use a query parameter.<br>
/// The sslConfiguration is the name of the Security.SSLConfigs object to use for this request.
/// The default for sslConfiguration comes from the OAuth2.Client instance.
ClassMethod AddAccessToken(httpRequest As %Net.HttpRequest, type As %String = "header", sslConfiguration As %String, applicationName As %String, sessionId As %String) As %Status
{
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		Do ##class(%OAuth2.Utils).GetDefaultSessionId(.sessionId)

		If '..GetAccessToken(applicationName,sessionId,,.accessToken) {
			Set sc=$$$ERROR($$$OAuth2NoAccessToken)
			Quit
		}
		
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAccessToken]","applicationName="_applicationName_", sessionId="_sessionId)

		Set sc=..AuthorizeWithAccessToken(httpRequest,type,.sslConfiguration,applicationName,accessToken)
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:AddAccessToken]",0,sc)
	Quit sc
}

/// AuthorizeWithAccessToken adds the bearer access token which is passed as an argument to this method
/// to the resource server request as defined by RFC 6750.
/// The sslConfiguration that is specified for the client is added to the httpRequest object.
/// This method is used to prepare requests from the Client to the Resource Server.
/// The type argument specifies one of three ways defined by RFC 6750 to send the access token to the Resource Server:<br>
/// 	"header" to use Bearer token HTTP header.<br>
/// 	"body" to use form encoded body.  In this case, request must be a POST with form encoded body.<br>
/// 	"query" to use a query parameter.<br>
/// The sslConfiguration is the name of the Security.SSLConfigs object to use for this request.
/// The default for sslConfiguration comes from the OAuth2.Client instance.
ClassMethod AuthorizeWithAccessToken(httpRequest As %Net.HttpRequest, type As %String = "header", sslConfiguration As %String, applicationName As %String, accessToken As %String) As %Status
{
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AuthorizeWithAccessToken]","accessToken="_accessToken_", type="_type_", sslConfiguration="_$get(sslConfiguration))

		// Add access token for authorization
		If type="header" {
			Do httpRequest.SetHeader("Authorization","Bearer "_accessToken)
		} ElseIf type="body" {
			Do httpRequest.DeleteFormData("access_token")
			Do httpRequest.InsertFormData("access_token",accessToken)
		} ElseIf type="query" {
			Do httpRequest.DeleteParam("access_token")
			Do httpRequest.InsertParam("access_token",accessToken)
			Do httpRequest.SetHeader("Cache-Control","no-store")
			Do httpRequest.SetHeader("Pragma","no-cache")
		} Else {
			Set sc=$$$ERROR($$$OAuth2InvalidTokenType,type)
			Quit
		}
		
		// Request must use SSL
		If $get(sslConfiguration)="" {
			// Find application client
			Set client=##class(OAuth2.Client).Open(applicationName,.sc)
			If client="" Quit
			Set sslConfiguration=client.SSLConfiguration
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAccessToken]","Client sslConfiguration="_sslConfiguration)
		}
		If sslConfiguration="" {
			Set sc=$$$ERROR($$$OAuth2NoSSLConfig)
			Quit
		}
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=sslConfiguration
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:AddAccessToken]",0,sc)
	Quit sc
}

/// GetAccessTokenFromRequest returns the access token which is found in the HTTP request
/// using one of the three RFC 6750 formats (See AddAccessToken above).
/// The access token should be validated using a Validate method or a user written Validate method.
/// This method is used by the Resource Server to authorize requests from the Client.
ClassMethod GetAccessTokenFromRequest(Output sc As %Status) As %String
{
	Set sc=$$$OK
	Set accessToken=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		If $$$SysLogLevel>=3 {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:GetAccessTokenFromRequest]","")
			Do ##class(%OAuth2.Utils).LogCSPRequest("[%SYS.OAuth2.AccessToken:GetAccessTokenFromRequest]",0)
		}
		// Test that request used SSL
		If '%request.Secure {
			Set sc=$$$ERROR($$$OAuth2NotSSL)
			Quit
		}
		
		// Look for Bearer header
		Set authorizationHeader=%request.GetCgiEnv("HTTP_AUTHORIZATION")
		If $zcvt($piece(authorizationHeader," ",1),"U")="BEARER" {
			Try {
				If $length(authorizationHeader," ")=2 {
					Set accessToken=$piece(authorizationHeader," ",2)
				}
			} Catch {
			}
			If accessToken="" {
				Set sc=$$$ERROR($$$OAuth2InvalidBearerHeader)
			}
			Quit
		}
		
		// Look for form encoded body or query parameter
		Set accessToken=$get(%request.Data("access_token",1))
		If $data(%request.Data("access_token",2)) {
			Set sc=$$$ERROR($$$OAuth2DuplicateToken)
		}

		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) {
		Set accessToken=""
		Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:GetAccessTokenFromRequest]",0,sc)
	}
	Quit accessToken
}

/// AddAuthication adds the required authentication for the token request
/// and the SSLConfiguration that is specified for the client.
/// See AuthenticationType property of OAuth2.Client.
/// This method is used for sending HTTP requests to the Authorization Server.
ClassMethod AddAuthentication(applicationName As %String, httpRequest As %Net.HttpRequest) As %Status
{
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAuthentication]","applicationName="_applicationName)
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit
		
		// Add client identity for authentication
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAuthentication]","AuthenticationType="_client.AuthenticationType_", ClientId="_client.ClientId_", ClientType="_client.ClientType)
		If (client.ClientType="public") || ((client.ClientType="resource") && (client.ClientSecret="")) {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAuthentication] public client","")
			Do httpRequest.DeleteFormData("client_id")
			Do httpRequest.InsertFormData("client_id",client.ClientId)
		} ElseIf client.AuthenticationType="basic" {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAuthentication] basic","")
			Set httpRequest.Authorization="Basic "_$system.Encryption.Base64Encode(
				##class(%CSP.Page).EscapeURL(client.ClientId)_":"_
				##class(%CSP.Page).EscapeURL(client.ClientSecret),1)
		} ElseIf client.AuthenticationType="body" {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:AddAuthentication] body","")
			Do httpRequest.DeleteFormData("client_id")
			Do httpRequest.InsertFormData("client_id",client.ClientId)
			Do httpRequest.DeleteFormData("client_secret")
			Do httpRequest.InsertFormData("client_secret",client.ClientSecret)
		}
		
		// Request must use SSL
		If client.SSLConfiguration="" {
			Set sc=$$$ERROR($$$OAuth2NoSSLConfig)
			Quit
		}
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=client.SSLConfiguration
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:AddAuthentication]",0,sc)
	Quit sc
}

/// IsAuthorized returns true if the applicationName and sessionId combination has an access token which
/// authorizes all the scopes that are specified by the scope argument.<br>
/// applicationName is the name of the application that is being authorized.<br>
/// sessionId is the session id.  sessionId defaults to %session.SessionId and will usually not be specified.<br>
/// scope is a blank separated list of scopes.<br>
/// responseProperties will be returned as a local array specifying the properties that were included
/// in the token response in the form properties(name)=value.<br>
/// The access token is returned in the accessToken argument.
ClassMethod IsAuthorized(applicationName As %String, sessionId As %String, scope As %String = "", Output accessToken As %String, Output IDToken As %String, Output responseProperties, Output error As %OAuth2.Error) As %Boolean
{
	Set error=""
	Set (accessToken,IDToken)=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"

	Try {
		Do ##class(%OAuth2.Utils).GetDefaultSessionId(.sessionId)

		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:IsAuthorized]","applicationName="_applicationName_", SessionId="_sessionId_", scope="_scope)

		// Get access token
		// If there is an access token, then check the scope
		If ..GetAccessToken(applicationName,sessionId,.tokenScope,.accessToken,.IDToken,.responseProperties,.error) {
			If tokenScope'="" {
				For i=1:1:$length(tokenScope," ") {
					Set scopeArray($piece(tokenScope," ",i))=""
				}
			}
			Set matched=1
			Set scope=##class(%OAuth2.Utils).NormalizeScope(scope)
			If scope'="" {
				For i=1:1:$length(scope," ") {
					If '$data(scopeArray($piece(scope," ",i))) {
						Set matched=0
						Quit
					}
				}
			}
	$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:IsAuthorized]","matched="_matched)
			// Don't return access token if scopes are not all authorized for token
			If 'matched Set (accessToken,IDToken)=""
		}

	} Catch ex {
		Set sc=ex.AsStatus()
		// use client_error for local errors -- this should be rare.
		Set error=##class(%OAuth2.Error).%New("client_error",$system.Status.GetErrorText(sc))
	}

	$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:IsAuthorized]","AccessToken="_accessToken_", IDToken="_IDToken)
	If $isobject(error) $$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:IsAuthorized]","error="_error.AsString())
	Quit ((accessToken'="") || (IDToken'=""))
}

/// GetAccessToken is an internal method to get (a possibly refreshed access token)
/// for the applicationName and SessionId combination.<br>
/// responseProperties will be returned as a local array specifying the properties that were included
/// in the token response in the form properties(name)=value.<br>
ClassMethod GetAccessToken(applicationName As %String, sessionId As %String, Output scope As %String, Output accessToken As %String, Output IDToken As %String, Output responseProperties, Output error As %OAuth2.Error) As %Boolean [ Internal ]
{
	Set error=""
	Set sc=$$$OK
	Set found=0
	kill responseProperties
	Set accessToken=""
	Set IDToken=""
	Set scope=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"

	Try {
		Do ##class(%OAuth2.Utils).GetDefaultSessionId(.sessionId)

		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:GetAccessToken]","applicationName="_applicationName_", SessionId="_sessionId)

		// Get access token object
		Set token=##class(OAuth2.AccessToken).OpenForSession(applicationName,sessionId,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$LoadObjectNotFound) Set sc=$$$OK
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:GetAccessToken]","token="_token_", error="_$system.Status.GetErrorText(sc))
		If '$isobject(token) Quit
		
		// If access token expires, then refresh
		If $isobject(token),token.AccessToken'="",token.IsExpired() {
			$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:GetAccessToken]","Expired Token="_token.AccessToken)
			Set sc=##class(%SYS.OAuth2.Authorization).GetAccessTokenRefresh(token,.refreshed)
			If 'refreshed {
				Quit
			}
		}
		
		// If there is a token, then get the access token, IDToken, scope and responseProperties
		If $isobject(token) {
			Set found=1
			Set accessToken=token.AccessToken
			Set IDToken=token.IDToken
			Set scope=token.Scope
			Set name=""
			For {
				Set value=token.ResponseProperties.GetNext(.name)
				If name="" Quit
				Set responseProperties(name)=value
			}
			If token.IsError() {
				Set error=token.Error.%ConstructClone()
			}
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}

	$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:GetAccessToken]","AccessToken="_accessToken)
	
	If $$$ISERR(sc) {
		Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:GetAccessToken]",0,sc)
		// use client_error for local errors -- this should be rare.
		Set error=##class(%OAuth2.Error).%New("client_error",$system.Status.GetErrorText(sc))
	}
	
	If $isobject(error) Set found=0
	
	Quit found
}

/// Remove the token associated with the specified application and session from the client
ClassMethod RemoveAccessToken(applicationName As %String, sessionId As %String) As %Status
{
	Set sc=$$$OK
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"

	Try {
		Do ##class(%OAuth2.Utils).GetDefaultSessionId(.sessionId)

		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.AccessToken:RemoveAccessToken]","applicationName="_applicationName_", SessionId="_sessionId)
		Set token=##class(OAuth2.AccessToken).OpenForSession(applicationName,sessionId,.sc)
		If $isobject(token) Set sc=token.Remove()
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.AccessToken:RemoveAccessToken]",0,sc)
	Quit sc
}

/// Retrieve the JSON object that is returned from the userinfo endpoint forthee specified access token.
/// The request is authorized using the specified access token.
/// If the userinfo endpoint returns a JWT, then the object is optionally decrypted and the signature checked.<br>
/// If IDTokenObject is passed as the object returned by ##class(%SYS.OAuth2.Validation).ValidateIDToken and
/// is used to check the sub property.<br>
/// The claims returned by the userinfo endpoint are returned as the properties of jsonObject.<br>
/// securityParameters is returned as a local array of Strings that was used to set the JSON Object Signature and/or Encryption operations to be performed on the JWT<br>
/// <br>
/// For JSON Web Signature (JWS):<br>
/// securityParameters("sigalg") - Signature or MAC algorithm<br>
/// <br>
/// For JSON Web Encryption (JWE):<br>
/// securityParameters("keyalg") - Key management algorithm<br>
/// securityParameters("encalg") - Content encryption algorithm<br>
/// See %OAuth2.JWT for the list of supported algorithms.
ClassMethod GetUserinfo(applicationName As %String, accessToken As %String, IDTokenObject As %RegisteredObject, Output jsonObject As %RegisteredObject, Output securityParameters As %String) As %Status
{
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Set err=""
	Set sc=$$$OK
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Validation:GetUserinfo]","applicationName="_applicationName_"accessToken="_accessToken_", scope="_$get(scope)_", aud="_$get(aud))
		
		// Get httpRequest object and add accessToken for authorization
		Set httpRequest=##class(%Net.HttpRequest).%New()
		Set sc=..AuthorizeWithAccessToken(httpRequest,,,applicationName,accessToken)

		// Find the client
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit

		If client.ServerDefinition.UserinfoEndpoint="" {
			Set sc=$$$ERROR($$$OAuth2NoEndpoint,"Userinfo")
			Quit
		}
		
		// Send request to userinfo endpoint		
		Set sc=httpRequest.Get(client.ServerDefinition.UserinfoEndpoint)
		If $$$ISERR(sc) Quit

		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogHTTPResponse("[%SYS.OAuth2.Validation:GetUserinfo]",0,httpRequest)
		}
		
		Set httpResponse=httpRequest.HttpResponse
		Set statusCode=httpResponse.StatusCode
		If statusCode'=200 {
			Set wwwAuthenticate=httpResponse.GetHeader("WWW-Authenticate")
			If wwwAuthenticate'="" {
				Set err="Userinfo authorization error.  Status code="_statusCode_", WWW-Authenticate: "_wwwAuthenticate
			} Else {
				Set err="Unexpected status code="_statusCode
			}
			Quit
		}

		// Get response as string
		If $isobject(httpResponse.Data) {
			Do httpResponse.Data.Rewind()
			If httpResponse.Data.Size>32000 {
				Set err="Body is too large. length="_httpResponse.Data.Size
			}
			Set body=httpResponse.Data.Read(32000)
		} Else {
			Set body=httpResponse.Data
		}

		// Convert to local charset based on Content-Type charset
		Set contentType=$zconvert($zstrip($piece(httpResponse.ContentType,";"),">W"),"l")
		Set charset=$piece($translate($zconvert(contentType,"l"),$char(32,9)),"charset=",2)
		Set charset=$zstrip($piece(charset,";"),"<>W","""")
		If charset'="" {
			Set table=$$MapCharset^%SYS.NLS(charset)
		} Else {
			Set table="UTF8"
		}
		Set body=$zconvert(body,"I",table)
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Validation:GetUserinfo]","StatusCode="_statusCode_", contentType="_contentType_", charset="_charset_", body="_body)
		
		// Response must be JSON or JWT
		If contentType="application/json" {
			// Parse JSON response
			Set jsonObject=##class(%DynamicAbstractObject).%FromJSON(body)

		} ElseIf contentType="application/jwt" {
			// JWT response.
			// Convert JWT to an object		
			Set sc=##class(%SYS.OAuth2.Validation).JWTToObject(client,body,.securityParameters,.jsonObject)
			If $$$ISERR(sc) Quit

		} Else {
			Set err="Unexpected content-type: "_contentType
			Quit
		}
		
		// Body must have contain a JSON object or JWT
		If '$isobject(jsonObject) {
			Set err="Empty json object in body"
			Quit
		}
		
		// If the IDTokenObject was specified, then verify that sub from userinfo matches sub from IDToken.
		If $isobject($get(IDTokenObject)) {
			If IDTokenObject.sub="" {
				Set err="sub claim was be present in IDToken"
				Quit
			}
			If jsonObject.sub="" {
				Set err="sub claim was be present in userinfo response"
				Quit
			}
			If IDTokenObject.sub'=jsonObject.sub {
				Set err="sub claim in userinfo response ("_jsonObject.sub_") must match sub claim in IDToken ("_IDTokenObject.sub_")"				Quit
			}
		}

		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISOK(sc),err'="" {
		Set sc=$$$ERROR($$$OAuth2UserinfoNotValid,err)
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Validation:GetUserinfo]",0,sc)
	
	Quit sc
}

/// Retrieves the JSON object which contains claims about accessToken
/// that is returned from the introspection endpoint.
/// The request is authorized using the basic authorization HTTP header
/// with the client_id and client_secret associated with applicationName.<br>
/// The claims returned by the introspection endpoint are returned as the properties of jsonObject.
ClassMethod GetIntrospection(applicationName As %String, accessToken As %String, Output jsonObject As %RegisteredObject) As %Status
{
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Set jsonObject=""
	Set sc=$$$OK
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Validation:GetIntrospection]","applicationName="_applicationName)
		
		// Find the client		
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit

		// Get the introspection endpoint
		Set endpoint=client.ServerDefinition.IntrospectionEndpoint
		If endpoint="" {
			Set sc=$$$ERROR($$$OAuth2NoEndpoint,"Token Introspection")
			Quit
		}
		
		// Add authentication to the request
		Set httpRequest=##class(%Net.HttpRequest).%New()
		Set httpRequest.ContentType="application/x-www-form-urlencoded"
		Set sc=##class(%SYS.OAuth2.AccessToken).AddAuthentication(applicationName,httpRequest)
		If $$$ISERR(sc) Quit

		// Add the query parameters
		Do httpRequest.InsertFormData("token",accessToken)
		Do httpRequest.InsertFormData("token_type","access_token")
		
		If $$$SysLogLevel>=3 {
			Set formData("token")=accessToken
			Set formData("token_type")="access_token"
			Do ##class(%OAuth2.Utils).LogHTTPRequest("[%SYS.OAuth2.Validation:GetIntrospection]",0,
				httpRequest,"POST",endpoint,.formData)
		}

		// Post the request
		Set sc=httpRequest.Post(endpoint)
		If $$$ISERR(sc) Quit
		
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogHTTPResponse("[%SYS.OAuth2.Validation:GetIntrospection]",0,httpRequest)
		}
		
		// Get the response as a JSON object
		Set sc=##class(OAuth2.Response).GetJSONResponse(httpRequest,.jsonObject)
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Validation:GetIntrospection]",0,sc)
	
	Quit sc
}

/// RevokeToken invalidates the access token using the revocation endpoint.
/// This method will be called automatically when the session holding the token is deleted.
/// This method may also be called from user code to make the token no longer valid.
/// RevokeToken will call %SYS.OAuth2.AccessToken.Remove to remove the token from the client.<br>
/// The request is authorized using the basic authorization HTTP header
/// with the client_id and client_secret associated with applicationName.
ClassMethod RevokeToken(applicationName As %String, accessToken As %String) As %Status
{
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Set sc=$$$OK
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Validation:RevokeToken]","applicationName="_applicationName)
		
		// Find the client		
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit

		// Get the revocation endpoint
		Set endpoint=client.ServerDefinition.RevocationEndpoint
		If endpoint="" {
			Set sc=$$$ERROR($$$OAuth2NoEndpoint,"Token Revocation")
			Quit
		}
		
		// Add authentication to the request
		Set httpRequest=##class(%Net.HttpRequest).%New()
		Set httpRequest.ContentType="application/x-www-form-urlencoded"
		Set sc=##class(%SYS.OAuth2.AccessToken).AddAuthentication(applicationName,httpRequest)
		If $$$ISERR(sc) Quit

		// Add the query parameters
		Do httpRequest.InsertFormData("token",accessToken)
		Do httpRequest.InsertFormData("token_type","access_token")
		
		If $$$SysLogLevel>=3 {
			Set formData("token")=accessToken
			Set formData("token_type")="access_token"
			Do ##class(%OAuth2.Utils).LogHTTPRequest("[%SYS.OAuth2.Validation:RevokeToken]",0,
				httpRequest,"POST",endpoint,.formData)
		}

		// Post the request
		Set sc=httpRequest.Post(endpoint)
		If $$$ISERR(sc) Quit
		
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogHTTPResponse("[%SYS.OAuth2.Validation:RevokeToken]",0,httpRequest)
		}
		
		// Handle success and error cases
		Set statusCode=httpRequest.HttpResponse.StatusCode
		If statusCode=200 {
			Set token=##class(OAuth2.AccessToken).Open(accessToken,.sc)
			If $isobject(token) Set sc=token.Remove()
		} Else {
			Set errorText="status="_httpRequest.HttpResponse.StatusCode
			Set sc=$$$ERROR($$$OAuth2ResponseBody,"Error response: "_errorText)
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Validation:RevokeToken]",0,sc)
	
	Quit sc
}

/// Check that specified audience is contained in the containing audience list.
/// containingAud may either be a single audience as %String or a list of audiences as %DynamicArray.
ClassMethod IsAudContained(containingAud As %DynamicArray, aud As %String) As %Boolean
{
	If aud'="" {
		If $isobject(containingAud) {
			Set contained=0
			Set iterator=containingAud.%GetIterator()
			While iterator.%GetNext(.key,.value) {
				If value=aud {
					Set contained=1
					Quit
				}
			}
		} Else {
			Set contained=(aud=containingAud)
		}
	} Else {
		Set contained=1
	}

	Quit contained
}

/// Check that scope is subset of valid scopes for this token.
ClassMethod IsScopeContained(containingScope As %String, scope As %String) As %Boolean
{
	Set contained=1
	// If scope not specified, then just keep current scope
	If scope'="" {
		// New scope must be a subset of the scope specified at token creation
		Set currentScope=" "_containingScope_" "
		For i=1:1:$length(scope," ") {
			Set s=$piece(scope," ",i)
			If currentScope'[(" "_s_" ") {
				Set contained=0
				Quit
			}
		}
	}

	Quit contained
}

}
