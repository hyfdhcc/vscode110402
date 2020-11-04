Class %CSP.UI.Portal.Domain Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Edit Domain";

Parameter PARENTPAGE = "/csp/sys/sec/%CSP.UI.Portal.Domains.zen";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.Domain.zen";

Parameter HELPADDRESS = "Home,Security Management,Security Domains";

Parameter EMSSERVICE = "Users";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<label id="errmsg" hidden="true" enclosingClass="ErrorBox"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<label id="lblName" label="Domain name" hidden="true" controlClass="normal"/>
<text id="Name" label="Domain name" size="20" hint="Required." onchange="zenPage.doModified();"/>
<text id="Description" label="Description" size="80" onchange="zenPage.doModified();"/>
</group>
</form>
</pane>
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	try {
		var pass = true;
		if (!this.validateRequired(zen('Name'),pass,"S")) pass = false;

		return pass;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
}

/// Save current item.
ClientMethod doSave() [ Language = javascript ]
{
	try {
		this.resetMsg();
		
		// if user has not changed anything but hit Save, then we can just close out.
		if (!this.pageModified) {
			this.doCancel();
			return;
		}
		
		if (this.PID == "") {
			if (!this.validate()) {
				this.afterValidate();
				return;
			}
		}
		
		var proxy = new zenProxy();
		proxy.PID = this.PID;
		proxy.Name = zen('Name').getValue();
		proxy.Description = zen('Description').getValue();
		
		var ok = this.SaveData(proxy);
		this.afterSave(ok);
	} catch (ex) {
		alert("Error doSave: " + ex);
	}
}

/// Call server save method.
ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		If (pProxy.PID '= "") {
			Set Properties("Description") = pProxy.Description
			Set tSC = ##Class(Security.Domains).Modify(pProxy.PID,.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		} Else {
			Set tSC = ##class(Security.Domains).Create(pProxy.Name,pProxy.Description)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	If ..PID = "" {
		Set ..%GetComponentById("Text1").value = $$$TextHTML("Use the form below to create a new domain code:")
	} Else {
		Set ..%GetComponentById("lblName").value = ..PID
		Set ..%GetComponentById("Text1").value = $$$FormatText($$$TextHTML("Use the form below to edit domain code %1:"),..PID)
		Set ..%GetComponentById("lblName").hidden = 0
		Set ..%GetComponentById("Name").hidden = 1
		
		Set tSC = ##class(Security.Domains).Get(..PID,.Properties)
		If $$$ISERR(tSC) {
			Set ..%GetComponentById("fld").hidden = 1
			Set ..InvalidParam = 1
			Quit $$$OK
		}

		Set tProperty = ""
		Set tProperty = $O(Properties(tProperty)) 
		While tProperty '= ""  {
			Set Component = ..%GetComponentById(tProperty)
			If $ISO(Component) {
				Set Component.value = Properties(tProperty)
				If ..IsEMSReadOnly Set Component.disabled = 1
			}
			Set tProperty = $O(Properties(tProperty)) 
		}
	}

	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Edit Domain")
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Security Management","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = $$$Text("Security Domains")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen?PID="_..EscapeURL(..PID)_$S(NAMESPACE="":"",1:"&$NAMESPACE="_NAMESPACE))
	Quit $$$OK
}

}
