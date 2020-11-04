Class %CSP.UI.Portal.Shadow Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "Edit Shadow Server";

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter EMSSERVICE = "Namespace";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Shadow.zen";

Parameter HELPADDRESS = "System Administration, Configuration, Connectivity, Shadow Server Settings, Add Shadow Server";

Parameter PARENTPAGE = "/csp/sys/mgr/%CSP.UI.Portal.Shadows.zen";

Parameter RECENT = 0;

Property IsEditForm As %Boolean [ InitialExpression = 1 ];

Property isNew As %String(ZENURL = "isNew") [ InitialExpression = "0" ];

/// Shadow for edit. Null if adding new shadow.
Property PID As %String(ZENURL = "PID");

Property ShowAdvanced As %Boolean [ InitialExpression = 0 ];

XData Style
{
<style type="text/css">
.zenLabelDisabled,a.radioSetCaptionDisabled { color:black; }
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
 <!-- block to show result -->
 <form id="fld">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<label id="shadowRunning" enclosingClass="errorNote" hidden="true" containerStyle="padding-bottom:4px;"/>
<group enclosingClass="EditForm" cellStyle="padding:4px;" labelPosition="left">
<group cellStyle="padding:4px;" labelPosition="left">
<text id="Name" label="Name of the shadow" hint="Required." onchange="zenPage.doModified();"/>
<text id="Address" label="DNS name or IP address of the source" hint="Required." onchange="zenPage.doModified();"/>
<text id="Port" label="Port number of the source" hint="Required." size="5" onchange="zenPage.doModified();"/>
</group>
<link id="AdvancedLink" href="#" caption="Show Advanced Settings" onclick="zenPage.toggleAdvanced();return false;" enclosingClass="smpLink"/>
<group id="AdvancedGroup" hidden="true" labelPosition="left" cellStyle="padding:4px;">
<hgroup label="Journal file directory">
<text id="JournalDirectory" value="shadow" size="40" onchange="zenPage.doModified();"/>
<button id="JournalDirectoryBrowse" caption="Browse..." onclick="zenPage.doBrowse('JournalDirectory');" valign="top"/>
</hgroup>
<dataCombo id="SSLConfig"
queryClass="Security.SSLConfigs"
queryName="ListNames"
label="SSL Configuration"
onchange="zenPage.doModified();"
/>
<text id="FilterRoutine" label="Filter routine" onchange="zenPage.doModified();"/>
<text id="DaysBeforePurge" label="Days of old copied journals to keep" value="0" size="5" maxlength="5" onchange="zenPage.doModified();"/>
<text id="MaxErrors" label="Maximum error messages to keep" value="10" size="5" maxlength="5" onchange="zenPage.doModified();"/>

<checkbox id="DisableJournalUpdates" label="Disable journaling of shadow updates" onchange="zenPage.doModified();"/>
</group>
<group labelPosition="left">
<group id="MappingGroup" cellStyle="padding:4px;" labelPosition="left" label="Database mapping for this shadow">
<link id="AddMappingLink" href="#" caption="Add Database Mapping" onclick="zenPage.addMapping();return false;" enclosingClass="smpLink" hidden="#(%page.IsEMSReadOnly)#"/>
<spacer height="0.5em"/>
<tableNavBar showFilter="false" showMaxRows="true" showPageSize="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table"
queryClass="Config.MapShadows"
queryName="List"
maxRows="1000"
pageSize="0"
useSnapshot="true">
<parameter value="#(%page.PID)#"/>
<parameter value="*"/>
<parameter value=""/>
<parameter value=""/>
<parameter value=""/>
<column colName="Name" header="Remote Directory"/>
<column colName="Directory" header="Local Directory"/>
<column linkCaption="Delete" id="LinkDelete" link="javascript:zenPage.deleteItem('#(%query.Name)#');" linkConfirm="Are you sure you want to delete definition '%1'?" hidden="#(%page.IsEMSReadOnly)#"/>
</tablePane>
</group>
</group>
</group>
</form>
</pane>
}

ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action == "ok") {
		if (popupName == 'JournalDirectory') {
			zen(popupName).setValue(value);		
			zenPage.doModified();
		} else {
			zen('table').executeQuery();
		}
	}
}

/// Launching a file selector window. 
ClientMethod doBrowse(fieldID) [ Language = javascript ]
{
	var Dir = zen(fieldID).getValue();
	var wildcard = "*";
	var url = zenLink("%ZEN.Dialog.fileSelect.zen?Dir=" + cspEncodeUTF8(Dir) + "&wildcard=" + wildcard + "&showdirectoryonly=1");
	zenLaunchPopupWindow(url,fieldID,'status,scrollbars,resizable,width=600,height=700');
}

/// Add Database Mapping to this shadow
ClientMethod addMapping() [ Language = javascript ]
{
	var url = zenLink('%CSP.UI.Portal.Dialog.ShadowDBMapping.zen?ShadowName='+encodeURIComponent(zenPage.PID));
	zenPage.launchPopupWindow(url,'Add Database Mapping','status,scrollbars,resizable,width=700,height=600');
}

/// Delete existing item.
ClientMethod deleteItem(name) [ Language = javascript ]
{
	name = unescape(name);
	try {
		this.resetMsg();
		var ok = this.DeleteMap(this.PID,name);
		if (ok != 1) {
			zenPage.showMsg(ok,1);
		} else {
			zen('table').executeQuery();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Call server delete method.
ClassMethod DeleteMap(Shadow As %String, Name As %String) As %String [ ZenMethod ]
{
	Try {
		// Make sure shadow isn't running at this point.
		Set shadowStatus = ##class(SYS.Shadowing.Shadow).GetStatus(Shadow)
		If '##class(%Library.ShadowState).CanStart(shadowStatus) {
   			Set tSC = $$$ERROR($$$ShadowStopRequired,Shadow)
   			throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set tSC = ##class(Config.MapShadows).Delete(Shadow,Name)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
	} Catch Error {
		Set tSC = ..EvalResult(Error.AsStatus())
	}
	Quit tSC
}

ClientMethod toggleAdvanced() [ Language = javascript ]
{
	var group = zen('AdvancedGroup');
	var isHidden = group.getProperty('hidden');
	if (!isHidden) {
		var caption = $$$Text('Show Advanced Settings');
	} else {
		var caption = $$$Text('Hide Advanced Settings');
	}
	zen('AdvancedLink').setProperty('caption',caption);
	group.setHidden(!isHidden);
}

ClientMethod validate() As %Boolean [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var pass = true;
	try {
		if (!this.validateRequired(zen('Name'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('Address'),pass,"S")) pass = false;
		if (!this.validateRequired(zen('Port'),pass,"N")) pass = false;
	} catch (ex) {
		alert("Error: " + ex);	
	}
	zenSynchronousMode = oldSynchronousMode;
	
	return pass;
}

/// Save current item. Subclass to override.
ClientMethod doSave() [ Language = javascript ]
{
	try {
		this.resetMsg();
		if (!this.validate()) {
			zenPage.afterValidate();
			return;
		}
		
		var proxy = new zenProxy();
		proxy.PID = this.PID;
		proxy.Name = zenEscapeJS(zen("Name").getValue());
		proxy.Address = zen("Address").getValue() + '|' + zen("Port").getValue();
		proxy.DaysBeforePurge = zen("DaysBeforePurge").getValue();
		proxy.DisableJournalUpdates = zen("DisableJournalUpdates").getValue();
		proxy.FilterRoutine = zen("FilterRoutine").getValue();
		proxy.JournalDirectory = zen("JournalDirectory").getValue();
		proxy.MaxErrors = zen("MaxErrors").getValue();
		proxy.SSLConfig = zen("SSLConfig").getValue();
		
		var ok = this.SaveData(proxy);
		zenPage.afterSave(ok);
	} catch (ex) {
		alert("Error: " + ex);
	}
}

ClassMethod SaveData(pProxy As %ZEN.proxyObject) As %ZEN.proxyObject [ ZenMethod ]
{
	#; Initialize return proxy object
	Set tProxy = ##class(%ZEN.proxyObject).%New()

	Try {
		If (pProxy.PID '= "") {
			// Make sure shadow isn't running at this point.
			Set shadowStatus = ##class(SYS.Shadowing.Shadow).GetStatus(pProxy.PID)
			If '##class(%Library.ShadowState).CanStart(shadowStatus) {
	   			Set tSC = $$$ERROR($$$ShadowStopRequired,pProxy.PID)
	   			throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
			}
		}
		Set Properties("Address") = pProxy.Address
		Set Properties("DaysBeforePurge") = pProxy.DaysBeforePurge
		Set Properties("DisableJournalUpdates") = pProxy.DisableJournalUpdates
		Set Properties("FilterRoutine") = pProxy.FilterRoutine
		Set Properties("JournalDirectory") = pProxy.JournalDirectory
		Set Properties("MaxErrors") = pProxy.MaxErrors
		Set Properties("SSLConfig") = pProxy.SSLConfig
		
		Set tMethod = $S(pProxy.PID="":"Create",1:"Modify")
		Set tSC = $classmethod("Config.Shadows",tMethod,pProxy.Name,.Properties)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		Set tProxy.ok = 1
	} Catch Error {
		Set tProxy.ok = 0
		Set tProxy.ErrorMessage = ..EvalResult(Error.AsStatus())
	}
	Quit tProxy
}

/// Subclass can override.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Do ..%GetNavTableState(..%GetPageName()_" "_..PID)

	Set ..lblTitle = $S(..isNew=1:$$$Text("Use the form below to create a new shadow server:"),1:$$$Text("Use the form below to edit a shadow server:"))
	
	If ..PID '= "" {
		Set ..%GetComponentById("Name").disabled = 1
		
		Set tSC = ##class("Config.Shadows").Get(..PID,.Properties)
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
		Set ..%GetComponentById("Name").value = ..PID
		Set ..%GetComponentById("Address").value = $p(Properties("Address"),"|",1)
		Set ..%GetComponentById("Port").value = $p(Properties("Address"),"|",2)
		If ..IsEMSReadOnly {
			Set ..%GetComponentById("Name").disabled = 1
			Set ..%GetComponentById("Address").disabled = 1
			Set ..%GetComponentById("Port").disabled = 1
		}
		// Make sure shadow isn't running at this point.
		Set shadowStatus = ##class(SYS.Shadowing.Shadow).GetStatus(..PID)
		If '##class(%Library.ShadowState).CanStart(shadowStatus) {
   			Set ..InvalidParam = 1
   			Set ..%GetComponentById("AddMappingLink").hidden = 1
   			Set ..%GetComponentById("LinkDelete").hidden = 1
   			Set ..%GetComponentById("shadowRunning").value = $$$Text("Changes cannot be saved while the shadow is running.")
   			Set ..%GetComponentById("shadowRunning").hidden = 0
		}
	} Else {
		Set ..%GetComponentById("MappingGroup").hidden = 1
	}

	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	If ..isNew {
		Quit $$$Text("Create Shadow Server")
	} ElseIf ..IsEMSReadOnly {
		Quit $$$Text("View Shadow Server")
	} Else {
		Quit $$$Text("Edit Shadow Server")
	}
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Configuration")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Shadow Server Settings")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen?PID="_$ZCVT(%page.PID,"O","URL"))
	Quit $$$OK
}

/// Overriden to add PID to the page name to distinguish the specific page.
ClientMethod navPageSizeChanged(value) [ Language = javascript ]
{
	this.TablePageSize = value;
	this.UpdateTableNavState(this.Filter,value,this.TableMaxRows,this.PID);
}

/// Overriden to add PID to the page name to distinguish the specific page.
ClientMethod navMaxRowsChanged(value) [ Language = javascript ]
{
	this.TableMaxRows = value;
	this.UpdateTableNavState(this.Filter,this.TablePageSize,value,this.PID);
}

/// Used to Save tableNavBar values, add PID to the page name to distinguish the type for the page.
ClassMethod UpdateTableNavState(pFilter As %String, pPageSize As %Integer, pMaxRows As %Integer, pPID As %String) [ ZenMethod ]
{
	Set $$$CacheTempMgt($Username,..%GetPageName()_" "_pPID,"TableNavState") = $lb(pFilter,pPageSize,pMaxRows)
}

}
