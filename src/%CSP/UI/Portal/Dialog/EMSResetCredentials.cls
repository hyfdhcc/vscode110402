Include %ems

/// <p>This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. 
/// There is no guarantee made about either the behavior or future operation of this class.</p>
/// EMS Credentials Reset for Management Portal
Class %CSP.UI.Portal.Dialog.EMSResetCredentials Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

Parameter CSPURL = "/csp/sys/%CSP.UI.Portal.Dialog.EMSResetCredentials.zen";

/// Displayed name of this page.
Parameter PAGENAME = "EMSResetCredentials";

Parameter AUTONS As BOOLEAN = 0;

/// If true, then this dialog displays an Apply button.
Parameter APPLYBUTTON As BOOLEAN = 0;

/// Localization Domain
Parameter DOMAIN = "%EMSMessages";

Parameter HELPID = "GSA_config_enterprisemanager_applying";

/// User must hold at least operator privilege to use this dialog.
Parameter RESOURCE = "%Admin_Manage,%Admin_Secure";

Property ConnectionEstablished As %Boolean [ InitialExpression = 0 ];

/// Keeps track of the first form field that failed during validation.
Property FirstFailed As %String;

Property SecurityPolicy As %String;

Property ValidationErrorMsg As %String [ InitialExpression = {$$$Text("There was a problem with the form. See the highlighted fields below.")} ];

Property InstanceAddr As %String;

Property InstancePort As %String;

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
	background: #F2F1EC;
	border: 1px solid #4D3926;
	border-radius: 5px;
	color: #4D3926;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
	padding: 10px;
	text-align: left;
}
a.link {
	color: #3b84bc;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 0.8em; 
	font-weight: bold;
	padding-left: 4px;
	text-decoration: none; 
}
a.link:visited {
	color: #3b84bc;
}
a.link:hover {
	color: #98923a;
}
.smpLink a.link {
	text-decoration:underline;
	font-weight:normal;
}
</style>
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="body" cellStyle="padding:4 6 4 10;">
<label id="idRespond" enclosingClass="note" containerStyle="padding-top:10px;padding-left:4px;" hidden="true"/>
<tabGroup id="tabGroup">

<!-- First Page -->
<tab id="tab1" enclosingStyle="padding-top:10px;" cellStyle="padding-bottom:10px;">
<group labelPosition="left" cellStyle="padding:4px;">
<label id="ServerLocReceived" label="Enterprise Manager Credentials" controlClass="normal"/>
</group>
<html OnDrawContent="DrawPageTitle" seed="2" enclosingStyle="padding-bottom:6px;border-bottom:1px solid teal;width:835px;"/>

<label id="policyLabel"/>

<!-- No Security (Password Security) -->
<group id="passwordGroup" labelPosition="left" hidden="true" cellStyle="padding:4px;">
<label label="This security option is meant for demo and testing purposes only!" labelClass="rednote"/>
</group>

<!-- Certificate Security -->
<group id="certificateGroup" labelPosition="left" hidden="true" cellStyle="padding:4px;">
<group id="NoSSL" hidden="true">
<hgroup labelPosition="left">
<link id="SSLLink" label="There are no valid SSL/TLS configurations on this instance." labelStyle="font-style:italic;" href="sec/%25CSP.UI.Portal.SSLList.zen" target="_blank" caption="Add/Edit Configurations" enclosingClass="smpLink"/>
<spacer width="10px"/>
<link caption="Check for Updates" href="#" onclick="zenPage.doCheckForValidCredentials('SSL');" enclosingClass="smpLink"/>
</hgroup>
<group>
<label label="SSL configurations must be type 'Client' and have a CA certificate, certificate file, private key, and password for use with Enterprise Manager."/>
</group>
</group>
<group id="HasSSL" labelPosition="left" hidden="true">
<hgroup id="ServerSSLConfigGroup" label="SSL/TLS Configuration" labelPosition="left" cellStyle="padding:4px;">
<dataCombo id="ServerSSLConfig"
queryClass="Security.SSLConfigs"
queryName="ListEMS"
showEmpty="false"
cached="true"
displayColumns="1"
valueColumn="1"
choiceColumn="1"
hint="Required."
onchange="zenPage.updateState();"
/>
<link href="sec/%25CSP.UI.Portal.SSLList.zen" caption="View SSL/TLS configurations" target="_blank" containerStyle="vertical-align:top;" enclosingClass="smpLink"/>
</hgroup>
<group>
<label label="SSL configurations must be type 'Client' and have a CA certificate, certificate file, private key, and password for use with Enterprise Manager. Other configurations are not listed above."/>
</group>
</group>
<group id="NoAlias" hidden="true">
<hgroup labelPosition="left">
<link id="AliasLink" label="There are no valid X.509 credentials on this instance." labelStyle="font-style:italic;" href="sec/%25CSP.UI.Portal.X509Credentials.zen" target="_blank" caption="Add/Edit Credentials" enclosingClass="smpLink"/>
<spacer width="10px"/>
<link caption="Check for Updates" href="#" onclick="zenPage.doCheckForValidCredentials('X509');" enclosingClass="smpLink"/>
</hgroup>
<group>
<label label="X.509 credentials must have a private key and password for use with Enterprise Manager."/>
</group>
</group>
<group id="HasAlias" labelPosition="left" hidden="true">
<hgroup id="aliasGroup" labelPosition="left" label="X.509 Alias" cellStyle="padding:4px;">
<dataCombo id="alias"
queryClass="%SYS.X509Credentials"
queryName="ListEMS"
showEmpty="false"
cached="true"
displayColumns="1"
valueColumn="1"
choiceColumn="1"
dropdownWidth="300px"
dropdownHeight="100px"
hint="Required."
onchange="zenPage.updateState();"
/>
<spacer width="1.0em"/>
<link href="sec/%25CSP.UI.Portal.X509Credentials.zen" caption="View/edit X.509 credentials" target="_blank" containerStyle="vertical-align:top;" enclosingClass="smpLink"/>
</hgroup>
<group>
<label label="X.509 credentials must have a private key and password for use with Enterprise Manager. Other credentials are not listed above."/>
</group>
<!--
<certificateViewer id="serverCert" label="Server's Certificate"/>
<checkbox id="acceptCertificate" label="Accept this Certificate" hint="Required." onchange="zenPage.updateState();"/>
-->
</group>
</group>
</tab>

</tabGroup>
</pane>
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.<br/>
/// If this returns false, then the action is cancelled.
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		return this.doSave();
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,"error in ondialogFinish");
	}
	return true;
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return '';
}

/// This client event, if present, is fired when the page is resized.
ClientMethod onresizeHandler() [ Language = javascript ]
{
	var wd = zenGetWindowWidth() - 80;
	var ht = zenGetWindowHeight() - 210;
	if (wd < 100) wd = 100;
	if (ht < 100) ht = 100;
}

/// This is called when the template is first displayed;<br/>
/// This provides a chance to load the last filetype, etc.
ClientMethod onstartHandler() [ Language = javascript ]
{
	//zen("ServerAddr").focus();
	zenPage.updateState();
}

/// Return true if this template can go to the next page (i.e., enable
/// the Next button).<br>
ClientMethod canGoNext() [ Language = javascript ]
{
	return false;
}

/// Return true if this template can go to the previous page (i.e., enable
/// the Back button).<br>
/// This is implemented by subclasses.
ClientMethod canGoBack() [ Language = javascript ]
{
	return false;
}

/// Return true if this template can Finish (i.e., enable
/// the Finish button).<br>
ClientMethod canFinish() [ Language = javascript ]
{
	return true;
}

ClientMethod hasMultiplePages() [ Language = javascript ]
{
	return false;
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var proxy = new zenProxy();
	proxy.ServerAddr = zenPage.InstanceAddr;
	proxy.ServerPort = zenPage.InstancePort;
	proxy.ServerPrefix = "";
	var result = zenPage.RequestPolicy(proxy);
	if (result.ok != 1) {
		zenPage.showMsg(result.ErrorMessage,1);
	}
	zenPage.SecurityPolicy = result.Policy;
	
	if (result.Policy == "Username") {
		zen("passwordGroup").setHidden(false);
		msg = $$$Text("This Enterprise Manager instance uses the unsecured security option.");
	} else {
		zen("certificateGroup").setHidden(false);
		if (result.Policy == "SSL") {
			msg = $$$Text("This Enterprise Manager instance uses SSL/TLS security.");
			var tServerSSLConfig = zenPage.getComponentById("ServerSSLConfig");
			var optCount = tServerSSLConfig.getOptionCount();
			for (i = 0; i < optCount; i++) {
				if (result.Credentials == tServerSSLConfig.getOptionText(i)) {
					var optVal = tServerSSLConfig.getOptionValue(i);
					tServerSSLConfig.setValue(optVal);
				}
			}
			if (result.NoSSL == 1) {
				zen("NoSSL").setHidden(false);
			} else {
				zen("HasSSL").setHidden(false);
				focusField = "ServerSSLConfig";
			}
		} else {
			//var cert = zen("serverCert");
			//cert.setProperty('Certificate',result.Certificate);
			//cert.ReallyRefreshContents();
			msg = $$$Text("This Enterprise Manager instance uses WS-Security.");
			var tAlias = zenPage.getComponentById("alias");
			var optCount = tAlias.getOptionCount();
			for (i = 0; i < optCount; i++) {
				if (result.Credentials == tAlias.getOptionText(i)) {
					var optVal = tAlias.getOptionValue(i);
					tAlias.setValue(optVal);
				}
			}
			if (result.NoAlias == 1) {
				zen("NoAlias").setHidden(false);
			} else {
				zen("HasAlias").setHidden(false);
				focusField = "alias";
			}
		}
	}
	zen("policyLabel").setProperty('label',msg);
}

/// Called when returning from creating an SSL configuration.
ClientMethod updateSSLList(val) [ Language = javascript ]
{
	try {
		var e = zen('ServerSSLConfig');
		e.clearCache();
		e.setValue(val);
		e.setHidden(false);
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in updateSSLList");
	}
}

/// Called when returning from deleting an SSL configuration
ClientMethod updateSSLListForDelete(val) [ Language = javascript ]
{
	try {
		var cfg = zen('ServerSSLConfig');
		if (cfg.getValue() == val) this.updateSSLList("") // deleted previously selected SSL configuration
		else this.updateSSLList(cfg.getValue()) // deleted unselected SSL configuration
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in updateSSLListForDelete");
	}
}

/// Called when returning from creating an X509 credentials
ClientMethod updateX509List(val) [ Language = javascript ]
{
	try {
		var e = zen('alias');
		e.clearCache();
		e.setValue(val);
		e.setHidden(false);
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in updateX509List");
	}
}

/// Called when returning from deleting an X509 credentials
ClientMethod updateX509ListForDelete(val) [ Language = javascript ]
{
	try {
		var e = zen('alias');
		if (e.getValue() == val) this.updateX509List("") // deleted previously selected X509 credentials
		else this.updateX509List(e.getValue()) // deleted unselected X509 credentials
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in updateX509ListForDelete");
	}
}

/// Go to the next page of the template (if there is one).<br/>
ClientMethod nextPage() [ Language = javascript ]
{
	zenPage.updateState();
}

/// Go to the previous page of the template (if there is one).<br/>
/// This is implemented by subclasses.
ClientMethod previousPage() [ Language = javascript ]
{
	zenPage.updateState();
}

ClientMethod doCheckForValidCredentials(policy) [ Language = javascript ]
{
	try {
		this.resetMsg();
		var credsExist = this.CheckForValidCredentials(policy);
		if (!credsExist) {
			this.showMsg($$$Text('There are still no valid credentials.'),true);
			return;
		} else {
			if (policy == "X509") {
				zen("NoAlias").setHidden(true);
				zen("HasAlias").setHidden(false);
				zen("alias").focus();
			} else {
				zen("NoSSL").setHidden(true);
				zen("HasSSL").setHidden(false);
				zen("ServerSSLConfig").focus();
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,"error in doCheckForValidCredentials");
	}
}

/// Process save and create new db. Return true if success. OW return false.
ClientMethod doSave() As %Boolean [ Language = javascript ]
{
	try {
		var ok = zenPage.validate2(this.SecurityPolicy);
		if (!ok) {
			zenPage.afterValidate();
			return false;
		}
		
		var proxy = new zenProxy();
		proxy.Policy = this.SecurityPolicy;
		proxy.SSLConfig = zen("ServerSSLConfig").getValue();
		proxy.alias = zen("alias").getValue();
		if (proxy.Policy == "X509") {
			proxy.Credentials = proxy.alias;
		} else if (proxy.Policy == "SSL") {
			proxy.Credentials = proxy.SSLConfig;
		} else {
			proxy.Credentials = "";
		}
		//proxy.InstanceAddr = zen("InstanceAddr").getValue();
		//proxy.InstancePort = zen("InstancePort").getValue();
		//proxy.InstancePrefix = zen("InstancePrefix").getValue();
		//proxy.InstanceDesc = zen("InstanceDesc").getValue();
		
		zenPage.disableAllButtons();
		//var result = zenPage.RequestManagement(proxy);
		//alert("Policy: " + proxy.Policy + "; Credentials: " + proxy.Credentials);
		var result = zenPage.ResetCredentials(proxy);
		if (result.ok != 1) {
			zenPage.showMsg(result.ErrorMessage,1);
			zenPage.updateState();
			return false;
		}
		return true;
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,"error in doSave");
	}
	return false;
}

/// Toggle disable of all buttons.
ClientMethod disableAllButtons() [ Language = javascript ]
{
	var btnBack = zen('btnBack');
	var btnNext = zen('btnNext');
	var btnFinish = zen('btnFinish');
	var btnHelp = zen('btnHelp');

	if (btnBack) {
		btnBack.setProperty('disabled', true);
		btnBack.setProperty('controlClass',	'commandButtonDisabled');
	}
	if (btnNext) {
		btnNext.setProperty('disabled', true);
		btnNext.setProperty('controlClass',	'commandButtonDisabled');
	}
	if (btnFinish) {
		btnFinish.setProperty('disabled', true);
		btnFinish.setProperty('controlClass',	'commandButtonDisabled');
	}
	if (btnHelp) {
		btnHelp.setProperty('disabled', true);
		btnHelp.setProperty('controlClass',	'commandButtonDisabled');
	}
	this.showMsg($$$Text('Please wait...'),0);
}

ClientMethod validate1() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('ServerAddr'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('ServerPort'),pass,"N",true,0,65535)) pass = false;
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in validate1");
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

ClientMethod validate2(policy) As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (policy == "SSL") {
			if (!this.validateRequired(zen('ServerSSLConfig'),pass,"S")) pass = false;
		} else if (policy == "X509") {
			if (!this.validateRequired(zen('alias'),pass,"S")) pass = false;
		}
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in validate2");
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

ClientMethod validate3() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('InstanceAddr'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('InstancePort'),pass,"N",true,0,65535)) pass = false;
	} catch (ex) {
		zenExceptionHandler(ex,arguments,"error in validate3");
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$TextHTML("Reset Credentials")
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
	
	Set Status = ##Class(%Library.RoutineMgr).GetWebServerPort(.Port,.Server)
	//Set ..%GetComponentById("InstanceAddr").value = Server
	//Set ..%GetComponentById("InstancePort").value = Port
	Set ..InstanceAddr = Server
	Set ..InstancePort = Port

	Quit $$$OK
}

ClassMethod DrawPageTitle(pSeed As %String) As %Status
{
	If pSeed = 1 {
		Set tPageTitle = $$$TextHTML("Enter information about the Enterprise Manager instance.")
	} ElseIf pSeed = 2 {
		Set tPageTitle = $$$TextHTML("Enter security information.")
	} Else {
		Set tPageTitle = $$$TextHTML("Enter information about this instance.")
	}
	&html<<div class="Description">#(tPageTitle)#</div>>
	Quit 1
}

ClassMethod RequestPolicy(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""
	Set tProxy.NoAlias = 0
	Set tProxy.NoSSL = 0
	Set tProxy.Credentials = ""
	Try {
		If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
			$$$ThrowStatus($$$ERROR($$$OperationRequires3,$$$PermUseName,$$$AdminManageResourceName,$$$AdminSecureResourceName))
		}
		Set prefix = pProxy.ServerPrefix
		If ($Extract(prefix,*) = "/") Set prefix = $Extract(prefix,1,*-1)
		
		//Set tErr = ##class(EMS.Instance).RegisterInit(pProxy.ServerAddr,pProxy.ServerPort,prefix,.policy,.endpoint)
		//If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
		Set tInstance = ##class(EMS.Instance).Open(,.tErr)
		Set policy = tInstance.ManagerConnection.Policy
		Set endpoint = tInstance.ManagerConnection.Endpoint
		
		Set tProxy.Host = endpoint.Host
		Set tProxy.Port = endpoint.Port
		Set tProxy.Prefix = endpoint.Prefix

		Set tProxy.Policy = policy.PolicyId
		If (tProxy.Policy = "X509") {
			Set tProxy.NoAlias = '..CheckForValidCredentials("X509")
			Set tProxy.Certificate = $System.Encryption.Base64Encode(policy.Certificate)
			Set tProxy.Credentials = tInstance.InstanceData.InstanceConnection.Policy.X509CredentialsAlias
		} ElseIf (tProxy.Policy = "SSL") {
			Set tProxy.NoSSL = '..CheckForValidCredentials("SSL")
			Set tProxy.Credentials = tInstance.InstanceData.InstanceConnection.Policy.SSLConfiguration
		}
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") {
			Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
		}
	}
	Quit tProxy
}

ClassMethod CheckForValidCredentials(pPolicyType As %String) As %Boolean [ ZenMethod ]
{
	Set credsExist = 0
	Try {
		If (pPolicyType = "X509") {
			Set query = "%SYS.X509Credentials:ListEMS"
		} ElseIf (pPolicyType = "SSL") {
			Set query = "Security.SSLConfigs:ListEMS"
		} Else {
			Set query = ""
		}
		Set rs = ##class("%Library.ResultSet").%New(query)
		Set tSC = rs.Execute()
		If $$$ISERR(tSC) Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		If rs.Next() {
			Set credsExist = 1
		}
	} Catch Error {
	}	
	Quit credsExist
}

Method RequestManagement(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""
	
	Try {
		If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
			$$$ThrowStatus($$$ERROR($$$OperationRequires3,$$$PermUseName,$$$AdminManageResourceName,$$$AdminSecureResourceName))
		}
		Set prefix = pProxy.InstancePrefix
		If ($Extract(prefix,*) = "/") Set prefix = $Extract(prefix,1,*-1)
		
		// Set up policy for instance
		Set policy = ##class(EMS.Connection.Policy).GetPolicy(pProxy.Policy)
		If pProxy.Policy = "Username" {
			Set policy.Username = $$$EMSManagerProxyUsername
			Set policy.Password = ##class(%SYS.EMS).GeneratePassword(16)
		} ElseIf pProxy.Policy = "SSL" {
			Set policy.SSLConfiguration = pProxy.SSLConfig
		} ElseIf pProxy.Policy = "X509" {
			Set policy.X509CredentialsAlias = pProxy.alias
		}
		
		// Request management
		Set tErr = ##class(EMS.Instance).RequestManagement(pProxy.InstanceAddr,pProxy.InstancePort,prefix,pProxy.InstanceDesc,policy)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw

		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method ResetCredentials(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ErrorMessage = ""
	Set tProxy.ok = 0
	
	Try {
		if pProxy.Credentials '= "" {
			Set tErr = ##class(EMS.Instance).UpdateCertificate(pProxy.Credentials)
			If tErr {
				Set tProxy.ErrorMessage = ..EvalResult(tErr.AsStatus())
				Return tProxy
			} Else {
				Set tProxy.ok = 1
			}
		} else {
			Set tProxy.ErrorMessage=$$$Text("Policy is 'Username'.  No credentials to reset.") 
		}
	} Catch Error {
		Set tProxy.ok = 0
		If (tProxy.ErrorMessage = "") Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

/// This method can be called by the doSave() function to handle what the ZenMethod of server Save returned. 
/// The method expects a proxy object to be passed.
/// result.ok = 1 indicates save is successful. result.Message is a message (not an error message) that should be displayed.
/// result.ok = 0 indicates save has failed. result.ErrorMessage should be displayed.
/// If result.ok = 1 and result.Message is null then the edit form is closed and the ParentURL is displayed.
ClientMethod afterSave(result As %ZEN.proxyObject) [ Language = javascript ]
{
	if (result.ok == 1) {
		if ((typeof(result.Message) != "undefined") && (result.Message != "")) {
			this.showMsg(result.Message,0);
		} else {
			this.doCancel();
		}
	} else {
		this.showMsg(result.ErrorMessage,1);
	}
}

/// This method can be called after validation (where validateRequired has failed) fails. 
/// Display standard error message and set focus to the FirstFailed field.
ClientMethod afterValidate() [ Language = javascript ]
{
	this.showMsg(this.ValidationErrorMsg,1);
	if (this.FirstFailed) {
		var field = this.FirstFailed;
		zen(field).focus();
	}
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
