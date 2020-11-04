Include %sqlui

/// System Management Portal - System Operations - Task Hisotry
/// If $ID1 is passed in then show task history for that ID only. 
Class %CSP.UI.Portal.TaskHistory Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.TaskHistory.zen";

Parameter HELPADDRESS = "Home,Task Manager,View Task History";

/// Displayed name of this page.
Parameter PAGENAME = "Task History";

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

Property CurrentColumn As %ZEN.Datatype.string [ InitialExpression = "Last Start" ];

/// internal task ID
Property PID As %String(ZENURL = "$ID1");

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
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px;padding-top:10px;">
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>

<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<tableNavBar showFilter="true" showPageSize="true" tablePaneId="table" showMaxRows="true"
onfilterChange="zenPage.filterChanged(value,zenThis.tablePaneId);"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
title="Enter a string to filter the list"
/>
<tablePane id="table" onheaderClick="return zenPage.columnSort(zenThis.getProperty('currColumn'),zenThis.getProperty('sortOrder'));"
queryClass="%SYS.Task.History"
queryName="DescendingTaskHistoryFilter"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="true"
valueColumn="Pid"
useSnapshot="true"
>
<column colName="Last Start" header="Last Start"/>
<column colName="Completed" header="Completed"/>
<column colName="Task Name" header="Task Name"/>
<column colName="Status" header="Status"/>
<column colName="Result" header="Result"/>
<column colName="Task" header="Task"/>
<column colName="NameSpace" header="Namespace"/>
<column colName="Routine" header="Routine"/>
<column colName="Pid" header="PID"/>
<column colName="%ER Date" header="%ER Date"/>
<column colName="%ER Error #" header="%ER Error #"/>
<column colName="Username" header="User"/>
<column colName="LogDate" header="Log Date"/>
<column colName="LogTime" header="Log Time"/>
<condition colName="Status" predicate="NEQ" value="1" rowStyle="background: #FFB6C1;"/> 
<parameter value="#(%page.Filter)#"/>
 </tablePane>

</pane>
}

/// User entered something in to the filter. Re-load the table with filter value.
ClientMethod filterChanged(value, tableID) [ Language = javascript ]
{
	var table = zen(tableID);
	if (value=="*") value="";
	table.parameters[0].value = value;
	table.executeQuery();
	table.currColumn = this.CurrentColumn;
	table.sortOrder = this.CurrentSort;
	this.updateTime();
	this.Filter = value;
	this.UpdateTableNavState(value,this.TablePageSize,this.TableMaxRows);
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..%GetComponentById("Text1").value = $$$Text("The following is a list of Task Manager activities:")
	// The default filter in the page we inherit from is initially set to "*". This screws up the new filtering system.
	i ..Filter="*" s ..Filter=""

	Quit $$$OK
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)
	
	Set tPageName = $$$Text("Task Manager")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen?"_$S(NAMESPACE="":"",1:"&$NAMESPACE="_$ZCVT(NAMESPACE,"O","URL")))
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Task History")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()
	
	Quit $$$OK
}

/// Add to the contents of the tool ribbon.
Method OnDrawRibbon() As %Status
{
	Do ..DrawAutoRefresh(..%GetPageName())
	Quit $$$OK
}

}
