Include %msql

/// System Management Portal - SQL Performance Tool
Class %CSP.UI.Portal.SQL.QButtons.IndexAnalyzer Extends (%CSP.UI.Template.Property, %CSP.UI.Portal.UtilsNav) [ System = 4 ]
{

Parameter RESOURCE = "%Development:USE";

Parameter CSPURL = "/csp/sys/exp/%CSP.UI.Portal.SQL.QButtons.IndexAnalyzer.zen";

Parameter HELPADDRESS = "Home,SQL Index Analyzer";

Property PlanPage As %String;

Property gatherStatus As %Boolean;

Property dots As %String;

Property jobStatus As %String;

/// Displayed name of this page.
Parameter PAGENAME = "SQL.QButtons.IndexAnalyzer";

Property QUERYNAME As %ZEN.Datatype.string [ InitialExpression = "indexUsage" ];

XData Style
{
<style type="text/css">
body { font-size: 1em; }
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none" containerStyle="padding-top:10px;">
<label id="Text1" value="" enclosingStyle="padding:10px;"/>

<vgroup id="groupContent" cellVAlign="top">
<label id="jobStatus" />
<label id="idRespond" enclosingClass="note" value="" hidden="true"/>
<vgroup cellStyle="padding-left:20px;">
<html id="htmlSQLStatements" label="SQL Statement Count" labelClass="caption" OnDrawContent="DrawSQLStatements"/>
</vgroup>
<vgroup id="editorPane" enclosingStyle="padding:10px 10px 10px 20px">
<checkbox id="chkShowSys" caption="Include System Queries?  (%*, DeepSee*,HS*, Ens*)" captionClass="optionLabel" title="Include System Queries" onchange="zenPage.clearRadio();" /> 
<dataCombo id="schemaSelection" label="Schema Selection" sql="SELECT SQLSchemaName FROM %Dictionary.CompiledClass WHERE SQLSchemaname > '%z' GROUP BY SQLSchemaName" onchange="zenPage.schemaSort();">
</dataCombo>
<radioButton id="rad_0" name="radOption" label="Select Report Option" labelClass="caption" caption="Index usage" optionValue="0" onclick="zenPage.startRadioOption('0');"/>
<radioButton id="rad_1" name="radOption" caption="Queries with table scans" optionValue="1" onclick="zenPage.startRadioOption('1');"/>
<radioButton id="rad_2" name="radOption" caption="Queries with temp indices" optionValue="2" onclick="zenPage.startRadioOption('2');"/>
<radioButton id="rad_3" name="radOption" caption="Queries with missing JOIN indices" optionValue="3" onclick="zenPage.startRadioOption('3');"/>
</vgroup>
<label id="radioCount"/>
<vgroup cellStyle="padding-left:20px;" id="tableGroup" >
<tableNavBar id="tableNav" showFilter="false" showPageSize="true" showMaxRows="true" tablePaneId="table"
saveSizeMax="true" onPageSizeChange="zenPage.navPageSizeChanged(value);" onMaxRowsChange="zenPage.navMaxRowsChanged(value);"
/>
<tablePane id="table" label="Index usage" labelClass="caption" 
queryClass="%SYS.PTools.SQLUtilities"
queryName="IndexUsage"
cellSpacing="1"
dataSource="query"
fixedHeaders="false"
multiSelect="false"
pageSize="0"
maxRows="1000"
showValueInTooltip="false"
showZebra="true"
useSnapshot="true"
initialExecute="false"
OnCreateResultSet="CreateRS"
>
<parameter id="schemaname"/>
<column colName="SQLText" hidden="true" />
<column id="showPlanColumn" OnDrawCell="DrawShowPlanCell" header="Show Plan"/>
</tablePane>
</vgroup>
</vgroup>

</pane>
}

Method DrawShowPlanCell(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	if $g(%query("SQLText"))'="" {
		s stream = ##class(%Stream.GlobalCharacter).%Open(%query("SQLText"))
		s query = $zcvt($replace(stream.Read(),"""","\"""),"O","HTML")
		s schema = $zcvt($replace(%query("SchemaName"),"""","\"""),"O","HTML")
		&html<<a href='javascript:zenPage.showPlan("#(query)#","#(schema)#")'>Show Plan</a>>
	}
	q $$$OK
}

Method showPlan(query, schema) [ ZenMethod ]
{
	//$$$ZENALERT(query _ "**" _ schema)
	d ..PrepareShowPlan(query, schema)
	s link = ..PlanPage _ "?namespace=" _ $zcvt(..NAMESPACE,"O","URL")
	&js<window.open('#(link)#');>
}

ClassMethod PrepareShowPlan(query, schema = "") [ ZenMethod ]
{
	//Set %session.Data("$SQLQUERY") = query
	Set ^mqh($Username) = query
	set ^mqh($Username,"schema")=$LB(schema)
}

ClientMethod clearRadio() [ Language = javascript ]
{
	zen("rad_0").setValue('');
	zen("rad_1").setValue('');
	zen("rad_2").setValue('');
	zen("rad_3").setValue('');
	var ok = this.ClearResults();
	var table = zen("table");
	table.setProperty("label","Index Usage");
	table.executeQuery(0);
	table.setHidden(false);
	table.refreshContents();
}

ClientMethod schemaSort() [ Language = javascript ]
{
	zen("schemaname").value = zen("schemaSelection").getValue();
	zen("table").executeQuery();
}

/// Invoke method to gather SQL Statements and update SQL Statement Count table. During this time, disable the rasio buttons.
ClientMethod startButtonGather() [ Language = javascript ]
{
	zenSetProp("jobStatus", "hidden", 0)
	zenSetProp("jobStatus", "value", "Gathering SQL statements ")
	zen("rad_0").setDisabled(true);
	zen("rad_0").setValue('');
	zen("rad_1").setDisabled(true);
	zen("rad_1").setValue('');
	zen("rad_2").setDisabled(true);
	zen("rad_2").setValue('');
	zen("rad_3").setDisabled(true);
	zen("rad_3").setValue('');
	var table = zen("table");
	table.setHidden(true);
	var ok = this.ClearStatements();
	var html = zen("htmlSQLStatements");
	html.seed = 1;
	html.refreshContents();
	var ok = this.GatherStatements();
}

/// Called by server-side GatherStatements method upon completion
ClientMethod endButtonGather() [ Language = javascript ]
{
	var html = zen("htmlSQLStatements");
	html.seed = 1;
	html.refreshContents();
	myFunc1=setInterval(function () {

		zenPage.CheckButtonStatus();

	}, 2500);
}

Method CheckButtonStatus() [ ZenMethod ]
{
	// this method is used  to see if a server side query is done yet.
	// you can only run one thing at a time so we reuse the same lock to test
	
	lock +^%sqlcq($NAMESPACE,"PTools","Utils","Queries"):1
	s status=$T
	set string="Gathering SQL statements "

	if status=0 {
		set ..dots=..dots_"."
		set string=string_..dots
	}
	else {
		lock -^%sqlcq($NAMESPACE,"PTools","Utils","Queries")
		set string="Done"
		&js<clearInterval("myFunc1");>
		
	}

	&js<zenPage.refreshButton('#(string)#')>
}

ClientMethod refreshButton(string) [ Language = javascript ]
{
	if (string == "Done") {
		zen("rad_0").setDisabled(false);
		zen("rad_1").setDisabled(false);
		zen("rad_2").setDisabled(false);
		zen("rad_3").setDisabled(false);
	}
	zenSetProp("jobStatus", "value", string);
	var html = zen("htmlSQLStatements");
	html.seed = 1;
	html.refreshContents();
}

ClientMethod startRadioOption(newOption) [ Language = javascript ]
{
	zenSetProp("jobStatus", "hidden", 1)
	zenSetProp("radioCount", "value", "Gathering results ")
	var showsys = zen("chkShowSys").getValue();
	var schema = zen("schemaSelection").getValue();
	/// run the %SYS.PTools.SQLUtilities utility for the option first
	zen("table").setProperty("currColumn",'');
	var ok = this.PrepareAnalysis(newOption,showsys);
}

ClientMethod endRadioOption(newOption) [ Language = javascript ]
{
	var table = zen("table");
	/// next load the table - set the query name based on the option selected
	var queryName = "";
	var index = zen("rad_0").getValue();
	var title = zen("rad_"+index).getProperty("caption");
	switch(newOption) {
		case '0':
			queryName = "IndexUsage";
			zen("showPlanColumn").setProperty("hidden",true);
			zen("rad_1").setDisabled(true);
			zen("rad_2").setDisabled(true);
			zen("rad_3").setDisabled(true);

			break;
		case '1':
			queryName = "TableScans";
			zen("showPlanColumn").setProperty("hidden",false);
			zen("rad_0").setDisabled(true);
			zen("rad_2").setDisabled(true);
			zen("rad_3").setDisabled(true);
			break;
		case '2':
			queryName = "TempIndices";
			zen("showPlanColumn").setProperty("hidden",false);
			zen("rad_0").setDisabled(true);
			zen("rad_1").setDisabled(true);
			zen("rad_3").setDisabled(true);
			break;
		case '3':
			queryName = "JoinIndices";
			zen("showPlanColumn").setProperty("hidden",false);
			zen("rad_0").setDisabled(true);
			zen("rad_1").setDisabled(true);
			zen("rad_2").setDisabled(true);
			break;	
	}
	table.setProperty("label",title);
	this.QUERYNAME = queryName;
	table.executeQuery(0);
	table.setHidden(false);
	zen('tableNav').setHidden(false);
	table.refreshContents();
	if (typeof myFunc2 != 'undefined')  {
		clearInterval(myFunc2);
		//zenPage.refreshRadio("Done",myFunc2Title,myFunc2QueryName);
	}
	myFunc2=setInterval(function () {

		zenPage.CheckRadioStatus(title,queryName);

	}, 500);
}

Method CheckRadioStatus(title, queryName) [ ZenMethod ]
{
	// this method is used  to see if a server side query is done yet.
	// you can only run one thing at a time so we reuse the same lock to test
	
	lock +^%sqlcq($NAMESPACE,"PTools","Utils","Queries"):1
	s status=$T
	set string="Gathering results "
	
	if status=0 {
		set ..dots=..dots_"."
		set string=string_..dots
	}
	else {
		lock -^%sqlcq($NAMESPACE,"PTools","Utils","Queries")
		set string="Done"
		&js<clearInterval(myFunc2);>
		
	}
	//s title=""_title_""
	&js<zenPage.refreshRadio('#(string)#','#(title)#','#(queryName)#')>
}

ClientMethod refreshRadio(string, title, queryName) [ Language = javascript ]
{
	if (string == "Done") {
		zen("rad_0").setDisabled(false);
		zen("rad_1").setDisabled(false);
		zen("rad_2").setDisabled(false);
		zen("rad_3").setDisabled(false);
	}
	zenSetProp("radioCount", "value", string);
 	var table = zen("table");
	table.seed = 1;
	table.setProperty("label",title);
	table.executeQuery(0);
	table.setHidden(false);
	zen('tableNav').setHidden(false);
	table.refreshContents();
}

Method %OnAfterCreatePage() As %Status
{
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	Do ..%GetNavTableState()

	Set %page.NAMESPACE = $G(%request.Data("$NAMESPACE",1))
	If %page.NAMESPACE = "" Set %page.NAMESPACE = $zu(5)
	
	Set ..%GetComponentById("Text1").value = $$$Text("Use options on this page to review various index analyzer reports.")
	
	Set %page.PlanPage = $P(..Link("%25SQL.Manager.ShowPlan.cls"),"?$NAMESPACE",1)
	Quit $$$OK
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = ..%OnGetPageName()

	// commands: $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("btnGather",$$$Text("Gather SQL Statements"),$$$Text("Gather SQL Statements"),"zenPage.startButtonGather();")

	Quit $$$OK
}

/// Get the (localized) name of the page.
/// This should be implemented in a subclass.
Method %OnGetPageName() As %String
{
	Quit $$$Text("SQL Index Analyzer")
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	switch(popupName) {
	case 'switchNamespace':
		var url = zenPage.GetNewURL(value,"%25CSP.UI.Portal.SQL.QButtons.IndexAnalyzer.zen");
		// do not use this.gotoPage(url) because zenLink will not honor the latest $NAMESPACE you selected, i.e. you may end up with multiple $NAMESPACE on the URL.
		self.document.location = url;
		break;
	case 'Details':
		break;
	}
}

/// Draw html for details title: Routine name and Query text
Method DrawDetailsTitle(pSeed) As %Status
{
	&html<<h4>#($$$Text("Use this page to display various index analyzer report."))#</h4>>
	Quit $$$OK
}

ClassMethod ClearResults() As %Status [ ZenMethod ]
{
	QUIT ##class(%SYS.PTools.SQLUtilities).ClearResults()
}

ClassMethod ClearStatements() As %Status [ ZenMethod ]
{

	set status = ##class(%SYS.PTools.SQLUtilities).ClearStatements()
	set status = ##class(%SYS.PTools.SQLUtilities).ClearResults()
	QUIT $$$OK
}

Method GatherStatements() [ ZenMethod ]
{
	set ..dots=""
	job ##class(%SYS.PTools.SQLUtilities).GetSQLStatements(1,1,1,1,0)
	&js<zenPage.endButtonGather();>
}

Method DrawSQLStatements(pSeed) As %Status
{
	Set tRS = ##class(%ResultSet).%New("%SYS.PTools.SQLUtilities:FindSQL")
	Do tRS.Execute()
	Set hasCount = 0
	&html<<table class="tpTable">>
	While tRS.Next()
	{
		&html<<tr><th>#(tRS.GetData(1))#</th><td>#(tRS.GetData(2))#</td></tr>> Set hasCount = 1
	}
	If 'hasCount &html<<tr><th>#($$$TextHTML("No count available. Click the 'Gather' button to get the statement count."))#</th></tr>> 
	&html<</table>>
	Quit $$$OK
}

Method PrepareAnalysis(option, system) [ ZenMethod ]
{
	s ..dots=""
	s system=$S(system="false":0,1:1)
	If option = 0 {
		j ##class(%SYS.PTools.SQLUtilities).IndexUsage(0,system)
	} ElseIf option = 1 {
		j ##class(%SYS.PTools.SQLUtilities).TableScans(0,system)
	} ElseIf option = 2 {
		j ##class(%SYS.PTools.SQLUtilities).TempIndices(0,system)
	} ElseIf option = 3 {
		j ##class(%SYS.PTools.SQLUtilities).JoinIndices(0,system)
	}
	&js<zenPage.endRadioOption('#(option)#');>
	
	QUIT $$$OK
}

/// <var>pInfo</var> holds details on how to create the query.
Method CreateRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set pRS = ""
	Set QueryName = %page.QUERYNAME
	Set Query = "%SYS.PTools.UtilSQLAnalysis:" _ QueryName
	Set pRS = ##class(%ResultSet).%New(Query)
	Quit pRS
}

}
