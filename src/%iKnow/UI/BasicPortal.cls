/// <p>This is a sample User Interface built on top of the iKnow query APIs, displaying a browsable overview
/// of the semantic elements identified by the iKnow Smart Indexing API. Click on an entity in a list
/// to browse to the elements similar, related or containing the selected entity.</p>
/// <p>Use the filter button to filter the displayed results based on metadata criteria.</p>
Class %iKnow.UI.BasicPortal Extends %iKnow.UI.AbstractPortal [ System = 4 ]
{

Parameter PAGENAME = "Basic iKnow Portal";

Property summaryLength As %ZEN.Datatype.integer(ZENURL = "summaryLength") [ InitialExpression = 10 ];

XData Style
{
<style type="text/css">
body {
	font-family: Verdana, Arial;
	font-size: 10px;
}

a {
	color: #a00000;
}

.resultList {
	overflow-y: auto;
}

</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" 
	 title="iKnow - Basic Portal" width="100%" height="100%" >

<modalGroup id="summaryBox">
<vgroup width="100%" height="100%">
<titleBox title="Full text" />
<spacer height="5" />
<html id="summary" OnDrawContent="DrawSummary" enclosingClass="resultList" height="200" />
<spacer height="5" />
<hgroup>
<label label="Create summary: " />
<text id="summaryLength" value="10" maxlength="4" />
<button onclick="zenPage.buildSummaryClient();return;" caption="go" />
</hgroup>
<spacer height="10" />
<titleBox title="Metadata" />
<spacer height="5" />
<tablePane id="metadata" queryClass="%iKnow.Queries.MetadataQAPI" queryName="GetValuesById" width="100%"
OnExecuteResultSet="ExecuteQuery" showRowSelector="false" enclosingClass="resultList" height="150">
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.source)#" />
<column colName="mdFieldId" hidden="true" />
<column colName="fieldName" header="Field name" />
<column colName="value" header="Value" OnDrawCell="DrawMetadataValue" />
</tablePane>
</vgroup>
</modalGroup>


<form method="post" id="kpForm" width="100%" height="100%">
<vgroup height="100%" width="100%">
<pane paneName="logoPane" id="logoContainer" />
<hgroup width="100%" id="controlsContainer">
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
<spacer height="10" />
<hgroup width="100%" cellVAlign="top" height="100%" id="resultListContainer">
<vgroup width="33%" height="100%" valign="top">
<titleBox title="Top Concepts" id="ttlTopEntities" />
<spacer height="5" />
<repeatingGroup id="topEntities" OnExecuteResultSet="ExecuteQuery" enclosingClass="resultList"
queryClass="%iKnow.Queries.EntityQAPI" queryName="GetTop" width="100%" height="100%">
<parameter value="#(%page.domain)#" />
<parameter value="#(%session.pagetopEntities)#" />
<parameter value="25" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
<parameter value="-1" />
<parameter value="0" />
<parameter value="0" />
<parameter value="#(%page.blacklists)#" />
<hgroup width="100%">
<link href="javascript:zenPage.useTermClient('#(%query.entity)#');" caption="#(%query.entity)#" />
<label label="#(%query.frequency)# - #(%query.spread)#" align="right" />
</hgroup>
</repeatingGroup>
<spacer height="5" />
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('topEntities');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('topEntities');" />
</hgroup>
</vgroup>
<spacer width="20" />
<vgroup width="33%" height="100%" valign="top">
<vgroup height="50%" width="100%" id="grpSimEntities">
<titleBox title="Similar Entities" />
<spacer height="5" />
<repeatingGroup id="simEntities" OnExecuteResultSet="ExecuteQuery" enclosingClass="resultList"
queryClass="%iKnow.Queries.EntityQAPI" queryName="GetSimilar" width="100%" >
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagesimEntities)#" />
<parameter value="10" id="prmSimEntitiesPageSize" />
<parameter value="#(%page.filter)#" />
<parameter value="#(%page.filtermode)#" />
<parameter value="0" />
<parameter value="#(%page.blacklists)#" />
<parameter value="-1" id="prmSimEntitiesRole" />
<hgroup width="100%">
<link href="javascript:zenPage.useTermClient('#(%query.entity)#');" caption="#(%query.entity)#" />
<label label="#(%query.frequency)# - #(%query.spread)#" align="right" />
</hgroup>
</repeatingGroup>
<spacer height="5" />
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('simEntities');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('simEntities');" />
</hgroup>
</vgroup>
<spacer height="20" id="spcRelEntities" />
<vgroup height="50%" width="100%" id="grpRelEntities">
<titleBox title="Related Entities" />
<spacer height="5" />
<repeatingGroup id="relEntities" OnExecuteResultSet="ExecuteQuery" enclosingClass="resultList"
queryClass="%iKnow.Queries.EntityQAPI" queryName="GetRelated" width="100%">
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
<hgroup width="100%">
<link href="javascript:zenPage.useTermClient('#(%query.entity)#');" caption="#(%query.entity)#" />
<label label="#(%query.frequency)# - #(%query.spread)#" align="right" />
</hgroup>
</repeatingGroup>
<hgroup align="right">
<spacer height="5" />
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('relEntities');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('relEntities');" />
</hgroup>
</vgroup>
</vgroup>
<spacer width="20" />
<vgroup width="33%" height="100%" valign="top">
<titleBox title="Sources" />
<spacer height="5" />
<repeatingGroup id="sources" OnExecuteResultSet="ExecuteQuery" enclosingClass="resultList" 
queryClass="%iKnow.Queries.SourceQAPI" queryName="GetByEntities" width="100%">
<parameter value="#(%page.domain)#" />
<parameter value="#(%page.term)#" />
<parameter value="#(%session.pagesources)#" />
<parameter value="25" />
<parameter value="#(%page.filter)#" />
<hgroup width="100%">
 <html OnDrawContent="DrawSource" />
 </hgroup>
</repeatingGroup>
<spacer height="5" />
<hgroup align="right">
<button caption="&lt;&lt;" onclick="javascript:zenPage.previousPageClient('sources');" />
<button caption="&gt;&gt;" onclick="javascript:zenPage.nextPageClient('sources');" />
</hgroup>
</vgroup>
</hgroup>
</vgroup>
</form>
</page>
}

Method DrawSource(pSeed As %String) As %Status
{
	set srcId = %query.srcId
	set extId = %query.externalId
	write "<a href=""javascript:zenPage.displaySourceClient(",srcId,");"" title=""",extId,""">",srcId,"</a>: "
	
	set domain = ..domain
	set terms = $lfs(..term)
	kill tHighlight
	for j=1:1:$ll(terms) {
		set id = ##class(%iKnow.Queries.EntityAPI).GetId(domain, $li(terms,j))
		set $li(terms,j) = id, tHighlight("ENTITY",id) = "<b>"
	}
	write "... "
	set tSC = ##class(%iKnow.Queries.SentenceAPI).GetByEntityIds(.res, domain, terms, $lb(srcId))
	set j = ""
	for {
		set j = $order(res(j),-1,sent)
		quit:j=""
		
		write ##class(%iKnow.Queries.SentenceAPI).GetHighlighted(domain, $li(sent,3), .tHighlight)
		write " ... "
	}
	
	quit $$$OK
}

Method InitPages() As %Status
{
	set %session.Data("pagetopEntities") = 1
	set %session.Data("pagesimEntities") = 1
	set %session.Data("pagerelEntities") = 1
	set %session.Data("pagesources") = 1
	quit ##super()
}

ClientMethod onUpdateFilterClient() [ Language = javascript ]
{
	zen('topEntities').refreshContents();
	zen('simEntities').refreshContents();
	zen('relEntities').refreshContents();
	zen('sources').refreshContents();
	this.setProperSizes();
}

ClientMethod onUpdateTermClient() [ Language = javascript ]
{
	zen("simEntities").refreshContents();
	zen("relEntities").refreshContents();
	zen("sources").refreshContents();
	this.setProperSizes();
}

ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	this.setProperSizes();
}

ClientMethod setProperSizes() [ Language = javascript ]
{
	var top = zen('logoContainer').getEnclosingDiv().clientHeight;
	top = top + zen('controlsContainer').getEnclosingDiv().clientHeight + 20;
	var fullHeight = zenGetWindowHeight()-top-100;
	var halfHeight = fullHeight/2-25;
	
	zen('topEntities').getEnclosingDiv().style.height = fullHeight;
	zen('simEntities').getEnclosingDiv().style.height = halfHeight;
	zen('relEntities').getEnclosingDiv().style.height = halfHeight;
	zen('sources').getEnclosingDiv().style.height = fullHeight;
}

ClientMethod displaySourceClient(sourceId) [ Language = javascript ]
{
	var sc = zenPage.updateSourceClient(sourceId);
	zenPage.getComponentById("summaryBox").show($$$Text("Source details"),"static","",50,150,600);
}

Method UpdateSummaryLength(length As %Integer) As %Status [ ZenMethod ]
{
	set ..summaryLength = length
	quit $$$OK
}

ClientMethod buildSummaryClient() [ Language = javascript ]
{
	zenPage.setProperty('summaryLength', zen('summaryLength').getValue());
	zen('summary').refreshContents();
	zen('summary').getEnclosingDiv().style.height = 200;
}

Method DrawSummary(pSeed As %String) As %Status
{
	if (..summaryLength>0) {
		set tSC = ##class(%iKnow.Queries.SourceAPI).GetSummary(.result, ..domain, ..source, ..summaryLength)
	} else {
		set tSC = ##class(%iKnow.Queries.SentenceAPI).GetBySource(.result, ..domain, ..source, 0, 0)
	}
	set i = ""
	for {
		set i = $o(result(i),1,d)
		quit:i=""
		
		write $list(d,2)
	}
	
	quit $$$OK
}

ClientMethod onUpdateSourceClient(source) [ Language = javascript ]
{
	if ((source == null) || (source = 0)) return;
	zen('metadata').refreshContents();
	zen('summaryLength').setValue(0);
	zen('summary').refreshContents();
	zen('summary').getEnclosingDiv().style.height = 200;
}

Method DrawMetadataValue(pTable As %ZEN.Component.tablePane, pName As %String, pSeed As %String) As %Status
{
	set mdfObj = ##class(%iKnow.Objects.MetadataField).PKINDEXOpen(..domain, %query("mdFieldId"))
	
	set value = %query("value")
	if (mdfObj.DataType = $$$MDDTDATE) {
		write $s(+$p(value,",",2):$zdatetime(value), 1:$zdate(value))
	} else {
		write value
	}
	
	quit $$$OK
}

Method GetInfoPaneText() As %String
{
	quit "<p>This is a sample User Interface built on top of the iKnow query APIs, displaying a browsable overview "_
			"of the semantic elements identified by the iKnow Smart Indexing API. Click on an entity in a list " _
			"to browse to the elements similar, related or containing the selected entity.</p>" _
			"<p>Use the filter button to filter the displayed results based on metadata criteria.</p>"
}

Method OnChangeLanguageMode() As %Status
{
	// BDB526 - update labelling and layout for Japanese
	set ..%GetComponentById("ttlTopEntities").title = $case(..languageMode, "ja":$$$Text("Top Entities"), :$$$Text("Top Concepts"))
	set ..%GetComponentById("grpSimEntities").height = $case(..languageMode, "ja":"100%", :"50%")
	set ..%GetComponentById("spcRelEntities").hidden = (..languageMode="ja")
	set ..%GetComponentById("grpRelEntities").hidden = (..languageMode="ja")
	set tParam = ..%GetComponentById("prmSimEntitiesPageSize")
	set:$isobject(tParam) tParam.value = $case(..languageMode, "ja":25, :10)
	set tParam = ..%GetComponentById("prmSimEntitiesRole")
	set:$isobject(tParam) tParam.value = $case(..languageMode, "ja":$$$ENTTYPECONCEPT, :$$$ENTTYPEANY)
	quit $$$OK
}

}
