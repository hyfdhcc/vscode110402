/// System Management Portal - Enterprise Manager - Notifications
Class %CSP.UI.Portal.EMSNotifications Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/%CSP.UI.Portal.EMSNotifications.zen";

Parameter HELPADDRESS = "System,Enterprise Manager,Notifications";

/// Displayed name of this page.
Parameter PAGENAME = "Notifications";

Parameter PARENTPAGE = "/csp/sys/%CSP.UI.Portal.EMS.zen";

/// Localization Domain
Parameter DOMAIN = "%EMSMessages";

/// Security requirement
Parameter RESOURCE = "%Admin_Secure,%Admin_Manage";

Property DisableNewButton As %Boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css">
/* additional style for table pane */
table.tpTable th {
	border-right: 1px solid #F1F0E7;
	border-bottom: 1px solid #F1F0E7;
}

table.tpTable td {
	border-right: 1px solid #F1F0E7;
	border-bottom: 1px solid #F1F0E7;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px;padding-top:10px;">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<hgroup valign="top">
<vgroup valign="top">
<tablePane id="table" cellSpacing="2"
queryClass="EMS.Notification"
queryName="ListForInstance"
dataSource="columns"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="true"
valueColumn="ID"
>
<column colName="ID" hidden="true"/>
<column colName="CreatedAt" hidden="true"/>
<column colName="CreatedAtLocal" header="Time Sent"/>
<column colName="CreatedBy" header="From User"/>
<column colName="Message"/>
<column OnDrawCell="DrawClear"/>
 </tablePane>
 </vgroup>
</hgroup>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if (this.DisableNewButton) {
		this.disableCommandButton('btnNew');
	}
}

ClientMethod doNew() [ Language = javascript ]
{
	this.gotoPage('%25CSP.UI.Portal.EMSNotificationNew.zen');
}

ClientMethod doClear(notification) [ Language = javascript ]
{
	this.resetMsg();
	var result = this.Clear(notification);
	if (result.ok == 1) {
		zen('table').executeQuery();
	} else {
		this.showMsg(result.ErrorMessage,true);
	}
}

ClassMethod Clear(ID As %String) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""
	
	Try {
		Set tErr = ##class(EMS.Notification).Clear(ID)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw

		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method DrawClear(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	Set onclick = "zenPage.doClear('"_%query("ID")_"');"
	&html<<a href="#" onclick="#(onclick)#return false;">#($$$Text("Clear"))#</a>>
	Quit $$$OK
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..%GetComponentById("Text1").value = $$$Text("The following notifications have been received:")
	
	Set instance = ##class(EMS.Instance).Open(,.tErr)
	If ((instance = "") || (instance.State = $$$EMSCStateAwaitingAccept)) {
		Set ..DisableNewButton = 1
	}
	
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnNew",$$$Text("Send Notification"),$$$Text("Send a notification"),"zenPage.doNew();")

	Quit $$$OK
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $Get(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($Increment(pLink)) = $ListBuild(tPageName,tURL)

	Set tPageName = $$$Text("Enterprise Manager","%Utility")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($Increment(pLink)) = $ListBuild(tPageName,$ZConvert($ClassName(),"O","URL")_".zen"_$Select(NAMESPACE="":"",1:"?$NAMESPACE="_NAMESPACE))
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Notifications")
}

/// Zen page notification of an HTTP request. This method can be overwritten
/// by subclasses.<br/>
/// This is called <em>before</em> the standard Zen pre-HTTP processing occurs.
ClassMethod %OnPreHTTP() As %Boolean
{
	If '($System.Security.Check("%Admin_Manage","U") && $System.Security.Check("%Admin_Secure","U")) {
		Set %zenPageError=$$$ERROR($$$AccessDenied)
	}
	Quit 1
}

}
