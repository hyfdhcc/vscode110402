/// Zen page for System Management Portal - Join Async
Class %CSP.UI.Portal.Mirror.JoinAsync Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.Mirror.Utils) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

/// Displayed name of this page.
Parameter PAGENAME = "Join Mirror as Async";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Mirror.JoinAsync.zen";

Parameter HELPADDRESS = "Home,Configuration,Join Mirror as Async";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property MirrorRequiresSSL As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<label id="errmsg" hidden="true" enclosingClass="ErrorBox"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<hgroup>
<group id="Page1" valign="top">
<fieldSet label="Mirror Information" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<group labelPosition="left">
<text id="MirrorName" label="Mirror Name" size="20" maxlength="15" hint="Required." onchange="zenPage.cleanInput(zenThis);zenPage.doModified();"/>
</group>
<fieldSet labelPosition="left" label="Mirror Failover Member's Info" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<text id="AgentAddress" label="Agent Address on Failover System" size="32" hint="Required." onchange="zenPage.doModified();"/>
<text id="AgentPort" label="Mirror Agent Port" size="5" hint="Required." onchange="zenPage.doModified();"/>
<text id="InstanceName" label="Caché Instance Name" size="32" hint="Required." onchange="zenPage.doModified();"/>
</fieldSet>
<group labelPosition="left">
<label id="idNotifyText" label="SSL/TLS Requirement" controlClass="normal" controlStyle="font-style:italic;" hidden="true"/>
</group>
</fieldSet>
<spacer height="5px"/>
<label id="connectInstructions" label="Provide required information then click [Next] to retrieve data" containerStyle="padding-left:4px;"/>
</group>
<group id="Page2" hidden="true" valign="top">
<fieldSet label="Async Member Information" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;" labelPosition="left">
<text id="ShadowName" label="Async Member Name" size="32" hint="Required." onchange="zenPage.doModified();"/>
<text id="ShadowAddr" label="Async Member Address" size="32" hint="Required." onchange="zenPage.doModified();"/>
<select id="ShadowType" label="Async Member System Type" valueList="0,1,2" displayList="Disaster Recovery (DR),Read-Only Reporting,Read-Write Reporting" value="0" showEmpty="false" onchange="zenPage.doModified();"/>
<link id="linkSSL" onclick="zenPage.openSSL();return false;" href="#" enclosingClass="smpLink" hidden="true"/>
<label id="idWarnText" controlClass="rednote" hidden="true"/>
<label id="X509DN" label="X.509 Distinguished Name" controlClass="normal" hidden="true"/>
</fieldSet>
</group>
</hgroup>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	zen("MirrorName").focus();
	this.hideCommandButton("btnSave");
	this.hideCommandButton("btnClear");
	if (this.DisableSave) {
		this.disableCommandButton("btnSave");
	}
}

/// Overriding for DN redraw
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if ((popupName == "SSL") && (action == "ok")) {
			this.SSLDefined = 1;
			zen("linkSSL").setProperty("caption", $$$Text("Edit SSL/TLS"));
			zen("idWarnText").setHidden(true);
			zenPage.UpdateDN();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClientMethod goToNextPage() [ Language = javascript ]
{
	zen("Page1").setProperty("disabled",true);
	zen("connectInstructions").setHidden(true);
	zen("Page2").setHidden(false);
	this.hideCommandButton("btnConnect");
	this.showCommandButton("btnSave");
	this.showCommandButton("btnClear");
	zen('BtnCancel').setProperty('caption',$$$Text('Close'));
}

ClientMethod doClear() [ Language = javascript ]
{
	this.setModified(false);
	var url = '%25CSP.UI.Portal.Mirror.JoinAsync.zen';
	zenPage.gotoPage(url);
}

ClientMethod doConnect() [ Language = javascript ]
{
	this.resetMsg();
	var ok = this.validateConnect();
	if (!ok) {
		this.afterValidate();
		return;
	}
	
	var proxy = new zenProxy();
	
	proxy.MirrorName = zen("MirrorName").getValue();
	proxy.AgentAddress = zen("AgentAddress").getValue();
	proxy.AgentPort = zen("AgentPort").getValue();
	proxy.InstanceName = zen("InstanceName").getValue();

	var result = this.Connect(proxy);
	if (result.ok == 1) {
		this.goToNextPage();
	} else {
		this.showMsg(result.ErrorMessage,1);
	}
}

ClientMethod doSave() [ Language = javascript ]
{
	this.resetMsg();
	var proxy = new zenProxy();
	
	proxy.MirrorName = zen("MirrorName").getValue();
	proxy.AgentAddress = zen("AgentAddress").getValue();
	proxy.AgentPort = zen("AgentPort").getValue();
	proxy.InstanceName = zen("InstanceName").getValue();
	
	proxy.MemberName = zen("ShadowName").getValue();
	proxy.MemberAddress = zen("ShadowAddr").getValue();
	proxy.MemberType = zen("ShadowType").getValue();
	
	proxy.MirrorRequiresSSL = zenPage.MirrorRequiresSSL;
	proxy.SSLDefined = zenPage.SSLDefined;
	
	var ok = this.validateSave(proxy);
	if (!ok) return;

	var result = this.SaveData(proxy);
	this.afterSave(result);
	if ((result.ok == 1) && (result.Message != "")) {
		this.disableCommandButton('btnSave');
		this.disableCommandButton('btnClear');
	}
}

ClientMethod validateConnect() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('MirrorName'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('AgentAddress'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('AgentPort'),pass,"N")) pass = false;
		if (!this.validateRequired(zen('InstanceName'),pass,"S")) pass = false;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

ClientMethod validateSave(proxy) [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	var specialCase = false;
	try {
		if (!this.validateRequired(zen('ShadowName'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('ShadowAddr'),pass,"S")) pass = false;
		
		if (pass && proxy.MirrorRequiresSSL) {
			if (!proxy.SSLDefined) {
				// if user selects UseSSL and SSL is not defined, then do not go on.
				this.showMsg($$$Text("Please click the 'Set up SSL/TLS' link to set up SSL/TLS for this system."),1);
				specialCase = true;
				pass = false;
			} else {
				var sc = zenPage.InitialSSLverification(proxy.MirrorName,proxy.InstanceName,proxy.AgentAddress,proxy.AgentPort);
				if (!sc || !sc.length) {
					pass = true;
				} else {
					pass = confirm($$$Text("SSL verification found following problems:") + "\n\n" + sc + "\n\n" + $$$Text("Continue to joing mirror?"))
					specialCase = true;
					this.showMsg($$$Text("Joining mirror is aborted."),1);
				}
			}
		}
		if (!pass && !specialCase) {
			this.afterValidate();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;

	return pass;
}

///  Save general association data to server.<br/>
///  Returns proxy.ok = 1 (save successful) or 0 (error occurred)<br/>
///  proxy.ErrorMessage (save failed and display this error message).
///  If proxy.ok is 1 and no messages returned then we return to SMP home.
Method Connect(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 1

	Try {
		If ##class(Config.Mirrors).Exists(pProxy.MirrorName) {
			Set tmsg = $$$TextHTML("The Mirror is already configured in the system.")
			Set tSC = $$$ERROR($$$GeneralError,tmsg)
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set EMSManaged = 0
		Set MirrorConfig = ##class(SYS.MirrorConfiguration).RetrieveMirrorConfig(pProxy.MirrorName,pProxy.AgentAddress,pProxy.AgentPort,pProxy.InstanceName,.tSC,.Unicode,"",.EMSManaged)
		If '$IsObject(MirrorConfig) {
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		If EMSManaged {
			Set tmsg = $$$TextHTML("Target mirror is managed by Enterprise Manager, use Enterprise Manager to add this system as a mirror member.")
			Set tSC = $$$ERROR($$$GeneralError,tmsg)
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		#; Check if Unicode type match.
		if (Unicode '= "") && (Unicode '= (''$zbitget($zversion(0),1))) {
			Set tmsg = $$$TextHTML("The character size of the other system is different from local system.")
			Set tSC = $$$ERROR($$$GeneralError,tmsg)
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		Set (%page.MirrorRequiresSSL) = MirrorConfig.UseSSL
		If MirrorConfig.UseSSL = 0 {
			Set ..%GetComponentById("idNotifyText").value = $$$TextHTML("The mirror does not require SSL/TLS.")
			Set ..%GetComponentById("idNotifyText").hidden = 0
		} Else {
		    Set ..%GetComponentById("idNotifyText").value = $$$TextHTML("The mirror requires SSL/TLS.")
		    Set ..%GetComponentById("idNotifyText").hidden = 0
		    If '%page.SSLDefined {
			    Set ..%GetComponentById("idWarnText").hidden = 0
		    }
		    Set ..%GetComponentById("linkSSL").hidden = 0
		}

		if %page.SSLDefined {
			Do ..UpdateDN()
		}
		
		Set tSC = ..GetSSLLink(.linkSSL, .labelSSL)
		If $$$ISERR(tSC) {
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set %page.SSLLink = linkSSL
		Set ..%GetComponentById("linkSSL").caption = labelSSL
		
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method UpdateDN() As %Status [ ZenMethod ]
{
	Set tSC = ##class(SYS.MirrorConfiguration).DoSSLConfigurationsExist(.cn)
	If $$$ISOK(tSC) {
		Set ..%GetComponentById("X509DN").value = cn
		Set ..%GetComponentById("X509DN").hidden = 0
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
	Set tProxy.ok = 1
	Set tProxy.Message = ""

	Try {
		If ##class(Config.Mirrors).Exists(pProxy.MirrorName) {
			Set tmsg = $$$TextHTML("The Mirror is already configured in the system.")
			Set tSC = $$$ERROR($$$GeneralError,tmsg)
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set EMSManaged = 0
		Set MirrorConfig = ##class(SYS.MirrorConfiguration).RetrieveMirrorConfig(pProxy.MirrorName,pProxy.AgentAddress,pProxy.AgentPort,pProxy.InstanceName,.tSC,.Unicode,"",.EMSManaged)
		If '$IsObject(MirrorConfig) {
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		If EMSManaged {
			Set tmsg = $$$TextHTML("Target mirror is managed by Enterprise Manager, use Enterprise Manager to add this system as a mirror member.")
			Set tSC = $$$ERROR($$$GeneralError,tmsg)
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		#; Check if Unicode type match.
		if (Unicode '= "") && (Unicode '= (''$zbitget($zversion(0),1))) {
			Set tmsg = $$$TextHTML("The character size of the other system is different from local system.")
			Set tSC = $$$ERROR($$$GeneralError,tmsg)
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		if pProxy.SSLDefined {
			Set tSC = ##class(SYS.MirrorConfiguration).DoSSLConfigurationsExist()
			If $$$ISERR(tSC) Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		
		Set mir = ##class(Config.MirrorMember).Open()
		#; Don't pass Shadow Name if the Shadow Name already exist.
		if (mir.AsyncMemberGUID = "") {
			Set mir.SystemName = pProxy.MemberName
			Set mir.AsyncMemberType = pProxy.MemberType
		}
	
		Set prop("AgentAddress") = pProxy.AgentAddress
		Set prop("AgentPort") = pProxy.AgentPort
		Set prop("InstanceDirectory") = pProxy.InstanceName
		Set prop("ShadowType") = pProxy.ShadowType

		Set tSC = ##class(SYS.MirrorConfiguration).CreateNewShadow(pProxy.MirrorName,.prop,mir,,,pProxy.MemberAddress)
		If $$$ISERR(tSC) Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		
		If (pProxy.MirrorRequiresSSL = 1) {
			Set tProxy.Message = $$$FormatText($$$TextHTML("New Async member saved and activated. Reminder: Add %1 to the list of authorized Async members on the failover nodes in mirror %2"),pProxy.MemberName,pProxy.MirrorName)
		}
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

///  Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	If ..IsEditForm = 0 Quit $$$OK
	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnConnect",$$$Text("Next"),$$$Text("Connect to the specified instance and retrieve data"),"zenPage.doConnect();")
	Set pCommands(2) = $LB("btnSave",$$$Text("Save"),$$$Text("Save and join the mirror"),"zenPage.doSave();")
	Set pCommands(3) = $LB("btnClear",$$$Text("Clear"),$$$Text("Clear the form and start over"),"zenPage.doClear();")
	Set pCommands(4) = $LB("btnCancel",$$$Text("Cancel"),$$$Text("Return without saving new changes"),"zenPage.doCancel();")

	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	Quit $$$Text("Join Mirror as Async")
}

/// Set Locator bar and determine whether to show change password option.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..lblTitle = $$$TextHTML("Use the form below to join an existing Mirror as an async member")_":"
	
	Set ..%GetComponentById("AgentPort").value = $$$GetDefaultAgentPort
	Set ..%GetComponentById("ShadowAddr").value = $System.INetInfo.LocalHostName()
	Set ..%GetComponentById("idWarnText").value = $$$TextHTML("The mirror requires SSL/TLS. To join the mirror you must first set up SSL/TLS for this system.")
	
	Set mir = ##class(Config.MirrorMember).Open()
	If (mir.AsyncMemberGUID '= "") {
		Set ..%GetComponentById("ShadowName").value = mir.SystemName
		Set ..%GetComponentById("ShadowName").disabled = 1
		Set ..%GetComponentById("ShadowType").value = mir.AsyncMemberType
		Set ..%GetComponentById("ShadowType").disabled = 1
		Set ..%GetComponentById("ShadowType").hint = $$$TextHTML("To change member type, use the Edit Async page.")
	} Else {
		Set ..%GetComponentById("ShadowName").value = $$$GetDefaultSystemName
	}
	
	Quit 1
}

}
