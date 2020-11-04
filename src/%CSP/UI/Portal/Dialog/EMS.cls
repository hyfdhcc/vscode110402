Include %ems

/// <p>This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. 
/// There is no guarantee made about either the behavior or future operation of this class.</p>
/// EMS Wizard for Management Portal
Class %CSP.UI.Portal.Dialog.EMS Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

Parameter CSPURL = "/csp/sys/%CSP.UI.Portal.Dialog.EMS.zen";

/// Displayed name of this page.
Parameter PAGENAME = "EMSWizard";

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

Property AlreadyManaged As %String(ZENURL = "MANAGED");

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
 <html OnDrawContent="DrawPageTitle" seed="1" enclosingStyle="padding-bottom:6px;border-bottom:1px solid teal;width:835px;"/>
 <group labelPosition="left" cellStyle="padding:4px;">
<text id="ServerAddr" label="Network Location" size="20" maxlength="256" hint="Required. Hostname or IP address." onchange="zenPage.updateState();" onkeyup="zenPage.updateState();"/>
<text id="ServerPort" label="Port" size="5" maxlength="5" value="57780" hint="Required. Web server port." onchange="zenPage.updateState();" onkeyup="zenPage.updateState();"/>
<text id="ServerPrefix" label="Prefix" size="20" maxlength="256"/>
</group>
</tab>

<!-- Second Page -->
<tab id="tab2" enclosingStyle="padding-top:10px;" cellStyle="padding-bottom:10px;">
<group labelPosition="left" cellStyle="padding:4px;">
<label id="ServerLocRecieved" label="Enterprise Manager Location" controlClass="normal"/>
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
<spacer height="10px"/>
<checkbox id="acceptSSLCertificate" label="Accept Server's Certificate" hint="Required." onchange="zenPage.updateState();"/>
<certificateViewer id="serverSSLCert"/>
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
displayColumns="1"
valueColumn="1"
choiceColumn="1"
dropdownWidth="300px"
dropdownHeight="100px"
hint="Required."
onchange="zenPage.updateState();"
/>
<spacer width="1.0em"/>
<link href="sec/%25CSP.UI.Portal.X509Credentials.zen" caption="View X.509 credentials" target="_blank" containerStyle="vertical-align:top;" enclosingClass="smpLink"/>
</hgroup>
<group>
<label label="Only X.509 credentials with a private key and password are listed for use with Enterprise Manager."/>
</group>
<spacer height="10px"/>
<checkbox id="acceptCertificate" label="Accept Server's Certificate" hint="Required." onchange="zenPage.updateState();"/>
<certificateViewer id="serverCert"/>
</group>
</group>
</tab>

<!-- Third Page -->
<tab id="tab3" enclosingStyle="padding-top:10px;" cellStyle="padding-bottom:10px;">
<group labelPosition="left" cellStyle="padding:4px;">
<label id="ServerLocRecieved2" label="Enterprise Manager Location" controlClass="normal"/>
</group>
<html OnDrawContent="DrawPageTitle" seed="3" enclosingStyle="padding-bottom:6px;border-bottom:1px solid teal;width:835px;"/>
<group labelPosition="left" cellStyle="padding:4px;">
<text id="InstanceDesc" label="Description" size="50" maxlength="128"/>
<text id="InstanceAddr" label="Network Location" size="20" maxlength="256" hint="Required. Hostname or IP address." onchange="zenPage.updateState();" onkeyup="zenPage.updateState();"/>
<text id="InstancePort" label="Port" size="5" maxlength="5" hint="Required. Web server port." onchange="zenPage.updateState();" onkeyup="zenPage.updateState();"/>
<text id="InstancePrefix" label="Prefix" size="20" maxlength="256" />
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
	zen("ServerAddr").focus();
	zenPage.updateState();
}

// ClientMethod onloadHandler() [ Language = javascript ]

// {

// 	this.invokeSuper('onloadHandler',arguments);

// 	alert("Managed: " + this.AlreadyManaged);

// }

/// Return true if this template can go to the next page (i.e., enable
/// the Next button).<br>
ClientMethod canGoNext() [ Language = javascript ]
{
	var tabGroup = zen('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var flag = false;
	switch(tabNo) {
	case 1:
		var ServerAddr = zen("ServerAddr").getValue();
		var ServerPort = zen("ServerPort").getValue();
		if ((ServerAddr != "") && (ServerPort != "")) {
			flag = true;	
		}
		break;
	case 2:
		if (zenPage.SecurityPolicy == "Username") {
			flag = true;	
		} else if (zenPage.SecurityPolicy == "SSL") {
			var SSL = zen("ServerSSLConfig").getValue();
			var accept = zen("acceptSSLCertificate").getValue();
			if ((SSL != "") && accept) {
				flag = true;
			}
		} else {
			var alias = zen("alias").getValue();
			var accept = zen("acceptCertificate").getValue();
			if ((alias != "") && accept) {
				flag = true;
			}
		}
		break;
	case 3:
		break;
	}
	return flag;
}

/// Return true if this template can go to the previous page (i.e., enable
/// the Back button).<br>
/// This is implemented by subclasses.
ClientMethod canGoBack() [ Language = javascript ]
{
	var tabGroup = zen('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var flag = true;
	switch(tabNo) {
	case 1:
		flag = false;
		break;
	case 2:
		break;
	case 3:
		break;	
	}	

	return flag
}

/// Return true if this template can Finish (i.e., enable
/// the Finish button).<br>
ClientMethod canFinish() [ Language = javascript ]
{
	var tabGroup = zen('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var flag = false;
	switch(tabNo) {
	case 1:
		break;
	case 2:
		break;
	case 3:
		var InstanceAddr = zen("InstanceAddr").getValue();
		var InstancePort = zen("InstancePort").getValue();
		if ((InstanceAddr != "") && (InstancePort != "")) {
			flag = true;	
		}
		break;
	}	
	
	return flag;
}

ClientMethod hasMultiplePages() [ Language = javascript ]
{
	return true;
}

/// Go to the next page of the template (if there is one).<br/>
ClientMethod nextPage() [ Language = javascript ]
{
	this.resetMsg();
	
	var tabGroup = zen('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	var ok = true;
	var proxy = new zenProxy();
	var msg = "";
	var focusField = "";
	var oldSynchronousMode = zenSynchronousMode;
	
	switch(tabNo) {
	case 1:
		zenSynchronousMode = true;
		if (!this.ConnectionEstablished) {
			ok = zenPage.validate1();
			if (!ok) {
				zenPage.afterValidate();
				break;
			}
			
			proxy.ServerAddr = zen("ServerAddr").getValue();
			proxy.ServerPort = zen("ServerPort").getValue();
			proxy.ServerPrefix = zen("ServerPrefix").getValue();
			proxy.AlreadyManaged = this.AlreadyManaged;
			
			zenPage.disableAllButtons();
			var result = zenPage.RequestPolicy(proxy);
			if (result.ok != 1) {
				zenPage.showMsg(result.ErrorMessage,1);
				break;
			}
			var loc = result.Host+":"+result.Port;
			if (result.Prefix != '') {
				loc += '/'+result.Prefix;
			}
			zen('ServerLocRecieved').setValue(loc);
			zen('ServerLocRecieved2').setValue(loc);

			zenPage.resetMsg();
			this.ConnectionEstablished = true;
			zen("ServerAddr").setProperty('disabled',true);
			zen("ServerPort").setProperty('disabled',true);
			zen("ServerPrefix").setProperty('disabled',true);
			
			zenPage.SecurityPolicy = result.Policy;
			if (result.Policy == "Username") {
				zen("passwordGroup").setHidden(false);
				msg = $$$Text("This Enterprise Manager instance uses the unsecured security option.");
			} else {
				zen("certificateGroup").setHidden(false);
				if (result.Policy == "SSL") {
					var cert = zen("serverSSLCert");
					cert.setProperty('Certificate',result.Certificate);
					cert.ReallyRefreshContents();
					msg = $$$Text("This Enterprise Manager instance uses SSL/TLS security.");
					if (result.NoSSL == 1) {
						zen("NoSSL").setHidden(false);
					} else {
						zen("HasSSL").setHidden(false);
						focusField = "ServerSSLConfig";
					}
				} else {
					var cert = zen("serverCert");
					cert.setProperty('Certificate',result.Certificate);
					cert.ReallyRefreshContents();
					msg = $$$Text("This Enterprise Manager instance uses WS-Security.");
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
		
		tabGroup.showNextTab();
		if (focusField !== "") {
			zen(focusField).focus();
		}
		zenSynchronousMode = oldSynchronousMode;
		break;
	case 2:
		ok = zenPage.validate2(this.SecurityPolicy);
		if (!ok) {
			zenPage.afterValidate();
			break;
		}
		
		if (this.SecurityPolicy == "X509") {
			if (!zen("acceptCertificate").getValue()) {
				msg = $$$Text("You must accept the server's certificate.");
				this.showMsg(msg,1);
				zen('acceptCertificate').focus();
				break;
			}
		}
		zenSynchronousMode = true;
		tabGroup.showNextTab();
		zen("InstanceDesc").focus();
		zenSynchronousMode = oldSynchronousMode;
		break;
	case 3:
		break;
	}
	zenPage.updateState();
}

/// Go to the previous page of the template (if there is one).<br/>
/// This is implemented by subclasses.
ClientMethod previousPage() [ Language = javascript ]
{
	//this.resetMsg();	
	var tabGroup = zen('tabGroup');
	var tabNo = tabGroup.getCurrTabNo();
	switch(tabNo) {
	case 1:
		break;
	case 2:
		tabGroup.showPreviousTab();
		break;
	case 3:
		tabGroup.showPreviousTab();
		break;
	}
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
		var ok = zenPage.validate3();
		if (!ok) {
			zenPage.afterValidate();
			return false;
		}
		
		var proxy = new zenProxy();
		proxy.Policy = this.SecurityPolicy;
		proxy.SSLConfig = zen("ServerSSLConfig").getValue();
		proxy.alias = zen("alias").getValue();
		proxy.InstanceAddr = zen("InstanceAddr").getValue();
		proxy.InstancePort = zen("InstancePort").getValue();
		proxy.InstancePrefix = zen("InstancePrefix").getValue();
		proxy.InstanceDesc = zen("InstanceDesc").getValue();
		
		zenPage.disableAllButtons();
		var result = zenPage.RequestManagement(proxy);
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
	Quit $$$TextHTML("Apply for Management")
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
	Set ..%GetComponentById("InstanceAddr").value = Server
	Set ..%GetComponentById("InstancePort").value = Port
	
	Set tInstance = ##class(EMS.Instance).Open(,.tErr)
	//Set policy = tInstance.ManagerConnection.Policy
	If (tInstance) {
		Set endpoint = tInstance.ManagerConnection.Endpoint
		Set ..%GetComponentById("ServerAddr").value = endpoint.Host
		Set ..%GetComponentById("ServerPort").value = endpoint.Port
		Set ..%GetComponentById("ServerPrefix").value = endpoint.Prefix	
	}
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
	
	Try {
		If '($System.Security.Check($$$AdminManageResourceName,$$$PermUseName) && $System.Security.Check($$$AdminSecureResourceName,$$$PermUseName)) {
			$$$ThrowStatus($$$ERROR($$$OperationRequires3,$$$PermUseName,$$$AdminManageResourceName,$$$AdminSecureResourceName))
		}
		Set prefix = pProxy.ServerPrefix
		If ($Extract(prefix,*) = "/") Set prefix = $Extract(prefix,1,*-1)
		
		If (pProxy.AlreadyManaged = "YES") {
			Set reapply = 1
		} Else {
			Set reapply = 0
		}
		Set tErr = ##class(EMS.Instance).RegisterInit(pProxy.ServerAddr,pProxy.ServerPort,prefix,.policy,.endpoint,reapply)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw
		
		Set tProxy.Host = endpoint.Host
		Set tProxy.Port = endpoint.Port
		Set tProxy.Prefix = endpoint.Prefix

		Set tProxy.Policy = policy.PolicyId
		If (tProxy.Policy = "X509") {
			Set tProxy.NoAlias = '..CheckForValidCredentials("X509")
			Set tProxy.Certificate = $System.Encryption.Base64Encode(policy.Certificate)
		} ElseIf (tProxy.Policy = "SSL") {
			Set tProxy.NoSSL = '..CheckForValidCredentials("SSL")
			Set tProxy.Certificate = $System.Encryption.Base64Encode(policy.Certificate)
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
		If (..AlreadyManaged = "YES") {
			Set reapply = 1
		} Else {
			Set reapply = 0
		}
		Set tErr = ##class(EMS.Instance).RequestManagement(pProxy.InstanceAddr,pProxy.InstancePort,prefix,pProxy.InstanceDesc,policy,reapply)
		If tErr Set tProxy.ErrorMessage = tErr.AsHTML() Throw

		Set tProxy.ok = 1
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
