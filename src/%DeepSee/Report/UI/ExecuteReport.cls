/// DeepSee Run Report Manager page.
/// 
Class %DeepSee.Report.UI.ExecuteReport Extends %DeepSee.UI.standardPage [ DependsOn = (%DeepSee.Report.UI.reportPreviewer, %DeepSee.Report.UI.reportModelServer), LegacyInstanceContext, System = 4 ]
{

Parameter AUTONS = 0;

Parameter DOMAIN = "%DeepSee";

/// DeepSee favorite icon.
Parameter FAVORITEICON = "portal/deepsee.ico";

/// Displayed name of this page.
Parameter PAGENAME = "DeepSee Visual Reporting Execution Manager";

/// Name of Report being viewed.
Property reportName As %ZEN.Datatype.string(ZENURL = "RPT");

/// Data source. This is a copy of the value in the report model.
Property dataSource As %ZEN.Datatype.string;

/// Local copy of report model object.
/// Index (0-based) of selected data field (if any).
Property selectedDataField As %ZEN.Datatype.integer;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

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

#outputWindow iframe{
	width:98%;
	height:100%;
	margin-left:0.9%;
	margin-right:0.9%;
}

.propItem {
	border:1px solid #356b8d;
	width:98%;
	margin-left:0.9%;
	margin-right:0.9%;
	position:relative;
	top:0px;
	left:0px;
}

.propName {
	width:25%;
	font-weight:bold;
	font-size:16pt;
	padding:3px;
	display:inline-block;
}

.propDesc {
	position:relative;
	top:0px;
	left:0px;
	width:50%;
}

.propCtrl {
	position:absolute;
	top:0px;
	right:0px;
	width:25%;
	height:100%;
}

.propCheckCtrl {
	position:absolute;
	top:0px;
	right:0px;
	width:25%;
	height:100%;
}

</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" layout="none">
<reportModelServer id="modelServer" />
<reportModelServer id="schemaServer" />
<reportPreviewer id="reportPreview" />
<label id="activeReport" enclosingStyle="width:100%;font-weight:bold;font-size:26px;text-align:center;" />
<html id="optionPanel" enclosingStyle="width:90%;margin-left:5%;margin-right:5%;">
<!--
In this space the user will ultimately see a list of defined parameters for this
report and will be presented with UI widgets to set specific values to tune the 
selection or accept the defaults<p />
There will also be an optional multiselect set of debugging options to add to the URL 
such as $LOG to allow expert user some additional flexibility shy of having to crack open Studio.
-->
</html>
<iframe id="outputWindow" enclosingStyle="width:100%;background:#ffffff" />
</pane>
}

/// Return the array of links to show in the locator bar.<br/>
/// pLink(n)=$LB(caption,link) 
Method %GetLocatorLinks(Output pLink) As %Status
{
	Set tPageName = $$$Text("DeepSee","%DeepSee")
	Set pLink($I(pLink)) = $LB(tPageName,..homePage)

	Set tPageName = ..%OnGetPageName()
	Set pLink($I(pLink)) = $LB(tPageName,$ZCVT(..%ClassName(1),"O","URL")_".zen?home="_$G(%request.Data("home",1))_"&REPORT="_$ZCVT(..reportName,"O","URL"))
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
	Quit $$$Text("Report Execution Manager","%DeepSee")
}

/// Get the product name for the page.
Method %OnGetProductName() As %String
{
	Quit "DeepSee"
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
		if ('$$CheckReportExecuteAccess^%qdsUtils()) {
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

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status
{
	Set pDisplay = 1
	Set pSearchBox = 0
	Set pRibbonTitle = $$$Text("Report Executor")

	Set pViewIcons(1) = $LB("stack",$$$Text("Show controls and report stacked"),"portal/view_stacked.png")
	Set pViewIcons(2) = $LB("parallel",$$$Text("Show controls and report side by side"),"portal/view_side_by_side.png")
	Set pViewIcons(3) = $LB("tabbed",$$$Text("Show controls and report on separate tabs"),"portal/view_tabbed.png")

	// commands
	// $LB(id,caption,help,onclick)
	Set pCommands(1) = $LB("cmdOpen",$$$Text("Open"),$$$Text("Open an existing report"),"zenPage.openReport();")
	Set pCommands(2) = $LB("cmdPreview",$$$Text("Run"),$$$Text("Execute this report"),"zenPage.runReport();")
	Set pCommands(3) = $LB("cmdDebug",$$$Text("Debug"),$$$Text("Execute this report in debugging mode"),"zenPage.debugReport();")
	Quit $$$OK
}

/// Draw additional stuff in the ribbon bar
Method OnDrawRibbon() As %Status
{
	Quit $$$OK
}

ClassMethod GetPropertyData(className As %ZEN.Datatype.string) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set rValue = ""
	
	Set cDef=##class(%ClassDefinition).%OpenId(className)
	if (cDef="") {
		quit rValue
	}
	Set pInfo=$property(cDef,"Properties")
	For i=1:1:pInfo.Count() {
		Set item=pInfo.GetAt(i)
		Set desc=$$FindDesc^%occName(item.ClassName,$$$cCLASSproperty,item.Name)
		Set rValue = rValue_"n:"_item.Name_"|t:"_item.Type_"|d:"_desc_"|"
		If item.Parameters.Count()>0 {
			Set rValue = rValue_"p:"
			Set pname="",first=1
			For  Set pval=item.Parameters.GetNext(.pname) Quit:pname=""  Do
			. Set rValue = rValue_$S(first:"",1:"!$!")_pname_"="_pval
			. Set first=0
			set rValue = rValue_"|"
		}
	
		Set rValue = rValue_"i:"_item.InitialExpression_"|:"_$C(10)
	}
	Quit rValue
}

ClientMethod setRibbonTitle(str) [ Language = javascript ]
{
	var td = ZLM.getElementsByClassPrefix("ribbonTitle","toolRibbon");
	td[0].innerHTML="<nobr>"+str+"</nobr>";
	td[0].style.display="block";
}

/// Check if user really wants to exit if they have not saved changes
ClientMethod onunloadHandler() [ Language = javascript ]
{
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.modelServer = this.getModelServer();
	this.schemaServer = this.getSchemaServer();
	this.previewEngine = this.getPreviewEngine();
	this.activeReportLabel = zen('activeReport');
	this.optionPanel = zen('optionPanel');
	this.outputWindow = zen('outputWindow');
	this.dpr = null;
	this.dssHome = 'linked';
	this.dssClass = '';
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

		//var th = this.getTitleAreaHeight();
		var th = this.optionPanel.getEnclosingDiv().offsetTop+this.optionPanel.getEnclosingDiv().offsetHeight;
		var hgt = winHeight - th - 20;
		if (hgt<200) hgt=200;
		var d = this.outputWindow.getEnclosingDiv();
		var tp = ZLM.getPageOffsetTop(d);
		hgt = winHeight-tp-20;
		this.outputWindow.getEnclosingDiv().style.height = hgt+"px";
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

ClientMethod getPreviewEngine() [ Language = javascript ]
{
	return(zen('reportPreview'));
}

/// Invoke dialog to open a report.
ClientMethod openReport() [ Language = javascript ]
{
	var parms = {
		SUPER:'%DeepSee.Report.dataPresenter'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','OpenReport','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

ClientMethod generateNVPString(pName, pValue) [ Language = javascript ]
{
	var delims = [',','|','~',':',';'];
	var dLen = delims.length;
	var pLen = pName.length;
	var done = false;
	var dIdx = 0;
	while (!done && dIdx<dLen) {
		done = true;
		var d = delims[dIdx];
		for (var i=0;i<pLen;i++) {
			if ((pName.indexOf(d)>=0) || (pValue.indexOf(d)>=0)) {
				done = false;
				dIdx++;
				i=pLen;
			}
		}
	}
	if (done) {
		var d = delims[dIdx];
		var a = [];
		for (var i=0;i<pLen;i++) {
			a.push(d+pName[i]+d+pValue[i]);
		}
		return(a.join(""));
	}
	return("");
}

/// Show a preview.
ClientMethod runReport() [ Language = javascript ]
{
	var ms = this.modelServer;
	var pStr = ""
	if (this.qOpts) {
		var pName = [];
		var pValue = [];
		for (var i=0;i<this.qOpts.length;i++) {
			var o = this.qOpts[i];
			if (o.dirty) {
				pName.push(o.name);
				pValue.push(o.value);
			}
		}
		pStr = this.generateNVPString(pName,pValue);
	}
	
	var p = this.previewEngine;
	if (p) {
		var url = p.execute(ms.jsModel.sysName,ms.jsModel.dssClass,pStr);
		if (url) this.outputWindow.setProperty("src",url);
	}
}

/// Generate logs for debugging.
ClientMethod debugReport() [ Language = javascript ]
{
	var ms = this.modelServer;
	var pStr = ""
	if (this.qOpts) {
		var pName = [];
		var pValue = [];
		for (var i=0;i<this.qOpts.length;i++) {
			var o = this.qOpts[i];
			if (o.dirty) {
				pName.push(o.name);
				pValue.push(o.value);
			}
		}
		pStr = this.generateNVPString(pName,pValue);
	}
	
	var p = this.previewEngine;
	if (p) {
		var url = p.execute(ms.jsModel.sysName,ms.jsModel.dssClass,pStr,"dsrGenerationLog");
		if (url) this.outputWindow.setProperty("src",url);
	}
}

/// Extract the data needed to build a form to allow the user to enter
/// query parameter values prior to running a report
ClientMethod intializeReportForm() [ Language = javascript ]
{
	var m = this.modelServer.setReportSource(this.className,'DPR');
	this.dssClass = m.dssClass;
	var s = this.schemaServer.setReportSource(this.dssClass,'DSS');
	this.dataFileName = s.dataFileName;
	this.dataCollector = s.dataCollector;
	if (this.dataFileName) {
		this.dssProperties = null;
	}
	else {
		this.dssProperties = this.GetPropertyData(this.dataCollector);
	}
	this.updateControls();
}

/// Returning from file select dialog and setting the value into the Filename field
ClientMethod onPopupAction(popupName, action, value) [ Language = javascript ]
{
	if (action != "ok") return;
	
	switch(popupName) {
		case 'OpenReport':
				if (value!='') {
					var s = value.toString().split('.');
					if ('cls' == s[s.length-1]) {
						s.length = s.length-1;
						this.className = s.join('.');
						this.intializeReportForm();
					}
				}
				break;
		case 'switchNamespace':
			var url = zenPage.GetNewURL(value,"_DeepSee.Report.UI.ExecuteReport.cls");
			try {
				if (window.location && window.location.assign) window.location.assign(url);
				else self.document.location =url ;
			}
			catch (e) {
			}
			break;

	}
}

ClientMethod updateControls() [ Language = javascript ]
{
	this.activeReportLabel.setValue(this.className);
	var h=[];
	var p = document.getElementById("optionPanel");
	var pList = this.dssProperties.split('|:\n');
	var pLen = pList.length-1;
	h.push("<h4>Data Collector: "+this.dssClass+"</h4>");
	this.qOpts = [];
	for (var i=0;i<pLen;i++) {
		var item = pList[i];
		var attr = item.split('|');
		var aLen = attr.length;
		if (aLen>0) {
			var obj = {};
			obj.value=null;
			for (var j=0;j<aLen;j++) {
				if (attr[j].indexOf('n:')==0) {
					obj.name = attr[j].substring(2);
				}
				else if (attr[j].indexOf('d:')==0) {
					obj.desc = attr[j].substring(2);
					obj.desc = obj.desc.split("\n").join(" ");
				}
				else if (attr[j].indexOf('t:')==0) {
					obj.type = attr[j].substring(2);
				}
				else if (attr[j].indexOf('p:')==0) {
					// We only want objects with a defined ZENURL property
					// Implicit VALUEList of True,False for %Boolean
					// Also we can check MAXLEN MINLEN and VALUELIST for Strings
					// Check for MAXVAL, MINVAL and VALUELIST for everything else
					// %Currency, %Date, %Date, %Float, %Integer, %Numeric, %Time
					obj.params = attr[j].substring(2).split('!$!');
				}
				else if (attr[j].indexOf('i:')==0) {
					obj.value = attr[j].substring(2);
					if (obj.value.charAt(0)=='"') obj.value = obj.value.split('"').join('');
				}
			}
			this.qOpts.push(obj);
		}
	}
	var qLen = this.qOpts.length;
	for (var i=0;i<qLen;i++) {
		var o = this.qOpts[i];
		if (o.value=='""') o.value=null;
		h.push("<form name='dcrData' onsubmit='ZLM.killEvent(event);' action='#' >");
		h.push("<div class='propItem'>");
		h.push("<span class='propName'>"+o.name+"</span>");
		h.push("<span class='propDesc'>"+o.desc+"</span>");
		var handled = false;
		if (o.type == "%Boolean") {
			var checked = "";
			if (parseInt(o.value)==1) checked = "checked='yes'";
			h.push("<input class='propCheckCtrl' name='P"+i+"' type='checkbox' "+checked+" onchange='zenPage.updateQueryOptions(event,"+i+",this);' />");
			handled = true;
		}
		else if (o.type == "%Integer") {
			var parms = o.params;
			var pLen = parms.length;
			
			var minV = 'ukn';
			for (var j=0;j<pLen;j++) {
				if (parms[j].indexOf("MINVAL=")==0) {
					minV = parseInt(parms[j].substring(7));
					j=pLen;
				}
			}
			var maxV = 'ukn';
			for (var j=0;j<pLen;j++) {
				if (parms[j].indexOf("MAXVAL=")==0) {
					maxV = parseInt(parms[j].substring(7));
					j=pLen;
				}
			}
			if (minV!='ukn' && maxV!='ukn' && (maxV-minV)<25) {
				h.push("<select class='propCtrl' onchange='zenPage.updateQueryOptions(event,"+i+",this);' >");
				h.push("<option value=''></option>");
				for (var j=minV;j<=maxV;j++) h.push("<option value='"+j+"'>"+j+"</option>");
				h.push("</select>");
				handled=true;
			}
		}
		if (!handled) {
			var vList = 'ukn';
			var parms = o.params;
			if (parms) {
				var pLen = parms.length;		
				for (var j=0;j<pLen;j++) {
					if (parms[j].indexOf("VALUELIST=")==0) {
						vList = parms[j].substring(10);
						j=pLen;
					}
				}
			}
			if (vList != 'ukn') {
				var delim = vList.charAt(0);
				var vOption = vList.split(delim);
				h.push("<select class='propCtrl' onchange='zenPage.updateQueryOptions(event,"+i+",this);' >");
				for (var j=0;j<vOption.length;j++) {
					var selected = "";
					if (vOption[j]==o.value) selected = "selected='true' ";
					h.push("<option "+selected+" value='"+vOption[j]+"'>"+vOption[j]+"</option>");
				}
				h.push("</select>");
			}	
			else {
				if (o.value) h.push("<input class='propCtrl' type='text' value='"+o.value+"' onchange='zenPage.updateQueryOptions(event,"+i+",this);' />");
				else h.push("<input class='propCtrl' type='text' onchange='zenPage.updateQueryOptions(event,"+i+",this);' />");
			}
		}
		h.push("</div>");
	}
	h.push("</form>");
	h.push("<br />");
	p.innerHTML=h.join("");
	this.outputWindow.setProperty("src","");
	this.adjustSizes();
}

ClientMethod updateQueryOptions(event, idx, ctrl) [ Language = javascript ]
{
	if (ctrl.tagName=="INPUT" && ctrl.type=="checkbox") {
		var status = document.dcrData["P"+idx].checked;
		if (!status || status=="false") this.qOpts[idx].value=0;
		else this.qOpts[idx].value=1;
	}
	else {
		this.qOpts[idx].value=ctrl.value;
	}
	this.qOpts[idx].dirty = true;
	ZLM.killEvent(event);
}

}
