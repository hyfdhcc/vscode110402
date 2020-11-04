/// The OAuth2.Application class describes an OAuth2 client and references the Authorization server
/// that it uses to authorize the application based on RFC 6749.
/// A client system may be used with multiple authorization servers for different applications.<br>
Class OAuth2.Client Extends %Persistent [ System = 4 ]
{

/// The IDKEY for the application class.
Index IDIndex On ApplicationName [ IdKey, Unique ];

/// The ApplicationName identifies this application (clien + authorization server) configuration.<br>
/// Chosen by user during configuration.
Property ApplicationName As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// True if client application is enabled.<br>
/// Chosen by user during configuration.
Property Enabled As %Boolean [ InitialExpression = 1, Required ];

/// Description of the application.<br>
/// Chosen by user during configuration.
Property Description As %String(MAXLEN = 256);

/// The type of client configuration:<br>
/// public - a public client.  See RFC 6749
/// confidential - a confidential client.  See RFC 6749
/// resource - a resource server which is not also a client.<br>
/// Chosen by user during configuration.  Will usually be confidential client for Cache application.
Property ClientType As %String(VALUELIST = ",public,confidential,resource") [ Required ];

/// The name of the activated TLS/SSL configuration to use for authorization server requests.<br>
/// Chosen by user during configuration.
Property SSLConfiguration As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The endpoint object for the URL to be used by the authorization server to return the response to an authorization request.<br>
/// Required if ClientType is public or confidential,
/// Chosen by user during configuration.
Property RedirectionEndpoint As OAuth2.Endpoint;

/// The default scope, as a blank separated list, for access token requests.<br>
/// Chosen by user during configuration.
Property DefaultScope As %String(MAXLEN = 1024);

/// The type of authentication (as specified in RFC 6749) to be used for HTTP requests to the authorization server.
/// As specified in RFC 6749:  none, basic or body.
/// Based on Authorization Server documentation.
Property AuthenticationType As %String(VALUELIST = ",none,basic,body") [ InitialExpression = "basic", Required ];

/// The client id that is supplied during client registration.<br>
/// Required for all ClientTypes.
Property ClientId As %String(MAXLEN = 1024) [ Required ];

/// The client secret that is supplied during client registration.<br>
/// Required if ClientType is confidential or resource server.
Property ClientSecret As %String(MAXLEN = 1024);

/// ClientCredentials is the alias of the %SYS.X509Credentials object which contains the client's
/// certificate and private key.
Property ClientCredentials As %String;

/// ClientPassword is the password for the private key in ClientCredentials if the password is not in the %SYS.X5009Credentials object
Property ClientPassword As %String(MAXLEN = 128);

/// SigningAlgorithm specifies the signing algorithm used to create JWSs or "" if JWTs are not to be signed.
/// See %OAuth2.JWT for the list of supported algorithms.
Property SigningAlgorithm As %String(VALUELIST = ",RS256,RS384,RS512");

/// EncryptionAlgorithm specifies the encryption algorithm used to create JWEs or "" if JWTs are not to be encrypted.
/// See %OAuth2.JWT for the list of supported algorithms.
/// If EncryptionAlgorithm is specified, KeyAlgorithm must also be specified.
Property EncryptionAlgorithm As %String(VALUELIST = ",A128CBC-HS256,A192CBC-HS384,A256CBC-HS512");

/// KeyAlgorithm specifies the key management algorithm used to create JWEs or "" if JWTs are not to be encrypted.
/// See %OAuth2.JWT for the list of supported algorithms.
/// If KeyAlgorithm is specified, EncryptionAlgorithm must also be specified.
Property KeyAlgorithm As %String(VALUELIST = ",RSA1_5,RSA-OAEP");

/// ServerDefinition is the reference to the OAuth2.ServerDefinition object which describes
/// the authorization server to be used for this client.
Relationship ServerDefinition As OAuth2.ServerDefinition [ Cardinality = one, Inverse = Clients ];

/// Open an OAuth2.Client instance based on the applicationName ID property
ClassMethod Open(applicationName As %String, Output sc As %Status) As OAuth2.Client
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"
	
	Try {
		Set client=##class(OAuth2.Client).%OpenId(applicationName,,.sc)
		If '$isobject(client) || $$$ISERR(sc) Quit
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set client=""		
	Quit client
}

Method %OnValidateObject() As %Status [ Internal, Private ]
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	
	Try {
		Set sc=$$$OK
		$$$SysLog(3,"OAuth2","[OAuth2.Client:%OnValidateObject]","")
		// RedirectionEndpoint, AuthorizationEndpoint, TokenEndpoint, ClientId and ClientSecret
		// are required for public or confidential clients.
		Set missing=""
		If $case(..ClientType,"confidential":1,"public":1,:0) {
			If ..RedirectionEndpoint.Host="" Set missing=missing_"RedirectionEndpoint,"
			If ..SSLConfiguration="" Set missing=missing_"SSLConfiguration,"
			If ..ClientId="" Set missing=missing_"ClientId,"
		}
		If ..ClientType="confidential",..ClientSecret="" {
			Set missing=missing_"ClientSecret,"
		}
		If missing'="" {
			Set sc=$$$ERROR($$$RequiredClientProperties,$extract(missing,1,*-1))
			Quit
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Client:%OnValidateObject]",0,sc)
	Quit sc
}

/// This callback method is invoked when the current object is added to the SaveSet,
/// either because %Save() was invoked on this object or on an object that references this object.
/// %OnAddToSaveSet can modify the current object. It can also add other objects to the current
/// SaveSet by invoking %AddToSaveSet or remove objects by calling %RemoveFromSaveSet.
/// 
/// <P>If this method returns an error status then %Save() will fail and the transaction
/// will be rolled back.
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Internal, Private, ServerOnly = 1 ]
{
	// Normalize DefaultScope to be single blank separated list
	If ..DefaultScope'="" {
		Set ..DefaultScope=##class(%OAuth2.Utils).NormalizeScope(..DefaultScope)
	}
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal ]
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	Quit $$$OK
}

/// List client applications for SMP page
Query List() As %SQLQuery [ SqlProc ]
{
	SELECT ApplicationName, ClientType, DefaultScope FROM Client
 		ORDER BY ApplicationName
}

/// List client applications that use the sppecified server
Query ListForServer(serverID As %String) As %SQLQuery [ SqlProc ]
{
	SELECT ApplicationName, ClientType, DefaultScope FROM Client
		WHERE ServerDefinition->ID=:serverID
 		ORDER BY ApplicationName
}

Storage Default
{
<Data name="ClientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Enabled</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ClientType</Value>
</Value>
<Value name="5">
<Value>SSLConfiguration</Value>
</Value>
<Value name="6">
<Value>RedirectionEndpoint</Value>
</Value>
<Value name="7">
<Value>DefaultScope</Value>
</Value>
<Value name="8">
<Value>AuthenticationType</Value>
</Value>
<Value name="12">
<Value>ClientId</Value>
</Value>
<Value name="13">
<Value>ClientSecret</Value>
</Value>
<Value name="16">
<Value>ClientCredentials</Value>
</Value>
<Value name="17">
<Value>ClientPassword</Value>
</Value>
<Value name="19">
<Value>ServerDefinition</Value>
</Value>
<Value name="20">
<Value>SigningAlgorithm</Value>
</Value>
<Value name="21">
<Value>EncryptionAlgorithm</Value>
</Value>
<Value name="22">
<Value>KeyAlgorithm</Value>
</Value>
</Data>
<DataLocation>^OAuth2.ClientD</DataLocation>
<DefaultData>ClientDefaultData</DefaultData>
<IdLocation>^OAuth2.ClientD</IdLocation>
<IndexLocation>^OAuth2.ClientI</IndexLocation>
<StreamLocation>^OAuth2.ClientS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
