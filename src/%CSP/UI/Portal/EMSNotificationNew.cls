Class %CSP.UI.Portal.EMSNotificationNew Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/%CSP.UI.Portal.EMSNotificationNew.zen";

Parameter HELPADDRESS = "System,Enterprise Manager,Notifications,Send a Notification";

/// Displayed name of this page.
Parameter PAGENAME = "Send a Notification";

Parameter PARENTPAGE = "/csp/sys/%CSP.UI.Portal.EMSNotifications.zen";

/// Localization Domain
Parameter DOMAIN = "%EMSMessages";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage,%Admin_Secure";

Property GUID As %String [ InitialExpression = {##class(%SYS.System).InstanceGUID()} ];

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<textarea id="Message" label="Message" rows="5" cols="40"/>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	document.getElementById('command_btnSave').innerHTML = $$$Text("Send");
}

ClientMethod doSave() [ Language = javascript ]
{
	this.resetMsg();
	if (!this.validate()) {
		this.afterValidate();
		return;
	}
	
	var proxy = new zenProxy();
	proxy.Target = this.GUID;
	proxy.Message = zen('Message').getValue();
	
	var result = this.SaveData(proxy);
	this.afterSave(result);
	
	return;
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('Message'),pass,"S")) pass = false;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

/// Call server save method.
ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""
	
	Try {
		Set tErr = ##class(EMS.Notification.UserGenerated).Create($$$EMSNoteInstanceEdit,pProxy.Target,pProxy.Message)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
		
		Set instance = ##class(EMS.Instance).OpenRequired(4,.tErr)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
	
		Set tErr = instance.SendNotifications()
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw

		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
		
	Set ..lblTitle = $$$Text("Send a notification to Enterprise Manager users:")
	
	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Send a Notification")
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
	Set tURL = ..Link("/csp/sys/%25CSP.UI.Portal.EMS.zen")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Notifications","%Utility")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($Increment(pLink)) = $ListBuild(tPageName,$ZConvert($ClassName(),"O","URL")_".zen"_$Select(NAMESPACE="":"",1:"?$NAMESPACE="_NAMESPACE))
	Quit $$$OK
}

/// Zen page notification of an HTTP request. This method can be overwritten
/// by subclasses.<br/>
/// This is called <em>before</em> the standard Zen pre-HTTP processing occurs.
ClassMethod %OnPreHTTP() As %Boolean
{
	if '($system.Security.Check("%Admin_Manage","U") && $system.Security.Check("%Admin_Secure","U")) {
		set %zenPageError=$$$ERROR($$$AccessDenied)
	}
	quit 1
}

}
