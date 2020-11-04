/// <p>This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. 
/// There is no guarantee made about either the behavior or future operation of this class.</p>
/// Edit Service Popup Dialog for Management Portal
Class %CSP.UI.Portal.Mirror.Dialog.SSL Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

Parameter CSPURL = "/csp/sys/sec/%CSP.UI.Portal.Mirror.Dialog.SSL.zen";

/// Displayed name of this page.
Parameter PAGENAME = "SSL";

/// If true, then this dialog displays an Apply button.
Parameter APPLYBUTTON As BOOLEAN = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Secure";

Property isNew As %ZEN.Datatype.boolean(ZENURL = "isNew") [ InitialExpression = "0" ];

/// Indicate if password is modified. If pwModified is 0 then at save time we won't save password.
Property pwModified As %ZEN.Datatype.boolean [ InitialExpression = "0" ];

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title instructions */
div.Description	{
	font-size: 0.9em; 
	padding: 5px;
}
</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" width="100%" height="100%" 
	title="#(%page.dialogTitle)#">
<html id="header" OnDrawContent="%DrawTitle" />

<pane paneName="dialogBody" id="body" />

<hgroup id="footer" width="100%" cellAlign="right">
<hgroup id="buttonHolder" cellAlign="right">
<button id="btnCancel" controlClass="commandButton" caption="Cancel" onclick="zenPage.dialogCancel();" />
<spacer width="5" />
<button id="btnFinish" controlClass="commandButton" caption="Save" onclick="zenPage.dialogFinish();;"/>
</hgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:4 6 4 10;">
<spacer height="10"/>
<html OnDrawContent="DrawPageTitle" seed="#(%page.isNew)#"/>
<label id="idRespond" enclosingClass="note" containerStyle="padding-top:10px;padding-left:4px;" hidden="true"/>

<hgroup id="idButton" >
<hidden name="browseselect" id="browseselect"/>
<label id="result" controlClass="redText" value=""/>
</hgroup>

<group cellStyle="padding:5px;" enclosingClass="EditForm" enclosingStyle="margin-left:3px;padding-top:2px;" labelPosition="left">
<hgroup id="id_CAFile" labelPosition="left" label="File containing trusted Certificate Authority X.509 certificate" cellVAlign="top" >
<text id="CAFile" size="60" onkeyup="zenPage.changedCAFile();"/>
<button id="CAFileBrowse" caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect('CAFile','*.cer');"/>
</hgroup>
<hgroup id="id_CRLFile" labelPosition="left" label="File containing Certificate Revocation List" cellVAlign="top" >
<text id="CRLFile" size="60"/>
<button id="CRLFileBrowse" caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect('CRLFile','*.cer');"/>
</hgroup>
<fieldSet id="id_Type" label="This server's credentials" containerStyle="padding-left:4px;padding-right:4px;" labelPosition="top">
<hgroup id="id_File" labelPosition="left" label="File containing this configuration's X.509 certificate" cellVAlign="top" containerStyle="padding-top:4px;padding-bottom:4px;" >
<text id="CertificateFile" size="59"/>
<button caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect('CertificateFile','*.cer');"/>
</hgroup>
<hgroup id="id_Key" labelPosition="left" label="File containing associated private key" cellVAlign="top" cellStyle="padding-bottom:4px;" >
<text id="PrivateKeyFile" size="59"/>
<button caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect('PrivateKeyFile','*.key');"/>
</hgroup>
<vgroup labelPosition="left" showLabel="false">
<radioSet id="PrivateKeyType" label="Private key type" displayList="RSA,DSA" valueList="2,1" value="2"/>
<radioSet id="PWOptions" label="Password:" displayList="Enter new password,Clear password,Leave as is" valueList="2,1,0" value="0" onchange="zenPage.togglePW();"/>
<vgroup id="id_Password" showLabel="false" labelPosition="left" hidden="true">
<text inputtype="password" id="PrivateKeyPassword" label="Private key password" onchange="zenPage.changePW();" />
<text inputtype="password" id="PrivateKeyPassword1" label="Private key password (confirm)" onchange="zenPage.changePW();"/>
</vgroup>
</vgroup>
</fieldSet>
<fieldSet id="id_CipherList" label="Cryptographic settings" containerStyle="padding-left:4px;padding-right:4px;" labelPosition="left">
<hgroup id="id_Protocols" label="Protocols">
<checkbox id="Protocols1" caption="SSLv2" captionClass="normal"/>
<checkbox id="Protocols2" caption="SSLv3" captionClass="normal"/>
<checkbox id="Protocols4" caption="TLSv1.0" captionClass="normal" value="1"/>
<checkbox id="Protocols8" caption="TLSv1.1" captionClass="normal" value="1"/>
<checkbox id="Protocols16" caption="TLSv1.2" captionClass="normal" value="1"/>
</hgroup>
<text id="CipherList" label="Enabled ciphersuites" size="60"/>
</fieldSet>
</group>

</pane>
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	zen("CAFile").focus();
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
		if (this.validate()==false) return false;
		if (this.doSave()==false) return false;
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments);
	}
	return true;
}

/// This callback, if defined, is called when the user presses the Cancel button.
/// If this returns false, then the dialog is not cancelled.
ClientMethod ondialogCancel() [ Language = javascript ]
{
	return true;
}

ClientMethod getDialogValue() [ Language = javascript ]
{
	return true;
}

/// User clicked one of the Browse buttons.
/// Save the name of the textfield so that when you return you know which textfield to update.
ClientMethod browseSelect(name, wildcard) [ Language = javascript ]
{
	zenPage.getComponentById('browseselect').setValue(name);
	var Dir = zenPage.getComponentById(name).getValue();
	zenLaunchPopupWindow('%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir)+'&wildcard='+wildcard,'FileSelect','resizable,width=600,height=700');
}

/// User changed CAFile. If not null, enable CRL file. OW, disable
ClientMethod changedCAFile() [ Language = javascript ]
{
	var CAFile = zenTrim(zen("CAFile").getValue());
	if (CAFile == "") {
		zen("id_CRLFile").setProperty("disabled",true);
		zen("id_CRLFile").setProperty("labelClass","disablednormal");		
	} else {
		zen("id_CRLFile").setProperty("disabled",false);
		zen("id_CRLFile").setProperty("labelClass","normal");
	}
}

/// User changed password. Update flag. 
ClientMethod changePW() [ Language = javascript ]
{
	this.pwModified = 1;
}

/// User changed PWOptions option. If they want to enter new password, show password fields. Otherwise hide them. 
ClientMethod togglePW() [ Language = javascript ]
{
	var PWOptions = zenPage.getComponentById("PWOptions").getValue();
	if (PWOptions == 2) {
		zenPage.getComponentById("id_Password").setHidden(false);
	} else {
		zenPage.getComponentById("id_Password").setHidden(true);	
	}
}

/// Get user input and send to server to save settings.
ClientMethod doSave() [ Language = javascript ]
{
	try {
		// reset previous result message, if any
		zenPage.getComponentById("result").setValue("");
		
		var CAFile = zenPage.getComponentById("CAFile").getValue();
		var CRLFile = zenPage.getComponentById("CRLFile").getValue();
		var CertificateFile = zenPage.getComponentById("CertificateFile").getValue();
		var PrivateKeyFile = zenPage.getComponentById("PrivateKeyFile").getValue();
		var PrivateKeyType = zenPage.getComponentById("PrivateKeyType").getValue();
		var PrivateKeyPassword = zenPage.getComponentById("PrivateKeyPassword").getValue();
		var Protocols1 = zenPage.getComponentById("Protocols1").getValue();
		var Protocols2 = zenPage.getComponentById("Protocols2").getValue();
		var Protocols4 = zenPage.getComponentById("Protocols4").getValue();
		var Protocols8 = zenPage.getComponentById("Protocols8").getValue();
		var Protocols16 = zenPage.getComponentById("Protocols16").getValue();
		var CipherList = zenPage.getComponentById("CipherList").getValue();
		var PWOptions = zenPage.getComponentById("PWOptions").getValue();
		var proxy = this.SaveData(CAFile,CRLFile,CertificateFile,PrivateKeyFile,PrivateKeyType,PrivateKeyPassword,Protocols1,Protocols2,Protocols4,Protocols8,Protocols16,CipherList,this.pwModified,PWOptions);
		if (proxy.Message != "") {
			zenPage.getComponentById("result").setValue(proxy.Message);
		}
		return proxy.ok
	} catch(ex) {
		alert("ERROR: " + ex);
	}
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			var name = zenPage.getComponentById("browseselect").getValue();
			zenPage.getComponentById(name).setValue(value);
			//if user changed CAFile, then see if we should enable/disable the CRLFile field.
			if (name == "CAFile") this.changedCAFile();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClientMethod validate() [ Language = javascript ]
{
	var PrivateKeyPassword = zenPage.getComponentById("PrivateKeyPassword").getValue();
	var PrivateKeyPassword1 = zenPage.getComponentById("PrivateKeyPassword1").getValue();
	if (PrivateKeyPassword != PrivateKeyPassword1) {
		alert($$$Text("The two Passwords are not the same. Please type them again."));
		zenPage.getComponentById("PrivateKeyPassword1").focus();
		return false;
	}
	return true;
}

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$Text("Edit SSL/TLS Configurations for Mirror")
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
	
	Set ..isNew = '+##class(SYS.MirrorConfiguration).DoSSLConfigurationsExist()

	// Load data into fields
	Set tSC = ..LoadData()
	If $$$ISERR(tSC) Set ..%GetComponentById("result").value = tSC,..%GetComponentById("btnFinish").disabled = 1
	
	If (..%GetComponentById("CAFile").value = "") {
		Set ..%GetComponentById("id_CRLFile").disabled = 1
		Set ..%GetComponentById("id_CRLFile").labelClass = "disablednormal"
	}
	
	Quit $$$OK
}

/// Used when Editing an existing SSL/TLS configuration. Load previously defined values into fields.
Method LoadData() As %Status
{
	Set $ZT="Error"
	If ##class(Security.SSLConfigs).%ExistsId("%MirrorServer") {
		Set sys = ##class(Security.SSLConfigs).%OpenId("%MirrorServer")
		Set ..%GetComponentById("CRLFile").value = sys.CRLFile
	} Else {
		Set sys = ##class(Security.SSLConfigs).%New()
	}
	Set ..%GetComponentById("PrivateKeyType").value = sys.PrivateKeyType
	Do ..ParseProtocols(sys.Protocols,.P)
	Set ..%GetComponentById("Protocols1").value = $S(P(1)'="":1,1:0)
	Set ..%GetComponentById("Protocols2").value = $S(P(2)'="":1,1:0)
	Set ..%GetComponentById("Protocols4").value = $S(P(4)'="":1,1:0)
	Set ..%GetComponentById("Protocols8").value = $S(P(8)'="":1,1:0)
	Set ..%GetComponentById("Protocols16").value = $S(P(16)'="":1,1:0)
	Set ..%GetComponentById("CertificateFile").value = sys.CertificateFile
	Set ..%GetComponentById("PrivateKeyFile").value = sys.PrivateKeyFile
	Set ..%GetComponentById("CipherList").value = sys.CipherList

	// Figure out if this is a File or Directory
	Set CAFile = sys.CAFile
	Set CAPath = sys.CAPath
	If CAFile '= "", ##class(%File).DirectoryExists(CAFile) Set CAPath = CAFile,CAFile=""
	If CAPath '= "", '##class(%File).DirectoryExists(CAPath) Set CAFile = CAPath,CAPath = ""
	If CAFile="",CAPath'="" Set CAFile = CAPath   //YSD1424 - this line is for display purpose only
	Set ..%GetComponentById("CAFile").value = CAFile
	Quit $$$OK
Error	///
	Set $ZT="" Do BACK^%ETN
	Quit $ZCVT($ZE,"O","HTML")
}

ClassMethod ParseProtocols(Protocols As %String, Output P As %String)
{
	Set (P(1),P(2),P(4),P(8),P(16)) = ""
	If $zb(Protocols,1,1) Set P(1)=1
	If $zb(Protocols,2,1) Set P(2)=2
	If $zb(Protocols,4,1) Set P(4)=4
	If $zb(Protocols,8,1) Set P(8)=8
	If $zb(Protocols,16,1) Set P(16)=16
}

/// Save general association data to server
ClassMethod SaveData(CAFile, CRLFile, CertificateFile, PrivateKeyFile, PrivateKeyType, PrivateKeyPassword, Protocols1, Protocols2, Protocols4, Protocols8, Protocols16, CipherList, pwModified, PWOptions) As %ZEN.proxyObject [ ZenMethod ]
{
#dim sys as Security.SSLConfigs

	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		Set CAPath = ""
		If CAFile '= "",##class(%File).DirectoryExists(CAFile) Set CAPath = CAFile,CAFile=""
		If CAPath '= "",'##class(%File).DirectoryExists(CAPath) Set CAFile = CAPath,CAPath = ""
		
		Set Protocols1 = $S(Protocols1="true":1,1:0)
		Set Protocols2 = $S(Protocols2="true":2,1:0)
		Set Protocols4 = $S(Protocols4="true":4,1:0)
		Set Protocols8 = $S(Protocols8="true":8,1:0)
		Set Protocols16 = $S(Protocols16="true":16,1:0)
		Set Protocols = Protocols1 + Protocols2 + Protocols4 + Protocols8 + Protocols16
		
		For Name = "%MirrorServer","%MirrorClient" {
			If ##class(Security.SSLConfigs).%ExistsId(Name) {
				Set sys = ##class(Security.SSLConfigs).%OpenId(Name,,.tSC)
				If '$IsObject(sys) {
					Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
				}
			} Else {
				Set sys = ##class(Security.SSLConfigs).%New()
				Set sys.Name = Name
			}
			Set sys.Enabled = 1
			Set sys.Description = $S(Name="%MirrorClient":$$$TextHTML("SSL/TLS Client Configuration for Mirror"),1:$$$TextHTML("SSL/TLS Server Configuration for Mirror"))
			Set sys.VerifyPeer = $S(Name="%MirrorClient":1,1:3)
			Set sys.PrivateKeyType = PrivateKeyType
			Set sys.Protocols = Protocols
			Set sys.CAFile = CAFile
			Set sys.CAPath = CAPath
			Set sys.CRLFile = CRLFile
			Set sys.CertificateFile = CertificateFile
			Set sys.PrivateKeyFile = PrivateKeyFile
			
			If PWOptions = 1 Set sys.PrivateKeyPassword = ""
			If pwModified Set sys.PrivateKeyPassword = PrivateKeyPassword
			If (PWOptions = 0) && ##class(Security.SSLConfigs).%ExistsId(Name) {
				Set old = ##class(Security.SSLConfigs).%OpenId(Name,,.tSC)
				If '$IsObject(old) {
					Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
				}
				Set sys.PrivateKeyPassword = old.PrivateKeyPassword
				Kill old
			}
			Set sys.CipherList = CipherList
			Set sys.Type = $S(Name="%MirrorClient":0,1:1)
			Set tSC = sys.%Save()
			If $$$ISERR(tSC) Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			Kill sys
		}
		#; YSD2418:
		Set tSC = ##class(SYS.Mirror).UpdateDNinMirrorSetMember()
		If $$$ISERR(tSC) Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		Set tProxy.ok = 1
		Set tProxy.Message = ""
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.Message = ..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
	}
	Quit tProxy
}

ClassMethod DrawPageTitle(pSeed As %String) As %Status
{
	if (pSeed = 1) {
		Set tPageTitle = $$$TextHTML("Use the form below to create SSL/TLS configurations for Mirror. All changes made below will be saved to both %MirrorClient and %MirrorServer:")_"<br/>"
	} else {
		Set tPageTitle = $$$TextHTML("Use the form below to edit SSL/TLS configurations for Mirror. All changes made below will be saved to both %MirrorClient and %MirrorServer:")_"<br/>"
	}
	&html<<div class="Description">#(tPageTitle)#</div>
	<hr size="1"/>>
	Quit $$$OK
}

}
