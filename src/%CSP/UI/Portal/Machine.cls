/// Zen page for System Management Portal 
Class %CSP.UI.Portal.Machine Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Edit Machine";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Machine.zen";

Parameter HELPADDRESS = "Home,Provider,Machines";

Parameter PARENTPAGE = "/csp/sys/mgr/%CSP.UI.Portal.Machines.zen";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property isNew As %ZEN.Datatype.boolean(ZENURL = "isNew") [ InitialExpression = "0" ];

/// ID for edit. Null if adding new credentials.
Property PID As %String(ZENURL = "PID");

XData Style
{
<style type="text/css">
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px;">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<text id="PID" hidden="true"/>
<text hidden="true" name="browseselect" id="browseselect"/>
<form autocomplete="false">
<label id="idRespond" enclosingClass="errorNote" hidden="true" containerStyle="padding-bottom:2px;"/>
<radioSet id="OneOrMany" label="Create Provider Machines" valueList="0,1" displayList="Create One, Create Many" value="0" onchange="zenPage.OneOrManyChanged(zenThis.getValue());zenPage.doModified();" />
<group id="groupOneEdit" hidden="false" cellStyle="padding:5px;" enclosingClass="EditForm" enclosingStyle="padding-top:2px;font-family: Verdana, Arial, Helvetica, sans-serif;" labelPosition="left">
<text id="Name" label="Name" size="60" maxlength="64" hint="Required." onchange="zenPage.doModified();"/>
<text id="Description" label="Description" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text id="DNSName" label="DNS Name" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text id="Username" label="Username" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text inputtype="password" id="Password" label="Password" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text inputtype="password" id="PasswordConfirm" label="Password (confirm)" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<hgroup id="KeyFileGroup" labelPosition="left" label="Key File" cellVAlign="top">
<text id="KeyFile" size="60" onchange="zenPage.doModified();"/>
<button id="btnBrowse1" caption="Browse..." onclick="zenPage.browseSelect('KeyFile','*.cer*');"/>
</hgroup>
</group>
<group id="groupManyEdit" hidden="true" cellStyle="padding:5px;" enclosingClass="EditForm" enclosingStyle="padding-top:2px;font-family: Verdana, Arial, Helvetica, sans-serif;" labelPosition="left">
<text id="DNSNameMany" label="DNS Name Prefix" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text id="StartingDNSNameNumber" label="DNS Name Start Number" size="10" maxlength="10" onchange="zenPage.doModified();"/>
<text id="EndingDNSNameNumber" label="DNS Name End Number" size="10" maxlength="10" onchange="zenPage.doModified();"/>
<text id="DescriptionMany" label="Description" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text id="UsernameMany" label="Username" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text inputtype="password" id="PasswordMany" label="Password" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<text inputtype="password" id="PasswordConfirmMany" label="Password (confirm)" size="60" maxlength="256" onchange="zenPage.doModified();"/>
<hgroup id="KeyFileGroupMany" labelPosition="left" label="Key File" cellVAlign="top">
<text id="KeyFileMany" size="60" onchange="zenPage.doModified();"/>
<button id="btnBrowse1Many" caption="Browse..." onclick="zenPage.browseSelectMany('KeyFileMany','*.cer*');"/>
</hgroup>
</group>
</form>
</pane>
}

ClientMethod OneOrManyChanged(newvalue) [ Language = javascript ]
{
	if (newvalue == 1) {
		zen('groupOneEdit').setHidden(true);
		zen('groupManyEdit').setHidden(false);
	} else {
		zen('groupOneEdit').setHidden(false);
		zen('groupManyEdit').setHidden(true);
	}
}

/// User clicked one of the Browse buttons.
/// Save the name of the textfield so that when you return you know which textfield to update.
ClientMethod browseSelect(name, wildcard) [ Language = javascript ]
{
	zenPage.getComponentById('browseselect').setValue(name);
	var Dir = zenPage.getComponentById(name).getValue();
	zenLaunchPopupWindow('%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir)+'&wildcard='+wildcard,'FileSelect','resizable,width=600,height=700');
}

/// User clicked one of the Browse buttons.
/// Save the name of the textfield so that when you return you know which textfield to update.
ClientMethod browseSelectMany(name, wildcard) [ Language = javascript ]
{
	zenPage.getComponentById('browseselectMany').setValue(name);
	var Dir = zenPage.getComponentById(name).getValue();
	zenLaunchPopupWindow('%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir)+'&wildcard='+wildcard,'FileSelect','resizable,width=600,height=700');
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	var PID = this.PID;
	if (PID != "") {
		zen("Description").focus();
	} else {
		zen("Name").focus();
	}
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	#; If a PID is purposely removed when this page is rendered, then set it isNew to true.
	If ..PID = "" Set ..isNew = 1

	If ..isNew {
		Set ..lblTitle = $$$Text("Use the form below to create a new Provider Machine:")
		Set ..HelpAddress = "Home,Provider Management,Machines,Add Machine"
		s Status=##Class(Provider.Defaults).Get("SYSTEM",.Properties)
		i '$$$ISOK(Status) q Status
		s ..%GetComponentById("Username").value=Properties("Username")
		s ..%GetComponentById("Password").value=Properties("Password")
		s ..%GetComponentById("PasswordConfirm").value=Properties("Password")
		s ..%GetComponentById("KeyFile").value=Properties("KeyFile")
		s ..%GetComponentById("UsernameMany").value=Properties("Username")
		s ..%GetComponentById("PasswordMany").value=Properties("Password")
		s ..%GetComponentById("PasswordConfirmMany").value=Properties("Password")
		s ..%GetComponentById("KeyFileMany").value=Properties("KeyFile")
	} Else {
		Set ..%GetComponentById("OneOrMany").hidden = 1
		Set ..lblTitle = $$$Text("Use the form below to edit a Provider Machine:")
		Set ..HelpAddress = "Home,Provider Management,Machines,Edit Machine"
		Set Status = ##class(Provider.Machines).Get(..PID,.Properties)
		i '$$$ISOK(Status) q Status
		s Properties("PasswordConfirm")=Properties("Password")
		d ..PopulateFields(.Properties)
	}
	
	Quit $$$OK
}

Method PopulateFields(ByRef Properties As %String) As %Status
{
	// Loop to set all field values
	Set Property = ""
	Set Property = $O(Properties(Property)) 
	While Property '= ""  {
		Set Component = ..%GetComponentById(Property)
		If $ISO(Component) Set Component.value = Properties(Property)
		Set Property = $O(Properties(Property)) 
	}
	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	If ..isNew {
		Quit $$$Text("New Provider Machine")
	} Else {
		Quit $$$Text("Edit Provider Machine")
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

	Set tPageName = $$$Text("Provider Management","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Machines","%Utility")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_"?PID="_$ZCVT($G(%request.Data("PID",1)),"O","URL"))
	Quit $$$OK
}

/// Used to draw title for this page. pHalpAddress is need to build the link for Help for this page.
ClassMethod DrawTitle1(pSeed As %String) As %Status
{
	Do %application.DrawTitle(%page.LocatorHeader_"^"_%page.HelpAddress)
	Quit $$$OK
}

/// Get user selection and send to server to save settings.
ClientMethod doSave() [ Language = javascript ]
{
	var proxy = new zenProxy();
	proxy.PID = this.PID;
	proxy.Name = zen('Name').getValue();
	proxy.DNSName = zen('DNSName').getValue();
	proxy.KeyFile = zen('KeyFile').getValue();
	proxy.Description = zen('Description').getValue();
	proxy.Username = zen('Username').getValue();
	proxy.Password = zen('Password').getValue();
	
	proxy.DNSNameMany = zen('DNSNameMany').getValue();
	proxy.KeyFileMany = zen('KeyFileMany').getValue();
	proxy.DescriptionMany = zen('DescriptionMany').getValue();
	proxy.UsernameMany = zen('UsernameMany').getValue();
	proxy.PasswordMany = zen('PasswordMany').getValue();
	proxy.StartingDNSNameNumber = zen("StartingDNSNameNumber").getValue();
	proxy.EndingDNSNameNumber = zen("EndingDNSNameNumber").getValue();
	proxy.OneOrMany = zen('OneOrMany').getValue();
	var result = this.SaveData(proxy);
	if (result.ok != 1) {
		// error case
		this.showMsg(result.ErrorMessage,true);
		return;
	}
	this.setModified(false);
	// saved existing app
	this.afterSave(result);
	//this.showMsg($$$Text('Machine saved.'),false);
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

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			var name = zen("browseselect").getValue();
			zen(name).setValue(value);
			this.doModified();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Save general association data to server
ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
		#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		i pProxy.OneOrMany=0 {
			Set Properties("Description") = pProxy.Description
			Set Properties("KeyFile")=pProxy.KeyFile
			Set Properties("Username")=pProxy.Username
			Set Properties("Password")=pProxy.Password
			Set Properties("DNSName")=pProxy.DNSName
			If pProxy.PID = "" {
				Set tSC = ##class(Provider.Machines).Create(pProxy.Name,.Properties)
				If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			} Else {
				Set tSC = ##class(Provider.Machines).Modify(pProxy.Name,.Properties)
				If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			}
		} else {
			Set Properties("Description") = pProxy.DescriptionMany
			Set Properties("KeyFile")=pProxy.KeyFileMany
			Set Properties("Username")=pProxy.UsernameMany
			Set Properties("Password")=pProxy.PasswordMany
			Set Properties("DNSName")=pProxy.DNSNameMany
			Set Properties("StartingDNSNameNumber")=pProxy.StartingDNSNameNumber
			Set Properties("EndingDNSNameNumber")=pProxy.EndingDNSNameNumber
			Set tSC = ##class(Provider.Machines).CreateMany(.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

}