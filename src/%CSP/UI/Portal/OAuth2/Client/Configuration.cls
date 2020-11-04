/// Zen page for System Management Portal - Edit OAuth 2.0 client configuration
Class %CSP.UI.Portal.OAuth2.Client.Configuration Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "OAuth 2.0 Client Configuration";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.OAuth2.Client.Configuration.zen";

Parameter HELPADDRESS = "System Administration,Security,OAuth 2.0,Client Configuration,Client Configuration";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property isNew As %ZEN.Datatype.boolean(ZENURL = "isNew") [ InitialExpression = "0" ];

/// ID for edit. Null if adding new configuration.
Property PID As %String(ZENURL = "PID");

XData Style
{
<style type="text/css">
/* override the image because this form is too tall */
.EditForm {
	background-image: url('');
}
.fieldSet {
	background: #f5f3f3;
	border: 1px solid #b1b1b3;
	border-radius: 3px;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<form autocomplete="false">
<label id="idRespond" enclosingClass="errorNote" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group id="groupEdit" enclosingClass="EditForm" cellStyle="padding:5px;" labelPosition="left">
<spacer height="2"/>
<text id="Name" label="Application name" size="60" maxlength="50" hint="Required." onchange="zenPage.doModified();"/>
<text id="Description" label="Description" size="60" maxlength="1024" onchange="zenPage.doModified();"/>
<checkbox id="Enabled" label="Enabled" onchange="zenPage.doModified();"/>
<radioSet id="ClientType" label="Client Type" displayList="Confidential,Public,Resource server" valueList="confidential,public,resource" onchange="zenPage.doModified();zenPage.changeClientType();"/>
<select id="SSLConfiguration" label="SSL configuration" hint="Required." onchange="zenPage.doModified();"/>
<spacer height="2"/>
<fieldSet id="id_Redirection" label="Client redirect URL" >
<group>
<label id="id_ServerRedirect" value="The client URL to be specified to the authorization server to receive responses." enclosingClass="normal" enclosingStyle="padding-bottom:4px;"/>
<textarea id="redirectURL" readOnly="true" rows="2" cols="80"/>
<checkbox id="UseSSL" label="Use TLS/SSL" onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
<text id="addr" label="Host name" hint="Required." onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
<text id="port" label="Port" onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
<text id="prefix" label="Prefix" onchange="zenPage.getRedirectURL();zenPage.doModified();"/>
</group>
</fieldSet>
<spacer height="2"/>
<radioSet id="AuthenticationType" label="Authentication type" displayList="none,basic,form encoded body" valueList="none,basic,body" value="basic" onchange="zenPage.doModified();"/>

<spacer height="2"/>
<fieldSet id="id_Client" label="This client's credentials" >
<text id="ClientId" label="Client ID" size="60" hint="Required." onchange="zenPage.doModified();"/>
<text id="ClientSecret" label="Client secret" size="60" hint="Required if client type is confidential." onchange="zenPage.doModified();"/>
</fieldSet>
<spacer height="2"/>
<fieldSet id="groupJWT" label="JSON Web Token (JWT) Settings" containerStyle="font-size:12px;padding-left:4px;padding-right:4px;">
<select id="ClientCredentials" label="Client credentials" onchange="zenPage.doModified();"/>
<!-- do not delete the xxClientPassword field below! it is there to over come a bug in Chrome which may show password when it should not --> 
<password id="xxClientPassword" hidden="true"/>
<text inputtype="password" id="ClientPassword" label="Client password" autocomplete="false" onchange="zenPage.doModified();"/>
<select id="SigningAlgorithm" label="Signing algorithm" valueList="RS256,RS384,RS512" displayList="RS256: RSASSA-PKCS1-V1_5 using SHA-256, RS384: RSASSA-PKCS1-V1_5 using SHA-384, RS512: RSASSA-PKCS1-V1_5 using SHA-512" onchange="zenPage.doModified();"/>
<select id="EncryptionAlgorithm" label="Encryption algorithm" valueList="A128CBC-HS256,A192CBC-HS384,A256CBC-HS512" displayList="A128CBC-HS256: 128-bit AES in CBC mode with HMAC SHA-256, A192CBC-HS384: 192-bit AES in CBC mode with HMAC SHA-384, A256CBC-HS512: 256-bit AES in CBC mode with HMAC SHA-512" onchange="zenPage.doModified();"/>
<select id="KeyAlgorithm" label="Key algorithm" valueList="RSA1_5,RSA-OAEP" displayList="RSA1_5: Encryption with RSAES-PKCS1-V1_5, RSA-OAEP: Encryption with RSAES-OAEP" onchange="zenPage.doModified();"/>
</fieldSet>
<spacer height="2"/>
<text id="DefaultScope" label="Default scope" size="60" onchange="zenPage.doModified();"/>
<spacer height="2"/>
</group>
</form>
</pane>
}

ClientMethod showJWT(flag) [ Language = javascript ]
{
	zen("imgJWTPlus").setHidden(flag);
	zen("imgJWTMinus").setHidden(!flag);
	zen("groupJWT").setHidden(!flag);
}

/// End Add/Edit and return to list page.
ClientMethod doFinish() [ Language = javascript ]
{
	this.setModified(false);
	var opener = this.getOpener();
	if (opener) {
		self.close();
	} else {
		this.doCancel();
	}
}

/// User changed Type. Show/hide client/server credentials related fields.
ClientMethod changeClientType() [ Language = javascript ]
{
	var Type = zen('ClientType').getValue();
	var isHidden = (Type=="resource") ? true : false;
	zen('UseSSL').setHidden(isHidden);
	zen('addr').setHidden(isHidden);
	zen('port').setHidden(isHidden);
	zen('prefix').setHidden(isHidden);
	zen('id_Redirection').setHidden(isHidden);
}

/// Get user input and send to server to save settings.
ClientMethod doSave() [ Language = javascript ]
{
	try {	
		var PID = this.PID;
		var ClientType = zen("ClientType").getValue();
		var pass = true;
		var fields = '';
		if (!this.validateRequired(zen('Name'),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'Name';
		}
		if (!this.validateRequired(zen('SSLConfiguration'),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'SSLConfiguration';
		}

		if (!this.validateRequired(zen('ClientId'),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'ClientId';
		}
		if (ClientType != "resource") {
			if ((ClientType == "confidential") && !this.validateRequired(zen('ClientSecret'),pass,"S")) {
				pass = false;
				fields = fields + ((fields != "") ? ', ' : '') + 'ClientSecret';
			}
			if (!this.validateRequired(zen('addr'),pass,"S")) {
				pass = false;
				fields = fields + ((fields != "") ? ', ' : '') + 'addr';
			}
		}
		if (!pass) {
			this.ValidationErrorMsg = $$$Text('Required fields missing: ') + fields;
			this.afterValidate();
			return;
		}
		var valueProxy = new zenProxy();
		valueProxy.Name = zenTrim(zen('Name').getValue());
		valueProxy.Description = zenTrim(zen("Description").getValue());
		valueProxy.Enabled = (zen("Enabled").getValue()) ? 1 : 0;
		valueProxy.SSLConfiguration = zenTrim(zen("SSLConfiguration").getValue());
		valueProxy.ClientType = ClientType;
		valueProxy.UseSSL = zen("UseSSL").getValue();
		valueProxy.addr = zenTrim(zen("addr").getValue());
		valueProxy.port = zenTrim(zen("port").getValue());
		valueProxy.prefix = zenTrim(zen("prefix").getValue());
		valueProxy.DefaultScope = zenTrim(zen("DefaultScope").getValue());
		valueProxy.AuthenticationType = zenTrim(zen("AuthenticationType").getValue());
		valueProxy.ClientId = zenTrim(zen("ClientId").getValue());
		valueProxy.ClientSecret = zenTrim(zen("ClientSecret").getValue());
		valueProxy.ClientCredentials = zenTrim(zen("ClientCredentials").getValue());
		valueProxy.ClientPassword = zenTrim(zen("ClientPassword").getValue());
		valueProxy.SigningAlgorithm = zenTrim(zen("SigningAlgorithm").getValue());
		valueProxy.EncryptionAlgorithm = zenTrim(zen("EncryptionAlgorithm").getValue());
		valueProxy.KeyAlgorithm = zenTrim(zen("KeyAlgorithm").getValue());
		
		var proxy = this.SaveData(valueProxy);
		if (proxy.ok == 1) {
			if (proxy.Message != "") {
				this.showMsg(proxy.Message,0);
			} else {
				this.doFinish();
			}
		} else {
			this.showMsg(proxy.ErrorMessage,1);
		}
	} 
  catch(ex) {
	alert("ERROR: " + ex);
	}
}

/// Set focus to the Name field.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	
	zen("Name").focus();
	// disable or enable fields based on Type, etc.
	if (zen("ClientType").getValue()=='') zen("ClientType").setValue("confidential")
	this.changeClientType();
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	#; If a PID is purposely removed when this page is rendered, then set isNew to true.
	If ..PID = "" Set ..isNew = 1

	Set titleAdd = $$$FormatText($$$Text("Use the form below to create a new OAuth 2.0 client configuration for server %1:"), $zconvert(%session.Data($Username,"IssuerEndpoint"),"O","HTML"))
	Set titleEdit = $$$FormatText($$$Text("Use the form below to edit an existing OAuth 2.0 client configuration for server %1:"), $zconvert(%session.Data($Username,"IssuerEndpoint"),"O","HTML"))
	Set ..lblTitle = $S(..isNew=1:titleAdd,1:titleEdit)
	Set ..ParentURL = ..Link("%25CSP.UI.Portal.OAuth2.Client.ConfigurationList.zen")_"?IssuerEndpointID="_$zconvert(%session.Data($Username,"IssuerEndpointID"),"O","HTML")_"&IssuerEndpoint=" _ $zconvert(%session.Data($Username,"IssuerEndpoint"),"O","HTML")

	// Load data into fields
	Set tSC = ..LoadData(..PID)
	If '$$$ISOK(tSC) {
		Set ..%GetComponentById("idRespond").value = tSC
		Set ..%GetComponentById("idRespond").hidden = 0
		Set ..%GetComponentById("groupEdit").hidden = 1
	}

	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	If ..isNew {
		Quit $$$TextHTML("New OAuth 2.0 Client Configuration")
	} Else {
		Quit $$$TextHTML("Edit OAuth 2.0 Client Configuration")
	}
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Security Management","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("OAuth 2.0 Client Configurations","%Utility")
	Set tURL = "%25CSP.UI.Portal.OAuth2.Client.ServerList.zen"
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Client Configurations","%Utility")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_"?PID="_..EscapeURL($G(%request.Data("PID",1)))_$S(NAMESPACE="":"",1:"&$NAMESPACE="_..EscapeURL(NAMESPACE)))
	Quit $$$OK
}

/// Get redirect URL upon user changing any of server address/port/prefix.
ClientMethod getRedirectURL() [ Language = javascript ]
{
	var ssl = zen('UseSSL').getValue() ? 1 : 0;
	var addr = zenTrim(zen('addr').getValue());
	var port = zenTrim(zen('port').getValue());
	var prefix = zenTrim(zen('prefix').getValue());
	var url = this.GetRedirectURLforUI(addr, port, prefix, ssl);
	zen('redirectURL').setValue(url);
}

/// Used when Editing an existing OAuth2 client configuration. Load previously defined values into fields.
Method LoadData(PID As %String) As %Status
{
	Set $ZT="Error"
	If '%page.isNew {
		If ##class(OAuth2.Client).%ExistsId(PID) {
			Set sys = ##class(OAuth2.Client).Open(PID)
			Set isHidden = (sys.ClientType = "resource")
			Set ..%GetComponentById("UseSSL").hidden = isHidden
			Set ..%GetComponentById("addr").hidden = isHidden
			Set ..%GetComponentById("port").hidden = isHidden
			Set ..%GetComponentById("prefix").hidden = isHidden
		} Else {
			Quit $$$TextHTML("Cannot open object!")
		}
	} Else {
		Set sys = ##class(OAuth2.Client).%New()
	}
	Set tRS = ##class(%ResultSet).%New("Security.SSLConfigs:List")
	Do tRS.Execute("*")
	Set SSLConfigurations = ""
	While tRS.Next() {
		If tRS.GetData(1) '= "" {
			Set SSLConfigurations = SSLConfigurations _ $S(SSLConfigurations'="":",",1:"") _ tRS.GetData(1)	
		}
	}
	Set ..%GetComponentById("Name").value = PID
	Set ..%GetComponentById("Description").value = sys.Description
	Set ..%GetComponentById("Enabled").value = sys.Enabled
	Set ..%GetComponentById("ClientType").value = sys.ClientType
	Set ..%GetComponentById("SSLConfiguration").valueList = SSLConfigurations
	Set ..%GetComponentById("SSLConfiguration").value = sys.SSLConfiguration
	Set ..%GetComponentById("UseSSL").value = $select(sys.RedirectionEndpoint.UseSSL="":1,1:sys.RedirectionEndpoint.UseSSL)
	Set ..%GetComponentById("addr").value = sys.RedirectionEndpoint.Host
	Set ..%GetComponentById("port").value = sys.RedirectionEndpoint.Port
	Set ..%GetComponentById("prefix").value = sys.RedirectionEndpoint.Prefix
	Set ..%GetComponentById("DefaultScope").value = sys.DefaultScope
	Set ..%GetComponentById("AuthenticationType").value = sys.AuthenticationType
	Set ..%GetComponentById("ClientId").value = sys.ClientId
	Set ..%GetComponentById("ClientSecret").value = sys.ClientSecret
	Set ..%GetComponentById("redirectURL").value = ..GetRedirectURLforUI(sys.RedirectionEndpoint.Host, sys.RedirectionEndpoint.Port, sys.RedirectionEndpoint.Prefix, sys.RedirectionEndpoint.UseSSL)
	Set ..%GetComponentById("ClientCredentials").value = sys.ClientCredentials
	Set ..%GetComponentById("ClientCredentials").originalValue = sys.ClientCredentials
	Set ..%GetComponentById("ClientPassword").value = sys.ClientPassword
	Set tX509List = ""
	Set tRS = ##class(%ResultSet).%New("%SYS.X509Credentials:ListPrivateKey")
	Do tRS.Execute()
	While tRS.Next() {
		Set tX509List = tX509List _ $S(tX509List'="":",", 1:"")_tRS.GetData(1)	
	}
	Set ..%GetComponentById("ClientCredentials").valueList = tX509List	

	Set ..%GetComponentById("SigningAlgorithm").value = sys.SigningAlgorithm
	Set ..%GetComponentById("EncryptionAlgorithm").value = sys.EncryptionAlgorithm
	Set ..%GetComponentById("KeyAlgorithm").value = sys.KeyAlgorithm			

	Quit $$$OK
Error	///
	Set $ZT="" Do BACK^%ETN
	Quit $ZCVT($ZE,"O","HTML")
}

/// Save general association data to server
/// Test can only be done for client, not server. 
ClassMethod SaveData(pValueProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	
	Set $ZT="Error"
	
	#dim sys as OAuth2.Client

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 0
	Set tProxy.Message = ""
	Set tProxy.ErrorMessage = ""
	Set tProxy.PID = pValueProxy.Name
	Set tSC = $$$OK
	Set IssuerEndpointID = $G(%session.Data($Username,"IssuerEndpointID"))
	If IssuerEndpointID '= "" {
		Set ServerDefinition = ##class(OAuth2.ServerDefinition).%OpenId(IssuerEndpointID)
	} Else {
		Set ServerDefinition = ##class(OAuth2.ServerDefinition).%New()
	}
	If ##class(OAuth2.Client).%ExistsId(pValueProxy.Name) {
		Set sys = ##class(OAuth2.Client).Open(pValueProxy.Name)
	} Else {
		Set sys = ##class(OAuth2.Client).%New()
		Set sys.ApplicationName = pValueProxy.Name
	}
	Set sys.ServerDefinition = ServerDefinition
	Set sys.Enabled = pValueProxy.Enabled
	Set sys.ClientType = pValueProxy.ClientType
	Set sys.Description = pValueProxy.Description
	Set sys.SSLConfiguration = pValueProxy.SSLConfiguration
	Set sys.RedirectionEndpoint.UseSSL = pValueProxy.UseSSL
	Set sys.RedirectionEndpoint.Host = pValueProxy.addr
	Set sys.RedirectionEndpoint.Port = pValueProxy.port
	Set sys.RedirectionEndpoint.Prefix = pValueProxy.prefix
	Set sys.DefaultScope = pValueProxy.DefaultScope
	Set sys.AuthenticationType = pValueProxy.AuthenticationType
	Set sys.ClientId = pValueProxy.ClientId
	Set sys.ClientSecret = pValueProxy.ClientSecret
	Set sys.ClientCredentials = pValueProxy.ClientCredentials
	Set sys.ClientPassword = pValueProxy.ClientPassword
	Set sys.SigningAlgorithm = pValueProxy.SigningAlgorithm
	Set sys.EncryptionAlgorithm = pValueProxy.EncryptionAlgorithm
	Set sys.KeyAlgorithm = pValueProxy.KeyAlgorithm

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
	Kill sys
	Quit tProxy
}

Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnSave",$$$Text("Save"),$$$Text("Save changes"),"zenPage.doSave();")
	Set pCommands(2) = $LB("btnCancel",$$$Text("Cancel"),$$$Text("Return without saving new changes"),"zenPage.doFinish();")

	Quit $$$OK
}

ClassMethod GetRedirectURLforUI(pAddress, pPort, pPrefix, pSSL) As %String [ ZenMethod ]
{
	If pAddress="", pPort="", pPrefix="" Quit ""
	Set tClient = ##class(OAuth2.Client).%New()
	Set tClient.RedirectionEndpoint.UseSSL = pSSL
	Set tClient.RedirectionEndpoint.Host = pAddress
	Set tClient.RedirectionEndpoint.Port = pPort
	Set tClient.RedirectionEndpoint.Prefix = pPrefix
	Set tURL = ##class(OAuth2.Response).GetRedirectURL(tClient, .tSC)
	If $$$ISOK(tSC) Quit tURL
	Quit $System.Status.GetErrorText(tSC)
}

}
