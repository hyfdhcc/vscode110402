/// Page setup control
Class %DeepSee.Report.UI.pageSetupControl Extends %ZEN.Component.control [ LegacyInstanceContext, System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property pageSizePrompt As %ZEN.Datatype.caption [ InitialExpression = "Page size:" ];

Property orientationPrompt As %ZEN.Datatype.caption [ InitialExpression = "Orientation:" ];

Property landscapeOption As %ZEN.Datatype.caption [ InitialExpression = "Landscape" ];

Property portraitOption As %ZEN.Datatype.caption [ InitialExpression = "Portrait" ];

Property marginsPrompt As %ZEN.Datatype.caption [ InitialExpression = "Margins:" ];

Property topPrompt As %ZEN.Datatype.caption [ InitialExpression = "Top:" ];

Property bottomPrompt As %ZEN.Datatype.caption [ InitialExpression = "Bottom:" ];

Property leftPrompt As %ZEN.Datatype.caption [ InitialExpression = "Left:" ];

Property rightPrompt As %ZEN.Datatype.caption [ InitialExpression = "Right:" ];

Property headerPrompt As %ZEN.Datatype.caption [ InitialExpression = "Header:" ];

Property footerPrompt As %ZEN.Datatype.caption [ InitialExpression = "Footer:" ];

Property runningHeadersPrompt As %ZEN.Datatype.caption [ InitialExpression = "Running Headers:" ];

Property omitFirstPagePrompt As %ZEN.Datatype.caption [ InitialExpression = "Omit on first page" ];

Property omitLastPagePrompt As %ZEN.Datatype.caption [ InitialExpression = "Omit on last page" ];

Property editHeaderReserve As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property editFooterReserve As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property stockDefaultColor As %ZEN.Datatype.caption [ InitialExpression = "White" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.pageSetup {
	position:relative;
	top:0px;
	left:0px;
	height:300px;
	width:600px;
	border:1px solid #000042;
	background:#eeeeee;
}

.pageSetUpFormBox {
	position:absolute;
	top:5%;
	left:2.5%;
	width:45%;
	height:90%;
}
/*	border:1px solid #000042;*/

.pageSetupPromptBox {
	font:bold 14px Arial;
	display:block;
	width:100%;
	height:25px;
	position:relative;
}

.pageSetupPromptCol1 {
	width:15%;
	height:100%;
	position:absolute;
	left:10%;
	top:0px;
}

.pageSetupPromptCol2 {
	width:20%;
	height:100%;
	position:absolute;
	left:25%;
	top:0px;
	white-space:nowrap;
	overflow:visible;
}

.pageSetupPromptCol3 {
	width:20%;
	height:100%;
	position:absolute;
	right:25%;
	top:0px;
}

.pageSetupPromptCol4 {
	width:20%;
	height:100%;
	position:absolute;
	right:0%;
	top:0px;
}

.pageSetupSelector {
	width:60%;
	position:absolute;
	top:0px;
	right:0px;
}

.pageSetupPreviewBox {
	position:absolute;
	top:5%;
	right:2.5%;
	width:45%;
	height:90%;
	border:1px solid #000042;
	background-image:url('csp/broker/images/grad-gray-10x500.png');
	background-color:#404040;
	background-repeat:repeat-x;
}

.pageSetupAvatar {
	position:absolute;
	top:2%;
	left:14%;
	height:96%;
	width:72%;
	border:1px solid #000042;
	background:#fefeff;
	display:none;
}

/*  The Printable Area is the box INSIDE the bounds of the left, right, top and bottom 
 *  margins.  Its geometry is calculated dynamically.
 */
.pageSetupPrintableArea {
	position:absolute;
	display:block;
}

/*  The Body Area is the area left on the printable page once the header and footer 
 *  reserves have been taken into account.  Its width is the same as the printable area
 *  but its height is calculated dynamically
 */
.pageSetupBodyArea {
	position:absolute;
	display:block;
	left:3px;
	right:1px;
	z-index:-1;
}

.pageSetupMarginH {
	position:absolute;
	top:0%;
	width:3px;
	height:100%;
	background:red;
	cursor: col-resize;
}

.pageSetupMarginV {
	position:absolute;
	left:0%;
	width:100%;
	height:3px;
	font-size:1px;
	line-height:0px;
	background:red;
	cursor: row-resize;
}

.pageSetupReserveV {
	position:absolute;
	left:0%;
	width:100%;
	height:3px;
	font-size:1px;
	line-height:0px;
	background:green;
	cursor:row-resize;
}

/* leftovers below */

.spinner {
	position:relative;
	top:0px;
	left:0px;
	height:20px;
	width:100%;
}

.spinnerWinDiv {
	border:1px solid #575757;
	overflow:hidden;
	position:absolute;
	top:1px;
	right:14px;
	height:16px;
	width:50px;
}

.spinnerWinBGDiv {
	width:100%;
	height:20px;
	background:#ffffff;
}

.spinnerUnitDiv {
	position:absolute;
	top:2px;
	right:0px;
	height:100%;
	width:25px;
	font:12px sans-serif;
	color:#000077;
}

.spinnerValueDiv {
	border:none;
	height:16px;
	width:59px;
	font:12px sans-serif;
	color:#000077;
	position:absolute;
	top:0px;
	right:26px;
	text-align:right;
}

.spinnerIncDiv {
	position:absolute;
	top:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/incSpinner.png);
}

.spinnerIncDivActive {
	position:absolute;
	top:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/incSpinnerB.png);
}

.spinnerDecDiv {
	position:absolute;
	bottom:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/decSpinner.png);
}

.spinnerDecDivActive {
	position:absolute;
	bottom:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/decSpinnerB.png);
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="pageSetup" > 
		

		<div id="#(..%MakeId("form"))#" class="pageSetUpFormBox" >
		<div id="#(..%MakeId("line1"))#" class="pageSetupPromptBox" >
			#(..pageSizePrompt)#
			<select id="#(..%MakeId("paper"))#" class="pageSetupSelector" onchange="this.controller.selectPaperCB(this);" > 
			</select>
		</div>
		<div id="#(..%MakeId("line2"))#" class="pageSetupPromptBox" >
			#(..orientationPrompt)#
			<select id="#(..%MakeId("orientation"))#" class="pageSetupSelector" onchange="this.controller.selectOrientationCB(this);" > 
				<option value="portrait">#(..portraitOption)#</option>
				<option value="landscape">#(..landscapeOption)#</option>
			</select>
		</div>
		<div id="#(..%MakeId("line3"))#" class="pageSetupPromptBox" >
			#(..marginsPrompt)#
		</div>
		<div id="#(..%MakeId("line4"))#" class="pageSetupPromptBox" >
			<div class="pageSetupPromptCol1">#(..leftPrompt)#</div>
			<div class="pageSetupPromptCol2">

		<div id="#(..%MakeId("leftBase"))#" class="spinner" > 
		<div id="#(..%MakeId("leftIncrement"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB('left');" onmouseup="this.controller.stopCountCB('left');" ></div>
		<div id="#(..%MakeId("leftDecrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB('left');" onmouseup="this.controller.stopCountCB('left');"></div>
		<div id="#(..%MakeId("leftValueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("leftBackground"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("leftUnitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("leftValueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate('left',event);" onblur="this.controller.validate('left',event);" ></input>
		</div>
		</div>

			</div>
			<div class="pageSetupPromptCol3">#(..rightPrompt)#</div>
			<div class="pageSetupPromptCol4">

		<div id="#(..%MakeId("rightBase"))#" class="spinner" > 
		<div id="#(..%MakeId("rightIncrement"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB('right');" onmouseup="this.controller.stopCountCB('right');" ></div>
		<div id="#(..%MakeId("rightDecrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB('right');" onmouseup="this.controller.stopCountCB('right');"></div>
		<div id="#(..%MakeId("rightValueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("rightBackground"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("rightUnitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("rightValueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate('right',event);" onblur="this.controller.validate('right',event);" ></input>
		</div>
		</div>

			</div>
		</div>
		<div id="#(..%MakeId("line5"))#" class="pageSetupPromptBox" >
			<div class="pageSetupPromptCol1">#(..topPrompt)#</div>
			<div class="pageSetupPromptCol2">

		<div id="#(..%MakeId("topBase"))#" class="spinner" > 
		<div id="#(..%MakeId("topIncrement"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB('top');" onmouseup="this.controller.stopCountCB('top');" ></div>
		<div id="#(..%MakeId("topDecrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB('top');" onmouseup="this.controller.stopCountCB('top');"></div>
		<div id="#(..%MakeId("topValueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("topBackground"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("topUnitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("topValueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate('top',event);" onblur="this.controller.validate('top',event);" ></input>
		</div>
		</div>

			</div>
			<div class="pageSetupPromptCol3">#(..bottomPrompt)#</div>
			<div class="pageSetupPromptCol4">

		<div id="#(..%MakeId("bottomBase"))#" class="spinner" > 
		<div id="#(..%MakeId("bottomIncrement"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB('bottom');" onmouseup="this.controller.stopCountCB('bottom');" ></div>
		<div id="#(..%MakeId("bottomDecrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB('bottom');" onmouseup="this.controller.stopCountCB('bottom');"></div>
		<div id="#(..%MakeId("bottomValueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("bottomBackground"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("bottomUnitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("bottomValueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate('bottom',event);" onblur="this.controller.validate('bottom',event);" ></input>
		</div>
		</div>

			</div>
		</div>
		<div id="#(..%MakeId("line6"))#" class="pageSetupPromptBox" >
			<div id="#(..%MakeId("headerPrompt"))#" class="pageSetupPromptCol1">#(..headerPrompt)#</div>
			<div class="pageSetupPromptCol2">

		<div id="#(..%MakeId("headerBase"))#" class="spinner" > 
		<div id="#(..%MakeId("headerIncrement"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB('header');" onmouseup="this.controller.stopCountCB('header');" ></div>
		<div id="#(..%MakeId("headerDecrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB('header');" onmouseup="this.controller.stopCountCB('header');"></div>
		<div id="#(..%MakeId("headerValueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("headerBackground"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("headerUnitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("headerValueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate('header',event);" onblur="this.controller.validate('header',event);" ></input>
		</div>
		</div>

			</div>
			<div id="#(..%MakeId("footerPrompt"))#" class="pageSetupPromptCol3">#(..footerPrompt)#</div>
			<div class="pageSetupPromptCol4">

		<div id="#(..%MakeId("footerBase"))#" class="spinner" > 
		<div id="#(..%MakeId("footerIncrement"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB('footer');" onmouseup="this.controller.stopCountCB('footer');" ></div>
		<div id="#(..%MakeId("footerDecrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB('footer');" onmouseup="this.controller.stopCountCB('footer');"></div>
		<div id="#(..%MakeId("footerValueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("footerBackground"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("footerUnitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("footerValueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate('footer',event);" onblur="this.controller.validate('footer',event);" ></input>
		</div>
		</div>

			</div>
			
			<div id="#(..%MakeId("line7"))#" class="pageSetupPromptBox" >
			#(..runningHeadersPrompt)#
			</div>
		<div id="#(..%MakeId("line8"))#" class="pageSetupPromptBox" >
			<div class="pageSetupPromptCol1">
			<input id="#(..%MakeId("omitFirstValueDiv"))#" type="checkbox" onchange="this.controller.configureHeadersCB(this,0);"> </input>
			</div>
			<div class="pageSetupPromptCol2">#(..omitFirstPagePrompt)#</div>
		</div>
		<div id="#(..%MakeId("line9"))#" class="pageSetupPromptBox" >
			<div class="pageSetupPromptCol1">
			<input id="#(..%MakeId("omitLastValueDiv"))#" type="checkbox" onchange="this.controller.configureHeadersCB(this,1);"> </input>
			</div>
			<div class="pageSetupPromptCol2">#(..omitLastPagePrompt)#</div>
		</div>
		
		</div>
	>
	
	&html<
		</div>
				
		<div id="#(..%MakeId("preview"))#" class="pageSetupPreviewBox" >
			<div id="#(..%MakeId("pageAvatar"))#" class="pageSetupAvatar" >
				<div id="#(..%MakeId("leftHandle"))#" class="pageSetupMarginH"></div>
				<div id="#(..%MakeId("rightHandle"))#" class="pageSetupMarginH" style="left:90%" ></div>
				<div id="#(..%MakeId("topHandle"))#" class="pageSetupMarginV"></div>
				<div id="#(..%MakeId("bottomHandle"))#" class="pageSetupMarginV" ></div>
				<div id="#(..%MakeId("printableArea"))#" class="pageSetupPrintableArea" >
					<div id="#(..%MakeId("headerHandle"))#" class="pageSetupReserveV" ></div>
					<div id="#(..%MakeId("footerHandle"))#" class="pageSetupReserveV" ></div>
					<div id="#(..%MakeId("bodyArea"))#" class="pageSetupBodyArea" style="background:cyan">
					</div>
				</div>
			</div>
		</div>
		</div>
	
	>
}

Method GetStockPaperOptions() As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC = ##class(%DeepSee.Utils).%GetPaperSizeList(.tPage)

	Set tValueList = ""
	Set tDisplayList = ""
	Set k = $O(tPage(""))
	While (k'="") {
		Set tDisplayList = tDisplayList _ $S(tDisplayList="":"",1:",") _ $LG(tPage(k),1) _ "^" _ $LG(tPage(k),2)
		Set k = $O(tPage(k))
	}
	Set rtn = tDisplayList
	Quit rtn
}

/// Set the point size of the page based on the logical name of the physical paper type
/// Note that the nominal page width and height always assume a portrait orientation
ClientMethod selectPaperCB(who) [ Language = javascript ]
{
	var o = this.valueObj;
	if (!o) return;
	o.paper = who.value.toLowerCase();
	var stockDetail = this.getStdStockDetails(who.value);
	if (stockDetail) {
		o.width = stockDetail.minorExtent;
		o.height = stockDetail.majorExtent;
		o.extentUnits = stockDetail.extentUnits;
		o.units = stockDetail.stockUnits;
	}
	this.updateAvatar();
}

ClientMethod selectOrientationCB(who) [ Language = javascript ]
{
	if (!this.valueObj) return;
	this.valueObj.orient = who.value;
	this.updateAvatar();
}

ClientMethod configureHeadersCB(who, which) [ Language = javascript ]
{
	var props = ["omitFirst","omitLast"];
	if (!this.valueObj) return;
	var flag = 0;
	if (who.checked) flag=1;
	this.valueObj[props[which]]=flag;
	this.updateAvatar();
}

ClientMethod getPixelToPointRatioH() [ Language = javascript ]
{
	var pageHeightPt = this.valueObj.height;
	if (this.valueObj.orient=="landscape") pageHeightPt = this.valueObj.width;
	return(this._pageHeightPx/pageHeightPt);
}

ClientMethod getPixelToPointRatioV() [ Language = javascript ]
{
	var pageWidthPt = this.valueObj.width;
	if (this.valueObj.orient=="landscape") pageWidthPt = this.valueObj.height;
	return(this._pageWidthPx/pageWidthPt);
}

ClientMethod computeBodyAreaSize() [ Language = javascript ]
{
	var bas = this._bodyArea.style;
	var boundsTop = this._headerHandle.offsetTop+3;
	if (!this.editHeaderReserve) boundsTop = 3;
	var boundsLow = this._footerHandle.offsetTop-1;
	if (!this.editFooterReserve) boundsLow = this._bottomHandle.offsetTop-this._topHandle.offsetTop;
	bas.top = boundsTop+"px";
	bas.height = (boundsLow-boundsTop)+"px";
}

ClientMethod setDragLineDisplay(prefix, value) [ Language = javascript ]
{
	var stockHeightPts = this.valueObj.height;
	var stockWidthPts = this.valueObj.width;
	if (this.valueObj.orient=="landscape" && stockHeightPts>stockWidthPts) {
		var tmp = stockWidthPts;
		stockWidthPts = stockHeightPts;
		stockHeightPts = tmp;
	}
	var avatarHeightPx = this._page.offsetHeight;
	var avatarWidthPx = this._page.offsetWidth;
	var pas = this._printableArea.style;
	var bas = this._bodyArea.style;
	switch (prefix) {
		case 'top': 
			var ofs = (value/stockHeightPts)*avatarHeightPx;			
			this._topHandle.style.top = ofs+"px";
			pas.top = ofs+"px";
			pas.height = (this._bottomHandle.offsetTop-ofs)+"px";
			this.computeBodyAreaSize();
			return;
		case 'bottom':
			var ofs = (value/stockHeightPts)*avatarHeightPx;
			this._bottomHandle.style.top = "";
			this._bottomHandle.style.bottom = ofs+"px";
			pas.height = (this._pageHeightPx-ofs-this._topHandle.offsetTop)+"px";
			this.computeBodyAreaSize();
			return;
		case 'header':
			if (this.editHeaderReserve) {
				this._headerHandle.style.display = "block";
				var ofs = (value/stockHeightPts)*avatarHeightPx;
				this._headerHandle.style.top = ofs+"px";
				this.computeBodyAreaSize();
			}
			else {
				this._headerHandle.style.display = "none";
				this.computeBodyAreaSize();
			}
			return;
		case 'footer':
			if (this.editFooterReserve) {
				this._footerHandle.style.display = "block";
				var ofs = (value/stockHeightPts)*avatarHeightPx;
				this._footerHandle.style.top = "";
				this._footerHandle.style.bottom = ofs+"px";
				this.computeBodyAreaSize();
			}
			else {
				this._footerHandle.style.display = "none";
				this.computeBodyAreaSize();
			}				
			return;
		case 'left':
			var ofs = (value/stockWidthPts)*avatarWidthPx;
			if (ofs>this._rightHandle.offsetLeft) ofs=this._rightHandle.offsetLeft;
			this._leftHandle.style.left = ofs+"px";
			pas.left = ofs+"px";
			pas.width = (this._rightHandle.offsetLeft-ofs)+"px";
			return;
		case 'right':
			var ofs = (value/stockWidthPts)*avatarWidthPx;
			this._rightHandle.style.left = "";
			this._rightHandle.style.right = ofs+"px";
			var newW = this._rightHandle.offsetLeft-this._leftHandle.offsetLeft;
			if (newW<0) newW = 0;
			pas.width = newW+"px";
			return;
	}
}

ClientMethod updateConstraints() [ Language = javascript ]
{
	var o=this.valueObj;
	if (!o) return;
	if (!this.editHeaderReserve) o.header = 0;
	if (!this.editFooterReserve) o.footer = 0;
	
	// top, bottom, left, right, header, footer
	this.min={};
	// the easy ones...
	this.min['top'] = 0; // top of page
	this.min['header'] = 0 ; // top of printable area
	this.min['left'] = 0; // left edge of page
	this.min['bottom']= 0; // bottom of page
	this.min['footer']=0; // bottom of printable area
	this.min['right']=0; // right edge of page
	
	this.max={};
	this.max['top'] = (o.height-o.bottom-o.header-o.footer-1)*this.quantum;
	this.max['bottom']= (o.height-o.top-o.header-o.footer-1)*this.quantum;

	this.max['right'] = (o.width-o.left-1)*this.quantum;
	this.max['left'] = (o.width-o.right-1)*this.quantum;
	
	this.max['header'] = (o.height-o.bottom-o.top-o.footer-1)*this.quantum;
	this.max['footer'] = (o.height-o.bottom-o.top-o.header-1)*this.quantum;
}

ClientMethod updatePagePreview() [ Language = javascript ]
{
	var o=this.valueObj;
	if (!o) return;
	var box = this.findElement('preview');
	var aspect = o.width/o.height;
	var page = this._page;
	var s = page.style;
	var w = 1;
	var h = 1;
	s.display = "block";	
	if (o.orient=='landscape') {
		s.width="96%";
		s.left="2%";
		var w = page.offsetWidth;
		var h = Math.round(w*aspect);
		s.height = h+"px";
		s.top = (box.offsetHeight-h)/2+"px";
	}
	else {
		s.top = "2%";
		s.height="96%";
		var h = page.offsetHeight;
		var w = Math.round(h*aspect);
		s.width = w+"px";
		s.left = (box.offsetWidth-w)/2+"px";
	}
	this._pageWidthPx = w;
	this._pageHeightPx = h;	
	this._pprH = this.getPixelToPointRatioH();
	this._pprV = this.getPixelToPointRatioV();
	var spinners = ['left','right','top','bottom','header','footer'];
	for (var i=spinners.length-1;i > -1;i--) {
		var p = spinners[i];
		this.setUnitsString(p,o.units);
		if (o.units=="in") this.setQuantumUnit(1/72);  // 1 pt in inches
		else if (o.units=="mm") this.setQuantumUnit((1/0.0393700787)/72); // 1 pt in millimeters
		else this.setQuantum(1);
	}
	this.updateConstraints();
}

ClientMethod updateAvatar() [ Language = javascript ]
{
	var o=this.valueObj;
	if (o) {
		this.updatePagePreview();
		var div = this.findElement('paper');
		div.value = o.paper;
		var div = this.findElement('orientation');
		div.value = o.orient;
		var spinners = ['left','right','top','bottom','header','footer'];
		for (var i=spinners.length-1;i > -1;i--) {
			var p = spinners[i];
			this.setValueDisplay(p,o[p]);
			this.setDragLineDisplay(p,o[p]);
		}
		
		var div = this.findElement('omitFirstValueDiv');
		if (o.omitFirst) div.checked = true;
		else div.checked = false;

		var div = this.findElement('omitLastValueDiv');
		if (o.omitLast) div.checked = true;
		else div.checked = false;
	}
	this.value = ZLM.jsonStringify(this.valueObj);
}

ClientMethod initializeValueObject(v) [ Language = javascript ]
{
	if (!v) {
		var o = this.stdStock[0];
		this.valueObj = {paper:o.stockName.toLowerCase(), orient:'portrait', units:o.stockUnits, width:o.unitWidth, height:o.unitHeight, left:72, right:72, top:72, bottom:72, header:18, footer:18, omitFirst:1, omitLast:0 };
	}
	else this.valueObj = v;
	this.updateAvatar();
}

ClientMethod initializeSpinners() [ Language = javascript ]
{
	var spinners = ['left','right','top','bottom','header','footer'];	
	for (var i=spinners.length-1;i > -1;i--) {
		var p = spinners[i];
		var div = this.findElement(p+'Base');
		div.controller = this;
		var t = this.findElement(p+'ValueDiv');
		t.controller = this;
		var t = this.findElement(p+'Increment');
		t.controller = this;
		var t = this.findElement(p+'Decrement');
		t.controller = this;
	
		this.setUnitsString(p,this.valueObj.units);
		this.setValueDisplay(p,this.valueObj[p]);

		if (p=="header" && !this.editHeaderReserve) {
			div.style.display="none";
			var t = this.findElement("headerPrompt");
			t.style.display="none";
		}
		else if (p=="footer" && !this.editFooterReserve) {
			div.style.display="none";
			var t = this.findElement("footerPrompt");
			t.style.display="none";
		} 
	}
}

Method GetCustomStock() As %ZEN.Datatype.string [ ZenMethod ]
{
	Set model = ##class(%DeepSee.Report.Config.configData).GetCustomPageSizes()
	Quit model
}

ClientMethod buildStockArray() [ Language = javascript ]
{
	this.stdStock = [];
	var pageTypes = this.GetStockPaperOptions();
	var stock = pageTypes.split(',');
	var custom = ZLM.jsonParse(this.GetCustomStock(),1);
	if (custom && custom.length) {
		var cLen = custom.length;
		for (var i=0;i<cLen;i++) {
			var c = custom[i];
			stock.push(c.displayName+"^"+c.width+"x"+c.height+" "+c.units);
		}
	}
	var sLen = stock.length;
	for (var i=0;i<sLen;i++) {
		var o = {};
		var s1 = stock[i].split("^");
		o.stockName = s1[0];
		o.stockDesc = s1[1];
		o.stockColor = this.stockDefaultColor;
		var s2 = s1[1].split(" ");
		o.stockUnits = s2[1];
		o.extentUnits = "pt";
		var s3 = s2[0].split("x");
		var w = parseFloat(s3[0]);
		var h = parseFloat(s3[1]);
		if (h>w) o.orientation = "portrait";
		else o.orientation = "landscape";
		if (o.stockUnits == "in") { // convert to points
			w *= 72;
			h *= 72;
		}
		else if (o.stockUnits == "cm") { // convert to millimeters
			w *= 10;
			h *= 10;
		}
		o.unitWidth = w;
		o.unitHeight = h;
		if (o.stockUnits == "mm" || o.stockUnits == "cm") { // convert intental extends to points
			// already in mm just need to switch to points
			w *= 2.834645669;
			h *= 2.834645669;
		}
		if (h>w) {
			o.majorExtent = h;
			o.minorExtent = w;
		}
		else {
			o.majorExtent = w;
			o.minorExtent = h;
		}
		o.numCols = 1;
		o.numColOffset = "0";
		o.numRows = 1;
		o.numRowOffset = "0";
		this.stdStock.push(o);
	}
	this.stdStockLen = sLen;
}

/// Return the topology record associated with the given (localized)
/// stock name
ClientMethod getStdStockDetails(name) [ Language = javascript ]
{
	
	var n = name.toLowerCase();
	var l = this.stdStockLen;
	for (var i=0;i<l;i++) {
		var o = this.stdStock[i];
		if (n==o.stockName.toLowerCase()) return(o);
	}
	return(null);
}

ClientMethod initializePaperSelector() [ Language = javascript ]
{
	var l = this.stdStock.length;
	var h=[];
	for (var i=0;i<l;i++) {
		var o = this.stdStock[i];
		var s = '<option value="'+o.stockName.toLowerCase()+'">'+o.stockName+' ['+o.stockDesc+']</option>';
		h.push(s);
	}
	var sel = this.findElement('paper');
	sel.innerHTML = h.join("\n");
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.buildStockArray();
	this.initializePaperSelector();

	var t = this.findElement('paper');
	t.controller = this;
	var t = this.findElement('orientation');
	t.controller = this;

	this._page = this.findElement('pageAvatar');
	this._printableArea = this.findElement('printableArea');
	this._bodyArea = this.findElement('bodyArea');
	
	this._leftHandle = this.findElement("leftHandle");
	ZLM.registerDragItem(this._leftHandle,this);
	ZLM.setLocalAttribute(this._leftHandle,"onmousedown","ZLM.drag(this,event);");
	this._rightHandle = this.findElement("rightHandle");
	ZLM.registerDragItem(this._rightHandle,this);
	ZLM.setLocalAttribute(this._rightHandle,"onmousedown","ZLM.drag(this,event);");
	this._topHandle = this.findElement("topHandle");
	ZLM.registerDragItem(this._topHandle,this);
	ZLM.setLocalAttribute(this._topHandle,"onmousedown","ZLM.drag(this,event);");
	this._bottomHandle = this.findElement("bottomHandle");
	ZLM.registerDragItem(this._bottomHandle,this);
	ZLM.setLocalAttribute(this._bottomHandle,"onmousedown","ZLM.drag(this,event);");
	this._headerHandle = this.findElement("headerHandle");
	ZLM.registerDragItem(this._headerHandle,this);
	ZLM.setLocalAttribute(this._headerHandle,"onmousedown","ZLM.drag(this,event);");
	this._footerHandle = this.findElement("footerHandle");
	ZLM.registerDragItem(this._footerHandle,this);
	ZLM.setLocalAttribute(this._footerHandle,"onmousedown","ZLM.drag(this,event);");

	var t = this.findElement('omitFirstValueDiv');
	t.controller = this;

	var t = this.findElement('omitLastValueDiv');
	t.controller = this;
	
	this.initializeValueObject();
	this.initializeSpinners();
}

/*
 * DRAG MANAGEMENT
 */
ClientMethod indexDragElement(node) [ Language = javascript ]
{
	switch (node) {
		case this._topHandle: return(1);
		case this._bottomHandle: return(2);
		case this._headerHandle: return(3);
		case this._footerHandle: return(4); 
		case this._leftHandle: return(5);
		case this._rightHandle: return(6);
	}
	return(0);
}

ClientMethod startDrag(engine, wrapper) [ Language = javascript ]
{
	var p =this._page;
	this._maxDragX = this._pageWidthPx-3;
	this._maxDragY = this._pageHeightPx-3;
	this._minDragX = 0;
	this._minDragY = 0;
	
 	var idx = this.indexDragElement(wrapper.node);
 	if (idx==0) return;
	if (idx<5) { // horizontal guides
		this._maxDragX = 0;
		switch(idx) {
			case 1: // top margin
				var hOfsTop = this._headerHandle.offsetTop;
				if (!this.editHeaderReserve) hOfsTop = 0;
				var fOfsTop = this._footerHandle.offsetTop;
				if (!this.editFooterReserve) fOfsTop = this._printableArea.offsetHeight;
				this._maxDragY = this._bottomHandle.offsetTop-hOfsTop-(this._printableArea.offsetHeight-fOfsTop)-3;

				break;
			case 2: // bottom margin
				var hOfsTop = this._headerHandle.offsetTop;
				if (!this.editHeaderReserve) hOfsTop = 0;
				var fOfsTop = this._footerHandle.offsetTop;
				if (!this.editFooterReserve) fOfsTop = this._printableArea.offsetHeight;
				this._minDragY = hOfsTop+this._topHandle.offsetTop+(this._printableArea.offsetHeight-fOfsTop)+3;
				break;
			case 3: // header reserve
				this._maxDragY = this._footerHandle.offsetTop-3;
				break;
			case 4: // footer reserve
				this._minDragY = this._headerHandle.offsetTop+3;
				this._maxDragY = this._printableArea.offsetHeight-3;
				break;
		}
	}
	else if (idx<10) { // vertical guides
		this._maxDragY = 0;
		switch(idx) {
			case 5: // left margin
				this._maxDragX = this._rightHandle.offsetLeft-3;
				break;
			case 6: // right margin
				this._minDragX = this._leftHandle.offsetLeft+3;
				break;
		}
	}
	this._activeDragItem = idx;
}

ClientMethod constrainDragY(mgr, wrapper, newY) [ Language = javascript ]
{
	if (newY<this._minDragY) return(this._minDragY);
	if (newY>this._maxDragY) return(this._maxDragY);

	var n = wrapper.node;
	var o = this.valueObj;
	var pas = this._printableArea.style;
	var bas = this._bodyArea.style;
	var ot = n.offsetTop;
	var oh = n.offsetHeight;
	var ol = n.offsetLeft;
	var ow = n.offsetWidth;
	switch(this._activeDragItem) {
		case 1: // top margin
			var ofs = ot/this._pprV;
			pas.top = (ot+3)+"px";
			pas.height = (this._bottomHandle.offsetTop-ot-3)+"px";
			bas.top = (this._headerHandle.offsetTop+3)+"px";
			bas.height = (this._footerHandle.offsetTop - this._headerHandle.offsetTop-3)+"px";
			break;
		case 2: // bottom margin
			var ofs = (this._pageHeightPx-ot)/this._pprV;
			this.setDragLineDisplay('bottom',ofs);
			break;
		case 3: // header reserve
			var ofs = ot/this._pprV;
			bas.top = (ot+3)+"px";
			bas.height = (this._footerHandle.offsetTop-ot-3)+"px";
			break;
		case 4: // footer reserve
			var ofs = (this._printableArea.offsetHeight-ot)/this._pprV;
			this.setDragLineDisplay('footer',ofs);
			break;
		case 5: // left margin
			var ofs = ol/this._pprH;
			pas.left = (ol+3)+"px";
			pas.width = (this._rightHandle.offsetLeft-ol-3)+"px";
			break;
		case 6: // right margin
			var ofs = (this._page.offsetWidth+ow-ol)/this._pprH;
			pas.width = (ol-this._leftHandle.offsetLeft-3)+"px";
			break;
	}
	return(newY);
}

ClientMethod constrainDragX(mgr, wrapper, newX) [ Language = javascript ]
{
	if (newX<this._minDragX) return(this._minDragX);
	if (newX>this._maxDragX) return(this._maxDragX);
	return(newX);
}

ClientMethod endDrag(mgr, wrapper) [ Language = javascript ]
{
	var n = wrapper.node;
	var ot = n.offsetTop;
	var oh = n.offsetHeight;
	var ol = n.offsetLeft;
	var ow = n.offsetWidth;
	switch(this._activeDragItem) {
		case 1: // top margin
			var ofs = ot/this._pprV;
			this.setValueDisplay('top',ofs);
			break;
		case 2: // bottom margin
			var ofs = (this._pageHeightPx-ot)/this._pprV;
			this.setValueDisplay('bottom',ofs);
			break;
		case 3: // header reserve
			var ofs = ot/this._pprV;
			this.setValueDisplay('header',ofs);
			break;
		case 4: // footer reserve
			var ofs = (this._printableArea.offsetHeight-ot)/this._pprV;
			this.setValueDisplay('footer',ofs);
			break;
		case 5: // left margin
			var ofs = ol/this._pprH;
			this.setValueDisplay('left',ofs);
			break;
		case 6: // right margin
			var ofs = (this._page.offsetWidth+ow-ol)/this._pprH;
			this.setValueDisplay('right',ofs);
			break;
	}
	this.updateAvatar();
}

/// Set the quantum unit for incrementing and decrementing spinners.
/// This is effectively the decimal convertion from points to whatever
/// units are associated with the selected paper size
ClientMethod setQuantumUnit(n) [ Language = javascript ]
{
	this.quantum = n;
}

/// Set the displayed units to the given string within the given spinner object,
/// identified by prefix
ClientMethod setUnitsString(prefix, str) [ Language = javascript ]
{
	var d = this.findElement(prefix+'UnitDiv');
	d.innerHTML = str;
	if (!this._units) this._units = {}
	this._units[prefix] = str;
}

/// Set the value of one of the many spinners, identified by prefix code.
/// The internal value is in points, however the display value is coverted to
/// either millimeters or inches depending on paper selection
ClientMethod setValueDisplay(prefix, v) [ Language = javascript ]
{
	this.valueObj[prefix] = v;
	var d = this.findElement(prefix+'ValueDiv');
	var u = this._units[prefix];
	var dispValue = Math.round(v)*this.quantum;
	if (u=='%') dispValue = v;
	if (u=='in') {
		dispValue = Math.round(dispValue*1000)/1000;
	}
	else if (u=='mm' || u=='%') {
		dispValue = Math.round(dispValue*10)/10;
	}
	d.value = dispValue;
}

/// Confirm that the entered number meets the current contraints applicable to the
/// given spinner, identified by prefix code.
ClientMethod validate(prefix, e) [ Language = javascript ]
{
	if (e.type=='blur' || (e.type=='keyup' && e.which==13)) {
		var t = this.findElement(prefix+"ValueDiv");
		var v=parseFloat(t.value);
		if (isNaN(v)|| v==null || v<this.min[prefix]) v=this.min[prefix];
		if (v>this.max[prefix]) v=this.max[prefix];
		var ptValue = Math.round(v/this.quantum);
		this.valueObj[prefix]= ptValue;
		this.setValueDisplay(prefix,ptValue);

		this.setDragLineDisplay(prefix,ptValue);
		this.updateConstraints();
	
		if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
		this.updateAvatar();
	}
}

ClientMethod autoCount(prefix, time) [ Language = javascript ]
{
	this.incrementDelay = 200;
	time+=3;
	var delay = this.incrementDelay-time;
	if (delay<1) delay=10;
	this.autoIncDec(prefix);
	if (this._countDelta!=0) setTimeout("zenPage.getComponent("+this.index+").autoCount('"+prefix+"',"+time+")",delay);
}

ClientMethod countUpCB(prefix) [ Language = javascript ]
{
	var d = this.findElement(prefix+'Increment');
	d.className = "spinnerIncDivActive";
	this._countDelta= this.quantum;
	this.autoCount(prefix,0);
}

ClientMethod countDownCB(prefix) [ Language = javascript ]
{
	var d = this.findElement(prefix+'Decrement');
	d.className = "spinnerDecDivActive";
	this._countDelta= -this.quantum;
	this.autoCount(prefix,0);
}

ClientMethod stopCountCB(prefix) [ Language = javascript ]
{
	var d = this.findElement(prefix+'Increment');
	d.className = "spinnerIncDiv";
	var d = this.findElement(prefix+'Decrement');
	d.className = "spinnerDecDiv";
	this._countDelta=0;
}

ClientMethod autoIncDec(prefix) [ Language = javascript ]
{
	var t = this.findElement(prefix+"ValueDiv");
	var v=parseFloat(t.value)+this._countDelta;
	if (v>this.max[prefix]) {
		this._countDelta=0;
		v=this.max[prefix];
		var up = this.findElement(prefix+"Increment");
		up.className = "spinnerIncDiv";	
	}
	else if (v<this.min[prefix]) {
		this._countDelta=0;
		v=this.min[prefix];
		var down = this.findElement(prefix+"Decrement");
		down.className="spinnerDecDiv";	
	}
	t.value=v;
	this.validate(prefix,{type:'blur'});
}

}
