Class %CSP.UI.Portal.LDAP Extends %CSP.UI.Portal.Template [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "LDAP Options";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.LDAP.zen";

Parameter HELPADDRESS = "System Administration,Security,System Security,LDAP Options";

Parameter EMSSERVICE = "Users";

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property LDAPUserString1 As %String [ InitialExpression = {$$$TextHTML("LDAP username to use for searches")} ];

Property LDAPUserString2 As %String [ InitialExpression = {$$$TextHTML("LDAP DN user to use for searches")} ];

/// True if the Security service is managed
Property SecurityIsReadOnly As %Boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css">
/* override the image because this form is too tall */
.EditForm {
	background-image: url('');
}
a.radioSetCaption {
	vertical-align:baseline;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<group labelPosition="left">
<checkbox id="AutheLDAP" label="Allow LDAP authentication" onchange="zenPage.LDAPChanged(zenThis.getValue());"/>
</group>
<group id="LDAPGroup" labelPosition="left" cellStyle="padding:4px;">
<checkbox id="LDAPActiveDirectory" label="LDAP server is a Windows Active Directory server" onchange="zenPage.showDomain(zenThis.getValue());zenPage.doModified();"/>
<text id="LDAPDomainName" label="LDAP domain name" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPHostNames" label="LDAP host names" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPSearchUsername" label="#(%page.LDAPUserString2)#" size="50" onchange="zenPage.doModified();"/>
<radioSet id="PWOptions" label="LDAP username password" displayList="Enter new password,Clear password,Leave as is" valueList="2,1,0" value="0" onchange="zenPage.togglePW(zenThis.getValue());zenPage.doModified();"/>
<text inputtype="password" id="LDAPSearchPassword" label="Password" onchange="zenPage.doModified();" hidden="true"/>
<text inputtype="password" id="LDAPSearchPasswordVer" label="Confirm Password" onchange="zenPage.doModified();" hidden="true"/>
<text id="LDAPBaseDN" label="LDAP Base DN to use for searches" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPUniqueDNIdentifier" label="LDAP Unique search attribute" size="50" onchange="zenPage.doModified();"/>
<checkbox id="LDAPTLSConnection" label="Use TLS/SSL encryption for LDAP sessions" onchange="zenPage.doModified();"/>
<checkbox id="LDAPUseGroups" label="Use LDAP Groups for Roles/Routine/Namespace" onchange="zenPage.changedGroupSetting(zenThis.getValue());zenPage.doModified();"/>
<checkbox id="LDAPUseNestedGroups" label="Search nested Groups for Roles/Routine/Namespace" onchange="zenPage.doModified();"/>
<hgroup id="CertFileGroup" label="TLS/SSL certificate file">
<text id="LDAPCACertFile" size="50" onchange="zenPage.doModified();"/>
<spacer width="5px"/>
<button caption="Browse..." onclick="zenPage.doBrowse('LDAPCACertFile');"/>
</hgroup>
<text id="LDAPAttributeComment" label="User attribute to retrieve comment attribute" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPAttributeFullName" label="User attribute to retrieve full name from" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPAttributeNameSpace" label="User attribute to retrieve default namespace" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPAttributeRoutine" label="User attribute to retrieve default routine" size="50" onchange="zenPage.doModified();"/>
<text id="LDAPAttributeRoles" label="User attribute to retrieve roles" size="50" onchange="zenPage.doModified();"/>
<textarea id="Attributes" label="LDAP attributes to retrieve for each user" cols="50" rows="5" onchange="zenPage.doModified();"/>
</group>
</group>
</form>
</pane>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.resetMsg();
	this.showDomain(zen('LDAPActiveDirectory').getValue());
	zen('PWOptions').setValue(0);
	this.togglePW(0);
	if (!this.IsEMSReadOnly) {
		this.changedGroupSetting(zen('LDAPUseGroups').getValue());
	}
}

/// Returning from file select OR qualifers dialog and setting the value into the appropriate field.
/// The id of the field that needs to be updated is saved in "dialogClicked".
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action == "ok") {
		zen(popupName).setValue(value);		
		zenPage.doModified();
	}
}

/// Launching a file selector window. 
ClientMethod doBrowse(fieldID) [ Language = javascript ]
{
	var Dir = zen(fieldID).getValue();
	var wildcard = "*";
	var url = zenLink("%ZEN.Dialog.fileSelect.zen?Dir=" + cspEncodeUTF8(Dir) + "&wildcard=" + wildcard);
	zenLaunchPopupWindow(url,fieldID,'status,scrollbars,resizable,width=600,height=700');
}

ClientMethod LDAPChanged(newvalue) [ Language = javascript ]
{
	this.doModified();
	zen('LDAPGroup').setHidden(!newvalue);
}

ClientMethod changedGroupSetting(newValue) [ Language = javascript ]
{
	if (newValue) {
		if (zen('LDAPActiveDirectory').getValue() == 1)	zen('LDAPUseNestedGroups').setDisabled(false);
		zen('LDAPAttributeNameSpace').setDisabled(true);
		zen('LDAPAttributeRoutine').setDisabled(true);
		zen('LDAPAttributeRoles').setDisabled(true);
	} else {
		zen('LDAPUseNestedGroups').setValue(0);
		zen('LDAPUseNestedGroups').setDisabled(true);
		zen('LDAPAttributeNameSpace').setDisabled(false);
		zen('LDAPAttributeRoutine').setDisabled(false);
		zen('LDAPAttributeRoles').setDisabled(false);
	}
}

ClientMethod showDomain(newvalue) [ Language = javascript ]
{
	var result = this.IsWindows();
	if (result.iswindows == 1) {
		if (newvalue) {
			zen('LDAPDomainName').setHidden(0);
		} else {
			zen('LDAPDomainName').setHidden(1);
		}
	} else {
		zen('LDAPDomainName').setHidden(1);
	}
	if (newvalue) {
		zen('LDAPUseNestedGroups').setDisabled(false);
		zen('LDAPSearchUsername').setProperty('label',this.LDAPUserString1);
	} else {
		zen('LDAPUseNestedGroups').setValue(0);
		zen('LDAPUseNestedGroups').setDisabled(true);
		zen('LDAPSearchUsername').setProperty('label',this.LDAPUserString2);
	}
}

/// User changed PWOptions option. If they want to enter new password, show password fields. Otherwise hide them. 
ClientMethod togglePW(PWOptions) [ Language = javascript ]
{
	if (PWOptions == 2) {
		zen("LDAPSearchPassword").setHidden(false);
		zen("LDAPSearchPasswordVer").setHidden(false);
	} else {
		zen("LDAPSearchPassword").setHidden(true);
		zen("LDAPSearchPasswordVer").setHidden(true);
	}
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (zen('PWOptions').getValue() == 2) {
			var verElem = zen('LDAPSearchPasswordVer');
			if (zen('LDAPSearchPassword').getValue() != verElem.getValue()) {
				verElem.setProperty("hintClass","redText");
				verElem.setProperty("controlClass","zenInvalid");
				if (pass) {
					this.FirstFailed = 'LDAPSearchPasswordVer';
				}
				pass = false;
			} else {
				verElem.setProperty("hintClass","helpText");
				verElem.setProperty("controlClass","");
			}
		}
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
		
		if (!this.validate()) {
			this.afterValidate();
			return;
		}
		
		var proxy = new zenProxy();
		
		proxy.AutheLDAP = zen('AutheLDAP').getValue();
		proxy.LDAPActiveDirectory = zen('LDAPActiveDirectory').getValue();
		proxy.LDAPDomainName = zen('LDAPDomainName').getValue();
		proxy.LDAPHostNames = zen('LDAPHostNames').getValue();
		proxy.LDAPSearchUsername = zen('LDAPSearchUsername').getValue();
		proxy.PWOptions = zen('PWOptions').getValue();
		proxy.LDAPSearchPassword = zen('LDAPSearchPassword').getValue();
		proxy.LDAPSearchPasswordVer = zen('LDAPSearchPasswordVer').getValue();
		proxy.LDAPBaseDN = zen('LDAPBaseDN').getValue();
		proxy.LDAPUniqueDNIdentifier = zen('LDAPUniqueDNIdentifier').getValue();
		proxy.LDAPTLSConnection = zen('LDAPTLSConnection').getValue();
		proxy.LDAPUseGroups = zen('LDAPUseGroups').getValue();
		proxy.LDAPUseNestedGroups = zen('LDAPUseNestedGroups').getValue();
		proxy.LDAPCACertFile = zen('LDAPCACertFile').getValue();
		proxy.LDAPAttributeComment = zen('LDAPAttributeComment').getValue();
		proxy.LDAPAttributeFullName = zen('LDAPAttributeFullName').getValue();
		proxy.LDAPAttributeNameSpace = zen('LDAPAttributeNameSpace').getValue();
		proxy.LDAPAttributeRoutine = zen('LDAPAttributeRoutine').getValue();
		proxy.LDAPAttributeRoles = zen('LDAPAttributeRoles').getValue();
		proxy.Attributes = zen('Attributes').getValue();
		proxy.SecurityIsReadOnly = this.SecurityIsReadOnly;

		var result = this.SaveData(proxy);
		this.afterSave(result);
	} catch (ex) {
		alert("Error doSave: " + ex);
	}
}

ClassMethod IsWindows() As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	i $$$ISWINDOWS {
		s tProxy.iswindows=1
	} else {
		s tProxy.iswindows=0
	}
	q tProxy
}

ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		Set tSC = ##Class(Security.System).Get($$$SystemSecurityName,.Properties)
		If $$$ISERR(tSC) {
			throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
			
		// we can only enable/disable LDAP if we can modify the security service
		If 'pProxy.SecurityIsReadOnly {
			If pProxy.AutheLDAP {
				Set Properties("AutheEnabled") = $zb(+Properties("AutheEnabled"),$$$AutheLDAP,7)
			} Else {
				Set Properties("AutheEnabled") = $zb(+Properties("AutheEnabled"),$$$AutheLDAP,2)
			}
			Set tSC = ##Class(Security.System).Modify($$$SystemSecurityName,.Properties)
			If $$$ISERR(tSC) {
				throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			}
		}
		
		// LDAP settings can be changed if we can't modify the security service or if LDAP is enabled
		If pProxy.AutheLDAP || pProxy.SecurityIsReadOnly {
			Set LDAPFlags = Properties("LDAPFlags")
			If pProxy.LDAPActiveDirectory {
				Set LDAPFlags = $zb(+LDAPFlags,$$$LDAPActiveDirectory,7)
			} Else {
				Set LDAPFlags = $zb(+LDAPFlags,$$$LDAPActiveDirectory,2)
			}
			If $$$ISWINDOWS && pProxy.LDAPActiveDirectory Set Properties("LDAPDomainName") = pProxy.LDAPDomainName
			Set LDAPFlags = $zb(+LDAPFlags,$$$LDAPTLSConnection,$S(pProxy.LDAPTLSConnection:7,1:2))
			Set LDAPFlags = $zb(+LDAPFlags,$$$LDAPUseGroups,$S(pProxy.LDAPUseGroups:7,1:2))
			Set LDAPFlags = $zb(+LDAPFlags,$$$LDAPUseNestedGroups,$S(pProxy.LDAPUseNestedGroups:7,1:2))
			Set Properties("LDAPFlags") = LDAPFlags
			
			Set Properties("LDAPHostNames") = pProxy.LDAPHostNames
			Set Properties("LDAPSearchUsername") = pProxy.LDAPSearchUsername
			
			If pProxy.PWOptions = 2 {
				Set Properties("LDAPSearchPassword") = pProxy.LDAPSearchPassword
			} ElseIf pProxy.PWOptions = 1 {
				Set Properties("LDAPSearchPassword") = ""
			}
			
			Set Properties("LDAPBaseDN") = pProxy.LDAPBaseDN
			Set Properties("LDAPUniqueDNIdentifier") = pProxy.LDAPUniqueDNIdentifier
			If '$$$ISWINDOWS {
				Set Properties("LDAPCACertFile") = pProxy.LDAPCACertFile
			}
			Set Properties("LDAPAttributeComment") = pProxy.LDAPAttributeComment
			Set Properties("LDAPAttributeFullName") = pProxy.LDAPAttributeFullName
			Set Properties("LDAPAttributeNameSpace") = pProxy.LDAPAttributeNameSpace
			Set Properties("LDAPAttributeRoutine") = pProxy.LDAPAttributeRoutine
			Set Properties("LDAPAttributeRoles") = pProxy.LDAPAttributeRoles

			// build into array so there are no duplicates
			// note that the line breaks are now $c(10)
			For i = 1:1:$L(pProxy.Attributes,$c(10)) {
				Set tA = $P(pProxy.Attributes,$c(10),i)
				If tA '= "" Set A(tA)=""
			}
			Kill Properties("LDAPAttributes")
			Set Properties("LDAPAttributes") = ""
			Set attribute = $ORDER(A(""))
			While (attribute '= "") {
				Set Properties("LDAPAttributes",attribute) = ""
				Set attribute = $ORDER(A(attribute))
			}
			
			Set tSC = ##Class(Security.System).Modify($$$SystemSecurityName,.Properties)
			If $$$ISERR(tSC) {
				throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			}
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
	
	Set ..lblTitle = $$$Text("Edit Security LDAP Options:")
	
	Set tSC = ##Class(Security.System).Get($$$SystemSecurityName,.Properties)
	If $$$ISERR(tSC) {
		Set ..%GetComponentById("idRespond").value = ..EvalResult(tSC)
		Quit $$$OK
	}
	
	Set Properties("LDAPSearchPasswordVer") = Properties("LDAPSearchPassword")
	Set Properties("LDAPActiveDirectory") = $zb(+Properties("LDAPFlags"),$$$LDAPActiveDirectory,1) > 0
	Set Properties("LDAPTLSConnection") = $zb(+Properties("LDAPFlags"),$$$LDAPTLSConnection,1) > 0
	Set Properties("LDAPUseGroups") = $zb(+Properties("LDAPFlags"),$$$LDAPUseGroups,1) > 0
	Set Properties("LDAPUseNestedGroups") = $zb(+Properties("LDAPFlags"),$$$LDAPUseNestedGroups,1) > 0
	
	Set Attributes = ""
	Set attribute = $ORDER(Properties("LDAPAttributes",""))
	While (attribute '= "") {
		If (Attributes '= "") Set Attributes = Attributes_$c(13,10)
		Set Attributes = Attributes_attribute
		Set attribute = $ORDER(Properties("LDAPAttributes",attribute))
	}
 	Set Properties("Attributes") = Attributes
	
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
	
	If ..IsEMSReadOnly {
		Set ..%GetComponentById("PWOptions").disabled = 1
		Set ..%GetComponentById("LDAPSearchPasswordVer").disabled = 1
	}
	
	Set ..SecurityIsReadOnly = ##class(%SYS.EMS).IsReadOnly("%CSP.UI.Portal.Parameters")
	
	Set AutheLDAP = $zb(+Properties("AutheEnabled"),$$$AutheLDAP,1) > 0
	Set ..%GetComponentById("AutheLDAP").value = AutheLDAP
	
	If ..SecurityIsReadOnly {
		Set ..%GetComponentById("AutheLDAP").disabled = 1
		Set ..%GetComponentById("AutheLDAP").hint = $$$Text("LDAP may be enabled or disabled through the Enterprise Manager Security service.")
	} Else {
 	 	Set ..%GetComponentById("LDAPGroup").hidden = 'AutheLDAP
	}
	
 	If $$$ISWINDOWS {
	 	Set ..%GetComponentById("CertFileGroup").hidden = 1
	 	Set ..%GetComponentById("CertFileGroup").containerStyle = "padding:0;"
 	} Else {
	 	;Set ..%GetComponentById("LDAPActiveDirectory").hidden = 1
	 	;Set ..%GetComponentById("LDAPActiveDirectory").containerStyle = "padding:0;"
	 	Set ..%GetComponentById("LDAPDomainName").hidden = 1
	 	Set ..%GetComponentById("LDAPDomainName").containerStyle = "padding:0;"
 	}
 	
	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("LDAP Options")
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
