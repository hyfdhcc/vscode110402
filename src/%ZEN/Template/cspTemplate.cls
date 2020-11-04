Class %ZEN.Template.cspTemplate Extends %CSP.Page [ Abstract, System = 4 ]
{

/// Ensure user has %Development:USE.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	Quit $system.Security.Check($$$DevelopmentResourceName,"USE")
}

}
