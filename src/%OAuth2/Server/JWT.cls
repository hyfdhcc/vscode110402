/// The %OAuth2.Server.JWT is the GenerateTokernClass which creates a JWT which is included with the server.
/// The GenerateTokenClass is specified in the Authorization Server Configuration.
/// It must contain a GenerateAccessToken method will be used to generate an access token based
/// on the array of properties that is returned by the ValidateUser method.
Class %OAuth2.Server.JWT Extends %RegisteredObject [ System = 4 ]
{

/// The GenerateAccessToken method returns an optionally signed and/or encryypted JWT to be used
/// as an access token.  The access token may be based on the properties argument.
/// In addition values for claims to be added to the JSON response object may be returned in the
/// properties.ResponseProperties array.<br>
/// However the method in this default class just returns a JWT which is optionally signed and/or encrypted.
ClassMethod GenerateAccessToken(properties As %OAuth2.Server.Properties, Output sc As %Status) As %String
{
	#dim %server As OAuth2.Server.Configuration

	Try {
		$$$SysLog(3,"OAuth2Server","[%OAuth2.Server.JWT:GenerateAccessToken]","")

		// Create object containg claims required by IHE IUA supplement
		Set json=##class(%DynamicObject).%New()
		Do json.%Set("jti",properties.GetClaimValue("iss")_"."_##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(20)),"string")
		Do json.%Set("iss",properties.GetClaimValue("iss"),"string")
		Do json.%Set("sub",properties.GetClaimValue("sub"),"string")
		Do json.%Set("exp",properties.GetClaimValue("exp"),"number")
		Set aud=properties.GetConvertedClaimValue("aud",.type)
		If aud'="" {
				Do json.%Set("aud",aud,"string")
		}
		
		// Add Claims from JWTClaims in %OAuth2.Server.Properties.
		Do ..AddClaims(properties.JWTClaims,properties,json)

		// Create JWT
		Set JWT=..CreateJWT("",json,.sc)

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Set JWT=""
	Quit JWT
}

/// Create JWT based on JSON object containing the claims.  
/// Any signing an encryption takes place here.
ClassMethod CreateJWT(token As OAuth2.Server.AccessToken, json As %RegisteredObject, Output sc As %Status) As %String
{
	#dim %server As OAuth2.Server.Configuration

	// Setup JWT parameters
	If %server.SigningAlgorithm'="" {
		Set JOSE("sigalg")=%server.SigningAlgorithm
		Set local("alias")=%server.ServerCredentials
		If %server.ServerPassword'="" Set local("password")=%server.ServerPassword
		$$$SysLog(3,"OAuth2Server","[%OAuth2.Server.JWT:CreateJWT]","Signing alg="_JOSE("sigalg")_", credentials="_local("alias"))
	}
	If (%server.EncryptionAlgorithm'="") || (%server.KeyAlgorithm'="") {
		Set JOSE("keyalg")=%server.KeyAlgorithm
		Set JOSE("encalg")=%server.EncryptionAlgorithm
		If $isobject(token) {
			Set client=##class(OAuth2.Server.Client).Open(token.ClientId,.sc)
			If $$$ISERR(sc) Quit
		} Else {
			Set client=%client
		}
		Set remote("alias")=client.ClientCredentials
		$$$SysLog(3,"OAuth2Server","[%OAuth2.Server.JWT:CreateJWT]","Encryption alg=("_JOSE("keyalg")_","_JOSE("encalg")_"), credentials="_remote("alias"))
	}
	
	// Create JWT
	Set sc=##class(%OAuth2.JWT).ObjectToJWT(.JOSE,json,.local,.remote,.JWT)
	$$$SysLog(3,"OAuth2Server","[%OAuth2.Server.JWT:CreateJWT]","JWT="_$get(JWT))
	
	Quit JWT
}

/// Add requested claims to the JWT
ClassMethod AddClaims(claims As %ArrayOfObjects, properties As %OAuth2.Server.Properties, json As %DynamicObject)
{
	Set name=""
	For {
		Set name=claims.Next(name)
		If name="" Quit

		Set value=properties.GetConvertedClaimValue(name,.type)
		If value="" Continue

		If type="array" {
			// Cannot specify type for an array value
			Do json.%Set(name,value)
		} ElseIf type="object" {
			Set $property(json,name)=value
		} Else {
			Do json.%Set(name,value,type)
		}
	}
}

}
