/// The authorization server supports the authorization control flow for the Authorization Code
/// and Implicit grant types as specified in RFC 6749.  The OAuth2.Server.Auth class is a
/// subclass of %CSP.Page which acts as the Authorization Endpoint and controls the flow
/// in accordance with RFC 6749.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Server.Auth Extends %CSP.Page [ System = 4 ]
{

ClassMethod OnPage() As %Status [ Internal, ServerOnly = 1 ]
{
	Try {
		Set sc=$$$OK
		// Write out the HTML here.
		If $get(%OAuth2error)="" {
			If $get(%token)="" {
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPage]","no token")
				Do ..ReturnSimpleError("internal error -- no token","No token",$$$OK)
			} Else {
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPage]","stage="_%token.Stage)
			}
	
			If $piece(%token.Stage,":",1)="login" {
				Set sc=..DisplayLogin(%token)

			} ElseIf %token.Stage="permission" {
				// Permissions stage after login screen
				Set sc=..DisplayPermissions(%token)

			} Else {
				Do ..ReturnSimpleError("internal error","Stage",$$$OK)
			}
			
			// Save token since Properties may have been modified by DisplayLogin or DisplayPermissions
			If $$$ISOK(sc),$get(%OAuth2error)="" {
				Set sc=%token.Save()
			}
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ..ReturnSimpleError("internal error","Exception caught",sc)
	
	// If error before client identified, return simple error page
	If $get(%OAuth2error)'="" {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPage]","%OAuth2error="_$get(%OAuth2error))
		Write "<html><head></head><body>"_%OAuth2error_"</body></html>"
		Quit $$$OK
	}
	
	Quit $$$OK
}

/// Event handler for <b>PreHTTP</b> event: this is invoked before
/// the HTTP headers for a CSP page have been sent.  All changes to the
/// <class>%CSP.Response</class> class, such as adding cookies, HTTP headers,
/// setting the content type etc. must be made from within the OnPreHTTP() method.
/// Return <b>0</b> to prevent <method>OnPage</method> from being called.<br><br>
/// OnPreHttp is used to control flow and redirect back to the requester.
/// OnPage is where the actual authentication takes place.
ClassMethod OnPreHTTP() As %Boolean [ Internal, ServerOnly = 1 ]
{
	If $$$SysLogLevel>=3 {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPreHTTP]","")
		Do ##class(%OAuth2.Utils).LogCSPRequest("[OAuth2.Server.Auth:OnPreHTTP]",1)
	}
	Kill %OAuth2error
	
	Try {
		// Server must be configured
		Set %server=##class(OAuth2.Server.Configuration).Open(.sc)
		If '$isobject(%server) {
			Do ..ReturnSimpleError("server not configured","Authorization Server is not configured",sc)
		}
		
		// If AuthorizationCode query parameter is present and identified, then in the authentication cycle.  
		// Process the response to login or permissions form.
		Set authorizationCode=##class(%CSP.Page).UnescapeURL($get(%request.Data("AuthorizationCode",1)))
		If authorizationCode'="" {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPreHTTP]","AuthorizationCode="_authorizationCode)
			Set %token=##class(OAuth2.Server.AccessToken).OpenByCode(authorizationCode,.sc)
			If $isobject(%token) {
				Set client=##class(OAuth2.Server.Client).Open(%token.ClientId,.sc)
				If $isobject(client) {
					Do ..ProcessFormResponse(client,%token)
				} Else {
					Do ..ReturnSimpleError("no client","Internal error client not found. AuthorizationCode="_authorizationCode_", clientId="_%token.ClientId,sc)
				}
			} Else {
				Do ..ReturnSimpleError("no token","No token for AuthorizationCode="_authorizationCode,sc)
			}
			Quit
		}
		
		// Must be new request. First check for client_id so that we know where to redirect.
		Set clientId=##class(%CSP.Page).UnescapeURL($get(%request.Data("client_id",1)))
		If clientId'="" {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPreHTTP]","client_id="_clientId)
			Set client=##class(OAuth2.Server.Client).Open(clientId,.sc)
			If $isobject(client) {
				Do ..ProcessRequest(client,.%token)
			} Else {
				Do ..ReturnSimpleError("client_id","Unable to find client_id="_clientId,sc)
			}
			Quit
		}
		
		// No client could be identified.  Just return error page.
		Do ..ReturnSimpleError("no client_id","No AuthorizationCode or client_id",$$$OK)
		
	} Catch ex {
		Set sc=ex.AsStatus()
		Do ..ReturnSimpleError("internal error","Exception caught",sc)
	}
	
	Quit 1
}

/// Process the initial request from the client
ClassMethod ProcessRequest(client As OAuth2.Server.Client, Output token As OAuth2.Server.AccessToken) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessRequest]","ClientId="_client.ClientId)
	
	Try {
		Set sc=$$$OK
        // Ensure that we honor the requested HTTP_ACCEPT_LANGUAGE as default 
        Do %response.MatchLanguage() 

		// Error check the request and initialize token
		Set token=..InitializeRequestToken(client)
		// If no token object returned, then redirect error already set
		If token="" Quit
		
		// If we are configured to use callback to do entire authentication, do it now
		Set sc=..DirectLogin(token,.password)
		If $$$ISERR(sc) Quit
		If token.Username'="" {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessRequest]","Authenticate via DirectLogin")
			// DirectLogin method took responsibility for the entire authentication
			If token.Username=$char(0) {
				Do ..ReturnError(client,token,"access_denied")
				Quit

			} Else {
				If password'="",..ValidateUser(token,token.Username,password,.sc) {
					// Save the time when the authorization took place.
					$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessRequest]","ValidateUser auth_time="_token.AuthTime)
					Do token.SetAuthTime()
					// Call AfterAuthenticate to allow user to adjust scope and properties, and to add responseProperties
					Set sc=..AfterAuthenticate(token)
					// Token generated and returned immediately. implicit grant type
					Set sc=..PrepareResponse(token)
					If $$$ISERR(sc) Quit
					Do ..RedirectResponse(client,token)

				} Else {
					If $$$ISOK(sc) {
						Do ..ReturnError(client,token,"access_denied")
						Quit
					}
				}
			}

		} Else {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessRequest]","Will display login page")
			// Set stage and go display login page
			Set token.Stage="login:1"
			
			// Login stage -- get the user.
			// Get username from cookie if already logged in and sessions supported
			Set username=..GetUser(.scope,.authTime,.sc)
			If $$$ISERR(sc) Quit

			// If prompt=none, then never prompt for username or consent.			
			Set prompt=token.Properties.RequestProperties.GetAt("prompt")
			If username="",prompt["none" {
				Do ..ReturnError(client,token,"access_denied")
				Quit
			}
			
			// If session expired because of max_age query parameter,
			// then logout the session and reauthenticate
			If username'="" {
				Set maxAge=token.Properties.RequestProperties.GetAt("max_age")
				If maxAge'="" {
					Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
					If now>(authTime+maxAge) {
						Set username=""
						Do ..Logout()
					}
				}
			}
			
			// If propmpt query parameter requires reauthentication,
			// then logout the session and reauthenticate
			If username'="" {
				If (prompt["login") || (prompt["select_account") {
					Set username=""
					Do ..Logout()
				}
			}
			
			// There is an already logged in user
			If username'="" {
				Set token.Stage="permission"
				Set token.Username=username
				Do token.SetAuthTime(authTime)
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessRequest]","GetUser auth_time="_token.AuthTime_", scope="_scope)

				If $$$SysLogLevel>=7 {
					Do ##class(%OAuth2.Utils).LogServerScope("Set ScopeArray-GetUser",token)
				}
				If ##class(%SYS.OAuth2.AccessToken).IsScopeContained(scope,token.Scope),prompt'["consent" {
					// If desired token scope is a subset of session scope,
					// return access token.
					$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessRequest]","Session user has required scope")
					// Call AfterAuthenticate to allow user to adjust scope and properties, and to add responseProperties
					Set sc=..AfterAuthenticate(token)
					// Return token
					Set sc=..PrepareResponse(token)
					If $$$ISERR(sc) Quit
					
					// Return access token response
					Set client=##class(OAuth2.Server.Client).Open(token.ClientId,.sc)
					If $$$ISERR(sc) Quit
					If '$isobject(client) {
						Do ..ReturnError(client,token,"server_error","no client found")
						Quit
					}
					Do ..RedirectResponse(client,token)

				} Else {
					Do ..RedirectToSelf(token)
				}

			} Else {
				// Go to display authentication page.
				Do ..RedirectToSelf(token)
			}
		}
		
		// Now save the token
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogServerToken("ProcessRequest",token)
		}
		Set sc=token.Save()
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ..ReturnError(client,token,"server_error","",sc)
}

/// Redirect to self with AuthorizationCode in order to display login or permissions.
ClassMethod RedirectToSelf(token As OAuth2.Server.AccessToken) [ Internal, Private ]
{
	// Redirect to self to clear OAuth 2.0 request parameters
	Set url="authorize"
	Set url=url_"?AuthorizationCode="_..EscapeURL(token.AuthorizationCode)
	Set url=url_"&stage="_token.Stage
	Set %response.Redirect=url
	// Change stage to display
	Set token.Stage="display"
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:RedirectToSelf]","url="_url)
}

/// Process the initial request from the client
ClassMethod InitializeRequestToken(client As OAuth2.Server.Client) As OAuth2.Server.AccessToken [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:InitializeRequestToken]","ClientId="_client.ClientId)
	Try {
		Set sc=$$$OK
		Set returnToken=""
		
		// Get the request parameters from %request and the request JWT
		Set queryErr=..GetQueryParameters(client,.requestParameters)
		If queryErr="",$data(%request.Data("request",1)),$data(%request.Data("request_uri",1)) {
			Set queryErr="Both request and request_uri parameters may not be specified."
		}
		
		// Get a new access token object
		Set token=##class(OAuth2.Server.AccessToken).%New()

		// Get redirect uri for response
		Set redirect=$get(requestParameters("redirect_uri"))
		If redirect'=""{
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:InitializeRequestToken]","redirect="_redirect)
			Set token.RedirectURL=redirect
			Set found=0
			For i=1:1:client.RedirectURL.Count() {
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:InitializeRequestToken]","redirect("_i_")="_client.RedirectURL.GetAt(i))
				If redirect=client.RedirectURL.GetAt(i) {
					Set found=1
					Quit
				}
			}
			If 'found {
				// Need state to return the error
				Set token.State=$get(requestParameters("state"))
				// Return the error
				Do ..ReturnError(client,token,"invalid_request","redirect_uri does not match the client's configured redirect URI.")
				Quit
			}
		} Else {
			If client.RedirectURL.Count()'=1 {
				Do ..ReturnSimpleError("invalid_request","redirect_uri was not specified.",$$$OK)
				Quit
			}
			Set token.RedirectURL=client.RedirectURL.GetAt(1)
		}
		
		// Get state from request to include in responses.		
		Set state=$get(requestParameters("state"))
		If state="" {
			Do ..ReturnError(client,token,"invalid_request","No state was specified.")
			Quit
		}
		Set token.State=state
		
		// If good so far and error getting query parameters, then return error
		If queryErr'="" {
			If $get(%request.Data("request_uri"))'="" {
				Set code="invalid_request_uri"
			} Else {
				Set code="invalid_request_object"
			}
			Do ..ReturnError(client,token,"invalid_request",queryErr)
			Quit
		}

		// client_id and response_type must be query parameters and match value if request object
		If requestParameters("client_id")'=client.ClientId {
			Do ..ReturnError(client,token,"invalid_request","client_id must be specified as query parameter.")
			Quit
		}
		// response_type must be a query parameter
		If requestParameters("response_type")'=$get(%request.Data("response_type",1)) {
			Do ..ReturnError(client,token,"invalid_request","response_type must be specified as query parameter.")
			Quit
		}

		// Get aud from request to use in validating token.
		Set aud=$get(requestParameters("aud"))
		If aud="",%server.AudRequired {
			Do ..ReturnError(client,token,"invalid_request","No aud was specified.")
			Quit
		}
		If aud="" Set aud=client.ClientId
		Do token.Aud.Insert(aud)

		// Validate response mode
		Set responseMode=$get(requestParameters("response_mode"))
		If $case(responseMode,"":0,"query":0,"fragment":0,:1) {
			// Unsupported
			Do ..ReturnError(client,token,"unsupported_response_mode","response_mode="_responseMode)
			Quit
		}

		// Validate response type
		Set responseType=requestParameters("response_type")
		If responseType="code" {
			// Authorization Code Grant Type
			Set token.GrantType="A"
			If responseMode="" Set responseMode="query"
		} ElseIf $case(responseType,"token":1,"id_token token":1,"id_token":1,:0) {
			// Implicit Grant Type
			Set token.GrantType="I"
			If responseMode="" Set responseMode="fragment"
		} Else {
			// Unsupported
			Do ..ReturnError(client,,"unsupported_response_type")
			Quit
		}
		If %server.SupportedGrantTypes'[token.GrantType {
			Do ..ReturnError(client,token,"unsupported_response_type")
			Quit
		}
		
		// Validate the max_age request parameter to be integer
		Set maxAge=$get(requestParameters("max_age"))
		If maxAge'="",(maxAge'=+maxAge) || (maxAge<1) || (maxAge\1'=maxAge) {
			Do ..ReturnError(client,token,"invalid_request","Invalid prompt request parameter")
			Quit
		}
		
		// Validate the prompt request patameter
		Set prompt=$zstrip($get(requestParameters("prompt")),"<=>W")
		If prompt'="",prompt'="none" {
			Set ok=1
			For i=1:1:$length(prompt," ") {
				If $case($piece(prompt," ",i),"login":0,"consent":0,"select_account":0,:1) {
					Set ok=0
					Quit
				}
			}
			If 'ok {
				Do ..ReturnError(client,token,"invalid_request","Invalid prompt request parameter")
				Quit
			}
		}
		
		If $data(%request.Data("client_id",2)) ||
		   $data(%request.Data("response_type",2)) ||
		   $data(%request.Data("response_mode",2)) ||
		   $data(%request.Data("redirect_uri",2)) ||
		   $data(%request.Data("scope",2)) ||
		   $data(%request.Data("state",2)) ||
		   $data(%request.Data("aud",2)) ||
		   $data(%request.Data("claims",2)) ||
		   $data(%request.Data("prompt",2)) ||
		   $data(%request.Data("max_age",2)) {
			Do ..ReturnError(client,token,"invalid_request","Multiple occurrence of request parameter")
			Quit
		}
		
		// Must use https for this request
		If '%request.Secure {
			Do ..ReturnError(client,token,"invalid_request","Request must be secured with TLS/SSL.")
			Quit
		}
		
		// Initialize the access token object
		Set token.ClientId=client.ClientId
		Set token.Stage="new"
		Set token.Issuer=%server.GetIssuerURL()
		Set token.ResponseType=responseType
		Set token.ResponseMode=responseMode

		// Scope must be specified or defaulted
		Set scope=$get(requestParameters("scope"))
		Set error=..ProcessScope(%server,client,.scope)
		If error'="" {
			Do ..ReturnError(client,token,error.Error,error.ErrorDescription)
			Quit
		}
		Do ##class(OAuth2.Server.Auth).SetScope(token,scope)
		
		// Save the CSP request query parameters
		Do ..SaveQueryParameters(.requestParameters,token.Properties.RequestProperties)

		// Copy needed client configuration properties to the ServerProperties array.
		Do ..CopyAuthenticationProperties(client,token)
	
		// Call BeforeAuthenticate to allow user to adjust scope and properties
		Set sc=..BeforeAuthenticate(token)
		If $$$ISERR(sc) {
			Do ..ReturnError(client,token,"server_error","",sc)
			Quit
		}
		
		// OpenID Connect specific processing.
		// Note that this block of code takes place after BeforeAuthenticate is called
		// which allows openid scope to be by BeforeAuthenticate.
		If token.IsOpenID() {
			// "token" response_type is not valid for OpenID Connect
			If responseType="token" {
				Do ..ReturnError(client,token,"invalid_request","token is not a valid response_type for OpenID Connect.")
				Quit
			}

			// Add scope based claims		
			Do ##class(OAuth2.Server.OpenID).AddScopeClaims(token)

			// Add claims based on scopes as specified by OpenID Connect
			Set claims=$get(requestParameters("claims"))
			If claims'="" {
				Set err=""
				If $isobject(claims) {
					Set claimsObject=claims
				} Else {
					Set claimsObject=##class(%DynamicAbstractObject).%FromJSON(claims)
				}
				If $isobject(claimsObject.userinfo) {
					Set userinfoObject=claimsObject.userinfo
					Set err=..ProcessClaimsRequest(userinfoObject,token.Properties.UserinfoClaims)
				}
				If err="",$isobject(claimsObject."id_token") {
					Set idtokenObject=claimsObject."id_token"
					Set err=..ProcessClaimsRequest(idtokenObject,token.Properties.IDTokenClaims)
				}
				If err'="" {
					Do ..ReturnError(client,token,"invalid_request",err)
					Quit
				}
			}
		}

		// Only refresh token for authorization code when needed
		If (" "_responseType_" ")[" code " {
			Do ##class(OAuth2.Server.Token).GenerateRefreshToken(client,token)
		}
		
		// This token object is good
		Set returnToken=token
		
	} Catch ex {
		Set sc=ex.AsStatus()
		Do ..ReturnError(client,token,"server_error","",sc)
	}
	
	Quit returnToken
}

/// Get request properties from %request and the request JWT.
/// Return error description if invalid request.
ClassMethod GetQueryParameters(client As OAuth2.Client, Output requestParameters) As %String
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GetQueryParameters]","")
	Set err=""
	
	// Copy query parameters from request
	Kill requestParameters
	Set name=""
	For {
		Set name=$order(%request.Data(name))
		If name="" Quit
		Set requestParameters(name)=##class(%CSP.Page).UnescapeURL($get(%request.Data(name,1)))
	}
	
	Set request=$get(requestParameters("request"))
	Set requestUri=$get(requestParameters("request_uri"))
	Set err=""
	if request'="" {
		// If request object is specified,
		// then supersede the query parameter values with values from request JWT.
		Set err=..GetRequestObject(client,request,.requestParameters)
	}
	
	If err="",requestUri'="" {
		// If request uri is specified, then load the request JWT and
		// then supersede the query parameter values with values from request JWT.
		Set err=..LoadRequest(requestUri,.request)
		If err="" {
			Set err=..GetRequestObject(client,request,.requestParameters)
		}
	}
	
	If err'="" {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GetQueryParameters]","err="_err)
	}
	
	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogArray("[OAuth2.Server.Auth:GetQueryParameters]",1,"request parameters (err="_err_")",.requestParameters)
	}

	Quit err
}

/// Load request from request_uri specified location.
ClassMethod LoadRequest(requestUri As %String, Output request As %String) As %String [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:LoadRequest]","requestUri="_requestUri)
	Set httpRequest=##class(%Net.HttpRequest).%New()
	If $extract(requestUri,1,8)="https://" {
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=%server.SSLConfiguration
	}

	Set sc=httpRequest.Get($piece(requestUri,"#",1))
	If $$$ISERR(sc) Quit $system.Status.GetErrorText(sc)

	// Get response as string
	Set httpResponse=httpRequest.HttpResponse
	If $isobject(httpResponse.Data) {
		Do httpResponse.Data.Rewind()
		If httpResponse.Data.Size>32000 {
			Quit "body is too large. length="_httpResponse.Data.Size
		}
		Set request=httpResponse.Data.Read(32000)
	} Else {
		Set request=httpResponse.Data
	}

	Quit ""
}

/// Get request parameters from request object
ClassMethod GetRequestObject(client As OAuth2.Client, request As %String, ByRef requestParameters) As %String [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GetRequestObject]","ClientId="_client.ClientId_", request="_request)
	// Setup the credentials for the server
	If %server.ServerCredentials'="" {
		Set local("alias")=%server.ServerCredentials
		If %server.ServerPassword'="" Set local("password")=%server.ServerPassword
	}
	
	// Setup the credentials for the client
	If client.ClientCredentials'="" {
		Set remote("alias")=client.ClientCredentials
	}
	
	// Get the request object
	Set sc=##class(%OAuth2.JWT).JWTToObject(request,.local,.remote,.securityParameters,.requestObject)
	If $$$ISERR(sc) Quit $system.Status.GetErrorText(sc)
	
	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogJSON("[OAuth2.Server.Auth:GetRequestObject]",1,"request object",requestObject)
	}

	// Get the request properties
	Set iterator=requestObject.%GetIterator()
	While iterator.%GetNext(.name,.value) {
		Set requestParameters(name)=value
	}
	
	// request or request_uri must not be in request object
	If requestObject.%IsDefined("request") || requestObject.%IsDefined("request_uri") {
		Quit "request or request_uri properties may not be specified in the request object."
	}
	
	// If request is signed, then iss and aud claims must be included
	If $get(securityParameters("sigalg"))'="" {
		If requestObject.iss'=client.ClientId {
			Quit "A signed request object must have a valid iss claim."
		}
		Set aud=requestObject.aud
		Set issuer=%server.GetIssuerURL()
		Set ok=0
		If $isobject(aud),$classname(aud)="%Library.DynamicArray" {
			Set iterator=aud.%GetIterator()
			While iterator.%GetNext(.key,.value) {
				If value=issuer {
					Set ok=1
					Quit
				}
			}
		} ElseIf aud=issuer {
			Set ok=1
		}
		If 'ok {
			Quit "A signed request object must have a valid aud claim."_aud_":"_%server.IssuerEndpoint
		}
	}

	Quit ""
}

/// Process userinfo and id_token members of the claims parameter
ClassMethod ProcessClaimsRequest(claimsMemberObject As %DynamicObject, claims As %ArrayOfObjects) As %String [ Internal ]
{
	Set err=""
	
	// Look at each of the possible claims
	Set iterator=claimsMemberObject.%GetIterator()
	While iterator.%GetNext(.name,.value) {
		If value="" {
			// null for default claim
			Do claims.SetAt("",name)
			
		} ElseIf $isobject(value) {
			// claim value must be a JSON object if not null
			If $classname(value)'="%Library.DynamicObject" {
				Set err="array not expected for claim: "_name
				Quit
			}
			Set claim=##class(%OAuth2.Server.Claim).%New()
			
			// essential member must be true or false if present
			Set essential=$case(value.essential,"":0,0:0,1:1,:"")
			If essential="" {
				Set err="unexpected value for essential member of claim: "_name
				Quit
			}
			Set claim.Essential=essential
			
			// value member
			If value.%IsDefined("value") {
				Set valueMember=value.value
				If $isobject(valueMember) {
					Set err="value member must be a scalar for claim: "_name
					Quit
				}
				If valueMember'="" Do claim.Values.Insert(valueMember)
			}
			
			// values array member
			If value.%IsDefined("values") {
				Set valuesMember=value.values
				If '$isobject(valuesMember) || ($classname(valuesMember)'="%Library.DynamicArray") {
					Set err="values member must be an array for claim: "_name
					Quit
				}
				Set iterator=valuesMember.%GetIterator()
				While iterator.%GetNext(.i,.arrayValue) {
					If arrayValue'="" Do claim.Values.Insert(arrayValue)
				}
			}
			
			// Add to claims list
			Do claims.SetAt(claim,name)
			
		} Else {
			Set err="unexpected value for claim: "_name
			Quit
		}
	}
	
	Quit err
}

/// Save the %request query parameters in the properties array.
ClassMethod SaveQueryParameters(ByRef requestParameters, requestParameterArray As %ArrayOfDataTypes)
{
	Set name=""
	For {
		Set name=$order(requestParameters(name))
		If name="" Quit
		Do requestParameterArray.SetAt(requestParameters(name),name)
	}
}

/// Process the form response from the login page or permissions page
ClassMethod ProcessFormResponse(client As OAuth2.Server.Client, token As OAuth2.Server.AccessToken) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessFormResponse]","ClientId="_client.ClientId_", stage="_token.Stage)
	Try {
		Set sc=$$$OK
		
		If $case($piece(token.Stage,":",1),"login":0,"permission":0,"display":0,:1) {
			Do ..ReturnError(client,token,"server_error","")
			Quit
		}
		
		// If just redirect to self, then display page
		If token.Stage="display" {
			Set stage=$get(%request.Data("stage",1))
			If stage'="" {
				Set token.Stage=stage
				Set sc=token.Save()
			} Else {
				Do ..ReturnError(client,token,"server_error","Unexpected return from initial page")
			}
			Quit
		}
		
		// Handle Cancel
		If $data(%request.Data("Cancel",1)) {
			Do ..ReturnError(client,token,"access_denied","")
			Set token.Stage=""
			Set sc=token.Save()
			Quit
		}
		
		// Response from login form
		If $piece(token.Stage,":",1)="login" {
			// Check proper return from form
			If '$data(%request.Data("Username",1)) || ($get(%request.Data("Password",1))="") ||
			   ('$data(%request.Data("Login",1)) && '$data(%request.Data("Accept",1))) {
				Do ..ReturnError(client,token,"server_error","Unexpected return from authenticate dialog")
				Quit
			}

			Set username=$get(%request.Data("Username",1))
			Set password=$get(%request.Data("Password",1))
			If ..ValidateUser(token,username,password,.sc) {
				Set token.Stage="permission"
				Set token.Username=username
			} Else {
				Set token.Stage=$piece(token.Stage,":",1)_":"_($piece(token.Stage,":",2)+1)
			}
			If $$$ISERR(sc) Quit
			
			// Save p_ ids from request data
			Do ..SaveRequestData(token)
				
			// If login form had an Accept button, then do not quit since permission already given.
			// The login form also acted as a permissions form.
			If '$data(%request.Data("Accept",1)) {
				Set sc=token.Save()
				Quit
			}
		} 
		
		// Permissions have been accepted.
		If token.Stage="permission" {
			// Check proper return from form
			If '$data(%request.Data("Accept",1)) {
				Do ..ReturnError(client,token,"server_error","Unexpected return from permissions dialog")
				Quit
			}
			
			// Save p_ ids from request data
			Do ..SaveRequestData(token)
				
			// Call AfterAuthenticate to allow user to adjust scope and properties, and to add responseProperties
			Set sc=..AfterAuthenticate(token)
	
			// Check for existing session to update if we are supporting sessions.
			If %server.SupportSession {
				// Get the current user
				Set username=..GetUser(.sessionScope,.authTime,.sc)
				If username'="",username=token.Username {
					// Adjust scope of session to include newly accepted token permissions
					Set paddedSessionScope=" "_sessionScope_" "
					Set scope=token.Scope
					For i=1:1:$length(token.Scope," ") {
						Set s=$piece(token.Scope," ",i)
						If paddedSessionScope'[(" "_s_" ") {
							Set sessionScope=sessionScope_" "_s
						}
					}
					Set sc=..UpdateSession(sessionScope)
				} Else {
					Set sc=..Login(token.Username,token.Scope,%server.SessionInterval,.authTime)
				}
				If $$$ISOK(sc) Do token.SetAuthTime(authTime)
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessFormResponse]","GetUser auth_time="_token.AuthTime_", username="_username_", token.Username="_token.Username)
			} Else {
				// Save the time when the authorization took place.
				Do token.SetAuthTime()
				$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ProcessFormResponse]","No session auth_time="_token.AuthTime)
			}

			// Generate and return access token
			Set sc=..PrepareResponse(token)
			If $$$ISERR(sc) Quit
			Do ..RedirectResponse(client,token)
			
			// Save token
			Set sc=token.Save()
			If $$$ISERR(sc) Quit
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Do ..ReturnError(client,token,"server_error","",sc)
}

/// Save %request data whose name begins with p_ in properties
ClassMethod SaveRequestData(token As OAuth2.Server.AccessToken) [ Internal, ServerOnly = 1 ]
{
	Set name=""
	For {
		Set name=$order(%request.Data(name))
		If name="" Quit
		If $extract(name,1,2)="p_",$length(name)>2 {
			Do token.Properties.CustomProperties.SetAt(##class(%CSP.Page).UnescapeURL($get(%request.Data(name,1))),$extract(name,3,*))
		}
	}
}

/// Return a simple error page, since no client could be identified
ClassMethod ReturnSimpleError(error As %String, desc As %String, sc As %Status) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:OnPreHTTP]","error="_error_", desc="_$get(desc))
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Auth:OnPreHTTP]",1,sc)
	// Return simple error page.
	Set %OAuth2error="Unexpected request - "_error
}

/// Handle scope rules
ClassMethod ProcessScope(server As OAuth2.Server.Configuration, client As OAuth2.Server.Client, ByRef scope As %String) As %OAuth2.Error
{
	// Scope must be specified or defaulted
	Set initialScope=##class(%OAuth2.Utils).NormalizeScope(scope)

	If $isobject(client),initialScope="" Set initialScope=client.DefaultScope
	If initialScope="" Set initialScope=server.DefaultScope
	If initialScope="" {
		Quit ##class(OAuth2.EWrror).%New("invalid_scope","No scope was specified or configured.")
	}

	// Check scopes are valid -- error or ignore for unsupported scope
	Set openid=##class(OAuth2.Server.OpenID).IsOpenID(scope)
	Set error=""
	Set scope=""
	For i=1:1:$length(initialScope," ") {
		Set p=$piece(initialScope," ",i)
		If server.SupportedScopes.IsDefined(p) || (..GetOpenIDScope(openid,p)'="") || server.AllowUnsupportedScope {
			Set scope=scope_p_" "
		} Else {
			Set scope=""
			Set error=##class(%OAuth2.Error).%New("invalid_scope","An unsupported scope was specified: "_p)
			Quit
		}
	}
	If error'="" Quit error

	If scope="" {
		Quit ##class(%OAuth2.Error).%New("invalid_scope","No supported scope was specified")
	}
	
	Set scope=$extract(scope,1,*-1)

	Quit ""
}

/// Execute BeforeAuthenticate in the authenticate class
ClassMethod BeforeAuthenticate(token As OAuth2.Server.AccessToken) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:BeforeAuthenticate]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles_", AuthenticateClass="_%server.AuthenticateClass)
	
	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Now do the call in user's namespace
	New $namespace,$roles
	Set $namespace=%server.CustomizationNamespace
	Set $roles=%server.CustomizationRoles
	
	Set sc=$classmethod(%server.AuthenticateClass,"BeforeAuthenticate",token.ScopeArray,properties)
	If $$$ISOK(sc) Do ..SetScopeArray(token)

	Quit sc
}

/// Execute AfterAuthenticate in the authenticate class
ClassMethod AfterAuthenticate(token As OAuth2.Server.AccessToken) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:AfterAuthenticate]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles_", AuthenticateClass="_%server.AuthenticateClass)
	
	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Now do the call in user's namespace
	New $namespace,$roles
	Set $namespace=%server.CustomizationNamespace
	Set $roles=%server.CustomizationRoles
	new %token set %token=token
	Set sc=$classmethod(%server.AuthenticateClass,"AfterAuthenticate",token.ScopeArray,properties)
	If $$$ISOK(sc) Do ..SetScopeArray(token)

	Quit sc
}

/// Execute DirectLogin in the authenticate class
ClassMethod DirectLogin(token As OAuth2.Server.AccessToken, Output password As %String) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:DirectLogin]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles)
	
	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Now do the call in user's namespace
	New $namespace,$roles
	Set $namespace=%server.CustomizationNamespace
	Set $roles=%server.CustomizationRoles
	
	Set username=""
	Set password=""
	Set sc=$classmethod(%server.AuthenticateClass,"DirectLogin",token.ScopeArray,properties,.username,.password)
	Set token.Username=username
	Quit sc
}

/// Execute DisplayLogin in the authenticate class
ClassMethod DisplayLogin(token As OAuth2.Server.AccessToken) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:DisplayLogin]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles)
	
	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Now do the call in user's namespace
	New $namespace,$roles
	Set $namespace=%server.CustomizationNamespace
	Set $roles=%server.CustomizationRoles
	
	Quit $classmethod(%server.AuthenticateClass,"DisplayLogin",token.AuthorizationCode,token.ScopeArray,properties,$piece(token.Stage,":",2))
}

/// Execute DisplayPermissions in the authenticate class
ClassMethod DisplayPermissions(token As OAuth2.Server.AccessToken) As %Status [ Internal, ServerOnly = 1 ]
{
	#dim scopeArray As %ArrayOfDataTypes
	#dim sessionScopeArray As %ArrayOfDataTypes

	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:DisplayPermissions]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles)
	
	// If user logged into session, then get scope already obtained for user and
	// Remove from requested scope list.
	Set username=..GetUser(.sessionScope,,.sc)
	If $$$ISERR(sc) Quit sc
	If username'="",sessionScope'="" {
		Set scopeArray=..GetScopeArray(token.Scope)
		Set sessionScopeArray=..GetScopeArray(sessionScope)
		// Remove current scopes from requested scope array, since they are already approved.
		Set scope=""
		For {
			Set scope=scopeArray.Next(scope)
			If scope="" Quit
			If sessionScopeArray.GetAt(scope)'="" Do scopeArray.RemoveAt(scope)
		}
	} Else {
		Set scopeArray=token.ScopeArray
		Set sessionScopeArray=""
	}
	
	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Now do the call in user's namespace
	New $namespace,$roles
	Set $namespace=%server.CustomizationNamespace
	Set $roles=%server.CustomizationRoles
	
	Quit $classmethod(%server.AuthenticateClass,"DisplayPermissions",token.AuthorizationCode,scopeArray,sessionScopeArray,properties)
}

/// Copy the properties that are needed by the Authentication Class
/// from OAuth2.Server.Client to CustomProperties.
ClassMethod CopyAuthenticationProperties(client As OAuth2.Server.Client, token As OAuth2.Server.AccessToken) [ Internal ]
{
	If client."client_name"'="" {
		Do token.Properties.ServerProperties.SetAt(client."client_name","client_name")
	} Else {
		Do token.Properties.ServerProperties.SetAt(client.Name,"client_name")
	}
	Do token.Properties.ServerProperties.SetAt(client."logo_uri","logo_uri")
	Do token.Properties.ServerProperties.SetAt(client."client_uri","client_uri")
	Do token.Properties.ServerProperties.SetAt(client."policy_uri","policy_uri")
	Do token.Properties.ServerProperties.SetAt(client."tos_uri","tos_uri")
}

/// Get scope array
ClassMethod GetScopeArray(scope As %String) As %ArrayOfDataTypes [ Internal ]
{
	Set openid=##class(OAuth2.Server.OpenID).IsOpenID(scope)
	Set scopeArray=##class(%ArrayOfDataTypes).%New()
	For i=1:1:$length(scope," ") {
		Set s=$piece(scope," ",i)
		If %server.SupportedScopes.IsDefined(s) {
			Do scopeArray.SetAt(%server.SupportedScopes.GetAt(s),s)
		} Else {
			Do scopeArray.SetAt(..GetOpenIDScope(openid,s),s)
		}
	}
	Quit scopeArray
}

/// Set scope and scope array in the token baseed on array of scopes.
ClassMethod SetScopeArray(token As OAuth2.Server.AccessToken) [ Internal ]
{
	If $$$SysLogLevel>=7 {
		Do ##class(%OAuth2.Utils).LogServerScope("Set ScopeArray-before",token)
	}

	// Compute blank separated list of scopes based on scope array
	Set scope=""
	Set s=""
	For {
		Set desc=token.ScopeArray.GetNext(.s)
		If s="" Quit
		Set scope=scope_s_" "
		Set array(s)=desc
	}
	If scope'="" Set scope=$extract(scope,1,*-1)
	
	// If scope has changed update Scope and ScopeArray
	If scope'=token.Scope {
		// Update scope
		Set token.Scope=scope

		// Update scope array
		Do token.ScopeArray.Clear()
		Set s=""
		For {
			Set s=$order(array(s),1,desc)
			If s="" Quit
			Do token.ScopeArray.SetAt(desc,s)
		}
		
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogServerScope("Set ScopeArray-after",token)
		}
	}
}

/// Set scope and scope array in the token as on blank spearated list of scopes.
ClassMethod SetScope(token As OAuth2.Server.AccessToken, scope As %String) [ Internal ]
{
	// Nothing to do  if scope hasn't changed
	If token.Scope=scope Quit

	// Get the array version of the scopes including descriptions.
	Set scopeArray=..GetScopeArray(scope)

	// Copy the scope array to the token	
	Do token.ScopeArray.Clear()
	Set s=""
	For {
		Set desc=scopeArray.GetNext(.s)
		If s="" Quit
		Do token.ScopeArray.SetAt(desc,s)
	}
	
	// Set new scope
	Set token.Scope=scope
}

/// Get description of OpenID scope if the sacope is valid
ClassMethod GetOpenIDScope(openid As %Boolean, scope As %String) As %String [ Internal ]
{
	Set description=""

	If scope="offline_access" {
		Set description="Offline Access"
	} ElseIf openid {
		If scope="openid" {
			Set description="OpenID Connect"
		} ElseIf scope="profile" {
			Set description="User default profile information"
		} ElseIf scope="email" {
			Set description="User email"
		} ElseIf scope="address" {
			Set description="User mailing address"
		} ElseIf scope="phone" {
			Set description="User phone number"
		}
	}
	Quit description
}

/// Execute GetUser session method
ClassMethod GetUser(Output scope As %String, Output authTime As %Integer, Output sc As %Status) As %String [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GetUser]","inSession="_%server.SupportSession)

	Set scope=""
	Set sc=$$$OK
	// If sessions not supported, then no logged in user.
	If '%server.SupportSession Quit ""
	
	// If not default session class, then in customization namespace
	If %server.SessionClass'="OAuth2.Server.Session" {
		New $namespace,$roles
		Set $namespace=%server.CustomizationNamespace
		Set $roles=%server.CustomizationRoles
	}
	
	Set username=$classmethod(%server.SessionClass,"GetUser",.scope,.authTime,.sc)

	// There is an already logged in user
	If username'="" {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GetUser]","Session user="_username_", session scope="_scope_", requested scope="_%token.Scope)
		// Logged in user must still be valid
		If '..ValidateUser(%token,username,"",.sc) {
			Set (username,scope)=""
			// Logout the user if he is not longer valid.
			Do ..Logout()
		}
	}
	
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GetUser]","username="_username_", scope="_scope)
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Auth:GetUser]",1,sc)
	
	Quit username
}

/// Execute UpdateSession session method
ClassMethod UpdateSession(scope As %String) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:UpdateSession]","inSession="_%server.SupportSession_", scope="_scope)

	// If not default session class, then in customization namespace
	If %server.SessionClass'="OAuth2.Server.Session" {
		New $namespace,$roles
		Set $namespace=%server.CustomizationNamespace
		Set $roles=%server.CustomizationRoles
	}
	
	Set sc=$classmethod(%server.SessionClass,"Update",scope)

	If $$$SysLogLevel>=7 {
		Do ##class(%OAuth2.Utils).LogCurrentSesssion("UpdateSession")
	}

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Auth:UpdateSession]",1,sc)
	
	Quit sc
}

/// Execute Login session method
ClassMethod Login(username As %String, scope As %String, interval As %Integer, authTime As %Integer) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:Login]","username="_username_", scope="_scope_", interval="_interval)

	// If not default session class, then in customization namespace
	If %server.SessionClass'="OAuth2.Server.Session" {
		New $namespace,$roles
		Set $namespace=%server.CustomizationNamespace
		Set $roles=%server.CustomizationRoles
	}
	
	Set sc=$classmethod(%server.SessionClass,"Login",username,scope,interval,.authTime)

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Auth:Login]",1,sc)
	
	Quit sc
}

/// Execute Logout session method
ClassMethod Logout() [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:Logout]","")

	// If not default session class, then in customization namespace
	If %server.SessionClass'="OAuth2.Server.Session" {
		New $namespace,$roles
		Set $namespace=%server.CustomizationNamespace
		Set $roles=%server.CustomizationRoles
	}
	
	Do $classmethod(%server.SessionClass,"Logout")

	Quit
}

/// Execute ValidateUser callback
ClassMethod ValidateUser(token As OAuth2.Server.AccessToken, username As %String, password As %String, Output sc As %Status) As %Boolean [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ValidateUser]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles_", username="_username)

	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Default validate user class is always run in %SYS
	If %server.ValidateUserClass'="%OAuth2.Server.Validate" {
		New $namespace,$roles
		Set $namespace=%server.CustomizationNamespace
		Set $roles=%server.CustomizationRoles
	}
	
	Set sc=$$$OK
	Set valid=$classmethod(%server.ValidateUserClass,"ValidateUser",username,password,token.ScopeArray,properties,.sc)
	If $$$ISERR(sc) || 'valid Quit 0

	// Update scope if it has been changed by ValidateUser
	Do ..SetScopeArray(token)

	// Save username
	Set token.Username=username
	
	// Set default properties
	Do ..AddClaimValues(token,token.ClientId,username)
	
	Quit 1
}

/// Execute ValidateClient callback
ClassMethod ValidateClient(token As OAuth2.Server.AccessToken, clientId As %String, clientSecret As %String, Output sc As %Status) As %Boolean [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ValidateClient]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles_", client_id="_clientId)

	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	// Default validate user class is always run in %SYS
	If %server.ValidateUserClass'="%OAuth2.Server.Validate" {
		New $namespace,$roles
		Set $namespace=%server.CustomizationNamespace
		Set $roles=%server.CustomizationRoles
	}
	
	Set sc=$$$OK
	// Get scope array
	Set valid=$classmethod(%server.ValidateUserClass,"ValidateClient",clientId,clientSecret,token.ScopeArray,properties,.sc)
	If $$$ISERR(sc) || 'valid Quit 0

	// Update scope if it has been changed by ValidateClient
	Do ..SetScopeArray(token)

	// Username is "" for client grant type
	Set token.Username=""
	
	// Set default properties
	Do ..AddClaimValues(token,clientId,clientId)
	
	Quit 1
}

/// Add iss, sub, exp and aud to ClaimValues and client_id to CustomProperties if they are not already set.
ClassMethod AddClaimValues(token As OAuth2.Server.AccessToken, clientId As %String, sub As %String) [ Internal ]
{
	// Set client_id property if it is not already set
	If token.Properties.CustomProperties.GetAt("client_id")="" {
		Do token.Properties.CustomProperties.SetAt(token.ClientId,"client_id")
	}

	// Set Issuer property if it is not already set
	If token.Properties.GetClaimValue("iss")="" {
		Do token.Properties.SetClaimValue("iss",token.Issuer)
	}
	
	// Set Username property if it is not already set
	If token.Properties.GetClaimValue("sub")="" {
		Do token.Properties.SetClaimValue("sub",sub)
	}
	
	// Set aud property if available
	Set count=$select(token.Aud="":0,1:token.Aud.Count())
	If count>0,token.Properties.GetClaimValue("aud")="" {
		If count=1 {
			Set aud=token.Aud.GetAt(1)
		} ElseIf count>1 {
			Set aud=""
			For i=1:1:count {
				Set aud=aud_$lb(token.Aud.GetAt(i))
			}
		}
		Do token.Properties.SetClaimValue("aud",aud)
	}
}

/// Finished authorization.  Prepare for response.
ClassMethod PrepareResponse(token As OAuth2.Server.AccessToken) As %Status [ Internal, ServerOnly = 1 ]
{
	Set sc=$$$OK
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:PrepareResponse]","")
	
	// Create Access token if implicit grant type
	If token.GrantType="I" {
		Set sc=..GenerateAccessToken(token)
	}
	
	If $$$ISOK(sc) {
		// Save token
		Set token.Stage=""
		Set sc=token.Save()
	}

	If $$$SysLogLevel>=7 {
		Do ##class(%OAuth2.Utils).LogServerScope("Set ScopeArray-saved",token)
	}
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Auth:PrepareResponse]",1,sc)
	Quit sc
}

/// Execute GenerateAccessToken callback.
/// Optionally also obtain the IDToken.
ClassMethod GenerateAccessToken(token As OAuth2.Server.AccessToken) As %Status [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GenerateAccessToken]","namespace="_%server.CustomizationNamespace_", roles="_%server.CustomizationRoles_",$roles="_$roles)

	// Swizzle Properties before changing namespace
	Set properties=token.Properties
	
	Set sc=$$$OK
	Set responseType=" "_token.ResponseType_" "

	// Set expires as late as possible
	Set token.AccessTokenExpires=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,%server.AccessTokenInterval)
	Do properties.SetClaimValue("exp",token.AccessTokenExpires,"number")

	// Generate access token if required
	If (token.GrantType'="I") || (responseType[" token ") {
		New %client
		Set %client=##class(OAuth2.Server.Client).Open(token.ClientId,.sc)
		If $$$ISOK(sc) {
			Set accessToken = ..GenerateAccessTokenCustomization(properties,.sc)
		}
		If $$$ISERR(sc) {
			Set accessToken=""
		} ElseIf accessToken="" {
			Set sc=$$$ERROR($$$OAuth2GenerateError)
		} Else {
			Set token.AccessToken=accessToken
		}
	}
	
	/// Generate IDToken if required.
	If $$$ISOK(sc),token.IsOpenID(),(token.GrantType="A") || (responseType[" id_token ") {
		Set IDToken=##class(OAuth2.Server.OpenID).CreateIDToken(token,.sc)
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GenerateAccessToken]","IDToken="_IDToken)
		If $$$ISOK(sc) Set token.IDToken=IDToken
	}

	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Auth:GenerateAccessToken]",1,sc)
	Quit sc
}

ClassMethod GenerateAccessTokenCustomization(properties As %OAuth2.Server.Properties, Output pSC As %Status) As %String [ Internal, ServerOnly = 1 ]
{
	New $namespace,$roles
	Set $namespace=%server.CustomizationNamespace
	Set $roles=%server.CustomizationRoles
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GenerateAccessToken]","$roles="_$roles)
	
	Set accessToken=$classmethod(%server.GenerateTokenClass,"GenerateAccessToken",properties,.pSC)
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:GenerateAccessToken]","accessToken="_accessToken)
	
	Quit accessToken
}

/// Return error as redirected response
ClassMethod ReturnError(client As OAuth2.Server.Client, token As OAuth2.Server.AccessToken, error As %String, errorDescription As %String, sc As %Status) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ReturnError]","error="_error_", errorDescription="_$get(errorDescription)_", sc="_$select($get(sc)'="":$system.Status.GetErrorText(sc),1:""))
	Set url=token.RedirectURL
	Set sep=$select(token.ResponseMode="query":"?",1:"#")
	Set url=url_$select(url[sep:"&",1:sep)

	Set url=url_"error="_..EscapeURL(error)
	If $$$ISERR($get(sc,$$$OK)) {
		Set errorDescription=$get(errorDescription)_" internal error="_$system.Status.GetErrorText(sc)
	}
	If $get(errorDescription)'="" {
		Set url=url_"&error_description="_..EscapeURL(errorDescription)
	}
	
	// Include state in response
	If token.State'="" {
		Set url=url_"&state="_..EscapeURL(token.State)
	}
	
	Set %response.Redirect=url
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:ReturnError]",url)
}

/// Setup redirect for done
ClassMethod RedirectResponse(client As OAuth2.Server.Client, token As OAuth2.Server.AccessToken) [ Internal, ServerOnly = 1 ]
{
	Set url=token.RedirectURL
	Set sep=$select(token.ResponseMode="query":"?",1:"#")
	Set url=url_$select(url[sep:"&",1:sep)

	If token.GrantType="A" {
		// Authorization Code
		Set url=url_"code="_..EscapeURL(token.AuthorizationCode)
		Set url=url_"&state="_..EscapeURL(token.State)
		Set %response.Redirect=url
		// Set expires as late as possible
		Set token.AuthorizationCodeExpires=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,%server.AuthorizationCodeInterval)
		
	} ElseIf token.GrantType="I" {
		// Implicit
		If token.AccessToken'="" {
			Set url=url_"access_token="_..EscapeURL(token.AccessToken)
			Set url=url_"&token_type=bearer"
		}
		If token.IDToken'="" {
			Set url=url_"&id_token="_..EscapeURL(token.IDToken)
		}
		Set url=url_"&expires_in="_%server.AccessTokenInterval
		Set url=url_"&scope="_..EscapeURL(token.Scope)
		Set url=url_"&state="_..EscapeURL(token.State)
		Set key=""
		For {
			Set value=token.Properties.ResponseProperties.GetNext(.key)
			If key="" Quit
			Set url=url_"&"_..EscapeURL(key)_"="_..EscapeURL(value)
		}
		Set %response.Redirect=url
		If token.RefreshToken'="" {
			Set token.RefreshTokenExpires=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,%server.RefreshTokenInterval)
		}
		Set token.AuthorizationCodeExpires=0
		// Set expires property if it is not already set
		If token.Properties.GetClaimValue("exp")="" {
			Do token.Properties.SetClaimValue("exp",token.AccessTokenExpires,"number")
		}
		
	} Else {
		Do ..ReturnError(client,token,"server_error")
	}
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Auth:RedirectResponse]","url="_url)
}

}
