/// Zen page for System Management Portal - Show Databases Freespace
Class %CSP.UI.Portal.DatabaseFreespace Extends (%CSP.UI.Portal.Template, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

/// Do not switch namespace for this page: it needs to stay in %SYS
Parameter AUTONS As %Boolean = 0;

/// Displayed name of this page.
Parameter PAGENAME = "Freespace";

Parameter CSPURL = "/csp/sys/op/%CSP.UI.Portal.DatabaseFreespace.zen";

Parameter HELPADDRESS = "Home,Databases,Freespace";

Parameter PARENTPAGE = "/csp/sys/op/%CSP.UI.Portal.OpDatabases.zen";

/// Security requirement
Parameter RESOURCE = "%Admin_Operate";

Property msgValidate As %ZEN.Datatype.caption [ InitialExpression = {$$$TextJS("Please enter a number that is less than the current size. To remove all unused space, enter 0.")} ];

XData Style
{
<style type="text/css">
/* light blue for Operations pages*/
.ribbonTitle {
	background: #C7E4EC;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane containerStyle="padding:20px">
<label id="Text1" value="" containerStyle="padding-bottom:4px;"/>
<timer id="refreshTimer" timeout="0" ontimeout="zenPage.refreshHandler();"/>
<tableNavBar showFilter="true" showMaxRows="true" showPageSize="true" tablePaneId="table"
onfilterChange="zenPage.filterChanged(value);"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
title="Enter the leading characters of a database name followed by [Tab] to filter the list. For example: C for all database names starting with letter 'C'." 
/>
<tablePane id="table" cellSpacing="2"
queryClass="SYS.Database"
queryName="FreeSpace"
dataSource="columns"
fixedHeaders="false"
pageSize="0"
maxRows="1000"
showValueInTooltip="true"
showZebra="true"
valueColumn="Directory"
useSnapshot="true"
>
<column colName="DatabaseName" header="Name"/>
<column colName="Directory" header="Directory"/>
<column colName="MaxSize" header="Max Size"/>
<column colName="Size" hidden="true"/>
<column colName="SizeInt" header="Size" OnDrawCell="DrawDB"/>
<column colName="ExpansionSize" header="Expansion Size"/>
<column colName="Available" hidden="true"/>
<column colName="AvailableNum" header="Available" OnDrawCell="DrawDB"/>
<column colName="Free" header="% Free"/>
<column colName="DiskFreeSpace" hidden="true"/>
<column colName="DiskFreeSpaceNum" header="Disk Free Space" OnDrawCell="DrawDB"/>
<column colName="Status" header="Status"/>
<column colName="ReadOnly" hidden="true"/>
<column linkCaption="Truncate" link="%25CSP.UI.Portal.DatabaseFreespaceCleanup.zen?DBName=#(%query.DatabaseName)#&amp;Directory=#(%query.Directory)#" />
<column linkCaption="Compact" link="%25CSP.UI.Portal.DatabaseFreespaceCompact.zen?DBName=#(%query.DatabaseName)#&amp;Directory=#(%query.Directory)#" />
<parameter value="#(%page.Filter)#"/>
<parameter value="0"/>
<condition colName="DatabaseName" predicate="EQ" value="" cellStyle="disabled" targetCol="Truncate"/> 
<condition colName="DatabaseName" predicate="EQ" value="" cellStyle="disabled" targetCol="Compact"/> 
<condition colName="ReadOnly" predicate="EQ" value="1" cellStyle="disabled" targetCol="Truncate"/> 
<condition colName="ReadOnly" predicate="EQ" value="1" cellStyle="disabled" targetCol="Compact"/> 
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
	this.Filter = value;
	this.UpdateTableNavState(value,this.TablePageSize,this.TableMaxRows);
}

/// User override of cell-display for tablePane.
Method DrawDB(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	#; Draw HTML to render table cell in proper DB size.
	Set dbSizeLogicalToDisplay = ##class(SYS.Database).FormatSizes(%query(pName))
	&html<&nbsp;#(dbSizeLogicalToDisplay)#>
	Quit $$$OK
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()
	Set ..%GetComponentById("Text1").value = $$$Text("The following is a list of the local databases with freespace information:")		
	Quit $$$OK
}

Method %OnGetPageName() As %String
{
	 Quit $$$Text("Database Freespace")
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) <br/>
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set NAMESPACE = $G(%session.Data("$NAMESPACE"))
	Set tPageName = $$$Text("System","%Utility")
	Set tURL = $$$GetHomePage
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	Set tPageName = $$$Text("Databases")
	Set tURL = ..ParentURL
	Set pLink($I(pLink)) = $LB(tPageName,tURL)

	// default: add *this* page to list
	Set tPageName = ..StdTitle
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT($className(),"O","URL")_".zen"_$S(NAMESPACE="":"",1:"?$NAMESPACE="_$ZCVT(NAMESPACE,"O","URL")))
	Quit $$$OK
}

}
