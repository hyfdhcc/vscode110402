/// DeepSee Line Item Detail Report Builder page.
/// 
Class %DeepSee.Report.UI.BuildLIDR Extends %DeepSee.UI.standardPage [ DependsOn = (%DeepSee.Report.UI.editLIDR, %DeepSee.Report.UI.reportPreviewer, %DeepSee.Report.UI.reportModelServer, %DeepSee.Report.UI.popGroup, %DeepSee.Report.UI.busyPanel), LegacyInstanceContext, System = 4 ]
{

/// Do NOT auto-switch namespace to whatever is passed in work in the user's current space.
Parameter AUTONS As BOOLEAN = 0;

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

/// Displayed name of this page.
Parameter PAGENAME = "DeepSee Visual Reporting Line Item Report Builder";

/// The placeholder name given to reports that have yet to be saved to disk
Property defaultRptName As %ZEN.Datatype.string [ InitialExpression = "UnnamedLIDR" ];

/// Name of the currently active default namespace
Property nameSpace As %ZEN.Datatype.string(ZENURL = "NAMESPACE");

/// Name of Report being viewed.
Property reportName As %ZEN.Datatype.string(ZENURL = "RPT");

/// Data source. This is a copy of the value in the report model.
Property dataSource As %ZEN.Datatype.string;

/// Local copy of report model object.
/// Index (0-based) of selected data field (if any).
Property selectedDataField As %ZEN.Datatype.integer;

/// This Style block contains page-specific CSS 3 style definitions.
XData CSS3Style
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
	color: rgb(67,67,67);
	font-size: 10pt;
}
.zenLabelDisabled {
	font-size: 10pt;
}

.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}

.dynaTreeNode {
	white-space: nowrap;
	font-size: 10pt;
}

.dynaTreeItem {
	color: rgb(71,72,67);
}

.cssIsland {
	position:relative;
	top:0px;
	left:0px;
}

.ribbonTitle {
	background:#356b8d;
	color:#ffffff;
	padding-right:10px;
	width:100%;
	height:100%;
}

.detailLabel {
	font-weight: bold;
	color: rgb(71,72,67);
	font-size: 10pt;
}

.listBoxItemSelected {
	color: black;
	background: #E0E0E0;
	font-weight: bold;
}

/* @doc="Selected item with focus within listBox." */
.listBoxItemFocus {
	font-weight: bold;
	color: white;
	background: rgb(53,107,141);
	background-image: none;
	background-repeat: no-repeat;
}

/* tab 1 */
#dataSourceHeader {
	border-bottom: 1px solid #C0C0C0;
}

/* div inside header */
.DataHeaderDiv {
	padding: 5px;
	height: 12pt;
	color: #404040;
	background: #e8e7e2;
}

#dataSourceTree {
	background: white;
	width: 225px;
	overflow: auto;
	border-bottom: 1px solid gray;
}

#schemaTableHeader {
	border-bottom: 1px solid #C0C0C0;
}

#schemaTablePane {
	background: white;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
}

#dataPropertyPane {
	background: white;
	width: 250px;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
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

.hdrLink {
	font-size: 10pt;
	font-weight: normal;
	color: #5ba4dc;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.hdrLinkDisabled {
	font-size: 10pt;
	font-weight: normal;
	color: gray;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.hdrLink:hover {
	color: #98923a;
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
	color: rgb(67,67,67);
	font-size: 10pt;
}
.zenLabelDisabled {
	font-size: 10pt;
}

.zenHint {
	color: rgb(67,67,67);
	font-size: 8pt;
}

.dynaTreeNode {
	white-space: nowrap;
	font-size: 10pt;
}

.dynaTreeItem {
	color: rgb(71,72,67);
}

.cssIsland {
	position:relative;
	top:0px;
	left:0px;
}

.ribbonTitle {
	background:#356b8d;
	color:#ffffff;
	padding-right:10px;
	width:100%;
	height:100%;
}

.detailLabel {
	font-weight: bold;
	color: rgb(71,72,67);
	font-size: 10pt;
}

.listBoxItemSelected {
	color: black;
	background: #E0E0E0;
	font-weight: bold;
}

/* @doc="Selected item with focus within listBox." */
.listBoxItemFocus {
	font-weight: bold;
	color: white;
	background: rgb(53,107,141);
	background-image: none;
	background-repeat: none;
}

/* tab 1 */
#dataSourceHeader {
	border-bottom: 1px solid #C0C0C0;
}

/* div inside header */
.DataHeaderDiv {
	padding: 5px;
	height: 12pt;
	color: #404040;
	background: #e8e7e2;
}

#dataSourceTree {
	background: white;
	width: 225px;
	overflow: auto;
	border-bottom: 1px solid gray;
}

#schemaTableHeader {
	border-bottom: 1px solid #C0C0C0;
}

#schemaTablePane {
	background: white;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
}

#dataPropertyPane {
	background: white;
	width: 250px;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	border-left: 1px solid #C0C0C0;
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

.hdrLink {
	font-size: 10pt;
	font-weight: normal;
	color: #5ba4dc;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.hdrLinkDisabled {
	font-size: 10pt;
	font-weight: normal;
	color: gray;
	text-decoration: none;
	padding-left: 6px;
	padding-right: 6px;
}

.hdrLink:hover {
	color: #98923a;
}

</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none">
<reportModelServer id="modelServer" />
<reportModelServer id="schemaServer" />

<reportPreviewer id="reportPreview" />

<popGroup id="busyTrap" width="50%" height="150px"  headerStyle="none">
<busyPanel id="busyDialog"/>
</popGroup>

<editLIDR id="layoutEditorPane" hidden="true" />
</pane>
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

/// Get the (localized) title string for the page.
/// This should be implemented in a subclass.
Method %OnGetTitle() As %String
{
	If (..reportName="") {
		Quit ..%OnGetPageName()
	}
	Quit ..reportName
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Quit $$$Text("Line Item Report Builder","%DeepSee")
}

/// Get the product name for the page.
Method %OnGetProductName() As %String
{
	Quit "DeepSee"
}

Method %OnGetJSResources(ByRef pResources As %String) As %Status [ Private ]
{
	Set pResources("NoActiveClass") = $$$Text("( no active class )")
	Set pResources("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation") = $$$Text("The current class has unsaved changes.  Press 'Ok' to discard changes and proceed or 'Cancel' to abort the current operation.")
	Set pResources("TheCurrentClassHasUnsavedChanges") = $$$Text("The current class has unsaved changes.")
	Set pResources("SaveFailedWithError") = $$$Text("Save failed with Error:")
	Set pResources("TheCurrentDocumentContainsInsufficientDataToSaveAndCompileAtThisTimePleaseEnsureThatAValidDataSourceIsSelected") = $$$Text("The current document contains insufficient data to save and compile at this time.  Please ensure that a valid data source is selected.")
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
		If ('$$CheckReportFormatDefAccess^%qdsUtils()) {
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

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = $$$Text("Report Builder")

	Set pViewIcons(1) = $LB("layout",$$$Text("Show report layout"),"portal/view_report_layout.png")

	// commands
	// $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("cmdOpen",$$$Text("Open"),$$$Text("Open an existing report"),"zenPage.openReport();")
	Set pCommands(2) = $LB("cmdNew",$$$Text("New"),$$$Text("Create a new report"),"zenPage.newReport();")
	Set pCommands(3) = $LB("cmdSave",$$$Text("Save"),$$$Text("Save this report"),"zenPage.saveReport();")
	Set pCommands(4) = $LB("cmdSaveAs",$$$Text("Save As"),$$$Text("Save this document under a new name"),"zenPage.saveAsLIDR();")
	Set pCommands(5) = $LB("cmdSetUp",$$$Text("Setup"),$$$Text("Set up basic page attributes of this report"),"zenPage.pageSetup();")
	Set pCommands(6) = $LB("cmdPreview",$$$Text("Preview"),$$$Text("Show a preview of this report"),"zenPage.preview();")
	Quit $$$OK
}

/// Draw additional stuff in the ribbon bar
Method OnDrawRibbon() As %Status
{
	Quit $$$OK
}

ClientMethod setRibbonTitle(str) [ Language = javascript ]
{
	var td = ZLM.getElementsByClassPrefix("ribbonTitle","toolRibbon");
	td[0].innerHTML="<nobr>"+str+"</nobr>";
	td[0].style.display="block";
}

/// Give visual feedback as to where a given datum may be dropped 
ClientMethod scopeDataDrag(prefix) [ Language = javascript ]
{
	zenPage._bannerWorkspace.setDataDragScope(prefix);
}

/// Remove any obsolete visual feedback as to where a given datum may be dropped 
ClientMethod resetCoverplates() [ Language = javascript ]
{
	zenPage._bannerWorkspace.resetDataDragScope();
}

/// Check if user really wants to exit if they have not saved changes
ClientMethod onunloadHandler() [ Language = javascript ]
{
	if (this._documentEdited) {
		return(zenText("TheCurrentClassHasUnsavedChanges"));
	}
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._documentActive = false;
	this._documentEdited = false;
	
	this.modelServer = this.getModelServer();
	this.schemaServer = this.getSchemaServer();
	this.layoutEditor = this.getLayoutEditor();
	this.previewEngine = this.getPreviewEngine();
	this.dpr = null;
	this.dssHome = 'linked';
	this.dssClass = '';
	this.pageModel = {paper:'letter', orient:'portrait', units:'in', width:612, height:792, left:72, right:72, top:72, bottom:72, header:18, footer:18};

	this.resetLIDR();
	if (this.reportName=="") {
		this.reportName = this.defaultRptName;
		var value = {};
		value.pkgName = "MyApp";
		value.clsName = this.reportName;
		value.appName = " ";
		value.desc = " ";
		value.rptName = this.reportName;

		this.dpr = this.modelServer.createNewDPR(value);
		if (this.pageModel) this.dpr.pageModel = this.pageModel;
		this.setRibbonTitle(this.dpr.sysName);
		this.layoutEditor.enable();
		var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
		workspace.setPageModel(this.pageModel);
		this.adjustSizes();
		this._documentActive = true;
		this._documentEdited = false;
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

/// Adjust sizes of components on the page.
ClientMethod adjustSizes() [ Language = javascript ]
{
	try {
		// find size of window
		var winHeight = zenGetWindowHeight();
		var winWidth = zenGetWindowWidth();

		var th = this.getTitleAreaHeight();
		var hgt = winHeight - th - 20;
		var editor = this.getLayoutEditor();
		if (editor) editor.adjustSizes(winWidth, hgt);
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in adjustSizes');
	}
}

ClientMethod getModelServer() [ Language = javascript ]
{
	return(zen('modelServer'));
}

ClientMethod getSchemaServer() [ Language = javascript ]
{
	return(zen('schemaServer'));
}

ClientMethod getLayoutEditor() [ Language = javascript ]
{
	return(zen('layoutEditorPane'));
}

ClientMethod getPreviewEngine() [ Language = javascript ]
{
	return(zen('reportPreview'));
}

/// Invoke dialog to open a report.
ClientMethod openReport() [ Language = javascript ]
{
	if (this._documentEdited) {
		var x = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!x) return;
	}

	var parms = {
		SUPER:'%DeepSee.Report.dataPresenter'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','OpenReport','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

/// Invoke dialog to create a new report.
ClientMethod newReport() [ Language = javascript ]
{
	if (this._documentEdited) {
		var x = confirm(zenText("TheCurrentClassHasUnsavedChangesPressOkToDiscardChangesAndProceedOrCancelToAbortTheCurrentOperation"));
		if (!x) return;
	}

	var parms = {
		SUPER:'%DeepSee.Report.dataPresenter'
	}
	// TODO CHECK TO SEE IF THERE ARE UNSAVED CHANGES
	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls','NewReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Rename this report and save it to disk.
ClientMethod saveAsLIDR() [ Language = javascript ]
{
	// Ask for a rename, onPopupAction can deal with the rest.
	var parms = {
		SUPER:'%DeepSee.Report.dataPresenter'
	}

	zenPage._popupData = {};
	var d = zenPage._popupData;
	//if (this.dpr.package) d.pkgName=this.dpr.package 
	d.pkgName=null; // use default package name
	if (this.dpr.appName) d.appName=this.dpr.appName;
	if (this.dpr.objClass) d.clsName=this.dpr.objClass;
	if (this.dpr.name) d.rptName=this.dpr.name;
	if (this.dpr.desc) d.desc=this.dpr.desc;

	zenLaunchPopupWindow('_DeepSee.Report.UI.NewReportWizard.cls','SaveAsReport','status,scrollbars,resizable=yes,width=505,height=380',parms);
}

/// Request a save of the report.
ClientMethod saveReport() [ Language = javascript ]
{
	if (!this.modelServer.jsModel) {
		return;
	}
	if (this.dpr.sysName == "MyApp."+this.defaultRptName) this.saveAsLIDR();
	else {
		var blocker = this.getComponentById("busyTrap");
		blocker.show(this.getEnclosingDiv().offsetWidth/4,this.getEnclosingDiv().offsetHeight/4,true);
		setTimeout("zenPage.reallySaveLIDR();",0);
	}
}

/// Really save the report to server.
ClientMethod reallySaveLIDR() [ Language = javascript ]
{
	var tsc = 0;
	try {
		var ms = this.modelServer;
		var b = this._editor._editorPanel;
	
		// Synch the model with the editors
		var rObj = b.exportObj();
		ms.jsModel.t = rObj.t;
		ms.jsModel.s = rObj.s;
		var zrsObj = b.exportZRS();
		ms.setZRSBody(zrsObj.d);

		var name = ms.exportXMLtoFile(null);
		var tsc = ms.ImportXML(name);
	}
	catch (err) {
		if (tsc==0) tsc = err;
	}

	var blocker = this.getComponentById("busyTrap");
	blocker.popAway();
	if (tsc!=1) {
		if (!zrsObj) { // Died prior to attempts to reach server
			alert(zenText("TheCurrentDocumentContainsInsufficientDataToSaveAndCompileAtThisTimePleaseEnsureThatAValidDataSourceIsSelected"));
			return;
		}
		alert(zenText("SaveFailedWithError")+tsc.split("|").join('\n'));
	}
	else {
		this._documentEdited = false;
	}
}

ClientMethod getPageModel() [ Language = javascript ]
{
	return(this.pageModel);
}

/// Page setup for report
ClientMethod pageSetup() [ Language = javascript ]
{
	var url = "_DeepSee.Report.UI.PageSetUpDialog.cls";
	zenLaunchPopupWindow(url,'PageSetup','status,scrollbars,width=628,height=466,resizable=no');
}

/// Show a preview.
ClientMethod preview() [ Language = javascript ]
{
	this.saveReport();
	var ms = this.modelServer;
	
	var p = this.previewEngine;
	if (p) p.preview(ms.jsModel.sysName,ms.jsModel.dssClass);
}

/// Data drop on layout editor.
ClientMethod layoutEditorDropHandler(dragData) [ Language = javascript ]
{
	var div = zen('layoutEditor').getEnclosingDiv();
	div.innerHTML = dragData.text;
}

ClientMethod restoreDPR(src) [ Language = javascript ]
{
	this.dpr = src;
	if (src.pageModel) {
		this.pageModel = src.pageModel;
		var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
		workspace.setPageModel(this.pageModel);
	}
	else if (this.pageModel) this.dpr.pageModel;
	this.layoutEditor.enable();
	this.adjustSizes();
	if (src.dssHome=='linked') {
		this.newLayout(src.dssClass);
	}
	else {
		//TODO address local DSS
	}
	var b = this._editor._editorPanel;
	b.restoreObj(src);
	this.setRibbonTitle(src.sysName);
	var e = this.layoutEditor;
	var p = e.getWorkingDataSetPanel();
	p.fixDataSource();
}

/// reset the active editors
ClientMethod resetLIDR() [ Language = javascript ]
{
	this.dpr = null;
//	this.pageModel = {paper:'letter', orient:'portrait', units:'in', width:612, height:792, left:72, right:72, top:72, bottom:72, header:18, footer:18};
	var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
	workspace.setPageModel(this.pageModel);
	this.layoutEditor.disable();
	this.setRibbonTitle(zenText('NoActiveClass'));
	zenPage._bannerWorkspace.resetBanners();
	zenPage._workingDataSetPane.reset();
	this._documentActive = false;
}

ClientMethod newLayout(dssClass) [ Language = javascript ]
{
	var ms = this.modelServer;
	var ss = this.schemaServer;
	ss.setReportSource(dssClass,"DSS");
	var j = ss.getDSSObject();
	if (!j) {
		ZLM.cerr("Bad translation to JSON object "+m);
		return;
	}
	j.item.push({'nodeName':'$pageNum','nodeType':'sysvar','item':[],'attr':[]});
	this.setDataPoolFromDSSObject(j);
	j.item.pop();
	this.dssClass = dssClass;
	this.dssHome = 'linked';
	ms.jsModel.dssClass = dssClass;
	ms.jsModel.dssHome = 'linked';
	ms.jsModel.dssName = j.nodeName;
}

ClientMethod autoFillData() [ Language = javascript ]
{
	var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
	var name = this.dpr.name;
	if ((!name)||(name && name.length && name.length==0)) name = this.dpr.sysName;
	workspace.autoFillFromDSS(this.dpr.name);
}

ClientMethod setDataPoolFromDSSObject(obj, title) [ Language = javascript ]
{
	if (!title && obj.nodeType=='root') {
		title = obj.nodeName;
	}
	var wds = this.getComponentById("layoutEditorPane.workingDataSetPanel.workingDataSet");
	wds.setDataTreeFromDSS(obj);
	var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
	workspace.initSchemaFromDSS(obj);
}

ClientMethod getUserImageURLSelection(cb) [ Language = javascript ]
{
	this.imageSelectCB = cb;
	this.showFileSelectionWindow();
}

ClientMethod showFileSelectionWindow() [ Language = javascript ]
{
	var Dir = this.modelServer.getCSPDir();
	var wildcard = "*"
	var url = "%ZEN.Dialog.fileSelect.cls?Dir=" + cspEncodeUTF8(Dir) + "&wildcard=" + wildcard;
	zenLaunchPopupWindow(url,'FileSelection','status,scrollbars,resizable,width=500,height=700');
}

/// Returning from file select dialog and setting the value into the Filename field
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	
	switch(popupName) {
		case 'NewReport':
			if (value) {
				this.resetLIDR();
				this.dpr = this.modelServer.createNewDPR(value);
				if (this.pageModel) this.dpr.pageModel = this.pageModel;
				this.setRibbonTitle(this.dpr.sysName);
				this.layoutEditor.enable();
				var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
				workspace.setPageModel(this.pageModel);
				this.adjustSizes();
				this._documentActive = true;
				this._documentEdited = false;
			}
			break;

		case 'SaveAsReport':
			if (value) {
				if (!value.rptName) value.rptName = this.defaultRptName;
				this.dpr.package = value.pkgName;
				this.dpr.objClass = value.clsName;
				this.dpr.appName = value.appName;
				this.dpr.sysName = value.pkgName+"."+value.clsName;
				this.dpr.name = value.rptName;
				this.dpr.desc = value.desc;
				this.setRibbonTitle(this.dpr.sysName);
				this.saveReport();
			}
			break;
			
		case 'OpenReport':
				if (value!='') {
					this.resetLIDR();
					var s = value.toString().split('.');
					if ('cls' == s[s.length-1]) {
						s.length = s.length-1;
						var m = this.modelServer.setReportSource(s.join('.'),'DPR');
						this.restoreDPR(m);
						this._documentActive = true;
						this._documentEdited = false;
					}
				}
				break;
		
		case 'DataSource':
			if (value != '') {
				// pull extension off of name
				var s = value.toString().split('.');
				if ('cls' == s[s.length-1]) {
					s.length = s.length-1;
					this.newLayout(s.join('.'));
					var e = this.layoutEditor;
					var p = e.getWorkingDataSetPanel();
					p.fixDataSource();
					this._documentEdited = true;
				}
			}
			break;

		case 'FileSelection':
			if (this.imageSelectCB) eval(this.imageSelectCB);
			break;
			
		case 'switchNamespace':
			var url = zenPage.GetNewURL(value,"_DeepSee.Report.UI.BuildLIDR.cls");
			try {
				if (window.location && window.location.assign) window.location.assign(url);
				else self.document.location =url ;
			}
			catch (e) {
			}
			break;
			
		case 'PageSetup':
			this.pageModel = ZLM.jsonParse(value,1,1);
			var workspace = this.getComponentById("layoutEditorPane.layoutEditorPanel.layoutEditor");
			workspace.setPageModel(this.pageModel);
			if (this.dpr) this.dpr.pageModel = this.pageModel;
			this._documentEdited = true;
			break;
	}
}

/// For the time being, do not use soft modals for the portal.
ClassMethod %OnUseSoftModals() As %Boolean [ CodeMode = expression ]
{
1
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
