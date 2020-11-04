Class %CSP.UI.Portal.Parameters Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "System-wide Security Parameters";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.Parameters.zen";

Parameter HELPADDRESS = "System Administration,Security,System Security,System-wide Security Parameters";

Parameter EMSSERVICE = "Security";

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

/// Properties that are managed by the EMS Users service in Security.LoginRules
Property UsersFields As %String [ InitialExpression = "DefaultSecurityDomain,InactiveLimit,InvalidLoginLimit,InvalidLoginAction,PasswordExpirationDays,PasswordPattern,PasswordValidationRoutine,SecurityDomains" ];

/// True on the managed instance if the Users service is managed
Property UsersIsReadOnly As %Boolean [ InitialExpression = 0 ];

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm">
<group cellStyle="padding:4px;" labelPosition="left">
<checkbox id="AuditEnabled" label="Enable audit" onchange="zenPage.doModified();"/>
<checkbox id="ConfigurationSecurityEnabled" label="Enable configuration security" onchange="zenPage.doModified();"/>
<select id="DefaultSecurityDomain" label="Default security domain" showEmpty="false" onchange="zenPage.doModified();"/>
<text id="InactiveLimit" label="Inactive limit" hint="Required. (0-365)" size="8" onchange="zenPage.doModified();"/>
<text id="InvalidLoginLimit" label="Invalid login limit" hint="Required. (0-64)" size="8" onchange="zenPage.doModified();"/>
<checkbox id="InvalidLoginAction" label="Disable account if login limit reached" onchange="zenPage.doModified();"/>
<text id="PasswordExpirationDays" label="Password expiration days" hint="Required. (0-99999)" size="8" onchange="zenPage.doModified();"/>
<text id="PasswordPattern" label="Password pattern" size="40" onchange="zenPage.doModified();"/>
<text id="PasswordValidationRoutine" label="Password validation routine" size="40" onchange="zenPage.doModified();"/>
<text id="RequiredRole" label="Role required to connect to this system" size="40" onchange="zenPage.doModified();"/>
<checkbox id="PercentGlobalWrite" label="Enable writing to percent globals" onchange="zenPage.doModified();"/>
<checkbox id="SecurityDomains" label="Allow multiple security domains" onchange="zenPage.doModified();"/>
<radioSet id="SSLSuperServer" label="Superserver SSL/TLS support" valueList="0,1,2" displayList="Disabled,Enabled,Required" layout="vertical" onchange="zenPage.SSLChanged(zenThis.getValue());"/>
<select id="DefaultSignatureHash" label="Default signature hash" showEmpty="false" onchange="zenPage.doModified();"/>
</group>
<group id="SSLwarning" cellStyle="padding:4px;" hidden="true">
<label label="Warning: You must define an SSL/TLS server configuration named '%SuperServer' before you can configure the superserver to use SSL/TLS." labelClass="rednote"/>
</group>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	//this.invokeSuper('onloadHandler',arguments);
	// override super because we need to be able to save if users isn't managed
	if (this.IsEMSReadOnly && this.UsersIsReadOnly) {
		this.disableCommandButton('btnSave');
		this.disableCommandButton('btnNew');
	}
	this.resetMsg();
}

ClientMethod SSLChanged(newvalue) [ Language = javascript ]
{
	this.doModified();
	if (newvalue > 0) {
		if (this.CheckSuper() != 1) {
			zen('SSLwarning').setHidden(false);
			return;
		} 
	}
	zen('SSLwarning').setHidden(true);
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('InactiveLimit'),pass,"N",true,0,365)) pass = false;
		if (!this.validateRequired(zen('InvalidLoginLimit'),pass,"N",true,0,64)) pass = false;
		if (!this.validateRequired(zen('PasswordExpirationDays'),pass,"N",true,0,99999)) pass = false;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

/// Save current item.
ClientMethod doSave() [ Language = javascript ]
{
	try {
		this.resetMsg();
		
		var proxy = new zenProxy();
		
		if (!this.UsersIsReadOnly) {
			if (!this.validate()) {
				this.afterValidate();
				return;
			}
			
			proxy.DefaultSecurityDomain = zen('DefaultSecurityDomain').getValue();
			proxy.DefaultSignatureHash = zen('DefaultSignatureHash').getValue();
			proxy.InactiveLimit = zen('InactiveLimit').getValue();
			proxy.InvalidLoginLimit = zen('InvalidLoginLimit').getValue();
			proxy.InvalidLoginAction = zen('InvalidLoginAction').getValue();
			proxy.PasswordExpirationDays = zen('PasswordExpirationDays').getValue();
			proxy.PasswordPattern = zen('PasswordPattern').getValue();
			proxy.PasswordValidationRoutine = zen('PasswordValidationRoutine').getValue();
			proxy.SecurityDomains = zen('SecurityDomains').getValue();
		}
		proxy.AuditEnabled = zen('AuditEnabled').getValue();
		proxy.ConfigurationSecurityEnabled = zen('ConfigurationSecurityEnabled').getValue();
		proxy.RequiredRole = zen('RequiredRole').getValue();
		proxy.PercentGlobalWrite = zen('PercentGlobalWrite').getValue();
		proxy.SSLSuperServer = zen('SSLSuperServer').getValue();
		proxy.UsersIsReadOnly = this.UsersIsReadOnly;
		
		var result = this.SaveData(proxy);
		this.afterSave(result);
	} catch (ex) {
		alert("Error doSave: " + ex);
	}
}

ClassMethod CheckSuper() As %Boolean [ ZenMethod ]
{
	Quit ##class(Security.SSLConfigs).Exists("%SuperServer")
}

ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		If 'pProxy.UsersIsReadOnly {
			Set Properties("DefaultSecurityDomain") = pProxy.DefaultSecurityDomain
			Set Properties("DefaultSignatureHash") = pProxy.DefaultSignatureHash
			Set Properties("InactiveLimit") = pProxy.InactiveLimit
			Set Properties("InvalidLoginLimit") = pProxy.InvalidLoginLimit
			Set Properties("InvalidLoginAction") = pProxy.InvalidLoginAction
			Set Properties("PasswordExpirationDays") = pProxy.PasswordExpirationDays
			Set Properties("PasswordPattern") = pProxy.PasswordPattern
			Set Properties("PasswordValidationRoutine") = pProxy.PasswordValidationRoutine
			Set Properties("SecurityDomains") = pProxy.SecurityDomains
		}
		Set Properties("AuditEnabled") = pProxy.AuditEnabled
		Set Properties("ConfigurationSecurityEnabled") = pProxy.ConfigurationSecurityEnabled
		Set Properties("RequiredRole") = pProxy.RequiredRole
		Set Properties("PercentGlobalWrite") = pProxy.PercentGlobalWrite
		Set Properties("SSLSuperServer") = pProxy.SSLSuperServer
		
		Set tSC = ##Class(Security.System).Modify($$$SystemSecurityName,.Properties)
		If $$$ISERR(tSC) {
			throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
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
	
	Set ..lblTitle = $$$Text("Edit System-wide Security Parameters:")
	
	Set ..UsersIsReadOnly = ##class(%SYS.EMS).IsReadOnly("%CSP.UI.Portal.LDAP")
	
	Set tSC = ..PopulateDomainList()
	If $$$ISERR(tSC) {
		Set ..%GetComponentById("idRespond").value = ..EvalResult(tSC)
		Quit $$$OK
	}
		
	Set tSC = ##Class(Security.System).Get($$$SystemSecurityName,.Properties)
	If $$$ISERR(tSC) {
		Set ..%GetComponentById("idRespond").value = ..EvalResult(tSC)
		Quit $$$OK
	}
	Set tProperty = ""
	Set tProperty = $O(Properties(tProperty)) 
	While tProperty '= ""  {
		Set Component = ..%GetComponentById(tProperty)
		If $ISO(Component) {
			Set Component.value = Properties(tProperty)
			If ..IsEMSReadOnly {
				// if security is managed
				If ..UsersIsReadOnly || ((","_..UsersFields_",")'[(","_tProperty_",")) {
					// if users is managed, disable everything. otherwise, just disable the security fields.
					Set Component.disabled = 1
				}
			}
		}
		Set tProperty = $O(Properties(tProperty)) 
	}
	
	If (Properties("SSLSuperServer") > 0) && (..CheckSuper() = 0) {
		Set ..%GetComponentById("SSLwarning").hidden = 0
	}
	
	Quit $$$OK
}

Method PopulateDomainList() As %Status
{
	Set (valueList,displayList) = ""
	Set tRS = ##class(%ResultSet).%New("Security.Domains:List")
	Do tRS.Execute("*")
	While tRS.Next() {
		If (valueList '= "") {
			Set valueList = valueList_","
			Set displayList = displayList_","
		}
		Set valueList = valueList_tRS.GetData(1)
		Set displayList = displayList_..EscapeHTML(tRS.GetData(1))
	}
	Set Component = ..%GetComponentById("DefaultSecurityDomain")
	Set Component.valueList = valueList
	Set Component.displayList = displayList
	
	Set Component = ..%GetComponentById("DefaultSignatureHash")
	Set Component.valueList = "SHA1,SHA256,SHA384,SHA512"
	Set Component.displayList = "SHA1,SHA256,SHA384,SHA512"
	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("System-wide Security Parameters")
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

}
