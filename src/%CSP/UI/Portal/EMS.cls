Include %ems

Class %CSP.UI.Portal.EMS Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "Enterprise Manager";

Parameter CSPURL = "/csp/sys/%CSP.UI.Portal.EMS.zen";

Parameter HELPADDRESS = "System,Enterprise Manager";

/// Localization Domain
Parameter DOMAIN = "%EMSMessages";

/// Security requirement
Parameter RESOURCE = "%Admin_Secure,%Admin_Manage";

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Property CanJoin As %Boolean;

Property CanRemove As %Boolean;

Property CanResume As %Boolean;

Property CanResetCredentials As %Boolean;

Property CanSuspend As %Boolean;

Property IsManaged As %Boolean;

Property InstanceState As %String;

Property IsAwaitingApproval As %Boolean;

Property IsMirror As %Boolean;

Property HasLicense As %Boolean;

XData Style
{
<style type="text/css">
/* light purple for System Administration pages*/
.ribbonTitle {
	background: #D2CFDF;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<label id="errmsg" hidden="true" enclosingClass="ErrorBox"/>
<link id="NeedLicense" hidden="true" href="/csp/sys/mgr/%25CSP.UI.Portal.License.Key.zen" caption="Activate a new license key" enclosingClass="smpLink"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<form id="fld">
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<label id="DetailEMSServer" controlClass="normal" label="Enterprise Manager server"/>
<label id="DetailInstanceServer" controlClass="normal" label="This instance's web server"/>
<label id="DetailSecurityPolicy" controlClass="normal" label="Security policy"/>
<label id="Status" label="Management status" controlClass="normal"/>
<label id="Services" label="Managed Service(s)" controlClass="normal" hidden="true" containerStyle="padding:0;"/>
<label id="LastCommunicationTime" label="Last communication" controlClass="normal" hidden="true" containerStyle="padding:0;"/>
<label id="LastUpdateTime" label="Last update" controlClass="normal" hidden="true" containerStyle="padding:0;"/>
<link id="Notifications" label="Notifications" href="%25CSP.UI.Portal.EMSNotifications.zen"/>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.updateButtons();
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			this.resetMsg();
			this.updateView();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Update / Reload tables. This overrides the one in Portal.Utils.
ClientMethod updateView() [ Language = javascript ]
{
	this.InitializeForm(false);
	this.updateButtons();
	self.document.getElementById("id_refresh").title = this.LastUpdateTime();
}

ClientMethod updateButtons() [ Language = javascript ]
{
	if (this.CanJoin) {
		this.enableCommandButton('btnNew');
		this.disableCommandButton('btnRenew');
		this.disableCommandButton('btnResetCred');
	} else {
		this.disableCommandButton('btnNew');
		this.enableCommandButton('btnRenew');
		this.enableCommandButton('btnResetCred');
	}	
	if (this.IsAwaitingApproval) {
		this.disableCommandButton('btnRenew');
		this.disableCommandButton('btnResetCred');
	}
	if (this.HasLicense == 0) {
		this.disableCommandButton('btnRenew');
		this.disableCommandButton('btnResetCred');
	}
	if (this.CanResume) {
		this.enableCommandButton('btnResume');
	} else {
		this.disableCommandButton('btnResume');
	}
	if (this.CanSuspend) {
		this.enableCommandButton('btnSuspend');
	} else {
		this.disableCommandButton('btnSuspend');
	}
	if (this.CanRemove) {
		this.enableCommandButton('btnRemove');
	} else {
		this.disableCommandButton('btnRemove');
	}
	if (this.CanResetCredentials == 0) {
		this.disableCommandButton('btnResetCred');
	}
}

/// Toggle disable of all buttons.
ClientMethod disableAllButtons() [ Language = javascript ]
{
	this.disableCommandButton('btnNew');
	this.disableCommandButton('btnResume');
	this.disableCommandButton('btnSuspend');
	this.disableCommandButton('btnRemove');
	this.disableCommandButton('btnResetCred');
	this.showMsg($$$Text('Please wait...'),0);
}

ClientMethod doNew() [ Language = javascript ]
{
	if (!this.CanJoin) return;
	this.resetMsg();
	var url = zenLink('%CSP.UI.Portal.Dialog.EMS.zen');
	zenLaunchPopupWindow(url,'EMSWizard','resizable,width=900,height=750');
}

ClientMethod doRenew() [ Language = javascript ]
{
	if (this.CanJoin) return;
	if (this.IsAwaitingApproval) return;
	if (this.HasLicense == 0) return;
	this.resetMsg();
	var url = zenLink('%CSP.UI.Portal.Dialog.EMS.zen?MANAGED=YES');
	var parms = new Object();
	parms.MANAGED = "YES";
	zenPage.launchPopupWindow(url,'EMSWizard','resizable,width=900,height=750',parms);
}

ClientMethod doResume() [ Language = javascript ]
{
	if (!this.CanResume) return;
	this.resetMsg();
	if (!confirm($$$Text('Send a message to Enterprise Manager to resume management?'))) return;
	
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	this.disableAllButtons();	
	
	var result = this.Resume();
	this.afterSave(result);
	this.updateView();
	zenSynchronousMode = oldSynchronousMode;
}

ClientMethod doSuspend() [ Language = javascript ]
{
	if (!this.CanSuspend) return;
	this.resetMsg();
	if (!this.IsMirror) {
		var msg = $$$Text('Suspend management?')
	} else {
		var msg = $$$Text('This Instance is part of a managed Mirror. The other Mirror members will need to also be Suspended to affect changes to the Mirror. Do you still want to Suspend management?');
	}
	if (!confirm(msg)) return;
	
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	this.disableAllButtons();	
	
	var result = this.Suspend();
	this.afterSave(result);
	this.updateView();
	zenSynchronousMode = oldSynchronousMode;
}

ClientMethod doRemove() [ Language = javascript ]
{
	if (!this.CanRemove) return;
	if (this.IsMirror) {
		alert($$$Text('This Instance cannot be Removed while it is part of a managed Mirror. The Mirror must be first be removed from Enterprise Manager.'));
		return;
	}
	this.resetMsg();
	if (this.IsAwaitingApproval) {
		var msg = $$$Text('Remove management request from Enterprise Manager?');
	} else {
		var msg = $$$Text('Completely remove this instance from Enterprise Manager?')+'\n\n'+$$$Text('If you wish to temporarily manage this instance locally, use the Suspend option instead.');
	}
	if (!confirm(msg)) return;
	
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	this.disableAllButtons();
	
	var result = this.Remove();
	if (result.ErrorMessage != "") {
		this.showMsg(result.ErrorMessage,!result.ok);
	} else {
		this.resetMsg();
	}
	this.updateView();
	zenSynchronousMode = oldSynchronousMode;
}

ClientMethod doResetCredentials() [ Language = javascript ]
{
	if (this.IsManaged) {
		this.resetMsg();
		var url = zenLink('%CSP.UI.Portal.Dialog.EMSResetCredentials.zen');
		//zenLaunchPopupWindow(url,'EMSResetCredentials','resizable,width=900,height=750');
		zenPage.launchPopupWindow(url, 'EMSResetCredentials','resizable,width=900,height=750');
	}
}

ClassMethod Resume() As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""

	Try {
		If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
			$$$ThrowStatus($$$ERROR($$$OperationRequires3,$$$PermUseName,$$$AdminManageResourceName,$$$AdminSecureResourceName))
		}
		Set tErr = ##class(EMS.Instance).LocalResumeManagement(.resumed)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
		If (resumed = 0) {
			Set tProxy.Message = $$$Text("Enterprise Manager has been notified that this instance may be resumed.")
		} Else {
			Set tProxy.Message = $$$Text("Management has been resumed.")
		}
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") {
			Set tSC = Error.AsStatus()
			Set tProxy.ErrorMessage = ..EvalResult(tSC)
		}
	}
	Quit tProxy
}

ClassMethod Suspend() As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""

	Try {
		If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
			$$$ThrowStatus($$$ERROR($$$OperationRequires3,$$$PermUseName,$$$AdminManageResourceName,$$$AdminSecureResourceName))
		}
		Set tErr = ##class(EMS.Instance).SuspendManagement(,.suspended)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
		Set tProxy.Message = $$$Text("Management has been suspended.")
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") {
			Set tSC = Error.AsStatus()
			Set tProxy.ErrorMessage = ..EvalResult(tSC)
		}
		If $g(suspended) = 1 {
			Set tProxy.ok = 1
			Set tProxy.Message = tErr.AsHTML()
		}
	}
	Quit tProxy
}

ClassMethod Remove() As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""

	Try {
		If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
			$$$ThrowStatus($$$ERROR($$$OperationRequires3,$$$PermUseName,$$$AdminManageResourceName,$$$AdminSecureResourceName))
		}
		Set tErr = ##class(EMS.Instance).RemoveFromManagement(1,.removed)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") {
			Set tSC = Error.AsStatus()
			Set tProxy.ErrorMessage = ..EvalResult(tSC)
		}
		If $g(removed) = 1 {
			Set tProxy.ok = 1
		}
	}
	Quit tProxy
}

/// InitializeForm is called when we need to change the page's state.
/// firstLoad = true indicates that this is on the initial page load
Method InitializeForm(HideResponse As %Boolean = 1) As %Status [ ZenMethod ]
{
	If HideResponse {
		Do ..%SetValueById("idRespond","")
		Set ..%GetComponentById("idRespond").hidden = 1
	}
	
	Set ..CanJoin = 0
	Set ..CanResume = 0
	Set ..CanSuspend = 0
	Set ..CanRemove = 0
	Set ..IsManaged = 0
	Set ..IsAwaitingApproval = 0
	Set ..IsMirror = 0
	Set ..CanResetCredentials = 1
	
	// If the license isn't correct, prompt for license
	If $$$EMSInstanceLicenseCheckFailed {
		Set ..%GetComponentById("NeedLicense").hidden = 0
		Set ..%GetComponentById("fld").hidden = 1
		Set ..%GetComponentById("Text1").value = $$$Text("A valid license key is required.")
		Set ..HasLicense = 0
		Quit $$$OK
	}
	Set ..HasLicense = 1
	
	Set instance = ##class(EMS.Instance).Open(,.tErr)
	// If there is no instance object, prompt for join
	If (instance = "") {
		Set ..CanJoin = 1
		Set ..%GetComponentById("fld").hidden = 1
		Set ..%GetComponentById("Text1").value = $$$Text("This instance is not managed by Enterprise Manager.")
		Quit $$$OK
	}
	
	Set ..CanRemove = 1
	Set ..%GetComponentById("fld").hidden = 0
	Set ..%GetComponentById("Text1").value = $$$Text("This system's Enterprise Manager status is detailed below:")
	
	Do ..%SetValueById("Status",..EscapeHTML(##class(EMS.Instance).StateAsString(instance.State)))
	Do ..%SetValueById("DetailEMSServer",..GetServerString(instance.ManagerConnection.Endpoint))
	Do ..%SetValueById("DetailInstanceServer",..GetServerString(instance.InstanceData.InstanceConnection.Endpoint))
	If instance.InstanceData.InstanceConnection.Policy'="" {
		Do ..%SetValueById("DetailSecurityPolicy",instance.InstanceData.InstanceConnection.Policy.DisplayName())
		If instance.InstanceData.InstanceConnection.Policy.PolicyId= "Username" Set ..CanResetCredentials=0
	}
	
	Set tRS = ##class(%ResultSet).%New("EMS.Notification:ListForInstance")
	Do tRS.Execute()
	Set count = 0
	While tRS.Next() {
		Set count = count + 1
	}
	If count = 0 {
		Set ..%GetComponentById("Notifications").caption = $$$Text("No Notifications")
	} ElseIf count = 1 {
		Set ..%GetComponentById("Notifications").caption = $$$Text("1 Notification")
	} Else {
		Set ..%GetComponentById("Notifications").caption = $$$FormatText($$$Text("%1 Notifications"),count)
	}
	
	// The following fields only display if they have a value
	Set services = ##class(EMS.Instance).ServicesAsString(1,1)
	If (services '= "") {
		Set component = ..%GetComponentById("Services")
		Set component.value = services
		Set component.hidden = 0
		Set component.containerStyle="padding:4px;"
	}
	If (instance.LastCommunicationTime '= "") {
		Set component = ..%GetComponentById("LastCommunicationTime")
		Set component.value = instance.LastCommunicationTimeLocal
		Set component.hidden = 0
		Set component.containerStyle="padding:4px;"
	}
	If (instance.LastUpdateTime '= "") {
		Set component = ..%GetComponentById("LastUpdateTime")
		Set component.value = instance.LastUpdateTimeLocal
		Set component.hidden = 0
		Set component.containerStyle="padding:4px;"
	}
	
	If instance.State = $$$EMSCStateManaged {
		Set ..CanSuspend = 1
		Set ..IsManaged = 1
		Set ..InstanceState = "Managed"
	} ElseIf (instance.State = $$$EMSCStateSuspended) {
		Set ..CanResume = 1
		Set ..IsManaged = 1
		Set ..InstanceState = "Suspended"
	} ElseIf (instance.State = $$$EMSCStateNotUpdated) {
		Set ..CanResume = 1
		Set ..IsManaged = 1
		Set ..InstanceState = "Not Updated"
	} Else {
		Set ..IsAwaitingApproval = 1
		Set ..InstanceState = "Awaiting Approval"
	}
	
	Set services = ##class(EMS.Instance).ServicesAsString(0,0)
	If services["Mirror" Set ..IsMirror = 1

	Quit $$$OK
}

ClassMethod GetServerString(endpoint As EMS.Connection.Endpoint) As %String
{
	Set server=$$$Text("Unknown")
	If endpoint'="" {
		Set addr = endpoint.Host
		Set port = endpoint.Port
		Set prefix = endpoint.Prefix
		Set server=$Select(prefix = "":addr_":"_port,1:addr_":"_port_"/"_prefix)
	}
	Quit server
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $Get(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($Increment(pLink)) = $ListBuild(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($Increment(pLink)) = $ListBuild(tPageName,$ZConvert($ClassName(),"O","URL")_".zen"_$Select(NAMESPACE="":"",1:"?$NAMESPACE="_NAMESPACE))
	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Enterprise Manager")
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Do ..InitializeForm()
	$$$SetRefreshTimer	
	Quit $$$OK
}

/// Add to the contents of the tool ribbon.
Method OnDrawRibbon() As %Status
{
	If ($G($$$CacheTempMgt($Username,..%GetPageName(),"AutoRefreshState"),"") = "") {
		Set $$$CacheTempMgt($Username,..%GetPageName(),"AutoRefreshState") = 1
	}
	If ($G($$$CacheTempMgt($Username,..%GetPageName(),"AutoRefreshRate"),"") = "") {
		Set $$$CacheTempMgt($Username,..%GetPageName(),"AutoRefreshRate") = 5
	}
	Do ..DrawAutoRefresh(..%GetPageName())
	Quit $$$OK
}

///  Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands($I(pCommands)) = $ListBuild("btnNew",$$$Text("Apply"),$$$Text("Apply for management"),"zenPage.doNew();")
	Set pCommands($I(pCommands)) = $ListBuild("btnRenew",$$$Text("Reapply"),$$$Text("Reapply for management"),"zenPage.doRenew();")
	Set pCommands($I(pCommands)) = $ListBuild("btnSuspend",$$$Text("Suspend"),$$$Text("Suspend management"),"zenPage.doSuspend();")
	Set pCommands($I(pCommands)) = $ListBuild("btnResume",$$$Text("Resume"),$$$Text("Request to resume management"),"zenPage.doResume();")
	Set pCommands($I(pCommands)) = $ListBuild("btnRemove",$$$Text("Remove"),$$$Text("Remove from Enterprise Manager"),"zenPage.doRemove();")
	Set pCommands($I(pCommands)) = $ListBuild("btnResetCred",$$$Text("Reset Credentials"),$$$Text("Reset this instance's security credentials."),"zenPage.doResetCredentials();")

	Quit $$$OK
}

/// Zen page notification of an HTTP request. This method can be overwritten
/// by subclasses.<br/>
/// This is called <em>before</em> the standard Zen pre-HTTP processing occurs.
ClassMethod %OnPreHTTP() As %Boolean
{
	If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
		Set %zenPageError=$$$ERROR($$$AccessDenied)
	}
	Quit 1
}

}
