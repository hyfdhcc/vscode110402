/// System Management Portal - System Operations - View Locks (Remove not allowed)
Class %CSP.UI.Portal.LocksView Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.LocksView.zen";

Parameter HELPADDRESS = "Home,Locks";

/// Displayed name of this page.
Parameter PAGENAME = "ViewLocks";

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

XData Style
{
<style type="text/css">
/* additonal style for table pane */
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
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<group>
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-bottom:4px;"/>
<checkbox id="DisplayRoutine" caption="Display Owner's Routine Information" onchange="zenPage.displayroutine(zenThis.getValue())"/>
<tableNavBar id="tableNav" showFilter="true" showPageSize="true" tablePaneId="table" showMaxRows="true"
onfilterChange="zenPage.filterChanged(value);"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
title="Enter an string to filter the list"
/>
<tablePane id="table" 
queryClass="%SYS.LockQuery"
queryName="WebListFilter"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="true"
valueColumn="DeleteID"
useSnapshot="true"
>
<column colName="Removable" hidden="true"/>
<column colName="DeleteID" hidden="true"/>
<column colName="CanBeExamined" hidden="true"/>
<column colName="RemoteOwner" hidden="true"/>
<column colName="PidInternal" hidden="true"/>

<column colName="Pid" header="Owner"/>
<column colName="ModeCount" header="ModeCount"/>
<column colName="Reference" header="Reference"/>
<column colName="Directory" header="Directory"/>
<column colName="System" header="System"/>
<column colName="RoutineInfo" header="Routine"/>

<parameter value="#(%page.Filter)#"/>
<parameter value="1"/>

 </tablePane>
 </group>
</pane>
}

/// User entered something in to the filter. Re-load the table with filter value.
ClientMethod filterChanged(value) [ Language = javascript ]
{
	var table = zen("table");
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
	
	Set ..%GetComponentById("Text1").value = $$$Text("The following is a list of the current Locks:")
		
	// The default filter in the page we inherit from is initially set to "*". This screws up the new filtering system.
	i ..Filter="*" s ..Filter=""
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
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_$S(NAMESPACE="":"",1:"?$NAMESPACE="_..EscapeURL(NAMESPACE)))
	Quit $$$OK
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
	Do ..DrawAutoRefresh(..%OnGetPageName())
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("View Locks")
}

/// Update table.
ClientMethod updateView() [ Language = javascript ]
{
	window.location.reload();
}

/// Toggle for displaying routine information.
ClientMethod displayroutine(value) [ Language = javascript ]
{
	var table = zen("table");
	table.parameters[1].value = !value;
	table.executeQuery();
}

}
