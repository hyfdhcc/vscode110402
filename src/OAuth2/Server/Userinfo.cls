/// OAuth2.Server.Userinfo implements the OpenID Connect Userinfo endpoint.
Class OAuth2.Server.Userinfo Extends %RegisteredObject [ System = 4 ]
{

Parameter HTTP200OK As %String = "200 OK";

Parameter HTTP400BADREQUEST As %String = "400 Bad Request";

Parameter HTTP401UNAUTHORIZED As %String = "401 Unauthorized";

Parameter HTTP500INTERNALSERVERERROR As %String = "500 Internal Server Error";

ClassMethod Process() As %Status [ Internal, ServerOnly = 1 ]
{
	Try {
		Set error=""
		If $$$SysLogLevel>=3 {
			$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Userinfo:Process]","")
			Do ##class(%OAuth2.Utils).LogCSPRequest("[OAuth2.Server.Userinfo:Process]",1)
		}
		
		// Setup response
		Set %response.Status=..#HTTP200OK
		Do %response.SetHeader("Cache-Control","no-store")
		Do %response.SetHeader("Pragma","no-cache")

		// Server must be configured
		Set %server=##class(OAuth2.Server.Configuration).Open(.sc)
		If $$$ISERR(sc) {
			Do ..StatusError(sc)
			Quit
		}
		If '$isobject(%server) {
			Set %response.Status=..#HTTP400BADREQUEST
			Set error=##class(%OAuth2.Error).%New("invalid_request","Server not configured")
			Do ..ReturnError(error)
			Quit
		}
		
		// Get the access token from the request per RFC 6750
		Set accessToken=##class(%SYS.OAuth2.AccessToken).GetAccessTokenFromRequest(.sc)
		If $$$ISERR(sc) {
			// Log error
			Do ..StatusError(sc)
			Set %response.Status=..#HTTP401UNAUTHORIZED
			Set error=##class(%OAuth2.Error).%New("invalid_request","No access token in request")
			Do ..ReturnError(error)
			Quit
		}
		
		// Find the token object
		Set token=##class(OAuth2.Server.AccessToken).OpenByToken(accessToken,.sc)
		If $$$ISERR(sc) {
			Do ..StatusError(sc)
			Quit
		}
		If '$isobject(token) {
			Set %response.Status=..#HTTP401UNAUTHORIZED
			Set error=##class(%OAuth2.Error).%New("invalid_token","Token not found")
			Do ..ReturnError(error)
			Quit
		}
		
		If $$$SysLogLevel>=3 {
			Do ##class(%OAuth2.Utils).LogServerToken("[OAuth2.Server.Userinfo:Process]",token)
		}

		// Validate that the access token has not expired
		Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
		If token.AccessTokenExpires'="",token.AccessTokenExpires<now {
			Set %response.Status=..#HTTP401UNAUTHORIZED
			Set error=##class(%OAuth2.Error).%New("invalid_token","Access token has expired")
			Do ..ReturnError(error)
			Quit
		}
		
		// Create object containing claims
		Set json=##class(%DynamicObject).%New()
		
		// sub claim is required
		Set json.sub=token.Properties.GetClaimValue("sub")
		
		// If the response is signed, then include iss and aud claims
		If %server.SigningAlgorithm'="" {
			Set json.iss=token.Properties.GetClaimValue("iss")
			If token.IsOpenID() {
				Do ##class(OAuth2.Server.OpenID).SetAudClaim(json,token)
			} ElseIf token.Properties.GetClaimValue("aud")'="" {
				Do json.%Set("aud",token.Properties.GetClaimValue("aud"),"string")
			}
		}
		
		// Add claims from UserinfoClaims in %OAuth2.Server.Properties.
		Do ##class(%OAuth2.Server.JWT).AddClaims(token.Properties.UserinfoClaims,token.Properties,json)

		// If signed or encrypted, then return a JWT.  Otherwise return serialized JSON object
		If (%server.SigningAlgorithm'="") || (%server.EncryptionAlgorithm'="") || (%server.KeyAlgorithm'="") {
			// Create JWT
			Set JWT=##class(%OAuth2.Server.JWT).CreateJWT(token,json,.sc)
			If $$$ISERR(sc) {
				Do ..StatusError(sc)
				Quit
			}
			
			// Output JWT
			Set %response.ContentType="application/jwt"
			Set %response.CharSet=""
			Write JWT

		} Else {
			// Write the serialized json object
			Set %response.ContentType="application/json"
			Set %response.CharSet="utf-8"
			Set sc=##class(%OAuth2.Utils).ObjectToJSON(json)
			If $$$ISERR(sc) {
				Do ..StatusError(sc)
				Quit
			}
		}

	} Catch ex {
		Set sc=ex.AsStatus()
		Do ..StatusError(sc)
	}
	
	Quit $$$OK
}

/// Return an internal server error
ClassMethod StatusError(sc As %Status) [ Internal ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Userinfo:StatusError]",$system.Status.GetErrorText(sc))
	Set %response.Status=..#HTTP500INTERNALSERVERERROR
}

/// Return error response
ClassMethod ReturnError(error As %OAuth2.Error) [ Internal, ServerOnly = 1 ]
{
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Userinfo:ReturnError]","error="_error.Error_", error_description="_error.ErrorDescription)
	
	Set header="Bearer error="_error.Error_",error_description="_error.ErrorDescription
	Do %response.SetHeader("WWW-Authenticate",header)
}

}
