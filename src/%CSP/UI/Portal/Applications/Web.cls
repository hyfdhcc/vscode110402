/// System Management Portal - System Administration - Edit Web Application
Class %CSP.UI.Portal.Applications.Web Extends %CSP.UI.Portal.Applications.EditTemplate [ System = 4 ]
{

///  Displayed name of this page.
Parameter PAGENAME = "Edit Web Application";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.Applications.Web.zen";

Parameter HELPADDRESS = "System Administration,Security,Applications,Web Applications";

Parameter EMSSERVICE = "Security";

Parameter PARENTPAGE = "/csp/sys/sec/%CSP.UI.Portal.Applications.WebList.zen";

Property ApplicationType As %Integer [ InitialExpression = {$$$AppTypeCSP} ];

Property IsSysApp As %Boolean [ InitialExpression = 0 ];

Property OldDefaultApp As %String;

Property UserChangedPath As %Boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css">
.checkboxCaption {
	color:#404040;
	font-size:12px;	    
}
.fieldHint {
    color:gray;
    font-size:12px;
    padding-left:5px;
}
/* override the image because this form is too tall */
.EditForm {
	background-image: url('');
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<label id="Text1" containerStyle="padding-bottom:4px;"/>
<label id="errmsg" hidden="true" enclosingClass="ErrorBox"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<link id="newLink" href="%25CSP.UI.Portal.Applications.Web.zen?PID=" caption="Click here to create a new web application." hidden="true" containerStyle="padding-bottom:4px;"/>

<svgFrame id="svgTabArea" height="32" layout="none" backgroundStyle="fill:white;stroke-width:2;" frameStyle="border:none;">
<tabBar id="tabBar" tabCaptions=":General:Application Roles:Matching Roles"
 onChange="zenPage.tabChanged(index);"/>
</svgFrame>

<!-- Page 1: Application Edit -->
<vgroup id="page_1" hidden="false" enclosingStyle="padding-left:10px;padding-top:5px;" labelPosition="left">
<form id="fld">
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">

<!-- General settings -->
<text id="Name" label="Name" size="40" onchange="zenPage.updateCookiePath(zenThis.getValue());zenPage.doModified();" hint="Required. (e.g. /csp/appname)" title="Enter an application name using URL syntax, e.g. /csp/appname"/>
<select id="CopyApp"
label="Copy from"
onchange="zenPage.doCopyApp(zenThis.getValue());zenPage.doModified();"
title="Choose an existing application to copy"
/>
<text id="Description" label="Description" size="80" onchange="zenPage.doModified();"/>

<!-- Namespace settings -->
<hgroup id="NamespaceGroup" label="Namespace" labelPosition="left" cellStyle="padding:4px;">
<select id="NameSpace" showEmpty="false" onchange="zenPage.updateDefaultApp(zenThis.getValue());zenPage.doModified();"/>
<spacer width="5px"/>
<label id="idDefaultAppLabel" controlClass="normal" controlStyle="margin-left:5px;"/>
<spacer width="5px"/>
<checkbox id="IsNameSpaceDefault" caption="Namespace Default Application" title="Controls whether an application is its namespace's default application" onchange="zenPage.doModified();"/>
</hgroup>

<!-- Enabled services -->
<hgroup label="Enabled" cellStyle="padding-right:4px;">
<hgroup>
<checkbox id="Enabled" caption="Application" title="Controls whether an application is available" value="1" onchange="zenPage.doModified();" valign="top"/>
<vgroup valign="top">
<checkbox id="CSPZENEnabled" caption="CSP/ZEN" title="Controls whether an application will process CSP/Zen Pages" value="1" onchange="zenPage.setSubEnablers();zenPage.doModified();"/>
<hgroup>
<checkbox id="DeepSeeEnabled" caption="DeepSee" title="Controls whether DeepSee is enabled." value="0" onchange="zenPage.doModified();"/>
<checkbox id="iKnowEnabled" caption="iKnow" title="Controls whether iKnow is enabled." value="0" onchange="zenPage.doModified();"/>
<checkbox id="CSRFToken" caption="Prevent login CSRF attack" title="Generate a token and cookie in the login page that is validated before accepting any username/password." value="0" onchange="zenPage.doModified();"/>
</hgroup>
</vgroup>
<checkbox id="InbndWebServicesEnabled" caption="Inbound Web Services" title="Controls whether an application will process web services" value="1" onchange="zenPage.doModified();" valign="top"/>
</hgroup>
</hgroup>
<text id="PermittedClasses" label="Permitted Classes" size="130" onchange="zenPage.doModified();"/>

<!-- Security -->
<fieldSet label="Security Settings" labelPosition="left" cellStyle="padding:4px;">
<hgroup label="Resource Required" labelPosition="left">
<select id="Resource"
title="Specifies a resource for which users must have the Use permission (enabled as part of a privilege in a role) in order to run the application."
onchange="zenPage.doModified();"
/>
<spacer width="9px"/>
<text id="GroupById" label="Group By ID" title="A group of applications linked by this ID share authentication." size="40" onchange="zenPage.doModified();" controlStyle="margin-left:4px;"/>
</hgroup>
<hgroup id="AuthGroup" label="Allowed Authentication Methods" title="Specifies the available authentication mechanisms for connecting to the application" cellStyle="padding-right:4px;"/>
</fieldSet>

<!-- Session settings -->
<fieldSet label="Session Settings" labelPosition="left" cellStyle="padding:4px;">
<hgroup label="Session Timeout" labelPosition="left">
<text id="Timeout" title="The default session timeout in seconds" size="10" value="900" onchange="zenPage.doModified();"/>
<label label="seconds" labelClass="fieldHint"/>
<spacer width="9px"/>
<text id="EventClass" label="Event Class" title="Specifies the default name of the CSP class (a subclass of %CSP.SessionEvents) whose methods are invoked for web application events, such as a timeout or session termination." size="40" onchange="zenPage.doModified();" controlStyle="margin-left:4px;"/>
</hgroup>
<hgroup id="CookieGroup" label="Use Cookie for Session" labelPosition="left">
<select id="UseCookies"
title="Whether you want CSP to track which session a browser is in by using cookies or a URL-rewriting technique (placing a value in each URL)."
valueList="0,1,2"
displayList="Never,Autodetect,Always"
showEmpty="false"
value="2"
 onchange="zenPage.doModified();"/>
 <spacer width="9px"/>
<select id="CookiePath" label="Session Cookie Path" title="Scope of the session cookie." showEmpty="false" onchange="zenPage.doModified();" controlStyle="margin-left:4px;"/>
</hgroup>
</fieldSet>

<!-- Dispatch class -->
<text id="DispatchClass" label="Dispatch Class" title="If defined this will dispatch all requests in this CSP application to this one class." size="40" onkeyup="zenPage.dispatchClassModified(zenThis.getValue());" onchange="zenPage.doModified();"/>

<!-- CSP file settings -->
<fieldSet label="CSP File Settings" labelPosition="left" cellStyle="padding:4px;">
<hgroup id="ServeFilesGroup" label="Serve Files" labelPosition="left">
<select id="ServeFiles" 
title="A path from which the CSP stream server is allowed to serve files."
valueList="0,1,2,3"
displayList="No,Always,Always and cached,Use CSP security"
showEmpty="false"
value="1"
 onchange="zenPage.doModified();"/>
<spacer width="9px"/>
<text id="ServeFilesTimeout" label="Serve Files Timeout" size="6" value="3600" onchange="zenPage.doModified();" controlStyle="margin-left:4px;"/>
<label label="seconds" labelClass="fieldHint"/>
</hgroup>
<hgroup id="PathGroup" label="CSP Files Physical Path">
<text id="Path" size="65" title="The directory on the server in which CSP source files are stored. The path is relative to the install-dir/csp/ directory on the server system." onchange="zenPage.pathChanged(zenThis.getValue());zenPage.doModified();"/>
<button id="PathBrowseBtn" caption="Browse..." onclick="zenPage.doBrowse('Path','*',1);"/>
</hgroup>
<hgroup id="PackageGroup" label="Package Name" labelPosition="left">
<text id="Package" title="The name of an optional package prefix used by the CSP compiler. This name is prepended to the package names used for classes created from CSP files. If this field is not specified, the default value of csp is used." size="40" onchange="zenPage.doModified();"/>
<spacer width="9px"/>
<text id="SuperClass" label="Default Superclass" title="The name of the default superclass used by the CSP compiler for classes created from CSP files. The default is %CSP.Page." size="40" onchange="zenPage.doModified();" controlStyle="margin-left:4px;"/>
</hgroup>
<hgroup id="CSPSettingsGroup" labelPosition="left" label="CSP Settings" cellStyle="padding:4px;">
<checkbox id="Recurse" caption="Recurse" title="Specifies whether to include subdirectories within this application." value="1" onchange="zenPage.doModified();"/>
<checkbox id="AutoCompile" caption="Auto Compile" title="Specifies whether the CSP server should automatically compile CSP source files or not." value="1" onchange="zenPage.doModified();"/>
<checkbox id="LockCSPName" caption="Lock CSP Name" title="If true, then if two web applications both point to the same namespace and package, then you can only get to the CSP page via the application which it was first loaded from." value="1" onchange="zenPage.doModified();"/>
</hgroup>
</fieldSet>

<!-- Page settings -->
<fieldSet label="Custom Pages" labelPosition="left" cellStyle="padding-right:4px;">
<hgroup id="PageGroup" labelPosition="left" label="Login Page">
<text id="LoginPage" title="Name of a custom login page to display. This can be any of the forms: /csp/user/application/mylogin.cps, mylogin.csp, /cspuser/application/mylogin.cls, application.mylogin.cls. The CSPSystem user must be in the role %DB_User or %All." size="40" onchange="zenPage.doModified();"/>
<spacer width="9px"/>
<text id="ChangePasswordPage" label="Change Password Page" title="Name of page to use when changing password." size="40" onchange="zenPage.doModified();" controlStyle="margin-left:4px;"/>
</hgroup>
<text id="ErrorPage" label="Custom Error Page" title="The name of a .csp or .cls page that is displayed if an error occurs when generating a page within this application." size="40" onchange="zenPage.doModified();"/>
</fieldSet>

<!-- hidden field holds MatchRoles if creating a new app copied from an existing one -->
<hidden id="MatchRoles"/>

</group>
</form>
</vgroup>

<!-- Page 2: Application Roles -->
<vgroup id="page_2" hidden="true" enclosingStyle="padding-left:10px;padding-top:20px;" labelPosition="left">
<ApplicationRoles id="AppRoleComponent" type="ApplicationRole" PID="#(%page.PID)#" readOnly="#(%page.IsEMSReadOnly)#"/>
</vgroup>

<!-- Page 3: Match Roles -->
<vgroup id="page_3" hidden="true" enclosingStyle="padding-left:10px;padding-top:20px;" labelPosition="left">
<ApplicationRoles id="MatchRoleComponent" type="MatchRole" PID="#(%page.PID)#" readOnly="#(%page.IsEMSReadOnly)#"/>
</vgroup>

</pane>
}

/// Set focus to the Name or Description field, disable fields if DispatchClass is defined.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if (!this.IsSysApp) {
		zen("Name").focus();
	} else {
		zen("Description").focus();
	}
	var dispatchClass = zen('DispatchClass').getValue();
	if (dispatchClass != "") {
		this.dispatchClassModified(dispatchClass);
	}
	if (this.IsNewSave != 0) {
		this.showMsg($$$Text('Application saved.'),false);
		if (this.IsNewSave == 1) {
			var newLink = zen('newLink');
			newLink.setHidden(false);
		}
		return;
	}
	var hash = parseInt(document.location.hash.slice(1));
	if ((typeof(hash) === 'number') && (hash >= 0) && (hash <= this.NumTabs)) {
		zen('tabBar').tabClicked(hash);
	}
	
	this.setSubEnablers();
	
	this.resetMsg();
}

ClientMethod doCopyApp(newApp) [ Language = javascript ]
{
	zenPage.CopyApp(newApp);
}

ClientMethod setSubEnablers() [ Language = javascript ]
{
	if (zen('CSPZENEnabled').value == 1) {
		zen('DeepSeeEnabled').setProperty('disabled', false);
		zen('iKnowEnabled').setProperty('disabled', false);
		zen('CSRFToken').setProperty('disabled',false);
	} else {
		zen('DeepSeeEnabled').setProperty('disabled', true);
		zen('iKnowEnabled').setProperty('disabled', true);
		zen('CSRFToken').setProperty('disabled',true);
	}
}

/// Disable/enable the CSP setting fields if DispatchClass is defined/undefined.
ClientMethod dispatchClassModified(newClass) [ Language = javascript ]
{
	var fieldArray = ['ServeFiles','ServeFilesTimeout','Path','PathBrowseBtn','Recurse','AutoCompile','LockCSPName','Package','SuperClass','ErrorPage','LoginPage','ChangePasswordPage'];
	for (var n=0; n<fieldArray.length; n++) {
		var component = zen(fieldArray[n]);
		if (newClass == "") {
			component.setProperty('disabled',false);
		} else {
			component.setProperty('disabled',true);
		}
	}
	var groupArray = ['ServeFilesGroup','PathGroup','CSPSettingsGroup','PackageGroup','PageGroup'];
	for (var n=0; n<groupArray.length; n++) {
		var component = zen(groupArray[n]);
		var lbl = component.getLabelElement();
		if (lbl) {
			if (newClass == "") {
				lbl.className = (''==component.labelClass) ? 'zenLabel' : component.labelClass;
			} else  {
				lbl.className = (''==component.labelDisabledClass) ? 'zenLabelDisabled' : component.labelDisabledClass ;
			}
		}
	}
}

/// If the user enters a path, it will not be overwritten by then choosing a CopyFrom application
ClientMethod pathChanged(newPath) [ Language = javascript ]
{
	if (newPath == "") {
		this.UserChangedPath = false;
	} else if (!this.UserChangedPath) {
		this.UserChangedPath = true;
	}
}

/// When the app name changes, redraw the cookie path options
ClientMethod updateCookiePath(newName) [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	// add a trailing slash if necessary
	if ((newName.charAt(newName.length-1)) != "/") newName = newName + "/";
	zenPage.DrawCookiePath(newName);
	zen('CookiePath').setValue(newName);
	zenSynchronousMode = oldSynchronousMode;
}

ClientMethod updateDefaultApp(newNS) [ Language = javascript ]
{
	zenPage.DrawDefaultApp(newNS);
}

ClientMethod doSave() [ Language = javascript ]
{
	if (this.isButtonDisabled("btnSave")) return;
	this.resetMsg();
	zen('newLink').setHidden(true);
	var proxy = new zenProxy();
	proxy.PID = this.PID;
	proxy.Name = zen('Name').getValue();
	proxy.NameSpace = zen('NameSpace').getValue();
	proxy.IsNameSpaceDefault = zen('IsNameSpaceDefault').getValue();
	proxy.OldDefaultApp = this.OldDefaultApp;

	var ok = this.validate(proxy);
	if (!ok) return;
	
	var authArray = ['AutheUnauthenticated','AutheCache','AutheK5API','AutheDelegated','AutheLDAP','AutheLDAPCache','AutheLoginToken','AutheTwoFactorSMS','AutheTwoFactorPW'];
	for (var n=0; n<authArray.length; n++) {
		var component = zen(authArray[n]);
		if (typeof component !== "undefined") {
			proxy[authArray[n]] = component.getValue();
		}
	}

	proxy.AutoCompile = zen('AutoCompile').getValue();
	proxy.ChangePasswordPage = zen('ChangePasswordPage').getValue();
	proxy.CookiePath = zen('CookiePath').getValue();
	if (proxy.CookiePath == "") proxy.CookiePath = proxy.Name;
	proxy.CSPZENEnabled = zen('CSPZENEnabled').getValue();
	proxy.CSRFToken = zen('CSRFToken').getValue();
	proxy.DeepSeeEnabled = zen('DeepSeeEnabled').getValue();
	proxy.Description = zen('Description').getValue();
	proxy.DispatchClass = zen('DispatchClass').getValue();
	proxy.Enabled = zen('Enabled').getValue();
	proxy.ErrorPage = zen('ErrorPage').getValue();
	proxy.EventClass = zen('EventClass').getValue();
	proxy.GroupById = zen('GroupById').getValue();
	proxy.iKnowEnabled = zen('iKnowEnabled').getValue();
	proxy.LockCSPName = zen('LockCSPName').getValue();
	proxy.LoginPage = zen('LoginPage').getValue();
	proxy.Resource = zen('Resource').getValue();
	proxy.Package = zen('Package').getValue();
	proxy.Path = zen('Path').getValue();
	proxy.PermittedClasses = zen('PermittedClasses').getValue();
	proxy.Recurse = zen('Recurse').getValue();
	proxy.ServeFiles = zen('ServeFiles').getValue();
	proxy.ServeFilesTimeout = zen('ServeFilesTimeout').getValue();
	proxy.SuperClass = zen('SuperClass').getValue();
	proxy.Timeout = zen('Timeout').getValue();
	proxy.UseCookies = zen('UseCookies').getValue();
	proxy.InbndWebServicesEnabled = zen('InbndWebServicesEnabled').getValue();
	proxy.MatchRoles = zen('MatchRoles').getValue();
	proxy.ApplicationType = this.ApplicationType;
	
	var result = this.SaveData(proxy);
	if (result.ok != 1) {
		// error case
		this.showMsg(result.ErrorMessage,true);
		return;
	}
	this.setModified(false);
	if ((proxy.PID == '') || (proxy.PID != proxy.Name)) {
		if (proxy.PID == '') {
			// new app
			var isNew = 1;
		} else {
			// renamed app
			var isNew = 2;
		}
		var url = zenLink('%25CSP.UI.Portal.Applications.Web.zen?PID='+encodeURIComponent(proxy.Name)+'&new='+isNew);
		this.gotoPage(url);
		return;
	}
	// saved existing app
	this.DrawDefaultApp(proxy.NameSpace);
	this.showMsg($$$Text('Application saved.'),false);
}

ClientMethod validate(proxy) As %Boolean [ Language = javascript ]
{
	var pass = true;
	try {
		var oldSynchronousMode = zenSynchronousMode;
		zenSynchronousMode = true;
		if (!this.validateRequired(zen('Name'),pass,"S")) pass = false;
		if (!pass) {
			this.afterValidate();
			zenSynchronousMode = oldSynchronousMode;
			return pass;
		}
		zenSynchronousMode = oldSynchronousMode;
		
		if (proxy.Name.charAt(0) != "/") {
			zen('Name').focus();
			this.showMsg($$$Text("Please enter a valid Name using URL syntax."),1);
			return false;
		}
		
		if ((proxy.PID != '') && (proxy.PID != proxy.Name)) {
			// Check if new name matches namespace and give warning if not.
			var cspname = proxy.Name.split("/");
			var found = false;
			for (var n=1; n<cspname.length; n++) {
				if (cspname[n].toUpperCase() == proxy.NameSpace) {
					found = true;
					break;
				}
			}
			var msg = $$$Text("Are you sure you want to rename this web application?");
			if (!found) {
				msg = msg + "\n\n" + $$$Text("WARNING: You will no longer be able to run Ensemble or DeepSee in this namespace.");
			}
			if (!confirm(msg)) {
				return false;
			}
		}
		
		if ((proxy.IsNameSpaceDefault) && (proxy.OldDefaultApp != "") && (proxy.OldDefaultApp != proxy.Name)) {
			var msg = $$$Text("You are changing the default application for namespace %1 to %2. Are you sure you want to do this?");
			msg = msg.replace("%1",proxy.NameSpace);
			msg = msg.replace("%2",proxy.Name);
			msg = msg + "\n\n" + $$$Text("Click OK to continue or Cancel to abort the Save.");
			if (!confirm(msg)) {
				return false;
			}
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
	
	return pass;
}

ClientMethod enableLDAP(flag) [ Language = javascript ]
{
	var LDAPctrl = zen("AutheLDAPCache");
	if (typeof LDAPctrl === "undefined") return;
	if (flag) {
		LDAPctrl.setDisabled(false);
	} else {
		LDAPctrl.setDisabled(true);
		LDAPctrl.setValue(false);
	}
}

ClassMethod GetDefaultApp(Nsp As %String) As %String [ ZenMethod ]
{
	Set app = ""
	Set DefApp = $System.CSP.GetDefaultApp(Nsp)
	Set tSC = ##class(Security.Applications).Get(DefApp,.Properties)
	If $$$ISOK(tSC) && ($Get(Properties("IsNameSpaceDefault"),0) = 1) {
		Set app = DefApp
	}
	Quit app
}

Method DrawDefaultApp(Nsp As %String) [ ZenMethod ]
{
	Set appComp = ..%GetComponentById("idDefaultAppLabel")
	Set ..OldDefaultApp = ..GetDefaultApp(Nsp)
	If (..OldDefaultApp '= "") {
		Set appComp.label = $$$FormatText($$$Text("Default Application for %1"),Nsp)_":"
		Set appComp.value = ..OldDefaultApp
	} Else {
		Set appComp.label = ""
		Set appComp.value = ""
	}
}

Method DrawCookiePath(Name As %String) [ ZenMethod ]
{
	Set cpath = Name_$S($E(Name,$L(Name))'="/":"/",1:"")
	Set displayList = "/"
	Set valueList = "/"
	Set cp = 2
	Set thiscp = $P(cpath,"/",cp)
	Set lastcp = "/"
	While thiscp '= "" {
		Set lastcp = lastcp_thiscp_"/"
		Set displayList = displayList_","_..EscapeHTML(lastcp)
		Set valueList = valueList_","_lastcp
		Set cp = cp + 1
		Set thiscp = $P(cpath,"/",cp)
	}
	Set ..%GetComponentById("CookiePath").displayList = displayList
	Set ..%GetComponentById("CookiePath").valueList = valueList
}

Method CopyApp(AppName As %String) As %Status [ ZenMethod ]
{
	Set tSC = ##class(Security.Applications).Get(AppName,.Properties)
	If $$$ISERR(tSC) Quit tSC
	Set AutheArray = ..BuildAutheArray()
	Do ..PopulateFields(1,.Properties,AutheArray)
	Quit $$$OK
}

/// Call server save method.
ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		Set AutheEnabled = 0
		
		If (pProxy.AutheUnauthenticated) Set AutheEnabled = AutheEnabled + $$$AutheUnauthenticated
		If (pProxy.AutheCache) Set AutheEnabled = AutheEnabled + $$$AutheCache
		If (pProxy.AutheK5API) Set AutheEnabled = AutheEnabled + $$$AutheK5API
		If (pProxy.AutheDelegated) Set AutheEnabled = AutheEnabled + $$$AutheDelegated
		If (pProxy.AutheLDAP) Set AutheEnabled = AutheEnabled + $$$AutheLDAP
		If (pProxy.AutheLDAPCache) Set AutheEnabled = AutheEnabled + $$$AutheLDAPCache
		If (pProxy.AutheLoginToken) Set AutheEnabled = AutheEnabled + $$$AutheLoginToken
		If (pProxy.AutheTwoFactorPW) Set AutheEnabled = AutheEnabled + $$$AutheTwoFactorPW
		If (pProxy.AutheTwoFactorSMS) Set AutheEnabled = AutheEnabled + $$$AutheTwoFactorSMS

		Set Properties("AutheEnabled") = AutheEnabled
		Set Properties("AutoCompile") = pProxy.AutoCompile
		Set Properties("ChangePasswordPage") = pProxy.ChangePasswordPage
		Set Properties("CookiePath") = pProxy.CookiePath
		Set Properties("CSPZENEnabled") = pProxy.CSPZENEnabled
		Set Properties("CSRFToken") = pProxy.CSRFToken
		Set Properties("DeepSeeEnabled") = pProxy.DeepSeeEnabled
		Set Properties("Description") = pProxy.Description
		Set Properties("DispatchClass") = pProxy.DispatchClass
		Set Properties("Enabled") = pProxy.Enabled
		Set Properties("ErrorPage") = pProxy.ErrorPage
		Set Properties("EventClass") = pProxy.EventClass
		Set Properties("GroupById") = pProxy.GroupById
		Set Properties("iKnowEnabled") = pProxy.iKnowEnabled
		Set Properties("InbndWebServicesEnabled") = pProxy.InbndWebServicesEnabled
		Set Properties("IsNameSpaceDefault") = pProxy.IsNameSpaceDefault
		Set Properties("LockCSPName") = pProxy.LockCSPName
		Set Properties("LoginPage") = pProxy.LoginPage
		Set Properties("NameSpace") = pProxy.NameSpace
		Set Properties("Package") = pProxy.Package
		Set Properties("Path") = pProxy.Path
		Set Properties("PermittedClasses") = pProxy.PermittedClasses
		Set Properties("Recurse") = pProxy.Recurse
		Set Properties("Resource") = pProxy.Resource
		Set Properties("ServeFiles") = pProxy.ServeFiles
		Set Properties("ServeFilesTimeout") = pProxy.ServeFilesTimeout	
		Set Properties("SuperClass") = pProxy.SuperClass
		Set Properties("Timeout") = pProxy.Timeout
		Set Properties("UseCookies") = pProxy.UseCookies
		
		Set Properties("Type") = pProxy.ApplicationType
		
		If pProxy.PID = "" {
			Set Properties("MatchRoles") = pProxy.MatchRoles
			Set tSC = ##class(Security.Applications).Create(pProxy.Name,.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		} Else {
			//If this is a rename, create new one and delete old one
			If pProxy.PID '= pProxy.Name {
				Set tSC = ##class(Security.Applications).Create(pProxy.Name,.Properties)
				If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
				Set tSC = ##class(Security.Applications).Delete(pProxy.PID)
				If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			} Else {
				// Save the modification to application
				Kill Properties("Type")
				Set tSC = ##class(Security.Applications).Modify(pProxy.Name,.Properties)
				If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			}
		}

		/// If user is CHANGING the default application from another application to this one for the namespace,
		/// reset the other application's flag to zero.
		If ((pProxy.IsNameSpaceDefault = 1) && (pProxy.OldDefaultApp '= "") && (pProxy.OldDefaultApp '= pProxy.Name)) {
			Kill Properties
			Set Properties("IsNameSpaceDefault") = 0
			Set tSC = ##class(Security.Applications).Modify(pProxy.OldDefaultApp,.Properties)
			If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}

		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

/// Build a list of available authentication types
ClassMethod BuildAutheArray() As %ListOfDataTypes
{
	Set tSC = ##class(Security.System).Get($$$SystemSecurityName,.SysProperties)
	Set SysAutheEnabled = +SysProperties("AutheEnabled")
	
	Set AutheArray = ##class(%ListOfDataTypes).%New()
	If $zb(SysAutheEnabled,$$$AutheUnauthenticated,1) Do AutheArray.Insert("AutheUnauthenticated^"_$$$AutheUnauthenticated_"^"_$$$AutheUnauthenticatedStr)
	If $zb(SysAutheEnabled,$$$AutheCache,1) Do AutheArray.Insert("AutheCache^"_$$$AutheCache_"^"_$$$AutheCacheStr)
	If $zb(SysAutheEnabled,$$$AutheK5API,1) Do AutheArray.Insert("AutheK5API^"_$$$AutheK5API_"^"_$$$AutheK5APIStr)
    If $zb(SysAutheEnabled,$$$AutheDelegated,1) Do AutheArray.Insert("AutheDelegated^"_$$$AutheDelegated_"^"_$$$AutheDelegatedStr)
    If $zb(SysAutheEnabled,$$$AutheLDAP,1) Do AutheArray.Insert("AutheLDAP^"_$$$AutheLDAP_"^"_$$$AutheLDAPStr)
	If ($zb(SysAutheEnabled,$$$AutheLDAP,1) && $zb(SysAutheEnabled,$$$AutheLDAPCache,1)) Do AutheArray.Insert("AutheLDAPCache^"_$$$AutheLDAPCache_"^"_$$$AutheLDAPCacheStr)
    If $zb(SysAutheEnabled,$$$AutheTwoFactorPW,1) Do AutheArray.Insert("AutheTwoFactorPW^"_$$$AutheTwoFactorPW_"^"_$$$AutheTwoFactorPWStr)
    If $zb(SysAutheEnabled,$$$AutheTwoFactorSMS,1) Do AutheArray.Insert("AutheTwoFactorSMS^"_$$$AutheTwoFactorSMS_"^"_$$$AutheTwoFactorSMSStr)
	Do AutheArray.Insert("AutheLoginToken^"_$$$AutheLoginToken_"^"_$$$AutheLoginTokenStr)
	Quit AutheArray
}

/// Fill in form fields. Used when loading the page for edit or when choosing a copy from app during creation
Method PopulateFields(CopyApp As %Boolean, ByRef Properties As %String, AutheArray As %ListOfDataTypes) As %Status
{
	// If copying an existing application, don't try to make this one the NS default
	If (CopyApp) {
		Set Properties("IsNameSpaceDefault") = 0
	}
	
	// Loop to set all field values
	Set tProperty = ""
	Set tProperty = $O(Properties(tProperty)) 
	While tProperty '= ""  {
		Set Component = ..%GetComponentById(tProperty)
		If $ISO(Component) {
			If ('CopyApp || (tProperty '= "Path") || '..UserChangedPath) {
				Set Component.value = Properties(tProperty)
			}
			If ..IsEMSReadOnly Set Component.disabled = 1
		}
		Set tProperty = $O(Properties(tProperty)) 
	}
	
	Do ..DrawDefaultApp(Properties("NameSpace"))
	
	// Set values for the authentication options
	Set AutheLDAP = 0
	Set key = ""
	Do {
		Set Authe = AutheArray.GetNext(.key)
		If (Authe '= "") {
			Set comp = ..%GetComponentById($P(Authe,"^",1))
			Set b = +$P(Authe,"^",2)
			Set comp.value = ($zb(+Properties("AutheEnabled"),b,1) = b)
			
			If ((comp.id = "AutheLDAP") && (comp.value = 1)) {
				Set AutheLDAP = 1
			}
			If ((comp.id = "AutheLDAPCache") && (AutheLDAP '= 1)) {
				// enable AutheLDAPCache only if AutheLDAP is checked
				Set comp.disabled = 1
			}
	    }
	} While (key '= "")
	
	Quit $$$OK
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	// Populate the Resource dropdown
	Set tRS = ##class(%ResultSet).%New("Security.Resources:List")
	Do tRS.Execute(,,$$$ServiceResourceType+$$$ApplicationResourceType+$$$UserResourceType)
	Set valueList = ""
	While tRS.Next() {
		Set name = tRS.GetData(1)
		If valueList = "" {
			Set valueList = name
		} Else {
			Set valueList = valueList_","_name
		}
	}
	Set (..%GetComponentById("Resource").displayList,..%GetComponentById("Resource").valueList) = valueList
	Set ..%GetComponentById("PermittedClasses").title = $$$Text("Only permit classes matching this COS pattern to run in application, e.g. 1""myservice"" only permits ""myservice.cls""")

	// Populate the Namespace dropdown
	Set tType = 4   		// 4 - Returns array of all namespaces
	Set tRemote = 1 		// 1 - Return remote namespaces as well
	Set tDontConnect = 1	// 1 - Do not attempt to connect 
	Do List^%SYS.NAMESPACE(.Namespaces,tType,tRemote,tDontConnect)
	Set nms = $O(Namespaces(""))
	Set valueList = ""
  	While nms '= "" {
	  	If valueList = "" {
			Set valueList = nms
		} Else {
			Set valueList = valueList_","_nms
		}
	  	Set nms = $O(Namespaces(nms))
  	}
  	Set (..%GetComponentById("NameSpace").displayList,..%GetComponentById("NameSpace").valueList) = valueList
  	
  	// Draw the Authentication Options checkboxes
	Set AutheArray = ..BuildAutheArray()
	Set key = ""
	Do {
		Set Authe = AutheArray.GetNext(.key)
		If (Authe '= "") {
			Kill comp
			Set comp = ##class(%ZEN.Component.checkbox).%New()
			Set comp.id = $P(Authe,"^",1)
			Set comp.caption = $P(Authe,"^",3)
			Set comp.onchange = "zenPage.doModified();"
			If comp.id = "AutheLDAP" {
				set comp.onclick = "zenPage.enableLDAP(zenThis.getValue());"
			}
			If comp.id = "AutheLoginToken" {
				Set comp.title = $$$Text("When entering this application for the first time, CSP will attempt to use the authentication of the more recently logged in user.")
			}
			If ..IsEMSReadOnly {
				Set comp.disabled = 1
			}
			Do ..%GetComponentById("AuthGroup").%AddChild(comp)
	    }
	} While (key '= "")
	
	// Set up the Cookie Path select options
	Do ..DrawCookiePath(..PID)
	
	If ..PID = "" {
		// Creating new application
		Set ..%GetComponentById("Text1").value = $$$TextHTML("Use the following form to create a new web application:")
		Set ..%GetComponentById("svgTabArea").hidden = 1
		Set ..%GetComponentById("svgTabArea").height = 0
		
		Set ..%GetComponentById("NameSpace").value = "USER"
		
		Do ..DrawDefaultApp("USER")
		
		If $ISO(..%GetComponentById("AutheUnauthenticated")) {
			Set ..%GetComponentById("AutheUnauthenticated").value = 1
		}
		
		// Populate the Copy From dropdown
		Set tRS = ##class(%ResultSet).%New("Security.Applications:List")
		Do tRS.Execute("*",$$$AppTypeCSP,"")
		Set valueList = ""
		While tRS.Next() {
			Set name = tRS.GetData(1)
			If valueList = "" {
				Set valueList = name
			} Else {
				Set valueList = valueList_","_name
			}
		}
		Set (..%GetComponentById("CopyApp").displayList,..%GetComponentById("CopyApp").valueList) = valueList
		Set comp = ..%GetComponentById("AutheLDAPCache")
		If comp Set comp.disabled = 1
	} Else {
		// Editing existing application
		Set ..EditHeader = $$$FormatText($$$Text("Edit definition for web application %1:"),..PID)
		Set ..RolesHeader = $$$FormatText($$$Text("Edit roles for web application %1:"),..PID)
		Set ..%GetComponentById("Text1").value = ..EditHeader
		
		Kill Properties
		Set tSC = ##class(Security.Applications).Get(..PID,.Properties)
		If $$$ISERR(tSC) {
			Set ..%GetComponentById("fld").hidden = 1
			Set ..InvalidParam = 1
			Set ..%GetComponentById("svgTabArea").hidden = 1
			Set ..%GetComponentById("svgTabArea").height = 0
			Quit $$$OK
		}
		Set ..IsSysApp = ($ZB($$$AppTypeSystem,+Properties("Type"),1) = 1)
		Set ..%GetComponentById("Name").value = ..PID
		
		If (..IsSysApp) {
			Set ..%GetComponentById("Name").disabled = 1
			Set ..%GetComponentById("Name").hint = ""
		}
		
		Set ..%GetComponentById("CopyApp").hidden = 1
		Set ..%GetComponentById("CopyApp").containerStyle = "padding:0;"
		
		// Set the DeepSee, iKnow enabled checkboxes
		Set appName = ..PID _ "/"
		If $$IsDeepSeeEnabled^%SYS.cspServer(appName) {
			Set ..%GetComponentById("DeepSeeEnabled").value = 1
		} else {
			Set ..%GetComponentById("DeepSeeEnabled").value = 0
		}
		
		If $$IsIKnowEnabled^%SYS.cspServer(appName) {
			Set ..%GetComponentById("iKnowEnabled").value = 1
		} else {
			Set ..%GetComponentById("iKnowEnabled").value = 0
		}

		Do ..PopulateFields(0,.Properties,AutheArray)
	}

	If ..IsEMSReadOnly {
		Set ..%GetComponentById("Name").disabled = 1
		Set ..%GetComponentById("PathBrowseBtn").disabled = 1
	}

	Quit $$$OK
}

///  Return the array of links to show in the locator bar.<br/>
///  pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Security Management","%Utility")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Web Applications","%Utility")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen?PID="_..EscapeURL(..PID)_$S(NAMESPACE="":"",1:"&$NAMESPACE="_NAMESPACE))
	
	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Edit Web Application")
}

}
