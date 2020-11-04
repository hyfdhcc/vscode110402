/// OAuth2.Server.Configuration is a persistent class which describes the clients
/// which have registered with this authorization server.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.Server.Client Extends %Persistent [ System = 4 ]
{

/// The IDKEY for the client configuration class.
Index ClientIndex On ClientId [ IdKey, Unique ];

/// Index to insure uniqueness of name
Index NameIndex On Name [ Unique ];

/// The unique id which we generate for this client.
Property ClientId As %String(MAXLEN = 1024, MINLEN = 1) [ Required ];

/// ClientSecret is the secret which is used as a client password.
Property ClientSecret As %String(MAXLEN = 1024);

/// Arbitrary name of client
Property Name As %String [ Required ];

/// RedirectURL is the expected redirect URL for this client.
Property RedirectURL As list Of %String(MAXLEN = 1024);

/// LaunchURL is the URL used to launch this client.
/// LaunchURL may be used in some circumstances to identify the client and as the value of the aud claim.
Property LaunchURL As %String(MAXLEN = 1024);

/// DefaultScope is a blank separated list containing the default for access token scope
/// if scope is not specified in the access token request.
Property DefaultScope As %String(MAXLEN = 1024);

/// SupportedGrantTypes is the grant types that are supported to create an access token.
/// This property is a string of 1 to 4 characters with one character for each supported grant type as follows:<br>
/// - "A" - Authorization Code
/// - "I" - Implicit
/// - "P" - Resource Owner Password Credentials
/// - "C" - Client Credentials
Property SupportedGrantTypes As %String(MAXLEN = 4, MINLEN = 1);

/// Description of the client.<br>
/// Chosen by user during configuration.
Property Description As %String(MAXLEN = 256);

/// The type of client configuration:<br>
/// public - a public client.  See RFC 6749
/// confidential - a confidential client.  See RFC 6749
/// resource - a resource server which is not also a client.<br>
/// Chosen by user during configuration.  Will usually be confidential client for Cache application.
Property ClientType As %String(VALUELIST = ",public,confidential,resource") [ Required ];

/// ClientCredentials is the alias of the %SYS.X509Credentials object which contains the client's certificate.
Property ClientCredentials As %String;

/// client_name is the name of the Client to be presented to the EndUser.
Property "client_name" As %String(MAXLEN = 128);

/// logo_uri is a URL that references a logo for the Client application.
/// If present, the authorization server will display this image to the EndUser during approval.
/// The value of this field must point to a valid image file.
Property "logo_uri" As %OAuth2.uri;

/// client_uri is the URL of the home page of the Client.
/// The value of this field must point to a valid Web page.
/// If present, the authorization server will display this URL to the EndUser in a followable fashion.
Property "client_uri" As %OAuth2.uri;

/// policy_uri is the that the Relying Party Client provides to the EndUser to
/// read about the how the profile data will be used.
/// The value of this field must point to a valid web page.
Property "policy_uri" As %OAuth2.uri;

/// tos_uri is the URL that the Relying Party Client provides to the EndUser to
/// read about the Relying Party's terms of service.
/// The value of this field must point to a valid web page.
Property "tos_uri" As %OAuth2.uri;

/// Get a new OAuth2.Server.Client instance with a newly generated ClientId and ClientSecret.
Method %OnNew() As %Status [ Internal, Private ]
{
	Set ..ClientId=##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(32))
	Set ..ClientSecret=##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(64))
	Quit $$$OK
}

/// Open the OAuth2.Server.Client instance.
ClassMethod Open(clientId As %String, Output sc As %Status) As OAuth2.Server.Client
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Set sc=$$$OK
	
	Try {
		Set client=..%OpenId(clientId,,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$LoadObjectNotFound) {
			Set sc=$$$OK
			Set client=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set client=""		
	Quit client
}

/// Save this OAuth2.Server.Client instance.
Method Save() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Try {
		Set sc=..%Save()
	} Catch ex {
		Set sc=ex.AsStatus()
	}
		
	Quit sc
}

/// Delete this client configuration.
Method Delete() As %Status
{
	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}

	Try {
		Set sc=..%Delete(.."%%OID")
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	Quit sc
}

Method %OnValidateObject() As %Status [ Internal, Private ]
{
#define GetHost(%uri) $piece($piece($piece(%uri,"://",2,*),"/",1),":")

	If '$system.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
		Quit $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
	}
	
	Try {
		Set sc=$$$OK
		$$$SysLog(3,"OAuth2","[OAuth2.Server.Client:%OnValidateObject]","")
		
		If ..ClientType'="resource" {
			// At least one redirect URL must be specified
			Set count=..RedirectURL.Count()
			If count<1 {
				Set sc=$$$ERROR($$$OAuth2RedirectURINeeded)
				Quit
			}
			
			// RedirectURLs must be an absolute https or http URI
			For i=1:1:count {
				Set redirect=..RedirectURL.GetAt(i)
				If $extract(redirect,1,8)'="https://",$extract(redirect,1,7)'="http://" {
					Set sc=$$$ERROR($$$OAuth2RedirectURI,redirect)
					Quit
				}
				Set host(i)=$$$GetHost(redirect)
			}
			If $$$ISERR(sc) Quit
			
			// Check URLs to display on permissions screen
			Set uris("logo_uri")=$this."logo_uri"
			Set uris("client_uri")=.."client_uri"
			Set uris("policy_uri")=.."policy_uri"
			Set uris("tos_uri")=.."tos_uri"

			Set name=""
			For {
				Set name=$order(uris(name),1,uri)
				If name="" Quit
				
				If uri="" Continue
				
				Set found=0
				If ($extract(uri,1,8)="https://") || ($extract(uri,1,7)="http://") {
					For i=1:1:count {
						If host(i)=$$$GetHost(uri) Set found=1 Quit
					}
				}

				If 'found {
					Set fullname=$case(name,"logo_uri":"Logo","client_uri":"Client home page","policy_uri":"Policy","tos_uri":"Terms of service",:"")
					Set sc=$$$ERROR($$$OAuth2AuthURI,fullname_" URL",uri)
					Quit
				}
			}
			If $$$ISERR(sc) Quit
			
			// Grant Types must be a subset of server supported grant types.
			Set server=##class(OAuth2.Server.Configuration).Open(.sc)
			If $$$ISERR(sc) Quit
			If '$isobject(server) {
				Set sc=$$$ERROR($$$OAuth2NoConfiguration)
				Quit
			}
			Set allGrants=server.SupportedGrantTypes
			For i=1:1:$length(..SupportedGrantTypes) {
				If allGrants'[$extract(..SupportedGrantTypes,i) {
					Set sc=$$$ERROR($$$OAuth2GrantTypes,..SupportedGrantTypes)
					Quit
				}
			}
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[OAuth2.Server.Client:%OnValidateObject]",0,sc)
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

/// List client registrations for SMP page
Query List() As %SQLQuery [ SqlProc ]
{
	SELECT Name, ClientId, ClientType, DefaultScope, Description FROM Client
 		ORDER BY Name
}

Storage Default
{
<Data name="ClientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClientSecret</Value>
</Value>
<Value name="3">
<Value>RedirectURL</Value>
</Value>
<Value name="4">
<Value>DefaultScope</Value>
</Value>
<Value name="5">
<Value>SupportedGrantTypes</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>ClientType</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>LaunchURL</Value>
</Value>
<Value name="10">
<Value>ClientCredentials</Value>
</Value>
<Value name="11">
<Value>logo_uri</Value>
</Value>
<Value name="12">
<Value>client_uri</Value>
</Value>
<Value name="13">
<Value>policy_uri</Value>
</Value>
<Value name="14">
<Value>tos_uri</Value>
</Value>
<Value name="15">
<Value>LogoUri</Value>
</Value>
<Value name="16">
<Value>ClientUri</Value>
</Value>
<Value name="17">
<Value>PolicyUri</Value>
</Value>
<Value name="18">
<Value>TosUri</Value>
</Value>
<Value name="19">
<Value>client_name</Value>
</Value>
</Data>
<DataLocation>^OAuth2.Server.ClientD</DataLocation>
<DefaultData>ClientDefaultData</DefaultData>
<IdLocation>^OAuth2.Server.ClientD</IdLocation>
<IndexLocation>^OAuth2.Server.ClientI</IndexLocation>
<StreamLocation>^OAuth2.Server.ClientS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
