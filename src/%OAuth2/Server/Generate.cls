/// The %OAuth2.Server.Generate is the default GenerateTokernClass which is included with the server.
/// The default class will generate a random string as the opaque access token.<br>
/// The GenerateTokenClass is specified in the Authorization Server Configuration.
/// It must contain a GenerateAccessToken method will be used to generate an access token based
/// on the array of properties that is returned by the ValidateUser method.
Class %OAuth2.Server.Generate Extends %RegisteredObject [ System = 4 ]
{

/// The GenerateAccessToken method returns an access token.
/// The access token may be based on the properties argument.
/// In addition values for claims to be added to the JSON response object may be returned in the
/// properties.ResponseProperties array.<br>
/// However the method in this default class just returns an opaque random string.
ClassMethod GenerateAccessToken(properties As %OAuth2.Server.Properties, Output sc As %Status) As %String
{
	Set sc=$$$OK
	Quit ##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(64))
}

}
