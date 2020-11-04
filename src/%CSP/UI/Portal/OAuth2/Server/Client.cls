/// Page to define OAuth2 server clients
/// which have registered with the authorization server.
Class %CSP.UI.Portal.OAuth2.Server.Client Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "OAuth 2.0 Authorization Server Client Configuration";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.OAuth2.Server.Client.zen";

Parameter HELPADDRESS = "System Administration,Security,OAuth2,Server Configuration";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property NAMESPACE As %ZEN.Datatype.string(ZENURL = "$NAMESPACE");

/// ID for edit. Null if adding new client.
Property ClientId As %String(ZENURL = "ClientId");

Property isNew As %Boolean;

Property EditPage As %String [ InitialExpression = {..Link("%25CSP.UI.Portal.OAuth2.Server.Client.zen",,1)} ];

Property addRedirectURL As %Boolean [ InitialExpression = 1 ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title instructions */
div.Description	{
	font-size: 0.9em; 
	padding: 5px;
}
.listBox {
	border: 1px solid darkgray;	
}
.EditForm {
	background-image: none;	
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
<spacer height="2"/>
<text id="Name" label="Name" size="60" maxlength="1024" hint="Required." onchange="zenPage.doModified();"/>
<text id="Description" label="Description" size="60" maxlength="1024" onchange="zenPage.doModified();"/>
<radioSet id="ClientType" label="Client type" displayList="Confidential,Public,Resource server" valueList="confidential,public,resource" required="true" hint="Required." onchange="zenPage.doModified();"/>
<text id="DefaultScope" label="Default scope" size="60" maxlength="1024" onchange="zenPage.doModified();"/>
<vgroup label="Supported grant types (check at least one)" labelPosition="left" >
<checkbox id="GrantType1" caption="Authorization code" captionClass="normal" aux="A" onchange="zenPage.doModified();"/>
<checkbox id="GrantType2" caption="Implicit" captionClass="normal" aux="I" onchange="zenPage.doModified();"/>
<checkbox id="GrantType3" caption="Resource owner password credentials" captionClass="normal" aux="P" onchange="zenPage.doModified();"/>
<checkbox id="GrantType4" caption="Client credentials" captionClass="normal" aux="C" onchange="zenPage.doModified();"/>
</vgroup>
<text id="ClientId" label="Client ID" readOnly="true" size="60" controlStyle="background:#D0D0D0;"/>
<hgroup label="Client secret">
<text id="ClientSecret" size="60" readOnly="true" hidden="true" controlStyle="background:#D0D0D0;"/>
<link id="linkClientSecret" caption="show" href="#" onclick="zenPage.showHide('ClientSecret');"/>
</hgroup>
<listBox id="RedirectURLs" label="Redirect URLs" hint="Require at least one URL. Click an item in the list to edit or remove." width="600px" onchange="zenPage.selectRedirectURL();"/>
<button id="btnAdd" caption="Add URL" onclick="zenPage.newRedirectURL();"/>
<group id="groupRedirectURL" labelPosition="left" hidden="true">
<text id="RedirectURL" label="Enter URL: " required="true" size="60" onchange="zenPage.doModified();"/>
<hgroup>
<button id="btnSave" caption="OK" onclick="zenPage.saveRedirectURL();"/>
<button id="btnRemove" caption="Remove" disabled="true" onclick="zenPage.removeRedirectURL();"/>
<button id="btnCancel" caption="Cancel" onclick="zenPage.cancelRedirectURL();"/>
</hgroup>
</group>
<text id="LaunchURL" label="Launch URL: " size="60" onchange="zenPage.doModified();"/>
<spacer height="2"/>
<fieldSet id="id_DisplayURL" label="Authorization display" >
<label id="id_DisplayNote" value="This section contains the URLs to be displayed when requesting permissions from the end user." enclosingClass="normal" enclosingStyle="padding-bottom:4px;"/>
<text id="ClientName" label="Client name" size="40" hint="" onchange="zenPage.doModified();"/>
<text id="LogoUri" label="Logo URL" size="70" hint="" onchange="zenPage.doModified();"/>
<text id="ClientUri" label="Client home page URL" size="70" onchange="zenPage.doModified();"/>
<text id="PolicyUri" label="Policy URL" size="70" onchange="zenPage.doModified();"/>
<text id="TosUri" label="Terms of service URL" size="70" onchange="zenPage.doModified();"/>
</fieldSet>
<spacer height="2"/>
<fieldSet id="groupJWT" label="JSON Web Token (JWT) Settings">
<select id="ClientCredentials" label="Client credentials" onchange="zenPage.doModified();"/>
</fieldSet>
</group>
</form>
</pane>
</pane>
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	/// Set focus to the Name field and set default client type.	
	zen("Name").focus();
	if (zen("ClientType").getValue()=='') zen("ClientType").setValue("confidential");
}

ClientMethod showHide(fieldName) [ Language = javascript ]
{
	var isHidden = zen(fieldName).getProperty('hidden');
	var linkCaption = (isHidden) ? $$$Text('hide') : $$$Text('show');
	zen(fieldName).setHidden(!isHidden);
	zen('link'+fieldName).setProperty('caption', linkCaption);
}

/// User clicked an existing redirect url from the listbox.<br>
/// Set the value into the textbox for editing or removing.
ClientMethod selectRedirectURL() [ Language = javascript ]
{
	this.addRedirectURL = 0;
	zen('groupRedirectURL').setHidden(false);
	var ctrl = zen('RedirectURLs');
	zen('btnRemove').setDisabled(false);
	zen('RedirectURL').setValue(ctrl.getValue());
	zen('RedirectURL').focus();
}

/// User clicked the Add URL button to add a new Redirect URL.<br>
/// Clear the textbox to allow user to enter a new one.
ClientMethod newRedirectURL() [ Language = javascript ]
{
	this.addRedirectURL = 1;
	zen('groupRedirectURL').setHidden(false);
	zen('RedirectURLs').setProperty('selectedIndex', -1);
	zen('btnRemove').setDisabled(true);
	zen('RedirectURL').setValue('');
	zen('RedirectURL').focus();
}

/// User clicked the OK button to save a Redirect URL.<br>
/// Clear list selection and hide the edit fields afterwards.
ClientMethod saveRedirectURL() [ Language = javascript ]
{
	var url = zenTrim(zen('RedirectURL').getValue());
	if (!url) {
		alert($$$Text("Nothing to save - please enter a Redirect URL"));
		return;
	}
	var ctrl = zen('RedirectURLs');
	if (this.addRedirectURL) {
		ctrl.appendOption(url,url);	
	} else {
		ctrl.setOption(ctrl.getProperty('selectedIndex'), url, url);
	}
	ctrl.setProperty('selectedIndex', -1);
	this.addRedirectURL = 0;
	zen('groupRedirectURL').setHidden(true);
}

ClientMethod cancelRedirectURL() [ Language = javascript ]
{
	zen('groupRedirectURL').setHidden(true);
	zen('RedirectURLs').setProperty('selectedIndex', -1);
}

/// User clicked the Remove button to remove an entry from the listbox.
ClientMethod removeRedirectURL() [ Language = javascript ]
{
	var url = zenTrim(zen('RedirectURL').getValue());
	if (!url) {
		alert($$$Text("Nothing to remove"));
		return;	
	}
	var ctrl = zen('RedirectURLs');
	var currIndex = ctrl.selectedIndex;
	ctrl.removeOption(currIndex);
	ctrl.setProperty('selectedIndex', -1);
	this.addRedirectURL = 0;
	zen('groupRedirectURL').setHidden(true);
	this.doModified();
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod doSave(action) As %Boolean [ Language = javascript ]
{
	try {
		var ok = 1;
		var pass = true;
		var fields = '';
		if (!this.validateRequired(zen("Name"),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'Name';
		}
		if (!this.validateRequired(zen("ClientType"),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'ClientType';
		}
		if (zen("ClientType").getValue() != "resource") {
			var SupportedGrantTypes = "";
			if (zen("GrantType1").getValue()) SupportedGrantTypes = zen("GrantType1").aux;
			if (zen("GrantType2").getValue()) SupportedGrantTypes += zen("GrantType2").aux;
			if (zen("GrantType3").getValue()) SupportedGrantTypes += zen("GrantType3").aux;
			if (zen("GrantType4").getValue()) SupportedGrantTypes += zen("GrantType4").aux;
			if (!SupportedGrantTypes) {
				pass = false;
				if (!this.FirstFailed) this.FirstFailed = 'GrantType1';
				fields = fields + ((fields != "") ? ', ' : '') + 'SupportedGrantTypes';
			}
			var RedirectURL = '';
			var listURL = zen("RedirectURLs");
			var count = listURL.getOptionCount();
			if (count > 0) {
				for (i = 0; i < count; i++) {
					if (listURL.getOptionValue(i)) {
						RedirectURL = RedirectURL + listURL.getOptionValue(i) + "^";
					}
				}
			}
			if (!RedirectURL) {
				pass = false;
				if (!this.FirstFailed) this.FirstFailed = 'RedirectURLs';
				fields = fields + ((fields != "") ? ', ' : '') + 'RedirectURLs';			
			}
		}
		if (!pass) {
			// display standard error message on top
			this.ValidationErrorMsg = $$$Text('Required fields missing: ') + fields;
			this.afterValidate();
			return;
		} 
		var Name = zenTrim(zen("Name").getValue());
		var ClientId = zenTrim(zen("ClientId").getValue());
		var ClientSecret = zenTrim(zen("ClientSecret").getValue());
		var ClientType = zenTrim(zen("ClientType").getValue());
		var DefaultScope = zenTrim(zen("DefaultScope").getValue());
		var Description = zenTrim(zen("Description").getValue());
		var LaunchURL = zenTrim(zen("LaunchURL").getValue());
		var ClientName = zenTrim(zen("ClientName").getValue());
		var LogoUri = zenTrim(zen("LogoUri").getValue());
		var ClientUri = zenTrim(zen("ClientUri").getValue());
		var PolicyUri = zenTrim(zen("PolicyUri").getValue());
		var TosUri = zenTrim(zen("TosUri").getValue());
		var ClientCredentials = zenTrim(zen("ClientCredentials").getValue());
		var result = this.SaveData(Name, ClientId, ClientSecret, ClientType, DefaultScope, Description, RedirectURL, SupportedGrantTypes, LaunchURL, ClientName, LogoUri, ClientUri, PolicyUri, TosUri, ClientCredentials);
		if (result.ok == 1) {
			this.setModified(false);
			if ((typeof(result.Message) != "undefined") && (result.Message != "")) {
				this.showMsg(result.Message,0);
			} else {
				this.doCancel();
			}
		} else {
			this.showMsg(result.ErrorMessage,1);
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

ClientMethod doCancel() [ Language = javascript ]
{
	this.setModified(false);
	var opener = this.getOpener();
	if (opener) {
		self.close();
	} else {
		self.document.location = this.ParentURL;
	}
}

/// This client event, if present, is fired when the page is resized.
ClientMethod onresizeHandler() [ Language = javascript ]
{
}

Method %OnGetPageName() As %String
{
	Quit $$$Text("Server Client Configuration")
}

/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set tPageName = $$$Text("System")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Security Management","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("OAuth 2.0 Authorization Server","%Utility")
	Set tURL = ..Link("%25CSP.UI.Portal.OAuth2.Server.Configuration.zen")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen")
	Quit $$$OK
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

	Set ..isNew = (..ClientId = "")
	Set titleAdd = $$$TextHTML("Use the form below to create a new OAuth 2.0 server client which has been registered with the authorization server:")
	Set titleEdit = $$$TextHTML("Use the form below to edit an existing OAuth 2.0 server client which has been registered with the authorization server:")
	Set ..lblTitle = $S(..isNew=1:titleAdd,1:titleEdit)
	Set ..ParentURL = ..Link("%25CSP.UI.Portal.OAuth2.Server.ClientList.zen")
	If ..ClientId '= "", ##class(OAuth2.Server.Client).%ExistsId(..ClientId) {
		Set sys = ##class(OAuth2.Server.Client).Open(..ClientId)
	} Else {
		Set sys = ##class(OAuth2.Server.Client).%New()
	}
	Set ..%GetComponentById("Name").value = sys.Name
	Set ..%GetComponentById("Description").value = sys.Description
	Set ..%GetComponentById("ClientId").value = sys.ClientId
	Set ..%GetComponentById("ClientSecret").value = sys.ClientSecret
	Set ..%GetComponentById("ClientType").value = sys.ClientType
	Set ..%GetComponentById("DefaultScope").value = sys.DefaultScope
	Set ..%GetComponentById("LaunchURL").value = sys.LaunchURL
	Set ..%GetComponentById("ClientName").value = sys."client_name"
	Set ..%GetComponentById("LogoUri").value = sys."logo_uri"
	Set ..%GetComponentById("ClientUri").value = sys."client_uri"
	Set ..%GetComponentById("PolicyUri").value = sys."policy_uri"
	Set ..%GetComponentById("TosUri").value = sys."tos_uri"
	
	For i = 1:1:4 {
		Set value = $E(sys.SupportedGrantTypes,i)
		If value '= "" {
			Set:value="A" ..%GetComponentById("GrantType1").value = 1
			Set:value="I" ..%GetComponentById("GrantType2").value = 1
			Set:value="P" ..%GetComponentById("GrantType3").value = 1
			Set:value="C" ..%GetComponentById("GrantType4").value = 1
		}
	}
	Set totalURL = sys.RedirectURL.Count()
	For item = 1:1:totalURL {
		Set option = ##class(%ZEN.Auxiliary.option).%New()
		Set (option.value, option.text) = sys.RedirectURL.GetAt(item)
		Do %page.%AddComponent(option)
		Do ..%GetComponentById("RedirectURLs").options.Insert(option)
	}
	Set tX509List = ""
	Set tRS = ##class(%ResultSet).%New("%SYS.X509Credentials:ListDetails")
	Do tRS.Execute()
	While tRS.Next() {
		Set tX509List = tX509List _ $S(tX509List'="":",", 1:"")_tRS.GetData(1)	
	}
	Set ..%GetComponentById("ClientCredentials").valueList = tX509List	
	Set ..%GetComponentById("ClientCredentials").value = sys.ClientCredentials
	Quit $$$OK
}

ClassMethod SaveData(Name, ClientId, ClientSecret, ClientType, DefaultScope, Description, RedirectURL, SupportedGrantTypes, LaunchURL, ClientName, LogoUri, ClientUri, PolicyUri, TosUri, ClientCredentials) As %ZEN.proxyObject [ ZenMethod ]
{
	
	Set $ZT="Error"
	
	#dim sys as OAuth2.Server.Client

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 0
	Set tProxy.Message = ""
	Set tProxy.ErrorMessage = ""
	Set tProxy.ClientId = ClientId
	Set tSC = $$$OK
	If ##class(OAuth2.Server.Client).%ExistsId(ClientId) {
		Set sys = ##class(OAuth2.Server.Client).%OpenId(ClientId)
		Set tSC = sys.RedirectURL.Clear()
	} Else {
		Set sys = ##class(OAuth2.Server.Client).%New()
		Set sys.ClientId=ClientId
	}
	Set sys.Name = Name
	Set sys.ClientSecret = ClientSecret
	Set sys.ClientType = ClientType
	Set sys.DefaultScope = DefaultScope
	Set sys.Description = Description
	Set tCount = 1
	Set item = $P(RedirectURL,"^",tCount)
	While item '= "" {
		Do sys.RedirectURL.Insert(item)
		Set tCount = tCount + 1
		Set item = $P(RedirectURL,"^",tCount)
	}
	Set sys.SupportedGrantTypes = SupportedGrantTypes
	Set sys.LaunchURL = LaunchURL
	Set sys."client_name" = ClientName
	Set sys."logo_uri" = LogoUri
	Set sys."client_uri" = ClientUri
	Set sys."policy_uri" = PolicyUri
	Set sys."tos_uri" = TosUri
	Set sys.ClientCredentials = ClientCredentials
	Set tSC = sys.Save()
	If $$$ISERR(tSC) {
		Set tProxy.ErrorMessage = $ZCVT($System.Status.GetErrorText(tSC),"O","HTML")
	} Else {
		Set tProxy.ok = 1
		Set tProxy.ClientId = sys.ClientId
	}
	Kill sys
	Quit tProxy
Error	///
	Set $ZT="" Do BACK^%ETN
	Set tProxy.ErrorMessage = $ZCVT($ZE,"O","HTML")
	Kill sys
	Quit tProxy
}

}
