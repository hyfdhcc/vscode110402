Include (%occUtility, %DeepSee)

/// This class provides the API for DeepSee sessions.
/// An instance of this class represents the current session.
Class %DeepSee.Session Extends %RegisteredObject [ System = 3 ]
{

/// Id for this session.
Property sessionId As %String;

/// Create a new DeepSee session.
/// If <var>pSessionId</var> is provided, then it used,
/// otherwise $J is used.
ClassMethod %CreateSession(pSessionId As %String = "", Output pSC As %Status) As Session
{
	Set pSC = $$$OK
	Set tSession = ..%New()
	If '$IsObject(tSession) {
		Set pSC = $G(%objlasterror)
		Quit ""
	}
	If (pSessionId = "") {
		Set pSessionId = $J
	}
	Set tSession.sessionId = pSessionId
	Do tSession.%EndSession()
	Set $$$DeepSeeSessionGLVN(pSessionId,"start") = $ZDT($H,3)
	Set %DeepSeeSession = tSession
	Quit tSession
}

/// Terminate this DeepSee session and remove all definitions
/// associated with it.
Method %EndSession() As %Status
{
	If (..sessionId'="") {
		Kill $$$DeepSeeSessionGLVN(..sessionId)
	}
	Kill %DeepSeeSession
	Quit $$$OK
}

/// Resume a previously running session.
ClassMethod %ResumeSession(pSessionId As %String = "", Output pSC As %Status) As Session
{
	Set pSC = $$$OK
	Set tSession = ..%New()
	If '$IsObject(tSession) {
		Set pSC = $G(%objlasterror)
		Quit ""
	}
	If (pSessionId = "") {
		Set pSessionId = $J
	}
	Set tSession.sessionId = pSessionId
	Set %DeepSeeSession = tSession
	Quit tSession
}

/// Suspend the currently running session.
Method %SuspendSession() As %Status
{
	Set ..sessionId = ""
	Kill %DeepSeeSession
	Quit $$$OK
}

/// Get the session ID for this session.
Method %GetSessionId() As %Status
{
	Quit ..sessionId
}

Method %OnNew() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Quit ##class(%DeepSee.Utils).%RunServerInitCode()
}

Method %OnClose() As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	If (..sessionId'="") {
		Do ..%EndSession()
	}
	Quit $$$OK
}

}
