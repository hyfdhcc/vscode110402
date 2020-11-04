/// OAuth2. ServerDefinition is a persistent class which defines an authorization server which
/// is available to this Cache instance for OAuth 2.0 client definition.
/// The authorization server definition may be used by multiple client application definitions.
Class OAuth2.ServerDefinition Extends %Persistent [ System = 4 ]
{

/// The server definition is indexed by hash to make IssuerEndpoint unique.
Index IssuerIndex On Hash [ Internal, Unique ];

/// The endpoint URL to be used to identify the authorization server.<br>
/// The default IssuerEndpoint is the TokenEndpoint not including the anything after the final "/".<br>
/// Required for all ClientTypes.<br>
Property IssuerEndpoint As %String(COLLATION = "EXACT", MAXLEN = 1024) [ Required ];

Method IssuerEndpointSet(issuerEndpoint As %String) As %Status [ Internal ]
{
	Set i%IssuerEndpoint=issuerEndpoint
	If issuerEndpoint="" {
		Set i%Hash=""
	} Else {
		Set i%Hash=$system.Encryption.SHAHash(512,issuerEndpoint)
	}
}

/// SHA512 hash of the IssuerEndpoint to be used only for indexing
Property Hash As %String(COLLATION = "EXACT", MAXLEN = 64) [ Internal ];

/// The endpoint URL to be used for to request an authorization code from the authorization server.<br>
/// Required if ClientType is public or confidential.<br>
/// Based on Authorization Server documentation.
Property AuthorizationEndpoint As %OAuth2.uri;

/// The endpoint URL to be used for to request an access token from the authorization server.<br>
/// Required for all ClientTypes.<br>
/// Based on Authorization Server documentation.
Property TokenEndpoint As %OAuth2.uri [ Required ];

/// The endpoint URL to be used for to make a userinfo request using an access token from the
/// authorization server for authorization
Property UserinfoEndpoint As %OAuth2.uri;

/// The endpoint URL to be used for to make a RFC 7662 based token introspection request
/// using the client_id and client_secret for authorization.
Property IntrospectionEndpoint As %OAuth2.uri;

/// The endpoint URL to be used for to make a RFC 7009 based token revocation request
/// using the client_id and client_secret for authorization.
Property RevocationEndpoint As %OAuth2.uri;

/// ServerCredentials is the alias of the %SYS.X509Credentials object which contains the server's certificate.
Property ServerCredentials As %String;

/// The clients that use this server defintion.
Relationship Clients As OAuth2.Client [ Cardinality = many, Inverse = ServerDefinition ];

Method %OnValidateObject() As %Status [ Internal, Private ]
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	
	Try {
		Set sc=$$$OK
		$$$SysLog(3,"OAuth2","[OAuth2.ServerDefinition:%OnValidateObject]","")
		// AuthorizationEndpoint, TokenEndpoint, ClientId and ClientSecret
		// are required for public or confidential clients.
		Set missing=""
		If ..IssuerEndpoint="" Set missing=missing_"IssuerEndpoint,"
		If ..AuthorizationEndpoint="" Set missing=missing_"AuthorizationEndpoint,"
		If ..TokenEndpoint="" Set missing=missing_"TokenEndpoint,"
		If missing'="" {
			Set sc=$$$ERROR($$$RequiredServerDefinitionProperties,$extract(missing,1,*-1))
			Quit
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.ServerDefinition:%OnValidateObject]",0,sc)
	Quit sc
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

/// List authorization servers available to client applications for SMP page
Query List() As %SQLQuery [ SqlProc ]
{
	SELECT ID, IssuerEndpoint,
		   ( SELECT COUNT(*) FROM Client WHERE ServerDefinition->ID = sd.ID ) AS ClientCount 
		FROM ServerDefinition as sd
 		ORDER BY IssuerEndpoint
}

Storage Default
{
<Data name="ServerDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IssuerEndpoint</Value>
</Value>
<Value name="3">
<Value>AuthorizationEndpoint</Value>
</Value>
<Value name="4">
<Value>TokenEndpoint</Value>
</Value>
<Value name="5">
<Value>UserinfoEndpoint</Value>
</Value>
<Value name="7">
<Value>ServerCredentials</Value>
</Value>
<Value name="8">
<Value>Hash</Value>
</Value>
<Value name="9">
<Value>IntrospectionEndpoint</Value>
</Value>
<Value name="10">
<Value>RevocationEndpoint</Value>
</Value>
</Data>
<DataLocation>^OAuth2.ServerDefinitionD</DataLocation>
<DefaultData>ServerDefinitionDefaultData</DefaultData>
<IdLocation>^OAuth2.ServerDefinitionD</IdLocation>
<IndexLocation>^OAuth2.ServerDefinitionI</IndexLocation>
<StreamLocation>^OAuth2.ServerDefinitionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
