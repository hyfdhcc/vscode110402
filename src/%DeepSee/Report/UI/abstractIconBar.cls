/// Simple Icon Bar
Class %DeepSee.Report.UI.abstractIconBar Extends %ZEN.Component.control [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zendsmenus.js";

Property ontoggle As %ZEN.Datatype.eventHandler;

Parameter DEFAULTICONWIDTH = 34;

Parameter DEFAULTICONHEIGHT = 28;

Property iconWidth As %ZEN.Datatype.integer [ InitialExpression = {..#DEFAULTICONWIDTH} ];

Property iconHeight As %ZEN.Datatype.integer [ InitialExpression = {..#DEFAULTICONHEIGHT} ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.middleIconFrame {
	position:absolute;
	overflow:hidden;
	border:1px solid #000042;
}

.topIconFrame {
	position:absolute;
	overflow:hidden;
	border:1px solid #000042;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
}

.leftIconFrame {
	position:absolute;
	overflow:hidden;
	border:1px solid #000042;
	border-top-left-radius: 10px;
	border-bottom-left-radius: 10px;
}

.rightIconFrame {
	position:absolute;
	overflow:hidden;
	border:1px solid #000042;
	border-top-right-radius: 10px;
	border-bottom-right-radius: 10px;
}

.bottomIconFrame {
	position:absolute;
	overflow:hidden;
	border:1px solid #000042;
	border-bottom-left-radius: 10px;
	border-bottom-right-radius: 10px;
}

.onlyIconFrame {
	position:absolute;
	overflow:hidden;
	border:1px solid #000042;
	border-radius: 10px;
	border-radius: 10px;
}

.tbBitmapRender {
	position:absolute;
	top:0px;
	left:0px;
	width:100%;
	height:100%;
	background-position: center center;
	background-repeat: no-repeat;
}

.tbCanvasRender {
	position:absolute;
	top:3px;
	left:3px;
}

.toolIconBar {
	position:relative;
	top:0px;
	left:0px;
}

.toolButton {
	position:absolute;
	background-image:url(portal/buttonGray2.png);
	background-size:100% 100%;
	background-repeat:no-repeat;
	width:100%;
	height:100%;
}

.toolButtonActive {
	position:absolute;
	background-image:url(portal/buttonBlue2.png);
	background-size:100% 100%;
	background-repeat:no-repeat;
	width:100%;
	height:100%;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="toolIconBar" > 
		</div>
	>
}

ClientMethod appendButton(js) [ Language = javascript ]
{
	
	var id = js.name+"Button";
	var div = document.createElement("div");
	div.className = "middleIconFrame";
	
	var h = [];
	h.push('<a id="'+id+'_'+this.index+'" title="'+js.title+'" class="toolButton" onclick="this.controller.serviceClick(event);" >');
	h.push('<div class="tbBitmapRender"></div>');
	h.push('<canvas class="tbCanvasRender"></canvas>');
	h.push('</a>');
	
	div.innerHTML = h.join("");
	
	var anchor = div.getElementsByTagName("a")[0];
	anchor.controller = this;

	var bitmap = anchor.getElementsByClassName('tbBitmapRender');
	if (bitmap) bitmap = bitmap[0];
	var canvas = anchor.getElementsByClassName('tbCanvasRender');
	if (canvas) canvas = canvas[0];
		
	if (!this.ctrls) this.ctrls=[];
	this.ctrls["_"+id] = anchor;
	
	if (js.url) {
		bitmap.style.backgroundImage = js.url;
	}
	if (js.cvs) {
		this.canvas = canvas;
		canvas.width = this.iconWidth-6;
		canvas.height = this.iconHeight-6;
		if (canvas) eval(js.cvs);
	}
	this._base.appendChild(div);
}

/// Overload this method to dynamically create custom tool bars
ClientMethod onloadHandler() [ Language = javascript ]
{
	var tools = [
		{name:"pointer", title:"Selection Tool", cvs:"ZIS.drawPointerToolIcon(this.canvas);", value:"SELECT"},
		{name:"text", title:"Text Tool", cvs:"ZIS.drawTextToolIcon(this.canvas);", value:"TEXT"},
		{name:"line", title:"Line Tool", url:"url(portal/lineToolWide2.png)", value:"LINE"},
		{name:"rect", title:"Box Tool", url:"url(portal/rectToolWide2.png)", value:"RECT"},
		{name:"chart", title:"Chart Tool", url:"url(portal/chartToolWide2.png)", value:"CHART"},
		{name:"barcode", title:"Barcode Tool", url:"url(portal/barcodeToolWide.png)", value:"BCODE"},
		{name:"image", title:"Image Tool", url:"url(portal/imageToolWide2.png)", value:"IMAGE"}];

	this._toolSet = tools;
	
	this._base = this.findElement('base');
	this._base.controller = this;

	var len = tools.length;
	for (var i=0;i<len;i++) {
		this.appendButton(tools[i]);
	}	
		
	this.arrangeHorizontal();
//	this.arrangeVertical();

	this.value = 'SELECT';
	this.updateControls();
	
	ZRE.toolsPalette = this;
}

ClientMethod arrangeHorizontal() [ Language = javascript ]
{
	var len = this._toolSet.length;
		
	this._base.style.width = len*(this.iconWidth-1)+"px";
	this._base.style.height = this.iconHeight+"px";

	var margin = 0;
	for (var i=0;i<len;i++) {
		var id = "_"+this._toolSet[i].name+"Button";
		var div = this.ctrls[id];
		if (div) {
			var s = div.parentNode.style;
			s.top="0px";
			s.left=margin+"px";
			s.width = this.iconWidth+"px";
			s.height = this.iconHeight+"px";
			margin+=(this.iconWidth-1);
			
			if (i==0) div.parentNode.className = "leftIconFrame";
			if (i==len-1) div.parentNode.className = "rightIconFrame";
			if (len==1) div.parentNode.className = "onlyIconFrame";
		}
	}
}

ClientMethod arrangeVertical() [ Language = javascript ]
{
	var len = this._toolSet.length;
		
	this._base.style.height = len*(this.iconHeight-1)+"px";
	this._base.style.height = this.iconWidth+"px";

	var margin = 0;
	for (var i=0;i<len;i++) {
		var id = "_"+this._toolSet[i].name+"Button";
		var div = this.ctrls[id];
		if (div) {
			var s = div.parentNode.style;
			s.top=margin+"0px";
			s.left="0px";
			s.width = this.iconWidth+"px";
			s.height = this.iconHeight+"px";
			margin+=(this.iconHeight-1);
			
			if (i==0) div.parentNode.className = "topIconFrame";
			if (i==len-1) div.parentNode.className = "bottomIconFrame";
			if (len==1) div.parentNode.className = "onlyIconFrame";
		}
	}
}

ClientMethod serviceClick(event) [ Language = javascript ]
{
	var t = event.target;
	while (t.tagName!="A") t = t.parentNode;
	
	// if clicked on a plate option is already selected 
	if (t.className=="toolButtonActive") {
		return(ZLM.killEvent(event));
	}

	var v = this.value;
	var tools = this._toolSet;
	var len = tools.length;

	for (var i=0;i<len;i++) {
		var item = tools[i];
		var id = '_'+item.name+'Button';
		if (t==this.ctrls[id]) {
			this.value = item.value;
			i = len;
		}
	}
	this.updateControls();
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod updateControls() [ Language = javascript ]
{
	var v = this.value;
	var t = this._toolSet;
	var len = t.length;
	
	for (var i=0;i<len;i++) {
		var item = t[i];
		var id = '_'+item.name+'Button';
		if (v==item.value) this.ctrls[id].className = "toolButtonActive";
		else this.ctrls[id].className = "toolButton";
	}
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.value = value;
		this.updateControls();
		break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
