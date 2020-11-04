/// DeepSee Report DSS Generation From Class Queries.
/// 
Class %DeepSee.Report.UI.QueryBasedDSS Extends %DeepSee.UI.standardPage [ DependsOn = (%DeepSee.Report.UI.reportModelServer, %DeepSee.Report.UI.dataSourcePanel, %DeepSee.Report.UI.dataPickPool, %DeepSee.Report.UI.propertyEditor, %DeepSee.Report.UI.queryItemEditor, %DeepSee.Report.UI.busyPanel), LegacyInstanceContext, System = 4 ]
{

/// Do NOT auto-switch namespace to whatever is passed in work in the user's current space.
Parameter AUTONS As BOOLEAN = 0;

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

/// Displayed name of this page.
Parameter PAGENAME = "DeepSee Visual Reporting DSS Query-Based Generator";

Parameter JSINCLUDES = "zenCSLM.js,zenESVG.js";

Parameter USERPACKAGES = "%DeepSee.Report.UI";

/// Name of the currently active default namespace
Property nameSpace As %ZEN.Datatype.string(ZENURL = "NAMESPACE");

/// The placeholder name given to reports that have yet to be saved to disk
Property defaultRptName As %ZEN.Datatype.string [ InitialExpression = "UnnamedQDSS" ];

/// Name of Report being viewed.
Property reportName As %ZEN.Datatype.string(ZENURL = "CLS");

/// Data source. This is a copy of the value in the report model.
Property dataSource As %ZEN.Datatype.string;

/// This Style block contains page-specific CSS style definitions.
XData Style
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

#sourceQueryName {
	margin: 16px;
	font:bold 14px Arial;
}

#sourceQueryName span.labelText{
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

#groupingOptions {
	display:block;
	width:90%;
	height:100px;
	border:1px solid #356B8D;
	margin-left:5%;
	margin-bottom:16px;
	overflow:auto;
}

#fieldOptions {
	display:block;
	position:absolute;
	top:316px;
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

<label id="sourceQueryName" />

<label value="URL Properties:" enclosingStyle="margin-left:16px;"/>
<group layout="none" id="sourceURLProperties" />

<label value="Grouping and Sorting:" enclosingStyle="margin-left:16px;"/>
<group layout="none" id="groupingOptions" />

<label value="Reported Fields:" enclosingStyle="margin-left:16px;"/>
<group layout="none" id="fieldOptions" />
</group>

<!-- holder for report schema table -->
<group layout="none" id ="schemaPane" enclosingClass="cssIsland"  >
<html id="projectionHeader" enclosingClass="zruHeaderDiv"/>
<dataPickPool id="projection" />
</group>
</group>
</tab>

<tab id="propertyTab" layout="none">
<propertyEditor id="propertyEditPanel" />
</tab>

<tab id="itemTab" layout="none">
<queryItemEditor id="itemEditPanel" />
</tab>

<tab id="blankTab" layout="none">
</tab>

</tabGroup>
</pane>
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit $$$Text("Query Based DSS Extractor")
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Query Based DSS Extractor","%DeepSee")
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
	
	Set pResources("COUNT") = $$$Text("COUNT")
	Set pResources("AVE") = $$$Text("AVE")
	Set pResources("SUM") = $$$Text("SUM")
	Set pResources("MIN") = $$$Text("MIN")
	Set pResources("MAX") = $$$Text("MAX")

	Set pResources("ChangeTheDataSourceForThisReport") = $$$Text("Change the data source for this report")
	Set pResources("NoSourceClassSelected") = $$$Text("(no source class selected)")
	Set pResources("NoActiveClass") = $$$Text("( no active class )")
	Set pResources("ThereIsNoActiveDocumentToSave") = $$$Text("There is no active document to save")
	Set pResources("TheCurrentClassHasUnsavedChangesPressOkToSaveBeforeExitingOrCancelToDiscard") = $$$Text("The current class has unsaved changes.  Press 'Ok' to save before exiting or 'Cancel' to discard")
	Set pResources("TheCurrentClassHasUnsavedChanges") = $$$Text("The current class has unsaved changes.")
	Set pResources("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation") = $$$Text("The current class has unsaved changes.  Press 'Ok' to discard changes and proceed or 'Cancel' to abort the current operation.")
	Set pResources("TheCurrentClassAlreadyHasADSSSectionDefinedPressOkToDiscardOverwriteThisSectionAndProceedOrCancelToAbortTheCurrentOperation") = $$$Text("The current class already has a DSS section defined.  Press 'Ok' to discard overwrite this section and proceed or 'Cancel' to abort the current operation.")
	Set pResources("TheSelectedClassHasAnActiveDataCollectionSchemeAndWasNotGeneratedWithThisToolEditingSuchAClassIsNotRecommended") = $$$Text("The selected class has an active data collection scheme and was not generated with this tool.  Editing such a class is not recommended.")
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
		Set ..nameSpace = $NAMESPACE
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
	Set pRibbonTitle = $$$Text("Query Based DSS Extractor")

	Set pViewIcons(1) = $LB("data",$$$Text("Show report data definition"),"portal/view_report_data.png")
	Set pViewIcons(2) = $LB("properties",$$$Text("Show additional report class properties"),"portal/view_data_properties.png")
	Set pViewIcons(3) = $LB("items",$$$Text("Show additional data set items"),"portal/view_data_items.png")

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
 
   // Get a stream of XML from the XData block contained in this class
   Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xdataID)
   Set tStream=compiledXdata.Data
   If '$IsObject(tStream) Set tSC=%objlasterror Quit
   
   Set m = ""
   //iterate through document, node by node
   Do tStream.Rewind()
   While (tStream.AtEnd = 0) {
	   Set l = tStream.ReadLine()
 	   Set m = m_$CHAR(10)_l
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

		this.dss = this.modelServer.createNewSQLDSS(value);
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

ClientMethod getReportPropertiesWidget() [ Language = javascript ]
{
	return(zen('propertyEditPanel'));
}

ClientMethod getDataItemsWidget() [ Language = javascript ]
{
	return(zen('itemEditPanel'));
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

ClientMethod convertQPARMStoParamModel() [ Language = javascript ]
{
	if (!this._queryObject) return({});
	var q = this._queryObject;
	var qp = q.QPARMS;
	if (!qp) return({});
	var l = qp.length;
	var pa = [];
	for (var i=0;i<l;i++) {
		var o = {};
		var parm = qp[i];
		if (parm.pLocked) o.l = parm.pLocked;
		else o.l = false;
		if (parm.pName) o.n = parm.pName;
		else o.n = "";
		if (parm.pDesc) o.d = parm.pDesc;
		else o.d = "";
		if (parm.pType) o.t = parm.pType;
		else o.t = "%String"
		if (parm.pParam) o.p = parm.pParam;
		else o.p = null;
		if (parm.pDefault) o.i = parm.pDefault;
		else o.i = "";
		if (parm.pURL) o.z = parm.pURL;
		else o.z = o.n.toUpperCase();
		pa.push(o);
	}
	return(pa);
}

ClientMethod exportModelToItemEditor() [ Language = javascript ]
{
		var p = this.getDataItemsWidget();
		var ctx = {};
		var q = this._queryObject;
		var pList = [];
		var qp = q.QPARMS;
		if (qp) {
			var l = qp.length;
			for (var i=0;i<l;i++) pList.push(qp[i].pName);
		}
		ctx.prms = pList;
		var qf = q.FLDS;
		var l = qf.length;
		var fList = [];
		for (var i=0;i<l;i++) fList.push(qf[i].cName);
		ctx.flds = fList;
		var m = q.items;
		if (!m) m=[];
		p.restoreModel(m,ctx);
		this.updateReportProjection();
}

ClientMethod updateModelFromItemEditor() [ Language = javascript ]
{
	var p = this.getDataItemsWidget();
	var q = this._queryObject;
	q.items = p.getModel();
}

ClientMethod updateQPARMSFromEditor() [ Language = javascript ]
{
	if (!this._queryObject) return;
	this._documentEdited = true;
	var ped = this.getReportPropertiesWidget();
	var m = ped.getModel();
 
	var q = this._queryObject;
	var qp = [];
	var l = m.length;
	for (var i=0;i<l;i++) {
		var o = {};
		var parm = m[i];
		if (parm.n && parm.n.length>1) {
			o.pName = parm.n;
			if (parm.l) o.pLocked = parm.l;
			else o.pLocked = false;
			if (parm.d) o.pDesc = parm.d;
			if (parm.t) o.pType = parm.t;
			if (parm.p) o.pParam = parm.p;
			if (parm.i) o.pDefault = parm.i;
			if (parm.z) o.pURL = parm.z;
			else o.pURL = o.pName.toUpperCase();
			qp.push(o);
		}
	}
	q.QPARMS = qp;
	this.updatePropertiesGroup();
	this.updateReportProjection();
}

/// Do the actual work of updating the view to match the current view mode.
ClientMethod setViewModeHandler(mode) [ Language = javascript ]
{
	if (!this._documentActive) mode="none";
	var tabGroup = zen('tabGroup');	
	if (this._propertyEditorActive) {
		this.updateQPARMSFromEditor();
		this._propertyEditorActive=false;
	}
	if (this._dataItemsEditorActive) {
		this.updateModelFromItemEditor();
		this._dataItemsEditorActive=false;
	}
	switch(mode) {
	case 'data':
		tabGroup.showTab(1);
		this.adjustSizes();
		break;
	case 'properties':
		var pArray = this.convertQPARMStoParamModel();
		var p = this.getReportPropertiesWidget();
		p.restoreModel(pArray);
		this._propertyEditorActive = true;
		tabGroup.showTab(2);
		break;
	case 'items':
		this.exportModelToItemEditor();
		this._dataItemsEditorActive = true;
		tabGroup.showTab(3);
		break;
		
	case 'none':
		tabGroup.showTab(4);
		break;
	}
	this.updateReportProjection();
}

/// Launch the data source dialog.
ClientMethod changeDataSource() [ Language = javascript ]
{
//	if (this.dss.dss) {
//		var x = confirm(zenText("TheCurrentClassAlreadyHasADSSSectionDefinedPressOkToDiscardOverwriteThisSectionAndProceedOrCancelToAbortTheCurrentOperation"));
//		if (!x) return;
//	}
	var parms = {
		//MODE:'queries'
		MODE:'querycontext'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','DataSource','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

ClientMethod convertSorterToGrouper(objSrc) [ Language = javascript ]
{
	var fld = this._queryObject.FLDS;
	var len = fld.length;
	var obj = {};
	
	obj.type = "group";
	obj.gFld = objSrc.cName;
	for (var j=len-1;j>=0;j--) {
		var qFld = fld[j];
		if (qFld.cName==objSrc.cName) {
			obj.gName = qFld.xName;
			j= -1;
		}
	}
	obj.gDown = objSrc.cDown;
	return(obj);
}

ClientMethod convertGrouperToSorter(objSrc) [ Language = javascript ]
{
	var obj = {};
	obj.type = "sort";
	obj.cName = objSrc.gFld;
	obj.cDown = objSrc.gDown;
	return(obj);
}

ClientMethod querySortingControl(ctrlIdx) [ Language = javascript ]
{
	var fld = this._queryObject.FLDS;
	var len = fld.length;

	var obj = {};
	var selCtrl = document.getElementById("SortField_"+ctrlIdx);
	if (selCtrl) {
		var f = selCtrl.value;
		if (f=="(none)") {
			obj.type = "none";
		}
		else {
			var descending = false;
			var sortOnly = false;
			var dirCtrl = document.getElementById("SortDesc_"+ctrlIdx);
			if (dirCtrl.style.display=="block") descending = true;	
			var checkCtrl = document.getElementById("SortGroup_"+ctrlIdx);
			if (checkCtrl.checked==false) sortOnly = true;
			if (sortOnly) {
				obj.type = "sort";
				obj.cName = f;
				obj.cDown = 0;
				if (descending) obj.cDown = 1;
			}
			else {
				obj.type = "group";
				obj.gFld = f;
				for (var j=len-1;j>=0;j--) {
					var qFld = fld[j];
					if (qFld.cName==f) {
						obj.gName = qFld.xName;
						j= -1;
					}
				}
				obj.gDown = 0;
				if (descending) obj.gDown = 1;
			}
		}
	}
	return(obj);
}

/// Update the underlying model to reflect the curent state of the group and sort controls
ClientMethod updateGroupings(ctrlIdx, trigger) [ Language = javascript ]
{
	if (!this._queryObject) return;
	this._documentEdited = true;
	var q = this._queryObject;
	var fld = q.FLDS;
	if (!q.GROUPBY || !q.GROUPBY.length) q.GROUPBY = [];
	if (!q.SORTBY || !q.SORTBY.length) q.SORTBY = [];
	var len = fld.length;
	var ctrlLen = len-1;
	if (ctrlIdx == -1) {
		ctrlIdx = 0;
		if (q.GROUPBY.length) ctrlIdx+= q.GROUPBY.length;
		if (q.SORTBY.length) ctrlIdx += q.SORTBY.length;
	}
	var groupBy = [];
	var sortBy = [];

	if (trigger) {
		var gLen = q.GROUPBY.length;
		var sLen = q.SORTBY.length;
		var obj = this.querySortingControl(ctrlIdx);
		var changeToGroups=(ctrlIdx<gLen);
		switch(trigger) {
			case 1: //new field selected
				if (obj.type=="none") { // effectively a delete, bump everything forward
					if (changeToGroups) {
						for (var i=0;i<ctrlIdx;i++) groupBy.push(q.GROUPBY[i]);
						i++;
						while (i<gLen) groupBy.push(q.GROUPBY[i++]);
						q.GROUPBY = groupBy;
					}
					else {
						ctrlIdx -= gLen;
						for (var i=0;i<ctrlIdx;i++) sortBy.push(q.SORTBY[i]);
						i++;
						while (i<sLen) sortBy.push(q.SORTBY[i++]);
						q.SORTBY = sortBy;
					}
				}
				else { // name of a ordering field actually changed - this gets a
						// little ugly, need to make sure the field doesn't show up twice
					var name = obj.cName;
					if (!name) name = obj.gFld;
					if (changeToGroups) { // delta in groups
						for (var i=0;i<ctrlIdx;i++) groupBy.push(q.GROUPBY[i]);
						groupBy.push(obj);
						for (i++;i<gLen;i++) {
							if (q.GROUPBY[i].gFld!=name) groupBy.push(q.GROUPBY[i]);
						}
						for (var i=0;i<sLen;i++) {
							if (q.SORTBY[i].cName!=name) sortBy.push(q.SORTBY[i]);
						}
						q.SORTBY = sortBy;
						q.GROUPBY = groupBy;
					}
					else { // delta in sorts
						ctrlIdx -= gLen;
						for (var i=0;i<ctrlIdx;i++) sortBy.push(q.SORTBY[i]);
						sortBy.push(obj);
						for (i++;i<sLen;i++) {
							if (q.SORTBY[i].cName!=name) sortBy.push(q.SORTBY[i]);
						}
						q.SORTBY = sortBy;
					}
				}
				break;
			case 2: // grouping toggled, preserve order, change breakpoint between groups and sorts
				if (obj.type=="group") { // sort became a group
					var i = 0;
					while (i<sLen && i<=(ctrlIdx-gLen)) q.GROUPBY.push(this.convertSorterToGrouper(q.SORTBY[i++]));
					while (i<sLen) sortBy.push(q.SORTBY[i++]);
					q.SORTBY = sortBy;
				}
				else { // former group demoted to sort
					var i=0;
					while (i<gLen && i<ctrlIdx) groupBy.push(q.GROUPBY[i++]);
					while (i<gLen) sortBy.push(this.convertGrouperToSorter(q.GROUPBY[i++]));
					for (var i=0;i<sLen;i++) sortBy.push(q.SORTBY[i]);
					q.SORTBY = sortBy;
					q.GROUPBY = groupBy;
				}
				break;
			case 3: // ascending toggled doesn't impact who sorts v. who groups
				if (changeToGroups) {
					q.GROUPBY[ctrlIdx] = obj;
				}
				else {
					q.SORTBY[ctrlIdx-gLen] = obj;
				}
				break;
			default:
				ZLM.cerr("WARNING: Unhandled trigger case in updateGroupings()");
				break;
		}
	}
	else {
		var sortOnly = false;
		for (var i=0;i<ctrlLen;i++) {
			var o = this.querySortingControl(i);
			if (o.type!="none") {
				if (o.type=="sort") sortBy.push(o);
				else groupBy.push(o);			
			}
		} 
		q.GROUPBY = groupBy;
		q.SORTBY = sortBy;
	}
	this.updateGroupControlPanel();
	this.updateReportProjection();
}

/// Update the presentation state of the group control panel
/// to reflect the current settings of the underlying model
ClientMethod updateGroupControlPanel() [ Language = javascript ]
{
	if (!this._queryObject || !this._queryObject.FLDS || this._queryObject.FLDS.length<1) return;
	var q = this._queryObject;
	var fld = q.FLDS;
	var fLen = fld.length;
	var ctrlLen = fLen-1;
	var grps = q.GROUPBY;
	if (!grps.length) grps = [];
	var gLen = grps.length;
	var srts = q.SORTBY;
	if (!srts.length) srts = [];
	var sLen = srts.length;
	var nCtrls = gLen+sLen;
	for (var i=0;i<ctrlLen;i++) {
		var grpCtrl = document.getElementById("SortCtrl_"+i);
		var selCtrl = document.getElementById("SortField_"+i);
		var checkCtrl = document.getElementById("SortGroup_"+i);
		var ascCtrl = document.getElementById("SortAsc_"+i);
		var descCtrl = document.getElementById("SortDesc_"+i);	
		if (i>0 && i<nCtrls+1) {
			// update options
			var src = [];
			src.push("<option value='(none)'>(none)</option>");
			for (var j=0;j<fLen;j++) {
				var n = fld[j].cName;
				var keep=true;
				for (var k=0;k<gLen && k<i && keep;k++) {
					if (grps[k].gFld==n) keep=false; // already in use as higher group option
				}
				if (i>gLen) { //check sort options
					for (var k=0;k<sLen && k<i-gLen && keep;k++) {
						if (srts[k]==n) keep=false;
					}
				}
				if (keep) {
					src.push("<option value='"+n+"'>"+n+"</option>");
				}
			}
			selCtrl.innerHTML=src.join("\n");
		}
			
		if (i>nCtrls) {
			grpCtrl.style.display="none";
			checkCtrl.checked = false;
			checkCtrl.value=0;
			selCtrl.value="(none)";
		}
		else {
			if (grpCtrl) grpCtrl.style.display="block";
			if (i<gLen) {
				selCtrl.value=grps[i].gFld;
				checkCtrl.disabled = false;
				checkCtrl.checked = true;
				checkCtrl.value = 1;
				if (grps[i].gDown) {
					ascCtrl.style.display = "none";
					descCtrl.style.display = "block";
				}
				else {
					ascCtrl.style.display = "block";
					descCtrl.style.display = "none";
				}										
			}
			else if (i<nCtrls) {
				if (i==gLen) checkCtrl.disabled = false;
				else checkCtrl.disabled = true;
				var sIdx = i-gLen;
				if (srts[sIdx].charAt) { // legacy code, SORTBY used to be a CSV string
					var obj = {};
					obj.cName = srts[sIdx];
					obj.cDown = 0;
					srts[sIdx] = obj;
				}
				selCtrl.value = srts[sIdx].cName;
				checkCtrl.checked = false;
				checkCtrl.value = 0;
				if (srts[sIdx].cDown) {
					ascCtrl.style.display = "none";
					descCtrl.style.display = "block";
				}
				else {
					ascCtrl.style.display = "block";
					descCtrl.style.display = "none";
				}										
			}
			else {
				checkCtrl.disabled = true;
				checkCtrl.checked = false;
				checkCtrl.value=0;
				selCtrl.value="(none)";
				ascCtrl.style.display = "none";
				descCtrl.style.display = "none";
			}			
		}
	}
}

ClientMethod generateGroupControlPanelSrc(fld) [ Language = javascript ]
{
	var src = [];
	var len = fld.length;
	var ctrlLen = len-1;
	src.push("<group style='width:100%;overflow-y:scroll' >");
	for (var i=0;i<ctrlLen;i++) {
		var style = "style='position:relative;top:0px;left:0px;height:24px;display:none;'";
		if (i==0) style = "style='position:relative;top:0px;left:0px;height:24px;display:block;'";
		src.push("<group id='SortCtrl_"+i+"' "+style+">");
		src.push("<group style='position:absolute;display:block;width:10%;top:4px;left:0px;text-align:center;'>"+(i+1)+".</group>");
		src.push("<select id='SortField_"+i+"' style='width:50%;position:absolute;left:10%;top:2px;' onchange='zenPage.updateGroupings("+i+",1);'>");
		src.push("<option value='(none)'>(none)</option>");
		if (i==0) {
			for (var j=0;j<len;j++) {
				var n = fld[j].cName;
				src.push("<option value='"+n+"'>"+n+"</option>");
			}
		}
		src.push("</select>");
		src.push("<input id='SortGroup_"+i+"' type='checkbox' style='position:absolute;top:2px;right:30%' onchange='zenPage.updateGroupings("+i+",2);' disabled='true'/>");
		src.push("<group style='position:absolute;top:4px;left:71%'>Group</group>");
		src.push("<group id='SortAsc_"+i+"' style='position:absolute;top:0px;left:90%;background-image:url(deepsee/ds_up_24.gif);width:24px;height:24px;display:block;' onclick='zenPage.orderDescending("+i+");'></group>");
		src.push("<group id='SortDesc_"+i+"'  style='position:absolute;top:0px;left:90%;background-image:url(deepsee/ds_down_24.gif);width:24px;height:24px;display:none;' onclick='zenPage.orderAscending("+i+");'></group>");
		src.push("</group>");
	}
	src.push("</group>");
	return(src.join("\n"));
}

ClientMethod orderAscending(idx) [ Language = javascript ]
{
	var up = document.getElementById("SortAsc_"+idx);
	var dn = document.getElementById("SortDesc_"+idx);
	up.style.display = "block";;
	dn.style.display = "none";
	this.updateGroupings(idx,3);
}

ClientMethod orderDescending(idx) [ Language = javascript ]
{
	var up = document.getElementById("SortAsc_"+idx);
	var dn = document.getElementById("SortDesc_"+idx);
	up.style.display = "none";;
	dn.style.display = "block";
	this.updateGroupings(idx,3);
}

ClientMethod updateAggregates(fNum, aggName, ctrl) [ Language = javascript ]
{
	if (!this._queryObject || !this._queryObject.FLDS || this._queryObject.FLDS.length<1) return;
	this._documentEdited = true;
	var q = this._queryObject;
	var fld = q.FLDS;
	var f = fld[fNum];
	if (!f) return;
	var flag = 0;
	if (ctrl.checked) flag = 1;
	f.cAggr[aggName]=flag;
	this.updateReportProjection();
}

ClientMethod updateFieldControls() [ Language = javascript ]
{
	if (!this._queryObject || !this._queryObject.FLDS || this._queryObject.FLDS.length<1) return;
	var q = this._queryObject;
	var fld = q.FLDS;
	var fLen = fld.length;
	for (var i=0;i<fLen;i++) {
		var a = fld[i].cAggr;
		var countCtrl = document.getElementById('fieldCountCtrl_'+i);
		countCtrl.checked = (a.Count==1);
		if (fld[i].isNum) {
			var aveCtrl = document.getElementById('fieldAverageCtrl_'+i);
			aveCtrl.checked = (a.Ave==1);
			var sumCtrl = document.getElementById('fieldSumCtrl_'+i);
			sumCtrl.checked = (a.Sum==1);
			var minCtrl = document.getElementById('fieldMinCtrl_'+i);
			minCtrl.checked = (a.Min==1);
			var maxCtrl = document.getElementById('fieldMaxCtrl_'+i);
			maxCtrl.checked = (a.Max==1);	
		}
	}
}

ClientMethod generateFieldControlPanelSrc(fld) [ Language = javascript ]
{
	var src = [];
	src.push("<div id='fieldCtrlHeader' style='position:relative;top:0px;left:0px;height:20px;display:block;font-weight:bold;background:#ececec;border-bottom:1px solid #356b8d'>");
	src.push("<div style='position:absolute;top:1px;right:220px;width:50px;text-align:center;'>"+zenText("COUNT")+"</div>");
	src.push("<div style='position:absolute;top:1px;right:170px;width:50px;text-align:center;'>"+zenText("AVE")+"</div>");
	src.push("<div style='position:absolute;top:1px;right:120px;width:50px;text-align:center;'>"+zenText("SUM")+"</div>");
	src.push("<div style='position:absolute;top:1px;right:70px;width:50px;text-align:center;'>"+zenText("MIN")+"</div>");
	src.push("<div style='position:absolute;top:1px;right:20px;width:50px;text-align:center;'>"+zenText("MAX")+"</div>");
	src.push("</div>");
	src.push("<div style='position:absolute;top:21px;bottom:0px;overflow-y:scroll;width:100%;'>");
	var len = fld.length;
	for (var i=0;i<len;i++) {
		var f = fld[i];
		var clr = "background:#ffffff;";
		if (i%2==1) clr = "background:#ececec;";
		src.push("<div id='fieldCtrl_"+i+"' style='position:relative;top:0px;left:0px;height:20px;display:block;"+clr+"'>");
		src.push("<div id='fieldName_"+i+"' style='position:absolute;top:0px;left:3px;'>"+f.cName+"</div>");
		if (f.isNum) {
			src.push("<div style='position:absolute;top:1px;right:200px;width:50px;text-align:center;'>");
			src.push("<input id='fieldCountCtrl_"+i+"' type='checkbox' onchange='zenPage.updateAggregates("+i+",\"Count\",this);'/>");
			src.push("</div>");

			
			src.push("<div style='position:absolute;top:1px;right:150px;width:50px;text-align:center;'>");
			src.push("<input id='fieldAverageCtrl_"+i+"' type='checkbox' onchange='zenPage.updateAggregates("+i+",\"Ave\",this);' />");
			src.push("</div>");

			src.push("<div style='position:absolute;top:1px;right:100px;width:50px;text-align:center;'>");
			src.push("<input id='fieldSumCtrl_"+i+"' type='checkbox' onchange='zenPage.updateAggregates("+i+",\"Sum\",this);' />");
			src.push("</div>");

			src.push("<div style='position:absolute;top:1px;right:50px;width:50px;text-align:center;'>");
			src.push("<input id='fieldMinCtrl_"+i+"' type='checkbox' onchange='zenPage.updateAggregates("+i+",\"Min\",this);' />");
			src.push("</div>");

			src.push("<div style='position:absolute;top:1px;right:0px;width:50px;text-align:center;'>");
			src.push("<input id='fieldMaxCtrl_"+i+"' type='checkbox'  onchange='zenPage.updateAggregates("+i+",\"Max\",this);'/>");
			src.push("</div>");
		}
		else {
			src.push("<div style='position:absolute;top:1px;right:200px;width:50px;text-align:center;'>");
			src.push("<input id='fieldCountCtrl_"+i+"' type='checkbox' onchange='zenPage.updateAggregates("+i+",\"Count\",this);'/>");
			src.push("</div>");
		}
		src.push("</div>");
	}
	src.push("</div>");
	return(src.join("\n"));
}

ClientMethod updateReportProjection() [ Language = javascript ]
{
	if (!this._queryObject || !this._queryObject.FLDS || this._queryObject.FLDS.length<1) return;

	var rd = this.generateReportDefinition(this._queryObject);
	var newDSS = this.modelServer.convertRDToDSS(this.dss.sysName,rd);

	var disp = zen('projection');
	disp.setTitle(newDSS.nodeName);
	disp.setDataTreeFromDSS(newDSS,true);

	// Make sure the underlying master model is up to date
	this.dss.dss = newDSS;
	this.dss.reportDef = rd;
	this.dss.queryInfo = this._queryObject;
}

ClientMethod updatePropertiesGroup() [ Language = javascript ]
{
	if (!this._queryObject || !this._queryObject.FLDS || this._queryObject.FLDS.length<1) return;
	var sUP = document.getElementById("sourceURLProperties");	
	var p = this._queryObject.QPARMS;
	if (p && p.length) {
		var pStr = [];
		for (var i=0;i<p.length;i++) pStr.push(p[i].pURL);
		sUP.innerHTML='<pre>'+pStr.join('\n')+'</pre>';
	}
}

/// Set the dataSource for the report.
ClientMethod setDataSource(qObj) [ Language = javascript ]
{
	if (!qObj || !qObj.FLDS || (qObj.FLDS && qObj.FLDS.length<1)) return;
	this._queryObject = qObj;
	
	var sQN = this.getComponentById("sourceQueryName");
	if (qObj.VIEW_NAME) sQN.setValue(qObj.SCHEMA+"."+qObj.VIEW_NAME);
	else sQN.setValue(qObj.SCHEMA+"."+qObj.PROC_NAME);
	

/*
FLDS value [object ARRAY]
	Each element in this array is an object of the form:
	cName value (column name taken from ResultSet_Columns
	cType value (base data type)
	xName value (xml name, cName without dots)
	isNum value (true/false, based on cType)
	cAggr value [object Object]
		The properties of this object are:
		Count value (1/0)
		Ave value (1/0)
		Sum value (1/0)
		Min value (1/0)
		Max value (1/0)
GROUPBY value [object ARRAY]
	Each element in this array is an object of the form:
	gFld value (grouping field)
	gName value (xName of gFld)
	gDown value (1/0 flag to mark descending order)
SORTBY value [object ARRAY]
	Each element in the array is an obect of the form:
	cName from the FLDS array
	cDown value (1/0 - flag to mark descending order)
*/
	var fld = qObj.FLDS;
	var fldLen = fld.length;
	
	var sGO = document.getElementById("groupingOptions");
	sGO.innerHTML = this.generateGroupControlPanelSrc(fld);
	
	var sFO = document.getElementById("fieldOptions");
	sFO.innerHTML = this.generateFieldControlPanelSrc(fld);

	this.updatePropertiesGroup();	
	this.updateGroupControlPanel();
	this.updateFieldControls();	
	this.updateReportProjection();
}

/// reset the active editors
ClientMethod resetDSS() [ Language = javascript ]
{
	this.dataSource = "";
	var disp = zen('projection');
	disp.clear();

	var sCN = this.getComponentById("sourceQueryName");
	sCN.setValue(zenText("NoSourceSelected"));
	
	var sUP = document.getElementById("sourceURLProperties");
	sUP.innerHTML = "";
	
	var sGO = document.getElementById("groupingOptions");
	sGO.innerHTML = "";

	var sFO = document.getElementById("fieldOptions");
	sFO.innerHTML = "";
	
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
	
	var parms = {
		SUPER:'%DeepSee.Report.sqlQueryDSS'
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

	var parms = {
		SUPER:'%DeepSee.Report.sqlQueryDSS',
		CHECKUSERS:1
	}

	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls','NewReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Rename this report and save it to disk.
ClientMethod saveAsDSS() [ Language = javascript ]
{
	// Ask for a rename, onPopupAction can deal with the rest.
	var parms = {
		SUPER:'%DeepSee.Report.sqlQueryDSS',
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
		return;
	}
	if (this.dss.sysName == "MyApp."+this.defaultRptName) this.saveAsDSS();
	else {
		var blocker = this.getComponentById("busyTrap");
		blocker.show(this.getEnclosingDiv().offsetWidth/4,this.getEnclosingDiv().offsetHeight/4,true);
		setTimeout("zenPage.reallySaveDSS();",0);
	}
}

ClientMethod reallySaveDSS() [ Language = javascript ]
{
	var tsc = 0;
	try {
		if (this._dataItemsEditorActive) {
			this.updateModelFromItemEditor();
		}
		if (this._propertyEditorActive) {
			this.updateQPARMSFromEditor();
		}

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
				this.resetDSS();
				this.dss = this.modelServer.createNewSQLDSS(value);
				var newDSS = this.modelServer.convertRDToDSS("","<report name='unnamedDSS'/>");
				this.dss.dss=newDSS;

				this.setViewMode('none');
				this._documentActive = true;
				this.setRibbonTitle(value.pkgName+'.'+value.clsName);
				this.setViewMode('data');
				this._documentEdited = true;
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
				this.dss.dss.dataCollector = this.dss.sysName;
				this.dss.dss.n = this.dss.name;
				this.setRibbonTitle(this.dss.sysName);
				this.saveDSS();
			}
			break;
		case 'OpenReport':
				if (value!='') {
					this.resetDSS();
					var s = value.toString().split('.');
					if ('cls' == s[s.length-1]) {
						s.length = s.length-1;
						var className = s.join('.');
						if (this.HasDCRSection(className)) {
							alert(zenText("TheSelectedClassHasAnActiveDataCollectionSchemeAndWasNotGeneratedWithThisToolEditingSuchAClassIsNotRecommended"));
							return;
						}
						var m = zen("modelServer").setReportSource(className,'SQLDSS');
						this.dss = m;
						this.dss.queryInfo=zen("modelServer").getQueryInfo(className);
						var h = this.dss.queryInfo.headerInfo;
						if (h) {
							for (p in h) this.dss[p] = h[p];
							delete this.dss.queryInfo.headerInfo;
						}
						this._queryObject=this.dss.queryInfo;
						this.setDataSource(this.dss.queryInfo);
								
						this.setViewMode('none');
						this.setRibbonTitle(className);
						this._documentActive = true;
						this._documentEdited = false;
						this.setViewMode('data');
						
						this.updateGroupControlPanel();
						this.updateFieldControls();	
						this.updateReportProjection();

					}
				}
				break;
			
		case 'DataSource':
			if (value != '') {
				var sp = value.split(".");
				var info = this.QueryProcInfo(sp[0],sp[1]);
				var infoObj = ZLM.jsonParse(info);
				this.setRDefDefaults(infoObj);
				this.setDataSource(infoObj);
				this._documentEdited = true;		
				return;
			}
			break;
			
		case 'switchNamespace':
			var url = zenPage.GetNewURL(value,"_DeepSee.Report.UI.QueryBasedDSS.cls");
			try {
				if (window.location && window.location.assign) window.location.assign(url);
				else self.document.location =url ;
			}
			catch (e) {
			}
			break;


	}
}

/// Given a column type definition return a flag if the associated data is eligible for
/// numeric agregation
ClientMethod isNumeric(s) [ Language = javascript ]
{
	if (s=="DOUBLE") return(true);
	if (s=="INTEGER") return(true);
	if (s=="NUMERIC") return(true);
	if (s=="CURRENCY") return(true);
	if (s=="LONG") return(true);
	return(false);
}

/*
The abstract model consists of an object with the following properties:
CLASS_NAME value Sample.Employee
PROCEDURE_TYPE value query
METHOD_OR_QUERY_NAME value ByName
NUMBER_INPUT_PARAMS value 1
NUMBER_INPUT_OUTPUT_PARAMS value 0
NUMBER_OUTPUT_PARAMS value 0
RETURN_VALUE value 
RETURNS_RESULTSET value Yes
name NUMBER_OF_COLUMNS value 4
INPUT_PARAMETERS value name VARCHAR
INPUT_OUTPUT_PARAMETERS value 
OUTPUT_PARAMETERS value 
RESULTSET_COLUMNS value ID INTEGER, Name VARCHAR, DOB DATE, SSN VARCHAR
FLDS value [object ARRAY]
	Each element in this array is an object of the form:
	cName value (column name taken from ResultSet_Columns
	cType value (base data type)
	xName value (xml name, cName without dots)
	isNum value (true/false, based on cType)
	cAggr value [object Object]
		The properties of this object are:
		Count value (1/0)
		Ave value (1/0)
		Sum value (1/0)
		Min value (1/0)
		Max value (1/0)
QPARMS value [object ARRAY]
	Each element in this array is an object of the form:
	pName value name
	pType value (base data type)
	pURL vale (upper case of pName)
SCHEMA value Sample
PROC_NAME value Employee_ByName
GROUPBY value [object ARRAY]
	Each element in this array is an object of the form:
	gFld value (grouping field)
	gName value (xName of gFld)
	gDown value (1/0 - flag to indicate descending order on sort)
SORTBY value [object ARRAY]
	Each element in the array is an object of the form:
	cName from the FLDS array
	cDown value (1/0 - flag to indicate descending order on sort)
	
Many of these values are teased out from the base query in QueryProcInfo() the rest are 
initialized in setRDefDefaults and may be changed by the user via the graphical editor.

The ordering of GROUPBY and SORTBY matter.  Groups are breaking sorts and must all
appear before any sort only options.  Ultimately the group list and the sort list are
concatenated to form the orderby clause.
*/
ClientMethod setRDefDefaults(qObj) [ Language = javascript ]
{

	var p = qObj.QPARMS;
	if (p) {
		var pl = p.length;
		for (var i=0;i<pl;i++) {
			p[i].pURL = p[i].pName.toUpperCase();
		}
	}
	qObj.GROUPBY = [];
	qObj.SORTBY = [];
	
	var f = [];
	qObj.FLDS = f;
	var fld = qObj.RESULTSET_COLUMNS.split(", ");
	var fldLen = fld.length;
	for (var i=0;i<fldLen;i++) {
		var o={};
		var c = fld[i].split(" ");
		o.cName = c[0];
		o.cType = c[1];
		o.xName = c[0].split(".").join("");
		o.isNum = this.isNumeric(c[1]);
		if (c[0]=='ID') {
			o.cAggr={Count:1,Ave:0,Sum:0,Min:0,Max:0};
			o.isNum=false;
		}
		else if (o.isNum) o.cAggr={Count:0,Ave:1,Sum:1,Min:1,Max:1};
		else o.cAggr={Count:0,Ave:0,Sum:0,Min:0,Max:0};
		f.push(o);
	}
}

ClientMethod generateReportDefinition(qObj) [ Language = javascript ]
{
	var queryClass = qObj.CLASS_NAME;
	var queryName = qObj.METHOD_OR_QUERY_NAME;
	var rptName = qObj.METHOD_OR_QUERY_NAME;
	if (!rptName) rptName = "viewData";
	
	//COMPUTE orderby ATTRIBUTE
	var orderBy = "";
	var gb = qObj.GROUPBY;
	var gbLen = 0;
	if (gb && gb.length) {
		gbLen = gb.length;
		for(var i=0;i<gbLen;i++) {
			if (i>0) orderBy += ",";
			orderBy+=gb[i].gFld;
			if (gb[i].gDown) orderBy+=":DESC";
		}
	}
	var sb = qObj.SORTBY;
	if (sb && sb.length) {
		var sbLen = sb.length;
		for (var i=0;i<sbLen;i++) {
			if (orderBy.length>0 || i>0) orderBy+= ",";
			if (sb[i].charAt) { // legacy code, SORTBY used to be a CSV list
				var obj = {};
				obj.cName = sb[i];
				obj.cDown = 0;
				sb[i] = obj;
			}
			orderBy += sb[i].cName;
			if (sb[i].cDown) orderBy+= ":DESC";
		}
	}
	if (orderBy.length>0) orderBy = " orderby='"+orderBy+"'";
	
	var src = [];
	src.push("<report xmlns='http://www.intersystems.com/zen/report/definition' runonce='true' name='"+rptName+"'>");
	if (qObj.QPARMS && qObj.QPARMS.length) {
		for (var i=0;i<qObj.QPARMS.length;i++) {
			var p = qObj.QPARMS[i];
			if (p.pLocked) src.push("\t<parameter expression='.."+p.pName+"'/>");
		}
	}
	src.push("\t<attribute name='runTime' expression='$ZDT($H,3)' />");
	src.push("\t<attribute name='runBy' expression='$UserName' />");
	//Push all collected parameters here...
	if (qObj.QPARMS && qObj.QPARMS.length) {
		for (var i=0;i<qObj.QPARMS.length;i++) {
			var p = qObj.QPARMS[i];
			src.push("\t<attribute name='"+p.pName+"' expression='.."+p.pName+"'/>");
		}
	}
	// If we have any extra query items that don't have field dependencies
	// push them here as well
	if (qObj.items && qObj.items.length) {
		for (var i=0;i<qObj.items.length;i++) {
			var qi = qObj.items[i];
			if (!(qi.fd) || !(qi.fd.length) || qi.fd.length==0) {
				src.push("\t<element name='"+qi.n+"' expression='"+qi.x+"'/>");
				qi.done=true;
			}
		}	
	}
	if (qObj.PROCEDURE_TYPE=="VIEW") {
		src.push("\t<group name='Results' sql='SELECT *,%vid As ID FROM "+qObj.SCHEMA+"."+qObj.VIEW_NAME+"' "+orderBy+" >");
	}
	else {
		src.push("\t<group name='Results' queryClass='"+queryClass+"' queryName='"+queryName+"' "+orderBy+" >");
	}
	if (qObj.QPARMS && qObj.QPARMS.length) {
		for (var i=0;i<qObj.QPARMS.length;i++) {
			var p = qObj.QPARMS[i];
			if (p.pLocked) src.push("\t\t<parameter expression='.."+p.pName+"'/>");
		}
	}

	var kbf = []; // list of known breaking fields for figuring out where to put user items
	
	var fld = qObj.FLDS;
	var fldLen = fld.length;
	///REPORT WIDE AGREGATES
	for (var i=0;i<fldLen;i++) {
		var f = fld[i];
		if (f.cAggr.Count) {
			if (f.cName=="ID") src.push("<aggregate name='TotalCount' type='CUSTOM' field='ID' class='%ZEN.Report.Aggregate.CountDistinct'/>");
			else src.push("<aggregate name='CountAll"+f.xName+"' type='COUNT' field='"+f.cName+"' />");
		}
		if (f.cAggr.Ave) src.push("<aggregate name='AveAll"+f.xName+"' type='AVG' field='"+f.cName+"' />");
		if (f.cAggr.Max) src.push("<aggregate name='MaxAll"+f.xName+"' type='MAX' field='"+f.cName+"' />");
		if (f.cAggr.Min) src.push("<aggregate name='MinAll"+f.xName+"' type='MIN' field='"+f.cName+"' />");
		if (f.cAggr.Sum) src.push("<aggregate name='SumAll"+f.xName+"' type='SUM' field='"+f.cName+"' />");
	}
 	for (var i=0;i<gbLen;i++) {
	 	var g = gb[i];
		///OPEN BREAKING GROUPS
		kbf.push(g.gFld);
		src.push("<group name='DataBy"+g.gName+"' breakOnField='"+g.gFld+"' >");
		for (var j=0;j<fldLen;j++) {
			var f=fld[j];
			if (f.cName==g.gFld) {
				src.push("<attribute name='"+f.xName+"' field='"+f.cName+"'/>");
			}
		}
		///GROUP WIDE AGGREGATES
		for (var j=0;j<fldLen;j++) {
			var f = fld[j];
			if (f.cAggr.Count) {
				if (f.cName=="ID") src.push("<aggregate name='GroupCount' type='CUSTOM' field='ID' class='%ZEN.Report.Aggregate.CountDistinct'/>");
				else src.push("<aggregate name='Count"+f.xName+"By"+g.gName+"' type='COUNT' field='"+f.cName+"' />");
			}
			if (f.cAggr.Ave) src.push("<aggregate name='Ave"+f.xName+"By"+g.gName+"' type='AVG' field='"+f.cName+"' />");
			if (f.cAggr.Max) src.push("<aggregate name='Max"+f.xName+"By"+g.gName+"' type='MAX' field='"+f.cName+"' />");
			if (f.cAggr.Min) src.push("<aggregate name='Min"+f.xName+"By"+g.gName+"' type='MIN' field='"+f.cName+"' />");
			if (f.cAggr.Sum)	src.push("<aggregate name='Sum"+f.xName+"By"+g.gName+"' type='SUM' field='"+f.cName+"' />");
		}
		// Check to see if we can insert user items here
		if (qObj.items && qObj.items.length) {
			for (var i=0;i<qObj.items.length;i++) {
				if (!qi.done) {
					var fdLen = qi.fd.length;
					var go=true;
					var j=0;
					while(j<fdLen && go) {
						go = false;
						for (var k=0;k<kbf.length;k++) {
							if (qi.fd[j]==kbf[k]) go=true;
						}
						j++;
					} 
					if (go) {
						if (fdLen>1) {
							src.push("<attribute name='"+qi.n+"' fields='"+qi.fd.join(",")+"' expression='"+qi.x+"'/>");
						}
						else {
							src.push("<attribute name='"+qi.n+"' field='"+qi.fd.join(",")+"' expression='"+qi.x+"'/>");
						}
						qi.done = true;
					}
				}
			}
		}
	}

	src.push("<group name='Detail' >");
	for (var i=0;i<fldLen;i++) {
		var f = fld[i];
		var keep = 1;
		var name = f.cName;
		for (var j=0;j<gbLen;j++) {
			if (gb[j].gFld==name) {
				keep=0;
				j=gbLen;
			}
		}
		if (keep==1) {
			var tagName = "element";
			if (name=="ID") tagName="attribute";
			src.push("<"+tagName+" name='"+f.xName+"' field='"+name+"'/>");
		}
	}
	// Finally put in any user fields we couldn't process prior to now
	if (qObj.items && qObj.items.length) {
		for (var i=0;i<qObj.items.length;i++) {
			var qi = qObj.items[i];
			if (!qi.done) {
				if (qi.fd.length>1) {
					src.push("<element name='"+qi.n+"' fields='"+qi.fd.join(",")+"' expression='"+qi.x+"'/>");
				}
				else {
					src.push("<element name='"+qi.n+"' field='"+qi.fd.join(",")+"' expression='"+qi.x+"'/>");
				}
			}
			delete qi.done;
		}
	}
	src.push("</group>"); // Row details
	///CLOSE BREAKING GROUPS
	for (var i=0;i<gbLen;i++) {
		src.push("</group>");
	}

	src.push("\t</group>"); // Results group
	src.push("</report>");
	return(src.join("\n"));
}

/// Return the essential details about an SQL stored procedure as a JSON string
ClassMethod QueryProcInfo(schema As %String, proc As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	// Get meta-information for SQL statement
	Try {
		Set rset = ##class(%ResultSet).%New("%SQL.Manager.Catalog:ProcedureInfo")
	    Set columns = rset.GetColumnCount()
	 	Set sc = rset.Execute(schema,proc)
		Set json = "{"
	    // Now fetch the results
  		While (rset.Next()) {
			For col = 1:1:columns {
   	    	 	Set colname = rset.GetColumnName(col)
   	     		Set coldata = rset.GetData(col)
   	     		If (colname = "CLASS_NAME") Set qclass = coldata
        		If (colname = "METHOD_OR_QUERY_NAME") Set qname = coldata
				If (colname '= "DESCRIPTION") {
					Set json = json_colname_":'"_coldata_"', "
 				}
  			}
 			Do rset.Close()
		}
		Set sc=$ZObjClassMethod(qclass,qname_"GetInfo",.colinfo,.paraminfo,.idinfo,.qHandle)
		If ($ListLength(paraminfo)>0) {
			Set json = json_"QPARMS:["
			For i=1:1:$ListLength(paraminfo) {
				Set pName = $List($List(paraminfo,i),1)
				Set pType = ##class(%ZEN.Report.reportGenerator).decodetype($List($List(paraminfo,i),2))
				If (i>1) Set json=json_","
				Set json = json_"{pName:'"_pName_"', pType:'"_pType_"' pLocked:'true'}"
			}
			Set json = json_"], "
		}			
	    Set json = json_"SCHEMA:'"_schema_"', PROC_NAME:'"_proc_"' }"	
	}
	Catch (ex) {
		Set json = ..QueryViewInfo(schema,proc)
	}
	Quit json
}

/// Return the essential details about an SQL view as a JSON string
ClassMethod QueryViewInfo(schema As %String, view As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Try {
		Set rset = ##class(%ResultSet).%New("%SQL.Manager.Catalog:ViewInfo2")
	    Set columns = rset.GetColumnCount()
	 	Set sc = rset.Execute(schema,view)
		Set vClass = ""
		Set json = "{"
  		While (rset.Next()) {
			For col = 1:1:columns {
				Set colName = rset.GetColumnName(col)
        		Set colData = rset.GetData(col)
        		If (colName = "CLASSNAME") Set vClass = colData
  			}
 			Do rset.Close()
		}
		
		Set json = json_"CLASS_NAME:'"_vClass_"', "
		Set json = json_"PROCEDURE_TYPE:'VIEW', "
		Set json = json_"NUMBER_INPUT_PARAMS:0, "
		Set json = json_"NUMBER_INPUT_OUTPUT_PARAMS:0, "
		Set json = json_"NUMBER_OUTPUT_PARAMS:0, "
 
		Set rset = ##class(%ResultSet).%New("%SQL.Manager.Catalog:ViewFields")
	    Set columns = rset.GetColumnCount()
	 	Set sc = rset.Execute(schema,view)
	    // Now fetch the results
	    Set numCols = 1
	    Set rsCols = "ID OID"
  		While (rset.Next()) {
	  		Set fName = ""
	  		Set fData = ""
			For col = 1:1:columns {
				Set colName = rset.GetColumnName(col)
        		Set colData = rset.GetData(col)
        		If (colName = "FIELD_NAME") Set fName = colData
        		If (colName = "DATATYPE") Set fType = colData
  			}
  			if (fName '= "" && fType '= "") {
	  			Set numCols = numCols+1
	  			Set rsCols = rsCols_", "
	  			Set rsCols = rsCols_fName_" "_..SimplifyDataType(fType)
  			}
		}
 		Do rset.Close()
		Set json = json_"RESULTSET_COLUMNS:'"_rsCols_"', "
		Set json = json_"NUMBER_OF_COLUMNS:"_numCols_", "
		Set json = json_"QPARMS:[], "					
	    Set json = json_"SCHEMA:'"_schema_"', VIEW_NAME:'"_view_"' }"
	}
	Catch (ex) {
		Set json = "{error:true}"
	}
	Quit json
}

ClassMethod SimplifyDataType(formalType As %String) As %String
{
	Set retType = "BINARY"
	If ($Find(formalType,"String")>0) {
		Set retType = "VARCHAR"
	}
	ElseIf ($Find(formalType,"Integer")>0) {
		Set retType = "INTEGER"
	}
	ElseIf ($Find(formalType,"Boolean")>0) {
		Set retType = "BOOLEAN"
	}
	ElseIf ($Find(formalType,"Currency")>0) {
		Set retType = "CURRENCY"
	}
	ElseIf ($Find(formalType,"FilemanDate")>0) {
		Set retType = "FDATE"
	}
	ElseIf ($Find(formalType,"Date")>0) {
		Set retType = "DATE"
	}
	ElseIf ($Find(formalType,"Double")>0) {
		Set retType = "DOUBLE"
	}
	ElseIf ($Find(formalType,"ObjectHandle")>0) {
		Set retType = "HANDLE"
	}
	ElseIf ($Find(formalType,"List")>0) {
		Set retType = "LIST"
	}
	ElseIf ($Find(formalType,"Long")>0) {
		Set retType = "LONG"
	}
	ElseIf ($Find(formalType,"ObjectIdentity")>0) {
		Set retType = "OID"
	}
	ElseIf ($Find(formalType,"Numeric")>0) {
		Set retType = "NUMERIC"
	}
	ElseIf ($Find(formalType,"Status")>0) {
		Set retType = "STATUS"
	}
	ElseIf ($Find(formalType,"FilemanTimeStamp")>0) {
		Set retType = "FTIMESTAMP"
	}
	ElseIf ($Find(formalType,"TimeStamp")>0) {
		Set retType = "TIMESTAMP"
	}
	ElseIf ($Find(formalType,"Time")>0) {
		Set retType = "TIME"
	}
	ElseIf ($Find(formalType,"GlobalCharacterStream")>0) {
		Set retType = "CHARACTERSTREAM"
	}
	ElseIf ($Find(formalType,"GlobalBinaryStream")>0) {
		Set retType = "BINARYSTREAM"
	}
	Quit retType
}

ClassMethod doit()
{
 Set rset = ##class(%ResultSet).%New("%Library.SQLCatalog:SQLProcedures")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute()

 // Now fetch the results
 While (rset.Next()) {
    Set printit = 0
    // loop over columns
    For col = 1:1:columns {
	 	Set colName = rset.GetColumnName(col)
	    Set colVal = rset.GetData(col)
	    If (colName = "PROCEDURE_NAME") {
			Set rset2 = ##class(%ResultSet).%New("%SQL.Manager.Catalog:ProcedureInfo")
			Set col2 = rset2.GetColumnCount()
			Set pivot = $Find(colVal,".")-1
			Set schema = $Extract(colVal,1,pivot-1)
			Set proc = $Extract(colVal,pivot+1,$Length(colVal))
			Set sc = rset2.Execute(schema,proc)
			While (rset2.Next()) {
				For cidx = 1:1:col2 {
					Set c2Name = rset2.GetColumnName(cidx)
					Set c2Val = rset2.GetData(cidx)
					If (c2Name = "RETURNS_RESULTSET") {
						If (c2Val = "Yes") {
						Write "------------------------",!
						Set printit = 1
						}
					}
				}
			}
			Do rset2.Close()
		}
 		If (printit = 1) {
	 		Write colName,": ",colVal,!
 		}
 	}
 }
 Do rset.Close()
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
