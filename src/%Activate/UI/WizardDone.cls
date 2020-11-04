/// Activate Wizard 
Class %Activate.UI.WizardDone Extends %CSP.Page [ System = 4 ]
{

Parameter DOMAIN = "%ZEN";

Parameter PAGENAME = "Activate Wizard Result";

/// Ensure user has %Development:USE
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	Quit $system.Security.Check($$$DevelopmentResourceName,"USE")
}

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
	Set SelectedRows = $G(%session.Data("ActivateWizard","SelectedRows"))
	Set PackageName = $G(%session.Data("ActivateWizard","PackageName"),"Activate")
	Set ShowDetails = +$G(%session.Data("ActivateWizard","ShowDetails"))
	Set NAMESPACE = $G(%session.Data("ActivateWizard","NAMESPACE"))
	If NAMESPACE '= $ZU(5) ZN NAMESPACE
	&html<<html>
	<head>
	<title>#($$$Text("Activate Wizard Result"))#</title>
	<link rel="stylesheet" type="text/css" href="#(..Link("/csp/sys/intersystems.css"))#">
	
	<style type="text/css">
	.body {
		padding:10px;
		font-family: Verdana, Arial, Helvetica, sans-serif;
	}
	</style>
	</head>
	<body onload="self.focus();">>
	&html<<form style="margin-left:10px;margin-right:10px;padding-top:2px;"><div>#($$$TextHTML("Package Name"))#: #(PackageName)#</div>>
	&html<<div id="idMessage">#($$$TextHTML("Please wait..."))#</div>>
	&html<<pre>>
	Set m = ##class(%Activate.TLEnumerator).%New()
	Set len = $listlength(SelectedRows)
	For row = 1:1:len
	{
		Set path = $lg(SelectedRows,row)
		If path '= "" {
			Write !," --------------------- ",$ZCVT($$$FormatText($$$Text("Now Processing %1"),path),"O","HTML")," ---------------------"
			Do %response.Flush()
			Set gvDummy = m.LoadTypeLibrary(path, PackageName,"/displaylog="_ShowDetails)
			Do %response.Flush()
		}		
	}
	Write !,$ZCVT($$$FormatText($$$Text(" Finished at %1"),$zdt($h)),"O","HTML")
	Kill %session.Data("ActivateWizard","SelectedRows")
	&html<</pre>>
	&html<</form>>
	&html<<script language="javascript">
	document.getElementById("idMessage").innerHTML = '';
	</script>>
	&html<</body></html>>
	Quit $$$OK
}

/// Draw HTML for the page title
ClassMethod DrawTitle(pSeed As %String) As %Status
{
	Set pSeed = $$$Text("Activate Wizard Result")
	Do ##class(%Activate.UI.Wizard).DrawTitle(pSeed)
	Quit $$$OK
}

}
