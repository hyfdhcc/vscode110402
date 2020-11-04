Include %sqlui

/// System Management Portal - System Operations - Task Schedule 
Class %CSP.UI.Portal.TaskSchedule Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.TaskSchedule.zen";

Parameter HELPADDRESS = "Home,Task Manager,View Task Schedule";

/// Displayed name of this page.
Parameter PAGENAME = "Task Schedule";

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

Property AppContextPathProp As %ZEN.Datatype.string [ InitialExpression = "%CSP.UI.Portal" ];

Property CurrentColumn As %ZEN.Datatype.string [ InitialExpression = "ID" ];

Property Filter As %ZEN.Datatype.string;

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
queryClass="%SYS.Task"
queryName="TaskListFilter"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="true"
valueColumn="ID"
useSnapshot="true"
> 
<column colName="Task Name" header="Task Name" link="#(%page.AppContextPathProp)#.TaskInfo.zen?$ID1=#(%query.ID)#" 
title="View details of this task"/>
<column colName="Task Type" header="Task Type"/>
<column colName="Namespace" header="Namespace"/>
<column colName="Description" header="Description"/>
<column colName="ID"/>
<column colName="Suspended" header="Suspended"/>
<column colName="Last Finished" header="Last Finished"/>
<column colName="Next Scheduled" header="Next Scheduled"/>

<column linkCaption="History" link="#(%page.AppContextPathProp)#.TaskHistoryId.zen?$ID1=#(%query.ID)#" 
style="text-align:center;" title="View history of this task"/>

<column linkCaption="Run" id="LinkRun" link="UtilSysTaskAction.csp?Type=Run&amp;$ID1=#(%query.ID)#" 
style="text-align:center;" title="Run this task"/>

<condition colName="Suspended" predicate="NEQ" value="NULL" rowStyle="background: #FFB6C1;" cellStyle="disabled" targetCol="Run"/> 
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

	Set ..%GetComponentById("Text1").value = $$$Text("The following is a list of tasks scheduled for execution:")
		
	#; Check if user has security for "Run" schedule.
	If '$System.Security.Check("%Admin_Task","USE") {
		Set ..%GetComponentById("LinkRun").hidden = 1
	}
	// The default filter in the page we inherit from is initially set to "*". This screws up the new filtering system.
	i ..Filter="*" s ..Filter=""
	Quit $$$OK
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set tPageName = $$$Text("System")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Task Manager")
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen")
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Task Schedule")
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
