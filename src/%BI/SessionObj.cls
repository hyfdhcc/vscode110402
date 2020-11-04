Class %BI.SessionObj Extends %CSP.SessionEvents [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

ClassMethod OnEndSession()
{
 j RemSession^%bi.SMr.Session(%session.%Id())
 d trackLogout^%bi.SWr.WebLogin(1)
 Quit
}

/// Called when the CSP Daemon times out out this session before calling <method>EndSession</method>.
/// Use the %session object to examine this session. If you wish to
/// abort this deletion then:
/// <example>
/// Set %session.EndSession=0
/// </example>
ClassMethod OnTimeout()
{
 j RemSession^%bi.SMr.Session(%session.%Id())
 d trackLogout^%bi.SWr.WebLogin(2)
 Quit
}

/// Called when a new session is created and its values are initialised.
ClassMethod OnStartSession()
{
 Quit
}

}
