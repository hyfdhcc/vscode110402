/// Zen page for System Management Portal - Edit an Object Gateway Server
Class %CSP.UI.Portal.ObjectGateway Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "Object Gateway";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.ObjectGateway.zen";

Parameter HELPADDRESS = "System Administration, Configuration, Connectivity, Object Gateways";

Parameter PARENTPAGE = "/csp/sys/mgr/%CSP.UI.Portal.ObjectGateways.zen";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter RECENT = 0;

/// ID for edit.
Property PID As %String(ZENURL = "PID");

Property isNew As %ZEN.Datatype.boolean(ZENURL = "isNew") [ InitialExpression = "0" ];

/// Gateway type display string (.NET or Java)
Property GatewayType As %ZEN.Datatype.string;

/// Is Ensemble-enabled
Property IsEnsemble As %Boolean;

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

/// Is this a Unix system
Property IsUnix As %Boolean [ InitialExpression = "0" ];

/// Is the current gateway running
Property IsRunning As %Boolean [ InitialExpression = "0" ];

Property msgConfirmRunning As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Gateway is currently running! In order to save, you must stop the Gateway first.")} ];

Property msgActionsDisplay As %String [ InitialExpression = {$$$Text("None,Restart,Alert,Restart and Alert")} ];

Property msgActionsValue As %String [ InitialExpression = "N,R,A,RA" ];

Property JAVAHOMEValue As %String [ InitialExpression = {..GetJAVAHOMEValue()} ];

XData Style
{
<style type="text/css">
/* override the image because this form is too tall */
.EditForm {
	background-image: url('');
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px;padding-top:10px;">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:0px;"/>
<hidden name="browseselect" id="browseselect"/>
<form id="fld">
<label id="idRespond" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding-top:0px;padding-bottom:5px;" labelPosition="left">
<spacer height="2"/>
 <radioSet id="Type" label="Object Gateway For" valueList="2,1" displayList=".NET,Java" value="2" onchange="zenPage.changeType();"/>
 <label id="GatewayType" label="Object Gateway For" value="#(%page.GatewayType)#" controlClass="normal" hidden="true"/>
 <text id="Name" label="Gateway Name"  hint="Required." onchange="zenPage.doModified();" />
 <text id="Server" label="Server Name / IP Address" size="20" value="127.0.0.1" hint="Required." onchange="zenPage.doModified();"/> 
 <text id="Port" label="Port" size="20" hint="Required." onchange="zenPage.doModified();"/> 
 <hgroup id="id_LogFile" labelPosition="left" label="Log File" cellVAlign="top" >
<text id="LogFile" size="60" onchange="zenPage.doModified();"/>
<button id="LogFileBrowse" caption="Browse..." onclick="zenPage.browseSelect('LogFile','*.log');"/>
</hgroup>
 <text id="HeartbeatInterval" label="Heartbeat Interval" size="20" value="10" onchange="zenPage.doModified();"/> 
 <text id="HeartbeatFailureTimeout" label="Heartbeat Failure Timeout" size="20" value="30" onchange="zenPage.doModified();"/> 
 <select id="HeartbeatFailureAction" label="Heartbeat Failure Action" valueList="N,R,A,RA" displayList="None,Restart,Alert,Restart and Alert" 
  showEmpty="false" value="R" onchange="zenPage.doModified();"/> 

 <text id="HeartbeatFailureRetry" label="Heartbeat Failure Retry" size="20" value="300" onchange="zenPage.doModified();"/> 
 <text id="InitializationTimeout" label="Initialization Timeout" size="20" value="10" onchange="zenPage.doModified();"/> 
 <text id="ConnectionTimeout" label="Connection Timeout" size="20" value="5" onchange="zenPage.doModified();"/> 

<!-- The following are .NET ONLY Properties -->
 <text id="AllowedIPAddresses" label="Allowed IP Addresses" size="60" value="127.0.0.1" hidden="false" onchange="zenPage.doModified();"/> 
<hgroup id="id_FilePath" labelPosition="left" label="File Path" cellVAlign="top" hidden="false">
<text id="FilePath" size="60" onchange="zenPage.doModified();"/>
<button id="FilePathBrowse" caption="Browse..." onclick="zenPage.browseSelect('FilePath','showdirectoryonly');"/>
</hgroup>
<checkbox id="Exec64" label="Execute as 64-bit" value="false" hidden="false" onchange="zenPage.doModified();"/>
<select id="DotNetVersion" label=".NET Version" valueList="2.0,4.0" displayList="2.0,4.0" 
 showEmpty="false" value="2.0" hint="" hidden="false" onchange="zenPage.doModified();"/> 

<!-- The following are JAVA ONLY Properties -->
<text id="JavaHome" label="Java Home" size="60" value="" hint="" hidden="true" onchange="zenPage.doModified();"/> 
<select id="JDKVersion" label="JDK Version" valueList="JDK17,JDK18" displayList="Java 1.7,Java 1.8" 
 showEmpty="false" value="JDK17" hint="" hidden="true" onchange="zenPage.doModified();"/> 
<hgroup id="id_ClassPath" labelPosition="left" label="Class Path" cellVAlign="top" hidden="true">
<text id="ClassPath" size="60" onchange="zenPage.doModified();"/>
<button id="ClassPathBrowse" caption="Browse..." onclick="zenPage.browseSelect('ClassPath','*.jar');"/>
</hgroup>
<text id="JVMArgs" label="JVM arguments" size="60" hint="" hidden="true" onchange="zenPage.doModified();"/> 
<text id="JAVAHOMEValue" size="60" hidden="true" readOnly="true" label="JAVA_HOME Environment Variable" controlStyle="background:#DFDFDF;" value="#(%page.JAVAHOMEValue)#" hint="" title="Current value of O.S. environment variable JAVA_HOME." />

<spacer height="2"/>
 </group>
 </form>
</pane>
}

/// User clicked one of the Browse buttons.
/// Save the name of the textfield so that when you return you know which textfield to update.
ClientMethod browseSelect(name, wildcard) [ Language = javascript ]
{
	zenPage.getComponentById('browseselect').setValue(name);
	var Dir = zenPage.getComponentById(name).getValue();
	var url = '%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir);
	if (wildcard == "showdirectoryonly") url = url + '&showdirectoryonly=1';
	else  url = url + '&wildcard=' + wildcard;
	zenLaunchPopupWindow(url,'FileSelect','resizable,width=600,height=700');
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			var name = zenPage.getComponentById("browseselect").getValue();
			zenPage.getComponentById(name).setValue(value);
			this.doModified();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	#; If a PID is purposely removed when this page is renderred, then set isNew to true.
	If ..PID = "" Set ..isNew = 1
	
	If ..isNew {
		Set ..lblTitle = $$$Text("Use the form below to create a new Object Gateway Server definition:")
	} Else {
		Set ..lblTitle = $$$Text("Use the form below to edit an existing Object Gateway Server definition:")
	}
		
	// Load data into fields
	Set IsEnsemble = ##class(%Library.EnsembleMgr).IsEnsembleInstalled()
	Set tSC = ..LoadData(%page.PID,IsEnsemble)

	If tSC '= 1 {
		Set ..%GetComponentById("isRespond").value = tSC,..%GetComponentById("btnSave").disabled = 1
	} Else {
		// If gateway is currently running, then Do not allow edit.
		If %page.IsRunning {
			Set ..%GetComponentById("isRespond").value = $$$Text("Gateway is currently running! Edit is allowed only when Gateway is not running.")
			Set ..%GetComponentById("btnSave").disabled = 1
			For tProperty = "Name","Type","GatewayType","Server","Port","id_LogFile","HeartbeatInterval","HeartbeatFailureTimeout","HeartbeatFailureAction","HeartbeatFailureRetry","InitializationTimeout","ConnectionTimeout","JavaHome","JDKVersion","id_ClassPath","JVMArgs","AllowedIPAddresses","id_FilePath","Exec64","DotNetVersion" {
				Set ..%GetComponentById(tProperty).disabled = 1
			}
		} 
	}
	
	Set ..%GetComponentById("Exec64").hidden = ..Exec64Hidden(0)
	
	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	If ..isNew {
		Quit $$$Text("New Object Gateway")
	} Else {
		Quit $$$Text("Edit Object Gateway")
	}
}

/// User changed Type. Show/hide client/server credentials related fields.
ClientMethod changeType() [ Language = javascript ]
{
	if (zenPage.getComponentById('Type').getValue() == 1) {
		var hidejava = false;
		var hidenet = true;
		var hidenet64 = true;
	}
	else if (zenPage.getComponentById('Type').getValue() == 2) {
		hidejava = true;
		hidenet = false;
		hidenet64 = zenPage.Exec64Hidden(0);
	}
	else {
		alert('Unexpected Gateway type in method changeType');
		return;
	}

	zenPage.getComponentById('JavaHome').setHidden(hidejava);
	zenPage.getComponentById('JDKVersion').setHidden(hidejava);
	zenPage.getComponentById('id_ClassPath').setHidden(hidejava);
	zenPage.getComponentById('JVMArgs').setHidden(hidejava);
	zenPage.getComponentById('JAVAHOMEValue').setHidden(hidejava);
	zenPage.getComponentById('AllowedIPAddresses').setHidden(hidenet);
	zenPage.getComponentById('id_FilePath').setHidden(hidenet);
	zenPage.getComponentById('Exec64').setHidden(hidenet64);
	zenPage.getComponentById('DotNetVersion').setHidden(hidenet64);
}

/// Validation handler for form.
ClientMethod formValidationHandler() [ Language = javascript ]
{
	var pass = true;
	if (!this.validateRequired(zenPage.getComponentById("Name"),pass,"S")) pass = false;
	if (!this.validateRequired(zenPage.getComponentById("Server"),pass,"S")) pass = false;
	if (!this.validateRequired(zenPage.getComponentById("Port"),pass,"S")) pass = false;
	return pass;
}

/// Check if gateway is running.
ClientMethod checkIsRunning() [ Language = javascript ]
{
	var isrunning = 0;
	if (this.IsRunning == 0) return isrunning;
	alert(this.msgConfirmRunning);
	return 1;
}

/// Get user input and send to server to save settings.
ClientMethod doSave() [ Language = javascript ]
{
	try {
		if (this.checkIsRunning()) return;
		if (!this.formValidationHandler()) {
			this.afterValidate();
			return;
		} 
		var Type = zenPage.getComponentById("Type").getValue();
		var Name = zenPage.getComponentById("Name");
		// reset previous result message, if any
		var Server = zenPage.getComponentById("Server").getValue();
		var Port = zenPage.getComponentById("Port").getValue();
		var LogFile = zenPage.getComponentById("LogFile").getValue();
		var HeartbeatInterval = zenPage.getComponentById("HeartbeatInterval").getValue();
		var HeartbeatFailureTimeout = zenPage.getComponentById("HeartbeatFailureTimeout").getValue();
		var HeartbeatFailureAction = zenPage.getComponentById("HeartbeatFailureAction").getValue();
		var HeartbeatFailureRetry = zenPage.getComponentById("HeartbeatFailureRetry").getValue();
		var InitializationTimeout = zenPage.getComponentById("InitializationTimeout").getValue();
		var ConnectionTimeout = zenPage.getComponentById("ConnectionTimeout").getValue();
	
		if (Type == 1) {
			var J1 = zenPage.getComponentById("JavaHome").getValue();
			var J2 = zenPage.getComponentById("JDKVersion").getValue();
			var J3 = zenPage.getComponentById("ClassPath").getValue();
			var J4 = zenPage.getComponentById("JVMArgs").getValue();
		} else {
			var J1 = zenPage.getComponentById("AllowedIPAddresses").getValue();
			var J2 = zenPage.getComponentById("FilePath").getValue();
			var tJ3 =  zenPage.getComponentById("Exec64").getValue();
			if ((tJ3 == true) || (tJ3 == 'on') || (tJ3 == '1')) {
				var J3 = 1;
			} else {
				var J3 = 0;
			}
			var J4 = zenPage.getComponentById("DotNetVersion").getValue();
		}

		var proxy = this.SaveData(this.PID,Type,Name.getValue(),Server,Port,LogFile,HeartbeatInterval,HeartbeatFailureTimeout,HeartbeatFailureAction,HeartbeatFailureRetry,InitializationTimeout,ConnectionTimeout,J1,J2,J3,J4);
		this.afterSave(proxy);
	} 
  catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// If it is Edit, then enable/disable fields based on Type and do not show radioSet for Type because it is not clear. Show the label.
/// For Unix, you are here only if Ensemble is enabled and Java is the only Type available. Therefore the radio buttons for Type will be hidden.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if ((this.isNew == 0)||(this.IsUnix)) {
		this.changeType();
		this.showGatewayType();
	} else {
		if (this.IsEnsemble == 0) this.showGatewayType();
	}
}

/// Hide Type radiow buttons and show type as label
ClientMethod showGatewayType() [ Language = javascript ]
{
	zenPage.getComponentById("Type").setHidden(true);
	zenPage.getComponentById("GatewayType").setHidden(false);
}

/// Load values into fields. Special cases:<br>
/// If Ensemble is not enabled, then <br>
/// on Windows: .NET only<br>
/// on Unix:    Java only
Method LoadData(PID As %String, IsEnsemble As %Boolean) As %String
{
	Set $ZT="Error"
	If PID = "" {
		Set sys = ##class(%Net.Remote.ObjectGateway).%New()
		Set sys.Type = $S($zversion(1)=2:2,1:1)
	} ElseIf ##class(%Net.Remote.ObjectGateway).%ExistsId(PID) {
		Set sys = ##class(%Net.Remote.ObjectGateway).%OpenId(PID)
		Set ..%GetComponentById("Name").disabled = 1
		If sys.Type = 1 {
			Set ..%GetComponentById("JavaHome").value = sys.JavaHome
			Set ..%GetComponentById("JDKVersion").value = sys.JDKVersion
			Set ..%GetComponentById("ClassPath").value = sys.ClassPath
			Set ..%GetComponentById("JVMArgs").value = sys.JVMArgs
		} Else {
			Set ..%GetComponentById("AllowedIPAddresses").value = sys.AllowedIPAddresses
			Set ..%GetComponentById("FilePath").value = sys.FilePath
			Set ..%GetComponentById("Exec64").value = +sys.Exec64
			Set ..%GetComponentById("DotNetVersion").value = sys.DotNetVersion
		}
		Set %page.IsRunning = ##class(%Net.Remote.ObjectGateway).GatewayState(sys.Port)
	} Else {
		Set ..%GetComponentById("fld").hidden = 1
		Set ..InvalidParam = 1
		Quit $$$OK
	}
	Set ..%GetComponentById("Type").value = sys.Type

	Set %page.GatewayType = $S(sys.Type=1:"Java",1:".NET")
	Set %page.IsEnsemble = IsEnsemble
	Set %page.IsUnix = $zversion(1)=3

	Set ..%GetComponentById("Name").value = sys.Name
	Set ..%GetComponentById("Server").value = sys.Server
	Set ..%GetComponentById("Port").value = sys.Port
	Set ..%GetComponentById("LogFile").value = sys.LogFile
	Set ..%GetComponentById("HeartbeatInterval").value = sys.HeartbeatInterval
	Set ..%GetComponentById("HeartbeatFailureTimeout").value = sys.HeartbeatFailureTimeout
	Set:sys.HeartbeatFailureAction="" sys.HeartbeatFailureAction = "N"
	Set ..%GetComponentById("HeartbeatFailureAction").value = sys.HeartbeatFailureAction
	Set ..%GetComponentById("HeartbeatFailureRetry").value = sys.HeartbeatFailureRetry
	Set ..%GetComponentById("InitializationTimeout").value = sys.InitializationTimeout
	Set ..%GetComponentById("ConnectionTimeout").value = sys.ConnectionTimeout
	If 'IsEnsemble {
		// Restrict the heartbeat failure actions
		Set %page.msgActionsDisplay = $P(%page.msgActionsDisplay,",",1,2)
		Set %page.msgActionsValue = $P(%page.msgActionsValue,",",1,2)
	}
	Set tAction = ..%GetComponentById("HeartbeatFailureAction")
	Set tAction.displayList = %page.msgActionsDisplay
	Set tAction.valueList = %page.msgActionsValue
	Quit $$$OK
Error	///
	Set $ZT="" Do BACK^%ETN
	Quit $ZCVT($ZE,"O","HTML")
}

/// Save Object Gateway Server definition to server
ClassMethod SaveData(PID, Type, Name, Server, Port, LogFile, HeartbeatInterval, HeartbeatFailureTimeout, HeartbeatFailureAction, HeartbeatFailureRetry, InitializationTimeout, ConnectionTimeout, J1, J2, J3, J4) As %ZEN.proxyObject [ ZenMethod ]
{
	
	Set $ZT="Error"
	
	#dim sys as %Net.Remote.ObjectGateway

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 0
	Set tProxy.PID = PID
	Set tProxy.Message = ""
	Set tSC = $$$OK
	If PID'="",##class(%Net.Remote.ObjectGateway).%ExistsId(PID) {
		Set sys = ##class(%Net.Remote.ObjectGateway).%OpenId(PID)
	} Else {
		Set sys = ##class(%Net.Remote.ObjectGateway).%New()
		Set sys.Name = $zstrip(Name,"<>W")
		Set sys.Type = $zstrip(Type,"<>W")
	}
	Set sys.Server = $zstrip(Server,"<>W")
	Set sys.Port = $zstrip(Port,"<>W")
	Set sys.LogFile = $zstrip(LogFile,"<>W")
	Set sys.HeartbeatInterval = $zstrip(HeartbeatInterval,"<>W")
	Set sys.HeartbeatFailureTimeout = $zstrip(HeartbeatFailureTimeout,"<>W")
	Set sys.HeartbeatFailureAction = HeartbeatFailureAction
	Set sys.HeartbeatFailureRetry = $zstrip(HeartbeatFailureRetry,"<>W")
	Set sys.InitializationTimeout = $zstrip(InitializationTimeout,"<>W")
	Set sys.ConnectionTimeout = $zstrip(ConnectionTimeout,"<>W")
	If Type = 1 {
		Set sys.JavaHome = $zstrip(J1,"<>W")
		Set sys.JDKVersion = $zstrip(J2,"<>W")
		Set sys.ClassPath = $zstrip(J3,"<>W")
		Set sys.JVMArgs = $zstrip(J4,"<>W")
	} Else {
		Set sys.AllowedIPAddresses = $zstrip(J1,"<>W")
		Set sys.FilePath = $zstrip(J2,"<>W")
		Set sys.Exec64 = $zstrip(J3,"<>W")
		Set sys.DotNetVersion = $zstrip(J4,"<>W")
	}
	Set tSC = sys.%Save()
	If $$$ISERR(tSC) {
		Set tProxy.ErrorMessage = $ZCVT($System.Status.GetErrorText(tSC),"O","HTML")
	} Else {
		Set tProxy.ok = 1
		Set tProxy.PID = sys.%Id()
	}
	Kill sys
	Quit tProxy
Error	///
	Set $ZT="" Do BACK^%ETN
	Set tProxy.ErrorMessage = $ZCVT($ZE,"O","HTML")
	Quit tProxy
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

ClassMethod GetJAVAHOMEValue() As %String [ Internal ]
{
	Set tValue = $system.Util.GetEnviron("JAVA_HOME")
	Set:tValue="" tValue = $$$Text(" (Not defined)")
	Quit $ZCVT(tValue,"O","HTML")
}

/// If argument is 0 or false and system is 64 bits, return 0 (to be used as the value for attribute "hidden")
ClassMethod Exec64Hidden(b As %String = "1") As %Boolean [ Internal, ZenMethod ]
{
	Set t = 1
	If $system.Version.Is64Bits() && ((b="0") || (b="false")) Set t = 0
	Quit t
}

}
