Include %sqlui

/// Zen page for System Management Portal - FileMan template
Class %CSP.UI.Portal.FileManTemplate Extends %CSP.UI.Portal.Template [ Abstract, System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "FileMan Template";

/// Switch namespace for this page
Parameter AUTONS As %Boolean = 1;

XData Style
{
<style type="text/css">
#table {
	height: 400px;
	overflow: auto;
	border: solid gray 1px;	
}
#tree {
	height: 400px;
	overflow: auto;
}
.fieldSet {
	background: white;
	padding: 4px;
}
.fieldSetLabel {
	font-weight:bold;
	padding-bottom:2px;
}
.caption {
	font-weight:bold;
	padding:5px;
}
.brownnote {
	font-size: 0.8em;
	color: #990000;
}
#btnR1 input,#btnR2 input,#btnL1 input,#btnL2 input {
	width: 2.2em;
}

</style>
}

/// The template contains the following blocks and will be used by FileMan configuration and the wizard:
/// 1. The titleBar, which is drawn here
/// 2. The locatorBar, which is drawn here the Home page. You may add more locator links in subsequent pages
/// 3. The configPane, which is the configuration form for FileMan.
/// 4. The detailPane, which is the main content of your page.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" title="#(%page.StdTitle)#" valign="top">

<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding:10px"/>
<vgroup valign="top">
<!-- block to show result -->
<html id="idHTMLResult" OnDrawContent="DrawResult" hidden="true"/>
<pane paneName="configPane"/>
<pane paneName="detailPane"/>
</vgroup>
</pane>
}

/// This pane shows the configuration fields, used by both Configuration and the FileMan wizard.
XData configPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
<hidden name="browseselect" id="browseselect"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true"/>
<form cellStyle="padding:2px;" enclosingClass="EditForm" enclosingStyle="margin-left:3px;padding-top:2px;font-family: Verdana, Arial, Helvetica, sans-serif;" labelPosition="left" hidden="false">
<text id="owner" label="Owner of the Classes Created" size="50" onchange="zenPage.doModified();"/>
<text id="package" label="Package Name to Create the Classes in" size="50" onchange="zenPage.doModified();"/>
<text id="superClasses" label="Super Classes" size="50" hint="Comma delimited super classes that each mapped class should extend" onchange="zenPage.doModified();"/>
<text id="tableNameFormat" label="Table Name Format Based on the File Name and Number" size="50" onchange="zenPage.doModified();"/>
<text id="childTableNameFormat" label="Child Table Name Format Based on the File Name and Number" size="50" onchange="zenPage.doModified();"/>
<text id="nameLength" label="Maximum length of Property, Trigger, and Foreign Key names" size="3" hint="Prior to FM2Class 2.13 this was 31.  It can be up to 180." onchange="zenPage.doModified();"/>
<select id="fieldNameFormat" label="Field Name Format Based on the FileMan Field Name" valueList="Exact,Upper,Lower,Pascal,Camel" displayList="Exact,Upper,Lower,Pascal,Camel" showEmpty="false" onchange="zenPage.doModified();"/>
<text id="dateType" label="Datatype to use for FileMan Date fields" size="50" hint="May include type parameters:%Library.String(MAXLEN=19)" onchange="zenPage.doModified();"/>
<text id="datetimeType" label="Datatype to use for FileMan DateTime fields" size="50" hint="May include type parameters:%Library.TimeStamp(XMLTIMEZONE='UTC')" onchange="zenPage.doModified();"/>
<checkbox id="strictData" label="Define STRICTDATA=1 for %FilemanDate* datatypes?" onchange="zenPage.doModified();"/>
<select id="expandPointers" label="Expand Pointers?" valueList="0,1,2,3" displayList="No,Yes(1) - As FIELD and FIELD_NAME,Yes(2) - As FIELDID and FIELD,Yes(3) - As FIELD_fPointerFilenID and FIELD" showEmpty="false" onchange="zenPage.doModified();"/>
<checkbox id="expandSetOfCodes" label="Expand Set Of Codes fields?" onchange="zenPage.doModified();"/>
<checkbox id="variablePointerValueField" label="Create Value field for Variable Pointer fields?" onchange="zenPage.doModified();"/>
<select id="setOfCodesEnum" label="Define Set Of Codes fields as type?" valueList="0,1" displayList="%Library.String,%Library.EnumString" showEmpty="false" onchange="zenPage.doModified();"/>
<select id="requiredType" label="Defined Required Properties for" valueList="0,1" displayList="REQUIRED IDENTIFIERS,REQUIRED FIELDS" showEmpty="false" onchange="zenPage.doModified();"/>
<text id="extendedMapping" label="Extended Mapping" size="50" onchange="zenPage.doModified();"/>
<text id="ienFieldName" label="Name of the IEN Field" size="50" onchange="zenPage.doModified();"/>
<checkbox id="retainClass" label="Retain Class?" onchange="zenPage.doModified();"/>
<select id="recursion" label="Recursion" valueList="0,1,2" displayList="No recursion,Partial recursion,Full recursion" showEmpty="false" onchange="zenPage.doModified();"/>
<select id="wpIsList" label="Word-Processing Fields Conversion" valueList="0,1" displayList="Convert as child tables,Convert as list collections" showEmpty="false" onchange="zenPage.doModified();"/>
<checkbox id="readonly" label="Read Only?" onchange="zenPage.doModified();"/>
<html><hr size="1"/></html>
<hgroup id="idLogFile" labelPosition="left" label="Log File" cellVAlign="top">
<text id="logFile" size="60" onchange="zenPage.doModified();"/>
<button id="btnBrowse" caption="Browse..." containerStyle="padding-left:2px;" onclick="zenPage.browseSelect('logFile','*.log');"/>
</hgroup>
<checkbox id="compile" label="Compile Classes?" onchange="zenPage.doModified();"/>
<text id="compileQSpec" label="Compile Flags" size="50" onchange="zenPage.doModified();"/>
<text id="deleteQSpec" label="Delete Flags" size="50" onchange="zenPage.doModified();"/>
<select id="display" label="Display Result" valueList="0,1,2" displayList="No screen display,Minimal screen display,Full screen display" showEmpty="false" onchange="zenPage.doModified();"/>
<pane paneName="buttonsPane"/>
</form>
</pane>
}

/// This is the pane to display buttons. The Configuration page will override.
XData buttonsPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top">
<html><hr size="1"/></html>
<hgroup cellAlign="even">
<button caption="Save as Default" onclick="zenPage.doSaveDefault();" title="Save settings permanently to be used by everyone."/>
<hgroup cellStyle="padding:2px;" >
	<button id="btnNext" caption="Next" onclick="zenPage.doNext(2);"/>
	<button caption="Cancel" onclick="zenPage.doCancel();"/>
</hgroup>
</hgroup>
</pane>
}

/// Overriden by sub class.
XData detailPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane cellVAlign="top" containerStyle="padding:10px">
</pane>
}

/// User clicked one of the Browse buttons.
/// Save the name of the textfield so that when you return you know which textfield to update.
ClientMethod browseSelect(name, wildcard) [ Language = javascript ]
{
	zen('browseselect').setValue(name);
	var Dir = zen(name).getValue();
	zenLaunchPopupWindow('%ZEN.Dialog.fileSelect.zen?Dir='+encodeURIComponent(Dir)+'&wildcard='+wildcard,'FileSelect','resizable,width=600,height=700');
}

/// User clicked "Save as Default". Save settings permanently.
ClientMethod doSaveDefault() [ Language = javascript ]
{
	var proxy = this.getParameters();
	this.SaveSettings(proxy);
	this.setModified(false);
}

/// Return proxy object with values from current parameter fields
ClientMethod getParameters() [ Language = javascript ]
{
	var proxy = new zenProxy();
	proxy.owner = zen("owner").getValue();
	proxy.package = zen("package").getValue();
	proxy.superClasses = zen("superClasses").getValue();
	proxy.tableNameFormat = zen("tableNameFormat").getValue();
	proxy.childTableNameFormat = zen("childTableNameFormat").getValue();
	proxy.dateType = zen("dateType").getValue();
	proxy.datetimeType = zen("datetimeType").getValue();
	proxy.strictData = zen("strictData").getValue();
	proxy.expandPointers = zen("expandPointers").getValue();
	proxy.expandSetOfCodes = zen("expandSetOfCodes").getValue();
	proxy.variablePointerValueField = zen("variablePointerValueField").getValue();
	proxy.fieldNameFormat = zen("fieldNameFormat").getValue();
	proxy.nameLength = zen("nameLength").getValue();
	proxy.setOfCodesEnum = zen("setOfCodesEnum").getValue();
	proxy.requiredType = zen("requiredType").getValue();
	proxy.extendedMapping = zen("extendedMapping").getValue();
	proxy.ienFieldName = zen("ienFieldName").getValue();
	proxy.retainClass = zen("retainClass").getValue();
	proxy.recursion = zen("recursion").getValue();
	proxy.wpIsList = zen("wpIsList").getValue();
	proxy.readonly = zen("readonly").getValue();
	proxy.logFile = zen("logFile").getValue();
	proxy.compile = zen("compile").getValue();
	proxy.compileQSpec = zen("compileQSpec").getValue();
	proxy.deleteQSpec = zen("deleteQSpec").getValue();
	proxy.display = zen("display").getValue();
	return proxy
}

/// Load existing property values into fields.
Method LoadProperties()
{
	Do loadSettings^%fm2class()
	Set tName = $O(%fm(""))
	While tName '= "" {
		Set ..%GetComponentById(tName).value = %fm(tName)
		Set tName = $O(%fm(tName))
	}
	
	Set ..%GetComponentById("tableNameFormat").hint="May include:<FILENAME>,<FILENUMBER>"
	Set ..%GetComponentById("childTableNameFormat").hint="May include:<FILENAME>,<FILENUMBER>,<PARFILENAME>,<PARFILENUMBER>"
}

/// This method is called when user wants to save setting parameters permanently.
ClassMethod SaveSettings(proxy As %ZEN.proxyObject) As %String [ ZenMethod ]
{
	Set $ZT = "Trap"
	Set tSC = $$$OK
	Do {
		Set ^%SYS("sql","fm2class","owner") = proxy.owner
		Set ^%SYS("sql","fm2class","package") = proxy.package
		Set ^%SYS("sql","fm2class","superClasses") = proxy.superClasses
		Set ^%SYS("sql","fm2class","tableNameFormat") = proxy.tableNameFormat
		Set ^%SYS("sql","fm2class","childTableNameFormat") = proxy.childTableNameFormat
		Set ^%SYS("sql","fm2class","dateType") = proxy.dateType
		Set ^%SYS("sql","fm2class","datetimeType") = proxy.datetimeType
		Set ^%SYS("sql","fm2class","strictData") = proxy.strictData
		Set ^%SYS("sql","fm2class","expandPointers") = proxy.expandPointers
		Set ^%SYS("sql","fm2class","expandSetOfCodes") = proxy.expandSetOfCodes
		Set ^%SYS("sql","fm2class","variablePointerValueField") = proxy.variablePointerValueField
		Set ^%SYS("sql","fm2class","fieldNameFormat") = proxy.fieldNameFormat
		Set ^%SYS("sql","fm2class","requiredType") = proxy.requiredType
		Set ^%SYS("sql","fm2class","extendedMapping") = proxy.extendedMapping
		Set ^%SYS("sql","fm2class","setOfCodesEnum") = proxy.setOfCodesEnum
		Set ^%SYS("sql","fm2class","ienFieldName") = proxy.ienFieldName
		Set ^%SYS("sql","fm2class","retainClass") = proxy.retainClass
		Set ^%SYS("sql","fm2class","nameLength") = proxy.nameLength
		Set ^%SYS("sql","fm2class","recursion") = proxy.recursion
		Set ^%SYS("sql","fm2class","wpIsList") = proxy.wpIsList
		Set ^%SYS("sql","fm2class","readonly") = proxy.readonly
		Set ^%SYS("sql","fm2class","logFile") = proxy.logFile
		Set ^%SYS("sql","fm2class","compile") = proxy.compile
		Set ^%SYS("sql","fm2class","compileQSpec") = proxy.compileQSpec
		Set ^%SYS("sql","fm2class","deleteQSpec") = proxy.deleteQSpec
		Set ^%SYS("sql","fm2class","display") = proxy.display
		Set EventDesc = "FileMan"
		Set EventData = "Save settings"
		$$$SMPAuditChange
	} While (0)
	Quit 1
Done
	If $$$ISERR(tSC) Quit $System.Status.GetErrorText(tSC)
	Quit $$$OK
Trap
	Set $ZT=""	
	Quit "Error occurred in SaveSettings: "_$ZE
	Goto Done
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	try {
		if (action == "ok") {
			var name = zen("browseselect").getValue();
			zen(name).setValue(value);
			this.doModified();
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

}
