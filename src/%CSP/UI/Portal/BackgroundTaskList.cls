/// System Management Portal - System Operations - Background Tasks 
Class %CSP.UI.Portal.BackgroundTaskList Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/%CSP.UI.Portal.BackgroundTaskList.zen";

Parameter HELPADDRESS = "Home,Background Tasks";

/// Displayed name of this page.
Parameter PAGENAME = "Background Tasks";

/// Column the table is sorted by. Default is the "Process ID" column. User may change and the value is saved and reloaded for this page.
Property CurrentColumn As %ZEN.Datatype.string [ InitialExpression = "ID" ];

Property ErrorPage As %String [ InitialExpression = {..Link("%25CSP.UI.Portal.BackgroundTaskError.zen",,1)} ];

/// Page size value user entered into the "Page size" field in the table navigator. This value is saved and reloaded for this page.
Property TablePageSize As %Integer [ InitialExpression = "0" ];

/// Max rows value user entered into the "Max rows" field in the table navigator. This value is saved and reloaded for this page.
Property TableMaxRows As %Integer [ InitialExpression = "1000" ];

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
<tableNavBar id="tblNavBar" tablePaneId="table" showFilter="false" showPageSize="true" showMaxRows="true" saveSizeMax="true"
onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table" onheaderClick="return zenPage.columnSort(zenThis.getProperty('currColumn'),zenThis.getProperty('sortOrder'));"
queryClass="%CSP.UI.System.BackgroundTask"
queryName="EnumerateTasks"
dataSource="columns"
fixedHeaders="false"
initialExecute="true"
maxRows="1000"
multiSelect="false"
pageSize="0"
showValueInTooltip="false"
showZebra="true"
valueColumn="ID"
useSnapshot="true"
>
<column colName="ID" header="ID" title="Job number used as an index."/>
<column colName="StartTime" header="Start Time"/>
<column colName="Namespace" header="Namespace"/>
<column colName="Task" header="Task"/>
<column colName="Status" header="Status"/>
<column colName="Details" header="Details" style="white-space:normal !important;"/>
<column colName="ErrorCount" OnDrawCell="DrawErrorCount" header="Error Count"/>

<condition colName="Status" predicate="EQ" value="ERROR" rowStyle="background: #FFB6C1;"/>
 </tablePane>
</pane>
}

ClientMethod doErrors(pid) [ Language = javascript ]
{
	this.gotoPage(this.ErrorPage+'PID='+pid);
}

ClassMethod DrawErrorCount(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	If ($G(%query(pName),0) > 0) {
		Set title = $$$Text("View details of the error log for this task")
		&html<<div class="tpAction" style="text-align:center;white-space:nowrap;">>
		&html<<a href="#" onclick="zenPage.doErrors('#(%query("ID"))#');return false;" title="#(title)#">#(%query(pName))#</a>>
		&html<</div>>
	}
	Quit $$$OK
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..%GetComponentById("Text1").value = $$$Text("Current background tasks:")
		
	Quit $$$OK
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_$S(NAMESPACE="":"",1:"?$NAMESPACE="_$ZCVT(NAMESPACE,"O","URL")))
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnPurge",$$$Text("Purge Log"),$$$Text("Purge background tasks log."),"zenPage.doPurge();")

	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Background Tasks")
}

ClientMethod doPurge() [ Language = javascript ]
{
	if (!confirm($$$Text('Are you sure you want to purge all entries in this log?'))) return;
	var st = this.Purge();
	this.updateView();
}

ClassMethod Purge() As %Status [ ZenMethod ]
{
	Kill ^CacheTemp.MgtPortalTask
	Quit $$$OK
}

/// Add to the contents of the tool ribbon.
Method OnDrawRibbon() As %Status
{
	Do ..DrawAutoRefresh(..%GetPageName())
	Quit $$$OK
}

}
