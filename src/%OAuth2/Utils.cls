/// Utility methods for OAuth 2.0 support.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class %OAuth2.Utils Extends %RegisteredObject [ System = 4 ]
{

/// Encode binary value using base64url encoding
ClassMethod Base64UrlEncode(bin As %Binary) As %String [ CodeMode = expression ]
{
$translate($piece($system.Encryption.Base64Encode(bin,1),"=",1),"+/","-_")
}

/// Decode base64url encoded string
ClassMethod Base64UrlDecode(text As %String) As %Binary [ CodeMode = expression ]
{
$system.Encryption.Base64Decode($translate(text,"-_","+/")_$case($length(text)#4,0:"",2:"==",3:"="))
}

/// Convert $h value to seconds since start of the Unix epoch,<br>
/// time is $h value.<br>
/// interval is interval to be added in seconds.
ClassMethod TimeInSeconds(time As %String, interval As %Integer = 0) As %Integer [ Internal ]
{
	Quit (($piece(time,",")-47117)*86400+$piece(time,",",2)+interval)\1
}

/// Convert seconds since start of the Unix epoch to $h format.
ClassMethod TimeInH(time As %Integer) As %String [ Internal ]
{
	Set days=time\86400+47117
	Set seconds=time#86400
	Quit days_","_seconds
}

/// Check that scope is subset of valid scopes for this token
ClassMethod CheckScope(tokenScope As %String, scope As %String) As %OAuth2.Error
{
	If ##class(%SYS.OAuth2.AccessToken).IsScopeContained(tokenScope,scope) {
		Set error=""
	} Else {
		Set error=##class(%OAuth2.Error).%New("invalid_request","Invalid scope")
	}

	Quit error
}

/// Normalize scope
ClassMethod NormalizeScope(scope As %String) As %String [ Internal ]
{
	Quit $zstrip($translate(scope,$c(9,10,13,160),"    "),"<=>W")
}

/// Select the language for Authentication Class localization.<br>
/// uiLocales is the value of the ui_locales request parameter.<br>
/// The return value is the selected language code.<br>
/// Call looks like:  
///   Set language=##class(%OAuth2.Utils).SelectLanguage(properties.RequestProperties.GetAt("ui_locales"),domain)
ClassMethod SelectLanguage(uiLocales As %String, domain As %String) As %String
{
	// Normalize the acceptable language list.
	// Note that this list is in preference order.
	Set tags=$zcvt($zstrip($translate(uiLocales,$c(9,10,13,160),"    "),"<=>W"),"L")
	If tags="" Quit $$$SessionLanguage
	
	// Get the list of available language localizations.
	Set languageList=$$GetLanguages^%occMessages(domain,$select($extract(domain)="%":"+s",1:"-s"))
	For i=1:1:$listlength(languageList) {
		Set language($list(languageList,i))=""
	}
	
	// Search for exact match in preference order
	Set returnLanguage=""
	For i=1:1:$length(tags," ") {
		Set tag=$piece(tags," ",i)
		If $data(language(tag)) {
			// Best is exact match
			Set returnLanguage=tag
			Quit
		}
	}
	
	// Search for country match in preference order
	If returnLanguage="" {
		For i=1:1:$length(tags," ") {
			Set tag=$piece(tags," ",i)
			If tag["-",$data(language($piece(tag,"-",1))) {
				// OK to just match country
				Set returnLanguage=$piece(tag,"-",1)
				Quit
			}
		}
	}
	
	// Default to session language
	If returnLanguage="" Set returnLanguage=$$$SessionLanguage
	
	Quit returnLanguage
}

/// Get the default sessionId if none is specified.
ClassMethod GetDefaultSessionId(ByRef sessionId As %String) As %String [ Internal ]
{
	If $get(sessionId)="" {
		If $isobject($get(%session)) {
			Set sessionId=%session.SessionId
		} Else {
			Set sessionId="NOTCSP"
		}
	}
}

/// Output JSON object to the current device
ClassMethod ObjectToJSON(object As %DynamicAbstractObject) As %Status
{

	Try {
		Write object.%ToJSON()
		Set sc=$$$OK

	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	Quit sc
}

/// Log an OAuth 2.0 error
ClassMethod LogError(methodName As %String, server As %Boolean, sc As %Status, data As %String) [ Internal ]
{
	$$$SysLog(1,"OAuth2"_$select(server:"Server",1:""),methodName_"Error: "_$system.Status.GetErrorText(sc),.data)
}

/// Log details of HTTP request received by CSP
ClassMethod LogCSPRequest(methodName As %String, server As %Boolean) [ Internal ]
{
	If $$$SysLogLevel<3 Quit
	Set data="Content-Type: "_%request.ContentType
	Set data=data_", Secure: "_%request.Secure
	Set authorization=%request.GetCgiEnv("HTTP_AUTHORIZATION")
	If authorization'="" {
		Set data=data_", Authorization: "_authorization
	}
	Set name=""
	For {
		Set name=$order(%request.Data(name))
		If name="" Quit
		Set index=""
		For {
			Set index=$order(%request.Data(name,index),1,value)
			If index="" Quit
			If name="client_secret" Set value="*****"
			Set data(name,index)=value
		}
	}
	If %request.Content'="" {
		If $isobject(%request.Content) {
			Set data=data_", Content: "_%request.Content.Read()
		} Else {
			Set data=data_", Content: "_%request.Content
		}
	}
	If $$$SysLogLevel>=5 {
		Set name=""
		For {
			Set name=%request.NextCookie(name)
			If name="" Quit
			Set data("Cookie",name)=%request.GetCookie(name)
		}
		Set name="HTTP_"
		For {
			Set name=$order(%request.CgiEnvs(name),1,value)
			If $extract(name,1,5)'="HTTP_" Quit
			Set data("Header",name)=value
		}
	}
	$$$SysLog(3,"OAuth2"_$select(server:"Server",1:""),methodName_"CSP Request",.data)
}

/// Log details of HTTP request to be made
ClassMethod LogHTTPRequest(methodName As %String, server As %Boolean, httpRequest As %Net.HttpRequest, method As %String, url As %String, ByRef formData) [ Internal ]
{
	If $$$SysLogLevel<3 Quit

	Set data=method_": "_url
	Set data=data_", Content-Type: "_httpRequest.ContentType
	Set data("SSLConfiguration")=httpRequest.SSLConfiguration
	Set authorization=httpRequest.GetHeader("AUTHORIZATION")
	If authorization'="" {
		Set data=data_", Authorization: "_authorization
	}
	Set stream=##class(%GlobalCharacterStream).%New()
	Do httpRequest.OutputFormData(stream)
	Do stream.Rewind()
	Set data("-body-")=stream.Read()
	Set name=""
	For {
		Set name=$order(formData(name),1,value)
		If name="" Quit
		Set data(name)=value
	}
	$$$SysLog(3,"OAuth2"_$select(server:"Server",1:""),methodName_"HTTP Request",.data)
}

/// Log details of HTTP response
ClassMethod LogHTTPResponse(methodName As %String, server As %Boolean, httpRequest As %Net.HttpRequest) [ Internal ]
{
	If $$$SysLogLevel<3 Quit

	Set httpResponse=httpRequest.HttpResponse
	Set data="StatusCode="_httpResponse.StatusCode
	Set data=data_", ContentType="_httpResponse.ContentType
	Set data=data_",body="
	If $isobject(httpResponse.Data) {
		Set data=data_httpResponse.Data.Read()
	} Else {
		Set data=data_httpResponse.Data
	}
	If $$$SysLogLevel>=5 {
		Merge data=httpResponse.Headers
	}
	$$$SysLog(3,"OAuth2"_$select(server:"Server",1:""),methodName_"HTTP Response",.data)
}

/// Log a server token
ClassMethod LogServerToken(methodName As %String, token As OAuth2.Server.AccessToken) [ Internal ]
{
	If $$$SysLogLevel<3 Quit
	
	Set data("AuthorizationCode")=token.AuthorizationCode
	Set data("AccessToken")=token.AccessToken
	Set data("AccessTokenExpires")=token.AccessTokenExpires
	Set data("RefreshToken")=token.RefreshToken
	Set data("IDToken")=token.IDToken
	Set data("ClientId")=token.ClientId
	Set data("Scope")=token.Scope
	Do token.Properties.LogProperties(.data)
	If token.ScopeArray'="" {
		Set key=""
		For {
			Set value=token.ScopeArray.GetNext(.key)
			If key="" Quit
			Set data("ScopeArray",key)=value
		}
	}
	Set data("AuthorizationCodeExpires")=token.AuthorizationCodeExpires
	Set data("GrantType")=token.GrantType
	Set data("Stage")=token.Stage
	Set data("State")=token.State
	Set data("Username")=$select(token.Username=$char(0):"<NULL>",1:token.Username)
	Set data("Issuer")=token.Issuer
	If (token.Aud="") || (token.Aud.Count()=0) {
		Set data("Aud")=""
	} Else {
		For i=1:1:token.Aud.Count() {
			Set data("Aud",i)=token.Aud.GetAt(i)
		}
	}
	Set data("RedirectURL")=token.RedirectURL
	Set data("AuthTime")=token.AuthTime
	Set data("ResponseType")=token.ResponseType
	Set data("ResponseMode")=token.ResponseMode

	$$$SysLog(3,"OAuth2Server",methodName_": Access Token",.data)
}

/// Log a server token
ClassMethod LogServerScope(methodName As %String, token As OAuth2.Server.AccessToken) [ Internal ]
{
	If $$$SysLogLevel<3 Quit
	
	Set data("Scope")=token.Scope
	If token.ScopeArray'="" {
		Set key=""
		For {
			Set value=token.ScopeArray.GetNext(.key)
			If key="" Quit
			Set data("ScopeArray",key)=value
		}
	}

	$$$SysLog(3,"OAuth2Server",methodName_": Access Token Scope",.data)
}

/// Log the current session.
ClassMethod LogCurrentSesssion(methodName As %String)
{
	// Get the current session
	Set session=##class(OAuth2.Server.Session).GetCurrentSession(.sc)

	If $isobject(session) {
		// Log the session data
		Set data("Username")=session.Username
		Set data("Scope")=session.Scope
		Set data("AuthTime")=session.AuthTime
		$$$SysLog(3,"OAuth2Server",methodName_": Current session",.data)
	} Else {
		$$$SysLog(3,"OAuth2Server",methodName_": No current session",.data)
	}
}

/// Log a local array
ClassMethod LogArray(methodName As %String, server As %Boolean, desc As %String, ByRef array) [ Internal ]
{
	If $$$SysLogLevel<3 Quit
	
	Merge data=array

	$$$SysLog(3,"OAuth2"_$select(server:"Server",1:""),methodName_"Array "_desc,.data)
}

/// Log a JSON object
ClassMethod LogJSON(methodName As %String, server As %Boolean, desc As %String, json As %DynamicObject) [ Internal ]
{
	If $$$SysLogLevel<3 Quit

	Set iterator=json.%GetIterator()
	While iterator.%GetNext(.prop,.value) {
		Set data(prop)=value
	}

	$$$SysLog(3,"OAuth2"_$select(server:"Server",1:""),methodName_"JSON "_desc,.data)
}

/// Display ^%ISCLOG
ClassMethod DisplayLog(file As %String) [ Internal ]
{
	Try {
		do ##class(%File).Delete(file)
		Set open=0,io="",error=""
		Set io=$io
		Open file:"waes":1 else  Set error="Unable to open SOAP log file" Quit
		Set open=1
		Use file
		If $$$IsUnicode {
			// On Unicode systems, output the text in UTF-8.
			// On 8-bit systems, use the default file translate table.
			$$$SETIO("UTF8")
		}
		
		Set index=""
		For {
			Set index=$order(^%ISCLOG("Data",index),1,list)
			If index="" Quit
			
			Write "**",$listget(list,2),"-",$listget(list,1)," ",$listget(list,6)," ns=",$listget(list,5)
			Write " routine=",$listget(list,7)
			Set job=$listget(list,4)
			If job'="" Write " job=",job
			Set tag=$listget(list,8)
			If tag'="" Write " tag=",tag
			Set sessionid=$listget(list,9)
			If sessionid'="" Write " sessionid=",sessionid
			Write !,$listget(list,3),!
			If $data(^%ISCLOG("Data",index,0))=1 {
				Write ^%ISCLOG("Data",index,0),!
			} ElseIf $data(^%ISCLOG("Data",index,0))>=10 {
				Kill data
				Merge data=^%ISCLOG("Data",index,0)
				Zwrite data
			}
			Write !
		}
		
	} Catch ex {
		Set error="Error during SOAP logging: "_ex.DisplayString()
	}
	
	If open Close file
	If io'="" Use io

	If error'="" {
		Write !,"LOGGING ERROR: "_error,!
	}

	Quit
}

}
