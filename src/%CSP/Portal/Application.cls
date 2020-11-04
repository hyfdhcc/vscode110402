/// Zen based Management Portal Application which System Management Portal, Ensemble, or HS can extend to
Class %CSP.Portal.Application Extends %ZEN.Portal.Application [ System = 4 ]
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "System Management Portal";

/// Domain used for localization.
Parameter DOMAIN = "%Utility";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
/* @doc="Combobox and dataCombo box drop-down style for this application." */
.comboboxDropDown {
	font-family: Arial, Helvetica, Verdana,  sans-serif;
	padding: 4px;	
}
.comboboxItem {
	font-size: 0.9em;
}
.comboboxItemSelected {
	font-size: 0.9em;
}
/* LocatorBar Links Style */
DIV.locatorBarLinks {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 0.8em;
	font-weight: bold;
	color: darkblue;
	text-decoration: none;	
}
DIV.locatorBarLinks A {
	color: darkblue;
	text-decoration: none;
	padding-right: 1px;
	padding-left: 1px;
}

DIV.locatorBarLinks A:visited {
	color: darkblue;
}

DIV.locatorBarLinks A:hover {
	color: red;
	background: #FFFAE7;
}
.fieldSet {
	background: #C0C0C0;
	background-image: url('#(..Link("/csp/broker/images/grad-halfgray-10x500.png"))#');
	background-repeat: repeat-x;
	padding: 4px;
}

/* @doc="Default style for labels for disabled components." */
.zenLabelDisabled {
	color: gray;
	font-size: 12px;
	font-weight: normal;
	padding-right: 5px;
}

.helpText {
	color:gray;
	font-size:12px;	
}
.redText {
	color:#da4848;
	font-size:12px;	
	font-weight: bold;
}
/* @doc="Item within listBox. Added font-size." */
.listBoxItem {
	white-space: nowrap;
	width: 100%;
	color: black;
	/* ie does not handle transparent */
	border: 1px solid white;
	cursor: pointer;
    font-size:0.8em;
}

/* @doc="Selected item within listBox." */
.listBoxItemSelected {
	white-space: nowrap;
	width: 100%;
	color: black;
	background: #E0E0E0;
	font-weight: bold;
	border: 1px dotted #202060;
	cursor: pointer;
    font-size:0.8em;
}

/* This is the style similar to intersystems.css's DetailCommand.*/
.DetailCommand {
	font-size: 0.8em; 
	font-weight: bold;
	border-top: 1px gray solid;
	border-bottom: 1px gray solid;
	background: rgb(53,107,141); 
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	margin-bottom: 5px;
	width: 100%;
}
/* @doc="Default style for label/caption." */
.caption {
	color: #404040;
	font-size: 12px;
	font-weight: bold;
	padding-right: 5px;
}
.normal {
	color: black;
	font-size: 12px;
	padding-right: 5px;
}
.disablednormal {
	color: gray;
	font-size: 12px;
	padding-right: 5px;
}
.radioSetSpan {
	color: black;
	font-size: 12px;
	font-weight: normal;
	padding-left: 5px;
}
/* descriptive text for page title */
#Text1 {
	font-family: Arial, Helvetica, sans-serif;
	color: black;
	font-size: 1.0em;
}
#Text1:first-letter {
	font-size: 1.4em;
}
/* Generic style for messages */
.rednote {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #da4848;
	text-align: left;
	font-weight: bold;
}
.greennote {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #52b012;
	text-align: left;
	font-weight: bold;
}

</style>
}

/// Given a security resource, this method returns 1 if user has privilege, and 0 if the user does not security privilege for using a particular function.
ClassMethod CheckSecurity(pResource As %String) As %Boolean
{
	Quit $System.Security.Check(pResource,"USE")
}

/// Evaluate a menu item condition; the condition must refer to values or functions that
/// are in scope (i.e., % variables).
ClassMethod EvaluateCondition(pCondition As %String, tError As %String) As %Boolean
{
	New %ret
	Set %ret = 1
	Set tError = ""
	Set $ZT = "Trap"
	If (pCondition '= "") {
		Set x = "Set %ret = +(" _ pCondition _ ")"
		X x
	}
Done
	Quit %ret
Trap
	Set $ZT = ""
	Set %ret = 0
	If $ZE [ "<PROTECT>" Set tError = $$$Text("You do not have appropriate security privilege to complete this function.","%Utility")
	Set $ZE = ""
	Goto Done
}

}
