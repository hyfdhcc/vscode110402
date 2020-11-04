/// OAuth2.JWTServer is a simple CSP page to return JWT specified by request.
Class OAuth2.JWTServer Extends %CSP.Page [ System = 4 ]
{

ClassMethod OnPage() As %Status
{
	Try {
		// request query parameter is IDKey of %SYS.OAuth2.Request
		Set requestKey=..UnescapeURL($get(%request.Data("request",1)))
		$$$SysLog(3,"OAuth2Server","[OAuth2.JWTServer:OnPage]","requestUri="_requestKey)
		If requestKey'="" {
			// Open request object
			Set requestObject=##class(%SYS.OAuth2.Request).%OpenId(requestKey,,.sc)

			// Return JWT if correct key
			If $isobject(requestObject) {
				Set %response.ContentType="application/jwt"
				Set %response.CharSet=""
				Write requestObject.JWT
			}
		}
	} Catch ex {
		Set sc=ex.AsStatus()
		Do ##class(%OAuth2.Utils).LogError("[OAuth2.JWTServer:OnPage]",0,sc)
	}
	
	Quit $$$OK
}

}
