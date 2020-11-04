/// OAuth2.Server.Introspection implements the token inbtrospection endpoint as defined by RFC 7662
/// and the token revocation endpoint as defined by RFC 7009.
Class OAuth2.Server.Introspection Extends %RegisteredObject [ System = 4 ]
{

Parameter HTTP200OK As %String = "200 OK";

Parameter HTTP400BADREQUEST As %String = "400 Bad Request";

Parameter HTTP401UNAUTHORIZED As %String = "401 Unauthorized";

Parameter HTTP500INTERNALSERVERERROR As %String = "500 Internal Server Error";

// Process introspection request

ClassMethod ProcessIntrospection() As %Status [ Internal ]
{
	Try {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Introspection:ProcessIntrospection]","")

		// Common processing until token found.
		Set token=..Process(1,1,.error)
		If error'="" Quit

		Set tokenOK=$isobject(token)
		
		// Validate that the access token has not expired
		If tokenOK {
			Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
			If token.AccessTokenExpires'="",token.AccessTokenExpires<now {
				Set tokenOK=0
			}
		}
		
		// Create object containing claims
		Set json=##class(%DynamicObject).%New()

		// Return response		
		If 'tokenOK {
			// Return inactive response, if no valid active token
			Do json.%Set("active",0,"boolean")

		} Else {
			// Return active response plus claims
			Do json.%Set("active",1,"boolean")
		
			// Add required claims
			Do ..AddRequiredClaims(json,token)
			
			// Add claims for Introspection endpoint in %OAuth2.Server.Properties.
			Do ##class(%OAuth2.Server.JWT).AddClaims(token.Properties.IntrospectionClaims,token.Properties,json)
		}

		// Write the serialized json object
		Set sc=##class(%OAuth2.Utils).ObjectToJSON(json)
		If $$$ISERR(sc) {
			Set error=..StatusError(sc)
		}
			
	} Catch ex {
		Set sc=ex.AsStatus()
		Set error=..StatusError(sc)
	}
	
	If error'="" {
		Do ..ReturnError(error)
	}
	
	Quit $$$OK
}

// Process revocation request

ClassMethod ProcessRevocation() As %Status [ Internal ]
{
	Try {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Introspection:ProcessRevocation]","")

		// Common processing until token found.
		Set token=..Process(0,0,.error,.client)
		If error'="" Quit

		// Delete the token
		If $isobject(token) {
			// Validate that specified client issued code
			If token.ClientId'=client.ClientId {
				Set error=##class(%OAuth2.Error).%New("invalid_grant","Client did not issue this access token")
			} Else {
				Set sc=token.Delete()
				If $$$ISERR(sc) {
					Set error=..StatusError(sc)
				}
			}
		}
			
	} Catch ex {
		Set sc=ex.AsStatus()
		Set error=..StatusError(sc)
	}
	
	If error'="" {
		Do ..ReturnError(error)
	}
	
	Quit $$$OK
}

/// The common processing of introspection and recocation requests until token object is found
ClassMethod Process(requireTLS As %Boolean, requireConfidential As %Boolean, Output error As %String, Output client As OAuth2.Server.Client) As OAuth2.Server.AccessToken [ Internal ]
{
	Set error=""

	If $$$SysLogLevel>=3 {
		Do ##class(%OAuth2.Utils).LogCSPRequest("[OAuth2.Server.Introspection:Process]",1)
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
		Quit ""
	}
	If '$isobject(%server) {
		Set %response.Status=..#HTTP400BADREQUEST
		Set error=##class(%OAuth2.Error).%New("invalid_request","Server not configured")
		Quit ""
	}
	
	Set error=##class(OAuth2.Server.Token).Authorize(requireConfidential,.client,requireTLS)
	If error'="" Quit ""
	
	// Client_id must be specified
	If '$isobject(client) {
		Set error=##class(%OAuth2.Error).%New("invalid_client")
		Quit ""
	}
		
	// Check for duplicate request parameters
	Set error=##class(OAuth2.Server.Token).CheckDuplicate("token,token_type")
	If error'="" Quit ""

	// Token must be specified	
	If '$data(%request.Data("token",1),binaryToken) {
		Set error=##class(%OAuth2.Error).%New("invalid_request","token is required")
		Quit ""
	}

	// Find the token	
	If $get(%request.Data("token_type",1))="refresh_token" {
		// Look for refresh token first
		Set token=##class(OAuth2.Server.AccessToken).OpenByRefresh(binaryToken,.sc)
		If '$isobject(token) {
			Set token=##class(OAuth2.Server.AccessToken).OpenByToken(binaryToken,.sc)
		}
	} Else {
		// Look for access token first
		Set token=##class(OAuth2.Server.AccessToken).OpenByToken(binaryToken,.sc)
		If '$isobject(token) {
			Set token=##class(OAuth2.Server.AccessToken).OpenByRefresh(binaryToken,.sc)
		}
	}
	
	If $isobject(token) {
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogServerToken("[OAuth2.Server.Introspection:FindToken]",token)
		}
	}

	Quit token
}

/// The additional properties that are required for introspection endpoint.
ClassMethod AddRequiredClaims(json As %DynamicObject, token As OAuth2.Server.AccessToken) [ Internal ]
{
	Do json.%Set("scope",token.Scope,"string")
	Do json.%Set("client_id",token.ClientId,"string")
	Do json.%Set("username",token.Username,"string")
	Do json.%Set("token_type","bearer","string")

	Do json.%Set("exp",token.Properties.GetClaimValue("exp"),"number")
	If token.Properties.GetClaimValue("auth_time")'="" {
		Do json.%Set("iat",token.Properties.GetClaimValue("auth_time"),"number")
		Do json.%Set("nbf",token.Properties.GetClaimValue("auth_time"),"number")
	}

	Do json.%Set("sub",token.Properties.GetClaimValue("sub"),"string")
	If token.IsOpenID() {
		Do ##class(OAuth2.Server.OpenID).SetAudClaim(json,token)
	} ElseIf token.Properties.GetClaimValue("aud")'="" {
		Do json.%Set("aud",token.Properties.GetClaimValue("aud"),"string")
	}
	Do json.%Set("iss",token.Properties.GetClaimValue("iss"),"string")
}

/// Return an internal server error
ClassMethod StatusError(sc As %Status) As %OAuth2.Error [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Introspection:StatusError]",$system.Status.GetErrorText(sc))
	Set %response.Status=..#HTTP500INTERNALSERVERERROR
	Quit ##class(%OAuth2.Error).%New("server_error")
}

/// Return error response
ClassMethod ReturnError(error As %OAuth2.Error) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Introspection:ReturnError]","error="_error.Error_", error_description="_error.ErrorDescription)

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

	Set sc=##class(%OAuth2.Utils).ObjectToJSON(json)
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Introspection:ReturnError]",1,sc)
}

}
