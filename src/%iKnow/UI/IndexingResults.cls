/// <p>This is a sample User Interface built on top of the iKnow APIs, visualizing the results of the
/// iKnow Smart Indexing API. You can either select an existing source from the dropdown list, or
/// use the input button to enter free text directly.</p>
Class %iKnow.UI.IndexingResults Extends %iKnow.UI.AbstractSourceViewer [ System = 4 ]
{

Parameter PAGENAME = "iKnow Indexing Results";

Parameter LOADINCURRENTDOMAIN = 1;

Property sortCriteria As %ZEN.Datatype.string [ InitialExpression = "frequency" ];

Property showStems As %ZEN.Datatype.string [ InitialExpression = "entities" ];

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

.box {
	border: 1px solid black;
	width: 100%;
	padding: 15px;
}

.nonRelevant {
	font-style: italic;
	color: #777777;
}

.pathRelevant {
	font-style: italic;
	font-weight: bold;
}

.concept {
	font-weight: bold;
	background-color: #ffff66;
}

.relation {
	text-decoration: underline;
}

.negation {
	color: red;
}

.wordNegation {
	outline: 2px solid red;
}

.wordModifier {
	border: 2px solid #99ff99;
}

.wordTime {
	border: 2px solid #9999ff;
}

.sentimentPos {
	border: 2px dotted ForestGreen;
}
.sentimentNeg {
	border: 2px dotted Purple;
}
.wordSentimentPos {
}
.wordSentimentNeg {
}


.crc {
}

.path {
	
}

</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="iKnow - Indexing Results" width="100%" height="100%">
<form method="post" id="frmIndexingResults" width="100%" height="100%">
<vgroup height="100%" width="100%">
<pane paneName="logoPane" />
<spacer height="10" />
<hgroup width="100%">
<pane paneName="optSourcePane" />
<spacer width="10" />
<pane paneName="btnInputPane" />
<spacer width="20" />
<radioSet valueList="frequency,dominance" label="sort by:" layout="horizontal"  
onchange="zenPage.toggleSortCriteria(zenThis.getValue());" value="frequency" id="radSortBy" />
<spacer width="20" />
<radioSet valueList="entities,stems" hidden="true" label="display:" layout="horizontal" 
onchange="zenPage.toggleStemCriteria(zenThis.getValue());" value="entities" id="radShowStems" />
<spacer width="40%" />
<pane paneName="optDomainPane" />
</hgroup>
</vgroup>
<pane paneName="infoPane" />
<spacer height="10" />
<group id="grpMain" layout="vertical" cellVAlign="top" width="95%">
<vgroup enclosingClass="box" width="95%" id="grpSentences">
<titleBox title="Indexed sentences" />
<spacer height="10" />
<html id="divSentences" OnDrawContent="DrawSentences" />
</vgroup>
<spacer height="10" width="10" />
<hgroup valign="top" width="95%" id="grpElements">
<vgroup enclosingClass="box" width="45%" align="left" valign="top" id="grpConcepts">
<titleBox title="Concepts" id="ttlConcepts" />
<spacer height="10" />
<html id="divConcepts" OnDrawContent="DrawConcepts" />
</vgroup>
<spacer height="10" id="spcCRCs" />
<vgroup enclosingClass="box" width="45%" align="right" valign="top" id="grpCRCs">
<titleBox title="CRCs" id="ttlCRCs" />
<spacer height="10" />
<html id="divCrcs" OnDrawContent="DrawCrcs" />
</vgroup>
</hgroup>
</group>
</form>
</page>
}

// ---------------------

// SERVER-SIDE METHODS

// ---------------------

Method DrawSentences(seed As %ZEN.Datatype.string) As %Status
{
	set tSC = $$$OK
	try {
		set tSrcObj = ..GetSourceObject()
		if (tSrcObj="") {
			write $$$Text("no source selected")
			quit
		}
		set vSrcId = $s(..source<0:$zabs(..source), 1:0)
		set tDomainId = ..GetSourceDomainId()
		
		set tHighlight("ROLE", $$$ENTTYPECONCEPT) = "<span class=""concept"">"
		set:(..languageMode'="ja") tHighlight("ROLE", $$$ENTTYPERELATION) = "<span class=""relation"">"
		set tHighlight("ROLE", $$$ENTTYPENONREL) = "<span class=""nonRelevant"">"
		set tHighlight("ROLE", $$$ENTTYPEPATHREL) = "<span class=""pathRelevant"">"
		
		if $$$IKVERSIONATLEAST(..domain,$$$IKVERSIONATTRIBUTES) {
			set tHighlight("ATTRIBUTE", $$$IKATTNEGATION) = "<span class=""negation"">"
			set tHighlight("ATTRIBUTEWORDS", $$$IKATTNEGATION) = "<font class=""wordNegation"">"
			set tHighlight("ATTRIBUTEWORDS", $$$IKATTTIME) = "<font class=""wordTime"" title=""time"">"
			set tHighlight("ATTRIBUTEWORDS", $$$IKATTMODIFIER) = "<font class=""wordModifier"" title=""modifier"">"
			
			set tHighlight("ATTRIBUTE", $$$IKATTSENPOSITIVE) = "<span class=""sentimentPos"">"
			set tHighlight("ATTRIBUTE", $$$IKATTSENNEGATIVE) = "<span class=""sentimentNeg"">"
			set tHighlight("ATTRIBUTEWORDS", $$$IKATTSENPOSITIVE) = "<font class=""wordSentimentPos"">"
			set tHighlight("ATTRIBUTEWORDS", $$$IKATTSENNEGATIVE) = "<font class=""wordSentimentNeg"">"
		}
		
		for tSentId = tSrcObj.FirstSentenceId:1:tSrcObj.FirstSentenceId+tSrcObj.SentenceCount-1 {
			
			write "<p>"
			
			do ##class(%iKnow.Queries.SentenceAPI).GetHighlighted(tDomainId, tSentId, .tHighlight, vSrcId, .tFullSent, .tSC)
			quit:$$$ISERR(tSC)
			set i = ""
			for {
				set i = $order(tFullSent(i),1,tSentence)
				quit:i=""
				write tSentence
			}
			write "</p>"
		}
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method DrawConcepts(seed As %ZEN.Datatype.string) As %Status
{
	set tSC = $$$OK
	try {
		if (..GetSourceObject()="") {
			write $$$Text("no source selected")
			quit
		}
		
		set vSrcId = $s(..source<0:$zabs(..source), 1:0)
		set tDomainId = ..GetSourceDomainId()
		
		// BDB654
		set tFilter = $s(vSrcId:"", 1:##class(%iKnow.Filters.SourceIdFilter).%New(tDomainId, ..source))
		if (..sortCriteria="frequency") {
			set tSC = ##class(%iKnow.Queries.EntityAPI).GetTop(.tEntities, tDomainId, 0, 0, tFilter, $$$FILTERFREQANDSORT, $$$SORTBYFREQUENCY, $$$ENTTYPECONCEPT, vSrcId,, (..showStems="stems"))
		} else {
			set tSC = ##class(%iKnow.Semantics.DominanceAPI).GetBySource(.tEntities, tDomainId, ..source, 0, 0, $s(..showStems="stems":$$$SDSTEMCONCEPT, 1:$$$SDCONCEPT))
		}
		quit:$$$ISERR(tSC)
		
		// now display
		write "<table width=""100%"">"
		write "<tr><th width=""100%"">"_$$$Text("entity")_"</th><th>"_..sortCriteria_"</th></tr>"
		
		set i = ""
		for {
			set i = $order(tEntities(i), 1, tData)
			quit:i=""
			
			set tString = $case(..sortCriteria, "frequency":$lg(tData,2), "dominance":$lg($lg(tData,2)))
			set tValue = $case(..sortCriteria, "frequency":$lg(tData,3), "dominance":$lg(tData,4))
			write "<tr><td>" _ tString _ "</td><td align=""right"">" _ tValue _ "</td></tr>"
		}
		write "</table>"
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	write:$$$ISERR(tSC) "<b>"_$system.Status.GetErrorText(tSC)_"</b>"
	quit tSC
}

Method DrawCrcs(seed As %ZEN.Datatype.string) As %Status
{
	set tSC = $$$OK
	try {
		if (..GetSourceObject()="") {
			write $$$Text("no source selected")
			quit
		}
		
		set vSrcId = $s(..source<0:$zabs(..source), 1:0)
		set tDomainId = ..GetSourceDomainId()
		
		// BDB654
		set tFilter = $s(vSrcId:"", 1:##class(%iKnow.Filters.SourceIdFilter).%New(tDomainId, ..source))
		if (..sortCriteria="frequency") {
			set tSC = ##class(%iKnow.Queries.CrcAPI).GetTop(.tCRCs, tDomainId, 0, 0, tFilter, $$$FILTERFREQANDSORT, $$$SORTBYFREQUENCY, vSrcId)
		} else {
			set tSC = ##class(%iKnow.Semantics.DominanceAPI).GetBySource(.tCRCs, tDomainId, ..source, 0, 0, $$$SDCRC)
		}
		quit:$$$ISERR(tSC)
		
		// now display
		write "<table width=""100%"">"
		write "<tr><th width=""100%"">"_$$$Text("CRC")_"</th><th>"_..sortCriteria_"</th></tr>"
		
		set i=""
		for {
			set i = $order(tCRCs(i), 1, tData)
			quit:i=""
			
			set tList = $case(..sortCriteria, "frequency":$li(tData,2,4), "dominance":$lg(tData,2))
			set tValue = $case(..sortCriteria, "frequency":$lg(tData,5), "dominance":$lg(tData,4))
			
			write "<tr><td>"
			write "<font class=""concept"">" _ $lg(tList,1) _ "</font> "
			write "<font class=""relation"">" _ $lg(tList,2) _ "</font> "
			write "<font class=""concept"">" _ $lg(tList,3) _ "</font>"
			write "</td><td align=""right"">" _ tValue _ "</td></tr>"
		}
		write "</table>"
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	write:$$$ISERR(tSC) "<b>"_$system.Status.GetErrorText(tSC)_"</b>"
	quit tSC
}

// ------------------

// ZEN METHODS

// ------------------

Method OnUpdateSource(sourceId As %Integer) As %Status
{
	set srcObj = ..GetSourceObject()
	quit $$$OK
}

// ------------------

// CLIENT METHODS

// ------------------

ClientMethod toggleSortCriteria(val) [ Language = javascript ]
{
	sc = zenPage.setProperty('sortCriteria', val);
	zenPage.displayResultsClient();
}

ClientMethod toggleStemCriteria(val) [ Language = javascript ]
{
	sc = zenPage.setProperty('showStems', val);
	zenPage.displayResultsClient();
}

ClientMethod onUpdateSourceClient(source) [ Language = javascript ]
{
	sc = zenPage.displayResultsClient();
	setTimeout(function(){zenPage.DeleteCurrentVirtualSource()},3000);
}

ClientMethod displayResultsClient() As %Integer [ Language = javascript ]
{
	zen('divSentences').refreshContents();
	zen('divConcepts').refreshContents();
	zen('divCrcs').refreshContents();
	return 1
}

ClientMethod onProcessInputClient() [ Language = javascript ]
{
	sc = zenPage.displayResultsClient();
}

// ------------------

// UTILITY METHODS

// ------------------

Method GetInfoPaneText() As %String
{
	quit "<p>This is a sample User Interface built on top of the iKnow APIs, visualizing the results of the "_
			"iKnow engine. To view the results for an existing, indexed source, first select the iKnow domain "_
			"from the dropdown menu in the top-right corner and then select the record in the drop-down menu "_
			"on the left.<br/>Alternatively, click the ""manual input"" button to enter free text directly.</p>"
}

Method OnChangeLanguageMode() As %Status
{
	// BDB526 - update labelling and layout for Japanese
	set ..%GetComponentById("grpConcepts").width = $case(..languageMode, "ja":"100%", :"50%")
	set ..%GetComponentById("ttlConcepts").title = $case(..languageMode, "ja":$$$Text("Entities"), :$$$Text("Concepts"))
	set ..%GetComponentById("spcCRCs").hidden = (..languageMode="ja")
	set ..%GetComponentById("grpCRCs").hidden = (..languageMode="ja")
	set ..%GetComponentById("grpMain").layout = $case(..languageMode, "ja":"horizontal", :"vertical")
	set ..%GetComponentById("grpSentences").width = $case(..languageMode, "ja":"65%", :"95%")
	set ..%GetComponentById("grpElements").width = $case(..languageMode, "ja":"25%", :"95%")
	set (..%GetComponentById("radSortBy").value,..sortCriteria) = $case(..languageMode, "ja":"dominance", :"frequency")
	quit $$$OK
}

/// This method can be overridden at the subclass level to take any additional server-side
/// actions when the domain is changed.
Method OnUpdateDomain(domainId As %Integer) As %Status
{
	set ..%GetComponentById("radShowStems").hidden = ($$$GETPARAM(domainId,$$$IKPSTEMMING,0)=0)
	quit $$$OK
}

}
