/// pickBox control
Class %DeepSee.Report.UI.pickBox Extends %ZEN.Component.control [ System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property valueList As %ZEN.Datatype.string;

Property displayList As %ZEN.Datatype.string;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.pickBox {
	position:relative;
	top:0px;
	left:0px;
	height:20px;
	width:76px;
}

.pickBoxWinDiv {
	border:1px solid #575757;
	overflow:hidden;
	position:absolute;
	top:1px;
	right:14px;
	height:16px;
	width:62px;
}

.pickBoxWinBGDiv {
	width:100%;
	height:20px;
	background:#ffffff;
}

.pickBoxValueDiv {
	border:none;
	height:16px;
	width:68px;
	font:12px sans-serif;
	color:#000077;
	position:absolute;
	top:0px;
	right:2px;
	text-align:right;
}

.pickBoxIncDiv {
	position:absolute;
	top:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/incSpinner.png);
}

.pickBoxIncDivActive {
	position:absolute;
	top:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/incSpinnerB.png);
}

.pickBoxDecDiv {
	position:absolute;
	bottom:0px;
	right:0px;
	height:10px;
	width:13px;
	background-image:url(csp/broker/portal/decSpinner.png);
}

.pickBoxDecDivActive {
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
		<div id="#(..%MakeId("base"))#" class="pickBox" > 
		<div id="#(..%MakeId("increment"))#" class='pickBoxIncDiv' onmousedown="this.controller.countUpCB();" onmouseup="this.controller.stopCountCB();" ></div>
		<div id="#(..%MakeId("decrement"))#" class='pickBoxDecDiv' onmousedown="this.controller.countDownCB();" onmouseup="this.controller.stopCountCB();"></div>
		<div id="#(..%MakeId("valueWindow"))#" class='pickBoxWinDiv' >
			<div id="#(..%MakeId("background"))#" class='pickBoxWinBGDiv' ></div>
			<input id="#(..%MakeId("valueDiv"))#" class='pickBoxValueDiv' type="text" onkeyup="this.controller.validate();" ></input>
		</div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var div = this.findElement('base');
	div.controller = this;
	var t = this.findElement('valueDiv');
	t.controller = this;
	var t = this.findElement('increment');
	t.controller = this;
	var t = this.findElement('decrement');
	t.controller = this;
	this.setValueArrays();
	this.setValueDisplay(this.value);
}

ClientMethod setValueDisplay(v) [ Language = javascript ]
{
	this.value = v;
	this.setValueIndex();
	var d = this.findElement('valueDiv');
	d.value = this._dA[this._valueIdx];
}

ClientMethod setValueArrays() [ Language = javascript ]
{
	this._vA = this.valueList.split(',');
	if (this.displayList) this._dA = this.displayList.split(',');
	else this._dA = this.valueList.split(',');
	this.setValueIndex();
}

ClientMethod setValueIndex() [ Language = javascript ]
{
	var v = this.value;
	for (var i = 0; i<this._vA.length;i++) {
		if (v == this._vA[i]) {
			this._valueIdx = i;
			return;
		}
	}
	this._valueIdx = 0;
	this.value = this._vA[0];
}

ClientMethod serviceClick() [ Language = javascript ]
{
	if (this.getValue()) {
		this.setValue(false);
	}
	else {
		this.setValue(true);
	}
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod autoCount(time) [ Language = javascript ]
{
	this.incrementDelay = 200;
	time+=3;
	var delay = this.incrementDelay-time;
	if (delay<1) delay=10;
	this.autoIncDec();
	if (this._countDelta!=0) setTimeout("zenPage.getComponent("+this.index+").autoCount("+time+")",delay);
}

ClientMethod countUpCB() [ Language = javascript ]
{
	var d = this.findElement('increment');
	d.className = "pickBoxIncDivActive";
	this._countDelta= 1;
	this.autoCount(0);
}

ClientMethod countDownCB() [ Language = javascript ]
{
	var d = this.findElement('decrement');
	d.className = "pickBoxDecDivActive";
	this._countDelta= -1;
	this.autoCount(0);
}

ClientMethod stopCountCB() [ Language = javascript ]
{
	var d = this.findElement('increment');
	d.className = "pickBoxIncDiv";
	var d = this.findElement('decrement');
	d.className = "pickBoxDecDiv";
	this._countDelta=0;
}

ClientMethod setDisplayValue(val) [ Language = javascript ]
{
	var v=parseInt(val);
	if (isNaN(v)|| v==null || v<this.minValue) v=this.minValue;
	if (v>this.maxValue) v=this.maxValue;
	this.value=v;
	var t = this.findElement("valueDiv");
	t.value=this.value;
}

ClientMethod autoIncDec() [ Language = javascript ]
{
	
	var idx = this._valueIdx+this._countDelta;
	if (idx>=this._vA.length) {
		this._countDelta=0;
		idx=this._vA.length-1;
		var up = this.findElement("increment");
		up.className = "pickBoxIncDiv";	
	}
	else if (idx<0) {
		this._countDelta=0;
		idx = 0;
		var down = this.findElement("decrement");
		down.className="pickBoxDecDiv";	
	}
	this.value = this._vA[idx];
	this._valueIdx = idx;
	
	var t = this.findElement("valueDiv");
	t.value=this._dA[idx];
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod validate() [ Language = javascript ]
{
	this.setValueDisplay(this.value);
	return;
	// NEED TO REDO THIS
	var t = this.findElement("valueDiv");
	var v=parseInt(t.value);
	if (isNaN(v)|| v==null || v<this.minValue) v=this.minValue;
	if (v>this.maxValue) v=this.maxValue;
	this.value=v;
	t.value=v;

	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.setValueDisplay(value);
		break;
	case 'options':
		this.valueList = value;
		this.displayList = value2;
		this.setValueArrays();
		this.setValueDisplay(this.value);
		break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
