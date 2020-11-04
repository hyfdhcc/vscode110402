/// <p>This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. 
/// There is no guarantee made about either the behavior or future operation of this class.</p>
/// Edit ECP Data Server for Management Portal
Class %CSP.UI.Portal.Dialog.ECPDataServer Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Dialog.ECPDataServer.zen";

/// Displayed name of this page.
Parameter PAGENAME = "ECP Data Server";

/// If true, then this dialog displays an Apply button.
Parameter APPLYBUTTON As BOOLEAN = 0;

Parameter EMSSERVICE = "Namespace";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property SERVERNAME As %String(ZENURL = "ID");

/// mode - "new", "edit", "changeStatus"
Property action As %String(ZENURL = "action");

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title instructions */
div.Description	{
	font-size: 0.9em; 
	padding: 5px;
}
.note {
	font-size: 0.9em;
	color: #da4848;
	font-weight: normal;
	width: 600;
	border: 1px solid gray;
	padding: 10px;
	margin-top:5px;
}
</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />

<pane paneName="dialogBody" id="body" />

<hgroup id="footer" width="100%" cellAlign="right">
<hgroup id="buttonHolder" cellAlign="right">
<button id="btnCancel" controlClass="commandButton" caption="Cancel" onclick="zenPage.dialogCancel();" />
<spacer width="5" />
<button id="btnFinish" controlClass="commandButton" caption="Save" onclick="zenPage.dialogFinish();;"/>
</hgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:4 6 4 10;">
<spacer height="2"/>
<label id="idRespond" enclosingClass="note" containerStyle="padding-top:10px;padding-left:4px;" hidden="true"/>
<html OnDrawContent="DrawPageTitle" seed=""/>
<group id="formContainer" labelPosition="left" cellStyle="padding-bottom:5px;">
<text id="ServerName" label="Server Name" size="15" hint="Required."/>
<text id="HostName" label="Host DNS Name or IP Address" size="15" hint="Required."/>
<text id="IPPort" label="IP Port" size="15" hint="Required."/>
<checkbox id="MirrorConnection" label="Mirror Connection"/>
<label id="CurrStatus" label="Current Status" controlClass="normal" hidden="true"/>
<select id="Status" label="Change Status to" showEmpty="false" hidden="true"/>
</group>
<html id="ChangeStatusWarning" OnDrawContent="DrawChangeStatusWarning" hidden="true"/>

</pane>
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	// Don't invokeSuper...we need the finish button active if read only on managed instance.
	//this.invokeSuper('onloadHandler',arguments);
	if (this.InvalidParam) {
		var btnArray = ['btnOK','btnApply','btnFinish'];
		for (var i=0;i<btnArray.length;i++) {
			var btn = zen(btnArray[i]);
			if (btn) {
				zen(btnArray[i]).setProperty('controlClass','commandButtonDisabled');
				zen(btnArray[i]).setProperty('onclick','return false;');
			}
		}
	}
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onstartHandler() [ Language = javascript ]
{
	if (this.action == "new") {
		zen("ServerName").focus();
	} else if (this.action == "edit") {
		zen("HostName").focus();
	} else {
		zen("Status").focus();
	}
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		if (this.validate()==false) return false;
		if (this.doSave()==false) return false;
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	var serverName = encodeURIComponent(zen("ServerName").getValue());
	return serverName;
}

ClientMethod validate() [ Language = javascript ]
{
	this.resetMsg();
	var allOK = true;
	if (this.action !== "changeStatus") {
		var IPPort = zen("IPPort");
		var HostName = zen("HostName");
		var ServerName = zen("ServerName");
		
		IPPort.setProperty("hintClass","helpText");
		HostName.setProperty("hintClass","helpText");
		ServerName.setProperty("hintClass","helpText");
		
		if (IPPort.getValue().length < 1) {
			IPPort.setProperty("hintClass","redText");
			IPPort.focus();
			allOK = false;
		}
		if (HostName.getValue().length < 1) {
			HostName.setProperty("hintClass","redText");
			HostName.focus();
			allOK = false;
		}
		if (ServerName.getValue().length < 1) {
			ServerName.setProperty("hintClass","redText");
			ServerName.focus();
			allOK = false;
		}
		if (!allOK) {
			this.showMsg($$$Text('Please complete all required fields.'));
			return false;
		}
	}
	return true;
}

ClientMethod doSave() [ Language = javascript ]
{
	this.resetMsg();
	var proxy = new zenProxy();
	proxy.ServerName = zen("ServerName").getValue();
	proxy.HostName = zen("HostName").getValue();
	proxy.IPPort = zen("IPPort").getValue();
	proxy.MirrorConnection = zen("MirrorConnection").getValue() ? 1 : 0;
	proxy.Status = zen("Status").getValue();
	proxy.action = zenPage.action;
	var result = this.SaveData(proxy);
	if (result.ok != 1) {
		this.showMsg(result.ErrorMessage);
		return false;
	}
	return true;
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$Text("ECP Data Server")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set SERVERNAME = ..SERVERNAME
	If ((SERVERNAME = "") || ((..action '= "edit") && (..action '= "changeStatus"))) {
		Set ..action = "new"
	}
	Set action = ..action
	
	If action = "new" {
		Set ..%GetComponentById("IPPort").value = "1972"
	} Else {
		Set ..%GetComponentById("ServerName").value = SERVERNAME
		Set ..%GetComponentById("ServerName").disabled = 1
		Set tSC = ##class(Config.ECPServers).Get(SERVERNAME,.Properties)
		If $$$ISERR(tSC) {
			Set ..%GetComponentById("idRespond").value = $System.Status.GetErrorText(tSC)
			Set ..%GetComponentById("idRespond").hidden = 0
			Set ..%GetComponentById("formContainer").hidden = 1
		}
		
		Set ..%GetComponentById("HostName").value = Properties("Address")
		Set ..%GetComponentById("IPPort").value = Properties("Port")
		Set ..%GetComponentById("MirrorConnection").value = Properties("MirrorConnection")
		If (action = "edit") {
			If (Properties("MirrorConnection") = 1) {
				Set ..%GetComponentById("MirrorConnection").disabled = 1
			}
		} Else {
			Set ..%GetComponentById("HostName").disabled = 1
			Set ..%GetComponentById("IPPort").disabled = 1
			Set ..%GetComponentById("MirrorConnection").disabled = 1
			
			Set Status = ##class(SYS.ECP).GetServerConnState(SERVERNAME)
			Set ..%GetComponentById("CurrStatus").value = $Case(Status,-2:$$$Text("Invalid connection name"),-1:$$$Text("Invalid"),0:$$$Text("Initializing"),1:$$$Text("Not Connected"),2:$$$Text("Connection in Progress"),3:$$$Text("Connection Failed"),4:$$$Text("Disabled"),5:$$$Text("Normal"),6:$$$Text("Trouble"),7:$$$Text("Recovery"), :"")
			Set ..%GetComponentById("CurrStatus").hidden = 0
			
			Set dropDown = ..%GetComponentById("Status")
			Set dropDown.hidden = 0
			Set msgStatus(1) = $$$Text("Not Connected")
			Set msgStatus(2) = $$$Text("Disabled")
			Set msgStatus(3) = $$$Text("Normal")
			If (Status = 1) {
				Set dropDown.displayList = msgStatus(2)_","_msgStatus(3)
				Set dropDown.valueList = "2,3"
			} ElseIf (Status = 4) {
				Set dropDown.displayList = msgStatus(1)_","_msgStatus(3)
				Set dropDown.valueList = "1,3"
			} ElseIf (Status = 5) {
				Set dropDown.displayList = msgStatus(1)_","_msgStatus(2)
				Set dropDown.valueList = "1,2"
			} Else {
				Set dropDown.displayList = msgStatus(1)_","_msgStatus(2)_","_msgStatus(3)
				Set dropDown.valueList = "1,2,3"
			}
			
			Set ..%GetComponentById("ChangeStatusWarning").hidden = 0
		}
	}
	Quit $$$OK
}

ClassMethod DrawPageTitle(pSeed As %String) As %Status
{
	If %page.action = "new" {
		Set tPageTitle = $$$TextHTML("Add a new ECP data server")_"<br/>"
	} ElseIf %page.action = "edit" {
		Set tPageTitle = $$$FormatText($$$Text("Edit definition for ECP data server %1"),..EscapeHTML(%page.SERVERNAME))_"<br/>"
	} Else {
		Set tPageTitle = $$$FormatText($$$Text("Change status of ECP data server %1"),..EscapeHTML(%page.SERVERNAME))_"<br/>"
	}
	&html<<div class="Description">#(tPageTitle)#</div>
	<hr size="1"/>>
	Quit 1
}

ClassMethod DrawChangeStatusWarning(pSeed As %String) As %Status
{
	Set msg = $$$Text("WARNING: <br><br>Setting a connection to the 'Not Connected' or 'Disabled' states or editing an active connection will send an error to all applications awaiting network replies from that server. <br><br>Cached blocks from the data server are purged, all locks are released and transactions are rolled back.")
	&html<<div class="note">#(msg)#</div>>
	Quit $$$OK
}

ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 1
	Set tProxy.ErrorMessage = ""
	
	Try {
		Set serverName = $ZCVT(pProxy.ServerName,"U")
		Set Properties("Address") = pProxy.HostName
		Set Properties("Port") = pProxy.IPPort
		Set Properties("MirrorConnection") = pProxy.MirrorConnection
		If pProxy.action = "new" {
			Set tSC = ##class(Config.ECPServers).Create(serverName,.Properties)
		} ElseIf pProxy.action = "edit" {
			Set tSC = ##class(Config.ECPServers).Modify(serverName,.Properties)		
		} Else {
			Set tSC = ##class(SYS.ECP).ServerAction(serverName,pProxy.Status)
		}
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
	
	} Catch Error {
		Set Message = ..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = Message
	}
	Quit tProxy
}

}
