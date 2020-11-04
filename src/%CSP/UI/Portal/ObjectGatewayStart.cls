/// Zen page for System Management Portal - Start Object Gateway Server
Class %CSP.UI.Portal.ObjectGatewayStart Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As BOOLEAN = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Object Gateway Activity";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.ObjectGatewayStart.zen";

Parameter HELPADDRESS = "Home,Configuration,Object Gateways,Start Object Gateway";

Parameter PARENTPAGE = "/csp/sys/mgr/%CSP.UI.Portal.ObjectGateways.zen";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

/// ID for edit. Object Name for this page.
Property PID As %String(ZENURL = "PID");

XData Style
{
<style type="text/css">
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<timer id="timer" ontimeout="zenPage.timeout();" timeout="0"/>
<html id="htmlResult" label="Please wait...result will show below:" OnDrawContent="DrawResult" seed=""></html>
<html><hr/></html>
<button id="btnDone" caption="Done" onclick="zenPage.doCancel();" disabled="true"/>
</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set ..lblTitle = $$$FormatText($$$Text("Start Object Gateway Server %1:"),..PID)

	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	Quit $$$Text("Start Object Gateway")
}

/// Used to draw title for this page. pHalpAddress is need to build the link for Help for this page.
ClassMethod DrawTitle1(pSeed As %String) As %Status
{
	Do %application.DrawTitle(%page.LocatorHeader_"^"_%page.HelpAddress)
	Quit $$$OK
}

ClientMethod timeout() [ Language = javascript ]
{
	var status = this.IsDone();
	if (status) {
		zenPage.getComponentById('btnDone').setDisabled(false);
	}
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if (this.PID == "") {
		alert($$$Text("Sorry! Object Gateway name is null!"));
		return;	
	}	
	var html = zenPage.getComponentById('htmlResult');
	html.setProperty('seed',this.PID);
	var timer = zenPage.getComponentById('timer');
	timer.setProperty('timeout',1000);
	timer.startTimer();
}

/// Start action and server method will pump out result.
Method DrawResult(seed As %String) As %Status
{
	If seed = "" Quit 1
	Set ^CacheTemp.ObjectGateway("Start") = seed
	Set tSC = ##class(%Net.Remote.Service).StartGateway(seed,1)
	If $$$ISERR(tSC) Write "<br>",$$$TextHTML("Object Gateway Server failed to Start:")_"<br>"_$ZCVT($System.Status.GetErrorText(tSC),"O","HTML")
	Set ^CacheTemp.ObjectGateway("Start") = ""
	Quit 1
}

/// Return 1 if start is done.
ClassMethod IsDone() As %Boolean [ ZenMethod ]
{
	If $G(^CacheTemp.ObjectGateway("Start")) = "" Quit 1
	Quit 0
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Configuration","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Object Gateways","%Utility")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen?PID="_..EscapeURL(..PID)_$S(NAMESPACE="":"",1:"&$NAMESPACE="_..EscapeURL(NAMESPACE)))
	Quit $$$OK
}

}
