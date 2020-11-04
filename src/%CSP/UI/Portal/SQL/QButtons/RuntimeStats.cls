/// System Management Portal - SQL Performance Tool
Class %CSP.UI.Portal.SQL.QButtons.RuntimeStats Extends (%CSP.UI.Template.Property, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

Parameter RESOURCE = "%Development:USE";

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.SQL.QButtons.RuntimeStats.zen";

Parameter HELPADDRESS = "Home,SQL Runtime Statistics";

/// Displayed name of this page.
Parameter PAGENAME = "SQL.QButtons.RuntimeStats";

Property PlanPage As %String;

Property TurnOnStats As %Integer;

Property msgStatsChange As %ZEN.Datatype.string [ InitialExpression = {$$$TextJS("Show Plan stats flag changed.")} ];

Property msgPurgeQueryDone As %ZEN.Datatype.string [ InitialExpression = {$$$TextJS("Purge all cached queries done.")} ];

Property msgPurgeQuery As %ZEN.Datatype.string [ InitialExpression = {$$$TextJS("Purge all cached queries failed.")} ];

XData Style
{
<style type="text/css">
/* style for hand drawn table */
#tableView {
	height: 40.0em;
	overflow: auto;
}
.tpOdd	{ background: #C5E5C9; }
.tpEven	{ background: white; }
/* #C5E5C9;#D2CFDF; */
#divTerm {
	height:20px;
	overflow:auto;
}
#editorPane {
	height:500px;
	overflow:auto;
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
	height: 130px;
	width: 100%;
	overflow:auto;
}

</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none" containerStyle="padding-top:10px;">
<label id="Text1" value="" enclosingStyle="padding:10px;"/>

<vgroup id="groupContent" cellVAlign="top" hidden="false">
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-left:10px;"/>
<hgroup id="mainGroup" cellVAlign="top">

<tabGroup id="tabGroup" showTabBar="true" showBody="false" enclosingStyle="margin:10px;"
onshowTab="zenPage.tabChanged(zenThis.currTab);">

<tab id="page_1" caption="Settings" enclosingStyle="padding:30px">
<radioButton id="radTurnOnStats_0" name="radStatsFlag" label="Select SQL Show Plan Stats Flag" labelClass="caption" caption="Turn off Stats code generation" optionValue="0" onclick="zenPage.changeOption('0');"/>
<radioButton id="radTurnOnStats_1" name="radStatsFlag" caption="Turn on Stats code generation but do NOT gather stats" optionValue="1" onclick="zenPage.changeOption('1');"/>
<radioButton id="radTurnOnStats_2" name="radStatsFlag" caption="Turn on Stats code generation to gather stats at the Open and Close of a query" optionValue="2" onclick="zenPage.changeOption('2');"/>
<radioButton id="radTurnOnStats_3" name="radStatsFlag" caption="Turn on Stats code generation to gather stats at each Module level of a query" optionValue="3" onclick="zenPage.changeOption('3');"/>

<vgroup id="groupPurgeQuery" hidden="true">
<html id="htmlPurgeQuery" OnDrawContent="DrawPurgeQuery"/>
</vgroup>

</tab>

<tab id="page_2" caption="Query Test">
<hgroup labelPosition="left" enclosingStyle="padding:4px;" cellAlign="even">
<label label="The query entered below will be executed to generate SQL Stats and then the Show Plan will be displayed" labelClass="caption"/>
</hgroup>
<spacer height="2"/>
<form id="form1" labelPosition="left">
<textarea id="QueryText" label="SQL Statement:" labelClass="normal" rows="5" cols="80" valign="top" containerStyle="padding-top:10px;"
value=""/>
<button id="btnShowPlan" caption="Show Plan with SQL Stats" controlClass="commandButton" onclick="zenPage.doShowPlan();"/>
</form>
<iframe id="outputShowplan" valign="top" containerStyle="padding-top:10px;"/>
</tab>

<tab id="page_3" caption="View Stats">
<hgroup>
<vgroup id="groupView" valign="top">
<hgroup labelPosition="left" enclosingStyle="padding:4px;" cellAlign="even">
<label label="This following table includes information about all the queries that contain SQL Stats:" labelClass="caption"/>
<button id="btnView" caption="Refresh Table" hidden="false"
onclick="zenPage.doView();"/>
</hgroup>
<group id="editorPane">
<tableNavBar showFilter="false" showPageSize="true" showMaxRows="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table"
queryClass="%SYS.PTools.SQLStats"
queryName="ViewStats"
cellSpacing="1"
dataSource="columns"
fixedHeaders="false"
multiSelect="false"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
valueColumn="RoutineCursor"
useSnapshot="true"
initialExecute="false"
>
<column colName="RoutineCursor" hidden="true"/>
<column colName="RoutineName" header="Routine"/>
<column colName="CursorName" header="Cursor"/>
<column colName="QueryText" hidden="true"/>
<column colName="ImportSchema" hidden="true"/>
<column colName="RunCount" header="Run Count"/>
<column colName="AvgRows" header="Avg Rows"/>
<column colName="AvgGlobalRefs" header="Avg Global Refs"/>
<column colName="AvgCommands" header="Avg Commands"/>
<column colName="AvgDiskWait" header="Avg Disk Wait"/>
<column colName="AvgTime" header="Avg Time"/>
<column colName="Details" hidden="true"/>
<column linkCaption="Details" link="javascript:zenPage.doDetails('#(%query.CursorName)#','#(%query.RoutineName)#')"
style="text-align:center;" title="View details of the routine"/>
<column linkCaption="Show Plan" link="javascript:zenPage.doSelectRow('#(%query.CursorName)#','#(%query.RoutineName)#');" 
style="text-align:center;" title="View Show Plan for the query"/>

<condition colName="Details" predicate="EQ" value="0" rowStyle="background: #c4d6d6;" cellStyle="disabled" targetCol="Details"/> 

<parameter id="namespace" value=""/>
</tablePane>
</group>
</vgroup>
<spacer width="5"/>

<vgroup id="propertyPane" hidden="true" valign="top">
<html id="propertyTitle" OnDrawContent="DrawDetailsTitle"></html>
<spacer height="3"/>
<tablePane id="tableDetails"
queryClass="%SYS.PTools.SQLStats"
queryName="ViewStatsDetails"
cellSpacing="1"
dataSource="columns"
fixedHeaders="false"
multiSelect="false"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
valueColumn="QueryText"
useSnapshot="true"
initialExecute="false"
>
<column colName="QueryText" hidden="true"/>
<column colName="RunCount" header="Run Count"/>
<column colName="ModuleName" header="Module Name"/>
<column colName="AvgModCount" header="Avg Module Exec Count"/>
<column colName="AvgRows" header="Avg Rows"/>
<column colName="AvgGlobalRefs" header="Avg Global Refs"/>
<column colName="AvgCommands" header="Avg Commands"/>
<column colName="AvgDiskWait" header="Avg Disk Wait"/>
<column colName="AvgTime" header="Avg Time"/>

<parameter value=""/>
<parameter value=""/>
</tablePane>
<iframe id="outputShowplan3" valign="top" containerStyle="padding-top:10px;" hidden="true"/>

</vgroup>

</hgroup>
</tab>
</tabGroup>

</hgroup>
</vgroup>

</pane>
}

/// This client event, if present, is fired when the page is loaded.
/// Enable the first tab and disable the rest.
ClientMethod onloadHandler() [ Language = javascript ]
{
	this.invokeSuper('onloadHandler',arguments);
	zen("radTurnOnStats_0").setValue(this.TurnOnStats);
	this.changeOption(this.TurnOnStats);
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {		
	
		this.adjustSizes();	
	
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler');
	}
}

ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var propDiv = zen('propertyPane').getEnclosingDiv();
		var editDiv = zen('editorPane').getEnclosingDiv();
		
		propDiv.style.display = 'block';

		var halfWinWidth = (winWidth / 2) - 25;
		halfWinWidth = (halfWinWidth<300) ? 300 : halfWinWidth;
		
		editDiv.style.width = halfWinWidth - 20 + 'px';
		propDiv.style.width = halfWinWidth + 'px';
	
		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 100;
		var tabBodyHgt = (hgt - 30);

		tabBodyHgt = (tabBodyHgt < 141 ? 141 : tabBodyHgt);
		propDiv.style.height = tabBodyHgt - 100 + 'px';
		editDiv.style.height = tabBodyHgt - 40 + 'px';

		var frame = zen("outputShowplan");
		var frameWidth = winWidth - 100;
		var frameHeight = tabBodyHgt - 180;

		frameWidth = Math.max(frameWidth,100);
		frame.setProperty("width",frameWidth + "px");
		frameHeight = Math.max(frameHeight,100);
		frame.setProperty("height",frameHeight +"px");

		frame = zen("outputShowplan3");
		frame.setProperty("width",propDiv.style.width);
		frame.setProperty("height",tabBodyHgt - 140 + 'px');

	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

ClientMethod changeOption(newOption) [ Language = javascript ]
{
	var oldOption = this.SaveSQLStats(newOption);
	zen("groupPurgeQuery").setHidden(newOption == 0);
	this.TurnOnStats = newOption;
	if (oldOption != newOption) this.showMsg(this.msgStatsChange);
}

ClientMethod doDetails(cursorName, routineName) [ Language = javascript ]
{
	zen('tableDetails').setHidden(false);
	zen('outputShowplan3').setHidden(true);
	zen("propertyPane").setHidden(false);
	var propDiv = zen('propertyPane').getEnclosingDiv();
	propDiv.style.display = 'block';

	var html = zen("propertyTitle");
	html.seed = routineName+"^"+cursorName;
	html.refreshContents();

	var table = zen("tableDetails");
	table.parameters[0].value = cursorName;
	table.parameters[1].value = routineName;
	table.executeQuery();
	table.setHidden(false);
}

ClientMethod doPurgeQuery() [ Language = javascript ]
{
	if (!confirm($$$Text("Are you sure you want to purge all cached queries in this namespace?"))) return;
	var ok = this.PurgeQuery(this.NAMESPACE);
	if (ok == 1) this.showMsg(this.msgPurgeQueryDone);
	else this.showMsg(this.msgPurgeQuery);
	zenPage.doView();
}

ClientMethod doShowPlan() [ Language = javascript ]
{
	var query = zen("QueryText").getValue();
	this.PrepareShowPlan(query);
	var planlink = this.PlanPage + "?namespace="+encodeURIComponent(this.NAMESPACE)+"&stats=1";
	zen('outputShowplan').setProperty('src',planlink);
}

ClientMethod doSelectRow(cursorName, routineName) [ Language = javascript ]
{
	zen('tableDetails').setHidden(true);
	zen('outputShowplan3').setHidden(false);
	zen("propertyPane").setHidden(false);
	var propDiv = zen('propertyPane').getEnclosingDiv();
	propDiv.style.display = 'block';
	
	var html = zen("propertyTitle");
	html.seed = routineName+"^"+cursorName;
	html.refreshContents();

	var query = this.GetQueryText(cursorName,routineName,1);
	var schema = this.GetImportSchema(cursorName,routineName,1);
	var id = routineName+"||"+cursorName;
	this.PrepareShowPlan(query,schema,id);
	var planlink = this.PlanPage + "?namespace="+encodeURIComponent(this.NAMESPACE)+"&stats=2";
	zen('outputShowplan3').setProperty('src',planlink);
	return;
}

ClientMethod doView() [ Language = javascript ]
{
	var table = zen("table");
	table.parameters[0].value = this.NAMESPACE;
	table.executeQuery();
}

ClientMethod tabChanged(index) [ Language = javascript ]
{
	this.resetMsg();
	zen("tableDetails").setHidden(true);
	if (index == 3) {
		zen("propertyTitle").setHidden(false);
		this.adjustSizes();
		this.doView();
	} else {
		zen("propertyTitle").setHidden(true);
		zen("propertyPane").setHidden(true);
		if (index == 2) {
			zen("QueryText").focus();
		}
	}
	return;
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	Set ..%GetComponentById("Text1").value = $$$TextHTML("Use options on this page to gather and view SQL runtime statistics for debugging purposes.")
	
	Set %page.NAMESPACE = $G(%request.Data("$NAMESPACE",1))
	If %page.NAMESPACE = "" Set %page.NAMESPACE = $zu(5)
	Set %page.PlanPage = $P(..Link("%25SQL.Manager.ShowPlan.cls"),"?$NAMESPACE",1)
	Set %page.TurnOnStats = +$G(^%SYS("sql","sys","SQLStats"),0)

	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnPurgeQuery",$$$Text("Purge Cached Queries"),$$$Text("Purge Cached Queries"),"zenPage.doPurgeQuery();")
	//Set pCommands(2) = $LB("btnViewStats",$$$Text("View Stats"),$$$Text("View SQLStats table"),"zenPage.getreportBtnClick();")

	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("SQL Runtime Statistics")
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	switch(popupName) {
	case 'switchNamespace':
		var url = zenPage.GetNewURL(value,"%25CSP.UI.Portal.SQL.QButtons.RuntimeStats.zen");
		// do not use this.gotoPage(url) because zenLink will not honor the latest $NAMESPACE you selected, i.e. you may end up with multiple $NAMESPACE on the URL.
		self.document.location = url;
		break;
	case 'Details':
		break;
	}
}

Method DrawPurgeQuery(pSeed) As %Status
{
	
	Write "<h3>",$$$TextHTML("To gather SQLStats data, queries need to be compiled with the Stats turned on.")
	Write "<br/><br/>",$$$TextHTML("Routines and Classes that contain SQL will need to be compiled if you want Stats on those queries.")
	Write "<br/><br/>",$$$TextHTML("For xDBC and Dynamic SQL this can be done by Purging Cached Queries.")
	Write "<br/><br/>",$$$TextHTML("When the Stats Flag is changed, you should click the 'Purge Cached Queries' button to purge cached queries. New cached queries will be built using the new flag.")
	Write "</h3>"
	Quit $$$OK
}

/// Draw html for details title: Routine name and Query text
Method DrawDetailsTitle(pData) As %Status
{
	If pData = "" Quit $$$OK
	s pRoutine=$P(pData,"^",1)
	s pCursor=$P(pData,"^",2)
	Set QueryText = ..GetQueryText(pCursor,pRoutine)
	&html<<h4>#($$$FormatText($$$Text("Routine: %1"),$zconvert(pRoutine,"O","HTML")))#</h4>>
	&html<#(..EscapeHTML(QueryText))#>
	Quit $$$OK
}

ClassMethod GetQueryText(pCursor, pRoutine, pInternal = 0) As %String [ ZenMethod ]
{
	Try {
		Set QueryText = ##class(%SYS.PTools.SQLStats).QueryText(pCursor,pRoutine,pInternal)
	}
	Catch(ex) {
		Set QueryText = ex.AsStatus()
	}
	Quit QueryText
}

ClassMethod GetImportSchema(pCursor, pRoutine, pInternal = 0) As %String [ ZenMethod ]
{
	Try {
		Set schema = ##class(%SYS.PTools.SQLStats).ImportSchema(pCursor,pRoutine,pInternal)
	}
	Catch(ex) {
		Set schema = ex.AsStatus()
	}
	Quit schema
}

ClassMethod PrepareShowPlan(query, schema = "", id = "") [ ZenMethod ]
{
	//Set %session.Data("$SQLQUERY") = query
	s RoutineName=$p(id,"||",1)
	Set ^mqh($Username) = $S(RoutineName="":query,$D($$$CQ("QueryText",$S(RoutineName[".cls":$E(RoutineName,1,*-2),1:RoutineName))):$P($$$CQ("QueryText",$S(RoutineName[".cls":$E(RoutineName,1,*-2),1:RoutineName),1),"~RUNTIME~",1),1:query)
	set ^mqh($Username,"schema")=schema
	set ^mqh($Username,"id")=id
}

/// This method returns 1 (success) or 0.
ClassMethod PurgeQuery(pNamespace) As %String [ ZenMethod ]
{
	;Quit ##class(%SYS.PTools.SQLStats).Purge(pNamespace)
	d $SYSTEM.SQL.Purge()
	QUIT 1
}

ClassMethod SaveSQLStats(newOption) As %Integer [ ZenMethod ]
{
	Quit $SYSTEM.SQL.SetSQLStats(newOption)
}

}
