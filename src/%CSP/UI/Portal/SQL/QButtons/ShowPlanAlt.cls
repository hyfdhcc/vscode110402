Class %CSP.UI.Portal.SQL.QButtons.ShowPlanAlt Extends %CSP.UI.Template.Property [ System = 4 ]
{

Parameter RESOURCE = "%Development:USE";

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.SQL.QButtons.ShowPlanAlt.zen";

Parameter HELPADDRESS = "Home,SQL Alternate Show Plans";

/// Displayed name of this page.
Parameter PAGENAME = "SQL.QButtons.ShowPlanAlt";

Property PlanPage As %String;

XData Style
{
<style type="text/css">
#groupView {
	height: 500px;
	width: 550px;
	overflow: auto;
}
#propertyPane {
	background: white;
	height: 449px;
	width: 550px;
	border-right: none;
	border-bottom: none;
	display: none;
}
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none" containerStyle="padding-top:10px;">
<label id="Text1" value="" enclosingStyle="padding:10px;"/>
<vgroup id="groupContent" cellVAlign="top" hidden="false" >
<label id="idRespond" enclosingClass="note" value="" hidden="true" containerStyle="padding-left:10px;"/>
<hgroup id="mainGroup" cellVAlign="top">


<hgroup>
<vgroup id="groupView" valign="top">
<hgroup labelPosition="left" enclosingStyle="padding:4px;" cellAlign="even">
<label label="Enter an SQL query and click on Show Plan Options, the resulting table will list the different plans the SQL Optimizer generated." labelClass="caption"/>
</hgroup>
<spacer height="2"/>
<form id="form1" labelPosition="top">
<textarea id="QueryText" label="SQL Statement:" labelClass="normal" rows="5" cols="80" valign="top" containerStyle="padding-top:10px;"/>
<button id="btnShowPlan" caption="Show Plan Options" controlClass="commandButton" onclick="zenPage.GetPlans();"/>
</form>
<tablePane  id="GetPlansTable" label="Possible Plans" labelClass="caption"
queryClass="%SYS.PTools.SQLUtilities"
queryName="PossiblePlans"
cellSpacing="1"
dataSource="columns"
fixedHeaders="false"
multiSelect="true"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
valueColumn="ID"
useSnapshot="true"
initialExecute="false"
>
<column colName="ID"/>
<column colName="Cost"/>
<column colName="MapType"/>
<column colName="StartingMap"/>
<column linkCaption="Show Plan" link="javascript:zenPage.doShowPlan('#(%query.ID)#');" 
style="text-align:center;" title="View Show Plan for this plan"/>
<parameter value=""/>
</tablePane>

<hgroup labelPosition="left" enclosingStyle="padding:4px;" cellAlign="even">
<label label="Select Plans from above table by clicking the Compare check box, then click the Compare Plans button" labelClass="caption"/>
</hgroup>
<hgroup labelPosition="left" enclosingStyle="padding:4px;" cellAlign="even">
<label label="Each plan will be executed and then displayed with SQLStats" labelClass="caption"/>
</hgroup>
<spacer height="2"/>
<form id="form2" labelPosition="top">
<button id="btnCompare" caption="Compare Show Plans with Stats" controlClass="commandButton" onclick="zenPage.ComparePlans();"/>
</form>
<tablePane  id="ComparePlansTable" label="Compare Possible Plans" labelClass="caption"
queryClass="%SYS.PTools.SQLUtilities"
queryName="PossiblePlansStats"
hidden="true"
cellSpacing="1"
dataSource="columns"
fixedHeaders="false"
multiSelect="false"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
valueColumn="ID"
useSnapshot="true"
initialExecute="false"
>
<column colName="ID"/>
<column colName="Cost"/>
<column colName="StartingMap"/>
<column colName="GlobalRef"/>
<column colName="Commands"/>
<column colName="TotalTime"/>
<column colName="RowsReturned"/>
<column linkCaption="Show Plan" link="javascript:zenPage.doShowPlan('#(%query.ID)#');" 
style="text-align:center;" title="View Show Plan for this plan"/>
<parameter value=""/>
<parameter value=""/>
</tablePane>
</vgroup>
<spacer width="5"/>

<vgroup id="propertyPane" hidden="true" valign="top">
<iframe id="outputShowplan" valign="top" containerStyle="padding-top:10px;" hidden="true"/>
</vgroup>
</hgroup>
</hgroup>
</vgroup>

</pane>
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

		var rightDiv = zen('propertyPane').getEnclosingDiv(); //right
		var leftDiv = zen('groupView').getEnclosingDiv(); //left

		var halfWinWidth = (winWidth / 2) - 25;
		halfWinWidth = (halfWinWidth<300) ? 300 : halfWinWidth;
	
		leftDiv.style.width = halfWinWidth - 20 + 'px';
		rightDiv.style.width = halfWinWidth + 'px';
	
		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 100;
		var tabBodyHgt = (hgt - 30);

		tabBodyHgt = (tabBodyHgt < 141 ? 141 : tabBodyHgt);

		frame = zen("outputShowplan");
		frame.setProperty("width",rightDiv.style.width);
		frame.setProperty("height",tabBodyHgt - 140 + 'px');

	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

/// Invoke method to gather SQL Statements and update SQL Statement Count table. During this time, disable the rasio buttons.
ClientMethod GetPlans() [ Language = javascript ]
{
	zen("propertyPane").setHidden(true);
	zen('outputShowplan').setHidden(true);
	zen("ComparePlansTable").setHidden(true);
	var table = zen("GetPlansTable");
	var query = zen("QueryText").getValue();
	
	table.parameters[0].value = query;
	table.executeQuery(query);
	table.refreshContents();
}

ClientMethod ComparePlans() [ Language = javascript ]
{
	zen("ComparePlansTable").setHidden(false);
	var table1 = zen("GetPlansTable");
	var selectedRows = table1.getProperty("selectedRows");
	var table2 = zen("ComparePlansTable");
	var query = zen("QueryText").getValue();
	table2.parameters[0].value = query;
	table2.parameters[1].value = selectedRows;
	table2.executeQuery();
	table2.refreshContents();
}

ClientMethod doShowPlan(ID) [ Language = javascript ]
{
	zen("propertyPane").setHidden(false);
	zen('outputShowplan').setHidden(false);
	var propDiv = zen('propertyPane').getEnclosingDiv();
	propDiv.style.display = 'block';

	
	var query = zen("QueryText").getValue();
	this.PrepareShowPlan(query);
	var planlink = this.PlanPage + "?namespace="+encodeURIComponent(this.NAMESPACE)+"&stats=3&AltPlan="+ID;
	zen('outputShowplan').setProperty('src',planlink);
}

Method DrawCompare(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	&html<<input type="checkbox"></input>>
	Quit $$$OK
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC

	Set %page.NAMESPACE = $G(%request.Data("$NAMESPACE",1))
	If %page.NAMESPACE = "" Set %page.NAMESPACE = $zu(5)
	
	Set %page.PlanPage = $P(..Link("%25SQL.Manager.ShowPlan.cls"),"?$NAMESPACE",1)
	
	Set ..%GetComponentById("Text1").value = $$$Text("Use options on this page to review Alternate Show Plans the SQL Optimizer produced.")
	
	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Alternate Show Plans")
}

/// Draw html for details title: Routine name and Query text
Method DrawDetailsTitle(pSeed) As %Status
{
	&html<<h4>#($$$Text("Use this page to review Alternate Show Plans the SQL Optimizer produced."))#</h4>>
	Quit $$$OK
}

Query GetPlans(query As %String) As %SQLQuery(ROWSPEC = "ID:%Integer,Cost:%Integer,Plan:%String") [ Internal ]
{
}

ClassMethod GetPlansExecute(ByRef qHandle As %Binary, query As %String) As %Status [ Internal, ProcedureBlock = 0 ]
{
	n %AltPlan
	s sql=1
	s sql(1)=query
	d ShowPlanAlt^%apiSQL(.sql,1)
	s qHandle=$LB(0)
}

ClassMethod GetPlansFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetPlansExecute ]
{
	s id=$LG(qHandle,1)
	s id=$O(%AltPlan(id),1,data)
	If id="" s AtEnd="",Row="" QUIT
	s Row=$LB(id,$LG(data,1),$LG(data,2))
	QUIT
}

ClassMethod GetPlansClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetPlansExecute ]
{
	If $data(qHandle) {
		kill $$$ISCQUERYTEMP(qHandle)
	}
	k %AltPlan
	Quit $$$OK
}

ClassMethod PassSQLHack(query) [ ZenMethod ]
{
	quit
	Set ^mqh($USERNAME)=1
	Set ^mqh($USERNAME,1) = query
}

ClassMethod PassSQLHack2(query, ids) [ ZenMethod ]
{
	quit
	Set ^mqh($USERNAME,"stats",1)=1
	Set ^mqh($USERNAME,"stats",1,1) = query
	Set ^mqh($USERNAME,"stats",2)=ids
}

ClassMethod PrepareShowPlan(query, rtn = "") [ ZenMethod ]
{
	//Set %session.Data("$SQLQUERY") = query
	Set ^mqh($Username) = query
}

}
