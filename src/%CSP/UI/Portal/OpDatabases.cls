/// System Management Portal - System Operations - Local Databases 
Class %CSP.UI.Portal.OpDatabases Extends %CSP.UI.Portal.Utils [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.OpDatabases.zen";

Parameter HELPADDRESS = "Home,Databases";

/// Displayed name of this page.
Parameter PAGENAME = "Operation Local Databases";

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

Property msgDismount As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Are you sure you want to dismount database %1?")} ];

Property FreespacePage As %String;

XData Style
{
<style type="text/css">

</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" containerStyle="padding:20px;padding-top:10px;">
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<tableNavBar showFilter="true" showPageSize="true" tablePaneId="table" showMaxRows="true"  
onfilterChange="zenPage.filterChanged(value);"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
title="Enter the leading characters of a database name followed by [Tab] to filter the list. For example: C for all database names starting with letter 'C'." 
/>
<tablePane id="table" cellSpacing="2" onheaderClick="return zenPage.columnSort(zenThis.getProperty('currColumn'),zenThis.getProperty('sortOrder'));"
queryClass="Config.Databases"
queryName="LocalDatabaseList"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
multiSelect="false"
showValueInTooltip="false"
showZebra="true"
valueColumn="Directory"
useSnapshot="true"
>
<column colName="Name" header="Name" link="%25CSP.UI.Portal.DatabaseDetails.zen?$ID1=#(%query.Directory)#&amp;DBName=#(%query.Name)#"
 title="View database properties"/>
<column colName="Mirror" header="Mirror" hidden="true"/>
<column colName="Directory" header="Directory"/>
<column colName="Maximum Size in GB" header="Max Size (GB)"/>
<column colName="Size in MB" header="Size (MB)"/>
<column colName="Status" header="Status"/>
<column colName="Encrypted" header="Encrypted"/>
<column colName="Journal" header="Journal"/>
<column colName="Resource" hidden="true"/>
<column colName="StatusInt" hidden="true"/>
<column linkCaption="Dismount" link="javascript:zenPage.doDismount('#(%query.Directory)#','#(%query.Name)#');" 
style="text-align:center;"/>
<column linkCaption="Mount" link="javascript:zenPage.doMount('#(%query.Directory)#','#(%query.Name)#');"
style="text-align:center;"/>
<parameter value="#(%page.Filter)#"/>
<parameter value=""/>
<condition colName="Name" predicate="EQ" value="CACHELIB" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="Name" predicate="EQ" value="CACHESYS" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="Name" predicate="EQ" value="CACHETEMP" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="Name" predicate="EQ" value="CACHEAUDIT" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="Name" predicate="EQ" value="CACHE" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="Name" predicate="EQ" value="CACHELIB" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="Name" predicate="EQ" value="CACHESYS" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="Name" predicate="EQ" value="CACHETEMP" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="Name" predicate="EQ" value="CACHEAUDIT" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="Name" predicate="EQ" value="CACHE" cellStyle="disabled" targetCol="Mount"/> 

<condition colName="StatusInt" predicate="EQ" value="Dismounted" rowStyle="background: #FFB6C1;" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="StatusInt" predicate="EQ" value="Unmounted" rowStyle="background: #FFB6C1;" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="StatusInt" predicate="EQ" value="Unavailable" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="StatusInt" predicate="EQ" value="Expanding" cellStyle="disabled" targetCol="Dismount"/> 
<condition colName="StatusInt" predicate="EQ" value="Expanding" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="StatusInt" predicate="EQ" value="ClusterMounted/R" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="StatusInt" predicate="EQ" value="ClusterMounted/RW" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="StatusInt" predicate="EQ" value="Mounted/R" cellStyle="disabled" targetCol="Mount"/> 
<condition colName="StatusInt" predicate="EQ" value="Mounted/RW" cellStyle="disabled" targetCol="Mount"/> 

 </tablePane>
</pane>
}

/// User entered something in to the filter. Re-load the table with filter value.
ClientMethod filterChanged(value) [ Language = javascript ]
{
	var table = zen("table");
	if (value.indexOf("*") == -1) {
		value += "*";
	}
	table.parameters[0].value = value;
	table.executeQuery();
	table.currColumn = this.CurrentColumn;
	table.sortOrder = this.CurrentSort;
	this.updateTime();
	this.Filter = value;
	this.UpdateTableNavState(value,this.TablePageSize,this.TableMaxRows);
}

/// Update / Reload table. This overrides the one in Portal.Utils.
ClientMethod updateView() [ Language = javascript ]
{
	this.filterChanged(this.Filter);
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set ..%GetComponentById("Text1").value = $$$Text("The following is a list of the local databases:")
		
	Set ..FreespacePage = ..Link("%25CSP.UI.Portal.DatabaseFreespace.zen")
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
	Set pCommands(1) = $LB("btnFreespace",$$$Text("Freespace"),$$$Text("List databases info with freespaces calculated"),"zenPage.doFreespace();")
	Set pCommands(2) = $LB("btnIntergrity",$$$Text("Integrity Check"),$$$Text("Perform background integrity check on selected databases"),"zenPage.doIntegrity();")
	Set pCommands(3) = $LB("btnLog",$$$Text("Integrity Log"),$$$Text("View integrity check result logs"),"zenPage.doLog();")
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Databases")
}

ClientMethod doDismount(dir, dbname) [ Language = javascript ]
{
	var msg = this.msgDismount;
	msg = msg.replace("%1",dbname);
	var ok = confirm(msg);
	if (ok == false) return;
	ok = this.Dismount(dir);
	if (ok != "") {
		alert(ok);
	} else {
		document.location.reload();	
	}
}

ClientMethod doMount(dir, dbname) [ Language = javascript ]
{
	var url = "%CSP.UI.Portal.Dialog.DBActions.zen";
	zenLaunchPopupWindow('%CSP.UI.Portal.Dialog.DBActions.zen?Dir=' + encodeURIComponent(dir) + '&DBName=' + encodeURIComponent(dbname) + '&ACTION=Mount','MountDB','resizable,width=500,height=600');
}

ClientMethod doFreespace() [ Language = javascript ]
{
	document.location.href = this.FreespacePage;
}

ClientMethod doIntegrity() [ Language = javascript ]
{
	zenLaunchPopupWindow('%CSP.UI.Portal.Dialog.Integ.zen?FILETYPE=Integ','IntegCheck','status,scrollbars,resizable=yes,width=900,height=700');
}

ClientMethod doLog() [ Language = javascript ]
{
	zenLaunchPopupWindow('%CSP.UI.Portal.Dialog.IntegLog.zen','IntegLog','status,scrollbars,resizable=yes,width=900,height=700');
}

/// This client event, if present, is fired when the a popup page
/// launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	switch(popupName) {

	case 'MountDB':
		try {
			if (action == "ok") {
				document.location.reload();	
				break;
			}
		} catch (ex) {
			alert("Error: " + ex);
		}
		break;
	}

	return true;
}

/// Dismount a DB.
ClassMethod Dismount(Dir As %String) As %String [ ZenMethod ]
{
	Set tmsg = ""
	If '##class(SYS.Database).%ExistsId(Dir) {
		Set tmsg = $$$Text("Database no longer exists.")
		Quit tmsg
	}
	Set dbOBJ = ##class(SYS.Database).%OpenId(Dir,,.Status)
	If '$$$ISOK(Status) {
		Set tmsg = Status
		Quit tmsg
	}
	Set Mounted = dbOBJ.Mounted
	Kill dbOBJ
	If Mounted = 0 {
		Set tmsg = $$$Text("Database is not mounted. Cannot perform dismount.")
	} Else {
		Set Status = ##class(SYS.Database).DismountDatabase(Dir)
		If Status '= 1 {
			Set tmsg = $ZCVT(Status,"O","HTML")
		} 
	}
	Quit tmsg
}

/// This is called in the middle of rendering the tool ribbon.
/// Subclasses can inject their own content into the ribbon by writing it out in this method.
/// This content should be wrapped within a td element.
Method OnDrawRibbon() As %Status
{
	Do ..DrawAutoRefresh(..%GetPageName())
	Quit $$$OK
}

}
