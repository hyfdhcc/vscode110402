/// Base Zen application class for portal pages implemented using Zen.
Class %ZEN.Portal.Application Extends %ZEN.application [ System = 4 ]
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "InterSystems Portal";

Parameter DOMAIN = "%Utility";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "/csp/sys/%25CSP.Portal.Home.zen";

/// This Style block contains application-wide CSS style definitions for css3
XData CSS3Style
{
<style type="text/css">
body {
	font-family: Arial;
}
/* overrider locator bar style */
.locatorBarTable td {
	background: rgb(53,107,141);
	background-image: none;
	background-repeat: repeat-x;
	border-bottom: 1px darkblue solid;
	padding-bottom: 1px;
	color: white;
}

.locatorBarLinks {
	color: white;
}
.locatorBarLinks a {
	color: white;
}
.locatorBarLinks a:visited {
	color: white;
}
.locatorBarLinks a:hover {
	color: darkred;
	background: #FFFAE7;
}
.locatorBarSelect {
	color: white;
}


.portalPropertyPanelTitle {
	color: white;
	font-size: 12pt;
	padding: 5px;
}

.portalPropertyPanelCommands {
	color: white;
	background: rgb(53,107,141);
	width: 100px;
	text-align: center;
	font-size: 9pt;
	border: 1px solid gray;
}

.portalTitle {
	width: 100%;
	height: 60px;
	position: relative;
	border-bottom: 1px solid gray;
	background: rgb(232,231,226);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	background: linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
}

.portalTitleInfoBox {
	position: absolute;
	bottom: 0px;
	left: 350px;
}

.portalTitleInfoLabel {
	padding-left: 10px;
	font-size: 9pt;	
	color: #606060;
	text-align: left;
}

.portalTitleInfoVal {
	font-size: 9pt;	
	color: black;
	text-align: left;
	font-weight: bold;
}

.portalTitleListBox {
	position: absolute;
	top: 5px;
	left: 20px;
	font-size: 9pt;	
}

.portalTitleMenuBox {
	position: absolute;
	top: 5px;
	left: 100px;
	font-size: 9pt;	
}
/* old color: #3A5162; new color: #3ba4dc?*/
.portalTitleLink {
	color: #3b84bc;
	text-decoration: none;
}
/* ifactory color: #98923a; new color:#f6f5f3;*/
.portalTitleLink:hover {
	color: #98923a;
}

.portalTitleTabBox {
	position: absolute;
	color: white;
	font-size: 16px;
	bottom: 0px;
	left: 20px;
	width: 300px;
	height: 25px;
	padding-left: 15px;
	padding-right: 15px;
	padding: 5px;

	border-top-right-radius: 5px;
	border-top-left-radius: 5px;

	overflow: hidden;
	background: rgb(53,107,141);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(53,107,141)), color-stop(1.0,rgb(23,77,101)));
	background: -moz-linear-gradient(top, rgb(53,107,141), rgb(23,77,101));
	background: linear-gradient(top, rgb(53,107,141), rgb(23,77,101));
	text-shadow: #F0F0F0 1px 1px 6px;
}

.portalLogoBox {
	position: absolute;
	top: 0px;
	padding: 10px;
	padding-bottom: 4px;
	padding-right: 30px;
	right: 0px;
	text-align: center;
	background: rgb(232,231,226);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	background: linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	z-index: 3;
}

.portalLogo {
	color: rgb(53,107,141);
	position: relative;
	font-weight: bold;
	font-size: 12pt;
	top: 0px;
	right: 0px;
	border: 2px solid rgb(53,107,141);
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;
	border-radius: 4px;
	background: #E0E0F0;
}

.portalLogoSub {
	position: relative;
	color: #808080;
	font-size: 8pt;
	top: 3px;
	right: 0px;
}

/* overrides of Finder styles */
.finderItemSelected {
	background: #356B8D;
}

.finderItemSelected {
	background: linear-gradient(top, rgb(53,107,141), rgb(23,77,101));
}

.finderListRowSelected {
	background: #2F6280;
}

.finderItem, .finderItemOdd,.finderItemSelected, .finderItemDisabled {
	border-bottom: 1px solid #356B8D;
}


/* command button styles */
.commandButton {
	background: rgb(53,107,141);
	color: #E0E0E0;
	text-decoration: none;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 2px solid gray;
    border-bottom: 2px solid gray;
    cursor: pointer;
}

.commandButtonRemove {
	background: rgb(141,53,53);
	color: #E0E0E0;
	text-decoration: none;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 2px solid gray;
    border-bottom: 2px solid gray;
    cursor: pointer;
}

.commandButtonDisabled {
	background: darkgray;
	color: #545454;
	text-decoration: none;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 2px solid gray;
    border-bottom: 2px solid gray;
}

.commandButton:hover {
	background: rgb(53,107,141);
	color: white;
	background-image: url(portal/button_hover.png);
	background-repeat: repeat-x;
}

.commandButtonRemove:hover {
	background: rgb(141,53,53);
	color: white;
	background-image: url(portal/button_red_hover.png);
	background-repeat: repeat-x;
}

img {
	border: none;
}

/* overrides of tablePane */
table.tpTable {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	border: 2px solid #F1F0E7;
	padding: 2px;
}

/* @doc="Column header." */
table.tpTable th {
	color: #3b84bc;
	border: none;
	background: white;
	font-weight: bold;
	text-align: left;
	padding: 2px;
	overflow: hidden;
}

/* @doc="Selected column header." */
table.tpTable th.tpHdrSelected {
	color: #3b84bc;
	background: white;
}

table.tpTable td {
	border: none;
	padding: 2px;
	overflow: hidden;
}

table.tpTable tr.tpSelected td {
	font-weight: normal;
	border: none;
	padding-top: 2px;
	padding-bottom: 2px;
}

table.tpTable tr.tpSelected {
	color: black;
	border: none;
	background: #F3E799;
	background-image: none;
}
 
/* @doc="Style for rows when not using zebra styling." */
.tpRow {
	color: black;
	background: white;
}

/* @doc="Style for odd-rows when using zebra styling." */
.tpOdd {
	color: black;
	background: #F1F0E7;
}
/* @doc="Style for even-rows when using zebra styling." */
.tpEven {
	color: black;	
	background: white;
}

/* @doc="Cell containing a link." */
.tpAction {
	font-size: 0.9em;
}

.tpAction a {
	white-space: nowrap;
	color: #3b84bc;
}

.tpAction a:hover {
	color: #98923a;
}

.tpAction a:link {
	color: #3b84bc;
}

.tpAction a:active {
	color: #3b84bc;
}

/* @doc="Table around navigator bar." */
.tnbrTable {
	background: #DBE0E6;
	border: 1px solid #F1F0E7;
	border-radius:3px;
	padding: 1px;
}
/* @doc="Buttons within navigator bar." */
.tnbrPagingButtons {
	border: 1px solid #B0B0B0;
}
.tnbrFilter {
	color: #404040;
}
.tnbrFilter input {
	border: 1px solid #B0B0B0;
	padding-left: 2px;
}
/* @doc="Row count indicator." */
.tnbrFound {
	color: #404040;
}
/* combo boxes and dateText */
.comboboxInput {
	border-top: 1px solid #8080F0;
	border-bottom: 1px solid #8080F0;
	border-left: 1px solid #8080F0;
	border-right: none;
}

.comboboxDropDown {
	border: 1px solid #8080F0;
}

.comboboxImgButton {
	border-top: 1px solid #8080F0;
	border-bottom: 1px solid #8080F0;
	border-left: none;
	border-right: 1px solid #8080F0;
}

.comboboxTextButton {
	border: 1px solid #8080F0;
}

</style>
}

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
body {
	font-family: Arial;
}
/* overrider locator bar style */
.locatorBarTable td {
	background: rgb(53,107,141);
	background-image: none;
	background-repeat: repeat-x;
	border-bottom: 1px darkblue solid;
	padding-bottom: 1px;
	color: white;
}

.locatorBarLinks {
	color: white;
}
.locatorBarLinks a {
	color: white;
}
.locatorBarLinks a:visited {
	color: white;
}
.locatorBarLinks a:hover {
	color: darkred;
	background: #FFFAE7;
}
.locatorBarSelect {
	color: white;
}


.portalPropertyPanelTitle {
	color: white;
	font-size: 12pt;
	padding: 5px;
}

.portalPropertyPanelCommands {
	color: white;
	background: rgb(53,107,141);
	width: 100px;
	text-align: center;
	font-size: 9pt;
	border: 1px solid gray;
}

.portalTitle {
	width: 100%;
	height: 60px;
	position: relative;
	border-bottom: 1px solid gray;

	background: rgb(232,231,226);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType='0', startColorstr='#e8e7e2', endColorstr='#e0d9d9');
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
}

.portalTitleInfoBox {
	position: absolute;
	bottom: 0px;
	left: 350px;
}

.portalTitleInfoLabel {
	padding-left: 10px;
	font-size: 9pt;	
	color: #606060;
	text-align: left;
}

.portalTitleInfoVal {
	font-size: 9pt;	
	color: black;
	text-align: left;
	font-weight: bold;
}

.portalTitleListBox {
	position: absolute;
	top: 5px;
	left: 20px;
	font-size: 9pt;	
}

.portalTitleMenuBox {
	position: absolute;
	top: 5px;
	left: 100px;
	font-size: 9pt;	
}
/* old color: #3A5162; new color: #3ba4dc?*/
.portalTitleLink {
	color: #3b84bc;
	text-decoration: none;
}
/* ifactory color: #98923a; new color:#f6f5f3;*/
.portalTitleLink:hover {
	color: #98923a;
}

.portalTitleTabBox {
	position: absolute;
	color: white;
	font-size: 16px;
	bottom: 0px;
	left: 20px;
	width: 300px;
	height: 25px;
	padding-left: 15px;
	padding-right: 15px;
	padding: 5px;

	border-top-right-radius: 5px;
	border-top-left-radius: 5px;

	overflow: hidden;
	background: rgb(53,107,141);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType='0', startColorstr='#356b8d', endColorstr='#306080');
}

/* non-ie! */
.portalTitleTabBox:not([ie]) {
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(53,107,141)), color-stop(1.0,rgb(23,77,101)));
	background: -moz-linear-gradient(top, rgb(53,107,141), rgb(23,77,101));
	text-shadow: #F0F0F0 1px 1px 6px;
}

.portalLogoBox {
	position: absolute;
	top: 0px;
	padding: 10px;
	padding-bottom: 4px;
	padding-right: 30px;
	right: 0px;
	text-align: center;
	background: rgb(232,231,226);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	z-index: 3;
}

.portalLogo {
	color: rgb(53,107,141);
	position: relative;
	font-weight: bold;
	font-size: 12pt;
	top: 0px;
	right: 0px;
	border: 2px solid rgb(53,107,141);
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;
	border-radius: 4px;
	background: #E0E0F0;
}

.portalLogoSub {
	position: relative;
	color: #808080;
	font-size: 8pt;
	top: 3px;
	right: 0px;
}

/* overrides of Finder styles */
.finderItemSelected {
	background: #356B8D;
}

/* non-ie! */
.finderItemSelected:not([ie]) {
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(53,107,141)), color-stop(1.0,rgb(23,77,101)));
	background: -moz-linear-gradient(top, rgb(53,107,141), rgb(23,77,101));
}

.finderListRowSelected {
	background: #2F6280;
}

.finderItem, .finderItemOdd,.finderItemSelected, .finderItemDisabled {
	border-bottom: 1px solid #356B8D;
}


/* command button styles */
.commandButton {
	background: rgb(53,107,141);
	color: #E0E0E0;
	text-decoration: none;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 2px solid gray;
    border-bottom: 2px solid gray;
    cursor: pointer;
}

.commandButtonRemove {
	background: rgb(141,53,53);
	color: #E0E0E0;
	text-decoration: none;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 2px solid gray;
    border-bottom: 2px solid gray;
    cursor: pointer;
}

.commandButtonDisabled {
	background: darkgray;
	color: #545454;
	text-decoration: none;
	padding: 3px;
	padding-left: 10px;
	padding-right: 10px;
	-moz-border-radius: 5px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 2px solid gray;
    border-bottom: 2px solid gray;
}

.commandButton:hover {
	background: rgb(53,107,141);
	color: white;
	background-image: url(portal/button_hover.png);
	background-repeat: repeat-x;
}

.commandButtonRemove:hover {
	background: rgb(141,53,53);
	color: white;
	background-image: url(portal/button_red_hover.png);
	background-repeat: repeat-x;
}

img {
	border: none;
}

/* overrides of tablePane */
table.tpTable {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	border: 2px solid #F1F0E7;
	padding: 2px;
}

/* @doc="Column header." */
table.tpTable th {
	color: #3b84bc;
	border: none;
	background: white;
	font-weight: bold;
	text-align: left;
	padding: 2px;
	overflow: hidden;
}

/* @doc="Selected column header." */
table.tpTable th.tpHdrSelected {
	color: #3b84bc;
	background: white;
}

table.tpTable td {
	border: none;
	padding: 2px;
	overflow: hidden;
}

table.tpTable tr.tpSelected td {
	font-weight: normal;
	border: none;
	padding-top: 2px;
	padding-bottom: 2px;
}

table.tpTable tr.tpSelected {
	color: black;
	border: none;
	background: #F3E799;
	background-image: none;
}
 
/* @doc="Style for rows when not using zebra styling." */
.tpRow {
	color: black;
	background: white;
}

/* @doc="Style for odd-rows when using zebra styling." */
.tpOdd {
	color: black;
	background: #F1F0E7;
}
/* @doc="Style for even-rows when using zebra styling." */
.tpEven {
	color: black;	
	background: white;
}

/* @doc="Cell containing a link." */
.tpAction {
	font-size: 0.9em;
}

.tpAction a {
	white-space: nowrap;
	color: #3b84bc;
}

.tpAction a:hover {
	color: #98923a;
}

.tpAction a:link {
	color: #3b84bc;
}

.tpAction a:active {
	color: #3b84bc;
}

/* @doc="Table around navigator bar." */
.tnbrTable {
	border: 1px solid gray;
	background: #DCE7F1;
	padding: 1px;
}
/* @doc="Buttons within navigator bar." */
.tnbrPagingButtons {
	border: 1px solid gray;
}

/* combo boxes and dateText */
.comboboxInput {
	border-top: 1px solid #8080F0;
	border-bottom: 1px solid #8080F0;
	border-left: 1px solid #8080F0;
	border-right: none;
}

.comboboxDropDown {
	border: 1px solid #8080F0;
}

.comboboxImgButton {
	border-top: 1px solid #8080F0;
	border-bottom: 1px solid #8080F0;
	border-left: none;
	border-right: 1px solid #8080F0;
}

.comboboxTextButton {
	border: 1px solid #8080F0;
}

</style>
}

/// Define any context links for the context menu in the header
/// piece 1: caption (if left null, a menu seperator will be built)
/// piece 2: URL (this is required entry)
/// piece 3: JS function name (if defined is a javascript to call such as "zenPage.save()")
/// Note that all security processing is performed in the page's CheckContextLinks() method.
ClassMethod GetContextLinks(Output pLinks) As %Status
{
	// create list of jump targets and associated URL
	// Manager tasks
	Set pLinks($I(n)) = $LB($$$Text("Configure Namespaces"),"/csp/sys/mgr/%25CSP.UI.Portal.Namespaces.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Configure Databases"),"/csp/sys/mgr/%25CSP.UI.Portal.Databases.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Configure Memory"),"/csp/sys/mgr/%25CSP.UI.Portal.MemoryStartup.zen","")
	Set pLinks($I(n)) = $LB("","","")

	// Security tasks
	Set pLinks($I(n)) = $LB($$$Text("Manage Web Applications"),"/csp/sys/sec/%25CSP.UI.Portal.Applications.WebList.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Manage Users"),"/csp/sys/sec/%25CSP.UI.Portal.Users.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Manage Roles"),"/csp/sys/sec/%25CSP.UI.Portal.Roles.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Manage Services"),"/csp/sys/sec/%25CSP.UI.Portal.Services.zen","")
	Set pLinks($I(n)) = $LB($$$Text("Manage Resources"),"/csp/sys/sec/%25CSP.UI.Portal.Resources.zen","")
	Set pLinks($I(n)) = $LB("","","")

	// Explorer tasks
	Set pLinks($I(n)) = $LB($$$Text("View SQL"),"/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen","")
	Set pLinks($I(n)) = $LB($$$Text("View Classes"),"/csp/sys/exp/%25CSP.UI.Portal.ClassList.zen","")
	Set pLinks($I(n)) = $LB($$$Text("View Routines"),"/csp/sys/exp/%25CSP.UI.Portal.RoutineList.zen","")
	Set pLinks($I(n)) = $LB($$$Text("View Globals"),"/csp/sys/exp/%25CSP.UI.Portal.GlobalList.zen","")
	Set pLinks($I(n)) = $LB("","","")

	// Operator tasks
	Set pLinks($I(n)) = $LB($$$Text("View System Dashboard"),"/csp/sys/op/UtilDashboard.csp","")
	Set pLinks($I(n)) = $LB($$$Text("View Locks"),"/csp/sys/op/%25CSP.UI.Portal.Locks.zen","")
	If $System.Security.Check("%DB_CACHESYS","READ,WRITE") {
		Set pLinks($I(n)) = $LB($$$Text("View Processes"),"/csp/sys/op/%25CSP.UI.Portal.Processes.zen","")
		Set pLinks($I(n)) = $LB($$$Text("View Console Log"),"/csp/sys/op/UtilSysConsoleLog.csp","")
	}
	#; The Background Tasks CSP page needs an extra check because it does not have its own resource, and should not be shown to users without %Admin_Operate:USE.
	If $system.Security.Check("%Admin_Operate","USE") Set pLinks($I(n)) = $LB($$$Text("View Background Tasks"),"/csp/sys/%25CSP.UI.Portal.BackgroundTaskList.zen","")

	Quit $$$OK
}

/// Provide any quick links for pages.
ClassMethod GetQuickLinks(Output pLinks) As %Status
{
	Set pLinks("Home") = ..#HOMEPAGE
	Quit $$$OK
}

/// Draw the HTML contents of the title area for portal pages.
Method %DrawTitleHTML(pProduct As %String, pTitle As %String, ByRef pSmallMenu, ByRef pLocatorMenu) As %Status
{
	#; show which server we are connected to
	Set tInstance = $P($ZU(86),"*",2)
	Set tLicensedTo = $$CustomerName^%SYS.LICENSE
	Set tServerStyle = "background: #60A060; color: white; border-radius: 2px;padding-left: 4px;"
	Set:%page.cssLevel'=3 tServerStyle = tServerStyle_"-moz-border-radius: 2px;"
	Set tUserName = $UserName
	Set tServerName = $zu(110)	
	Set IsEMSSetUp = ##class(%SYS.EMS).IsEMSSetUp()
	If IsEMSSetUp {
		Set EMSState = ##class(%SYS.EMS).GetInstanceState(.isManaged,.services)
		Set EMSServices = ""
		If isManaged {
			If services = "" Set services = $$$Text("None")
			Set EMSServices = $$$Text("Managed Services:")_" "_services
		}
	}
	
	#; special values for "demo" mode
	If (0) {
		Set tServerName = "HAL9000"
		Set tInstance = "Ensemble2011"
		Set tLicensedTo = "Global MegaCorp LTD"
		Set tUserName = "Dave"
	}

	Set tSystemMode = $G(^%SYS("SystemMode"))
	Set tSystemStyle = ""
	Set tSystemMsg = ""
	If (tSystemMode = "LIVE") {
		Set tSystemMsg = $$$TextHTML("This is a Live System")
		Set tSystemStyle = "text-align: center; background: red; color: white; font-size:12pt; padding:2px; border: 1px solid #404040;"
		Set:%page.cssLevel'=3 tSystemStyle = tSystemStyle_" -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "TEST") {
		Set tSystemMsg = $$$TextHTML("This is a Test System")
		Set tSystemStyle = "text-align: center; background: #D0D0D0; color: #404040; font-size:12pt; padding:2px; border: 1px solid #404040;"
		Set:%page.cssLevel'=3 tSystemStyle = tSystemStyle_" -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "FAILOVER") {
		Set tSystemMsg = $$$TextHTML("This is a Failover System")
		Set tSystemStyle = "text-align: center; background: #D0D0D0; color: #404040;; font-size:12pt; padding:2px; border: 1px solid #404040;"
		Set:%page.cssLevel'=3 tSystemStyle = tSystemStyle_" -moz-border-radius: 5px;"
	}
	ElseIf (tSystemMode = "DEVELOPMENT") {
		Set tSystemMsg = $$$TextHTML("This is a Development System")
		Set tSystemStyle = "text-align: center; color: #404040; font-size:10pt; padding:2px;"
	}
	ElseIf (tSystemMode '= "") {
		// show value as a string
		Set tSystemMsg = $ZCVT(tSystemMode,"O","HTML")
		Set tSystemStyle = "text-align: center; color: #404040; font-size:10pt; padding:2px;"
	}

	&html<<div class="portalTitle">>
	#; place holder for menu
	#; small menu
	Do ..%DrawSmallMenu(.pSmallMenu, .pLocatorMenu)
	Set tSwitch = $$$TextHTML("Switch namespace")
	Set tCode = "zenPage.switchNamespace();"
	Set tCaption = $$$TextHTML("Switch")
	Set tTitleText = pTitle
	Set msgInstance = $ZCVT($ZV,"O","HTML")
	#; Do not display "Switch" link if CanShowSwitch is false
	Set CanShowSwitch = ..CanShowSwitch(%request.PageName)
	#; handle long names
	Set tTitleStyle = ""
	If ($L(tTitleText)>28) {
		// smaller font
		Set tTitleStyle = "style=font-size:12px;"
	}
	If ($L(tTitleText)>100) {
		// aaa...bbb
		Set tTitleText = $ZSTRIP($E(tTitleText,1,40),"<>W")_"..."_$ZSTRIP($E(tTitleText,$L(tTitleText)-40,$L(tTitleText)),"<>W")
	}
	
	&html<
	<div class="portalTitleTabBox" #(tTitleStyle)# id="titleTab" title="#($ZCVT(pTitle,"O","HTML"))#">#($ZCVT(tTitleText,"O","HTML"))#<span id="modifiedIndicator">&nbsp;</span></div>

	<div class="portalTitleInfoBox">
		<table border="0" cellspacing="0" cellpadding="1">
		<tr>
		<td align="right" class="portalTitleInfoLabel" nowrap="1">#($$$TextHTML("Server"))#:</td>
		<td class="portalTitleInfoVal" style="#(tServerStyle)#" nowrap>#($ZCVT(tServerName,"O","HTML"))#&nbsp;</td>
		<td align="right" class="portalTitleInfoLabel" nowrap="1">#($$$TextHTML("Namespace"))#:</td>
		<td class="portalTitleInfoVal" nowrap>#($ZU(5))#&nbsp;>
		If CanShowSwitch &html<<a class="portalTitleLink" title="#(tSwitch)#" href="#" onclick="#(tCode)#return false;">#($ZCVT(tCaption,"O","HTML"))#</a>>
		&html<
		</td>
		<td align="left" colspan="4" nowrap="1" class="portalTitleInfoVal" style="#(tSystemStyle)#">#(tSystemMsg)#</td>
		</tr>
		<tr>>
		Do ..DrawUsername()
		&html<<td align="right" class="portalTitleInfoLabel" nowrap="1">#($$$TextHTML("Licensed to"))#:</td><td class="portalTitleInfoVal" nowrap>#($ZCVT(tLicensedTo,"O","HTML"))#&nbsp;</td>
		<td align="right" class="portalTitleInfoLabel" nowrap="1" title="#(msgInstance)#">#($$$TextHTML("Instance"))#:</td><td class="portalTitleInfoVal" nowrap>#($ZCVT(tInstance,"O","HTML"))#&nbsp;</td>>
		If IsEMSSetUp {
			&html<<td align="right" class="portalTitleInfoLabel" nowrap="1" title="#(EMSServices)#">#($$$TextHTML("Enterprise Manager Status"))#:</td><td class="portalTitleInfoVal" nowrap="1" title="#(EMSServices)#">#($ZCVT(EMSState,"O","HTML"))#&nbsp;</td>>
		} Else {
			&html<<td colspan="2">>
		}
		&html<</tr>
		</table>
	</div>

	<div class="portalLogoBox">
	<div class="portalLogo" title='#($$$Text("Powered by Zen"))#'>#(pProduct)#</div>>
	If (pProduct '= "InterSystems") {
		&html<<div class="portalLogoSub">#($$$TextHTML("by InterSystems"))#</div>>
	}
	Else {
		&html<<div class="portalLogoSub">#($ZCVT(tUserName,"O","HTML"))#</div>>
	}
	&html<
	</div>
	</div>>
	Quit $$$OK
}

/// Draw username with (or without) link to change password. The link is built only for the Home page.
Method DrawUsername()
{
	Set msgUser = $$$TextHTML("User")
	Set hlpUser = $$$TextHTML("Name of user logged into this session")
	Set hlpLink = $$$TextHTML("Change password")
	Set linkUser = ##class(%CSP.Page).Link("/csp/sys/UtilUserChangePassword.csp")
	Set tUserName = $Username
	Set tCode = "zenPage.changePassword();"
	Set IsHome = $Case(%request.PageName,"%CSP.Portal.Home.zen":1,"%CSP.Portal.Home.zen":1,"UtilHome.csp":1,:0)
	&html<<td align="right" class="portalTitleInfoLabel" title="#(hlpUser)#" nowrap="1">
	#(msgUser)#:<td class="portalTitleInfoVal" nowrap="1">>
	If IsHome &html<<a class="portalTitleLink" href="#" onclick="#(tCode)#return false;" style="text-decoration:none;" title="#(hlpLink)#">>
	&html<#($ZCVT(tUserName,"O","HTML"))#>
	If IsHome &html<</a>>
	&html<&nbsp;</td>>
}

/// Draw small menu at the top of the title area.
Method %DrawSmallMenu(ByRef pMenu As %String, ByRef pLocatorMenu As %String)
{
	// pMenu takes the form:
	// pMenu(1) = $LB("Caption","title","script")
	&html<<div class="portalTitleMenuBox">>
	Set tCount = 0
	Set n = $O(pMenu(""))
	While (n '= "") {
		If (tCount > 0) {
			&html<<span>|</span>>
		}
		Set tCount = tCount + 1
		Set tCaption = $LG(pMenu(n),1)
		Set tTitle = $LG(pMenu(n),2)
		Set tCode = $LG(pMenu(n),3)
		&html<<a class="portalTitleLink" title="#(tTitle)#" href="#" onclick="#(tCode)#">#($ZCVT(tCaption,"O","HTML"))#</a>>
		Set n = $O(pMenu(n))
	}
	&html<<img height="1px" width="32px" src="images/spacer.gif"/>>
	Set tCount = 0
	Set n = $O(pLocatorMenu(""))
	#; if this is on the home page, don't display the Home locator link.
	If n '= "",$O(pLocatorMenu(n)) '= "" {
		While (n '= "") {
			If (tCount > 0) {
				&html<<span>&gt;</span>>
			}
			Set tCount = tCount + 1
			Set tCaption = $LG(pLocatorMenu(n),1)
			Set tCode = $LG(pLocatorMenu(n),2)
			// JMD: remove onclick as tCode is not actually code !
			
			&html<<a class="portalTitleLink" href="#(tCode)#">#($ZCVT(tCaption,"O","HTML"))#</a>>
			Set n = $O(pLocatorMenu(n))
		}
	}
	&html<</div>>
}

/// Get the product name for the page. May be called from none-Zen classes in SMP.
Method %OnGetProductName() As %String
{
	// Test for product
	If (##class(%Library.EnsembleMgr).IsHealthShareInstalled()) {
		Quit "HealthShare"
	}
	ElseIf (##class(%Library.EnsembleMgr).IsEnsembleInstalled()) {
		Quit "Ensemble"
	} 
	ElseIf $E($G(%request.Data("home",1)),1,7) = "DEEPSEE" {
		Quit "DeepSee"
	}	
	Quit "Cach&eacute;"
}

/// Checks to see if Ensemble is loaded in any accessible namespace
ClassMethod EnsembleLoaded() As %Integer [ Internal ]
{
	// This replicates the check in %Library.EnsembleMgr
	// without the restriction of checking to see if it
	// is enabled in the current namespace
	Quit:($DATA(^%SYS("Ensemble")) > 0) 1
	
    // test for faking it
    Quit:($DATA(^DocBook.Config("EnsembleLoaded")) > 0) $GET(^DocBook.Config("EnsembleLoaded"), 0)
    
    // nope
    Quit 0
}

/// Checks to see if HealthShare is loaded in any accessible namespace
ClassMethod HealthShareLoaded() As %Integer [ Internal ]
{
	// This replicates the check in %Library.EnsembleMgr
	// without the restriction of checking to see if it
	// is enabled in the current namespace
	Quit:($DATA(^%SYS("HealthShare")) > 0) 1
	
    // test for faking it
    Quit:($DATA(^DocBook.Config("HealthShareLoaded")) > 0) $GET(^DocBook.Config("HealthShareLoaded"), 0)
    
    // nope
    Quit 0
}

/// Determine if the "Switch" link for namespace can be shown. Return 1 if yes, and 0 if not.
ClassMethod CanShowSwitch(PageName) As %Boolean
{
	Try {
		Set CanShowSwitch = 0
		/// If user logged in without any role, cannot use switch namespace
		If $Roles = "" Quit
		/// Do not display "Switch" link for most SMP options. Show only Tools and iKnow under /csp/sys/exp/
		Set WebApp = $system.CSP.GetPortalApp("%SYS",PageName)
		If (WebApp = "/csp/sys/sec/") || (WebApp = "/csp/sys/mgr/") || (WebApp = "/csp/sys/op/") Quit
		If $E(PageName,1,14) = "%CSP.UI.Portal",PageName'["SQL.",PageName'["iKnow" Quit
		/// Check security for namespace dialog
  		Set Resources = $G(^oddDEF("%ZEN.Dialog.namespaceSelect","p","RESOURCE",22))
  		If Resources = "" Quit
  		/// If user has at least one of the resources, then we can show. Otherwise we cannot.
  		For n = 1:1:$L(Resources,",") Set r = $P(Resources,",",n) If r'="",$System.Security.Check(r,"USE") Set CanShowSwitch = 1 Quit
 	} Catch errobj {
	 	/// most likely it's <PROTECT>
	 	///s ^CacheTemp("error")=errobj.Name_"^"_errobj.Code_"^"_errobj.Location_"^"_errobj.Data
  		Set CanShowSwitch = 0
 	}
 	Quit CanShowSwitch
}

}
