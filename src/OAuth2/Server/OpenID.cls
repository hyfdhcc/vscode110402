/// The authorization server supports the OpenId Connect specification.
/// The OAuth2.Server.OpenID class is a helper class which contains the OpenID functionality.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Server.OpenID Extends %RegisteredObject [ System = 4 ]
{

/// Is this an OpenID authorization request?  Find out by looking for openid scope.
ClassMethod IsOpenID(scope As %String) As %Boolean [ CodeMode = expression ]
{
((" "_scope_" ")[" openid ")
}

/// Add claims that are based on scopes.
/// Always add default claims.
ClassMethod AddScopeClaims(token As OAuth2.Server.AccessToken) [ Internal ]
{
	Set scope=""
	If token.ResponseType="id_token" {
		// If no access token is returned, return claims in IDToken
		Set claims=token.Properties.IDTokenClaims
	} Else {
		// If access token is returned, return claims from userinfo endpoint
		Set claims=token.Properties.UserinfoClaims
	}

	If token.ScopeArray.IsDefined("profile") {
		Do claims.SetAt("","name")
		Do claims.SetAt("","family_name")
		Do claims.SetAt("","given_name")
		Do claims.SetAt("","middle_name")
		Do claims.SetAt("","nickname")
		Do claims.SetAt("","preferred_username")
		Do claims.SetAt("","profile")
		Do claims.SetAt("","picture")
		Do claims.SetAt("","website")
		Do claims.SetAt("","gender")
		Do claims.SetAt("","birthdate")
		Do claims.SetAt("","zoneinfo")
		Do claims.SetAt("","locale")
		// updated_at is time in seconds since the Unix epoch.
		Do claims.SetAt("","updated_at")
	}
	
	If token.ScopeArray.IsDefined("email") {
		Do claims.SetAt("","email")
		Do claims.SetAt("","email_verified")
	}
	
	If token.ScopeArray.IsDefined("address") {
		Do claims.SetAt("","address")
	}
	
	If token.ScopeArray.IsDefined("phone") {
		Do claims.SetAt("","phone_number")
		Do claims.SetAt("","phone_number_verified")
	}
}

/// The additional properties that are required for OpenID.
ClassMethod AddRequiredClaims(json As %DynamicObject, token As OAuth2.Server.AccessToken) [ Internal ]
{
	Do json.%Set("iss",token.Properties.GetClaimValue("iss"),"string")
	Do json.%Set("sub",token.Properties.GetClaimValue("sub"),"string")
	Do json.%Set("exp",token.Properties.GetClaimValue("exp"),"number")
	Do json.%Set("auth_time",token.Properties.GetClaimValue("auth_time"),"number")

	// Set time of token creation
	Set iat=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
	Set json.iat=iat
	
	Set nonce=token.Properties.RequestProperties.GetAt("nonce")
	If nonce'="" Set json.nonce=nonce
	
	Set json."at_hash"=..Hash(%server.SigningAlgorithm,token.AccessToken)
	
	Do ..SetAudClaim(json,token)
	Set json.azp=token.ClientId
}

/// Set the aud claim for the JSON object
ClassMethod SetAudClaim(json As %DynamicObject, token As OAuth2.Server.AccessToken) [ Internal ]
{
	Set clientId=token.ClientId
	
	Set count=$select(token.Aud="":0,1:token.Aud.Count())
	
	If count=0 {
		Do json.%Set("aud",clientId,"string")
	} ElseIf count=1 {
		Set aud=token.Aud.GetAt(1)
		If aud=clientId {
			Do json.%Set("aud",aud,"string")
		} Else {
			Set array=##class(%DynamicArray).%New()
			Do array.%Set(0,aud,"string")
			Do array.%Set(1,clientId,"string")
			Do json.%Set("aud",array)
		}
	} Else {
		Set array=##class(%DynamicArray).%New()
		Set found=0
		For i=1:1:count {
			Set aud=token.Aud.GetAt(i)
			if aud=clientId Set found=1
			Do array.%Set(i-1,aud,"string")
		}
		if 'found Do array.%Set(count,clientId,"string")
		Do json.%Set("aud",array)
	}
}

/// Compute the token hash
ClassMethod Hash(alg As %String, tokenString As %String) As %String
{
	// IDToken must be signed to be able to hash access token
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.OpenID:Hash]","sigalg="_alg)
	If alg="" Quit ""
	
	// Hash with thee bitlength based on signing algorithm
	Set bitlength=$extract(alg,3,5)
	Set binaryHash=$system.Encryption.SHAHash(bitlength,tokenString)
	
	// base64url encode the left half of the hash and return
	Quit ##class(%OAuth2.Utils).Base64UrlEncode($extract(binaryHash,1,bitlength/16))
}

/// Add the additional properties that are needed for the IDToken
/// Create an IDToken based on token properties.
/// We assume %server is the server configuration.
ClassMethod CreateIDToken(token As OAuth2.Server.AccessToken, Output sc As %Status) As %String
{
	#dim %server As OAuth2.Server.Configuration

	Try {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.OpenID:CreateIDToken]","")

		// Create object containing claims required by OpenID Connect
		Set json=##class(%DynamicObject).%New()
		
		// Add required claims
		Do ..AddRequiredClaims(json,token)
		
		// Add claims from IDTokenClaims in %OAuth2.Server.Properties.
		Do ##class(%OAuth2.Server.JWT).AddClaims(token.Properties.IDTokenClaims,token.Properties,json)

		// Create JWT
		Set JWT=##class(%OAuth2.Server.JWT).CreateJWT(token,json,.sc)

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) {
		Set JWT=""
		Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.OpenID:CreateIDToken]",1,sc)
	}
	Quit JWT
}

/// Validate validates the signed OpenID Connect ID token and creates an object to reflect the JWT properties.
/// Validate also validates the access token based on the at_hash property of the IDToken.
/// The applicationName argument is the name of the client or resource server configuration which
/// contains authorization server access data, such as authorization server ServerCredentials.
/// The scope argument is a blank separated list of scope values.  If scope is specified,
/// the acces token must have an associated scope which is a superset of the scope parameter.<br>
/// The aud argument specifies the audience which is using the token.  If the token has an associated aud property
/// (usually because the audience was specified when requesting the token), then aud is matched to
/// the token audience.  If aud is not specified, then no audience checking takes place.<br>
/// The claims in the JSON object are returned in jsonObject as a Cache object.<br>
/// securityParameters - Array of Strings that was used to set the JSON Object Signature and/or Encryption operations to be performed on the JWT<br>
/// <br>
/// See %OAuth2.JWT for the list of supported algorithms.<br>
/// For JSON Web Signature (JWS):<br>
/// securityParameters("sigalg") - Signature or MAC algorithm.<br>
/// For JSON Web Encryption (JWE):<br>
/// securityParameters("keyalg") - Key management algorithm<br>
/// Note, securityParameters("keyalg") and securityParameters("encalg") must both be specified or null.<br>
/// See %OAuth2.JWT for the list of supported algorithms.
ClassMethod Validate(applicationName As %String, IDToken As %String, accessToken As %String, scope As %String, aud As %String, Output jsonObject As %RegisteredObject, Output securityParameters As %String, Output sc As %Status) As %Boolean
{
	Set isValid=0
	Set err=""
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.OpenID:Validate]","IDToken="_IDToken_", accessToken="_accessToken_", scope="_$get(scope)_", aud="_$get(aud))

		// Find the client
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit
		
		// Convert JWT to an object		
		Set sc=##class(%SYS.OAuth2.Validation).JWTToObject(client,IDToken,.securityParameters,.jsonObject)
		If $$$ISERR(sc) Quit
		
		// IDToken must be signed
		If $get(securityParameters("sigalg"))="" {
			Set err="IDToken must be signed"
			Quit
		}
		
		// Validate the audience.  Validate against clientId if aud not specified.
		// Audience validation is required for OpenID Connect client.
		// If aud argument specified, validate that this is in the audience
		If $get(aud)'="" {
			If '..VerifyAudience(jsonObject.aud,$get(aud),client.ClientId) {
				Set err="IDToken is not valid for specified audience: "_aud
				Quit
			}
		}
		
		// Validate that the this client is in the audience
		If '..VerifyAudience(jsonObject.aud,client.ClientId,client.ClientId) {
			Set err="IDToken does not have this client as an audience"
			Quit
		}
		
		// Validate that azp claim is present if multiple audiences
		If $isobject(jsonObject.aud),jsonObject.azp="" {
			Set err="IDToken must have azp claim if it has multiple audiences"
			Quit
		}
		
		// If azp claim present then it must be client_id
		If jsonObject.azp'="",jsonObject.azp'=client.ClientId {
			Set err="If IDToken has azp claim, azp must equal client_id"
			Quit
		}
		
		// Validate that the IDToken has not expired
		Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
		If jsonObject.exp'="",jsonObject.exp<now {
			Set err="IDToken has expired"
			Quit
		}

		// Validate the issuer if specified
		If jsonObject.iss'="",jsonObject.iss'=client.ServerDefinition.IssuerEndpoint {
			Set err="IDToken has unexpected issuer: "_$get(jsonObject("iss"))
			Quit
		}
		
		// Check at_hash if it is specified.
		If $get(accessToken)'="",jsonObject."at_hash"'="",
		   jsonObject."at_hash"'=..Hash(securityParameters("sigalg"),accessToken) {
			Set err="IDToken is not associated with this access token"
			Quit
		}

		// Further checks are only possible on the requesting client.
		// Get token object
		Set token=##class(OAuth2.AccessToken).OpenByIDToken(IDToken,.sc)
		If $$$ISERR(sc) Quit
		If $isobject(token) {
			If jsonObject.nonce="" {
				// Must have nonce for implicit grant type
				If token.GrantType="I" {
					Set err="nonce must specified for implicit flow"
					Quit
				}
			} Else {
				// Check nonce matches nonce from request
				If jsonObject.nonce'=token.Nonce {
					Set err="Invalid nonce"
					Quit
				}
			}
			// Check scope
			If $get(scope)'="" {
				Set error=##class(%OAuth2.Utils).CheckScope(token.Scope,scope)
				If error'="" {
					Set err="Invalid scope"
					Quit
				}
			}
		}
		
		Set isValid=1
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISOK(sc),err'="" {
		Set sc=$$$ERROR($$$OAuth2IDTokenNotValid,err)
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.OpenID:Validate]",0,sc)
	
	Quit isValid
}

/// Verify audience from the JSON object (objectAudience) against the audience from the resource server
/// The resource server audience is the aud argument, or if aud="" the client_id.
ClassMethod VerifyAudience(objectAudience, aud As %String, clientId As %String) As %Boolean [ Internal ]
{
	$$$SysLog(3,"OAuth2","[OAuth2.Server.Token:VerifyAudience]","aud="_aud_", clientId="_clientId)
	
	Set matched=0
	$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Token:VerifyAudience]","objectAudience="_objectAudience)
	If objectAudience'="" {
		// Compare token's audience against client_id, if no aud argument.
		If aud="" Set aud=clientId

		If '$isobject(objectAudience) {
			// Compare single audience from JWT
			If objectAudience=aud Set matched=1
		} Else {
			// Compare aud argument against token's audience
			Set iterator=objectAudience.%GetIterator()
			While iterator.%GetNext(.key,.value) {
				If value=aud {
					Set matched=1
					Quit
				}
			}
		}
	} Else {
		// Handle case of no token audience
		Set matched=(aud="")
	}
	
	Quit matched
}

}
