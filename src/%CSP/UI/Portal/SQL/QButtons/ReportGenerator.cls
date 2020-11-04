/// System Management Portal - SQL Performance Tool - Troubleshooting Report Generator
Class %CSP.UI.Portal.SQL.QButtons.ReportGenerator Extends %CSP.UI.Template.Property [ System = 4 ]
{

/// Switch namespace $NAMESPACE is present
Parameter AUTONS As %Boolean = 1;

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.SQL.QButtons.ReportGenerator.zen";

Parameter HELPADDRESS = "Home,Generate SQL Troubleshooting Report";

/// Displayed name of this page.
Parameter PAGENAME = "SQL QButtons Report Generator";

/// Security requirement
Parameter RESOURCE = "%Development";

Property NAMESPACE As %ZEN.Datatype.string(ZENURL = "$NAMESPACE");

Property msgWRC As %ZEN.Datatype.string [ InitialExpression = {$$$Text("Please enter a proper WRC number!")} ];

XData Style
{
<style type="text/css">
/* additional style for table pane */
table.tpTable th {
	border-right: 1px solid #F1F0E7;
	border-bottom: 1px solid #F1F0E7;
}

table.tpTable td {
	border-right: 1px solid #F1F0E7;
	border-top: 1px solid #F1F0E7;
}
.EditForm {
	width: 800px;	
}	
#propertyPane {
	background: white;
	height: 449px;
	width: 550px;
	border-right: none;
	border-bottom: none;
	display: none;
}
#propertyTitle {
	height: 300px;
	width: 100%;
	overflow:auto;
}
	
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding-top:10px;padding-left:20px;">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-left:10px;"/>
<form id="form1" enclosingClass="EditForm" labelPosition="left">
<hgroup label="WRC Number:" labelClass="normal" labelPosition="left">
<text id="WRCNum" name="WRCNum" size="8" value="" onchange="zenPage.checkWRCResult();"/>
<label label=" (Required)" labelClass="helpText"/>
</hgroup>
<textarea id="SQLStmt" label="SQL Statement:" labelClass="normal" rows="5" cols="80" valign="top" containerStyle="padding-top:10px;"
value=""/>
<checkbox id="includeresults" caption="Include query results data?" captionClass="normal" value="1"/>
</form>

<spacer height="4"/>
<hgroup >
<vgroup id="editorPane" label="Currently Saved Queries" labelClass="caption"  valign="top">
<tablePane id="table"
tableName="%SQL_Manager_QButtons.Base"
valueColumn="ID"
onselectrow="zenPage.doSelectRow(zenThis.getValue());"
>
<column colName="ID" cellTitle="Click row to see Query Statement" header="ID" hidden="true" />
<column colName="IncludeResults" header="Result Data?"/>
<column colName="TimeInserted" title="Time inserted" header="Time Inserted (GMT)"/>
<column colName="WRCNumber" title="WRC number" header="WRC Number"/>
<column colName="QueryStatement" hidden="true" />
<column colName="QueryCompileDecomposedStatus" title="Query compile status" header="Compile Status" />
<column colName="AllowDelimitedIdentifiers" cellTitle="Saved with 'Allow Delimited Identifiers'" title="Saved with 'Allow Delimited Identifiers'" header="Saved" />
<column colName="DefaultSchema" cellTitle="Saved with Default Schema" title="Saved with Default Schema" header="Saved with Default Schema" />
<column onclick="zenPage.removerowBtnClick('#(%query.ID)#');return false;" linkCaption="Delete" link="#"/>
</tablePane>
<hgroup>
<button id="btnClearWRC" caption="Clear WRC" title="Delete saved queries for the WRC" onclick="zenPage.clearWrcBtnClick();"/>
<button id="btnClearAll" caption="Clear All" title="Delete all saved queries" onclick="zenPage.clearAllBtnClick();"/>
</hgroup>
</vgroup>
<spacer width="5" />
<vgroup id="propertyPane" valign="top">
<html id="propertyTitle" OnDrawContent="DrawDetailsTitle" width="400px" height="400px"></html>
</vgroup>
</hgroup>
</pane>
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	this.adjustSizes();
	this.checkWRCResult();
	zen("WRCNum").focus();
}

ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();
		var table = zen('table').getEnclosingDiv();

		var propDiv = zen('propertyPane').getEnclosingDiv();
		var editDiv = zen('editorPane').getEnclosingDiv();
	
		propDiv.style.display = 'block';
	
		var halfWinWidth = (winWidth / 2) - 25;
		var halfWinHeight = (winHeight / 2) - 25;
		
		propDiv.style.width = halfWinWidth + 'px';
		editDiv.style.width = winWidth - (table.offsetWidth) - 20 + 'px';

		propDiv.style.height = halfWinHeight - 40 + 'px';
		editDiv.style.height = halfWinHeight - 40 + 'px';
	
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

ClientMethod checkWRCResult() As %Boolean [ Language = javascript ]
{
	var WRCNum = zen("WRCNum").getValue();
	if (this.validateWRCNum(WRCNum)) {
		if (!this.WRCRowExists(WRCNum)) {
			self.document.getElementById("command_btnGenerate").className = "commandButtonDisabled";
		} else {
			self.document.getElementById("command_btnGenerate").className = "commandButton";
		}
	}
}

ClientMethod clearAllBtnClick() [ Language = javascript ]
{
	var ok = this.ClearClick();
	if (ok) {
		this.refreshTable();	
	} else {
		alert(ok);	
	}
}

ClientMethod clearWrcBtnClick() [ Language = javascript ]
{
    if (this.validateWRCNum()) { 
		var ok = this.ClearClick(zen("WRCNum").getValue());
	  	if (ok) {
			this.refreshTable();	
		} else {
			alert(ok);	
		}
    } else {
		alert(this.msgWRC);
		zen("WRCNum").focus();
	}
}

ClientMethod doGenerate() [ Language = javascript ]
{
	if (!this.validateWRCNum()) {
		alert(this.msgWRC);
		zen("WRCNum").focus();
		return;	
	}
	var WRCNum = zen("WRCNum").getValue();
	var parms = {
			WRCNUM:WRCNum,
			$NAMESPACE:this.NAMESPACE
	};
	//open dialog for export criteria
	zenLaunchPopupWindow('%CSP.UI.Portal.Dialog.SQLReportGenerator.zen','Generate','status,scrollbars,resizable=yes,width=610,height=700',parms);
}

ClientMethod refreshTable() [ Language = javascript ]
{
	var table = zen("table");
	table.executeQuery(0);
	this.checkWRCResult();
}

ClientMethod removerowBtnClick(delId As %String) [ Language = javascript ]
{
	var ok = this.RemoveRow(delId);
  	if (ok) {
		this.refreshTable();	
	} else {
		alert(ok);	
	}
}

ClientMethod doSave() [ Language = javascript ]
{
	if (this.validateWRCNum()) {
		var WRCNum = zen("WRCNum").getValue();
		var SQLStmt = zen("SQLStmt").getValue();
		var includeresults = (zen("includeresults").getValue() == true) ? 1 : 0;
		var ok = this.SaveClick(SQLStmt,WRCNum,includeresults);
		if (ok != 1) {
			alert(ok);	
		} else {
			this.refreshTable();
		}
	} else {
		alert(this.msgWRC);
		zen("WRCNum").focus();
	}
}

ClientMethod doSelectRow(id) [ Language = javascript ]
{
	var html = zen("propertyTitle");
	html.seed = id;
	html.refreshContents();
	return;
}

ClientMethod validateWRCNum() As %Boolean [ Language = javascript ]
{
	var wrcnumstring = zen("WRCNum").getValue();
	//Make sure the wrc number only has digits and no whitespaces
	if (/\D/.test(wrcnumstring) || /\s/.test(wrcnumstring) || wrcnumstring == "") {
		return false
	}
	return true
}

ClassMethod ClearClick(wrcnum As %String = "") As %String [ ZenMethod ]
{
	Set sc = ##class(%SQL.Manager.QButtons.Base).ClearData(wrcnum)
	If $$$ISERR(sc) Set sc = $System.Status.GetErrorText(sc)
	Quit sc
}

ClassMethod RemoveRow(delId As %String) As %Integer [ ZenMethod ]
{
	Set sc = ##class(%SQL.Manager.QButtons.Base).ClearRow(delId)
	If $$$ISERR(sc) Set sc = $System.Status.GetErrorText(sc)
	Quit sc
}

ClassMethod SaveClick(SQLStmt, WRCNum, includeresults) As %String [ ZenMethod ]
{
	Set sc = ##class(%SQL.Manager.QButtons.Base).InsertQuery(SQLStmt,WRCNum,includeresults)
	If $$$ISERR(sc) Set sc = $System.Status.GetErrorText(sc)
	Quit sc
}

ClassMethod WRCRowExists(WRCNum) As %Boolean [ ZenMethod ]
{
	Quit ##class(%SQL.Manager.QButtons.Base).WRCRowExists(WRCNum)
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..%GetComponentById("Text1").value = $$$Text("Enter a WRC number and a SQL statement you wish to diagnose. Click 'Save Query' for each statement entered. When you are finished with saving all the queries, click 'Generate Report'.")

	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnSave",$$$Text("Save Query"),$$$Text("Save statement and query"),"zenPage.doSave();")
	Set pCommands(2) = $LB("btnGenerate",$$$Text("Generate Report"),$$$Text("Generate report for the WRC number of the saved queries"),"zenPage.doGenerate();")

	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Generate SQL Troubleshooting Report")
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	switch(popupName) {
	case 'switchNamespace':
		var url = zenPage.GetNewURL(value,"%25CSP.UI.Portal.SQL.QButtons.ReportGenerator.zen");
		this.NAMESPACE = value;
		// do not use this.gotoPage(url) because zenLink will not honor the latest $NAMESPACE you selected, i.e. you may end up with multiple $NAMESPACE on the URL.
		self.document.location = url;
		break;
	}
}

/// Draw html for details title: Query text
Method DrawDetailsTitle(pId) As %Status
{
	Quit:pId="" $$$OK
	Set QueryText = ##class(%SQL.Manager.QButtons.Base).FindQueryById(pId)
	&html<<h4 nowrap>#($$$Text("Query Text:"))#</h4>>
	&html<#(..EscapeHTML(QueryText))#>
	Quit $$$OK
}

}
