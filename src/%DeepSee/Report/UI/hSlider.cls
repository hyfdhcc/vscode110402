/// RGUI.hSlider
Class %DeepSee.Report.UI.hSlider Extends %ZEN.Component.control [ System = 4 ]
{

/// Default image for close group button.
Parameter INCLUDEFILES = "zenCSLM.js";

Property minValue As %ZEN.Datatype.integer [ InitialExpression = 0 ];

Property maxValue As %ZEN.Datatype.integer [ InitialExpression = 1 ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.hSliderWest {
	position:absolute;
	display:block;
	width:4px;
	height:17px;
	bottom:1px;
	left:0px;
	background-image:url(portal/hSliderWestEnd.png);
}

.hSliderEast {
	position:absolute;
	display:block;
	width:4px;
	height:17px;
	bottom:1px;
	right:0px;
	background-image:url(portal/hSliderEastEnd.png);
}

.hSliderMiddle {
	position:absolute;
	display:block;
	left:4px;
	height:17px;
	bottom:1px;
	background-image:url(portal/hSliderTroughEW.png);
	background-repeat:repeat-x;
	width:71px;
}

.hSliderTrough {
	position:absolute;
	display:block;
	left:0;
	bottom:0;
	height:19px;
	width:79px;
}

.hSliderValueBox {
	position:absolute;
	display:none;
	overflow:hidden;
	right:0px;
	bottom:0px;
}

.hSliderHandle {
	position:absolute;
	bottom:0px;
	left:50px;
	background-image:url(portal/slideHandleNorth.png);
	height:17px;
	width:11px;
}

.hSlider {
	position:relative;
	width:100%;
	height:19px;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="hSlider" #(..%Attr("minValue",..minValue))# #(..%Attr("maxValue",..maxValue))# #(..%Attr("value",..value))# > 
			<div id="#(..%MakeId("trough"))#" class="hSliderTrough" >
				<div class="hSliderWest"></div>
				<div id="#(..%MakeId("troughSpan"))#"class="hSliderMiddle"></div>
				<div class="hSliderEast"></div>
				<div id="#(..%MakeId("handle"))#" class="hSliderHandle"></div>
			</div>
		
			<div class="hSliderValueBox">
				<input type="text"></input>
			</div>
			
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.base = this.findElement("base");
	this.handle = this.findElement("handle");
	this.trough = this.findElement("trough");
	this.handle.controller = this;
	this.base.controller = this;
	this.trough.controller = this;
	ZLM.registerDragItem(this.handle,this);
	ZLM.setLocalAttribute(this.handle,"onmousedown","ZLM.drag(this,event);");
	this.range=this.maxValue-this.minValue;
	this.positionHandle();
}

ClientMethod startDrag() [ Language = javascript ]
{
	this.maxSlide=this.trough.clientWidth-this.handle.offsetWidth;
	this.slotSize=this.maxSlide/this.range;
	this.roundOff=this.slotSize/2;
	this.roundOff=0;
}

ClientMethod constrainDragY(mgr, wrapper, newY) [ Language = javascript ]
{
	return(2);
}

ClientMethod constrainDragX(mgr, wrapper, newX) [ Language = javascript ]
{
	if (newX<0) return(0);
	var mx=this.trough.clientWidth-this.handle.offsetWidth;
	if (newX>mx) return(mx);
	var newV=(this.handle.offsetLeft+this.roundOff)/this.slotSize;
	if (newV!=this.value) {
		this.value=newV;
		if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
	}
	return(newX);
}

ClientMethod endDrag() [ Language = javascript ]
{
	var newV=(this.handle.offsetLeft+this.roundOff)/this.slotSize;
	if (newV!=this.value) {
		this.value=newV;
		if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
	}
}

ClientMethod positionHandle() [ Language = javascript ]
{
	var tW = this.trough.clientWidth;
	var hW = this.handle.offsetWidth;
	if (tW==0) { // slider not currently visible do it the hard way
		tW = parseInt(ZLM.getComputedNodeStyle(this.trough,'width'),10);
		hW = parseInt(ZLM.getComputedNodeStyle(this.handle,'width'),10);
	}
	var mx = tW - hW;
	var slot=mx/this.range;
	this.handle.style.left=Math.round(this.value*slot)+"px";
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'maxValue':
		if (value==null) this.MaxValue=100;
		else {
			if (typeof(value)=="string") this.maxValue=parseFloat(value);
			else this.maxValue=value;
		}
		if (this.value>this.maxValue) this.value=this.maxValue;
		this.range=this.maxValue-this.minValue;
		this.positionHandle();
		break;
	case 'minValue':
		if (value==null) this.MinValue=0;
		else {
			if (typeof(value)=="string") this.minValue=parseFloat(value);
			else this.minValue=value;
		}
		if (this.value<this.minValue) this.value=this.minValue;
		this.range=this.maxValue-this.minValue;
		this.positionHandle();
		break;	
	case 'value':
		if (value==null) this.value=this.minValue;
		else {
			if (typeof(value)=="string") this.value=parseFloat(value);
			else this.value=value;
			if (this.value<this.minValue) this.value=this.minValue;
			if (this.value>this.maxValue) this.value=this.maxValue;
		}
		this.positionHandle();
		break;

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
