Class %CSP.UI.Portal.Shadows Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Displayed name of this page.
Parameter PAGENAME = "Shadow Server Settings";

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter EMSSERVICE = "Namespace";

/// Security requirement
Parameter RESOURCE = "%Admin_Manage";

Parameter CSPURL = "/csp/sys/mgr/%CSP.UI.Portal.Shadows.zen";

Parameter HELPADDRESS = "System Administration, Configuration, Connectivity, Shadow Server Settings";

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
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px;padding-top:10px;">
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<label id="Text1" value="#(%page.lblTitle)#" containerStyle="padding-bottom:4px;"/>
<vgroup id="fld0">
<tableNavBar showFilter="false" showMaxRows="true" showPageSize="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table" onheaderClick="return zenPage.columnSort(zenThis.getProperty('currColumn'),zenThis.getProperty('sortOrder'));"
fixedHeaders="false"
showValueInTooltip="true"
showZebra="true"
maxRows="1000"
pageSize="0"
valueColumn="Name"
useSnapshot="true"
queryClass="SYS.Shadowing.Shadow"
queryName="List"
dataSource="columns"
>
<column colName="Name" header="Name"/>
<column colName="Status" header="Status"/>
<column colName="Source Name" header="Source Name"/>
<column colName="Source Port" header="Data Port"/>
<column colName="Filter" header="Filter"/>
<column colName="LogicalStatus" hidden="true"/>
<column link="#" linkCaption="Edit" onclick="zenPage.doEdit('#(%query.Name)#');return false;"/>
<column link="#" OnDrawCell="DrawLink" seed="Start"/>
<column link="#" OnDrawCell="DrawLink" seed="Restart"/>
<column link="#" OnDrawCell="DrawLink" seed="Stop"/>
<column linkCaption="Delete" link="javascript:zenPage.deleteItem('#(%query.Name)#','table');" linkConfirm="Are you sure you want to delete shadow '%1'?" hidden="#(%page.IsEMSReadOnly)#"/>
<condition colName="LogicalStatus" predicate="NEQ" value="2" cellStyle="disabled" targetCol="Delete"/>
 </tablePane>
 </vgroup>
 <!-- block to show result -->
<label id="idRespond" enclosingClass="rednote"/>
</pane>
}

ClientMethod doEdit(shadowName) [ Language = javascript ]
{
	try {
		var url = "%25CSP.UI.Portal.Shadow.zen?PID="+encodeURIComponent(shadowName)
		this.gotoPage(url);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

/// Delete existing item.
ClientMethod deleteItem(shadowName, tableID) [ Language = javascript ]
{
	try {
		var ok = this.DeleteData(shadowName);
		if (ok != 1) {
			zen("idRespond").setValue(ok);
		} else {
			zen("idRespond").setValue("");
			zen(tableID).executeQuery();
		}
	} catch (ex) {
		alert("Error: " + ex);
	}
}

ClientMethod doNew() [ Language = javascript ]
{
	try {
		var url = "%25CSP.UI.Portal.Shadow.zen?isNew=1";
		this.gotoPage(url);
	} catch (ex) {
		alert("Error: " + ex);	
	}
}

ClientMethod changeStatus(shadow, action) [ Internal, Language = javascript ]
{
	switch(action) {
		case 0: //start
			location.href = 'UtilSysShadowAction.csp?Action=Start&$ID1='+encodeURIComponent(shadow)+'&$NAMESPACE=';
			break;
		case 1: //stop
			location.href = 'UtilSysShadowAction.csp?Action=Stop&$ID1='+encodeURIComponent(shadow)+'&$NAMESPACE=';
			break;
		case 2: //restart
			if (confirm($$$Text('Are you sure you want to restart this shadow server?'))) {
				location.href = 'UtilSysShadowAction.csp?Action=Restart&$ID1='+encodeURIComponent(shadow)+'&$NAMESPACE=';
			}
			break;
	}
}

/// Call server delete method.
ClassMethod DeleteData(Name As %String) As %String [ ZenMethod ]
{
	Try {
		// Make sure shadow isn't running at this point.
		Set shadowStatus = ##class(SYS.Shadowing.Shadow).GetStatus(Name)
		If '##class(%Library.ShadowState).CanStart(shadowStatus) {
   			Set tSC = $$$ERROR($$$ShadowStopRequired,Name)
   			throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set tSC = ##class(Config.Shadows).Delete(Name)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
	} Catch Error {
		Set tSC = ..EvalResult(Error.AsStatus())
	}
	Quit tSC
}

ClassMethod DrawLink(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status [ Internal ]
{
	Set drawLink = 0
	If (%query("LogicalStatus") = 2) {
		If pSeed = "Start" {
			Set drawLink = 1
			Set flag = 0
			Set text = $$$Text("Start")
		} ElseIf pSeed = "Restart" {
			Set drawLink = 1
			Set flag = 2
			Set text = $$$Text("Restart")
		}
	} ElseIf pSeed = "Stop" {
		Set drawLink = 1
		Set flag = 1
		Set text = $$$Text("Stop")
	}
	If drawLink = 1 {
		Set tName = $zconvert($zconvert(%query("Name"),"O","JS"),"O","HTML")
		&html<<a href="#" onclick="zenPage.changeStatus('#(tName)#',#(flag)#);return false;">#(text)#</a>>
	}
	Quit $$$OK
}

ClassMethod DrawAddress(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status [ Internal ]
{
	Write $zconvert($PIECE(%query("Address"),"|",1),"O","HTML")
	Quit $$$OK
}

ClassMethod DrawPort(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status [ Internal ]
{
	Write $zconvert($PIECE(%query("Address"),"|",2),"O","HTML")
	Quit $$$OK
}

/// Subclass can override.
Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	Set ..lblTitle = $$$TextHTML("This System has been defined as a shadow server for other database servers:")	
	Quit $$$OK
}

/// Get the (localized) name of the page.
///  This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Shadow Server Settings")
}

Method OnDrawRibbon() As %Status
{
	Do ..DrawAutoRefresh(..%GetPageName())
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set caption = $$$TextHTML("Create Shadow Server")
	Set pCommands(1) = $LB("btnNew",caption,caption,"zenPage.doNew();")

	Quit $$$OK
}

}
