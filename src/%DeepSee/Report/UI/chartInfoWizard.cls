/// 
Class %DeepSee.Report.UI.chartInfoWizard Extends %ZEN.Component.component [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zendsrpt.js";

Property plottingTxt As %ZEN.Datatype.caption [ InitialExpression = "Plotting" ];

Property dataFieldsTxt As %ZEN.Datatype.caption [ InitialExpression = "Data Fields" ];

Property seriesNamesTxt As %ZEN.Datatype.caption [ InitialExpression = "Series Names" ];

Property chartTabTxt As %ZEN.Datatype.caption [ InitialExpression = "Chart" ];

Property xAxisTabTxt As %ZEN.Datatype.caption [ InitialExpression = "X Axis" ];

Property yAxisTabTxt As %ZEN.Datatype.caption [ InitialExpression = "Y Axis" ];

Property titleTxt As %ZEN.Datatype.caption [ InitialExpression = "Title" ];

Property typeTxt As %ZEN.Datatype.caption [ InitialExpression = "Chart Type" ];

Property useDataGrpTxt As %ZEN.Datatype.caption [ InitialExpression = "Use Data Grouping" ];

Property defaultBWTxt As %ZEN.Datatype.caption [ InitialExpression = "Default to B&amp;W" ];

Property legendTxt As %ZEN.Datatype.caption [ InitialExpression = "Show Legend" ];

Property labelTxt As %ZEN.Datatype.caption [ InitialExpression = "Show Labels" ];

Property okayTxt As %ZEN.Datatype.caption [ InitialExpression = "Okay" ];

Property cancelTxt As %ZEN.Datatype.caption [ InitialExpression = "Cancel" ];

Property staticLabelsTxt As %ZEN.Datatype.caption [ InitialExpression = "Static label text" ];

Property dynamicLabelsTxt As %ZEN.Datatype.caption [ InitialExpression = "Dynamic label src" ];

Property axisTitleTxt As %ZEN.Datatype.caption [ InitialExpression = "Axis Title" ];

Property textAnchorTxt As %ZEN.Datatype.caption [ InitialExpression = "Label Anchor" ];

Property textAnchorBeginTxt As %ZEN.Datatype.caption [ InitialExpression = "Begin" ];

Property textAnchorEndTxt As %ZEN.Datatype.caption [ InitialExpression = "End" ];

Property labelAngleTxt As %ZEN.Datatype.caption [ InitialExpression = "Label Angle" ];

Property minValueDisplacementTxt As %ZEN.Datatype.caption [ InitialExpression = "Min Value Displacement" ];

Property majorGridLinesTxt As %ZEN.Datatype.caption [ InitialExpression = "Draw Grid Lines" ];

/// This Style block contains component-specific CSS 3 style definitions.
XData CSS3Style
{
<style type="text/css">
.chartInfoWizard {
	position:relative;
	top:0px;
	left:0px;
	width:450px;
	height:330px;
	background:#e8e7e2;
}

.chartInfoHeading{
	position:absolute;
	left:5px;
	color:#000077;
	font: 12px Arial;
}

.chartInfoTxtBox{
	position:absolute;
	color:#000077;
	font: 12px Arial;
	left: 35%;
	width: 60%;
}

.chartInfoSidebarBox{
	position:absolute;
	color:#000077;
	font: 12px Arial;
	left: 0px;
	width: 100%;
}
.chartInfoTabBar {
	position:absolute;
	top: 24px;
	width:100%;
	height:23px;
	background: #9999aa;
	cursor:pointer;
}

.chartInfoTab {
	position:absolute;
	height:20px;
	bottom:0px;
	font: 12px Arial;
	text-align:center;
	width: 75px;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
	background:#eeeeff;
	color:#000077;
}

.chartInfoCtrlDiv {
	position:absolute;
	left:1px;
	right:1px;
	top: 47px;
	bottom: 30px;
}
			
.chartInfoConstant{
	position:absolute;
	color:#000077;
	font: 12px Arial;
}

.chartInfoInput{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	width:98%;
	left:1%;
}

.chartInfoOkay {
	position:absolute;
	width:75px;
	top:0px;
	right:5px;
}

.chartInfoCancel{
	position:absolute;
	width:75px;
	top:0px;
	right:80px;
}

.chartCtrlDiv {
	position:absolute;
	width: 165px;
	height: 180px;
	top: 20px;
	left: 0px;
}

.chartInfoSidebarDiv {
	position: absolute;
	height: 100%;
	top: 0px;
	left: 0px;
	right: 65%
}

.chartInfoAreaDiv {
	position:absolute;
	height:98%;
	top:1%;
	left:37%;
	right:1%;
	background:#000042;
}

.chartFooterDiv {
	position:absolute;
	width:50%;
	height:25px;
	bottom:3px;
	left:50%;
}

</style>
}

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.chartInfoWizard {
	position:relative;
	top:0px;
	left:0px;
	width:450px;
	height:330px;
	background:#e8e7e2;
}

.chartInfoHeading{
	position:absolute;
	left:5px;
	color:#000077;
	font: 12px Arial;
}

.chartInfoTxtBox{
	position:absolute;
	color:#000077;
	font: 12px Arial;
	left: 35%;
	width: 60%;
}

.chartInfoSidebarBox{
	position:absolute;
	color:#000077;
	font: 12px Arial;
	left: 0px;
	width: 100%;
}
.chartInfoTabBar {
	position:absolute;
	top: 24px;
	width:100%;
	height:23px;
	background: #9999aa;
	cursor:pointer;
}

.chartInfoTab {
	position:absolute;
	height:20px;
	bottom:0px;
	font: 12px Arial;
	text-align:center;
	width: 75px;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
	-moz-border-top-left-radius: 10px;
	-moz-border-top-right-radius: 10px;
	background:#eeeeff;
	color:#000077;
}

.chartInfoCtrlDiv {
	position:absolute;
	left:1px;
	right:1px;
	top: 47px;
	bottom: 30px;
}

			
.chartInfoConstant{
	position:absolute;
	color:#000077;
	font: 12px Arial;
}

.chartInfoInput{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	width:98%;
	left:1%;
}

.chartInfoOkay {
	position:absolute;
	width:75px;
	top:0px;
	right:5px;
}

.chartInfoCancel{
	position:absolute;
	width:75px;
	top:0px;
	right:80px;
}

.chartCtrlDiv {
	position:absolute;
	width:165px;
	height:180px;
	top:20;
	left:0;
}

.chartInfoSidebarDiv {
	position:absolute;
	height:100%;
	top:0px;
	left:0px;
	right:65%
}

.chartInfoAreaDiv {
	position:absolute;
	height:98%;
	top:1%;
	left:37%;
	right:1%;
	background:#000042;
}

.chartFooterDiv {
	position:absolute;
	width:50%;
	height:25px;
	bottom:3px;
	left:50%;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="chartInfoWizard" >
			<div class="chartInfoHeading" style="top:5px;">#(..plottingTxt)#</div>
			<input id="#(..%MakeId("sourceCtrl"))#" class="chartInfoTxtBox" style="top:1px;"></input>
	
			<div class="chartInfoTabBar">
				<div id="#(..%MakeId("chartTab"))#" class="chartInfoTab" style="left:10px;" onclick="zenPage.getComponent(#(..index)#).showTab(0);">#(..chartTabTxt)#</div>
				<div id="#(..%MakeId("xAxisTab"))#" class="chartInfoTab" style="left:95px;" onclick="zenPage.getComponent(#(..index)#).showTab(1);">#(..xAxisTabTxt)#</div>
				<div id="#(..%MakeId("yAxisTab"))#" class="chartInfoTab" style="left:180px;" onclick="zenPage.getComponent(#(..index)#).showTab(2);">#(..yAxisTabTxt)#</div>
			</div>
			
			<div id="#(..%MakeId("chartCtrl"))#" class="chartInfoCtrlDiv" style="display:none;">
				<div id="#(..%MakeId("sidebar"))#" class="chartInfoSidebarDiv">
					<div class="chartInfoHeading" style="top:5px;">#(..titleTxt)#</div>
					<input type="text" id="#(..%MakeId("titleCtrl"))#" class="chartInfoSidebarBox" style="top:20px" onchange="zenPage.getComponent(#(..index)#).setTitle();" ></input>

					<div class="chartInfoHeading" style="top:43px;">#(..typeTxt)#</div>
					<!-- skip 75 pixels for the type selector -->

					<div class="chartInfoHeading" style="top:140px;">#(..dataFieldsTxt)#</div>
					<input type="text" id="#(..%MakeId("dataFldsCtrl"))#" class="chartInfoSidebarBox" style="top:155px" ></input>

					<div class="chartInfoHeading" style="top:178px;">#(..seriesNamesTxt)#</div>
					<input type="text" id="#(..%MakeId("seriesCtrl"))#" class="chartInfoSidebarBox" style="top:193px" ></input>

					<div class="chartInfoHeading" style="top:216px;">#(..useDataGrpTxt)#</div>
					<input type="checkbox" id="#(..%MakeId("dataGroupCtrl"))#" style="position:absolute;top:214px;right:1%" />

					<div class="chartInfoHeading" style="top:231px;">#(..legendTxt)#</div>
					<input type="checkbox" id="#(..%MakeId("legendCtrl"))#" style="position:absolute;top:229px;right:1%" onchange="zenPage.getComponent(#(..index)#).setLegendVisible();" />
	
					<div class="chartInfoHeading" style="top:246px;">#(..labelTxt)#</div>
					<input type="checkbox" id="#(..%MakeId("labelCtrl"))#" style="position:absolute;top:244px;right:1%" onchange="zenPage.getComponent(#(..index)#).setLabelVisible();" />

					<div class="chartInfoHeading" style="top:261px;">#(..defaultBWTxt)#</div>
					<input type="checkbox" id="#(..%MakeId("bwCtrl"))#" style="position:absolute;top:258px;right:1%" />
				</div>
				<div id="#(..%MakeId("area"))#" class="chartInfoAreaDiv" >
				</div>
			</div>
			
			<div id="#(..%MakeId("xAxisCtrl"))#" class="chartInfoCtrlDiv" style="display:none;">
				<div class="chartInfoHeading" style="top:5px;">#(..axisTitleTxt)#</div>
				<input class="chartInfoTxtBox" style="top:1px;" type="text" id="#(..%MakeId("xAxisTitleCtrl"))#"></input>
			
				<div class="chartInfoHeading" style="top:30px;">#(..staticLabelsTxt)#</div>
				<input class="chartInfoTxtBox" style="top:26px;" type="text" id="#(..%MakeId("xAxisStaticLabelCtrl"))#"></input>
			
				<div class="chartInfoHeading" style="top:55px;">#(..dynamicLabelsTxt)#</div>
				<input class="chartInfoTxtBox" style="top:51px;" type="text" id="#(..%MakeId("xAxisDynamicSrcCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:80px;">#(..textAnchorTxt)#</div>
				<input class="chartInfoTxtBox" style="top:76px;" type="text" id="#(..%MakeId("xAxisTextAnchorCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:105px;">#(..labelAngleTxt)#</div>
				<input class="chartInfoTxtBox" style="top:101px;" type="text" id="#(..%MakeId("xAxisLabelAngleCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:130px;">#(..minValueDisplacementTxt)#</div>
				<input class="chartInfoTxtBox" style="top:126px;" type="text" id="#(..%MakeId("xAxisMnVDCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:155px;">#(..majorGridLinesTxt)#</div>
				<input class="chartInfoTxtBox" style="top:151px;" type="text" id="#(..%MakeId("xAxisMGLCtrl"))#"></input>

			</div>
			
			<div id="#(..%MakeId("yAxisCtrl"))#" class="chartInfoCtrlDiv" style="display:none;">
				<div class="chartInfoHeading" style="top:5px;">#(..axisTitleTxt)#</div>
				<input class="chartInfoTxtBox" style="top:1px;" type="text" id="#(..%MakeId("yAxisTitleCtrl"))#"></input>
			
				<div class="chartInfoHeading" style="top:30px;">#(..staticLabelsTxt)#</div>
				<input class="chartInfoTxtBox" style="top:26px;" type="text" id="#(..%MakeId("yAxisStaticLabelCtrl"))#"></input>
			
				<div class="chartInfoHeading" style="top:55px;">#(..dynamicLabelsTxt)#</div>
				<input class="chartInfoTxtBox" style="top:51px;" type="text" id="#(..%MakeId("yAxisDynamicSrcCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:80px;">#(..textAnchorTxt)#</div>
				<input class="chartInfoTxtBox" style="top:76px;" type="text" id="#(..%MakeId("yAxisTextAnchorCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:105px;">#(..labelAngleTxt)#</div>
				<input class="chartInfoTxtBox" style="top:101px;" type="text" id="#(..%MakeId("yAxisLabelAngleCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:130px;">#(..minValueDisplacementTxt)#</div>
				<input class="chartInfoTxtBox" style="top:126px;" type="text" id="#(..%MakeId("yAxisMnVDCtrl"))#"></input>

				<div class="chartInfoHeading" style="top:155px;">#(..majorGridLinesTxt)#</div>
				<input class="chartInfoTxtBox" style="top:151px;" type="text" id="#(..%MakeId("yAxisMGLCtrl"))#"></input>
			</div>

			<div class="chartFooterDiv" >
				<input type="button" class="chartInfoOkay" value="#(..okayTxt)#" onclick="zenPage.getComponent(#(..index)#).handleOkay();"></input>
				<input type="button" class="chartInfoCancel" value="#(..cancelTxt)#" onclick="zenPage.getComponent(#(..index)#).handleCancel();"></input>
			</div>
		</div>
	>
}

ClientMethod showTab(num) [ Language = javascript ]
{
	this.chartTab.style.background = "#eeeeff";
	this.xAxisTab.style.background = "#eeeeff";
	this.yAxisTab.style.background = "#eeeeff";

	this.chartPanel.style.display = "none";
	this.xAxisPanel.style.display = "none";
	this.yAxisPanel.style.display = "none";
		
	if (num==0) {
		this.chartTab.style.background = "#e8e7e2";
		this.chartPanel.style.display = "block";
	}
	else if (num==1) {
		this.xAxisTab.style.background = "#e8e7e2";
		this.xAxisPanel.style.display = "block";
	}
	else if (num==2) {
		this.yAxisTab.style.background = "#e8e7e2";
		this.yAxisPanel.style.display = "block";
	}
}

ClientMethod makeChartTypePick() [ Language = javascript ]
{
	var sStr = "width:100%;height:50px;font-size:10px;color:#404040;text-align:center"
	var cb = "zenPage.getComponent("+this.index+").setChartType(";
	var outer = ZLM.makeElement("div",{style:"position:absolute;border:1px solid #c0c0c0;left:1%;top:61px;width:98%;height:75px;overflow:auto"});
	var d = ZLM.makeElement("div");
	outer.appendChild(d);
	var len = this.ids.length;
	this.picks=[];
	for (var i=0;i<len;i++) {
		var e = ZLM.makeElement("div",{id:(this.ids[i]+'_'+this.index),style:sStr,onclick:(cb+i+");")});
		e.innerHTML="<img src='"+this.icons[i]+"' style='margin-left:auto;margin-right:auto;padding-top:2px' /><div>"+this.captions[i]+"</div>"
		d.appendChild(e);
		e.style.background = "#e8e7e2";
		this.picks[i]=e;
	}
	this.updateFromModel();
	return(outer);
}

ClientMethod constrainPoints() [ Language = javascript ]
{
	var m =this.model;
	
	if (!m.ml || m.ml<0 || m.ml>100) m.ml=10;
	if (!m.mr || m.mr<0 || m.mr>100) m.mr=10;
	if (!m.mt || m.mt<0 || m.mt>100) m.mt=10;
	if (!m.mb || m.mb<0 || m.mb>100) m.mb=10;
	if (!m.lx || m.lx<0 || m.lx>100) m.lx=80;
	if (!m.ly || m.ly<0 || m.ly>100) m.ly=10;
	if (!m.lw || m.lw<0 || m.lw>100) m.lw=20;
	if (!m.lh || m.lh<0 || m.lh>100) m.lh=10;
	if (!m.tx || m.tx<0 || m.tx>100) m.tx=10;
	if (!m.ty || m.ty<0 || m.ty>100) m.ty=10;
	this.lastTotalWidth = 279;
	this.lastTotalHeight = 247;
}

ClientMethod updateFromModel() [ Language = javascript ]
{
	var m = this.model;
	var d = this.picks[m.cIdx];
	if (!d) return;
	d.style.background = "#55ffff";
	if (!this.chartArea) return;
	this.sourceCtrl.value = m.grp;
	if (m.udg) this.dataGroupCtrl.checked = true;
	else this.dataGroupCtrl.checked = false;
	
	if (m.df && m.df.length>0) this.dataFldsCtrl.value = m.df.join(',');
	this.seriesCtrl.value = m.sn;
	this.titleCtrl.value = m.n;
	if (m.sLgd) {
		this.legendCtrl.checked = true;
		this.chartKey.base.style.display="block";
	}
	else {
		this.legendCtrl.checked = false;
		this.chartKey.base.style.display="none";
	}
	if (m.sLbl) this.labelCtrl.checked = true;
	else this.labelCtrl.checked = false;

	if (m.bw) this.bwCtrl.checked = true;
	else this.bwCtrl.checked = false;
	
//	var z = 185/100;
	var a=this.findElement("area");
	var tw = a.offsetWidth/100;
	var th = a.offsetHeight/100;

	
	var op = ZRU.convertToPoints;
	m.ml = parseInt(m.ml);
	m.mr = parseInt(m.mr);
	m.mt = parseInt(m.mt);
	m.mb = parseInt(m.mb);
	m.lx = parseInt(m.lx);
	m.ly = parseInt(m.ly);
	m.lw = parseInt(m.lw);
	m.lh = parseInt(m.lh);
	m.tx = parseInt(m.tx);
	m.ty = parseInt(m.ty);

	this.constrainPoints();
	if (tw<=0) tw = this.lastTotalWidth;
	if (th<=0) th = this.lastTotalHeight;
	
	if (m.df && m.df.length>0) this.sourceCtrl.innerHTML = m.df.join(',');

	var chartW = op((100-m.mr-m.ml)*tw);
	var chartH = op((100-m.mb-m.mt)*th);
	
	this.chartArea.setPosition(op(m.ml*tw),op(m.mt*th));
	this.chartArea.setSizePt(chartW,chartH);
	this.chartArea.setImageURL(this.icons[m.cIdx]);

	this.chartTitle.setPosition(op(m.tx*tw),op(m.ty*th));

	this.chartKey.setPosition(op(m.lx*tw),op(m.ly*th));
	this.chartKey.setSizePt(op(m.lw*tw),op(m.lh*th));

	this.xAxisStaticLabelCtrl.value=m.XA.lbl;
	if (m.XA.fld && m.XA.fld.length>0) this.xAxisDynamicSrcCtrl.value=m.XA.fld.join(',');
	this.xAxisTitleCtrl.value=m.XA.title;
	this.xAxisTextAnchorCtrl.value=m.XA.txtAnchor;
	this.xAxisLabelAngleCtrl.value=m.XA.lblAngle;
	this.xAxisMnVDCtrl.value=m.XA.mnVD;
	this.xAxisMGLCtrl.value=m.XA.mGL;
	
	this.yAxisStaticLabelCtrl.value=m.YA.lbl;
	if (m.YA.lbl && m.YA.lbl.length>0) this.yAxisDynamicSrcCtrl.value=m.YA.fld.join(',');
	this.yAxisTitleCtrl.value=m.YA.title;
	this.yAxisTextAnchorCtrl.value=m.YA.txtAnchor;
	this.yAxisLabelAngleCtrl.value=m.YA.lblAngle;
	this.yAxisMnVDCtrl.value=m.YA.mnVD;
	this.yAxisMGLCtrl.value=m.YA.mGL;
}

ClientMethod synchAvatars() [ Language = javascript ]
{
	var m = this.model;
	var e=this.chartArea.gc;
	var a=this.findElement("area");
	var tw = a.offsetWidth;
	var th = a.offsetHeight;

	if (tw<=0) tw = this.lastTotalWidth;
	if (th<=0) th = this.lastTotalHeight;
	
	var ux = ZRU.convertToPixels(e.sizeLeft+"pt");
	var uy = ZRU.convertToPixels(e.sizeTop+"pt");
	var uw = ZRU.convertToPixels(e.sizeWidth+"pt");
	var uh = ZRU.convertToPixels(e.sizeHeight+"pt");
	
	m.ml = Math.round(100*ux/tw);
	m.mt = Math.round(100*uy/th);
	m.mr = Math.round(100*(tw-(ux+uw))/tw);
	m.mb = Math.round(100*(th-(uy+uh))/th);

	var e=this.chartKey.gc;
	var ux = ZRU.convertToPixels(e.sizeLeft+"pt");
	var uy = ZRU.convertToPixels(e.sizeTop+"pt");
	var uw = ZRU.convertToPixels(e.sizeWidth+"pt");
	var uh = ZRU.convertToPixels(e.sizeHeight+"pt");
	m.lx = Math.round(100*ux/tw);
	m.ly = Math.round(100*uy/th);
	m.lw = Math.round(100*uw/tw);
	m.lh = Math.round(100*uh/th);

	var e=this.chartTitle.gc;
	var ux = ZRU.convertToPixels(e.sizeLeft+"pt");
	var uy = ZRU.convertToPixels(e.sizeTop+"pt");
	m.tx = Math.round(100*ux/tw);
	m.ty = Math.round(100*uy/th);
	
	this.constrainPoints();
}

ClientMethod setModel(m) [ Language = javascript ]
{
	for (var p in m) {
		this.model[p] = m[p];
	}
	this.updateFromModel();
}

ClientMethod setTitle() [ Language = javascript ]
{
	this.synchModelToControls();
}

ClientMethod setLegendVisible() [ Language = javascript ]
{
	this.synchModelToControls();
	if (this.legendCtrl.checked) {
		this.model.sLgd=1;
		this.model.lx = 10;
		this.model.ly = 10;
		this.model.lw = 10;
		this.model.lh = 10;
	}
	else  this.model.sLgd=0;
	this.updateFromModel();
	this.synchAvatars();
}

ClientMethod setLabelVisible() [ Language = javascript ]
{
	if (this.labelCtrl.checked) this.model.sLbl=1;
	else  this.model.sLbl=0;
}

ClientMethod setChartType(tag) [ Language = javascript ]
{
	this.synchModelToControls();
	var m = this.model;
	m.cIdx = tag;
	for (var i=0;i<this.picks.length;i++) this.picks[i].style.background="";
	var d = this.picks[tag];
	d.style.background = "#e8e7e2";
	m.c = this.ids[tag].substring(0,this.ids[tag].length-1);
	this.updateFromModel();
	this.synchAvatars();
}

ClientMethod synchModelToControls() [ Language = javascript ]
{
	this.synchAvatars();
	var oldM = this.model;
	var m ={};
	m.c = oldM.c; 								// plot type
	m.cIdx = oldM.cIdx; 						// internal index
	m.n = this.titleCtrl.value; 				// title
	m.grp = this.sourceCtrl.value;				// core XML grouping
	if (this.dataGroupCtrl.checked) m.udg = 1;	// project as dataGroup rather than series group
	else m.udg = 0;
	m.df = this.dataFldsCtrl.value.split(",");	// dataFields
	m.sn = this.seriesCtrl.value;				// seriesNames
	if (this.legendCtrl.checked) m.sLgd = 1;	// legendVisible
	else m.sLgd = 0;
	if (this.labelCtrl.checked) m.sLbl = 1;		// labelsVisible
	else m.sLbl = 0;
	if (this.bwCtrl.checked) m.bw = 1;			// default to black and white settings
	else m.bw = 0;
	
	m.mt = oldM.mt;				// marginTop
	m.mr = oldM.mr;				// marginRight
	m.ml = oldM.ml;				// marginLeft
	m.mb = oldM.mb;				// marginBottom
	m.lx = oldM.lx;				// legendX
	m.ly = oldM.ly;				// legendY
	m.lh = oldM.lh;				// legendHeight
	m.lw = oldM.lw;				// legendWidth
	m.tx = oldM.tx;				// titleX
	m.ty = oldM.ty;				// titleY

	m.XA = {};				// XAxis

	m.XA.lbl=this.xAxisStaticLabelCtrl.value;			// Static labels
	m.XA.fld=this.xAxisDynamicSrcCtrl.value.split(",");	// Dynamic label field
	m.XA.title=this.xAxisTitleCtrl.value;				// Axis Title
	m.XA.txtAnchor=this.xAxisTextAnchorCtrl.value;		// Text Anchor
	m.XA.lblAngle=this.xAxisLabelAngleCtrl.value;		// Label angle
	m.XA.mnVD=this.xAxisMnVDCtrl.value;					// Minimum value displacement
	m.XA.mGL=this.xAxisMGLCtrl.value;					// Major Grid lines
	
	m.YA = {};              // Y Axis
	
	m.YA.lbl=this.yAxisStaticLabelCtrl.value;			// Static labels
	m.YA.fld=this.yAxisDynamicSrcCtrl.value.split(",");	// Dynamic label field
	m.YA.title=this.yAxisTitleCtrl.value;				// Axis Title
	m.YA.txtAnchor=this.yAxisTextAnchorCtrl.value;		// Text Anchor
	m.YA.lblAngle=this.yAxisLabelAngleCtrl.value;		// Label angle
	m.YA.mnVD=this.yAxisMnVDCtrl.value;					// Minimum value displacement
	m.YA.mGL=this.yAxisMGLCtrl.value;					// Major Grid lines
	
	this.model = m;
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var m ={};
	m.c = "column";   		// plot type
	m.cIdx = 2; 			// internal index
	m.n = "Untitled Plot";	// title
	m.grp = "";				// core XML grouping
	m.udg = 0;				// project as dataGroup rather than series group
	m.df = []; 				// dataFields
	m.sn = "";				// seriesNames
	m.sLgd = 0;				// legendVisible
	m.sLbl = 0;				// labelsVisible
	m.bw = 1;				// default to black and white settings
	m.mt = 6;				// marginTop
	m.mr = 2;				// marginRight
	m.ml = 10;				// marginLeft
	m.mb = 10;				// marginBottom
	m.tx = 50;				// titleX = MOVE TO AXIS RECORD
	m.ty = 5;				// titleY = MOVE TO AXIS RECORD
	m.lx = 0;				// legendX
	m.ly = 0;				// legendY
	m.lh = 20;				// legendHeight
	m.lw = 20;				// legendWidth
	m.XA = {};				// XAxis
	m.XA.lbl="";			// Static labels
	m.XA.fld=[];			// Dynamic label field
	m.XA.title="";			// Axis Title
	m.XA.txtAnchor="begin";	// Text Anchor
	m.XA.lblAngle=0;		// Label angle
	m.XA.mnVD=0;			// Minimum value displacement
	m.XA.mGL=false;			// Major Grid lines
	m.YA = {};              // Y Axis
	m.YA.lbl="";			// Static labels
	m.YA.fld=[];			// Dynamic label field
	m.YA.title="";			// Axis Title
	m.YA.txtAnchor="begin";	// Text Anchor
	m.YA.lblAngle=0;		// Label angle
	m.YA.mnVD=0;			// Minimum value displacement
	m.YA.mGL=false;			// Major Grid lines

	this.model = m;
	
	this.ids = ["barP","columnP","hilowP","lineP","pieP","stackedBarP","stackedColumnP"];
	this.captions = ["Bar Chart","Column Chart","High-Low Chart","Line Chart","Pie Chart","Stacked Bar Chart","Stacked Column Chart"];
	this.icons = [
					"csp/broker/portal/chart_bar_pivot.png",
					"csp/broker/portal/chart_bar.png",
					"csp/broker/portal/chart_hilow.png",
					"csp/broker/portal/chart_line.png",
					"csp/broker/portal/chart_pie.png",
					"csp/broker/portal/chart_bar_pivot_stacked.png",
					"csp/broker/portal/chart_bar_stacked.png"
	];
	
	this.ctrl = this.findElement("sidebar");
	this.ctrl.appendChild(this.makeChartTypePick());
	
	this.sourceCtrl = this.findElement("sourceCtrl");
	this.dataGroupCtrl = this.findElement("dataGroupCtrl");
	this.dataFldsCtrl = this.findElement("dataFldsCtrl");
	
	this.titleCtrl = this.findElement("titleCtrl");
	this.legendCtrl = this.findElement("legendCtrl");
	this.labelCtrl = this.findElement("labelCtrl");
	this.seriesCtrl = this.findElement("seriesCtrl");
	this.bwCtrl = this.findElement("bwCtrl");
	
	this.chartTab = this.findElement("chartTab");
	this.xAxisTab = this.findElement("xAxisTab");
	this.yAxisTab = this.findElement("yAxisTab");
	
	this.chartPanel = this.findElement("chartCtrl");
	this.xAxisPanel = this.findElement("xAxisCtrl");
	this.yAxisPanel = this.findElement("yAxisCtrl");

	this.xAxisTitleCtrl = this.findElement("xAxisTitleCtrl");
	this.xAxisStaticLabelCtrl = this.findElement("xAxisStaticLabelCtrl");
	this.xAxisDynamicSrcCtrl = this.findElement("xAxisDynamicSrcCtrl");
	this.xAxisTextAnchorCtrl = this.findElement("xAxisTextAnchorCtrl");
	this.xAxisLabelAngleCtrl = this.findElement("xAxisLabelAngleCtrl");
	this.xAxisMnVDCtrl = this.findElement("xAxisMnVDCtrl");
	this.xAxisMGLCtrl = this.findElement("xAxisMGLCtrl");

	this.yAxisTitleCtrl = this.findElement("yAxisTitleCtrl");
	this.yAxisStaticLabelCtrl = this.findElement("yAxisStaticLabelCtrl");
	this.yAxisDynamicSrcCtrl = this.findElement("yAxisDynamicSrcCtrl");
	this.yAxisTextAnchorCtrl = this.findElement("yAxisTextAnchorCtrl");
	this.yAxisLabelAngleCtrl = this.findElement("yAxisLabelAngleCtrl");
	this.yAxisMnVDCtrl = this.findElement("yAxisMnVDCtrl");
	this.yAxisMGLCtrl = this.findElement("yAxisMGLCtrl");
	
	setTimeout("zenPage.getComponent("+this.index+").initArea();",250); // Defer this until critical stuff loaded
}

ClientMethod addChartArea(x, y, w, h, url) [ Language = javascript ]
{
	var n = new ZRU.BannerBoxItem.create();
	this.area.appendChild(n.base);
	n.setGC(this.initGC());
	n.setContents(x,y,w,h,"image",url);
	ZLM.setLocalAttribute(n.box.base,"oncontextMenu","");
	ZLM.setLocalAttribute(n.imageDiv,"oncontextMenu","");
	this.chartArea = n;
	return(n);
}

ClientMethod addChartTitle(x, y, w, h) [ Language = javascript ]
{
	var n = new ZRU.BannerTextItem.create();
	this.area.appendChild(n.base);
	var gc = this.initGC();
	gc.textSize="10"; 
	n.setGC(gc);
	
	n.setContents('"Title');
	n.setPosition(x,y);

	this.chartTitle = n;
	return(n);
}

ClientMethod addChartKey(x, y, w, h) [ Language = javascript ]
{
	var n = new ZRU.BannerTextItem.create();
	this.area.appendChild(n.base);
	var dgc = this.initGC();
	var gc = {};
	for (var p in dgc) gc[p] = dgc[p];
	
	gc.strokeColor="#000000";
	gc.fillColor="#a0a0a0";
	gc.fillOpacity=100;
	gc.textColor="#000000";
	gc.textSize=8;
	gc.textJustify="center";
	n.setGC(gc);
	
	n.setContents('!KEY');
	n.setPosition(x,y);
	n.setSizePt(w,h);
	this.chartKey = n;
	return(n);
}

ClientMethod initArea() [ Language = javascript ]
{
	var op = 1.85;
	var z = ZRU.convertToPoints(20*op);
	var lx = ZRU.convertToPoints((100-21)*op);
	var ly = ZRU.convertToPoints(10*op);
	
	var x = Math.round(6*op);
	var y = Math.round(10*op);
	var w = Math.round((100-6-2)*op);
	var h = Math.round((100-10-6)*op);
	var url = "csp/broker/portal/chart_bar.png";
	this.area = this.findElement("area");
	this.addChartArea(x,y,w,h,url);
	this.addChartTitle(0,0);
	this.addChartKey(lx,ly,z,z);
	this.updateFromModel();
}

ClientMethod initGC() [ Language = javascript ]
{
	var g = {
		'strokeApropos':true,
		'strokeColor':'#000000',
		'strokeOpacity':1,
		'strokeWidth':1,
		'strokeStyle':'solid',
		
		'fillApropos':true,
		'fillColor':'#ffffff',
		'fillOpacity':0,

		'textApropos':true,
		'textColor':'#000000',
		'textOpacity':1,
		'textBold':false,
		'textItalic':false,
		'textUnderline':false,
		'textSize':12,
		'textJustify':'left',
		'textFont':'sans-serif',

		'tableApropos':true,
		'tableBorder':false,
		'tableHeaderBorder':false,
		'tableHeaderBodyDivider':false,
		'tableHeaderColumnDivider':false,
		'tableBodyColumnDivider':false,
		'tableBodyRowDivider':false,
		'tableZebraStripe':false,
		'tableZebraColor':'#bfffcf',
		
		'sizeApropos':false,
		'sizeWidth':0,
		'sizeHeight':0,
		'sizeTop':0,
		'sizeLeft':0
	}
	if (zenPage._editor && zenPage._editor._defaultGC) {
		var src = zenPage._editor._defaultGC;
		for (var p in src) g[p] = src[p];
	}
	return(g);
}

ClientMethod handleOkay() [ Language = javascript ]
{
	this.synchModelToControls();
	if (this.cbStr) eval(this.cbStr);
	this.closeDialog();
}

ClientMethod handleCancel() [ Language = javascript ]
{
	this.closeDialog();
}

ClientMethod closeDialog() [ Language = javascript ]
{
	if (this.parent.popAway) this.parent.popAway();
}

ClientMethod setOkayCB(cbStr) [ Language = javascript ]
{
	this.cbStr = cbStr;
}

ClientMethod getModel() [ Language = javascript ]
{
	this.synchModelToControls();
	return(this.model);
}

}
