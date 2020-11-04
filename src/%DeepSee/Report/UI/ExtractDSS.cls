/// DeepSee Report DSS Extraction From Legacy Report Page.
/// 
Class %DeepSee.Report.UI.ExtractDSS Extends %DeepSee.UI.standardPage [ DependsOn = (%DeepSee.Report.UI.reportModelServer, %DeepSee.Report.UI.dataSourcePanel, %DeepSee.Report.UI.dataPickPool, %DeepSee.Report.UI.busyPanel), LegacyInstanceContext, System = 4 ]
{

/// Do NOT auto-switch namespace to whatever is passed in work in the user's current space.
Parameter AUTONS As BOOLEAN = 0;

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

/// Displayed name of this page.
Parameter PAGENAME = "DeepSee Visual Reporting DSS Extractor";

Parameter JSINCLUDES = "zenCSLM.js,zenESVG.js";

Parameter USERPACKAGES = "%DeepSee.Report.UI";

/// The placeholder name given to reports that have yet to be saved to disk
Property defaultRptName As %ZEN.Datatype.string [ InitialExpression = "UnnamedXDSS" ];

/// Name of Report being viewed.
Property reportName As %ZEN.Datatype.string(ZENURL = "CLS");

/// Data source. This is a copy of the value in the report model.
Property dataSource As %ZEN.Datatype.string;

/// This Style block contains page-specific CSS 3 style definitions.
XData CSS3Style
{
<style type="text/css">

body {
	user-select: none;
}

.zenLabel {
	color: #000077;
	font: 12px Arial;
}

.labelText {
	color: #404040;
	font: 14px Arial;
}

.zenLabelDisabled {
	font-size: 10pt;
}

.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}

.checkbox {
	border: 1px solid #a0a0a0;
}

.text {
	border: 1px solid #a0a0a0;
	color: #404040;
	font: 12px Arial;
}

.cssIsland {
	position:relative;
	top:0px;
	left:0px;
}

.detailLabel {
	font-weight: bold;
	color: rgb(71,72,67);
	font-size: 10pt;
}

.zenLabelDisabled {
	color:#000077;
}

#tabGroup {
	overflow:hidden;
}

#dataTab {
	overflow:hidden;
}

#dataSourcePane {
	background: white;
	font: 14px Arial;
	color: #404040;	
	width: 50%;
	overflow: auto;
	border-bottom: 1px solid gray;
	position:relative;
	top:0px;
	left:0px;
}

#sourceClassName {
	margin: 16px;
	font:bold 14px Arial;
}

#sourceClassName span.labelText{
	font:bold 14px Arial;
}

#sourceURLProperties {
	display:block;
	width:90%;
	height:50px;
	border:1px solid #356B8D;
	margin-left:5%;
	margin-bottom:16px;
	overflow:auto;
}

#sourceReportDef {
	display:block;
	position:absolute;
	top:182px;
	bottom:5px;
	width:90%;
	border:1px solid #356B8D;
	left:5%;
	overflow:auto;
}

#schemaPane {
	background: white;
	color: #404040;	
	font: 14px Arial;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
	position:absolute;
	display:block;
	top:0px;
	left:50%;
	width:50%;
}

#projection {
	position:absolute;
	top:27px;
	left:0px;
	bottom:0px;
	width:100%;
	overflow:auto;
}

.dataPickPoolArea {
	background:white;
}

.dataPickPoolDatum {
	color:#404040;
	font:14px monospace;
}

.dataPickPoolGroupHeader {
	font:14px Arial;
}

.helpCommand {
	text-decoration: none;
	color: white;
	font-size: 10pt;
}

.helpCommand:hover {
	text-decoration: none;
	color: darkred;
}

.zruHeaderDiv {
	padding: 5px;
	height: 12pt;
	font-size: 12pt;
	color: #404040;
	background: #e8e7e2;
	border-bottom: 1px solid #C0C0C0;
}

.zruHeaderTitle {
	font-weight:bold;
}

.zruHeaderLink {
	font-size: 10pt;
	font-weight: normal;
	color: #5ba4dc;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.zruHeaderLinkDisabled {
	font-size: 10pt;
	font-weight: normal;
	color: gray;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.zruHeaderLink:hover {
	color: #98923a;
}

.ribbonTitle {
	background:#356b8d;
	color:#ffffff;
	padding-right:10px;
	width:100%;
}

pre {
	margin-top:0px;
	padding-top:0px;
	white-space:pre;
}

</style>
}

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

body {
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-o-user-select: none;
	user-select: none;
}

.zenLabel {
	color: #000077;
	font: 12px Arial;
}

.labelText {
	color: #404040;
	font: 14px Arial;
}

.zenLabelDisabled {
	font-size: 10pt;
}

.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}

.checkbox {
	border: 1px solid #a0a0a0;
}

.text {
	border: 1px solid #a0a0a0;
	color: #404040;
	font: 12px Arial;
}

.cssIsland {
	position:relative;
	top:0px;
	left:0px;
}

.detailLabel {
	font-weight: bold;
	color: rgb(71,72,67);
	font-size: 10pt;
}

.zenLabelDisabled {
	color:#000077;
}

#tabGroup {
	overflow:hidden;
}

#dataTab {
	overflow:hidden;
}

#dataSourcePane {
	background: white;
	font: 14px Arial;
	color: #404040;	
	width: 50%;
	overflow: auto;
	border-bottom: 1px solid gray;
	position:relative;
	top:0px;
	left:0px;
}

#sourceClassName {
	margin: 16px;
	font:bold 14px Arial;
}

#sourceClassName span.labelText{
	font:bold 14px Arial;
}

#sourceURLProperties {
	display:block;
	width:90%;
	height:50px;
	border:1px solid #356B8D;
	margin-left:5%;
	margin-bottom:16px;
	overflow:auto;
}

#sourceReportDef {
	display:block;
	position:absolute;
	top:182px;
	bottom:5px;
	width:90%;
	border:1px solid #356B8D;
	left:5%;
	overflow:auto;
}


#schemaPane {
	background: white;
	color: #404040;	
	font: 14px Arial;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
	position:absolute;
	display:block;
	top:0px;
	left:50%;
	width:50%;
}

#projection {
	position:absolute;
	top:27px;
	left:0px;
	bottom:0px;
	width:100%;
	overflow:auto;
}

.dataPickPoolArea {
	background:white;
}

.dataPickPoolDatum {
	color:#404040;
	font:14px monospace;
}

.dataPickPoolGroupHeader {
	font:14px Arial;
}

.helpCommand {
	text-decoration: none;
	color: white;
	font-size: 10pt;
}

.helpCommand:hover {
	text-decoration: none;
	color: darkred;
}

.zruHeaderDiv {
	padding: 5px;
	height: 12pt;
	font-size: 12pt;
	color: #404040;
	background: #e8e7e2;
	border-bottom: 1px solid #C0C0C0;
}

.zruHeaderTitle {
	font-weight:bold;
}

.zruHeaderLink {
	font-size: 10pt;
	font-weight: normal;
	color: #5ba4dc;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.zruHeaderLinkDisabled {
	font-size: 10pt;
	font-weight: normal;
	color: gray;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.zruHeaderLink:hover {
	color: #98923a;
}

.ribbonTitle {
	background:#356b8d;
	color:#ffffff;
	padding-right:10px;
	width:100%;
}

pre {
	margin-top:0px;
	padding-top:0px;
	white-space:pre;
}

</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none">
<reportModelServer id="modelServer" />

<popGroup id="busyTrap" width="50%" height="150px"  headerStyle="none">
<busyPanel/>
</popGroup>

<tabGroup id="tabGroup">
<tab id="dataTab" layout="none">
<group enclosingClass="cssIsland" enclosingStyle="width:100%;height:100%" layout="none">

<!-- Holder for original DB sources -->
<group layout="none" id="dataSourcePane">
<html id="sourceHeader"  enclosingClass="zruHeaderDiv"/>
<label id="sourceClassName" />
<label value="URL Properties:" enclosingStyle="margin-left:16px;"/>
<group layout="none" id="sourceURLProperties" />
<label value="ReportDefinition:" enclosingStyle="margin-left:16px;"/>
<group layout="none" id="sourceReportDef" />
</group>

<!-- holder for report schema table -->
<group layout="none" id ="schemaPane" enclosingClass="cssIsland"  >
<html id="projectionHeader" enclosingClass="zruHeaderDiv"/>
<dataPickPool id="projection" />
</group>
</group>
</tab>

<!-- Reserved for future feature set
<tab id="propertyTab" layout="none">
<propertyEditor id="propertyEditPanel" />
</tab>
-->

<tab id="blankTab" layout="none">
</tab>

</tabGroup>
</pane>
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit $$$Text("Legacy Report DSS Extractor")
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Legacy Report DSS Extractor","%DeepSee")
}

/// Get the product name for the page.
Method %OnGetProductName() As %String
{
	Quit "DeepSee"
}

Method %OnGetJSResources(ByRef pResources As %String) As %Status [ Private ]
{
	Set pResources("DataSource") = $$$Text("Data Source")
	Set pResources("DataProjection") = $$$Text("Data Projection")
	Set pResources("Change") = $$$Text("Change")
	Set pResources("ChangeTheDataSourceForThisReport") = $$$Text("Change the data source for this report")
	Set pResources("NoSourceClassSelected") = $$$Text("(no source class selected)")
	Set pResources("NoActiveClass") = $$$Text("( no active class )")
	Set pResources("ThereIsNoActiveDocumentToSave") = $$$Text("There is no active document to save")
	Set pResources("TheCurrentClassHasUnsavedChangesPressOkToSaveOrCancelToDiscard") = $$$Text("The current class has unsaved changes.  Press 'Ok' to save or 'Cancel' to discard")
	Set pResources("TheCurrentClassHasUnsavedChanges") = $$$Text("The current class has unsaved changes.")
	Set pResources("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation") = $$$Text("The current class has unsaved changes.  Press 'Ok' to discard changes and proceed or 'Cancel' to abort the current operation.")
	Set pResources("TheCurrentClassAlreadyHasADSSSectionDefinedPressOkToDiscardOverwriteThisSectionAndProceedOrCancelToAbortTheCurrentOperation") = $$$Text("The current class already has a DSS section defined.  Press 'Ok' to discard overwrite this section and proceed or 'Cancel' to abort the current operation.")
	Set pResources("TheSelectedClassHasAnActiveDataCollectionSchemeAndWasNotGeneratedWithThisToolEditingSuchAClassIsNotRecommended") = $$$Text("The selected class has an active data collection scheme and was not generated with this tool.  Editing such a class is not recommended.")
	Set pResources("TheSelectedClassHasAnActiveDataCollectionSchemeAndMayNotHaveBeenGeneratedWithThisToolEditingSuchAClassIsNotRecommendedPressOKToContinueOverwritingThisSectionOrCancelToAbort") = $$$Text("The selected class has an active data collection scheme and may not have been generated with this tool.  Editing such a class is not recommended. Press 'OK' to continue (overwriting this section) or 'Cancel' to abort.")
	Set pResources("TheSelectedClassIsNotAvailablePossiblyBecauseItIsNoLongerCompiledOrIsInTheProcessOfBeingSo") = $$$Text("The selected class is not available, possibly because it is no longer compiled or is in the process of being so.")
	Set pResources("TheSelectedClassDoesNotDefineAReportDefinitionSectionSuitableForExtraction") = $$$Text("The selected class does not define a ReportDefinition section suitable for extraction.")
	Set pResources("TheReportDefinitionOfTheSelectedClassCouldNotBeImportedPossiblyDueToTheLackOfAStaticGroupDefinition") = $$$Text("The ReportDefinition of the selected class could not be imported, possibly due to the lack of a static group definition")
	Set pResources("SaveFailedWithError") = $$$Text("Save failed with Error:")
	Quit $$$OK
}

/// This class method callback is called just before the server-side page 
/// object is created.
Method %OnAfterCreatePage() As %Status
{
	// first dispatch to super class
	Set tSC = ##super()
	If $$$ISERR(tSC) Quit tSC
	
	Set tSC = $$$OK
	Try {
		// check privileges
		if ('$$CheckReportDataDefAccess^%qdsUtils()) {
			Set %response.Redirect = ##class(%DeepSee.Utils).%GetErrorPageURL("License")
			Throw ##class(%Exception.SystemException).%New("DeepSee License")
		}
		Set ..reportName = ""
		Set ..dataSource = ""
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set tPageName = $$$Text("DeepSee","%DeepSee")
	Set pLink($I(pLink)) = $LB(tPageName,..homePage)

	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT(..%ClassName(1),"O","URL")_".zen?home="_..EscapeURL($G(%request.Data("home",1)))_"&REPORT="_$ZCVT(..reportName,"O","URL"))
	Quit $$$OK
}

/// Set the title block section of the ribbon to the given text
ClientMethod setRibbonTitle(str) [ Language = javascript ]
{
	var td = ZLM.getElementsByClassPrefix("ribbonTitle","toolRibbon");
	td[0].innerHTML="<nobr>"+str+"</nobr>";
}

/// Draw the header for the data source panel
ClientMethod drawSourceHeader(title, msgChange, hlpChange) [ Language = javascript ]
{
	var h=[];
	h.push('<span class="zruHeaderTitle"><nobr>'+title+'</nobr></span>');
	if (msgChange) {
		h.push('&nbsp;<a class="zruHeaderLink" href="#" title="'+hlpChange+'" onclick="zenPage.changeDataSource();return false;">'+msgChange+'</a>');
	}
	var d = document.getElementById("sourceHeader");
	d.innerHTML=h.join("");
}

/// Draw the header for the data projection panel
ClientMethod drawProjectionHeader(title) [ Language = javascript ]
{
	var h=[];
	h.push('<span class="zruHeaderTitle"><nobr>'+title+'</nobr></span>');
	var d = document.getElementById("projectionHeader");
	d.innerHTML=h.join("");
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
 	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = $$$Text("Legacy Report DSS Extractor")

	Set pViewIcons(1) = $LB("data",$$$Text("Show report data definition"),"portal/view_report_data.png")
	//Set pViewIcons(2) = $LB("properties",$$$Text("Show report class properties"),"portal/view_data_properties.png")

	// commands
	// $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("cmdOpen",$$$Text("Open"),$$$Text("Open an existing report data schema Definition"),"zenPage.openDSS();")
	Set pCommands(2) = $LB("cmdNew",$$$Text("New"),$$$Text("Create a new report data schema Definition"),"zenPage.newDSS();")
	Set pCommands(3) = $LB("cmdSave",$$$Text("Save"),$$$Text("Save this report data schema Definition"),"zenPage.saveDSS();")
	Set pCommands(4) = $LB("cmdSaveAs",$$$Text("Save As"),$$$Text("Save this document under a new name"),"zenPage.saveAsDSS();")
	Quit $$$OK
}

ClassMethod GetXDataTextSection(xdataID As %String) As %String [ ZenMethod ]
{
   Set m = ""
   If (xdataID="") {
	   Set m = "!!NOCLASS"
   }
   Else {
	   // Get a stream of XML from the XData block contained in this class
	   Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xdataID)
	   If '$IsObject(compiledXdata) {
		   Set m = "!!OPENFAILED"
	   }
	   Else {
		   Set tStream=compiledXdata.Data
		   If '$IsObject(tStream) {
			   Set tSC=%objlasterror 
			   Set m = "!!NODATA"
		   }
		   Else {
			   //iterate through document, node by node
			   Do tStream.Rewind()
			   While (tStream.AtEnd = 0) {
				   Set l = tStream.ReadLine()
			 	   Set m = m_$CHAR(10)_l
			   }
		   }
   	   }
   }	
   Quit m
}

/// This method returns true of pClassName is a subclass of %DeepSee.Report.dataCollector and
/// therefore has an active DCR xData Section and should NOT be opened by this tool.
ClassMethod HasDCRSection(pClassName) As %Boolean [ Internal, ZenMethod ]
{
	If pClassName="" Quit 0
	Set tSuper = "%DeepSee.Report.dataCollector"
	If pClassName=tSuper Quit 1
	Set tSuperClasses=$lg($get(^rINDEXCLASS($zcvt(pClassName,"u"))),7)
	Set tFound=0
	For i=1:1:$l(tSuperClasses,",") {
		Set tSuperOne=$p(tSuperClasses,",",i)
		Do NormalizeClassnameByDef^%occName(.tNormalized,tSuperOne,pClassName)
		If tNormalized=tSuper Set tFound=1 Quit
		Set tFound=..HasDCRSection(tNormalized) If tFound Quit
	}
	Quit tFound
}

/// Return a JSON string representing an array of the class properties that have ZENURL 
/// parameters set for them
Method GetClassProperties(className As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set rValue = "["
	Set rFirst = 1
	
	Set:className'="" cdef=##class(%ClassDefinition).%OpenId(className)
	If (cdef=$$$NULLOREF) QUIT "ERROR"
	Set tmp=$property(cdef,"Properties")
	For i=1:1:tmp.Count() {
		Set pObj = "{"
		Set item=tmp.GetAt(i)
		Set pCount = item.Parameters.Count()
		if (pCount>0) {  ;# if no parameters skip it and move on
			Set pObj = pObj_"n:'"_item.Name_"',e:'"_item.InitialExpression_"',"
			Set pFound = 0
			Set idx = 1
			Set pName = ""
			while (idx<=pCount) {
				Set pVal=item.Parameters.GetNext(.pName)
				if (pName="ZENURL") {
					Set pObj = pObj_"u:'"_pVal_"'}"
					Set pFound = 1
				}	
				Set idx = idx+1
			}
			if (pFound=1) {
				if (rFirst=0) {
					Set rValue = rValue_","
				}
				Set rValue = rValue_pObj
				Set rFirst = 0
			}					
		}
	}
	Set rValue = rValue_"]"
	Quit rValue
}

/// Check if user really wants to exit if they have not saved changes
ClientMethod onunloadHandler() [ Language = javascript ]
{
	if (this._documentEdited) {
		return(zenText("TheCurrentClassHasUnsavedChanges"));
	}
}

/// Adjust sizes of components on the page.
ClientMethod onlayoutHandler(load) [ Language = javascript ]
{
	try {
		this.adjustSizes();
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler');
	}
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._documentActive = false;
	this._documentEdited = false;

	this.drawSourceHeader(zenText("DataSource"),zenText("Change"),zenText("ChangeTheDataSourceForThisReport"));
	this.drawProjectionHeader(zenText("DataProjection"));

	this.resetDSS();
	
	if (this.reportName=="") {
		this.reportName = this.defaultRptName;
		var value = {};
		value.pkgName = "MyApp";
		value.clsName = this.reportName;
		value.appName = " ";
		value.desc = " ";
		value.rptName = this.reportName;

		this.dss = this.modelServer.createNewDSS(value);
		var newDSS = this.modelServer.convertRDToDSS("","<report name='"+this.reportName+"'/>");
		this.dss.dss=newDSS;
		this.setViewMode('none');
		this.setRibbonTitle(value.pkgName+'.'+value.clsName);
		this._documentActive = true;
		this._documentEdited = false;
		this.setViewMode('data');
	}
}

ClientMethod getModelServer() [ Language = javascript ]
{
	return(zen('modelServer'));
}

ClientMethod getDataSourceWidget() [ Language = javascript ]
{
	return(zen('dataSourceTree'));
}

/// Adjust sizes of components on the page.
ClientMethod adjustSizes(dnr) [ Language = javascript ]
{
	try {
		// get divs for data tab
		var dataSourceDiv = zen('dataSourcePane').getEnclosingDiv();
		var schemaDiv = zen('schemaPane').getEnclosingDiv();
		var winHeight = zenGetWindowHeight();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 10;
		
		dataSourceDiv.style.height = hgt + 'px';
		schemaDiv.style.height = hgt + 'px';

		if (!dnr) setTimeout("zenPage.adjustSizes(1);",10);
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

/// Do the actual work of updating the view to match the current view mode.
ClientMethod setViewModeHandler(mode) [ Language = javascript ]
{
	var tabGroup = zen('tabGroup');	
	switch(mode) {
	case 'data':
		tabGroup.showTab(1);
		this.adjustSizes();
		break;
	case 'none':
		tabGroup.showTab(2);
		break;
	}
}

/// Launch the data source dialog.
ClientMethod changeDataSource() [ Language = javascript ]
{
	var d = this.dss.dss;
	if (d) {
		if ((d.attr && d.attr.length) || (d.item && d.item.length)) {
			var x = confirm(zenText("TheCurrentClassAlreadyHasADSSSectionDefinedPressOkToDiscardOverwriteThisSectionAndProceedOrCancelToAbortTheCurrentOperation"));
			if (!x) return;
		}
	}
	
	var parms = {
		SUPER:'%ZEN.Report.reportPage'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','DataSource','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

/// Set the dataSource for the report.
ClientMethod setDataSource(cls) [ Language = javascript ]
{
	var sCN = this.getComponentById("sourceClassName");
	var sUP = document.getElementById("sourceURLProperties");
	var sRD = document.getElementById("sourceReportDef");
	
	var src = this.GetXDataTextSection(cls+"||ReportDefinition");
	if (src.indexOf("!!")==0) {
		alert(zenText("TheSelectedClassIsNotAvailablePossiblyBecauseItIsNoLongerCompiledOrIsInTheProcessOfBeingSo"));
		this._documentEdited = false;
		return;
	}
	if (src == "") {
		alert(zenText("TheSelectedClassDoesNotDefineAReportDefinitionSectionSuitableForExtraction"));
		this._documentEdited = false;
		return;
	}		
	var props = this.GetClassProperties(cls);
	var pArray = ZLM.jsonParse(props);
	var pStr = [];
	for (var i=0;i<pArray.length;i++) {
		pStr.push(pArray[i].u);
	}
	var newDSS = this.modelServer.convertRDToDSS(cls,src);

	if (!newDSS) {
		alert(zenText("TheReportDefinitionOfTheSelectedClassCouldNotBeImportedPossiblyDueToTheLackOfAStaticGroupDefinition"));
		this._documentEdited = false;
		return;
	}		
		
	var disp = zen('projection');
	disp.setTitle(newDSS.nodeName);
	disp.setDataTreeFromDSS(newDSS,true);
	
	var n = document.createTextNode(src);
	sCN.setValue(cls);
	sUP.innerHTML='<pre>'+pStr.join('\n')+'</pre>';
	sRD.innerHTML='<pre></pre>';
	sRD.firstChild.appendChild(n);		
	this.dss.dss=newDSS;
}

/// reset the active editors
ClientMethod resetDSS() [ Language = javascript ]
{
	this.dataSource = "";
	var disp = zen('projection');
	disp.clear();

	var sCN = this.getComponentById("sourceClassName");
	sCN.setValue(zenText("NoSourceSelected"));
	
	var sUP = document.getElementById("sourceURLProperties");
	sUP.innerHTML = "";
	var sRD = document.getElementById("sourceReportDef");
	sRD.innerHTML = "";
	
	this.setViewMode('none');
	this.modelServer = zen("modelServer");
	this.dss = this.modelServer.createNewDSS(null);

	this.setRibbonTitle(zenText('NoActiveClass'));
	this._documentActive = false;
}

/// Invoke dialog to open a report.
ClientMethod openDSS() [ Language = javascript ]
{
	if (this._documentEdited) {
		var x = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!x) return;
	}
	if (this._documentActive) this.resetDSS();
	
	var parms = {
		SUPER:'%DeepSee.Report.dataSchemaInterface'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','OpenReport','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

/// Invoke dialog to create a new report.
ClientMethod newDSS() [ Language = javascript ]
{
	if (this._documentEdited) {
		var x = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!x) return;
	}

	if (this._documentActive) {
		this.resetDSS();
	}

	var parms = {
		SUPER:'%DeepSee.Report.dataSchemaInterface',
		CHECKUSERS:1
	}
	
	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls?NOAPP=1','NewReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Rename this report and save it to disk.
ClientMethod saveAsDSS() [ Language = javascript ]
{
	// Ask for a rename, onPopupAction can deal with the rest.
	var parms = {
		SUPER:'%DeepSee.Report.dataSchemaInterface',
		CHECKUSERS:1
	}

	zenPage._popupData = {};
	var d = zenPage._popupData;
	//if (this.dss.package) d.pkgName=this.dss.package;
	d.pkgName = null; // use default package name
	if (this.dss.objClass) d.clsName=this.dss.objClass;
	if (this.dss.appName) d.appName=this.dss.appName;
	if (this.dss.name) d.rptName=this.dss.name;
	if (this.dss.desc) d.desc=this.dss.desc;

	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls','SaveAsReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Save the report.
ClientMethod saveDSS() [ Language = javascript ]
{
	if (!this._documentActive) {
		alert(zenText("ThereIsNoActiveDocumentToSave"));
		return;
	}
	if (this.dss.sysName == "MyApp."+this.defaultRptName) this.saveAsDSS();
	else {
		var blocker = this.getComponentById("busyTrap");
		blocker.show(this.getEnclosingDiv().offsetWidth/4,this.getEnclosingDiv().offsetHeight/4,true);
		setTimeout("zenPage.reallySaveDSS();",0);
	}
}

/// Really save the report.
ClientMethod reallySaveDSS() [ Language = javascript ]
{
	var tsc = 0;
	try {
		var ms = this.modelServer;
		var name = ms.exportXMLtoFile(null);
		var tsc = ms.ImportXML(name);
		this._documentEdited = false;
	}
	catch (err) {
		if (tsc==0) tsc = err;
	}

	var blocker = this.getComponentById("busyTrap");
	blocker.popAway();
	if (tsc!=1) {
		alert(zenText("SaveFailedWithError")+tsc.split("|").join('\n'));
	}
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	switch(popupName) {
		case 'NewReport':
			if (value) {
				this.dss = this.modelServer.createNewDSS(value);
				var newDSS = this.modelServer.convertRDToDSS("","<report name='unnamedDSS'/>");
				this.dss.dss=newDSS;

				this.setViewMode('none');
				this.setRibbonTitle(value.pkgName+'.'+value.clsName);
				this.setViewMode('data');
				this._documentActive = true;
				this._documentEdited = false;
			}
			break;
			
		case 'SaveAsReport':
			if (value) {
				if (!value.rptName) value.rptName = this.defaultRptName;
				this.dss.package = value.pkgName;
				this.dss.objClass = value.clsName;
				this.dss.appName = value.appName;
				this.dss.sysName = value.pkgName+"."+value.clsName;
				this.dss.name = value.rptName;
				this.dss.desc = value.desc;
				this.dss.dss.n = this.dss.name;
				this.setRibbonTitle(this.dss.sysName);
				this.saveDSS();
			}
			break;

		case 'OpenReport':
				if (value!='') {
					var s = value.toString().split('.');
					if ('cls' == s[s.length-1]) {
						s.length = s.length-1;
						var className = s.join('.');
						if (this.HasDCRSection(className)) {
							var x=confirm(zenText("TheSelectedClassHasAnActiveDataCollectionSchemeAndMayNotHaveBeenGeneratedWithThisToolEditingSuchAClassIsNotRecommendedPressOKToContinueOverwritingThisSectionOrCancelToAbort"));
							if (!x) return;
						}
						var m = zen("modelServer").setReportSource(className,'DSS');
						this.dss = m;
						if (m.dataCollector) this.setDataSource(m.dataCollector);
						this.setRibbonTitle(className);
						this._documentActive = true;
						this._documentEdited = false;
						this.setViewMode('data');
					}
				}
				break;
			
		case 'DataSource':
			if (value != '') {
				// pull extension off of name
				var s = value.toString().split('.');
				if ('cls' == s[s.length-1]) {
					s.length = s.length-1;
					this._documentEdited = true;
					this.setDataSource(s.join('.'));
				}
			}
			break;
			
		case 'switchNamespace':
			var url = zenPage.GetNewURL(value,"_DeepSee.Report.UI.ExtractDSS.cls");
			try {
				if (window.location && window.location.assign) window.location.assign(url);
				else self.document.location =url ;
			}
			catch (e) {
			}
			break;

	}
}

/// End the current session.
ClientMethod logout() [ Language = javascript ]
{
	if (this._documentEdited) {
		var discard = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!discard) return false;
	}
	this._documentEdited = false;
	this.pageModified = false;
	this.invokeSuper('logout',null);
	return false;
}

}
