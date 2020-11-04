/// Created using the page template: Default
Class %CSP.UI.Portal.SQL.QButtons.ReportLoaderOutput Extends %CSP.Page [ ProcedureBlock, System = 4 ]
{

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.SQL.QButtons.ReportLoaderOutput.zen";

/// Set this to the correct domain.
Parameter DOMAIN = "%Utility";

/// Ensure user has %Development:USE
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	Quit $system.Security.Check($$$DevelopmentResourceName,"USE")
}

/// The <method>OnPage()</method> is called by the CSP dispatcher to generate the
/// page content. For %CSP.StreamServer, since the content type is actually a stream, not HTML
/// we simply write out the stream data.
ClassMethod OnPage() As %Status
{
	Set filename = $Get(%request.Data("FILENAME",1))
	&html<<html>
	<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="#(..Link("/csp/sys/csputils.css"))#" title="Standard Style" >
	</head><body>>
	Write "<p>",$$$FormatText($$$Text("Loading File %1: "),$zconvert(filename,"O","HTML")),"</p>"
	Do %response.Flush()
	Write "<pre>"
	Set namespace = $Get(%request.Data("$NAMESPACE",1))
	Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
	Set tSC = ##class(%SQL.Manager.QButtons.Base).ConsumeReport(filename,"ckd",1,namespace)
	Kill EscapeObj
	Write "<p>",$$$TextHTML("Done"),"</p>"
    Write "</pre>"
    &html<</body></html>>
    Quit $$$OK
}

}
