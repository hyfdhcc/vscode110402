Class %CSP.UI.Portal.Monitoring Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Monitor Settings";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Monitoring.zen";

Parameter HELPADDRESS = "Home,Configuration,Monitor Settings";

Parameter EMSSERVICE = "Config";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property DialogLink As %String [ InitialExpression = {..Link("/csp/sys/sec/%CSP.UI.Portal.Dialog.Service.zen",,1)} ];

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<link id="ServiceStatus" caption="" href="#" onclick="zenPage.doService();return false;" enclosingClass="smpLink"/>
<checkbox id="PatrolEnabled" label="Start Patrol at System Startup" onchange="zenPage.doModified();"/>
<text id="PatrolTopProcesses" label="Patrol Top Processes to Monitor" size="5" hint="Required. (1 - 10000)" onchange="zenPage.doModified();"/>
<select id="PatrolDisplayMode" label="Patrol Display Mode" valueList="0,1,2" displayList="Total,Delta,Rate" showEmpty="false" onchange="zenPage.doModified();"/>
<text id="PatrolCollectionInterval" label="Patrol Collection Interval Seconds" size="5" hint="Required. (1 - 900)" onchange="zenPage.doModified();"/>
<checkbox id="SNMPEnabled" label="Start SNMP Agent at System Startup" onchange="zenPage.doModified();"/>
<checkbox id="WMIEnabled" label="WMI Enabled" onchange="zenPage.doModified();"/>
</group>
</form>
</pane>
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action == 'ok') zenPage.DrawServiceStatus();
}

ClientMethod doService() [ Language = javascript ]
{
	var url = zenLink(this.DialogLink+'PID='+encodeURIComponent('%Service_Monitor')+'&from=Monitor');
	zenLaunchPopupWindow(url,'Service','status,scrollbars,resizable=yes,width=600,height=600');
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('PatrolTopProcesses'),pass,"N",true,1,10000)) pass = false;
		if (!this.validateRequired(zen('PatrolCollectionInterval'),pass,"N",true,1,900)) pass = false;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

/// Save current item.
ClientMethod doSave() [ Language = javascript ]
{
	try {
		this.resetMsg();
		
		if (!this.validate()) {
			this.afterValidate();
			return;
		}
		
		var proxy = new zenProxy();
		
		proxy.PatrolEnabled = zen('PatrolEnabled').getValue();
		proxy.PatrolTopProcesses = zen('PatrolTopProcesses').getValue();
		proxy.PatrolDisplayMode = zen('PatrolDisplayMode').getValue();
		proxy.PatrolCollectionInterval = zen('PatrolCollectionInterval').getValue();
		proxy.SNMPEnabled = zen('SNMPEnabled').getValue();
		proxy.WMIEnabled = zen('WMIEnabled').getValue();

		var result = this.SaveData(proxy);
		this.afterSave(result);
	} catch (ex) {
		alert("Error doSave: " + ex);
	}
}

ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		Set tSC = ##Class(Config.Monitor).Get(.Properties)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		
		Set Properties("PatrolCollectionInterval") = pProxy.PatrolCollectionInterval
		Set Properties("PatrolDisplayMode") = pProxy.PatrolDisplayMode
		Set Properties("PatrolEnabled") = pProxy.PatrolEnabled
		Set Properties("PatrolTopProcesses") = pProxy.PatrolTopProcesses
		Set Properties("SNMPEnabled") = pProxy.SNMPEnabled
		Set Properties("WMIEnabled") = pProxy.WMIEnabled
		
		Set tSC = ##Class(Config.Monitor).Modify(.Properties)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)

		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Do ..DrawServiceStatus()
	
	Set ..lblTitle = $$$Text("SNMP and Remote Monitor Settings:")
	
	Set tSC = ##Class(Config.Monitor).Get(.Properties)
	If $$$ISERR(tSC) {
		Set ..%GetComponentById("idRespond").value = ..EvalResult(tSC)
		Quit $$$OK
	}
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

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Monitor Settings")
}

Method DrawServiceStatus() As %Status [ ZenMethod ]
{
	Set tSC = ##class(Security.Services).Get("%Service_Monitor",.Properties)
	If $$$ISOK(tSC) {
		Set statusComp = ..%GetComponentById("ServiceStatus")
		Set statusComp.label = $S(Properties("Enabled")=1:$$$TextHTML("The Monitor service is Enabled"),1:$$$TextHTML("The Monitor service is Disabled"))
		If ('$SYSTEM.Security.Check($$$AdminSecureResourceName,"USE") || ##class(%SYS.EMS).IsReadOnly("Security.Services")) {
			Set statusComp.disabled = 1
			Set statusComp.caption = ""
		} Else {
			Set statusComp.caption = $S(Properties("Enabled")=1:$$$TextHTML("Disable"),1:$$$TextHTML("Enable"))
		}
	}
	Quit tSC
}

}
