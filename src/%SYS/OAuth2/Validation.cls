/// The %SYS.OAuth2.Validation class defines the methods used to validate (or invalidate) an access token.<br><br>
/// 
/// The underlying token is stored in OAuth2.AccessToken in the CACHESYS database.
/// OAuth2.AccessToken is indexed by the combination of SessionId and ApplicationName.
/// Therefore, only one scope may be requested for each SessionId/ApplicationName.
/// If a second request is made with a different scope and access token has yet been granted,
/// the scope in the new request becomes the expected scope.<br>
/// Note that this class is in CACHELIB and thus available everywhere.
/// However, token storage storage is in CACHESYS and thus not difrectly available to most code.
Class %SYS.OAuth2.Validation Extends %RegisteredObject [ System = 4 ]
{

/// ValidateJWT validates the signed JWT token and creates an object to reflect the JWT properties.
/// The applicationName argument is the name of the client or resource server configuration which
/// contains authorization server access data, such as authorization server ServerCredentials.
/// The scope argument is a blank separated list of scope values.  If scope is specified,
/// the JWT must contain a scope claim which is a superset of the scope parameter.<br>
/// The aud argument specifies the audience which is using the token.  If the token has an associated aud property
/// (usually because the audience was specified when requesting the token), then aud is matched to
/// the token audience.  If aud is not specified, then no audience checking takes place.<br>
/// The claims in the JSON object are returned in jsonObject as a Cache object.<br>
/// securityParameters - Array of Strings that was used to set the JSON Object Signature and/or Encryption operations to be performed on the JWT<br>
/// <br>
/// For JSON Web Signature (JWS):<br>
/// securityParameters("sigalg") - Signature or MAC algorithm<br>
/// <br>
/// For JSON Web Encryption (JWE):<br>
/// securityParameters("keyalg") - Key management algorithm<br>
/// securityParameters("encalg") - Content encryption algorithm<br>
/// Note, securityParameters("keyalg") and securityParameters("encalg") must both be specified or null.<br>
/// See %OAuth2.JWT for the list of supported algorithms.
ClassMethod ValidateJWT(applicationName As %String, accessToken As %String, scope As %String, aud As %String, Output jsonObject As %RegisteredObject, Output securityParameters As %String, Output sc As %Status) As %Boolean
{
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Set isValid=0
	Set err=""
	
	Try {
		$$$SysLog(3,"OAuth2","[%SYS.OAuth2.Validation:ValidateJWT]","accessToken="_accessToken_", scope="_$get(scope)_", aud="_$get(aud))

		// Find the client
		Set client=##class(OAuth2.Client).Open(applicationName,.sc)
		If client="" Quit

		// Convert JWT to an object		
		Set sc=..JWTToObject(client,accessToken,.securityParameters,.jsonObject)
		If $$$ISERR(sc) Quit

		// Validate the audience.
		If $get(aud)'="",'##class(OAuth2.Server.OpenID).VerifyAudience(jsonObject.aud,aud,client.ClientId) {
			Set err="Access token is not valid for this audience"
			Quit
		}
		
		// Validate that the access token has not expired
		Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
		If jsonObject.exp'="",jsonObject.exp<now {
			Set err="Access token has expired"
			Quit
		}

		// Validate the issuer if specified
		If jsonObject.iss'="",jsonObject.iss'=client.ServerDefinition.IssuerEndpoint {
			Set err="Access token has invalid issuer"
			Quit
		}
		
		// Check scope
		If $get(scope)'="" {
			Set token=##class(OAuth2.AccessToken).Open(accessToken,.sc)
			If $$$ISERR(sc) Quit
			If $isobject(token) {
				Set error=##class(%OAuth2.Utils).CheckScope(token.Scope,scope)
				If error'="" {
					Set err="Invalid scope"
					Quit
				}
			} Else {
				Set err="Scope check may only be done on requesting client."
				Quit
			}
		}
		
		Set isValid=1
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISOK(sc),err'="" {
		Set sc=$$$ERROR($$$OAuth2JWTNotValid,err)
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.Validation:ValidateJWT]",0,sc)
	
	Quit isValid
}

/// ValidateIDToken validates the signed OpenID Connect ID token and creates an object to reflect the JWT properties.
/// ValidateIDToken also validates the access token based on the at_hash property of the IDToken.
/// The applicationName argument is the name of the client or resource server configuration which
/// contains authorization server access data, such as authorization server ServerCredentials.
/// The scope argument is a blank separated list of scope values.  If scope is specified,
/// the access token must have an associated scope which is a superset of the scope parameter.<br>
/// The aud argument specifies the audience which is using the token.  If the token has an associated aud property
/// (usually because the audience was specified when requesting the token), then aud is matched to
/// the token audience.  If aud is not specified, then no audience checking takes place.<br>
/// The claims in the JSON object are returned in jsonObject as a Cache object.<br>
/// securityParameters - Array of Strings that was used to set the JSON Object Signature and/or Encryption operations to be performed on the JWT<br>
/// <br>
/// For JSON Web Signature (JWS):<br>
/// securityParameters("sigalg") - Signature or MAC algorithm<br>
/// <br>
/// For JSON Web Encryption (JWE):<br>
/// securityParameters("keyalg") - Key management algorithm<br>
/// securityParameters("encalg") - Content encryption algorithm<br>
/// Note, securityParameters("keyalg") and securityParameters("encalg") must both be specified or null.<br>
/// See %OAuth2.JWT for the list of supported algorithms.
ClassMethod ValidateIDToken(applicationName As %String, IDToken As %String, accessToken As %String, scope As %String, aud As %String, Output jsonObject As %RegisteredObject, Output securityParameters As %String, Output sc As %Status) As %Boolean
{
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Quit ##class(OAuth2.Server.OpenID).Validate(applicationName,IDToken,.accessToken,.scope,.aud,.jsonObject,.securityParameters,.sc)
}

/// Wrapper function to setup JWTToObject calls.
ClassMethod JWTToObject(client As OAuth2.Client, token As %String, ByRef securityParameters As %String, ByRef jsonObject As %RegisteredObject) As %Status
{
	// Setup the credentials for the client
	If client.ClientCredentials'="" {
		Set local("alias")=client.ClientCredentials
		If client.ClientPassword'="" Set local("password")=client.ClientPassword
	}
	
	// Setup the credentials for the server
	If client.ServerDefinition.ServerCredentials'="" {
		Set remote("alias")=client.ServerDefinition.ServerCredentials
	}
	
	Quit ##class(%OAuth2.JWT).JWTToObject(token,.local,.remote,.securityParameters,.jsonObject)
}

}
