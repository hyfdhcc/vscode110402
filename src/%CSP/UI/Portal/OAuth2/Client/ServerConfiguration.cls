/// Zen page for System Management Portal - Edit OAuth 2.0 client configuration
Class %CSP.UI.Portal.OAuth2.Client.ServerConfiguration Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "OAuth 2.0 Client Configuration";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.OAuth2.Client.ServerConfiguration.zen";

Parameter HELPADDRESS = "System Administration,Security,OAuth 2.0,Client Configurations,Server Configuration";

Parameter PARENTPAGE = "/csp/sys/sec/%CSP.UI.Portal.OAuth2.Client.ServerList.zen";

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
<text id="IssuerEndpoint" label="Issuer endpoint" hint="Required. Endpoint URL to be used to identify the authorization server." size="60"/>
<spacer height="2"/>
<fieldSet id="id_Server" label="Authorization server" >
<label id="id_ServerNote" value="This section describes the authorization server to be used" enclosingClass="normal" enclosingStyle="padding-bottom:4px;"/>
<text id="AuthorizationEndpoint" label="Authorization endpoint" size="60" hint="Required." onchange="zenPage.doModified();"/>
<text id="TokenEndpoint" label="Token endpoint" size="60" hint="Required." onchange="zenPage.doModified();"/>
<text id="UserinfoEndpoint" label="Userinfo endpoint" size="60" onchange="zenPage.doModified();"/>
<text id="IntrospectionEndpoint" label="Token introspection endpoint" size="60" onchange="zenPage.doModified();"/>
<text id="RevocationEndpoint" label="Token revocation endpoint" size="60" onchange="zenPage.doModified();"/>
</fieldSet>
<spacer height="2"/>
<fieldSet id="groupJWT" label="JSON Web Token (JWT) Settings" containerStyle="font-size:12px;padding-left:4px;padding-right:4px;">
<select id="ServerCredentials" label="Server credentials" onchange="zenPage.doModified();"/>
</fieldSet>
<spacer height="2"/>
</group>
</form>
</pane>
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

/// Get user input and send to server to save settings.
ClientMethod doSave() [ Language = javascript ]
{
	try {	
		var PID = this.PID;
		var pass = true;
		var fields = '';
		if (!this.validateRequired(zen('AuthorizationEndpoint'),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'AuthorizationEndpoint';
		}
		if (!this.validateRequired(zen('TokenEndpoint'),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'TokenEndpoint';
		}
		if (!this.validateRequired(zen('IssuerEndpoint'),pass,"S")) {
			pass = false;
			fields = fields + ((fields != "") ? ', ' : '') + 'IssuerEndpoint';
		}

		if (!pass) {
			this.ValidationErrorMsg = $$$Text('Required fields missing: ') + fields;
			this.afterValidate();
			return;
		}
		var valueProxy = new zenProxy();
		valueProxy.PID = PID;
		valueProxy.AuthorizationEndpoint = zenTrim(zen("AuthorizationEndpoint").getValue());
		valueProxy.TokenEndpoint = zenTrim(zen("TokenEndpoint").getValue());
		valueProxy.UserinfoEndpoint = zenTrim(zen("UserinfoEndpoint").getValue());
		valueProxy.IntrospectionEndpoint = zenTrim(zen("IntrospectionEndpoint").getValue());
		valueProxy.RevocationEndpoint = zenTrim(zen("RevocationEndpoint").getValue());
		valueProxy.IssuerEndpoint = zenTrim(zen("IssuerEndpoint").getValue());
		valueProxy.ServerCredentials = zenTrim(zen("ServerCredentials").getValue());
		
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
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	#; If a PID is purposely removed when this page is rendered, then set isNew to true.
	If ..PID = "" Set ..isNew = 1

	Set titleAdd = $$$TextHTML("Use the form below to create a new OAuth 2.0 client server configuration:")
	Set titleEdit = $$$TextHTML("Use the form below to edit an existing OAuth 2.0 client server configuration:")
	Set ..lblTitle = $S(..isNew=1:titleAdd,1:titleEdit)

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
		Quit $$$TextHTML("New OAuth 2.0 Client Server Configuration")
	} Else {
		Quit $$$TextHTML("Edit OAuth 2.0 Client Server Configuration")
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
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_"?IssuerEndpointID="_..EscapeURL($G(%request.Data("IssuerEndpointID",1)))_$S(NAMESPACE="":"",1:"&$NAMESPACE="_NAMESPACE))
	Quit $$$OK
}

/// Used when Editing an existing OAuth2 client configuration. Load previously defined values into fields.
Method LoadData(PID As %String) As %Status
{
	Set $ZT="Error"
	If '%page.isNew {
		If ##class(OAuth2.ServerDefinition).%ExistsId(PID) {
			Set sys = ##class(OAuth2.ServerDefinition).%OpenId(PID)
		} Else {
			Quit $$$TextHTML("Cannot open object!")
		}
	} Else {
		Set sys = ##class(OAuth2.ServerDefinition).%New()
	}

	Set ..%GetComponentById("IssuerEndpoint").value = sys.IssuerEndpoint
	Set ..%GetComponentById("AuthorizationEndpoint").value = sys.AuthorizationEndpoint
	Set ..%GetComponentById("TokenEndpoint").value = sys.TokenEndpoint
	Set ..%GetComponentById("UserinfoEndpoint").value = sys.UserinfoEndpoint
	Set ..%GetComponentById("IntrospectionEndpoint").value = sys.IntrospectionEndpoint
	Set ..%GetComponentById("RevocationEndpoint").value = sys.RevocationEndpoint
	Set ..%GetComponentById("ServerCredentials").value = sys.ServerCredentials
	Set ..%GetComponentById("ServerCredentials").originalValue = sys.ServerCredentials
	Set tX509List = ""
	Set tRS = ##class(%ResultSet).%New("%SYS.X509Credentials:ListDetails")
	Do tRS.Execute()
	While tRS.Next() {
		Set tX509List = tX509List _ $S(tX509List'="":",", 1:"")_tRS.GetData(1)	
	}
	Set ..%GetComponentById("ServerCredentials").valueList = tX509List

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
	Set tProxy.PID = pValueProxy.PID
	Set tSC = $$$OK
	If ##class(OAuth2.ServerDefinition).%ExistsId(tProxy.PID) {
		Set sys = ##class(OAuth2.ServerDefinition).%OpenId(tProxy.PID)
	} Else {
		Set sys = ##class(OAuth2.ServerDefinition).%New()
	}
	Set sys.IssuerEndpoint = pValueProxy.IssuerEndpoint
	Set sys.AuthorizationEndpoint = pValueProxy.AuthorizationEndpoint
	Set sys.TokenEndpoint = pValueProxy.TokenEndpoint
	Set sys.UserinfoEndpoint = pValueProxy.UserinfoEndpoint
	Set sys.IntrospectionEndpoint = pValueProxy.IntrospectionEndpoint
	Set sys.RevocationEndpoint = pValueProxy.RevocationEndpoint
	Set sys.ServerCredentials = pValueProxy.ServerCredentials

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

}
