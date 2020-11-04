/// System Management Portal - System Administration - Connectivity - XSLT Gateway Server Settings & Status
Class %CSP.UI.Portal.XSLTGatewayServer Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.XSLTGatewayServer.zen";

Parameter HELPADDRESS = "Home, Configuration, XSLT Gateway Server";

/// Displayed name of this page.
Parameter PAGENAME = "XSLT Gateway Server";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property JAVAHOMEValue As %String [ InitialExpression = {..GetJAVAHOMEValue()} ];

Property XSLTGatewayHost As %String;

Property XSLTGatewayPort As %String;

Property XSLTGatewayJDKVersion As %String;

Property XSLTGatewayLogFile As %String;

Property XSLTGatewayJavaHome As %String;

Property XSLTGatewayJVMArgs As %String;

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
<button id="btnSave" caption="Save" disabled="false" controlClass="commandButton" title="Save these settings to be used the next time that the XSLT Gateway Server is started" onclick="zenPage.saveSettings();"/>
<button id="btnReset" caption="Reset" disabled="false" controlClass="commandButton" title="Reload the page to get the updated values for the settings" onclick="zenPage.reloadPage();return false;"/>
<button id="btnTest" caption="Test" disabled="false" controlClass="commandButton" title="Run a sample XSLT" onclick="zenPage.testExample();"/>
</hgroup>
<spacer height="10" />
<group id="id_XSLTGatewayHost" hidden="true" label="Host" title="Machine name or TCP address on which the XSLT Gateway will run.  The default is 127.0.0.1.">
<text name="XSLTGatewayHost" id="XSLTGatewayHost" value="" size="40" maxlength="255" onchange="zenPage.settingsModified(true);" />
</group>
<group id="id_XSLTGatewayPort" label="Port Number" title="TCP port number to be used exclusively by the XSLT Gateway.">
<text name="XSLTGatewayPort" id="XSLTGatewayPort" value="" size="10" onchange="zenPage.settingsModified(true);" />
</group>
<group id="id_XSLTGatewayJDKVersion" label="Java Version" title="Java version used to select the intended version of InterSystems .jar files.  The default is Java 1.7.">
<select name="XSLTGatewayJDKVersion" id="XSLTGatewayJDKVersion" label="" valueList="JDK17,JDK18" displayList="Java 1.7,Java 1.8" showEmpty="false" controlStyle="width:90px;" value="" onchange="zenPage.settingsModified(true);"/> 
</group>
<hgroup id="id_XSLTGatewayLogFile" label="Log File" title="Optional. Fully qualified name of the XSLT Gateway log file, usually for trouble-shooting.">
<text id="XSLTGatewayLogFile" size="40" maxlength="260" onchange="zenPage.settingsModified(true);" />
<button id="LogDirBrowse" caption="Browse..." containerStyle="padding-left: 2px;" onclick="zenPage.browseSelect('XSLTGatewayLogFile','*.*');" />
</hgroup>
<hgroup id="id_XSLTGatewayJavaHome" label="Java Home Directory" title="Directory that is the Java Home of the JVM to be used by the XSLT Gateway Server. If there is a default JVM on the machine this field may be left blank.">
<text id="XSLTGatewayJavaHome" size="40" maxlength="260" onchange="zenPage.settingsModified(true);" />
<button id="JavaHomeBrowse" caption="Browse..." containerStyle="padding-left: 2px;" onclick="zenPage.browseSelect('XSLTGatewayJavaHome','showdirectoryonly');" />
</hgroup>
<group id="id_XSLTGatewayJVMArgs" label="JVM Arguments" title="Optional JVM arguments to be added to the command used to start the XSLT Gateway.">
<text name="XSLTGatewayJVMArgs" id="XSLTGatewayJVMArgs" value="" size="40" onchange="zenPage.settingsModified(true);" />
</group>
<text id="JAVAHOMEValue" readOnly="true" label="JAVA_HOME Environment Variable" size="40" controlStyle="background:#EAEAEA;" value="#(%page.JAVAHOMEValue)#" hint="" title="Current value of O.S. environment variable JAVA_HOME." />
<spacer height="30" />
<label name="id_Note" id="id_Note" hidden="true" label="Settings can only be modified when the XSLT Gateway is stopped." labelStyle="font-size: 13px; font-weight: normal; text-wrap: normal;" />
<hidden name="browseselect" id="browseselect" />
</form>
<spacer height="30" />
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
<button id="btnStart" caption="Start" controlClass="commandButton" title="Start the XSLT Gateway Server" onclick="zenPage.startGateway();"/>
<button id="btnStop" caption="Stop" controlClass="commandButton" title="Stop the XSLT Gateway Server" onclick="zenPage.stopGateway();"/>
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
<parameter id="idGatewayName" name="GatewayName" value="XSLTGateway" />
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
		ctlState.innerHTML = $$$Text("XSLT Gateway is running");
		ctlState.style.color = 'green';
		zenSetProp('btnStart','controlClass','commandButtonGray');
		zenSetProp('btnStop','controlClass','commandButton');
	}
	else {
		ctlState.innerHTML = $$$Text("XSLT Gateway is stopped");
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

/// Find out whether the XSLT Gateway is active or inactive
ClassMethod GetGatewayState() As %Boolean [ ZenMethod ]
{
	Set tHost = $G(^%SYS("XSLTGateway","Host"))
	Set:tHost="" tHost = ..GetDefault("Host")
	Set tPort = $G(^%SYS("XSLTGateway","Port"))
	Set:'tPort tPort = ..GetDefault("Port")
	Quit ##class(%Net.Remote.Service).IsGatewayRunning(tHost, tPort, 0, .tSC, 1)
}

ClientMethod enableOrDisableSettingsForm(enable) [ Language = javascript ]
{
	if (enable == true) {
		// Enable form
		zenSetProp('btnSave','disabled',false);
		zenSetProp('btnSave','controlClass','commandButton');
		zenSetProp('XSLTGatewayHost','disabled',false);
		zenSetProp('XSLTGatewayPort','disabled',false);
		zenSetProp('XSLTGatewayJDKVersion','disabled',false);
		zenSetProp('XSLTGatewayLogFile','disabled',false);
		zenSetProp('XSLTGatewayJavaHome','disabled',false);
		zenSetProp('XSLTGatewayJVMArgs','disabled',false);
		zenSetProp('LogDirBrowse','hidden',false);
		zenSetProp('JavaHomeBrowse','hidden',false);
		zenSetProp('id_Note','hidden',true);
	}
	else {
		// Disable form
		zenSetProp('btnSave','disabled',true);
		zenSetProp('btnSave','controlClass','commandButtonDisabled');
		zenSetProp('XSLTGatewayHost','disabled',true);
		zenSetProp('XSLTGatewayPort','disabled',true);
		zenSetProp('XSLTGatewayJDKVersion','disabled',true);
		zenSetProp('XSLTGatewayLogFile','disabled',true);
		zenSetProp('XSLTGatewayJavaHome','disabled',true);
		zenSetProp('XSLTGatewayJVMArgs','disabled',true);
		zenSetProp('LogDirBrowse','hidden',true);
		zenSetProp('JavaHomeBrowse','hidden',true);
		zenSetProp('id_Note','hidden',false);
	}
}

/// Start the XSLT Gateway server.
ClientMethod startGateway() [ Language = javascript ]
{
	var isActive = zenPage.GetGatewayState();
	if (isActive == true) {
		alert($$$Text("The XSLT Gateway server is already running"));
		return;
	}

	// Check if settings were modified in this page and were not saved
	var host = zen('XSLTGatewayHost').value;
	var port = zen('XSLTGatewayPort').value;
	var jdk = zen('XSLTGatewayJDKVersion').value;
	var log = zen('XSLTGatewayLogFile').value;
	var javahome = zen('XSLTGatewayJavaHome').value;
	var jvmargs = zen('XSLTGatewayJVMArgs').value;
	if ((host != zenPage.XSLTGatewayHost) || (port != zenPage.XSLTGatewayPort) || (jdk != zenPage.XSLTGatewayJDKVersion) || 
		(log != zenPage.XSLTGatewayLogFile) || (javahome != zenPage.XSLTGatewayJavaHome) || (jvmargs != zenPage.XSLTGatewayJVMArgs)) {
		alert($$$Text("Please save modified settings before starting the XSLT Gateway"));
		return;
	}

	// Check if settings were modified by another process
	if (zenPage.CheckForChanges(false,host,port,jdk,log,javahome,jvmargs)) {
		alert($$$Text("The XSLT settings have been modified by another process, please click button 'Reset' to update the settings panel"));
		return;
	}

	if (!confirm($$$Text("Do you wish to start the XSLT Gateway server?"))) {
		return;
	}

	zen('refreshTimer').clearTimer();
	var ctlState = document.getElementById('id_State');
	ctlState.innerHTML = $$$Text("XSLT Gateway is starting, please wait...");
	ctlState.style.color = 'black';
	zenPage.enableOrDisableSettingsForm(false);
	zenSetProp('btnStart','controlClass','commandButtonDisabled');
	zenSetProp('btnStart','disabled',true);
	zenSetProp('btnStop','controlClass','commandButtonDisabled');
	zenSetProp('btnStop','disabled',true);
	zenSetProp('btnRefresh','controlClass','commandButtonDisabled');
	zenSetProp('btnRefresh','disabled',true);

	setTimeout(function() {
		var ret = zenPage.StartXSLTGateway(host,port,jdk,log,javahome,jvmargs);
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
		//alert($$$Text("XSLT Gateway started successfully"));
	}
	else {
		alert(ret);
	}
	return "done";
}

/// Stop the XSLT Gateway server.
ClientMethod stopGateway() [ Language = javascript ]
{
	var isActive = zenPage.GetGatewayState();
	if (isActive == false) {
		alert($$$Text("The XSLT Gateway server is already stopped"));
		return;
	}

	// Check if host or port was modified by another process
	var host = zen('XSLTGatewayHost').value;
	var port = zen('XSLTGatewayPort').value;
	if (zenPage.CheckForChanges(true,host,port)) {
		alert($$$Text("The XSLT Gateway host or port has been modified by another process, please click button 'Reset' to update the settings panel"));
		return;
	}

	if (!confirm($$$Text("Do you really wish to stop the XSLT Gateway server?") + "\n" + $$$Text("Note that ongoing XSLT connections will be affected."))) {
		return;
	}

	zen('refreshTimer').clearTimer();
	zenSetProp('btnStop','controlClass','commandButtonDisabled');
	zenSetProp('btnStop','disabled',true);
	zenSetProp('btnStart','disabled',true);
	zenSetProp('btnRefresh','controlClass','commandButtonDisabled');
	zenSetProp('btnRefresh','disabled',true);
	var ret = zenPage.StopXSLTGateway(host,port);
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
ClassMethod CheckForChanges(pOnlyPortOrHost As %Boolean = 0, pHost As %String, pPort As %String, pJDKVersion As %String, pLogFile As %String, pJavaHome As %String, pJVMArgs As %String) As %Boolean [ ZenMethod ]
{
	Set tHost = $G(^%SYS("XSLTGateway","Host"))
	Set:tHost="" tHost = ..GetDefault("Host")
	Set:pHost="" pHost = ..GetDefault("Host")
	If pHost'=tHost Quit 1

	Set tPort = $G(^%SYS("XSLTGateway","Port"))
	Set:'tPort tPort = ..GetDefault("Port")
	Set:pPort="" pPort = ..GetDefault("Port")
	If pPort'=tPort Quit 1

	If pOnlyPortOrHost Quit 0

	Set tJDKVersion = $G(^%SYS("XSLTGateway","JDKVersion"))
	Set:tJDKVersion="" tJDKVersion = ..GetDefault("JDKVersion")
	Set:$G(pJDKVersion)="" pJDKVersion = ..GetDefault("JDKVersion")
	If pJDKVersion'=tJDKVersion Quit 1

	Set tLogFile = $G(^%SYS("XSLTGateway","LogFile"))
	Set:tLogFile="" tLogFile = ..GetDefault("LogFile")
	Set:$G(pLogFile)="" pLogFile = ..GetDefault("LogFile")
	If pLogFile'=tLogFile Quit 1

	Set tJavaHome = $G(^%SYS("XSLTGateway","JavaHome"))
	Set:tJavaHome="" tJavaHome = ..GetDefault("JavaHome")
	Set:$G(pLogFile)="" pLogFile = ..GetDefault("JavaHome")
	If pJavaHome'=tJavaHome Quit 1

	Set tJVMArgs = $G(^%SYS("XSLTGateway","JVMArgs"))
	Set:tJVMArgs="" tJVMArgs = ..GetDefault("JVMArgs")
	Set:$G(pJVMArgs)="" pJVMArgs = ..GetDefault("JVMArgs")
	If pJVMArgs'=tJVMArgs Quit 1

	Quit 0
}

ClientMethod stopGatewayMessage(ret) [ Language = javascript ]
{
	if (ret == "") {
		//alert($$$Text("XSLT Gateway stopped successfully"));
	}
	else {
		alert(ret);
	}
	return;
}

ClassMethod StartXSLTGateway(pHost As %String, pPort As %String, pJDKVersion As %String, pLogFile As %String, pJavaHome As %String, pJVMArgs As %String) As %String [ ZenMethod ]
{
	Set err = ""
	Set tObjG = ##class(%Net.Remote.Java.XSLTGateway).StartGateway(.tSC, $G(pPort), $G(pHost), $G(pJDKVersion), $G(pJavaHome), $G(pLogFile), $G(pJVMArgs))
	If $$$ISERR($G(tSC)) {
		Set err = $system.Status.GetErrorText(tSC)
	}
	ElseIf '$IsObject(tObjG) {
		Set err = "Unable to get a Java Gateway object"
	}
	Quit err
}

ClassMethod StopXSLTGateway(pHost As %String, pPort As %String) As %String [ ZenMethod ]
{
	Set tSC = ##class(%Net.Remote.Java.XSLTGateway).ShutdownGateway(pPort, pHost)
	If $$$ISOK(tSC) {
		Quit ""
	}
	Else {
		Quit $system.Status.GetErrorText(tSC)
	}
}

ClientMethod saveSettings() [ Language = javascript ]
{
	var isActive = zenPage.GetGatewayState();
	if (isActive == true) {
		zenPage.refreshStatus();
		alert($$$Text("The XSLT Gateway server is currently running -") + "\n" + $$$Text("To modify settings, you must stop it"));
		return;
	}

	var proxy = new zenProxy();
	proxy.host = zen('XSLTGatewayHost').getValue();
	proxy.port = zen('XSLTGatewayPort').getValue();
	proxy.jdk = zen('XSLTGatewayJDKVersion').getValue();
	proxy.log = zen('XSLTGatewayLogFile').getValue();
	proxy.javahome = zen('XSLTGatewayJavaHome').getValue();
	proxy.jvmargs = zen('XSLTGatewayJVMArgs').getValue();
	var msg = zenPage.SaveXSLTSettings(proxy);
	if (msg == '') {
		zenPage.XSLTGatewayHost = proxy.host;
		zenPage.XSLTGatewayPort = proxy.port;
		zenPage.XSLTGatewayJDKVersion = proxy.jdk;
		zenPage.XSLTGatewayLogFile = proxy.log;
		zenPage.XSLTGatewayJavaHome = proxy.javahome;
		zenPage.XSLTGatewayJVMArgs = proxy.jvmargs;
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
ClassMethod SaveXSLTSettings(pProxy As %ZEN.proxyObject) As %String [ ZenMethod ]
{
	Set tSC = $$$OK
	Set msg = ""
	Try {
		If pProxy.port="" {
			Set pPort = ..GetDefault("Port")
		} Else {
			Set pPort = pProxy.port
		}

		Merge Properties = ^%SYS("XSLTGateway")
		If ($G(Properties("Host"))=pProxy.host) && ($G(Properties("Port"))=pPort) && ($G(Properties("JDKVersion"))=pProxy.jdk) && 
			($G(Properties("LogFile"))=pProxy.log) && ($G(Properties("JavaHome"))=pProxy.javahome) && ($G(Properties("JVMArgs"))=pProxy.jvmargs) {
			Set msg = "*"
			Quit
		}
		If +pPort=$ZU(172,0) {
			Set msg = "The XSLT Gateway cannot use the same port as the SuperServer"
			Quit
		}
		Kill WebPort Do ##class(%RoutineMgr).GetWebServerPort(.WebPort)
		If $G(WebPort) && (+pPort=WebPort) {
			Set msg = "The XSLT Gateway cannot use the same port as the internal Web Server"
			Quit
		}
		If +pPort=80 {
			Set msg = "The XSLT Gateway cannot use the same port as the Web Server"
			Quit
		}
		Set ^%SYS("XSLTGateway","Host") = pProxy.host
		Set ^%SYS("XSLTGateway","Port") = pPort
		Set ^%SYS("XSLTGateway","JDKVersion") = pProxy.jdk
		Set ^%SYS("XSLTGateway","LogFile") = pProxy.log
		Set ^%SYS("XSLTGateway","JavaHome") = pProxy.javahome
		Set ^%SYS("XSLTGateway","JVMArgs") = pProxy.jvmargs
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}

	If $$$ISERR(tSC) {
		Set msg = ..EscapeHTML($System.Status.GetErrorText(tSC))
	}

	Quit msg
}

/// Get the default value for a property
ClassMethod GetDefault(pProperty As %String) As %String
{
	If $G(pProperty)="" Quit ""
	Quit $Parameter("%Net.Remote.Java.XSLTGateway",pProperty)
}

ClientMethod reloadPage() [ Language = javascript ]
{
	zenSetProp('btnReset','controlClass','commandButtonDisabled');
	zen('btnReset').setDisabled(true);
	zen('btnTest').setDisabled(true);
	zen('btnStart').setDisabled(true);
	zen('btnStop').setDisabled(true);
	zen('btnRefresh').setDisabled(true);
	zenPage.pageModified = false;
	setTimeout(function() {
		self.document.location.reload();
	}, 300);
}

ClientMethod testExample() [ Language = javascript ]
{
	// Check if settings were modified in this page and were not saved
	var host = zen('XSLTGatewayHost').value;
	var port = zen('XSLTGatewayPort').value;
	var jdk = zen('XSLTGatewayJDKVersion').value;
	var log = zen('XSLTGatewayLogFile').value;
	var javahome = zen('XSLTGatewayJavaHome').value;
	var jvmargs = zen('XSLTGatewayJVMArgs').value;
	if ((host != zenPage.XSLTGatewayHost) || (port != zenPage.XSLTGatewayPort) || (jdk != zenPage.XSLTGatewayJDKVersion) || 
		(log != zenPage.XSLTGatewayLogFile) || (javahome != zenPage.XSLTGatewayJavaHome) || (jvmargs != zenPage.XSLTGatewayJVMArgs)) {
		alert($$$Text("Please save modified settings before testing the XSLT Gateway"));
		return;
	}

	// Check if settings were modified by another process
	if (zenPage.CheckForChanges(false,host,port,jdk,log,javahome,jvmargs)) {
		alert($$$Text("The XSLT settings have been modified by another process, please click button 'Reset' to update the settings panel"));
		return;
	}

	var url = zenLink('%CSP.UI.Portal.Dialog.XSLTGatewayTest.zen');
	zenLaunchPopupWindow(url,'XSLTTest','status,resizable=yes,width=650,height=550');
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

	case 'XSLTTest':
		zenPage.refreshStatus();
		break;
	}
	
	return true;
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	
	// Load current settings and update page properties
	Merge Properties = ^%SYS("XSLTGateway")
	For tProperty="Host","Port","JDKVersion","LogFile","JavaHome","JVMArgs" {
		Set tValue = $S($G(Properties(tProperty))'="":Properties(tProperty),1:..GetDefault(tProperty))
		Set ..%GetComponentById("XSLTGateway"_tProperty).value = tValue
		Set $Property($this,"XSLTGateway"_tProperty) = tValue
	}
	Set ..%GetComponentById("JAVAHOMEValue").title = $$$Text("(This is a read-only field) Current value of O.S. environment variable JAVA_HOME:")_" "_..GetJAVAHOMEValue()

	// Set into LocatorHeader so DrawTitle can use it
	Set ..LocatorHeader = $$$Text("XSLT Gateway Server")
	Set ..StdTitle = ..LocatorHeader

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
	Quit $$$Text("XSLT Gateway Server")
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
