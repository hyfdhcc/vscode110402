/// OAuth2.Server.REST acts as the router for REST requests to the authorization server.
/// The /oauth2/authorize is not really a REST endpoint since it uses redirection.  
/// Thus we special case the authorization endpoint.
Class OAuth2.Server.REST Extends %CSP.REST [ System = 4 ]
{

/// Specifies the character set to be used for all authorization server responses.
Parameter CHARSET = "utf-8";

/// Return JSON object.
Parameter CONTENTTYPE = "application/json";

/// Turn on CORS processing for the authorization server.
Parameter HandleCorsRequest = 1;

XData UrlMap
{
<Routes>

<Route Url="/token"					Method="GET"  Call="OAuth2.Server.Token:Process"/>
<Route Url="/token"					Method="POST" Call="OAuth2.Server.Token:Process"/>
<Route Url="/userinfo"				Method="GET"  Call="OAuth2.Server.Userinfo:Process"/>
<Route Url="/userinfo"				Method="POST" Call="OAuth2.Server.Userinfo:Process"/>
<Route Url="/introspection"			Method="GET" Call="OAuth2.Server.Introspection:ProcessIntrospection"/>
<Route Url="/introspection"			Method="POST" Call="OAuth2.Server.Introspection:ProcessIntrospection"/>
<Route Url="/revocation"			Method="POST" Call="OAuth2.Server.Introspection:ProcessRevocation"/>

</Routes>
}

/// We override the Page method in order to route the /oauth2/authorize URL
/// directly to the authorization endpoint.
ClassMethod Page(skipheader As %Boolean = 1) As %Status
{
	// GgiEnvs are not defined in the CSP shell
	Set url=$Get(%request.CgiEnvs("CSPLIB"))
	If url="" Set url=%request.URL
    
	// Ensure that any query string is not taken into account
	Set url=$Piece(url,"?")
      
	// Extract the match url from the application name
	Set matchUrl="/"_$extract(url,$length(%request.Application)+1,*)
	
	// If special /authorize URL, just invoke the authorize page.
	If matchUrl="/authorize" {
		Quit ##class(OAuth2.Server.Auth).Page(skipheader)
	}
	
	// Otherwise just continue on with the REST dispatch
	Quit ##super(skipheader)
}

}
