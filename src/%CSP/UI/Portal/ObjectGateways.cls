/// Zen page for System Management Portal - Object Gateways
Class %CSP.UI.Portal.ObjectGateways Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As BOOLEAN = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Object Gateways";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.ObjectGateways.zen";

Parameter HELPADDRESS = "System Administration, Configuration, Connectivity, Object Gateways";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Property msgStart As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Start")} ];

Property msgStop As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Stop")} ];

Property msgEdit As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Edit")} ];

Property msgDelete As %ZEN.Datatype.caption [ InitialExpression = {$$$Text("Delete")} ];

XData Style
{
<style type="text/css">
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px;padding-top:10px;">
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<spacer height="10" />
<tableNavBar showFilter="false" showMaxRows="true" showPageSize="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table"
queryClass="%Net.Remote.ObjectGateway"
queryName="ByGateway"
dataSource="columns"
fixedHeaders="false"
ondblclick="javascript:zenPage.doEditD();"
pageSize="0"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
valueColumn="Name"
useSnapshot="true"
width="800"
>
<column colName="Name" header="Name"/>
<column colName="Type" header="Type"/>
<column colName="Server" header="Server"/>
<column colName="Port" header="Port"/>
<column colName="State" hidden="true"/>
<column colName="StateExt" header="State"/>
<column linkCaption="Activity" link="%25CSP.UI.Portal.ObjectGatewayActivities.zen?PID=#(%query.Name)#"/>
<column id="colStart" linkCaption="Start" link="javascript:zenPage.doStart('#(%query.Name)#');" linkConfirm="Are you sure you want to start '%1'?"/>
<column id="colStop" linkCaption="Stop" link="javascript:zenPage.doStop('#(%query.Name)#');" linkConfirm="Are you sure you want to stop '%1'?"/>
<column id="colEdit" linkCaption="Edit" link="%25CSP.UI.Portal.ObjectGateway.zen?PID=#(%query.Name)#"/>
<column id="colDelete" linkCaption="Delete" link="javascript:zenPage.doDelete('#(%query.Name)#');" linkConfirm="Are you sure you want to delete '%1'?" />
<condition colName="State" predicate="EQ" value="1" cellStyle="disabled" targetCol="#(%page.msgEdit)#"/>
<condition colName="State" predicate="EQ" value="1" cellStyle="disabled" targetCol="#(%page.msgDelete)#"/>
<condition colName="State" predicate="EQ" value="1" cellStyle="disabled" targetCol="#(%page.msgStart)#"/>
<condition colName="State" predicate="EQ" value="0" cellStyle="disabled" targetCol="#(%page.msgStop)#"/>

 </tablePane>
</pane>
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	Set ..lblTitle = $$$Text("Object Gateway Server definitions provide a way to communicate with external APIs and data sources. A list of currently defined Object Gateway Server definitions are shown below:")
	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	Quit $$$Text("Object Gateways")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()
	
	// commands: $LB(id,caption,help,onclick)
	Set caption = $$$Text("Create New Gateway")
	Set pCommands(1) = $LB("btnAdd",caption,caption,"zenPage.doNew();")

	Quit $$$OK
}

/// User clicked Activities link. Goto to Activities page.
ClientMethod doActivities(PID) [ Language = javascript ]
{
	this.gotoPage("%25CSP.UI.Portal.ObjectGatewayActivities.zen?PID="+encodeURIComponent(PID));
}

/// User clicked Start link. Goto to Start page.
ClientMethod doStart(PID) [ Language = javascript ]
{
	this.gotoPage("%25CSP.UI.Portal.ObjectGatewayStart.zen?PID="+encodeURIComponent(PID));
}

/// User clicked Stop link. Goto to Stop page.
ClientMethod doStop(PID) [ Language = javascript ]
{
	this.gotoPage("%25CSP.UI.Portal.ObjectGatewayStop.zen?PID="+encodeURIComponent(PID));
}

/// User clicked Start link. Goto to Start page.
ClientMethod doNew() [ Language = javascript ]
{
	this.gotoPage("%25CSP.UI.Portal.ObjectGateway.zen?isNew=1");
}

/// User double clicked a row. Go to edit.
ClientMethod doEditD() [ Language = javascript ]
{
	var PID = zenPage.getComponentById('table').getValue();
	this.doEdit(PID);
}

/// User clicked the "Edit" link.
ClientMethod doEdit(PID) [ Language = javascript ]
{
	try {
		this.gotoPage("%25CSP.UI.Portal.ObjectGateway.zen?PID="+encodeURIComponent(PID));
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Delete existing gateway connection.
ClientMethod doDelete(PID) [ Language = javascript ]
{
	try {
		var ok = this.DeleteItem(PID);
		if (ok == 1) {
			var table = zenPage.getComponentById('table');
			table.setProperty("selectedIndex",-1);
			table.executeQuery();
		} else {
			alert(ok);
		}
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Call server delete method.
ClassMethod DeleteItem(PID) As %String [ ZenMethod ]
{
	Set $ZT="Error"
	Set tSC = ##class(%Net.Remote.ObjectGateway).%DeleteId(PID)
	If $$$ISERR(tSC) {
		Set ok = $System.Status.GetErrorText(tSC)
	} Else {
		Set ok = 1
	}
	Quit ok
Error	///
	Set $ZT="" Do BACK^%ETN
	Quit $ZCVT($ZE,"O","JS")
}

ClassMethod IsHealthShareInstalled() As %Boolean
{
	Quit $D(^%SYS("HealthShare"))>0
}

/// Return true if Object Gateways option can be shown.
ClassMethod EnableObjectGateways() As %Boolean
{
	/// If Windows return true
	If $zversion(1) = 2 Quit 1
	/// If VMS then return false
	If $zversion(1) = 1 Quit 0
	/// If Unix and Ensemble enabled, return true, else return false
	If ##class(%Library.EnsembleMgr).IsEnsembleInstalled() Quit 1
	Quit 0
}

}
