/// System Management Portal - System Administration - Connectivity - JDBC Gateway Server Settings & Status
Class %CSP.UI.Portal.JDBCGatewayServer Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.JDBCGatewayServer.zen";

Parameter HELPADDRESS = "Home,Configuration,JDBC Gateway Server";

/// Displayed name of this page.
Parameter PAGENAME = "JDBC Gateway Server";

Parameter RECENT = 0;

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property JAVAHOMEValue As %String [ InitialExpression = {..GetJAVAHOMEValue()} ];

Property JDBCGatewayPort As %String;

Property JDBCGatewayLog As %String;

Property JavaHome As %String;

Property JDBCGatewayJVMArgs As %String;

Property settingsExpanded As %Boolean [ InitialExpression = 1 ];

Property refreshState As %Boolean [ InitialExpression = 1 ];

Property refreshRate As %Integer [ InitialExpression = 30 ];

XData Style
{
<style type="text/css">
#settingsGroup {
	background: #edece4;
	padding-left: 3px;
	padding-right: 5px;
	border-right: 1px solid gray;
}
#settingsPane {
	padding-left: 3px;
	padding-right: 5px;
	overflow: hidden;
	overflow-y: auto;
	width: 400px;
}
.statuspane2 {
	overflow-x: scroll;
}
#spanArrow {
	font-size: 18px;
}
.radioSetSpan {
	vertical-align: middle;
	text-decoration: none;
}
.labelMsg {
	font-weight: normal;
}
table.tpTable th, table.tpTable td {
    padding: 2px 2px 2px 8px;
}
.commandButtonGray, .commandButtonDisabled {
	background: darkgray;
	color: #E3E3E3; /* rgb(67,67,67); */
	text-decoration: none;
	border-left: 1px solid lightgray;
	border-right: 2px solid gray;
	border-top: 1px solid lightgray;
	border-bottom: 2px solid gray;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 5px;
}
.commandButtonGray:hover {
	background: rgb(53,107,141);
	color: rgb(235,235,235);
	background-image: url('#(..Link("csp/broker/portal/button_gray_hover.png"))#');
	background-repeat: repeat-x;
}
</style>
}

/// This XML block defines the contents of this pane.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<vgroup width="100%">
<hgroup id="mainGroup" cellVAlign="top">
<hgroup id="settingsGroup" valign="top">
<pane id="settingsPane" paneName="settingsPane"/>
<html id="paneExpander" valign="top">
<span id="spanArrow" title="Hide the settings panel" 
onclick="zenPage.toggleSettings();" 
onmouseover="this.style.color='#356B8D';this.style.cursor='pointer'" 
onmouseout="this.style.color='';this.style.cursor='';">&#171;</span>
</html>
</hgroup>
<group id="statusGroup" valign="top">
<pane id="statusPane" paneName="statusPane" />
</group>
</hgroup>
</vgroup>
</pane>
}

/// This pane displays the settings form.
XData settingsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<form name="settingsForm" id="settingsForm" layout="vertical" cellStyle="padding: 5px 10px 5px 5px; font-size: 12px; width: 400px;">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<spacer height="10" />
<label label="Settings" labelStyle="font-size: 14px; font-weight: bold;" />
<hgroup cellStyle="padding-right: 5px; padding-top: 10px;">
<button id="btnSave" caption="Save" disabled="false" controlClass="commandButton" title="Save these settings to be used the next time that the JDBC Gateway Server is started" onclick="zenPage.saveSettings();"/>
<button id="btnReset" caption="Reset" disabled="false" controlClass="commandButton" title="Reload the page to get the updated values for the settings" onclick="zenPage.reloadPage();"/>
</hgroup>
<spacer height="10" />
<group id="id_JDBCGatewayPort" label="Port Number" title="TCP port number to be used exclusively by the JDBC Gateway.">
<text name="JDBCGatewayPort" id="JDBCGatewayPort" value="" size="10" onchange="zenPage.settingsModified(true);" />
</group>
<hgroup id="id_JDBCGatewayLog" label="Log File" title="Optional. Fully qualified name of the JDBC Gateway log file, usually for trouble-shooting.">
<text id="JDBCGatewayLog" size="40" maxlength="260" onchange="zenPage.settingsModified(true);" />
<button id="LogDirBrowse" caption="Browse..." containerStyle="padding-left: 2px;" onclick="zenPage.browseSelect('JDBCGatewayLog','*.*');" />
</hgroup>
<hgroup id="id_JavaHome" label="Java Home Directory" title="Directory that is the Java Home of the JVM to be used by the JDBC Gateway Server. If there is a default JVM on the machine this field may be left blank.">
<text id="JavaHome" size="40" maxlength="260" onchange="zenPage.settingsModified(true);" />
<button id="JavaHomeBrowse" caption="Browse..." containerStyle="padding-left: 2px;" onclick="zenPage.browseSelect('JavaHome','showdirectoryonly');" />
</hgroup>
<group id="id_JDBCGatewayJVMArgs" label="JVM Arguments" title="Optional JVM arguments to be added to the command used to start the JDBC Gateway.">
<text name="JDBCGatewayJVMArgs" id="JDBCGatewayJVMArgs" value="" size="40" onchange="zenPage.settingsModified(true);" />
</group>
<text id="JAVAHOMEValue" readOnly="true" label="JAVA_HOME Environment Variable" size="40" controlStyle="background:#EAEAEA;" value="#(%page.JAVAHOMEValue)#" hint="" title="Current value of O.S. environment variable JAVA_HOME." />
<spacer height="30" />
<label name="id_Note" id="id_Note" hidden="true" label="Settings can only be modified when the JDBC Gateway is stopped." labelStyle="font-size: 13px; font-weight: normal; text-wrap: normal;" />
<hidden name="browseselect" id="browseselect" />
</form>
<spacer height="150" />
</pane>
}

/// This pane displays the state and recent activity.
XData statusPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding: 10px; white-space:nowrap;" enclosingClass="statuspane" cellStyle="font-size: 13px;" >
<timer id="refreshTimer" timeout="30000" ontimeout="zenPage.refreshHandler();"/>
<spacer height="20" />
<label label="Status Information" labelStyle="font-size: 14px; font-weight: bold;" />
<spacer height="10" />
<button id="btnRefresh" caption="Refresh" controlClass="commandButton" title="Refresh state and activity information" onclick="zenPage.refreshStatus();"/>
<spacer height="10" />
<hgroup>
<label label="Refresh:" id="id_Refresh" name="id_Refresh" title="Enable or disable automatic refresh for the status information" />
<html OnDrawContent="DrawAutoRefresh" />
<spacer width="15" />
<label label="Updated:" labelClass="labelMsg" />
<spacer width="4" />
<label id="id_Time" value="" labelClass="labelMsg" />
</hgroup>
<spacer height="10" />
<html><hr /></html>
<spacer height="20" />
<label id="id_State" value="&#160;" labelClass="labelMsg" />
<hgroup cellStyle="padding-right: 5px; padding-top: 10px;">
<button id="btnStart" caption="Start" controlClass="commandButton" title="Start the JDBC Gateway Server" onclick="zenPage.startGateway();"/>
<button id="btnStop" caption="Stop" controlClass="commandButton" title="Stop the JDBC Gateway Server" onclick="zenPage.stopGateway();"/>
<label id="id_Msg" value="" enclosingClass="labelMsg" />
</hgroup>
<spacer height="25" />
<label label="Recent Activity" labelStyle="font-size: 14px; font-weight: normal;" />
<spacer height="10" />
<group enclosingStyle="overflow: auto;" containerStyle="overflow: auto;" >
<tableNavBar showFilter="false" showMaxRows="true" showPageSize="true" tablePaneId="table" 
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table"
queryClass="%Net.Remote.ActivityLog"
queryName="ByName"
dataSource="columns"
fixedHeaders="false"
maxRows="1000"
pageSize="100"
showValueInTooltip="true"
showZebra="true"
valueColumn="Name"
useSnapshot="true"
rowSelect="false"
>
<parameter id="idGatewayName" name="GatewayName" value="JDBC_Default" />
<column colName="ID" header="ID"/>
<column colName="DateTime" header="Date Time"/>
<column colName="RecordType" header="Record Type"/>
<column colName="Job" header="Job"/>
<column colName="Text" header="Text"/>
 </tablePane>
 </group>
</pane>
}

Method DrawAutoRefresh(pSeed As %String) As %Status
{
	Set msgSeconds = $$$Text("Refresh interval in seconds (10 - 300)")
	Set tSeconds = $$$TextHTML("sec")
	Set tState = %page.refreshState
	Set tRate = %page.refreshRate
	&html<
		<input id="refreshOff" name="refreshonoff" type="radio" #($S(tState=0:"checked",1:""))# onclick="return zenPage.setRefreshMode(false);"/><span onclick="zenPage.setRefreshMode(false);">#($$$Text("off"))#</span>
		<input id="refreshOn" name="refreshonoff" type="radio" #($S(tState=1:"checked",1:""))# onclick="return zenPage.setRefreshMode(true);"/><span onclick="zenPage.setRefreshMode(true);">#($$$Text("on"))#</span>
		&nbsp;
		<input id="refreshRate" name="refreshRate" type="number" min="10" max="300" title="#(msgSeconds)#" size="3" value="#(tRate)#" onchange="zenPage.setRefreshRate(this.value);">
	>
	Quit $$$OK
}

ClientMethod setRefreshMode(auto) [ Language = javascript ]
{
	if (auto) {
		zenPage.refreshState = true;
		zenPage.refreshStatus();
		zen('refreshTimer').setProperty('timeout',zenPage.refreshRate*1000);
		zen('refreshTimer').startTimer();
	}
	else {
		zenPage.refreshState = false;
		zen('refreshTimer').clearTimer();
	}
}

ClientMethod setRefreshRate(seconds) [ Language = javascript ]
{
	if (seconds) {
		var refreshRate = zenTrim(seconds);
		if ((refreshRate == '') || (isNaN(refreshRate) == true)) {
			refreshRate = 30; // default rate
			self.document.getElementById('refreshRate').value = refreshRate;
		}
		else if ((refreshRate < 10)) {
			refreshRate = 10; // minimum rate
			self.document.getElementById('refreshRate').value = refreshRate;
		}
		else if (refreshRate > 300) {
			refreshRate = 300; // maximum rate
			self.document.getElementById('refreshRate').value = refreshRate;
		}
		zenPage.refreshRate = refreshRate;
		if (zenPage.refreshState) {
			zen('refreshTimer').clearTimer();
			zenPage.setRefreshMode(true);
		}
	}
}

/// Auto-refresh timer handler.
ClientMethod refreshHandler() [ Language = javascript ]
{
	zen('refreshTimer').startTimer();
	zenPage.refreshStatus();
}

ClassMethod GetJAVAHOMEValue() As %String [ Internal ]
{
	Set tValue = $system.Util.GetEnviron("JAVA_HOME")
	Set:tValue="" tValue = $$$Text(" (Not defined)")
	Quit $ZCVT(tValue,"O","HTML")
}

ClientMethod settingsModified(isMod) [ Language = javascript ]
{
	zen('btnSave').setDisabled(false);
	zenSetProp('btnSave','controlClass','commandButton');
	zenPage.doModified();
}

/// User clicked one of the Browse buttons.
/// Save the name of the text field so that when you return you know which text field to update.
ClientMethod browseSelect(name, wildcard) [ Language = javascript ]
{
	zenPage.getComponentById('browseselect').setValue(name);
	var Dir = zenPage.getComponentById(name).getValue();
	var url = '%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir);
	if (wildcard == 'showdirectoryonly') url = url + '&showdirectoryonly=1';
	else  url = url + '&wildcard=' + wildcard;
	zenLaunchPopupWindow(url,'FileSelect','resizable,width=600,height=700');
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	switch(popupName) {

	case 'FileSelect':
		try {
			if (action == "ok") {
				var name = zenPage.getComponentById("browseselect").getValue();
				zenPage.getComponentById(name).setValue(value);
				zenPage.settingsModified(true);
			}
		} catch (ex) {
			alert("Error: " + ex);
		}
		break;

	}
	
	return true;
}

/// Update Status panel, refreshing time of update, state and recent activity table
ClientMethod refreshStatus() [ Language = javascript ]
{
	// Refresh time
	var ctlMsg = document.getElementById('id_Time');
	ctlMsg.innerHTML = zenPage.LastUpdateTime();

	// Refresh state
	var isActive = zenPage.GetGatewayState();
	zenPage.enableOrDisableSettingsForm(!isActive);
	var ctlState = document.getElementById('id_State');
	if (isActive) {
		ctlState.innerHTML = $$$Text("JDBC Gateway is running");
		ctlState.style.color = 'green';
		zenSetProp('btnStart','controlClass','commandButtonGray');
		zenSetProp('btnStop','controlClass','commandButton');
	}
	else {
		ctlState.innerHTML = $$$Text("JDBC Gateway is stopped");
		ctlState.style.color = 'red';
		zenSetProp('btnStart','controlClass','commandButton');
		zenSetProp('btnStop','controlClass','commandButtonGray');
	}
	zenSetProp('btnStart','disabled',false);
	zenSetProp('btnStop','disabled',false);
	zenSetProp('btnRefresh','controlClass','commandButton');
	zenSetProp('btnRefresh','disabled',false);


	// Refresh activity tablePane
	var tbl = zen('table');
	tbl.executeQuery();
}

/// Return server time in format HH:MM:SS
ClassMethod LastUpdateTime() As %String [ ZenMethod ]
{
	Quit $ZT($P($H,",",2))
}

/// Find out whether the JDBC Gateway is active or inactive
ClassMethod GetGatewayState() As %Boolean [ ZenMethod ]
{
	Set tHost = "127.0.0.1"
	Set tPort = $$$JDBCGatewayPort
	Set:'tPort tPort = 62972
	Quit ##class(%Net.Remote.Service).IsGatewayRunning("127.0.0.1", tPort, 0, .tSC, 1)
}

ClientMethod enableOrDisableSettingsForm(enable) [ Language = javascript ]
{
	if (enable == true) {
		// Enable form
		zenSetProp('btnSave','disabled',false);
		zenSetProp('btnSave','controlClass','commandButton');
		zenSetProp('JDBCGatewayPort','disabled',false);
		zenSetProp('JDBCGatewayLog','disabled',false);
		zenSetProp('JavaHome','disabled',false);
		zenSetProp('JDBCGatewayJVMArgs','disabled',false);
		zenSetProp('LogDirBrowse','hidden',false);
		zenSetProp('JavaHomeBrowse','hidden',false);
		zenSetProp('id_Note','hidden',true);
	}
	else {
		// Disable form
		zenSetProp('btnSave','disabled',true);
		zenSetProp('btnSave','controlClass','commandButtonDisabled');
		zenSetProp('JDBCGatewayPort','disabled',true);
		zenSetProp('JDBCGatewayLog','disabled',true);
		zenSetProp('JavaHome','disabled',true);
		zenSetProp('JDBCGatewayJVMArgs','disabled',true);
		zenSetProp('LogDirBrowse','hidden',true);
		zenSetProp('JavaHomeBrowse','hidden',true);
		zenSetProp('id_Note','hidden',false);
	}
}

/// Start the JDBC Gateway server.
ClientMethod startGateway() [ Language = javascript ]
{
	var isActive = zenPage.GetGatewayState();
	if (isActive == true) {
		alert($$$Text("The JDBC Gateway server is already running"));
		return;
	}

	// Check if settings were modified in this page and were not saved
	var port = zen('JDBCGatewayPort').value;
	var logfile = zen('JDBCGatewayLog').value;
	var javahome = zen('JavaHome').value;
	var jvmargs = zen('JDBCGatewayJVMArgs').value;
	if ((port != zenPage.JDBCGatewayPort) || (logfile != zenPage.JDBCGatewayLog) || (javahome != zenPage.JavaHome) || (jvmargs != zenPage.JDBCGatewayJVMArgs)) {
		alert($$$Text("Please save modified settings before starting the JDBC Gateway"));
		return;
	}

	// Check if settings were modified by another process
	if (zenPage.CheckForChanges(false,port,logfile,javahome)) {
		alert($$$Text("The JDBC settings have been modified by another process, please click button 'Reset' to update the settings panel"));
		return;
	}

	if (!confirm($$$Text("Do you wish to start the JDBC Gateway server?"))) {
		return;
	}

	zen('refreshTimer').clearTimer();
	var ctlState = document.getElementById('id_State');
	ctlState.innerHTML = $$$Text("JDBC Gateway is starting, please wait...");
	ctlState.style.color = 'black';
	zenPage.enableOrDisableSettingsForm(false);
	zenSetProp('btnStart','controlClass','commandButtonDisabled');
	zenSetProp('btnStart','disabled',true);
	zenSetProp('btnStop','controlClass','commandButtonDisabled');
	zenSetProp('btnStop','disabled',true);
	zenSetProp('btnRefresh','controlClass','commandButtonDisabled');
	zenSetProp('btnRefresh','disabled',true);

	setTimeout(function() {
		var ret = zenPage.StartJDBCGateway('127.0.0.1',port);
		zenPage.refreshStatus();
		if (zenPage.refreshState) {
			zen('refreshTimer').setProperty('timeout',zenPage.refreshRate*1000);
			zen('refreshTimer').startTimer();
		}
		setTimeout(function() {
			var sync = zenPage.startGatewayMessage(ret);
		}, 100);
	}, 100);
}

ClientMethod startGatewayMessage(ret) [ Language = javascript ]
{
	if (ret == "") {
		//alert($$$Text("JDBC Gateway started successfully"));
	}
	else {
		alert(ret);
	}
	return "done";
}

/// Stop the JDBC Gateway server.
ClientMethod stopGateway() [ Language = javascript ]
{
	var isActive = zenPage.GetGatewayState();
	if (isActive == false) {
		alert($$$Text("The JDBC Gateway server is already stopped"));
		return;
	}

	// Check if the port was modified by another process
	var port = zen('JDBCGatewayPort').value;
	if (zenPage.CheckForChanges(true,port,'','')) {
		alert($$$Text("The JDBC port has been modified by another process, please click button 'Reset' to update the settings panel"));
		return;
	}

	if (!confirm($$$Text("Do you really wish to stop the JDBC Gateway server?") + "\n" + $$$Text("Note that ongoing JDBC connections will be affected."))) {
		return;
	}

	zen('refreshTimer').clearTimer();
	zenSetProp('btnStop','controlClass','commandButtonDisabled');
	zenSetProp('btnStop','disabled',true);
	zenSetProp('btnStart','disabled',true);
	zenSetProp('btnRefresh','controlClass','commandButtonDisabled');
	zenSetProp('btnRefresh','disabled',true);
	var ret = zenPage.StopJDBCGateway('127.0.0.1',port);
	setTimeout(function() {
		zenPage.refreshStatus();
		if (zenPage.refreshState) {
			zen('refreshTimer').setProperty('timeout',zenPage.refreshRate*1000);
			zen('refreshTimer').startTimer();
		}
	}, 500);
	setTimeout(function() {
		zenPage.stopGatewayMessage(ret);
	}, 100);
}

/// Return 1 (true) if settings have been modified by another process, or 0 otherwise
ClassMethod CheckForChanges(pOnlyPort As %Boolean = 0, pPort As %String = "", pLogFile As %String = "", pJavaHome As %String = "") As %Boolean [ ZenMethod ]
{
	Set:'$G(port) port = $$$JDBCGatewayPort
	Set:'port port = 62972
	If pPort'=port Quit 1

	If pOnlyPort Quit 0

	If $D(pLogFile) {
		If pLogFile'=$$$JDBCGatewayLog Quit 1
	}

	If $D(pJavaHome) {
		If pJavaHome'=$$$JavaHome Quit 1
	}

	Quit 0
}

ClientMethod stopGatewayMessage(ret) [ Language = javascript ]
{
	if (ret == "") {
		//alert($$$Text("JDBC Gateway stopped successfully"));
	}
	else {
		alert(ret);
	}
	return;
}

ClassMethod StartJDBCGateway(pHost As %String, pPort As %String) As %String [ PublicList = tObjG, ZenMethod ]
{
	Kill %JDBCGateway
	Do LoadJDBCGTW^%apiGTW(pHost, pPort, "", "", .err, "")
	If (err="") && ($IsObject(%JDBCGateway("JavaGateway"))) {
		Try {
			Do getTempJGateway^%apiGTW(pHost, pPort)
			Do ##class(%Net.Remote.Service).Log(1, tObjG, "Invoking %Disconnect")
			Set tSC = %JDBCGateway("JavaGateway").%Disconnect()
		}
		Catch ex {
			Set tSC = ex.AsStatus()
		}
		If $$$ISERR(tSC) {
			Do ##class(%Net.Remote.Service).Log(3, %JDBCGateway("JavaGateway"), "Error in %Disconnect: "_$system.Status.GetErrorText(tSC))
			Set err = $system.Status.GetErrorText(tSC)
		}
	}
	Else {
		If err="" Set err = "Unexpected error in LoadJDBCGTW^%apiGTW"
	}
	Quit err
}

ClassMethod StopJDBCGateway(pHost As %String, pPort As %String) As %String [ PublicList = tObjG, ZenMethod ]
{
	Do getTempJGateway^%apiGTW($G(pHost), $G(pPort), "", "", "")
	If '$IsObject($G(tObjG)) {
		Set err = "Error instantiating an Object Gateway for Java"
	}
	Else {
		Set tSC = ##class(%Net.Remote.Service).StopGatewayObject(tObjG)
		Set err = $system.Status.GetErrorText(tSC)
	}
	Quit err
}

ClientMethod saveSettings() [ Language = javascript ]
{
	var isActive = zenPage.GetGatewayState();
	if (isActive == true) {
		zenPage.refreshStatus();
		alert($$$Text("The JDBC Gateway server is currently running -") + "\n" + $$$Text("To modify settings, you must stop it"));
		return;
	}

	var proxy = new zenProxy();
	proxy.port = zen('JDBCGatewayPort').getValue();
	proxy.log = zen('JDBCGatewayLog').getValue();
	proxy.javahome = zen('JavaHome').getValue();
	proxy.jvmargs = zen('JDBCGatewayJVMArgs').getValue();
	var msg = zenPage.SaveJDBCSettings(proxy);
	if (msg == '') {
		zenPage.JDBCGatewayPort = proxy.port;
		zenPage.JDBCGatewayLog = proxy.log;
		zenPage.JavaHome = proxy.javahome;
		zenPage.JDBCGatewayJVMArgs = proxy.jvmargs;
		try {
			if (zenPage.setModified) {
				zenPage.setModified(false);
			}
		} catch(ex) { }
		alert($$$Text("Settings saved"));
	}
	else if (msg == '*') {
		alert($$$Text("There are no modifications to save"));
	}
	else {
		alert($$$Text("An error occurred when saving the settings:") + "\n" + msg);
	}
}

/// Save settings on the server
ClassMethod SaveJDBCSettings(pProxy As %ZEN.proxyObject) As %String [ ZenMethod ]
{
	Set tSC = $$$OK
	Set msg = ""
	Try {
		If pProxy.port="" {
			Set pPort = 62972
		} Else {
			Set pPort = pProxy.port
		}

		// To do: Prevent saving a port that conflicts with a Gateway Object or Render Server

		Set tSC = ##class(Config.SQL).Get(.Properties)
		If ((Properties("JDBCGatewayPort")=pPort) && (Properties("JDBCGatewayLog")=pProxy.log) && (Properties("JavaHome")=pProxy.javahome) && (Properties("JDBCGatewayJVMArgs")=pProxy.jvmargs)) {
			Set msg = "*"
			Quit
		}
		If +pPort=$ZU(172,0) {
			Set msg = "JDBC cannot use the same port as the SuperServer"
			Quit
		}
		Kill WebPort Do ##class(%RoutineMgr).GetWebServerPort(.WebPort)
		If $G(WebPort) && (+pPort=WebPort) {
			Set msg = "JDBC cannot use the same port as the internal Web Server"
			Quit
		}
		If +pPort=80 {
			Set msg = "JDBC cannot use the same port as the Web Server"
			Quit
		}
		Set Properties("JDBCGatewayPort") = pPort
		Set Properties("JDBCGatewayLog") = pProxy.log
		Set Properties("JavaHome") = pProxy.javahome
		Set Properties("JDBCGatewayJVMArgs") = pProxy.jvmargs
		Set tSC = ##class(Config.SQL).Modify(.Properties)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}

	If $$$ISERR(tSC) {
		Set msg = ..EscapeHTML($System.Status.GetErrorText(tSC))
	}

	Quit msg
}

ClientMethod reloadPage() [ Language = javascript ]
{
	zenSetProp('btnReset','controlClass','commandButtonDisabled');
	zen('btnReset').setDisabled(true);
	zen('btnStart').setDisabled(true);
	zen('btnStop').setDisabled(true);
	zen('btnRefresh').setDisabled(true);
	zenPage.pageModified = false;
	setTimeout(function() {
		self.document.location.reload();
	}, 300);
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()

	// Load current settings
	Set tSC = ##class(Config.SQL).Get(.Properties)
	If $$$ISERR(tSC) Quit tSC
	
	
	Set tProperty = ""
	Set tProperty = $O(Properties(tProperty)) 
	While tProperty '= ""  {
		Set Component = ..%GetComponentById(tProperty)
		If $ISO(Component) {
			Set Component.value = Properties(tProperty)
		}
		Set tProperty = $O(Properties(tProperty)) 
	}

	// Update properties with value of saved settings
	Set ..JDBCGatewayPort = Properties("JDBCGatewayPort")
	Set ..JDBCGatewayLog = Properties("JDBCGatewayLog")
	Set ..JavaHome = Properties("JavaHome")
	Set ..JDBCGatewayJVMArgs = Properties("JDBCGatewayJVMArgs")

	Set tJH = ..%GetComponentById("JAVAHOMEValue")
	Set tJH.title = $$$Text("(This is a read-only field) Current value of O.S. environment variable JAVA_HOME:")_" "_..GetJAVAHOMEValue()

	Quit $$$OK
}

///  Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 0
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	Quit $$$OK
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ ForceGenerate, Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	zenPage.refreshStatus();
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("JDBC Gateway Server")
}

/// Toggle display of settings pane.
ClientMethod toggleSettings() [ Language = javascript ]
{
	this.settingsExpanded = !this.settingsExpanded;
	this.showExpand();
	this.adjustSizes();
}

ClientMethod showExpand() [ Language = javascript ]
{
	var span = self.document.getElementById('spanArrow');
	if (this.settingsExpanded) {
		span.innerHTML = '&#171;';
		span.title = $$$Text("Hide the settings panel");
	}
	else {
		span.innerHTML = '&#187;';
		span.title = $$$Text("Show the settings panel");
	}
}

/// Adjust sizes of components on the page.
ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		var settingsDiv = zen('settingsPane').getEnclosingDiv();
		settingsDiv.style.display = 'block';

		// find size of window
		var winWidth = zenGetWindowWidth();
		var propWidth = 5;
		if (!this.settingsExpanded) {
			var statusWidth = winWidth - 50;
		} else {
			propWidth = 400;
			var statusWidth = winWidth - propWidth - 50;
		}
		statusWidth = Math.max(statusWidth,100);
		zen('statusPane').getEnclosingDiv().style.width = statusWidth + 'px';
		settingsDiv.style.width = propWidth + 'px';
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

ClientMethod onunloadHandler() [ Language = javascript ]
{
	if (zenPage.pageModified) {
		return $$$Text("Changes made to the configuration will be lost if you leave this page.");
	}
	return true;
}

}
