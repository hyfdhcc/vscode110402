/// The OAuth2.Server.Session class is the default SessionClass which is included with the server.
/// The default class will use httpOnly cookies to maintain the session.<br>
/// The SessionClass is specified in the Authorization Server Configuration.
/// The SessionClass must contain GetUser, Update, Login and Logout methods with signatures as specified in this class.<br>
Class OAuth2.Server.Session Extends %Persistent [ System = 4 ]
{

/// The name of the cookie used to maintain the session
Parameter COOKIENAME As STRING = "CSPOAuth2Session";

/// The IDKEY for the session class.
Index CookieIndex On Cookie [ IdKey, Unique ];

/// The session is indexed by the Username
Index UserIndex On Username;

/// Order by time
Index ExpiresIndex On Expires;

/// Cookie that is used to track the session.	
Property Cookie As %String(COLLATION = "EXACT", MAXLEN = 128) [ Required ];

/// User that is logged in by this session.
Property Username As %String(COLLATION = "EXACT");

/// Expires is the time in seconds from beginning of the Unix epoch when the session expires.
/// If Expires="", then session does not expire.
Property Expires As %Integer;

/// Scope is the blank separated list of scopes permitted for this user in this session.
Property Scope As %String(MAXLEN = 1024);

/// The time when the user was authenticated.
Property AuthTime As %Integer;

/// The GetUser method returns the name of the user currently logged into this session.
/// If no session exists, then "" is returned.
ClassMethod GetUser(Output scope As %String, authTime As %Integer, Output sc As %Status) As %String
{
	Set sc=$$$OK
	Set username=""
	Set scope=""
	
	Try {
		// Get the current session
		Set session=..GetCurrentSession(.sc)

		// Return username if session found
		If $isobject(session) {
			Set username=session.Username
			Set scope=session.Scope
			Set authTime=session.AuthTime
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	Quit username
}

/// The Update method updates the existing current session.
/// The blank separated list of scopes in the scope argument updates the scopes associated with the session.
/// If the interval argument is specified the session interval is updated.
/// The interval argument is seconds until expiration for the session.
/// If interval=0, then the session will not expire.
ClassMethod Update(scope As %String, interval As %Integer) As %Status
{
	Set sc=$$$OK

	Try {
		// Try to update an existing session
		Set session=..GetCurrentSession(.sc)
		If $isobject(session) {
			Set session.Scope=scope
			If $data(interval) {
				If +interval=0 {
					Set session.Expires=""
				} Else {
					Set session.Expires=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,interval)
				}
			}
			// Save the session object		
			Set sc=session.%Save()
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}

	Quit sc
}

/// The Login method creates a new session for the user named by username.<br>
/// The scope argument specifies a blank separated list of scopes that this user is authorized for.
/// The interval argument is seconds until expiration for the session.
/// If interval=0, then the session will not expire.
ClassMethod Login(username As %String, scope As %String, interval As %Integer, Output authTime As %Integer) As %Status
{
	Set sc=$$$OK

	Try {
		// Create a new session object
		Set session=..%New()
		Set session.Cookie=..MakeCookieValue()
		Set session.Username=username
		Set session.Scope=scope
		Set authTime=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
		Set session.AuthTime=authTime
		If +interval=0 {
			Set session.Expires=""
		} Else {
			Set session.Expires=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,interval)
		}

		// Save the session object		
		Set sc=session.%Save()
		
		// Set the cookie into the user agent.
		If $$$ISOK(sc) Do ..SetCookie(session.Cookie,session.Expires)

	} Catch ex {
		Set sc=ex.AsStatus()
	}

	Quit sc
}

/// The Logout method terminates the current session.
/// It is not considered an error to have no current session.
ClassMethod Logout()
{

	Set loginCookie=..GetCookie()
	If loginCookie'="" {
		// zap any current Login Cookie by setting expire time to now - 60 seconds
		Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,-60)
		Do ..SetCookie(loginCookie,now)

		// Delete the session object
		Set session=..OpenByCookie(loginCookie)
		If $isobject(session) Do session.Delete()
	}
}

/// An overridable method to create a new cookie value.
/// This allows easy change of the cookie format.
ClassMethod MakeCookieValue() As %String
{
	Quit ##class(%OAuth2.Utils).Base64UrlEncode($system.Encryption.GenCryptRand(32))
}

/// An overridable method to obtain the cookie.  This allows easy change of the cookie format.
ClassMethod GetCookie() As %String
{
	// First cleanup expired sessions
	Do ..Cleanup()
	
	Quit $get(%request.Cookies(..#COOKIENAME,1),"")
}

/// Set the cookie.
ClassMethod SetCookie(value As %String, expires As %Integer)
{
	If expires'="" {
		Set h=##class(%OAuth2.Utils).TimeInH(expires)
		Set time  = $ztime($piece(h,",",2),1)
		Set date  = $translate($zdate(h,2)," ","-")
		Set wkday = $zdate(h,12)
		Set expireDate = wkday_", "_date_" "_time_" GMT"
	} Else {
		Set expireDate=""
	}
	Set path=##class(OAuth2.Server.Configuration).GetCSPApplication(1)_"/"

	Do %response.SetCookie(..#COOKIENAME,value,expireDate,path,,1,1)
}

/// The GetCurrentSession method returns the currently logged in session.
/// If no session exists, then "" is returned.
ClassMethod GetCurrentSession(Output sc As %Status) As OAuth2.Server.Session [ Internal ]
{
	Set sc=$$$OK
	Set session=""
	
	Try {
		// Get the session cookie
		Set loginCookie=..GetCookie()
		
		// If no cookie, then return "".
		If loginCookie="" Quit
		
		// Open the session object
		Set session=..OpenByCookie(loginCookie,.sc)
		
		// If no session object, then return ""
		If '$isobject(session) Quit
		
		// If expired, then delete session object and return "".
		Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)
		If session.Expires'="",session.Expires<now {
			Set sc=session.Delete()
			Set session=""
		}
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set session=""		
	Quit session
}

/// Open the OAuth2.Server.Session instance using Cookie.
ClassMethod OpenByCookie(cookie As %String, Output sc As %Status) As OAuth2.Server.Session [ Internal ]
{
	Set sc=$$$OK
	
	Try {
		Set session=..%OpenId(cookie,,.sc)
		If $$$GETERRORCODE(sc)=$$$ERRORCODE($$$LoadObjectNotFound) {
			Set sc=$$$OK
			Set session=""
		}
	} Catch ex {
		Set sc=ex.AsStatus()
	}

	If $$$ISERR(sc) Set session=""		
	Quit session
}

/// Delete this session object
Method Delete() As %Status [ Internal ]
{
	Try {
		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Session:Delete]","Delete for Cookie="_..Cookie_", Username="_..Username)
		Set sc=..%Delete(.."%%OID")
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	Quit sc
}

/// Clean up all expired sessions
ClassMethod Cleanup() [ Internal, Private ]
{
	Set now=##class(%OAuth2.Utils).TimeInSeconds($ztimestamp,0)

	// Loop over expired sessions and delete them
	&sql(DECLARE SESSION CURSOR FOR 
		SELECT Cookie, Username INTO :cookie, :username FROM OAuth2_Server.Session
		WHERE Expires IS NOT NULL AND Expires < :now)
	&sql(OPEN SESSION)

	For {
		&sql(FETCH SESSION)
		If SQLCODE'=0 Quit

		$$$SysLog(3,"OAuth2Server","[OAuth2.Server.Session:Cleanup]","Delete for Cookie="_cookie_", Username="_username)
		Do ..%DeleteId(cookie)
	}

	&sql(CLOSE SESSION)
}

Storage Default
{
<Data name="SessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Cookie</Value>
</Value>
<Value name="3">
<Value>Username</Value>
</Value>
<Value name="4">
<Value>Expires</Value>
</Value>
<Value name="5">
<Value>Scope</Value>
</Value>
<Value name="6">
<Value>AuthTime</Value>
</Value>
</Data>
<DataLocation>^OAuth2.Server.SessionD</DataLocation>
<DefaultData>SessionDefaultData</DefaultData>
<IdLocation>^OAuth2.Server.SessionD</IdLocation>
<IndexLocation>^OAuth2.Server.SessionI</IndexLocation>
<StreamLocation>^OAuth2.Server.SessionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
