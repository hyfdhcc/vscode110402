/// This is the application class for Activate Wizard
Class %Activate.UI.Application Extends %ZEN.application [ System = 4 ]
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Activate Wizard";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "Activate.Wizard.cls";

/// Domain used for localization.
Parameter DOMAIN = "Activate";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">

/* default body style */
body {
	background: white;
	font-family: arial,verdana;
}
/* Customized lookout menu style */
.lookoutButton {
	position: absolute;
	padding: 3px;
	font-weight: bold;
}

/* used for tab enclosing div */ 
.lookoutTab {
	position: absolute;
	padding: 1px;
	background: #F7ECD7;
	overflow: auto;
}

/* Customized menu style */
.menuTable {
	border: 1px solid #c4d8e2;
	font-family: verdana;
	padding: 0px;
	background: white;
}

.submenu {
	background: white;
}

a.menuItem {
	background: #F7ECD7;
	border-bottom:1px solid #c6930a;
	color: black;
	display: block;
	font-size: 0.9em;
	font-weight: bold;
	margin: 1px 1px 1px 1px;
	padding: 3px 3px 2px 3px;
	text-decoration: none;
	white-space: nowrap;
	vertical-align: middle;
}
/* mouse over */
a.menuItem:hover {
	background: #89aacb;
	margin: 0px 0px 0px 0px;
}

/* Customized TabGroup */
/* if tab bar is shown, this wraps the body of tabgroup */
.tabGroupBody {
	border-right: 1px solid #c4d8e2;
	border-left: 1px solid #c4d8e2;
	border-bottom: 1px solid #c4d8e2;
	height: 500px;
	background: #eeeeee;
}

/* container of tab bar buttons */
table.tabGroupBar {
	font-size: 1.0em;
}

/* individual tab bar button */
td.tabGroupButtonOn {
	background: #eeeeee;
	border-top: 1px solid #c4d8e2;
	border-bottom: none;
	border-right: 1px solid #c4d8e2;
	border-left: 1px solid #c4d8e2;
	font-weight: bold;
	padding-right: 5px;
	padding-left: 5px;
	cursor: pointer;
	border-top-left-radius:6px;
	border-top-right-radius:6px;
}

td.tabGroupButtonOff {
	background: none;
	border: 1px solid #c4d8e2;
	padding-right: 5px;
	padding-left: 5px;
	cursor: pointer;
	border-top-left-radius:6px;
	border-top-right-radius:6px;
}

td.tabGroupButtonDisabled {
	background: #AAAAAA;
	color: gray;
	border: 1px solid #c4d8e2;
	padding-right: 5px;
	padding-left: 5px;
	border-top-left-radius:6px;
	border-top-right-radius:6px;
}
td.tabGroupButtonOff:hover {
	background: #89aacb;
}

/* extra space on edges of tab bar */
.tabGroupExtra {
	background: white; /* !!! */
	border-bottom: 1px solid #c4d8e2;
}

/* Customized TablePane */
/* style for table pane */
#table {
	height: 20.0em;
	overflow: auto;
	border: 1px solid #c4d8e2;
}
/* defines style sheet used by this application table pane */

/* table */
table.tpTable {
	background: white;
	border: 1px solid black;
	font-family: arial;
	width: 100%;
	font-size: 0.8em;
	margin-left: 20px;
	margin-right: 20px;
}

/* column header (th) */
table.tpTable th {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	background: #E1C07D;
	color: black;
	font-weight: bold;
	text-align: left;
	padding: 2px;
}

/* selected column header (th) */
table.tpTable th.tpHdrSelected {
	background: #00A0EE;
}

table.tpTable td {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	padding: 2px;
}

table.tpTable tr.tpSelected td {
	border-top: 1px solid black;
	border-bottom: 2px solid black;
	padding-top: 1px;
	padding-bottom: 1px;
}

/* this is a normal, unselected row */
table.tpTable tr {
	color: black;
	white-space: nowrap;
	font-size: 0.8em;
}

/* this is a selected row */
table.tpTable tr.tpSelected {
	background: #FFFF80;
	color: black;
}

/* style for odd-rows when using zebra styling */
.tpOdd {
}

/* style for even-rows when using zebra styling */
.tpEven {
	background: #eeeeee;
}

/* descriptive text */
#description {
	font-family: verdana;
	color: darkblue;
	font-size: 1.2em;
	padding: 5px;
}

#description:first-letter {
	font-size: 1.5em;
}
.fieldBoxIndent {
	background: #D7DBDD;
	width: 100%;
	overflow: auto;	
}
.labelBold {
	color: black;
	font-size: 0.9em;
	font-weight: bold;
	text-decoration: none;
}
.labelNormal {
	color: black;
	font-size: 0.9em;
	text-decoration: none;
}
.labelSmall {
	color: black;
	font-size: 0.8em;
	font-weight: normal;
	text-decoration: none;
}
/* used by side search menupane */
.hrline {
	background: #C6930A;
	height:4px;
}
/* customized navigatorBar bgcolor */
.tnbrTable {
	background: #BFC8CF;
	border: 1px solid #E1C07D;
}
.button {
	padding: 1px; 
	font-family: "Tahoma"; 
	font-size: 10pt;
	background-color:#c5d9ff;
}

</style>
}

}
