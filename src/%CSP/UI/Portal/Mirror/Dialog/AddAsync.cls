Include %syMirror

/// Zen page for System Management Portal - Create Mirror
Class %CSP.UI.Portal.Mirror.Dialog.AddAsync Extends %CSP.UI.Portal.Dialog.WizardTemplate [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Mirror.Dialog.AddAsync.zen";

/// Displayed name of this page.
Parameter PAGENAME = "AddAsync";

/// If true, then this dialog displays an Apply button.
Parameter APPLYBUTTON As BOOLEAN = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property ErrorMsg As %String;

Property MirrorName As %ZEN.Datatype.string;

Property MemberName As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property AgentAddress As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property AgentPort As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property ConnectsTo As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property ECPAddress As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property GUID As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property InstanceDirectory As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property MemberType As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property MirrorAddress As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property MirrorSSPort As %Integer [ Required ];

Property SSLComputerName As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

Property EncryptCommunication As %ZEN.Datatype.string [ InitialExpression = "n/a" ];

XData Style
{
<style type="text/css">
tr.infoRow td {
	padding:0 6px 3px 0;
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
<button id="btnCancel" controlClass="commandButton" caption="Cancel" onclick="zenPage.dialogCancel();"/>
<spacer width="5" />
<button id="btnConnect" controlClass="commandButton" caption="Next" onclick="zenPage.doConnect();"/>
<button id="btnFinish" controlClass="commandButton" caption="Save" onclick="zenPage.dialogFinish();" hidden="true"/>
</hgroup>
</hgroup>
</page>
}

/// This XML block defines the contents of this pane.
XData dialogBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" cellStyle="padding:4 6 4 10;">
<spacer height="10"/>
<html OnDrawContent="DrawPageTitle" seed=""/>
<label id="idRespond" enclosingClass="note" containerStyle="padding-top:10px;padding-left:4px;" hidden="true"/>
<group id="fld" enclosingClass="EditForm" enclosingStyle="margin-left:3px;padding:3px;">
<group id="Page1">
<fieldSet label="Mirror Information" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<group labelPosition="left">
<label id="MirrorName" label="Mirror Name" controlStyle="color:black;font-size:12px;font-weight:bold;"/>
</group>
<fieldSet labelPosition="left" label="New Async Member's Info" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<text id="SSAddress" label="Superserver Address on the async member" size="32" hint="Required." hintClass="helpText"/>
<text id="SSPort" label="Superserver Port" size="5" hint="Required." hintClass="helpText"/>
</fieldSet>
</fieldSet>
<spacer height="5px"/>
<label label="Provide required information then click [Next] to retrieve data" containerStyle="padding-left:4px;"/>
</group>
<group id="Page2" hidden="true">
<fieldSet label="Async Member Information" valign="top" containerStyle="padding:4px;" cellStyle="padding:3px;">
<html id="MemberInfoTable" OnDrawContent="DrawMemberInfoTable"/>
</fieldSet>
</group>
</group>
</pane>
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	if (this.ErrorMsg !== "") {
		var msg = this.ErrorMsg;
		this.showMsg(msg);
		zen("btnFinish").setDisabled(true);
		zen("btnFinish").setProperty("controlClass","commandButtonDisabled");
		zen("fld").setHidden(true);
		return;
	}
	zen("SSAddress").focus();
}

ClientMethod goToNextPage() [ Language = javascript ]
{
	// refreshContents of the read-only checkbox so the display is correct
	zen("MemberInfoTable").refreshContents(true);
	zen("Page1").setHidden(true);
	zen("Page2").setHidden(false);
	zen("btnConnect").setHidden(true);
	zen("btnFinish").setHidden(false);
}

ClientMethod doConnect() [ Language = javascript ]
{
	var proxy = new zenProxy();
	
	proxy.MirrorName = zen("MirrorName").getValue();
	proxy.SSAddress = zen("SSAddress").getValue();
	proxy.SSPort = zen("SSPort").getValue();
	//proxy.InstanceName = zen("InstanceName").getValue();
	
	var ok = this.validateConnect(proxy);
	if (!ok) return;

	var result = this.Connect(proxy);

	if (result.ok == 1) {
		this.goToNextPage();
	} else {
		this.showMsg(result.ErrorMessage);
	}
}

ClientMethod doSave() [ Language = javascript ]
{
	var result = this.SaveData();

	if (result.ok == 1) {
		return true;
	} else {
		this.showMsg(result.ErrorMessage);
		return false;
	}
}

ClientMethod validateConnect(proxy) [ Language = javascript ]
{
	this.resetMsg('');

	if (proxy.MirrorName.length < 1) {
		this.showMsg($$$Text("Please enter a mirror name."));
		zen("MirrorName").focus();
		return false;
	}
	if (proxy.SSAddress.length < 1) {
		this.showMsg($$$Text("Please enter a superserver address."));
		zen("SSAddress").focus();
		return false;
	}
	if (proxy.SSPort.length < 1) {
		this.showMsg($$$Text("Please enter a superserver port."));
		zen("SSPort").focus();
		return false;
	}
	return true;
}

///  Save general association data to server.<br/>
///  Returns proxy.ok = 1 (save successful) or 0 (error occurred)<br/>
///  proxy.ErrorMessage (save failed and display this error message).
///  If proxy.ok is 1 and no messages returned then we return to SMP home.
Method Connect(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 1

	Try {
		#;JO2817: Add "" for targguid before existing "" for basedir
		Set rc=$$GetMemberConfigData^MIRRORCTL(pProxy.MirrorName,pProxy.SSAddress_"|"_pProxy.SSPort,"","","**")
		If '+$LG(rc) {
			Set tSC=$$$ERROR($$$GeneralError,"Failed to retrieve member information from async member, error="_$LG(rc,2))
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		#; The third piece is the local member info of remote.
		Set info=$LG(rc,3)  ;list of $LIST(name,<list of key/value pairs>)
		If info="" {
			Set tSC=$$$ERROR($$$GeneralError,"Remote member does not exist or is not an async member.")
			Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set %page.MemberName = $LG(info,1)
		Set data=$lg(info,2)
		Set len=$LL(data)
		For i=1:1:len {
			s item=$LG(data,i)
			s p=$LG(item,1)
			if p="AgentAddress" {
				Set %page.AgentAddress = $LG(item,2)
			} elseif p="AgentPort" {
				Set %page.AgentPort = $LG(item,2)
			} elseif p="ConnectsTo" {
				Set %page.ConnectsTo = $LG(item,2)
			} elseif p="ECPAddress" {
				Set %page.ECPAddress = $LG(item,2)
			} elseif p="GUID" {
				Set %page.GUID = $LG(item,2)
			} elseif p="InstanceDirectory" {
				Set %page.InstanceDirectory = $LG(item,2)
			} elseif p="MemberType" {
				Set %page.MemberType = $LG(item,2)
			} elseif p="MirrorAddress" {
				Set %page.MirrorAddress = $LG(item,2)
			} elseif p="MirrorSSPort" {
				Set %page.MirrorSSPort = $LG(item,2)
			} elseif p="SSLComputerName" {
				Set %page.SSLComputerName = $LG(item,2)
			} elseif p="EncryptCommunication" {
				Set %page.EncryptCommunication = $LG(item,2)
			}
		}
	} Catch Error {
		Set Message = ..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = Message
	}
	Quit tProxy
}

Method DrawMemberInfoTable(pSeed As %String) As %Status
{
	Set NameText = $$$TextHTML("Member Name")
	Set SuperserverPortText = $$$TextHTML("Superserver Port")
	Set SuperserverText = $$$TextHTML("Superserver Address")
	Set AgentText = $$$TextHTML("Agent Address")
	Set AgentPortText = $$$TextHTML("Mirror Agent Port")
	Set PrivateAddressText = $$$TextHTML("Mirror Private Address")
	Set MemberTypeText = $$$TextHTML("Member Type")
	Set GUIDText = $$$TextHTML("Member GUID")
	Set DirectoryText = $$$TextHTML("Instance Directory")
	Set DNText = $$$TextHTML("SSL DN")
	Set MemberType=$case(%page.MemberType,0:$$$Text("Failover"),1:$$$Text("Relay"),2:$$$Text("Async"),:$$$Text("Unknown"))
	
	&html<<table width="100%" cellspacing="3px">
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(NameText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.MemberName)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(GUIDText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.GUID)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(DirectoryText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.InstanceDirectory)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(AgentText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.AgentAddress)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(AgentPortText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.AgentPort)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(PrivateAddressText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.MirrorAddress)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(SuperserverText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.ECPAddress)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(SuperserverPortText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.MirrorSSPort)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(MemberTypeText)#:</td>
				<td class="normal" nowrap valign="middle"> #(MemberType)# </td>
			</tr>
			<tr class="infoRow">
				<td class="normal" nowrap valign="middle">&nbsp;#(DNText)#:</td>
				<td class="normal" nowrap valign="middle"> #(%page.SSLComputerName)# </td>
			</tr>
		</table>>
	
	Quit $$$OK
}

///  Save general association data to server.<br/>
///  Returns proxy.ok = 1 (save successful) or 0 (error occurred)<br/>
///  proxy.ErrorMessage (save failed and display this error message).
///  If proxy.ok is 1 and no messages returned then we return to SMP home.
Method SaveData() As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ok = 1

	Try {
		Set Prop("Name") = ..MemberName
		Set Prop("AgentAddress") = ..AgentAddress
		Set Prop("AgentPort") = ..AgentPort
		Set Prop("ConnectsTo") = ..ConnectsTo
		Set Prop("ECPAddress") = ..ECPAddress
		Set Prop("GUID") = ..GUID
		Set Prop("InstanceDirectory") = ..InstanceDirectory
		Set Prop("MemberType") = ..MemberType
		Set Prop("MirrorAddress") = ..MirrorAddress
		Set Prop("MirrorSSPort") = ..MirrorSSPort
		Set Prop("SSLComputerName") = ..SSLComputerName
		Set Prop("EncryptCommunication") = ..EncryptCommunication
		Set tSC = ##class(Config.MapMirrors).Create(..MirrorName,..MemberName,.Prop)
		If $$$ISERR(tSC) Throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
	} Catch Error {
		Set Message = ..EscapeHTML($System.Status.GetErrorText(Error.AsStatus()))
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = Message
	}
	Quit tProxy
}

/// Set Locator bar and determine whether to show change password option.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	If '$System.Mirror.IsPrimary() {
		Set %page.ErrorMsg = $$$TextHTML("Unable to continue because this is no longer the Primary system. Please check the cconsole.log for information.")
		Quit $$$OK
	}
	
	Set tSC = ##class(SYS.Mirror).CheckISCAgent()
	If $$$ISERR(tSC) {
		Set %page.ErrorMsg = ..EscapeHTML($System.Status.GetErrorText(tSC))
		Quit $$$OK
	}
	
	Set (%page.MirrorName,..%GetComponentById("MirrorName").value) = ##class(Config.Mirrors).GetMirrorName()
	If %page.MirrorName="" {
	    Set tSC = $$$ERROR($$$MirrorSetNameNotDefined)
	    Set %page.ErrorMsg = ..EscapeHTML($System.Status.GetErrorText(tSC))
		Quit $$$OK
    }
	
	Set ..%GetComponentById("SSPort").value = 1972
	
	Quit 1
}

/// This callback, if defined, is called when the user presses the OK or Apply action buttons.
/// If this returns false, then the action is cancelled.<br>
ClientMethod ondialogFinish(action) As %Boolean [ Language = javascript ]
{
	try {
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

/// Get the (localized) title string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	Quit $$$Text("Add Async Member to Mirror")
}

/// Get the (localized) subtitle string for the dialog.
/// This should be implemented in a subclass.
Method %OnGetSubtitle() As %String
{
	Quit ""
}

ClassMethod DrawPageTitle(pSeed As %String) As %Status
{
	Set tPageTitle = $$$TextHTML("Use the form below to add async member to the mirror configuration on this system")_"<br/>"
	&html<<div class="Description">#(tPageTitle)#</div>
	<hr size="1"/>>
	Quit $$$OK
}

}
