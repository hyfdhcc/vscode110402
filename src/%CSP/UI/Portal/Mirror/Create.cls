/// Zen page for System Management Portal - Create Mirror
Class %CSP.UI.Portal.Mirror.Create Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.Mirror.Utils) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

/// Displayed name of this page.
Parameter PAGENAME = "Create Mirror";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Mirror.Create.zen";

Parameter HELPADDRESS = "Home,Configuration,Create Mirror";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

XData Style
{
<style type="text/css">
.fieldHint {
    color: gray;
    font-size: 12px;
    padding-left: 5px;
    vertical-align: super;
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
<fieldSet labelPosition="left" label="Mirror Information" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<hgroup label="Mirror Name">
<text id="MirrorName" size="15" hint="Required." onchange="zenPage.cleanInput(zenThis);zenPage.doModified();"/>
<spacer width="5px"/>
<label label="(max 15 characters)" labelClass="fieldHint"/>
</hgroup>
<hgroup label="Require SSL/TLS">
<checkbox id="UseSSL" onchange="zenPage.toggleSSL(zenThis.getValue());zenPage.doModified();" title="Mirroring requires SSL when journal file encryption is enabled." value="1"/>
<link id="linkSSL" onclick="zenPage.openSSL();return false;" href="#" enclosingClass="smpLink"/>
</hgroup>
<label id="idWarnSSL" controlClass="rednote" hidden="true"/>
<checkbox id="UseArbiter" label="Use Arbiter" onchange="zenPage.toggle('idArbiter');zenPage.doModified();" value="1"/>
<vgroup id="idArbiter">
<hgroup labelPosition="left" cellVAlign="top">
<text id="ArbiterAddress" label="Address" size="12" hint="Required." onchange="zenPage.doModified();"/>
<spacer width="5px"/>
<text id="ArbiterPort" label="Port" size="6" hint="Required." onchange="zenPage.doModified();"/>
</hgroup>
</vgroup>
<checkbox id="UseVIP" label="Use Virtual IP" onchange="zenPage.toggle('idNetwork');zenPage.doModified();"/>
<vgroup id="idNetwork" hidden="true">
<hgroup labelPosition="left" cellVAlign="top">
<text id="VirtualAddress" label="IP Address" size="12" hint="Required." onchange="zenPage.doModified();"/>
<spacer width="5px"/>
<text id="CIDRMask" label="Mask (CIDR format)" size="4" hint="Required." onchange="zenPage.doModified();"/>
</hgroup>
<html id="networkInterfaceHTML" label="Network Interface" OnDrawContent="DrawNetworkInterface" hint="Required."/>
<spacer height="3px"/>
<vgroup id="idVAI" hidden="true">
<text id="VirtualAddressInterface" size="55" onchange="zenPage.doModified();"/>
<spacer height="3px"/>
<label label="(add index number if needed)" labelClass="fieldHint"/>
</vgroup>
</vgroup>
<combobox id="FOCmpMode" label="Compression Mode For Failover Members" dropdownHeight="60px" onchange="zenPage.CompressMode(zenThis.getValue(),false);">
<option value="0" text="System Selected" />
<option value="1" text="Uncompressed" />
<option value="2" text="Compressed" />
</combobox>
<combobox id="ASYNCmpMode" label="Compression Mode For Async Members" dropdownHeight="60px" onchange="zenPage.CompressMode(zenThis.getValue(),true);">
<option value="0" text="System Selected" />
<option value="1" text="Uncompressed" />
<option value="2" text="Compressed" />
</combobox>
</fieldSet>
<fieldSet labelPosition="left" label="Mirror Failover Member Information" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<text id="Name" label="Mirror Member Name" size="32" hint="Required." onchange="zenPage.cleanInput(zenThis);zenPage.doModified();"/>
<text id="ECPAddress" label="Superserver Address" size="32" onkeyup="zenPage.updateAddress(zenThis.getValue(),true);" hint="Required." onchange="zenPage.doModified();"/>
<text id="AgentPort" label="Mirror Agent Port" size="10" hint="Required." onchange="zenPage.doModified();"/>
</fieldSet>
</hgroup>
<link caption="Advanced Settings" onclick="zenPage.toggle('AdvancedContainer');return false;" href="#" enclosingClass="smpLink"/>
<hgroup id="AdvancedContainer" hidden="true">
<fieldSet labelPosition="left" label="Mirror Settings" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<text id="QOSTimeout" label="Quality of Service Timeout (msec)" size="10" value="8000" onchange="zenPage.doModified();"/>
</fieldSet>
<fieldSet labelPosition="left" label="This Failover Member" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<text id="MirrorAddress" label="Mirror Private Address" size="32" onchange="zenPage.modifiedAddress();"/>
</fieldSet>
</hgroup>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	zen("MirrorName").focus();
	if (this.DisableSave) {
		this.disableCommandButton("btnSave");
	}
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			if (popupName == "SSL") {
				this.SSLDefined = 1;
				zen("linkSSL").setProperty("caption", $$$Text("Edit SSL/TLS"));
			}
		}
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in onPopupAction");
	}
}

ClientMethod validate(proxy) [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	var errorShown = false;
	try {
		if (!this.validateRequired(zen('MirrorName'),pass,"S")) pass = false;
		if (proxy.UseArbiter) {
			if (!this.validateRequired(zen('ArbiterAddress'),pass,"S")) pass = false;
			if (!this.validateRequired(zen('ArbiterPort'),pass,"N")) pass = false;
		}
		if (proxy.UseVIP) {
			if (!this.validateRequired(zen('VirtualAddress'),pass,"S")) pass = false;
			if (!this.validateRequired(zen('CIDRMask'),pass,"N")) pass = false;
			if (zenTrim(proxy.VirtualAddressInterface) == '') {
				this.showMsg(this.ValidationErrorMsg,1);
				var ctl = document.getElementById("VIPNetworkInterface");
				ctl.focus();
				zen('networkInterfaceHTML').setProperty("hintClass","redText");
				ctl.className = "zenInvalid";
				errorShown = true;
				pass = false;
			} else {
				zen('networkInterfaceHTML').setProperty("hintClass","helpText");
				document.getElementById("VIPNetworkInterface").className = "";
			}
		}
		if (!this.validateRequired(zen('Name'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('ECPAddress'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('AgentPort'),pass,"N")) pass = false;
		
		if (pass) {
			// if user selects UseSSL and SSL is not defined, then do not go on.
			if (proxy.UseSSL && !this.SSLDefined) {
				this.showMsg($$$Text("Please click the 'Set up SSL/TLS' link to set up SSL/TLS for this system."),1);
				errorShown = true;
				pass = false;
			}
		}
		if (!pass && !errorShown) {
			this.afterValidate();
		}
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in validate");
	}
	zenSynchronousMode = oldSynchronousMode;

	return pass;
}

ClientMethod doSave() [ Language = javascript ]
{
	this.resetMsg('');
	
	var proxy = new zenProxy();
	
	proxy.MirrorName = zen("MirrorName").getValue();
	proxy.UseSSL = zen("UseSSL").getValue();
	proxy.UseArbiter = zen("UseArbiter").getValue();
	if (proxy.UseArbiter) {
		proxy.ArbiterAddress = zenTrim(zen("ArbiterAddress").getValue());
		proxy.ArbiterPort = zenTrim(zen("ArbiterPort").getValue());
		proxy.ArbiterNode = proxy.ArbiterAddress+'|'+proxy.ArbiterPort;
	} else {
		proxy.ArbiterNode = "";
	}
	proxy.UseVIP = zen("UseVIP").getValue();
	proxy.VirtualAddress = zen("VirtualAddress").getValue();
	proxy.CIDRMask = zen("CIDRMask").getValue();
	proxy.VirtualAddressInterface = zen("VirtualAddressInterface").getValue();
	
	proxy.Name = zen("Name").getValue();
	proxy.ECPAddress = zen("ECPAddress").getValue();
	proxy.AgentPort = zen("AgentPort").getValue();
	
	proxy.QOSTimeout = zen("QOSTimeout").getValue();
	
	proxy.MirrorAddress = zen("MirrorAddress").getValue();
	
	proxy.CompressionForFailoverMembers = zen("FOCmpMode").getValue();
	proxy.CompressionForAsyncMembers = zen("ASYNCmpMode").getValue();

	var ok = this.validate(proxy);
	if (!ok) return;

	var result = this.SaveData(proxy);
	this.afterSave(result);
}

/// Set Locator bar and determine whether to show change password option.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..lblTitle = $$$Text("Use the form below to create a Mirror")_":"
	
	Set tSC = ..GetSSLLink(.linkSSL, .labelSSL)
	If $$$ISERR(tSC) {
		Do ..DisplayError(tSC)
		Quit $$$OK
	}
	Set ..%GetComponentById("linkSSL").caption = labelSSL
	Set %page.SSLLink = linkSSL
	
	Set tSC = ##class(SYS.Mirror).CheckISCAgent()
	If $$$ISERR(tSC) {
		Do ..DisplayError(tSC)
		Quit $$$OK
	}

	// SML1756 ; check both runtime and startup journal encryption status.
	If ##class(%SYS.Journal.System).IsJournalEncryptionEnabled(3) {
		Set ..%GetComponentById("UseSSL").disabled = 1
	}

	Set ..%GetComponentById("Name").value = $$$GetDefaultSystemName
	Set (..%GetComponentById("ECPAddress").value,..%GetComponentById("MirrorAddress").value) = $System.INetInfo.LocalHostName()
	Set (..%GetComponentById("AgentPort").value,..%GetComponentById("ArbiterPort").value) = $$$GetDefaultAgentPort
	
	Set ..%GetComponentById("idWarnSSL").value = $$$Text("Use of SSL/TLS is highly recommended!")
	// SML2049+ ;Default is 'System Selected'.
	Set ..%GetComponentById("FOCmpMode").value = 0
	Set ..%GetComponentById("ASYNCmpMode").value = 0
	Set ..CurrentFOCmpMode = 0
	Set ..CurrentASYNCmpMode = 0
	// SML2049-

	Quit 1
}

Method %OnGetPageName() As %String
{
	Quit $$$Text("Create Mirror")
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

	Try {
		#; If user selected No then make sure to reset VirtualAddress and VirtualAddressInterface to null.
		If (pProxy.UseVIP = 0) {
			Set (VirtualAddress,CIDRMask,VirtualAddressInterface) = ""
		} Else {
			Set VirtualAddress = pProxy.VirtualAddress
			Set CIDRMask = pProxy.CIDRMask
			Set VirtualAddressInterface = pProxy.VirtualAddressInterface
		}
				
		Set MirrorInfo("QOSTimeout") = pProxy.QOSTimeout
		Set MirrorInfo("UseSSL") = pProxy.UseSSL
		Set MirrorInfo("VirtualAddress") = VirtualAddress_$S(CIDRMask'="":"/",1:"")_CIDRMask
		Set MirrorInfo("VirtualAddressInterface") = VirtualAddressInterface
		Set MirrorInfo("AgentPort") = pProxy.AgentPort
		Set MirrorInfo("ECPAddress") = pProxy.ECPAddress
		Set MirrorInfo("MirrorAddress") = pProxy.MirrorAddress
		Set MirrorInfo("ArbiterNode") = pProxy.ArbiterNode
		Set MirrorInfo("CompressionForFailoverMembers") = pProxy.CompressionForFailoverMembers
		Set MirrorInfo("CompressionForAsyncMembers") = pProxy.CompressionForAsyncMembers
		
		Set tSC = ##class(SYS.Mirror).CreateNewMirrorSet(pProxy.MirrorName,pProxy.Name,.MirrorInfo)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

}
