/// System Management Portal - System Configuration - ECP
Class %CSP.UI.Portal.ECP Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "ECP Settings";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.ECP.zen";

Parameter HELPADDRESS = "Home,Configuration,ECP Settings";

Parameter EMSSERVICE = "Namespace";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Property ConfigIsManaged As %Boolean [ InitialExpression = {##class(%SYS.EMS).IsReadOnly("Config.config")} ];

Property DialogLink As %String [ InitialExpression = {..Link("/csp/sys/sec/%CSP.UI.Portal.Dialog.Service.zen",,1)} ];

XData Style
{
<style type="text/css">
.fieldHint {
    color: gray;
    font-size: 12px;
    padding-left: 5px;
    vertical-align: super;
}
.successNote {
	background: #F2F1EC;
	border: 1px solid #4D3926;
	border-radius: 5px;
	color: #52B012;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
	padding: 10px;
	text-align: left;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<label id="errmsg" hidden="true" enclosingClass="ErrorBox"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<hgroup>
<fieldSet labelPosition="left" label="This System as an ECP Application Server" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<text id="MaxServers" label="Maximum number of data servers" size="5" hint="(0 - 254)" onchange="zenPage.doModified();"/>
<text id="ClientReconnectDuration" label="Time to wait for recovery" size="5" hint="(10 - 65535 seconds)" title="How long a client should keep trying to re-establish a connection before giving up." onchange="zenPage.doModified();"/>
<text id="ClientReconnectInterval" label="Time between reconnections" size="5" hint="(1 - 60 seconds)" title="When a server is not available, how long to wait between each reconnection attempt." onchange="zenPage.doModified();"/>
</fieldSet>
<fieldSet labelPosition="left" label="This System as an ECP Data Server" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<link id="ServiceStatus" caption="" href="#" onclick="zenPage.doService();return false;" enclosingStyle="margin-bottom:16px;" enclosingClass="smpLink"/>
<text id="MaxServerConn" label="Maximum number of application servers" size="5" hint="(0 - 254)" title="If modified, this field requires a Caché restart." onchange="zenPage.doModified();"/>
<text id="ServerTroubleDuration" label="Time interval for Troubled state" size="5" hint="(20 - 65535 seconds)" title="Once this period of time has elapsed, the server will declare the connection dead." onchange="zenPage.doModified();"/>
</fieldSet>
</hgroup>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	// overriding so that config elements can be edited if not config-managed
	if (this.IsEMSReadOnly && this.ConfigIsManaged) {
		this.disableCommandButton('btnSave');
	}
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action == 'ok') zenPage.DrawServiceStatus();
}

ClientMethod doAppServers() [ Language = javascript ]
{
	var url = '%25CSP.UI.Portal.ECPAppServers.zen';
	this.gotoPage(url);
}

ClientMethod doDataServers() [ Language = javascript ]
{
	var url = '%25CSP.UI.Portal.ECPDataServers.zen';
	this.gotoPage(url);
}

ClientMethod doService() [ Language = javascript ]
{
	var url = zenLink(this.DialogLink+'PID='+encodeURIComponent('%Service_ECP')+'&from=ECP');
	zenLaunchPopupWindow(url,'Service','status,scrollbars,resizable=yes,width=600,height=600');
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('MaxServers'),pass,"N",true,0,254)) pass = false;
		if (!this.validateRequired(zen('ClientReconnectDuration'),pass,"N",true,10,65535)) pass = false;
		if (!this.validateRequired(zen('ClientReconnectInterval'),pass,"N",true,1,60)) pass = false;
		if (!this.validateRequired(zen('MaxServerConn'),pass,"N",true,0,254)) pass = false;
		if (!this.validateRequired(zen('ServerTroubleDuration'),pass,"N",true,20,65535)) pass = false;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

ClientMethod doSave() [ Language = javascript ]
{
	this.resetMsg();
	
	var ok = this.validate();
	if (!ok) {
		this.afterValidate();
		return;
	}
	
	var proxy = new zenProxy();
	proxy.MaxServers = zen("MaxServers").getValue();
	proxy.ClientReconnectDuration = zen("ClientReconnectDuration").getValue();
	proxy.ClientReconnectInterval = zen("ClientReconnectInterval").getValue();
	proxy.MaxServerConn = zen("MaxServerConn").getValue();
	proxy.ServerTroubleDuration = zen("ServerTroubleDuration").getValue();
	proxy.ConfigIsManaged = this.ConfigIsManaged;
	proxy.IsEMSReadOnly = this.IsEMSReadOnly;
	
	var result = this.SaveData(proxy);

	if (result.ok == 1) {
		zen('idRespond').setProperty('enclosingClass','successNote');
		this.showMsg(result.msg);
		this.setModified(false);
	} else {
		this.showMsg(result.ErrorMessage,1);
	}
}

/// Set Locator bar and determine whether to show change password option.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set ..lblTitle = $$$Text("Use the form below to specify how this system operates as an ECP Data Server or ECP Application Server")_":"
	
	If ((##Class(%SYSTEM.License).MaxECPServers() = 0) || (##Class(%SYSTEM.License).KeyServer() = "Single")) {
		Set ..%GetComponentById("errmsg").value = $$$Text("The Caché license does not support ECP.")
		Set ..%GetComponentById("errmsg").hidden = 0
	}
	Do ..DrawServiceStatus()
	
	Set tSC = ##Class(Config.config).Get(.Properties)
	Set tProperty = ""
	Set tProperty = $O(Properties(tProperty)) 
	While tProperty '= ""  {
		Set Component = ..%GetComponentById(tProperty)
		If $ISO(Component) {
			Set Component.value = Properties(tProperty)
			If ..ConfigIsManaged {
				Set Component.disabled = 1
				If '..IsEMSReadOnly {
					Set Component.hint = $$$Text("This property is managed by the Enterprise Manager Configuration service.")
					Set Component.title = ""
				}
			}
		}
		Set tProperty = $O(Properties(tProperty)) 
	}
	
	Kill Properties

	Set tSC = ##Class(Config.ECP).Get(.Properties)
	Set tProperty = ""
	Set tProperty = $O(Properties(tProperty)) 
	While tProperty '= ""  {
		Set Component = ..%GetComponentById(tProperty)
		If $ISO(Component) {
			Set Component.value = Properties(tProperty)
			If ..IsEMSReadOnly Set Component.disabled = 1
		}
		Set tProperty = $O(Properties(tProperty)) 
	}
	
	Quit $$$OK
}

Method DrawServiceStatus() As %Status [ ZenMethod ]
{
	Set tSC = ##class(Security.Services).Get("%Service_ECP",.Properties)
	If $$$ISOK(tSC) {
		Set statusComp = ..%GetComponentById("ServiceStatus")
		Set statusComp.label = $S(Properties("Enabled")=1:$$$TextHTML("The ECP service is Enabled"),1:$$$TextHTML("The ECP service is Disabled"))
		If ('$SYSTEM.Security.Check($$$AdminSecureResourceName,"USE") || ##class(%SYS.EMS).IsReadOnly("Security.Services")) {
			Set statusComp.disabled = 1
			Set statusComp.caption = ""
		} Else {
			Set statusComp.caption = $S(Properties("Enabled")=1:$$$TextHTML("Disable"),1:$$$TextHTML("Enable"))
		}
	}
	Quit tSC
}

///  Save general association data to server.<br/>
///  Returns proxy.ok = 1 (save successful) or 0 (error occurred)<br/>
///  proxy.ErrorMessage (save failed and display this error message).
///  If proxy.ok is 1 and no messages returned then we return to SMP home.
ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		Set (Restart,SaveConfig) = 0
		
		// Only save these properties if Config is not EMS-managed
		If 'pProxy.ConfigIsManaged {
			Set tSC = ##class(Config.config).Get(.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)

			If pProxy.MaxServerConn '= Properties("MaxServerConn") {
				Set Properties("MaxServerConn") = pProxy.MaxServerConn
				Set Restart = 1
				Set SaveConfig = 1
			}
			If pProxy.MaxServers '= Properties("MaxServers") {
				Set Properties("MaxServers") = pProxy.MaxServers
				Set SaveConfig = 1
			}
			If SaveConfig {
				Set tSC = ##class(Config.config).Modify(.Properties)
				If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			}
			Kill Properties
		}
		
		// Only save these properties if Namespaces is not EMS-managed
		If 'pProxy.IsEMSReadOnly {
			Set tSC = ##class(Config.ECP).Get(.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		
			Set Properties("ServerTroubleDuration") = pProxy.ServerTroubleDuration
			Set Properties("ClientReconnectDuration") = pProxy.ClientReconnectDuration
			Set Properties("ClientReconnectInterval") = pProxy.ClientReconnectInterval
		
			Set tSC = ##class(Config.ECP).Modify(.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		Set tProxy.ok = 1
		Set tProxy.msg = $$$Text("Settings have been saved.")
		If Restart = 1 {
			Set tProxy.msg = tProxy.msg_" "_$$$Text("You must restart for the new values to take effect.")
		}
	} Catch Error {
		Set Message = ..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = Message
	}
	Quit tProxy
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("ECP Settings")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick,hidden)
	Set pCommands(1) = $LB("btnSave",$$$Text("Save"),$$$Text("Save changes"),"zenPage.doSave();")
	Set pCommands(2) = $LB("btnCancel",$$$Text("Cancel"),$$$Text("Return without saving new changes"),"zenPage.doCancel();")
	Set pCommands(3) = $LB("btnData",$$$Text("Data Servers"),$$$Text("View ECP data servers this system may connect to"),"zenPage.doDataServers();")
	Set pCommands(4) = $LB("btnApp",$$$Text("Application Servers"),$$$Text("View ECP application servers connected to this system."),"zenPage.doAppServers();")

	Quit $$$OK
}

}
