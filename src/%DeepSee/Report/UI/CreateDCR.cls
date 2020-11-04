/// DeepSee Report DCR Builder page.
/// 
Class %DeepSee.Report.UI.CreateDCR Extends %DeepSee.UI.standardPage [ DependsOn = (%DeepSee.Report.UI.reportModelServer, %DeepSee.Report.UI.dataSourcePanel, %DeepSee.Report.UI.schemaEditPanel, %DeepSee.Report.UI.dataPropertyPanel, %DeepSee.Report.UI.supplementalCodeEditor, %DeepSee.Report.UI.propertyEditor, %DeepSee.Report.UI.whereClauseEditor, %DeepSee.Report.UI.busyPanel), System = 4 ]
{

/// Do NOT auto-switch namespace to whatever is passed in work in the user's current space.
Parameter AUTONS As BOOLEAN = 0;

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

/// Displayed name of this page.
Parameter PAGENAME = "DeepSee Visual Reporting Data Collector Builder";

Parameter JSINCLUDES = "zenCSLM.js,zenESVG.js";

Parameter USERPACKAGES = "%DeepSee.Report.UI";

/// Name of the currently active default namespace
Property nameSpace As %ZEN.Datatype.string(ZENURL = "NAMESPACE");

/// The placeholder name given to reports that have yet to be saved to disk
Property defaultRptName As %ZEN.Datatype.string [ InitialExpression = "UnnamedDCR" ];

/// Name of Report being viewed.
Property reportName As %ZEN.Datatype.string(ZENURL = "CLS");

/// Data source. This is a copy of the value in the report model.
Property dataSource As %ZEN.Datatype.string;

/// Data selection type.  This sets the editor's mode of operation
/// To either select individual data fields (ByField) and create an
/// SQL statement, or to use a predefined class query and skip a lot
/// of low level stuff in favor of some quick defaults (ByQuery).
Property dataSelect As %ZEN.Datatype.string [ InitialExpression = "ByField" ];

/// Local copy of report model object.
/// Index (0-based) of selected data field (if any).
Property selectedDataField As %ZEN.Datatype.integer;

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
	color: #000077;
	font: 12px Arial;
}

.zenLabelDisabled {
	font-size: 10pt;
}

.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}

.comboboxInput {
	border:1px solid #a0a0a0;
	font:12px Arial;
	color:#404040;
}

.comboboxImgButton {
	border: none;	
}

.comboboxDropDown {
	overflow:auto;
	position: absolute;
	margin: 5px;
	top: 0px;
	left: 0px;
	background: #fdfdff;
	border: 1px solid #404040;
	width: 250px;
	height: 250px;
}

.comboboxItem {
	color: #000077;
	cursor: pointer;
	font: 12px Arial;
}

.comboboxItem a:link, .comboboxItem a:active, .comboboxItem a:visited {
	color: #404040;
	font: 12px Arial;
}

.comboboxItemSelected a:link, .comboboxItemSelected a:active, .comboboxItemSelected a:visited {
	color: white;
	font: 12px Arial;
}

.comboboxItemSelected a:hover {
	color: red;
	font: 12px Arial;
}

.comboboxItem a:hover {
	color: red;
	font: 12px Arial;
}

.comboboxItemSelected {
	width: 100%;
	color: white;
	cursor: pointer;
	background: #356b8d;
	background-image: none;
	border: none;
	font: 12px Arial;
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

.dynaTreeNode {
	white-space: nowrap;
	font-size: 10pt;
}

.dynaTreeItem {
	color: rgb(71,72,67);
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
	width: 200px;
	overflow: auto;
	border-bottom: 1px solid gray;
	position:relative;
	top:0px;
	left:0px;
}

#schemaTablePane {
	background: white;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
	position:absolute;
	top:0px;
	left:200px;
	right:210px;
	overflow:auto;
}

#dataPropertyPane {
	background: #ffffff;
	color: #000077;
	width: 210px;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
	position:absolute;
	top:0px;
	right:0px;
	overflow:auto;
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
	color: #000077;
	font: 12px Arial;
}

.zenLabelDisabled {
	font-size: 10pt;
}

.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}

.comboboxInput {
	border:1px solid #a0a0a0;
	font:12px Arial;
	color:#404040;
}

.comboboxImgButton {
	border: none;
	/*background:#e8e7e2;*/
	
}

.comboboxDropDown {
	overflow:auto;
	position: absolute;
	margin: 5px;
	top: 0px;
	left: 0px;
	background: #fdfdff;
	border: 1px solid #404040;
	width: 250px;
	height: 250px;
}

.comboboxItem {
	color: #000077;
	cursor: pointer;
	font: 12px Arial;
}

.comboboxItem a:link, .comboboxItem a:active, .comboboxItem a:visited {
	color: #404040;
	font: 12px Arial;
}

.comboboxItemSelected a:link, .comboboxItemSelected a:active, .comboboxItemSelected a:visited {
	color: white;
	font: 12px Arial;
}

.comboboxItemSelected a:hover {
	color: red;
	font: 12px Arial;
}

.comboboxItem a:hover {
	color: red;
	font: 12px Arial;
}

.comboboxItemSelected {
	width: 100%;
	color: white;
	cursor: pointer;
	background: #356b8d;
	background-image: none;
	border: none;
	font: 12px Arial;
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

.dynaTreeNode {
	white-space: nowrap;
	font-size: 10pt;
}

.dynaTreeItem {
	color: rgb(71,72,67);
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
	width: 200px;
	overflow: auto;
	border-bottom: 1px solid gray;
	position:relative;
	top:0px;
	left:0px;
}

#schemaTablePane {
	background: white;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
	position:absolute;
	top:0px;
	left:200px;
	right:210px;
	overflow:auto;
}

#dataPropertyPane {
	background: #ffffff;
	color: #000077;
	width: 210px;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
	position:absolute;
	top:0px;
	right:0px;
	overflow:auto;
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
<dataSourcePanel layout="none" id="dataSourceTree" width="100%"/>
</group>

<!-- holder for report schema table -->
<group layout="none" id ="schemaTablePane" enclosingClass="cssIsland"  >
<schemaEditPanel id="schemaTable" 
	dragEnabled="true" 
	dropEnabled="true"
	ondrop="return zenPage.schemaTableDropHandler(dragData);"
	/>
</group>

<!-- Holder for datum field properties -->
<group layout="none" id="dataPropertyPane">
<dataPropertyPanel layout="none" id="dataPropertyEditor" width="100%"/>
</group>

</group>
</tab>

<tab id="codeTab" layout="none">
<supplementalCodeEditor id="codeEditPanel" />
</tab>

<tab id="propertyTab" layout="none">
<propertyEditor id="propertyEditPanel" />
</tab>

<tab id ="filterTab" layout="none">
<whereClauseEditor id="whereClauseEditPanel" />
</tab>

<tab id="blankTab" layout="none">
</tab>

</tabGroup>
</pane>
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit $$$Text("Report Data Collector Builder")
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Report Data Collector Builder","%DeepSee")
}

/// Get the product name for the page.
Method %OnGetProductName() As %String
{
	Quit "DeepSee"
}

Method %OnGetJSResources(ByRef pResources As %String) As %Status [ Private ]
{
	Set pResources("NullDataSourceFrom") = $$$Text("NULL data source from")
	Set pResources("NoActiveClass") = $$$Text("( no active class )")
	Set pResources("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation") = $$$Text("The current class has unsaved changes.  Press 'Ok' to discard changes and proceed or 'Cancel' to abort the current operation.")
	Set pResources("TheCurrentClassHasUnsavedChanges") = $$$Text("The current class has unsaved changes.")
	Set pResources("SaveFailedWithError") = $$$Text("Save failed with Error:")
	Set pResources("DirectInclusionOfBinaryDataInXMLIsNotSupportedAtThisTimeBinaryStreamsShouldBeRoutedThroughAStreamServerViaURLAtRunTimeInstead") = $$$Text("Direct inclusion of binary data in XML is not supported at this time . Binary streams should be routed through a stream server via URL at run-time instead.")

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

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = $$$Text("Report Data Collector Builder")

	Set pViewIcons(1) = $LB("data",$$$Text("Show report data definition"),"portal/view_report_data.png")
	Set pViewIcons(2) = $LB("properties",$$$Text("Show report class properties"),"portal/view_data_properties.png")
	Set pViewIcons(3) = $LB("filters",$$$Text("Show data group filters"),"portal/view_data_filters.png")
	Set pViewIcons(4) = $LB("code",$$$Text("Show supplemental methods"),"portal/view_code_bodies.png")

	// commands
	// $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("cmdOpen",$$$Text("Open"),$$$Text("Open an existing report data schema Definition"),"zenPage.openDCR();")
	Set pCommands(2) = $LB("cmdNew",$$$Text("New"),$$$Text("Create a new report data schema Definition"),"zenPage.newDCR();")
	Set pCommands(3) = $LB("cmdSave",$$$Text("Save"),$$$Text("Save this report data schema Definition"),"zenPage.saveDCR();")
	Set pCommands(4) = $LB("cmdSaveAs",$$$Text("Save As"),$$$Text("Save this document under a new name"),"zenPage.saveAsDCR();")
	Quit $$$OK
}

ClientMethod setRibbonTitle(str) [ Language = javascript ]
{
	var td = ZLM.getElementsByClassPrefix("ribbonTitle","toolRibbon");
	td[0].innerHTML="<nobr>"+str+"</nobr>";
//	td[0].style.display="block";
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
	this._modelBackup = null;
	
	this.modelServer = zen("modelServer");
//this.dcr = this.modelServer.createNewDCR(null);
	var tabGroup = zen('tabGroup');
	tabGroup.showTab(6);
	if (this.reportName=="") {
		this.reportName = this.defaultRptName;
		var value = {};
		value.pkgName = "MyApp";
		value.clsName = this.reportName;
		value.appname = " ";
		value.desc = " ";
		value.rptname = " ";

		this.dcr = this.modelServer.createNewDCR(value);
		this.setViewMode('none');
		this.setRibbonTitle(this.dcr.sysName);
		this.setViewMode('data');
		this._documentActive = true;
		this._documentEdited = false;
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

ClientMethod getSchemaTableWidget() [ Language = javascript ]
{
	return(zen('schemaTable'));
}

ClientMethod getDataPropertiesWidget() [ Language = javascript ]
{
	return(zen('dataPropertyEditor'));
}

ClientMethod getReportPropertiesWidget() [ Language = javascript ]
{
	return(zen('propertyEditPanel'));
}

ClientMethod getWhereClauseWidget() [ Language = javascript ]
{
	return(zen('whereClauseEditPanel'));
}

ClientMethod getMethodEditorWidget() [ Language = javascript ]
{
	return(zen('codeEditPanel'));
}

/// Create a temporary backup of the active client-side model for 'undo' purposes
ClientMethod backupCurrentModel() [ Language = javascript ]
{
	this.updateModelFromEditors();
	var ms = this.getModelServer();
	this._modelBackup = ms.backupModel();
}

/// Reset the model to a previous locally-stored state
ClientMethod restoreCurrentBackup() [ Language = javascript ]
{
	if (!this._modelBackup) return;
	var ms = this.getModelServer();
	var m = ms.restoreBackupModel(this._modelBackup);
	this.restoreDCR(m);
}

/// Adjust sizes of components on the page.
ClientMethod adjustSizes(dnr) [ Language = javascript ]
{
	try {
		// get divs for data tab
		var dataSourceTreeDiv = zen('dataSourcePane').getEnclosingDiv();
		var schemaTableDiv = zen('schemaTablePane').getEnclosingDiv();
		var dataPropertyPaneDiv = zen('dataPropertyPane').getEnclosingDiv();

		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 10;

		var editorHgt = hgt;
		var editorWid = dataPropertyPaneDiv.offsetLeft - dataSourceTreeDiv.offsetWidth;
		
		dataSourceTreeDiv.style.height = editorHgt + 'px';

	//	schemaTableDiv.style.width = editorWid + 'px';
		schemaTableDiv.style.height = editorHgt + 'px';

		dataPropertyPaneDiv.style.height = editorHgt + 'px';
		if (!dnr) setTimeout("zenPage.adjustSizes(1);",10);
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

ClientMethod scanForSorters(n, l) [ Language = javascript ]
{
	if (n.t!='gp') return(l);
	if (n.br && n.br.length>0) {
		if (l.length>0) l+=",";
		l+=n.br;
	}
	if (n.s && n.s.length>0) {
		if (l.length>0) l+=",";
		l+=n.s;
	}
	var kl = n.k.length;
	for (var i=0;i<kl;i++) {
		var tl = this.scanForSorters(n.k[i],l);
		if (tl!=l) l=tl;
	}
	return(l);
}

ClientMethod scanForFieldNames(node, a) [ Language = javascript ]
{
	// check each node looking for field names
	// if a name is found, check it for uniqness against the list of
	// fields already pushed into the master array
	// This is complicated by the use of SQL aliases, we need to use these
	// alaises in the generation of an SQL statement, but all the rest of the 
	// plumbing in the suite is built around COS names so it's not sufficient 
	// to check against one, we need to check againt both.
	if (node.t=='gp') {
		var kl = node.k.length;
		for (var i=0;i<kl;i++) {
			this.scanForFieldNames(node.k[i],a);
		}
	}
	else {
		if (node.f && node.f.length>0) {
			// found a field
			var fName = node.f;
			if (node.s && node.s.length>0) fName = node.s; // alias in use
			for (var i=a.length-1;i>=0;i--) {
				var shortName = a[i].split(" ")[0];
				if (shortName==fName) {
					return; // already on the list
				}
			}
			// Add to list
			// First check if there is an implicit join
			if (node.f.indexOf('->')>0) {
				var cName = node.f.split('->').join("_");
				if (fName==cName) a.push(fName);
				else a.push(fName+" AS "+cName);
			}		
			else if (node.f != node.s ) { // now worry about top level aliases
				a.push(fName+" AS "+node.f); // switch alias back to COS
			}
			else a.push(fName);
		}
	}
}

ClientMethod updateBaseSQL() [ Language = javascript ]
{
	var ms = this.modelServer;
	var s = ms.getDCRSQL();
	var t = ms.getDCRDataTree();
	s.src = ms.getReportDataSource();
	var a = [];
	l = this.scanForFieldNames(t,a);
	s.fld = a;
	var l = "";
	l = this.scanForSorters(t,l);
	if (!l || l.length<1) s.ob=null;
	else s.ob = l.split(',');
	ms.setDCRSQL(s);
}

ClientMethod updateOrderByClause() [ Language = javascript ]
{
	var s = this.modelServer.getDCRSQL();
	var t = this.modelServer.getDCRDataTree();
	var l = "";
	l = this.scanForSorters(t,l);
	s.ob = l.split(',');
}

ClientMethod updateModelFromEditors() [ Language = javascript ]
{
	var tabGroup = zen('tabGroup');
	var currentTab = tabGroup.getCurrTabNo();
	switch (currentTab) {
	case 1: // data tab
		var sCtrl = this.getSchemaTableWidget();
		this.modelServer.setDCRDataTree(sCtrl.getModel());
		this.updateBaseSQL();
		break;
	case 2: // code tab
		var cCtrl = this.getMethodEditorWidget();
		this.modelServer.setDCRMethodsSection(cCtrl.getModel());
		break;
	case 3: // properties tab
		var pCtrl = this.getReportPropertiesWidget();
		this.modelServer.setDCRPropertiesSection(pCtrl.getModel());
		break;
	case 4: // filters tab
		var wCtrl = this.getWhereClauseWidget();
		this.modelServer.setDCRSQL(wCtrl.getModel());
		break;
	}
}

/// Do the actual work of updating the view to match the current view mode.
ClientMethod setViewModeHandler(mode) [ Language = javascript ]
{
	if (this.dcr.objClass.length==0) return;
	var tabGroup = zen('tabGroup');
	// First make sure the model has the latest changes from each sub-editor
	if (this._documentActive) this.updateModelFromEditors();
	
	switch(mode) {
	case 'data':
		tabGroup.showTab(1);
		var p = this.getSchemaTableWidget();	
		p.restoreModel(this.modelServer.getDCRDataTree());
		this.adjustSizes();
		break;
	case 'code':
		tabGroup.showTab(2);
		var p = this.getMethodEditorWidget();
		p.restoreModel(this.modelServer.getDCRMethodsSection());
		p.adjustLayout();
		break;
	case 'properties':
		tabGroup.showTab(3);
		var p = this.getReportPropertiesWidget();
		p.restoreModel(this.modelServer.getDCRPropertiesSection());
		break;
	case 'filters':
		tabGroup.showTab(4);
		var p = this.getWhereClauseWidget();
		p.restoreModel(this.modelServer.getDCRSQL());
		break;
	}
}

/// Launch the data source dialog.
ClientMethod changeDataSource() [ Language = javascript ]
{
	var parms = {
		MODE:'persistent'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','DataSource','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

Method GetSQLTableName(classname As %ZEN.Datatype.string) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set cdef = ##class(%Dictionary.CompiledClass).%OpenId(classname)
	If (cdef = $$$NULLOREF) {
		Set retStr = ""
	}
	else {
		Set SchemaName = cdef.SqlSchemaName
		if ($SYSTEM.SQL.IsReservedWord(cdef.SqlSchemaName)) Set SchemaName = """"""_SchemaName_""""""
		Set TableName = cdef.SqlTableName
		if ($SYSTEM.SQL.IsReservedWord(cdef.SqlTableName)) Set TableName = """"""_TableName_""""""
		Set retStr = SchemaName_"."_TableName
	}
	Quit retStr
}

/// Return a JSON string in the form of an array of function names
/// where the named functions are all queries associated with the given class
/// If the class cannot be openned the string ERROR will be returned.  If the
/// class has no defined queries the string "[]" will be returned.
Method GetClassQueries(className As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set rValue = "["
	Set:className'="" cdef=##class(%ClassDefinition).%OpenId(className)
	If (cdef=$$$NULLOREF) QUIT "ERROR"
	Set tmp=$property(cdef,"Queries")
	For i=1:1:tmp.Count() {
		Set item=tmp.GetAt(i)
		if (i>1) Set rValue=rValue_","
		Set rValue = rValue_"'"_item.Name_"'"
	}
	Set rValue = rValue_"]"
	Quit rValue
}

/// Given a class and query method name, return a JSON string for an object
/// with two fields. "data" is an array of objects where each object has a name,
/// type and caption field and represents a returned column from the query.
/// "arg" is an array of objects where each object has a name and type and 
/// represents a parameter of the query function (in order of passing).
/// If the class cannot be read, the query returns the string "$$$NoJoy" 
Method GetQueryInfo(queryClass As %String, queryName As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set rValue = ""	
	Set Status = $ZObjClassMethod(queryClass,queryName_"GetInfo",.colinfo,.paraminfo,.idinfo,.qhandle)
	If $$$ISERR(Status) Quit "$$$NoJoy"
	Set rValue = "{data:["
	For i=1:1:$LL(colinfo) {
		if (i>1) Set rValue = rValue_","
		Set colName = $LI($LI(colinfo,i),1)
		Set colType = $LI($LI(colinfo,i),2)
		Set colCap = $LI($LI(colinfo,i),3)
		Set rValue = rValue_"{name:'"_colName_"',type:"_colType_",caption:'"_colCap_"'}"
	}
	
	Set rValue = rValue_"], arg:["
	For i=1:1:$LL(paraminfo) {
		if (i>1) Set rValue = rValue_","
		Set pName = $LI($LI(paraminfo,i),1)
		Set pType = $LI($LI(paraminfo,i),2)
		Set rValue = rValue_"{name:'"_pName_"',type:"_pType_"}"
	}
	
	Set rValue = rValue_"]}"
	Quit rValue
}

/// Set the dataSource for the report.
ClientMethod setDataSource(cls) [ Language = javascript ]
{
	cls = cls.split('"').join("");
	this.dataSource = cls; // Need to stick this here to keep dynaTree happy
	//TODO Address the issue of subordinate queries
	//FOR NOW, changing the data source reinitialized the schema table
	var sqlSrc = this.GetSQLTableName(cls);
	if (sqlSrc=="") {
		var tCls = cls.split('_').join('.');
		sqlSrc = this.GetSQLTableName(tCls);
		if (sqlSrc=="") {
			sqlSrc=null;
			alert(zenText('NullDataSourceFrom')+' '+cls);
		}
		else {
			this.dataSource = tCls;
		}
	}	
	this.dcr.dataSrc = sqlSrc;
	this.dcr.dataCls = cls;
	// update tree
	var tree = zen('dataSourceTree');
	tree.refreshContents();
	var stw = this.getSchemaTableWidget();
	if (stw) {
		var a = tree.getTopLevelItems();
		var len = a.length;
		for (var i=len-1;i>=0;i--) {
			stw.autopopulateDBItem(a[i].cosN,a[i].sqlN,a[i].cosT);
		}
	}
}

/// Data drop on data property table.
ClientMethod schemaTableDropHandler(dragData) [ Language = javascript ]
{
	if (''!=dragData.value) {
		var sep = zenPage.getComponentById("schemaTable");
		var tree = zen('dataSourceTree');
		var typeInfo = null;
		if (dragData.sourceComponent!=sep) {
			typeInfo = tree.getNodeTypeInfo(dragData.sourceItem);
			if (typeInfo && typeInfo.indexOf("Binary")> -1) {
				alert(zenText("DirectInclusionOfBinaryDataInXMLIsNotSupportedAtThisTimeBinaryStreamsShouldBeRoutedThroughAStreamServerViaURLAtRunTimeInstead"));
				return;
			}
		}	
		var name = dragData.text.split('%').join('');
		sep.addDBItemFromDrag(name,dragData.value,typeInfo);
	}
}

/// reset the active editors
ClientMethod resetDCR() [ Language = javascript ]
{
	this.dataSource = "";
	var tree = zen('dataSourceTree');
	tree.refreshContents();

	this.setViewMode('none');
	this.modelServer = zen("modelServer");
	this.dcr = this.modelServer.createNewDCR(null);

	this.setRibbonTitle(zenText('NoActiveClass'));

	var sCtrl = this.getSchemaTableWidget();
	sCtrl.resetTable();
	
	var pCtrl = this.getDataPropertiesWidget();
	pCtrl.initializeDataFields(null);
	this._documentActive = false;
}

/// Invoke dialog to open a report.
ClientMethod openDCR() [ Language = javascript ]
{
	if (this._documentEdited) {
		var x = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!x) return;
	}
	if (this._documentActive) {
		this.resetDCR();
	}
	var parms = {
		SUPER:'%DeepSee.Report.dataCollector'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','OpenReport','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

/// Invoke dialog to create a new report.
ClientMethod newDCR() [ Language = javascript ]
{
	if (this._documentEdited) {
		var x = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!x) return;
	}

	if (this._documentActive) {
		this.resetDCR();
	}
	
	var parms = {
		SUPER:'%DeepSee.Report.dataCollector',
		CHECKUSERS:1
	}
	
	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls','NewReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Save the report.
ClientMethod saveDCR() [ Language = javascript ]
{
	if (this.dcr.sysName == "MyApp."+this.defaultRptName) this.saveAsDCR();
	else {
		var blocker = this.getComponentById("busyTrap");
		blocker.show(this.getEnclosingDiv().offsetWidth/4,this.getEnclosingDiv().offsetHeight/4,true);
		setTimeout("zenPage.reallySaveDCR();",0);
	}
}

/// Rename this report and save it to disk.
ClientMethod saveAsDCR() [ Language = javascript ]
{
	// Ask for a rename, onPopupAction can deal with the rest.
	var parms = {
		SUPER:'%DeepSee.Report.dataCollector',
		CHECKUSERS:1
	}
	
	zenPage._popupData = {};	
	var d = zenPage._popupData;
	//if (this.dcr.package) d.pkgName=this.dcr.package;
	d.pkgName=null; // use default package name
	if (this.dcr.objClass) d.clsName=this.dcr.objClass;
	if (this.dcr.appName) d.appName=this.dcr.appName;
	if (this.dcr.name) d.rptName=this.dcr.name;
	if (this.dcr.desc) d.desc=this.dcr.desc;

	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls','SaveAsReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Save the report.
ClientMethod reallySaveDCR() [ Language = javascript ]
{
	var tsc = 0;
	try {
		this.updateModelFromEditors();
		var ms = this.modelServer;
	
		var newBody = ms.exportAsXML(0);
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

/// Restore UI settings based on a freshly loaded model
ClientMethod restoreDCR(m) [ Language = javascript ]
{
	this.dcr = m;
	this.setRibbonTitle(m.sysName);
	this.setViewMode('data');
	if (m.dataSrc) {
		if (m.dataCls) this.setDataSource(m.dataCls);
		else this.setDataSource(m.dataSrc);
		var pCtrl = this.getReportPropertiesWidget();
		pCtrl.restoreModel(this.modelServer.getDCRPropertiesSection());
		
		var wCtrl = this.getWhereClauseWidget();
		wCtrl.restoreModel(this.modelServer.getDCRSQL());

		var cCtrl = this.getMethodEditorWidget();
		cCtrl.restoreModel(this.modelServer.getDCRMethodsSection());

		var sCtrl = this.getSchemaTableWidget();
		sCtrl.restoreModel(this.modelServer.getDCRDataTree());
	}
	this._documentActive = false;
	this._documentEdited = false;
}

/// This client event is fired when the a popup page launched from this page fires an action.
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	switch(popupName) {
		case 'NewReport':
			if (value) {
				this.dcr = this.modelServer.createNewDCR(value);
				this.setViewMode('none');
				this.setRibbonTitle(this.dcr.sysName);
				this.setViewMode('data');
				this._documentActive = true;
				this._documentEdited = false;
			}
			break;
		case 'SaveAsReport':
			if (value) {
				this.dcr.package = value.pkgName;
				this.dcr.objClass = value.clsName;
				this.dcr.appName = value.appName;
				this.dcr.sysName = value.pkgName+"."+value.clsName;
				this.dcr.name = value.rptName;
				this.dcr.desc = value.desc;
				this.setRibbonTitle(this.dcr.sysName);
				this.saveDCR();
			}
			break;
		case 'OpenReport':
				if (value!='') {
					var s = value.toString().split('.');
					if ('cls' == s[s.length-1]) {
						s.length = s.length-1;
						var m = zen("modelServer").setReportSource(s.join('.'),'DCR');
						this.restoreDCR(m);
						this._documentActive = true;
						this._documentEdited = false;
					}
				}
				break;
			
		case 'DataSource':
			if (value != '') {
				var stw = this.getSchemaTableWidget();
				stw.clearTable();
				if (this.dcr) this.dcr.sql={src:"",fld:[],w:"",ob:[],p:[]};
				// pull extension off of name
				var s = value.toString().split('.');
				if ('cls' == s[s.length-1]) {
					s.length = s.length-1;
					zenPage.setDataSource(s.join('.'));
				}
			}
			break;

		case 'switchNamespace':
			var url = zenPage.GetNewURL(value,"_DeepSee.Report.UI.CreateDCR.cls");
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
