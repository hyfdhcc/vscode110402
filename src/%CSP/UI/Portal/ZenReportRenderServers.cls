/// Zen page for System Management Portal - Zen Report Render Servers
Class %CSP.UI.Portal.ZenReportRenderServers Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Zen Report Render Servers";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.ZenReportRenderServers.zen";

Parameter HELPADDRESS = "Home,Configuration,Zen Report Render Servers";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

XData Style
{
<style type="text/css">
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<spacer height="10" />
<tableNavBar showFilter="false" showMaxRows="true" showPageSize="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table"
queryClass="%ZEN.Report.RenderServer"
queryName="ByServer"
dataSource="columns"
fixedHeaders="false"
ondblclick="javascript:zenPage.doEditD();"
pageSize="0"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
valueColumn="Name"
useSnapshot="true"
width ="600"
>
<parameter value="" />
<column colName="Name" header="Name"/>
<column colName="Port" header="Port"/>
<column colName="PingPort" header="Ping Port"/>
<column colName="Renderer" header="Renderer"/>
<column colName="State" hidden="true"/>
<column colName="StateEx" header="State"/>
<column linkCaption="Manage" link="%25CSP.UI.Portal.ZenReportRenderServer.zen?PID=#(%query.Name)#"/>

 </tablePane>
</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	Set (..LocatorHeader,..StdTitle) = $$$Text("Zen Report Render Servers")
	Set ..lblTitle = $$$Text("Zen Report Render Server definitions provide a way to specify parameters to start external render servers for Zen Reports. A list of currently defined Zen Report Render Servers is shown below:")

	Quit $$$OK
}

ClientMethod doAdd() [ Language = javascript ]
{
	document.location = '%25CSP.UI.Portal.ZenReportRenderServer.zen?isNew=1';
}

/// User double clicked a row. Go to the manage page.
ClientMethod doEditD() [ Language = javascript ]
{
	var PID = zenPage.getComponentById('table').getValue();
	this.doManage(PID);
}

/// User clicked the "Manage" link.
ClientMethod doManage(PID) [ Language = javascript ]
{
	try {
		this.gotoPage("%25CSP.UI.Portal.ZenReportRenderServer.zen?PID="+encodeURIComponent(PID));
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

///  Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick,disabled)
	Set pCommands(1) = $LB("btnAdd",$$$Text("New Render Server"),$$$Text("Add a new server definition"),"zenPage.doAdd();")

	Quit $$$OK
}

}
