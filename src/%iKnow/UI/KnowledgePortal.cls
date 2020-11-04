/// <p>This is a sample User Interface built on top of the iKnow query APIs, displaying a browsable overview
/// of the semantic elements identified by the iKnow Smart Indexing API. Click on an entity in a list 
/// to browse to the elements similar, related or containing the selected entity.</p>
/// <p>Use the filter button to filter the displayed results based on metadata criteria.</p>
Class %iKnow.UI.KnowledgePortal Extends %iKnow.UI.AbstractPortal [ System = 4 ]
{

Parameter PAGENAME = "iKnow Knowledge Portal";

Property drillMaster As %ZEN.Datatype.string;

Property drillRelation As %ZEN.Datatype.string;

Property drillSlave As %ZEN.Datatype.string;

XData Style
{
<style type="text/css">
body {
	font-family: Verdana, Arial;
	font-size: 12px;
}

a {
	color: #a00000;
}

.resultBox {
	border: 1px solid black;
	width: 100%;
	padding: 15px;
}

.resultBoxTitle {
	font-weight: bold;
	font-size: 18px;
	margin-bottom: 10px;
}

.resultTable {
	border: 0px;
	width: 100%;
	padding: 2px;
}

.resultTable tr {
	width: 100%;
}

td.resultItemValue {
	width: 100%;
}

td.resultItemFreq, td.resultItemSpread {
	margin-left: 10px;
	text-align: right;
}

.rnavNodeHilight { fill: red; stroke: red; }
.rnavNodeSelected { fill: red; stroke: red; }
.rnavNode { fill: black; stroke: black; }

table.noBorder, table.noBorder td {
	border: none;
}

</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" 
	 title="iKnow - Knowledge Portal" width="100%" height="100%">

<modalGroup id="summaryBox" width="600">
<vgroup>
<hgroup>
<label label="summary length" />
<text id="summaryLength" value="10" />
<button onclick="zenPage.buildSummaryClient();return;" caption="go" />
</hgroup>
<textarea id="summaryText" cols="60" rows="12" />
</vgroup>
</modalGroup>

<modalGroup id="drillSourcesPopup" width="80%">
<vgroup>
<vgroup width="100%">
<titleBox id="drillSourcesTitle" title="Sources containing [#(%page.drillMaster)#] #(%page.drillRelation)# [#(%page.drillSlave)#]" />
<spacer height="5" />
<tablePane id="drillSources" OnExecuteResultSet="ExecuteQuery" rowSelect="false"
queryClass="%iKnow.Queries.SourceQAPI" queryName="GetByCrcMask"
 showRowSelector="false" unlockSession="true" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.drillMaster)#" />
<parameter value="#(%page.drillRelation)#" />
<parameter value="#(%page.drillSlave)#" />
<parameter value="#(%session.pagedrillSources)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
 <column colName="srcId" header="sourceId" />
 <column colName="externalId" header="contents" OnDrawCell="DrawSourceDrill" />
</tablePane>
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('drillSources');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('drillSources');" />
</hgroup>
</vgroup>
</vgroup>
</modalGroup>

<form method="post" id="kpForm" width="100%" height="100%">
<vgroup height="100%" width="100%">
<pane paneName="logoPane" />
<hgroup width="100%">
<pane paneName="txtTermPane" />
<spacer width="10" />
<pane paneName="filterPane" />
<spacer width="10" />
<pane paneName="filterCountPane" />
<spacer width="20" />
<pane paneName="blacklistPane" />
<spacer width="30%" />
<pane paneName="optDomainPane" />
</hgroup>
<pane paneName="infoPane" />
<spacer height="20" />
<hgroup width="100%" cellVAlign="top">
<vgroup width="33%" id="grpTopEntities">
<titleBox title="Top Concepts" id="ttlTopEntities" />
<spacer height="5" />
<tabGroup id="topEntTabs">
<tab width="100%">
<tablePane id="topEntities" OnExecuteResultSet="ExecuteQuery" rowSelect="true" unlockSession="true"
queryClass="%iKnow.Queries.EntityQAPI" queryName="GetTop" valueColumn="entity"
showRowSelector="false" onselectrow="zenPage.useTermClientRow(zenThis);" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%session.pagetopEntities)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
<parameter value="-1" />
<parameter value="0" />
<parameter value="0" />
<parameter value="#(%page.blacklists)#" />
<column colName="entUniId" hidden="true" />
<column colName="entity" />
<column colName="frequency" />
<column colName="spread" />
</tablePane>
</tab>
<tab width="100%">
<tablePane id="domEntities" OnExecuteResultSet="ExecuteQuery" rowSelect="true" unlockSession="true"
queryClass="%iKnow.Semantics.DominanceQAPI" queryName="GetTop" valueColumn="entity"
showRowSelector="false" onselectrow="zenPage.useTermClientRow(zenThis);" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%session.pagedomEntities)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<parameter value="AVG" />
<parameter value="0" />
<column colName="entUniId" hidden="true" />
<column colName="entity" />
<column colName="score" />
</tablePane>
</tab>
</tabGroup>
<hgroup align="right">
<button caption="toggle" id="btnToggleTop" onclick="zenPage.toggleTop(0);" />
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('topEntities'); zenPage.previousPageClient('domEntities');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('topEntities'); zenPage.nextPageClient('domEntities');" />
</hgroup>
</vgroup>
<spacer width="20" />
<vgroup width="33%" id="grpSimEntities">
<titleBox title="Similar Entities" id="ttlSimEntities" />
<spacer height="5" />
<tablePane id="simEntities" OnExecuteResultSet="ExecuteQuery" rowSelect="true" unlockSession="true"
queryClass="%iKnow.Queries.EntityQAPI" queryName="GetSimilar" valueColumn="entity"
showRowSelector="false" onselectrow="zenPage.useTermClientRow(zenThis);" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagesimEntities)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
<parameter value="-1" />
<parameter value="#(%page.blacklists)#" />
<parameter value="-1" id="prmSimEntitiesRole" />
<column colName="entUniId" hidden="true" />
<column colName="entity" />
<column colName="frequency" />
<column colName="spread" />
</tablePane>
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('simEntities');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('simEntities');" />
</hgroup>
</vgroup>
<spacer width="20" id="spcRelEntities" />
<vgroup width="33%" id="grpRelEntities" >
<titleBox title="Related Concepts" id="ttlRelEntities" />
<spacer height="5" />
<tabGroup id="relEntTabs" width="100%">
<tab width="100%" id="tabRelEntities">
<tablePane id="relEntities" OnExecuteResultSet="ExecuteQuery" rowSelect="true" unlockSession="true"
queryClass="%iKnow.Queries.EntityQAPI" queryName="GetRelated" valueColumn="entity"
showRowSelector="false" onselectrow="zenPage.useTermClientRow(zenThis);" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagerelEntities)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
<parameter value="5" />
<parameter value="1" />
<parameter value="1" />
<parameter value="-1" />
<parameter value="#(%page.blacklists)#" />
<column colName="entUniId" hidden="true" />
<column colName="entity" />
<column colName="frequency" />
<column colName="spread" />
</tablePane>
</tab>
<tab id="tabRelEntitiesRadial">
<svgFrame id="svgFrame" height="235" width="350"  >
<radialNavigator id="radNavigator" onselectNode="zenPage.selectNodeClient();" height="235" width="350"
backgroundStyle="fill: white; stroke-width: 0;" preserveAspectRatio="false" >
</radialNavigator>
</svgFrame>
</tab>
<tab width="100%">
<tablePane id="prxEntities" OnExecuteResultSet="ExecuteQuery" rowSelect="true" unlockSession="true"
queryClass="%iKnow.Semantics.ProximityQAPI" queryName="GetProfile" valueColumn="entity"
showRowSelector="false" onselectrow="zenPage.useTermClientRow(zenThis);" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pageprxEntities)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<column colName="entUniId" hidden="true" />
<column colName="entity" />
<column colName="score" />
</tablePane>
</tab>
</tabGroup>
<hgroup align="right">
<button caption="toggle" id="btnToggleRel" onclick="zenPage.toggleRelated(0);" />
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('relEntities'); zenPage.previousPageClient('prxEntities');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('relEntities'); zenPage.nextPageClient('prxEntities');" />
</hgroup>
</vgroup>
</hgroup>
<spacer height="20" />
<vgroup width="100%">
<titleBox title="Paths" id="ttlPaths" />
<spacer height="5" />
<tablePane id="paths" OnExecuteResultSet="ExecuteQuery" rowSelect="false"
queryClass="%iKnow.Queries.PathQAPI" queryName="GetByEntities" unlockSession="true"
 showRowSelector="false" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagepaths)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
 <column colName="pathId" header="ID" />
 <column colName="entIds" header="Entities" OnDrawCell="DrawPath" />
</tablePane>
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('paths');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('paths');" />
</hgroup>
</vgroup>
<spacer height="20" />
<vgroup width="100%">
<titleBox title="Sources" />
<spacer height="5" />
<tablePane id="sources" OnExecuteResultSet="ExecuteQuery" rowSelect="false"
queryClass="%iKnow.Queries.SourceQAPI" queryName="GetByEntities" unlockSession="true"
 showRowSelector="false" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagesources)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
 <column colName="srcId" header="sourceId" />
 <column colName="externalId" header="contents" OnDrawCell="DrawSource" />
</tablePane>
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('sources');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('sources');" />
</hgroup>
</vgroup>
<spacer height="20" />
<hgroup width="100%" id="grpCRCnCC" cellVAlign="top">
<vgroup width="50%">
<titleBox title="CRCs" />
<spacer height="5" />
<tablePane id="crcs" OnExecuteResultSet="ExecuteQuery" rowSelect="false"
queryClass="%iKnow.Queries.CrcQAPI" queryName="GetByEntities" unlockSession="true"
 showRowSelector="false" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagecrcs)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
<column colName="crcId" hidden="true" />
 <column colName="master" header="CRC" OnDrawCell="DrawCRC" />
 <column colName="relation" hidden="true" />
 <column colName="slave" hidden="true" />
 <column colName="frequency" />
 <column colName="spread" />
 <column OnDrawCell="DrawDrillCRC" style="text-align:center;" />
</tablePane>
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('crcs');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('crcs');" />
</hgroup>
</vgroup>
<spacer width="20" />
<vgroup width="50%">
<titleBox title="CCs" />
<spacer height="5" />
<tablePane id="ccs" OnExecuteResultSet="ExecuteQuery" rowSelect="false"
queryClass="%iKnow.Queries.CcQAPI" queryName="GetByEntities" unlockSession="true"
 showRowSelector="false" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pageccs)#" />
<parameter value="10" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
 <column colName="mEntUniId" hidden="true" />
 <column colName="mEntity" header="CC" OnDrawCell="DrawCC" />
 <column colName="sEntUniId" hidden="true" />
 <column colName="sEntity" hidden="true" />
 <column colName="frequency" />
 <column colName="spread" />
 <column colName="ccUniId" hidden="true" />
 <column OnDrawCell="DrawDrillCC" style="text-align:center;" />
</tablePane>
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('ccs');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('ccs');" />
</hgroup>
</vgroup>
</hgroup>
</vgroup>
</form>
</page>
}

/// Client-side method which will explicitly select a certain term, based on a selected row.
/// See also <method>useTermClient</method>.
ClientMethod useTermClientRow(table) [ Final, Language = javascript ]
{
	var value = table.getValue();
	if (table.selectedIndex < 0) {
		return;
	}
	var sc = table.selectRow(-1);
	zenPage.useTermClient(value);
}

ClientMethod toggleTop(tab = 0) [ Language = javascript ]
{
	if (tab == 0) tab = (zen('topEntTabs').currTab==1) ? 2 : 1;
	switch (tab) {
		case 1:
			zen('ttlTopEntities').setProperty('title', $$$Text('Top Concepts'));
			break;
		case 2:
			zen('ttlTopEntities').setProperty('title', $$$Text('Dominant Concepts'));
			break;
	}
	zen('ttlTopEntities').refreshContents();
	zen('topEntTabs').showTab(tab);
}

ClientMethod toggleRelated(tab = 0) [ Language = javascript ]
{
	if (tab == 0) tab = ((zen('relEntTabs').currTab+1)%3)+1;
	switch (tab) {
		case 1:
			zen('ttlRelEntities').setProperty('title', $$$Text('Related Concepts'));
			break;
		case 2:
			zen('ttlRelEntities').setProperty('title', $$$Text('Related Concepts'));
			zenPage.refreshRadial();
			break;
		case 3:
			zen('ttlRelEntities').setProperty('title', $$$Text('Proximity Profile'));
			break;
	}
	zen('ttlRelEntities').refreshContents();
	zen('relEntTabs').showTab(tab);
}

Method InitPages() As %Status
{
	set %session.Data("pagetopEntities") = 1
	set %session.Data("pagedomEntities") = 1
	set %session.Data("pagesimEntities") = 1
	set %session.Data("pagerelEntities") = 1
	set %session.Data("pageprxEntities") = 1
	set %session.Data("pagepaths") = 1
	set %session.Data("pagesources") = 1
	set %session.Data("pagecrcs") = 1
	set %session.Data("pageccs") = 1
	set %session.Data("pagedrillSources") = 1
	quit ##super()
}

ClientMethod drillToSourcesClient(master, relation, slave) [ Language = javascript ]
{
	/*if (master=='') master = '*';
	if (relation=='') relation = '*';
	if (slave=='') slave = '*';*/
	
	var sc = zenPage.DrillToSources(master, relation, slave);
	zen('drillSourcesPopup').show();
	zen('drillSourcesTitle').refreshContents();
	zen('drillSources').refreshContents();
}

Method DrillToSources(master As %String, relation As %String, slave As %String) As %Status [ ZenMethod ]
{
	set ..drillMaster = master
	set ..drillRelation = relation
	set ..drillSlave = slave
	quit $$$OK
}

Method DrawDrillCRC(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	write "<a href=""javascript:zenPage.drillToSourcesClient('",$replace(%query("master"),"'","\'"),"','",$replace(%query("relation"),"'","\'"),"','",$replace(%query("slave"),"'","\'"),"');"">"_$$$Text("drill")_"</a>"
	quit $$$OK
}

Method DrawDrillCC(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	write "<a href=""javascript:zenPage.drillToSourcesClient('",$replace(%query("mEntity"),"'","\'"),"','"_$$$WILDCARD_"','",$replace(%query("sEntity"),"'","\'"),"');"">"_$$$Text("drill")_"</a>"
	quit $$$OK
}

Method DrawCRC(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	write ..MakeLink(%query("master")), " ", %query("relation"), " ", ..MakeLink(%query("slave"))
	quit $$$OK
}

Method DrawCC(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	write ..MakeLink(%query("mEntity")), " * ", ..MakeLink(%query("sEntity"))
	quit $$$OK
}

Method DrawPath(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	set tDomainId = ..domain
	set tSC = ##class(%iKnow.Queries.EntityAPI).TranslateEntityList(tDomainId,$lfs(..term),.tHighlight,,,$s($$$GETPARAMNODEF(tDomainId,$$$IKPSTEMMING):2, 1:0))
	quit:$$$ISERR(tSC) tSC
	
	set pathId = %query("pathId")
	set pathEnts = $lfs(%query("entIds"))
	set entOccs = ##class(%iKnow.Objects.Path).PKINDEXOpen(tDomainId, pathId).EntityOccurrences
	
	write "<span style='white-space:normal;'>"
	
	for j=1:1:$listlength(pathEnts) {
		set entId = $list(pathEnts,j)
		continue:entId=0
		set entOcc = ##class(%iKnow.Objects.EntityOccurrence).PKINDEXOpen(tDomainId, $list(entOccs,j))
		if (entOcc.EntTypeId=$$$ENTTYPECONCEPT) {
			if $d(tHighlight(entOcc.EntUniId)) {
				write "[<b>", ..MakeLink(##class(%iKnow.Queries.EntityAPI).GetValue(tDomainId, entId)), "</b>] "
			} else {
				write "[", ..MakeLink(##class(%iKnow.Queries.EntityAPI).GetValue(tDomainId, entId)), "] "
			}
		} else {
			write ##class(%iKnow.Queries.EntityAPI).GetValue(tDomainId, entId), " "
		}
	}
	
	write "</span>"
	quit $$$OK
}

Method DrawSource(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	set srcId = %query("srcId")
	set extId = %query("externalId")
	write "<table class=""noBorder"" width=""100%""><tr><td align=""left"">"
	write "<a href='javascript:zenPage.displaySourceClient(",srcId,");'>",extId,"</a>: "
	write "</td><td align=""right"">"
	write "<a href='_iKnow.UI.IndexingResults.zen?$NAMESPACE="_$namespace_"&domain="_..domain_"&source="_srcId_"' target=""_new"">indexing results</a> - "
	write "<a href='_iKnow.UI.MatchingResults.zen?$NAMESPACE="_$namespace_"&domain="_..domain_"&source="_srcId_"' target=""_new"">matching results</a>"
	write "</td></tr></table>"
	
	
	set tSC = ##class(%iKnow.Queries.EntityAPI).TranslateEntityList(..domain,$lfs(..term),.tEntIds,,, $s($$$GETPARAMNODEF(..domain,$$$IKPSTEMMING):2, 1:0))
	quit:$$$ISERR(tSC) tSC
	
	set tEntUniId = "", tEntIds=""
	for {
		set tEntUniId = $order(tEntIds(tEntUniId))
		quit:tEntUniId=""
		set tEntIds = tEntIds_$lb(tEntUniId)
		set tHighlight("ENTITY",tEntUniId) = "<b>"
	}
	
	write "<blockquote style='white-space:normal;'>... "
	set tSC = ##class(%iKnow.Queries.SentenceAPI).GetByEntityIds(.res, ..domain, tEntIds, $lb(srcId))
	set j = ""
	for {
		set j = $order(res(j),-1,sent)
		quit:j=""
		
		write ##class(%iKnow.Queries.SentenceAPI).GetHighlighted(..domain, $li(sent,3), .tHighlight,,, .tSC)
		quit:$$$ISERR(tSC)
		write " ... "
	}
	write "</blockquote>"
	quit $$$OK
}

Method DrawSourceDrill(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	set srcId = %query("srcId")
	set extId = %query("externalId")
	write "<a href='javascript:zenPage.displaySourceClient(",srcId,");'>",extId,"</a>:"
	
	kill tHighlight
	set terms = $lfs(..term)
	for j=1:1:$length(terms,",") {
		set id = ##class(%iKnow.Queries.EntityAPI).GetId(..domain, $li(terms,j))
		set tHighlight("ENTITY",id)="<b>", $li(terms,j)=id
	}
	
	// also add drilled entities
	set:..drillMaster'="" tHighlight("ENTITY", ##class(%iKnow.Queries.EntityAPI).GetId(..domain, ..drillMaster)) = "<b>"
	set:..drillRelation'="" tHighlight("ENTITY", ##class(%iKnow.Queries.EntityAPI).GetId(..domain, ..drillRelation)) = "<b>"
	set:..drillSlave'="" tHighlight("ENTITY", ##class(%iKnow.Queries.EntityAPI).GetId(..domain, ..drillSlave)) = "<b>"
	
	write "<blockquote style='white-space:normal;'>... "
	set tSC = ##class(%iKnow.Queries.SentenceAPI).GetByCrcMask(.res, ..domain, $s(..drillMaster'="":..drillMaster, 1:$$$WILDCARD), $s(..drillRelation'="":..drillRelation, 1:$$$WILDCARD), $s(..drillSlave'="":..drillSlave, 1:$$$WILDCARD), $lb(srcId))
	set j = ""
	for {
		set j = $order(res(j),-1,sent)
		quit:j=""
		
		write ##class(%iKnow.Queries.SentenceAPI).GetHighlighted(..domain, $li(sent,3), .tHighlight,,, .tSC)
		quit:$$$ISERR(tSC)
		write " ... "
	}
	write "</blockquote>"
	quit $$$OK
}

ClassMethod MakeLink(entity As %String) As %String
{
	quit "<a href=""javascript:zenPage.useTermClient('"_entity_"');"">"_entity_"</a>"
}

ClientMethod displaySourceClient(sourceId) [ Language = javascript ]
{
	zenPage.getComponentById("summaryBox").show();
	var sc = zenPage.UpdateSource(sourceId);
	zenPage.buildSummaryClient();
}

ClientMethod buildSummaryClient() [ Language = javascript ]
{
	var length = zenPage.getComponentById("summaryLength").getValue();
	zenPage.BuildSummary(length);
}

Method BuildSummary(summaryLength As %Integer) [ ZenMethod ]
{
	set text = ""
	
	set tSC = ##class(%iKnow.Queries.SourceAPI).GetSummary(.result, ..domain, ..source, summaryLength)
	set i = ""
	for {
		set i = $o(result(i),1,d)
		quit:i=""
		
		set text = text _ $list(d,2) _ " "
	}
	
	set ..%GetComponentById("summaryText").value = text
}

ClientMethod onUpdateFilterClient() [ Language = javascript ]
{
	zen('simEntities').executeQuery();
	zen('relEntities').executeQuery();
	zen('prxEntities').executeQuery();
	zen('topEntities').executeQuery();
	zen('domEntities').executeQuery();
	zen('sources').executeQuery();
	zen('paths').executeQuery();
	zen('ccs').executeQuery();
	zen('crcs').executeQuery();
	zenPage.refreshRadial();
}

ClientMethod onUpdateTermClient() [ Language = javascript ]
{
	zen('simEntities').executeQuery();
	zen('relEntities').executeQuery();
	zen('prxEntities').executeQuery();
	zen('sources').executeQuery();
	zen('paths').executeQuery();
	zen('ccs').executeQuery();
	zen('crcs').executeQuery();
	zenPage.refreshRadial();
}

Method GetInfoPaneText() As %String
{
	quit "<p>This is a sample User Interface built on top of the iKnow query APIs, displaying a browsable overview "_
			"of the semantic elements identified by the iKnow Smart Indexing API. Click on an entity in a list " _
			"to browse to the elements similar, related or containing the selected entity.</p>" _
			"<p>Use the filter button to filter the displayed results based on metadata criteria.</p>"
}

ClientMethod refreshRadial() [ Language = javascript ]
{
	var radNav = zen("radNavigator");
	radNav.clearNodes();
	var sc = zenPage.RefreshRadialContent();
	radNav.renderContents();
}

Method RefreshRadialContent() As %Status [ ZenMethod ]
{
	set tSC = $$$OK
	try {
		set tSC = ##class(%iKnow.Queries.EntityAPI).GetRelated(.tResult, ..domain, ..term)
		quit:$$$ISERR(tSC)
		
		#dim tRadNav As %ZEN.SVGComponent.radialNavigator
		set tRadNav = ..%GetComponentById("radNavigator")
		set tRadNav.mainLabel = ..term
		
		set i="", tMaxFreq=0
		for {
			set i = $order(tResult(i),1,tData)
			quit:i=""
			
			set:'tMaxFreq tMaxFreq = $li(tData,3)
			set tSize = $s(tMaxFreq:(6*$li(tData,3)/tMaxFreq), 1:0)
			
			set tNode = ##class(%ZEN.Auxiliary.radialNode).%New()
			do ..%AddComponent(tNode)
			set:tSize tNode.style = "fill: black; stroke-width: "_tSize_";"
			set tNode.caption = $li(tData,2)
			do tRadNav.nodes.Insert(tNode)
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClientMethod selectNodeClient() [ Language = javascript ]
{
	var index = zen("radNavigator").selectedIndex;
	if (index < 0) { return; }
	zenPage.useTermClient(zen("radNavigator").getNode(index).caption);
}

Method OnChangeLanguageMode() As %Status
{
	// BDB526 - update labelling and layout for Japanese
	//set ..%GetComponentById("ttlTopEntities").title = $case(..languageMode, "ja":$$$Text("Top Entities"), :$$$Text("Top Concepts"))
	set ..%GetComponentById("tabRelEntities").hidden = (..languageMode="ja")
	set ..%GetComponentById("tabRelEntitiesRadial").hidden = (..languageMode="ja")
	set ..%GetComponentById("btnToggleRel").hidden = (..languageMode="ja")
	set ..%GetComponentById("relEntTabs").currTab = $case(..languageMode, "ja":3, :1)
	set ..%GetComponentById("ttlRelEntities").title = $case(..languageMode, "ja":$$$Text("Proximity Profile"), :$$$Text("Related Concepts"))
	set ..%GetComponentById("grpCRCnCC").hidden = (..languageMode="ja")
	set ..%GetComponentById("ttlPaths").title = $case(..languageMode, "ja":$$$Text("Entity Vectors"), :$$$Text("Paths"))
	set tParam = ..%GetComponentById("prmSimEntitiesRole")
	set:$isobject(tParam) tParam.value = $case(..languageMode, "ja":$$$ENTTYPECONCEPT, :$$$ENTTYPEANY)
	quit $$$OK
}

}
