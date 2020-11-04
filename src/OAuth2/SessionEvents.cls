/// The override of %CSP.SessionEvents to allow us to clean up access tokens that are linked to the session
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class.
Class OAuth2.SessionEvents Extends %CSP.SessionEvents [ System = 4 ]
{

/// Called when the session is about to be deleted, either because of a timeout (in which case
/// <method>OnTimeout</method> is called first) or because the application
/// has explicitly closed this session. Use the %session object to examine this session. If you wish to
/// abort this deletion then:
/// <example>
/// Set %session.EndSession=0
/// </example>
ClassMethod OnEndSession()
{
	Set sc=$$$OK
	Set sessionId=%session.SessionId
	$$$SysLog(3,"OAuth2","[OAuth2.SessionEvents:OnEndSession]","SessionId="_sessionId_", roles="_$roles)
	$$$AddAllRoleTemporary
	
	Try {
		// Call the Zen OnEndSession to make sure to cleanup Zen sessions
		Do ##class(%ZEN.Controller).OnEndSession()

		// Delete any access tokens linked to this session
		// Open all tokens for this session
		&sql(DECLARE TOKEN CURSOR FOR SELECT ID INTO :id FROM OAuth2.AccessToken WHERE SessionId = :sessionId)
		&sql(OPEN TOKEN)
		For {
			&sql(FETCH TOKEN)
			If SQLCODE'=0 Quit
			// open token
			Set token=##class(OAuth2.AccessToken).%OpenId(id,,.sc)
			If $isobject(token) {
				$$$SysLog(3,"OAuth2","[OAuth2.SessionEvents:OnEndSession]","Remove AccessToken="_token.AccessToken)
				Set client=##class(OAuth2.Client).Open(token.ApplicationName,.sc)
				If $isobject(client),client.ServerDefinition.RevocationEndpoint'="" {
					// If the issuing server has a revocation endpoint, also invalidate on server.
					Set sc=##class(%SYS.OAuth2.AccessToken).RevokeToken(token.ApplicationName,token.AccessToken)
				}
				// Remove token
				Do token.Remove()
			}
		}
		&sql(CLOSE TOKEN)
		
	} Catch ex {
		Set sc=ex.AsStatus()
	}
	
	If $$$ISERR(sc) Do ##class(%OAuth2.Utils).LogError("[%SYS.OAuth2.SessionEvents:OnEndSession]",0,sc)
}

}
