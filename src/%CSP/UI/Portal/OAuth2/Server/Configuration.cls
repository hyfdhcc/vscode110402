/// Wizard that helps to define OAuth2 authorization server configuration
Class %CSP.UI.Portal.OAuth2.Server.Configuration Extends (%CSP.UI.Portal.Template, %CSP.UI.Component.SelectBoxUtils) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "OAuth 2.0 Authorization Server Configuration";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.OAuth2.Server.Configuration.zen";

Parameter HELPADDRESS = "System Administration,Security,OAuth2,Server Configuration";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property NAMESPACE As %ZEN.Datatype.string(ZENURL = "$NAMESPACE");

Property isNew As %Boolean;

Property ClientPage As %String [ InitialExpression = {..Link("%25CSP.UI.Portal.OAuth2.Server.ClientList.zen",,1)} ];

Property AvaRoles As %String;

Property SelectedRoles As %String;

Property currIndex As %Integer;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title instructions */
div.Description	{
	font-size: 0.9em; 
	padding: 5px;
}
.EditForm {
	background-image: none;	
}
table.tpTable {
	background-color: white;
	border-collapse: collapse;
}
table.tpTable td {
	border: 1px solid lightgray;
	padding: 2px 10px 2px 10px;	
}
table.tpTable th {
	border: 1px solid lightgray;
	padding: 2px 10px 2px 10px;	
}
.fieldSet {
	background: #f5f3f3;
	border: 1px solid #b1b1b3;
	border-radius: 3px;
}
</style>
}

/// This XML block defines the contents of this pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<form autocomplete="false">
<label id="idRespond" enclosingClass="errorNote" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group id="groupEdit" enclosingClass="EditForm" cellStyle="padding:5px;" labelPosition="left">
<fieldSet id="id_Redirection" label="Issuer endpoint" labelPosition="top">
<label id="id_ServerRedirect" label="The endpoint for this Authorization server." enclosingClass="normal" enclosingStyle="padding-bottom:4px;"/>
<textarea id="redirectURL" disabled="true" readOnly="true" rows="2" cols="80"/>
<text id="addr" label="Host name" hint="Required." onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
<text id="port" label="Port" onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
<text id="prefix" label="Prefix" onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
</fieldSet>
<checkbox id="AudRequired" label="Audience required" captionClass="zenLabel" onchange="zenPage.doModified();"/>
<checkbox id="SupportSession" label="Support user session" captionClass="zenLabel" onchange="zenPage.doModified();"/>

<select id="ReturnRefreshToken" label="Return refresh token" 
showEmpty="false"
valueList=",a,c,f" 
displayList="Only as required by OpenID Connect, Always return a refresh token, Confidential client, If offline_access scope requested" 
onchange="zenPage.doModified();"/>

<group label="Supported grant types (check at least one)" labelPosition="left" >
<checkbox id="GrantType1" caption="Authorization code" captionClass="normal" aux="A" onchange="zenPage.doModified();"/>
<checkbox id="GrantType2" caption="Implicit" captionClass="normal" aux="I" onchange="zenPage.doModified();"/>
<checkbox id="GrantType3" caption="Resource owner password credentials" captionClass="normal" aux="P" onchange="zenPage.doModified();"/>
<checkbox id="GrantType4" caption="Client credentials" captionClass="normal" aux="C" onchange="zenPage.doModified();"/>
<hidden id="GrantTypes"/>
</group>

<fieldSet id="IntervalsGroup" label="Endpoint intervals" >
<text id="Description" label="Description" size="60"/>
<text id="AccessTokenInterval" label="Access token interval" required="true" hint="Required. Enter interval in seconds." onchange="zenPage.doModified();" />
<text id="AuthorizationCodeInterval" label="Authorization code interval" required="true" hint="Required. Enter interval in seconds." onchange="zenPage.doModified();"/>
<text id="RefreshTokenInterval" label="Refresh token interval" hint="Required. Enter interval in seconds." onchange="zenPage.doModified();"/>
<text id="SessionInterval" label="Session termination interval" hint="Required. Enter interval in seconds. Enter 0 for no automatic session termination." onchange="zenPage.doModified();"/>
</fieldSet>
<fieldSet id="ScopesGroup" label="Scopes" >
<html id="htmlSupportedScopes" label="Supported scopes" OnDrawContent="DrawSupportedScopes" hint="Require at least one supported scope."/>
<button id="btnAdd" caption="Add Supported Scope" onclick="zenPage.newSupportedScope();"/>
<group id="groupSupportedScope" labelPosition="left" hidden="true">
<text id="SupportedScope" label="Enter supported scope: " required="true" size="60" onchange="zenPage.doModified();"/>
<text id="SupportedScopeDesc" label="Enter scope description: " required="false" size="60" onchange="zenPage.doModified();"/>
<hgroup>
<button id="btnSave" caption="OK" onclick="zenPage.saveSupportedScope();"/>
<button id="btnRemove" caption="Remove" disabled="true" onclick="zenPage.removeSupportedScope();"/>
<button id="btnCancel" caption="Cancel" onclick="zenPage.cancelRedirectURL();"/>
</hgroup>
</group>
<spacer height="20"/>
<group>
<checkbox id="AllowUnsupportedScope" caption="Allow unsupported scope" captionClass="zenLabel" onchange="zenPage.doModified();"/>
</group>
<spacer height="4"/>
<group>
<text id="DefaultScope" label="Default scope" size="60" maxlength="1024" onchange="zenPage.doModified();"/>
</group>
</fieldSet>
<fieldSet id="groupCustomization" label="Customization Options" >
<text id="AuthenticateClass" label="Authenticate class" size="60" maxlength="256" required="true" hint="Required." onchange="zenPage.doModified();"/>
<text id="ValidateUserClass" label="Validate user class" size="60" maxlength="256" required="true" hint="Required." onchange="zenPage.doModified();"/>
<text id="SessionClass" label="Session maintenance class" size="60" maxlength="256" required="true" hint="Required." onchange="zenPage.doModified();"/>
<text id="GenerateTokenClass" label="Generate token class" size="60" maxlength="256" required="true" hint="Required." onchange="zenPage.doModified();"/>
<select id="CustomizationNamespace" label="Customization namespace" required="true" hint="Required." showEmpty="false" valueList="" onchange="zenPage.doModified();" />
<group label="Customization roles (select at least one)" >
<hidden id="CustomizationRoles" />
<html OnDrawContent="DrawRoleBoxes" seed="" />
</group>
</fieldSet>
<select id="SSLConfiguration" label="SSL configuration" onchange="zenPage.doModified();"/>
<fieldSet id="groupJWT" label="JSON Web Token (JWT) Settings" >
<select id="ServerCredentials" label="Server credentials" onchange="zenPage.doModified();"/>
<text inputtype="password" id="ServerPassword" label="Server password" autocomplete="false" onchange="zenPage.doModified();"/>
<select id="SigningAlgorithm" label="Signing algorithm" valueList="RS256,RS384,RS512" displayList="RS256: RSASSA-PKCS1-V1_5 using SHA-256, RS384: RSASSA-PKCS1-V1_5 using SHA-384, RS512: RSASSA-PKCS1-V1_5 using SHA-512" onchange="zenPage.doModified();"/>
<select id="EncryptionAlgorithm" label="Encryption algorithm" valueList="A128CBC-HS256,A192CBC-HS384,A256CBC-HS512" displayList="A128CBC-HS256: 128-bit AES in CBC mode with HMAC SHA-256, A192CBC-HS384: 192-bit AES in CBC mode with HMAC SHA-384, A256CBC-HS512: 256-bit AES in CBC mode with HMAC SHA-512" onchange="zenPage.doModified();"/>
<select id="KeyAlgorithm" label="Key algorithm" valueList="RSA1_5,RSA-OAEP" displayList="RSA1_5: Encryption with RSAES-PKCS1-V1_5, RSA-OAEP: Encryption with RSAES-OAEP" onchange="zenPage.doModified();"/>
</fieldSet>
</group>
</form>
</pane>
</pane>
}

/// User clicked an existing redirect url from the listbox.<br>
/// Set the value into the textbox for editing or removing.
ClientMethod selectSupportedScope(currIndex) [ Language = javascript ]
{
	this.addSupportedScope = 0;
	zen('groupSupportedScope').setHidden(false);
	zen('btnRemove').setDisabled(false);
	var scopeData = this.GetScopeData(currIndex);
	zen('SupportedScope').setValue(scopeData.scope);
	zen('SupportedScopeDesc').setValue(scopeData.desc);
	zen('SupportedScope').focus();
	this.currIndex = currIndex;
}

/// User clicked the Add URL button to add a new Redirect URL.<br>
/// Clear the textbox to allow user to enter a new one.
ClientMethod newSupportedScope() [ Language = javascript ]
{
	this.addSupportedScope = 1;
	zen('groupSupportedScope').setHidden(false);
	this.currIndex = -1;
	zen('btnRemove').setDisabled(true);
	zen('SupportedScope').setValue('');
	zen('SupportedScopeDesc').setValue('');
	zen('SupportedScope').focus();
}

/// User clicked the OK button to save a Redirect URL.<br>
/// Clear list selection and hide the edit fields afterwards.
ClientMethod saveSupportedScope() [ Language = javascript ]
{
	var scope = zenTrim(zen('SupportedScope').getValue());
	var desc = zenTrim(zen('SupportedScopeDesc').getValue());
	if (!scope) {
		alert($$$Text("Nothing to save - please enter a supported scope"));
		return;
	}
	var html = zen('htmlSupportedScopes');
	var currIndex = this.currIndex;
	if (this.addSupportedScope) {
		var ok = this.CheckScopeData(scope);		
		if (ok != "") {
			alert(ok);
			zen('SupportedScope').focus();
			return;
		} else {
			html.seed = "add^" + "^" + scope + "^" + desc;	
		}
	} else {
		html.seed = "edit^" + currIndex + "^" + scope + "^" + desc;
	}
	this.addSupportedScope = 0;
	this.cancelRedirectURL();
	html.refreshContents();
}

ClientMethod cancelRedirectURL() [ Language = javascript ]
{
	zen('groupSupportedScope').setHidden(true);
	this.currIndex = -1;
}

/// User clicked the Remove button to remove an entry from the listbox.
ClientMethod removeSupportedScope() [ Language = javascript ]
{
	var currIndex = this.currIndex;
	var url = zenTrim(zen('SupportedScope').getValue());
	if (!url) {
		alert($$$Text("Nothing to remove"));
		return;	
	}
	this.addSupportedScope = 0;
	zen('groupSupportedScope').setHidden(true);
	this.doModified();
	var html = zen('htmlSupportedScopes');
	html.seed = "remove^" + currIndex + "^" + "^";
	html.refreshContents();
}

ClientMethod showJWT(flag) [ Language = javascript ]
{
	zen("imgJWTPlus").setHidden(flag);
	zen("imgJWTMinus").setHidden(!flag);
	zen("groupJWT").setHidden(!flag);
}

ClientMethod validatePage() [ Language = javascript ]
{
	var pass = true;
	var fields = '';

	if (!this.validateRequired(zen("AccessTokenInterval"),pass,"N",1)) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'AccessTokenInterval';
	}
	if (!this.validateRequired(zen("AuthorizationCodeInterval"),pass,"N",1)) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'AuthorizationCodeInterval';
	}
	if (!this.validateRequired(zen("RefreshTokenInterval"),pass,"N",1)) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'RefreshTokenInterval';
	}
	if (!this.validateRequired(zen("SessionInterval"),pass,"N",1)) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'SessionInterval';
	}
	if (this.SupportedScopeExists() == 0) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'SupportedScopes';			
	}	
	if (!this.validateRequired(zen("addr"),pass,"S")) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'addr';
	}
	var CustomizationRoles = "";
	var selectedRoles = document.getElementById("selList");
	if (selectedRoles.length < 2) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'CustomizationRoles';
	} else {
		for (var n=1; n<selectedRoles.length; n++) {
			if (selectedRoles.options[n].value != "") {
				if (CustomizationRoles != "") CustomizationRoles += ",";
				CustomizationRoles += selectedRoles.options[n].value;
			}
		}
	}
	zen('CustomizationRoles').setValue(CustomizationRoles);
	if (!this.validateRequired(zen("CustomizationNamespace"),pass,"S")) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'CustomizationNamespace';
	}
	if (!this.validateRequired(zen("AuthenticateClass"),pass,"S")) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'AuthenticateClass';
	}
	if (!this.validateRequired(zen("SessionClass"),pass,"S")) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'SessionClass';
	}
	if (!this.validateRequired(zen("ValidateUserClass"),pass,"S")) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'ValidateUserClass';
	}
	if (!this.validateRequired(zen("GenerateTokenClass"),pass,"S")) {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'GenerateTokenClass';
	}
	var SupportedGrantTypes = "";
	if (zen("GrantType1").getValue()) SupportedGrantTypes = zen("GrantType1").aux;
	if (zen("GrantType2").getValue()) SupportedGrantTypes += zen("GrantType2").aux;
	if (zen("GrantType3").getValue()) SupportedGrantTypes += zen("GrantType3").aux;
	if (zen("GrantType4").getValue()) SupportedGrantTypes += zen("GrantType4").aux;
	if (SupportedGrantTypes == "") {
		pass = false;
		fields = fields + ((fields != "") ? ', ' : '') + 'SupportedGrantTypes';
	}
	if (!pass) {
		this.ValidationErrorMsg = $$$Text('Required fields missing: ') + fields;
		this.afterValidate();
		return pass;
	}
	zen('GrantTypes').setValue(SupportedGrantTypes);
	return pass;
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.onresizeHandler();
	if (this.isNew == 1) {
		this.disableCommandButton("btnClient");
		this.disableCommandButton("btnDelete")
	};
	var options = this.AvaRoles.split(",");
	for (var i=0; i<options.length; i++) {
		if (options[i] != "") {
			document.getElementById('avaList').options[i+1] = new Option(options[i],options[i]);
		}
	}
	options = this.SelectedRoles.split(",");
	for (var i=0; i<options.length; i++) {
		if (options[i] != "") {
			document.getElementById('selList').options[i+1] = new Option(options[i],options[i]);
		}
	}
}

ClientMethod doDelete(action) As %Boolean [ Language = javascript ]
{
	if (confirm($$$Text('Are you sure you want to delete the current Authorization Server Configuration?') + "\n\n" + $$$Text('All Client Configurations will also be deleted.'))) {
		var result = this.DeleteConfiguration();
		if (result != 1) {
			this.showMsg(result, 1);
			return false;	
		} else {
			this.gotoPage(this.ParentURL);	
		}
	}
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod doSave(action) As %Boolean [ Language = javascript ]
{
	try {
		if (this.validatePage()) {
			var valueProxy = new zenProxy();
			valueProxy.addr = zenTrim(zen("addr").getValue());
			valueProxy.port = zenTrim(zen("port").getValue());
			valueProxy.prefix = zenTrim(zen("prefix").getValue());
			valueProxy.AccessTokenInterval = zenTrim(zen("AccessTokenInterval").getValue());
			valueProxy.AuthorizationCodeInterval = zenTrim(zen("AuthorizationCodeInterval").getValue());
			valueProxy.RefreshTokenInterval = zenTrim(zen("RefreshTokenInterval").getValue());
			valueProxy.SessionInterval = zenTrim(zen("SessionInterval").getValue());
			valueProxy.Description = zenTrim(zen("Description").getValue());
			valueProxy.DefaultScope = zenTrim(zen("DefaultScope").getValue());
			valueProxy.AllowUnsupportedScope = zen("AllowUnsupportedScope").getValue() ? 1 : 0;
			valueProxy.AudRequired = zen("AudRequired").getValue() ? 1 : 0;
			valueProxy.SupportSession = zen("SupportSession").getValue() ? 1 : 0;
			valueProxy.ReturnRefreshToken = zen("ReturnRefreshToken").getValue();
			valueProxy.SupportedGrantTypes = zen('GrantTypes').getValue();
			valueProxy.CustomizationRoles = zenTrim(zen("CustomizationRoles").getValue());
			valueProxy.CustomizationNamespace = zenTrim(zen("CustomizationNamespace").getValue());
			valueProxy.AuthenticateClass = zenTrim(zen("AuthenticateClass").getValue());
			valueProxy.SessionClass = zenTrim(zen("SessionClass").getValue());
			valueProxy.ValidateUserClass = zenTrim(zen("ValidateUserClass").getValue());
			valueProxy.GenerateTokenClass = zenTrim(zen("GenerateTokenClass").getValue());
			valueProxy.ServerCredentials = zenTrim(zen("ServerCredentials").getValue());
			valueProxy.ServerPassword = zenTrim(zen("ServerPassword").getValue());
			valueProxy.SigningAlgorithm = zenTrim(zen("SigningAlgorithm").getValue());
			valueProxy.EncryptionAlgorithm = zenTrim(zen("EncryptionAlgorithm").getValue());
			valueProxy.KeyAlgorithm = zenTrim(zen("KeyAlgorithm").getValue());
			valueProxy.SSLConfiguration = zenTrim(zen("SSLConfiguration").getValue());
			var result = this.SaveData(valueProxy);
			if (result.ok == 1) {
				this.setModified(false);
				this.enableCommandButton('btnClient');
				this.enableCommandButton('btnDelete');
			}
			this.afterSave(result);
		}	
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

/// This client event, if present, is fired when the page is resized.
ClientMethod onresizeHandler() [ Language = javascript ]
{
}

/// This callback is called after the server-side page 
/// object and all of its children are created.<br/>
/// Subclasses can override this to add, remove, or modify 
/// items within the page object model, or to provide values
/// for controls.
Method %OnAfterCreatePage() As %Status
{
	Set $ZT="Error"

	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set sys = ##class(OAuth2.Server.Configuration).Open(.sc)
	Set ..isNew = '$IsObject(sys)
	Set titleAdd = $$$TextHTML("Use the form below to create the OAuth 2.0 authorization server configuration:")
	Set titleEdit = $$$TextHTML("Use the form below to edit the OAuth 2.0 authorization server configuration:")
	Set ..lblTitle = $S(..isNew=1:titleAdd,1:titleEdit)

	Set tSC = ..LoadData(sys)
	If '$$$ISOK(tSC) {
		Set ..%GetComponentById("idRespond").value = tSC
		Set ..%GetComponentById("idRespond").hidden = 0
	}

	Quit $$$OK
Error	///
	Set $ZT="" Do BACK^%ETN
	Quit $$$OK
}

/// Get redirect URL upon user changing any of server address/port/prefix.
ClientMethod getRedirectURL() [ Language = javascript ]
{
	var addr = zenTrim(zen('addr').getValue());
	var port = zenTrim(zen('port').getValue());
	var prefix = zenTrim(zen('prefix').getValue());
	var url = this.GetRedirectURLforUI(addr, port, prefix);
	zen('redirectURL').setValue(url);
}

ClassMethod GetRedirectURLforUI(pAddress, pPort, pPrefix) As %String [ ZenMethod ]
{
	If pAddress="", pPort="", pPrefix="" Quit ""
	Set tClient = ##class(OAuth2.Server.Configuration).%New()
	Set tClient.IssuerEndpoint.Host = pAddress
	Set tClient.IssuerEndpoint.Port = pPort
	Set tClient.IssuerEndpoint.Prefix = pPrefix
	Set tClient.IssuerEndpoint.UseSSL = 1   ; always SSL
	Set tURL = tClient.GetIssuerURL()
	Quit tURL
}

/// Used when Editing existing OAuth2 authantication server configuration. Load previously defined values into fields or set defaults.
Method LoadData(sys) As %Status
{
	Set $ZT="Error"
	Set tNamespaces = ""
	Set tSC = ##class(%CSP.Portal.Utils).%GetNamespaceList(.NspList)
	If $$$ISERR(tSC) {
		Quit tSC
	}
	Set tNamespace = $O(NspList(""))
	While tNamespace '= "" {
		Set tEnabled = $lg(NspList(tNamespace),1)
		If tEnabled = 1 {
			Set tNamespaces = tNamespaces _ $S(tNamespaces'="": ",", 1:"") _ tNamespace
		}
		Set tNamespace = $O(NspList(tNamespace))
	}
	Set ..%GetComponentById("CustomizationNamespace").valueList = tNamespaces

	Set tX509List = ""
	Set tRS = ##class(%ResultSet).%New("%SYS.X509Credentials:ListPrivateKey")
	Do tRS.Execute()
	While tRS.Next() {
		Set tX509List = tX509List _ $S(tX509List'="":",", 1:"")_tRS.GetData(1)	
	}
	Set ..%GetComponentById("ServerCredentials").valueList = tX509List	
	Set selectedRoles = ""
	Kill %session.Data($Username,"SupportedScopes")

	Set tRS = ##class(%ResultSet).%New("Security.SSLConfigs:List")
	Do tRS.Execute("*")
	Set SSLConfigurations = ""
	While tRS.Next() {
		If tRS.GetData(1) '= "" {
			Set SSLConfigurations = SSLConfigurations _ $S(SSLConfigurations'="":",",1:"") _ tRS.GetData(1)	
		}
	}
	Set ..%GetComponentById("SSLConfiguration").valueList = SSLConfigurations

	If ..isNew = 0 {
		Set ..%GetComponentById("addr").value = sys.IssuerEndpoint.Host
		Set ..%GetComponentById("port").value = sys.IssuerEndpoint.Port
		Set ..%GetComponentById("prefix").value = sys.IssuerEndpoint.Prefix
		Set ..%GetComponentById("redirectURL").value = ..GetRedirectURLforUI(sys.IssuerEndpoint.Host, sys.IssuerEndpoint.Port, sys.IssuerEndpoint.Prefix)
		Set ..%GetComponentById("AccessTokenInterval").value = sys.AccessTokenInterval
		Set ..%GetComponentById("AuthorizationCodeInterval").value = sys.AuthorizationCodeInterval
		Set ..%GetComponentById("RefreshTokenInterval").value = sys.RefreshTokenInterval
		Set ..%GetComponentById("SessionInterval").value = sys.SessionInterval
		For i = 1:1:sys.SupportedScopes.Count() {
			Set desc = sys.SupportedScopes.GetNext(.scope)
			Set %session.Data($Username,"SupportedScopes", i, "scope") = scope
			Set %session.Data($Username,"SupportedScopes", i, "desc") = desc	
		}
		Set %session.Data($Username,"SupportedScopes","count") = sys.SupportedScopes.Count()
		Set ..%GetComponentById("Description").value = sys.Description
		Set ..%GetComponentById("DefaultScope").value = sys.DefaultScope
		Set ..%GetComponentById("AllowUnsupportedScope").value = sys.AllowUnsupportedScope
		Set ..%GetComponentById("AudRequired").value = sys.AudRequired
		Set ..%GetComponentById("SupportSession").value = sys.SupportSession
		Set ..%GetComponentById("ReturnRefreshToken").value = sys.ReturnRefreshToken
		
		For i = 1:1:4 {
			Set value = $E(sys.SupportedGrantTypes,i)
			If value '= "" {
				Set:value="A" ..%GetComponentById("GrantType1").value = 1
				Set:value="I" ..%GetComponentById("GrantType2").value = 1
				Set:value="P" ..%GetComponentById("GrantType3").value = 1
				Set:value="C" ..%GetComponentById("GrantType4").value = 1
			}
		}
		//Set ..%GetComponentById("CustomizationRoles").value = sys.CustomizationRoles
		Set ..SelectedRoles = sys.CustomizationRoles
		If sys.CustomizationRoles '= "" {
			For n=1:1:$length(sys.CustomizationRoles,",") Set CustomizationRoles($P(sys.CustomizationRoles,",",n))=""
		}
		Set ..%GetComponentById("CustomizationNamespace").value = sys.CustomizationNamespace
		Set ..%GetComponentById("AuthenticateClass").value = sys.AuthenticateClass
		Set ..%GetComponentById("SessionClass").value = sys.SessionClass
		Set ..%GetComponentById("ValidateUserClass").value = sys.ValidateUserClass
		Set ..%GetComponentById("GenerateTokenClass").value = sys.GenerateTokenClass
		Set ..%GetComponentById("ServerCredentials").value = sys.ServerCredentials
		Set ..%GetComponentById("ServerPassword").value = sys.ServerPassword
		Set ..%GetComponentById("SigningAlgorithm").value = sys.SigningAlgorithm
		Set ..%GetComponentById("EncryptionAlgorithm").value = sys.EncryptionAlgorithm
		Set ..%GetComponentById("KeyAlgorithm").value = sys.KeyAlgorithm			
		Set ..%GetComponentById("SSLConfiguration").value = sys.SSLConfiguration			

	} Else {
		Set ..%GetComponentById("AccessTokenInterval").value = "3600"
		Set ..%GetComponentById("AuthorizationCodeInterval").value = "60"
		Set ..%GetComponentById("RefreshTokenInterval").value = "86400"
		Set ..%GetComponentById("SessionInterval").value = "86400"
		Set ..%GetComponentById("ReturnRefreshToken").value = ""
		Set ..%GetComponentById("AuthenticateClass").value = "%OAuth2.Server.Authenticate"
		Set ..%GetComponentById("SessionClass").value = "OAuth2.Server.Session"
		Set ..%GetComponentById("ValidateUserClass").value = "%OAuth2.Server.Validate"
		Set ..%GetComponentById("GenerateTokenClass").value = "%OAuth2.Server.Generate"
		Set ..%GetComponentById("CustomizationNamespace").value = "%SYS"
	}	

	Set tRS = ##class(%ResultSet).%New("Security.Roles:List")
	Set tSC = tRS.Execute("*")
	If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)

	Set avaRoles = ""
	While tRS.Next() {
		If '$D(CustomizationRoles(tRS.GetData(1))) Set avaRoles = avaRoles _ $S(avaRoles'="":",",1:"") _ tRS.GetData(1)
	}
	Set ..AvaRoles = avaRoles

	Quit $$$OK
Error	///
	Set $ZT="" Do BACK^%ETN
	Quit $$$OK
}

Method DrawRoleBoxes(pSeed As %String) As %Status
{
	Do ..DrawAvailableList("", 1)

	//inbox, isPage, SelectedItems
	Do ..DrawSelectList("", 1)
	&html<<div class="zenHint">#($$$TextHTML("Hold the [Shift] or [Ctrl] key while clicking to select multiple roles."))#</div>>
	Quit $$$OK
}

ClassMethod DrawPageTitle(pSeed As %String) As %Status
{
	If pSeed '= "" {	
		Set tPageTitle = $$$Text("This wizard is used to view or edit your OAuth2 authorization server configuration.")	
	} 
	&html<<div class="Description">#(tPageTitle)#</div>
	<hr size="1"/>>
	Quit 1
}

ClassMethod SaveData(pValueProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	
	Set $ZT="Error"
	
	#dim sys as OAuth2.Server.Configuration

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 0
	Set tProxy.Message = ""
	Set tProxy.ErrorMessage = ""
	Set tSC = $$$OK
	Set sys = ##class(OAuth2.Server.Configuration).Open(.sc)

	If '$IsObject(sys) {
		Set sys = ##class(OAuth2.Server.Configuration).%New()
	}

	Set sys.IssuerEndpoint.Host = pValueProxy.addr
	Set sys.IssuerEndpoint.Port = pValueProxy.port
	Set sys.IssuerEndpoint.Prefix = pValueProxy.prefix

	Set sys.AccessTokenInterval = pValueProxy.AccessTokenInterval
	Set sys.AuthorizationCodeInterval = pValueProxy.AuthorizationCodeInterval
	Set sys.RefreshTokenInterval = pValueProxy.RefreshTokenInterval
	Set sys.SessionInterval = pValueProxy.SessionInterval
	Do sys.SupportedScopes.Clear()
	Set i = $O(%session.Data($Username,"SupportedScopes",0))
	While i'="", i'="count" {
		Set scope = $G(%session.Data($Username,"SupportedScopes", i, "scope"))
		Set desc = $G(%session.Data($Username,"SupportedScopes", i, "desc"))
		If scope '= "" {
			Do sys.SupportedScopes.SetAt(desc, scope)
		}
		Set i = $O(%session.Data($Username,"SupportedScopes",i))
	}
	Set sys.Description = pValueProxy.Description
	Set sys.DefaultScope = pValueProxy.DefaultScope
	Set sys.AllowUnsupportedScope = pValueProxy.AllowUnsupportedScope
	Set sys.AudRequired = pValueProxy.AudRequired
	Set sys.SupportSession = pValueProxy.SupportSession
	Set sys.ReturnRefreshToken = pValueProxy.ReturnRefreshToken
	Set sys.SupportedGrantTypes = pValueProxy.SupportedGrantTypes
	Set sys.CustomizationRoles = pValueProxy.CustomizationRoles
	Set sys.CustomizationNamespace = pValueProxy.CustomizationNamespace
	Set sys.AuthenticateClass = pValueProxy.AuthenticateClass
	Set sys.SessionClass = pValueProxy.SessionClass
	Set sys.ValidateUserClass = pValueProxy.ValidateUserClass
	Set sys.GenerateTokenClass = pValueProxy.GenerateTokenClass
	Set sys.ServerCredentials = pValueProxy.ServerCredentials
	Set sys.ServerPassword = pValueProxy.ServerPassword
	Set sys.SigningAlgorithm = pValueProxy.SigningAlgorithm
	Set sys.EncryptionAlgorithm = pValueProxy.EncryptionAlgorithm
	Set sys.KeyAlgorithm = pValueProxy.KeyAlgorithm
	Set sys.SSLConfiguration = pValueProxy.SSLConfiguration
	Set tSC = sys.Save()
	If $$$ISERR(tSC) {
		Set tProxy.ErrorMessage = $ZCVT($System.Status.GetErrorText(tSC),"O","HTML")
	} Else {
		Set tProxy.ok = 1
		Set tProxy.Message = $$$Text("Authorization Configuration saved successfully")
	}
	Kill sys
	Quit tProxy
Error	///
	Set $ZT="" Do BACK^%ETN
	Set tProxy.ErrorMessage = $ZCVT($ZE,"O","HTML")
	Kill sys
	Quit tProxy
}

ClassMethod DeleteConfiguration() As %String [ ZenMethod ]
{
	Set sys = ##class(OAuth2.Server.Configuration).Open(.sc)
	Set tSC = sys.Delete()
	If $$$ISERR(tSC) Quit $System.Status.GetErrorText(tSC)
	Quit $$$OK
}

ClientMethod doClient() [ Language = javascript ]
{
	try {
		this.gotoPage(this.ClientPage);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("OAuth 2.0 Authorization Server Configuration")
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set tPageName = $$$Text("System")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Security Management","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen")
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnSave",$$$Text("Save"),$$$Text("Save authorization server configuration."),"zenPage.doSave();")
	Set pCommands(2) = $LB("btnSave",$$$Text("Cancel"),$$$Text("Return to main menu."),"zenPage.doCancel();")
	Set pCommands(3) = $LB("btnDelete",$$$Text("Delete"),$$$Text("Delete the current authorization server configuration."),"zenPage.doDelete();")
	Set pCommands(4) = $LB("btnClient",$$$Text("Client Configurations"),$$$Text("View and edit authorization server client configurations when authorization server configuration is defined."),"zenPage.doClient();")

	Quit $$$OK
}

/// Manually draw html table for Supported Scopes.
/// %session.Data($Username,"SupportedScopes") represents the current supported scopes. Initially it is sys.SupportedScopes and
/// then it may be edited/added/removed.
/// pSeed represents [Action]/indexnumber/scope/scopeDescription
/// because pSeed can only be %String, we'll have to split it after arriving here. Delimiter is ^
/// Examples: <br>
///    add^^newscope name^newscope description
///    edit^1^newscope name^newscope description
///    remove^1^^
Method DrawSupportedScopes(pSeed As %String) As %Status
{
	&html<
		<table class="tpTable" cellspacing="2px">
		<tr><th>#($$$Text("Scope"))#</th><th>#($$$Text("Description"))#</th><th>&nbsp;</th></tr>
	>
	Set count = $get(%session.Data($Username,"SupportedScopes","count"),0)
	Set tIndex = ""
	If pSeed '= "" {
		Set tAction = $P(pSeed, "^", 1)
		Set tIndex = $P(pSeed, "^", 2)
		Set tScope = $P(pSeed, "^", 3)
		Set tScopeDesc = $P(pSeed, "^", 4)
		If tAction = "add" {
			Set count = count + 1
			Set %session.Data($Username,"SupportedScopes","count") = count
			Set %session.Data($Username,"SupportedScopes",count,"scope") = tScope
			Set %session.Data($Username,"SupportedScopes",count,"desc") = tScopeDesc
		} ElseIf tAction = "edit" {
			Set %session.Data($Username,"SupportedScopes",tIndex,"scope") = tScope
			Set %session.Data($Username,"SupportedScopes",tIndex,"desc") = tScopeDesc
		} ElseIf tAction = "remove" {
			Kill %session.Data($Username,"SupportedScopes",tIndex)
		}
	}
	Set i = $O(%session.Data($Username,"SupportedScopes",0))
	While i'="", i'="count" {
		Set scope = $G(%session.Data($Username,"SupportedScopes", i, "scope"))
		Set desc = $G(%session.Data($Username,"SupportedScopes", i, "desc"))
		If scope '= "" {
			&html<
			<tr><td>#(..EscapeHTML(scope))#</td><td>#(..EscapeHTML(desc))#</td><td><input type="button" value='#($$$Text("Edit"))#' onclick="zenPage.selectSupportedScope(#(i)#);"></td></tr>
			>
		}
		Set i = $O(%session.Data($Username,"SupportedScopes",i))
	}
	&html<</table>>
	Quit $$$OK
}

ClassMethod GetScopeData(pIndex) As %ZEN.proxyObject [ ZenMethod ]
{
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.scope = $G(%session.Data($Username,"SupportedScopes",pIndex,"scope"))
	Set tProxy.desc = $G(%session.Data($Username,"SupportedScopes",pIndex,"desc"))
	Quit tProxy
}

/// Check to see if the scope name user entering is a duplicate
ClassMethod CheckScopeData(pScope) As %String [ ZenMethod ]
{
	Set tResult = ""
	Set i = $O(%session.Data($Username,"SupportedScopes",0))
	While i'="", i'="count" {
		Set scope = $G(%session.Data($Username,"SupportedScopes", i, "scope"))
		If scope = pScope {
			Set tResult = $$$FormatText($$$Text("Scope '%1' is already defined."),$zconvert(pScope,"O","HTML"))
			Quit
		}
		Set i = $O(%session.Data($Username,"SupportedScopes",i))
	}
	Quit tResult
}

/// Check to see if at least one scope is defined. Return 1 if there is.
ClassMethod SupportedScopeExists() [ ZenMethod ]
{
	Set i = $O(%session.Data($Username,"SupportedScopes",0))
	If i '="", i '= "count" Quit 1
	Quit 0
}

}
