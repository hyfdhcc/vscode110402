/// Spinner control
Class %DeepSee.Report.UI.spinner Extends %ZEN.Component.control [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property minValue As %ZEN.Datatype.integer [ InitialExpression = 0 ];

Property maxValue As %ZEN.Datatype.integer [ InitialExpression = 100 ];

Property units As %ZEN.Datatype.string;

Property valueList As %ZEN.Datatype.string;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.spinner {
	position:relative;
	top:0px;
	left:0px;
	height:20px;
	width:76px;
}

.spinnerWinDiv {
	border:1px solid #575757;
	overflow:hidden;
	position:absolute;
	top:1px;
	right:14px;
	height:16px;
	width:62px;
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
		<div id="#(..%MakeId("base"))#" class="spinner" > 
		<div id="#(..%MakeId("increment"))#" class='spinnerIncDiv' onmousedown="this.controller.countUpCB();" onmouseup="this.controller.stopCountCB();" ></div>
		<div id="#(..%MakeId("decrement"))#" class='spinnerDecDiv' onmousedown="this.controller.countDownCB();" onmouseup="this.controller.stopCountCB();"></div>
		<div id="#(..%MakeId("valueWindow"))#" class='spinnerWinDiv' >
			<div id="#(..%MakeId("background"))#" class='spinnerWinBGDiv' ></div>
			<div id="#(..%MakeId("unitDiv"))#" class='spinnerUnitDiv'></div>
			<input id="#(..%MakeId("valueDiv"))#" class='spinnerValueDiv' type="text" onkeyup="this.controller.validate();" ></input>
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
	
	this.setUnitsString(this.units);
	this.setValueDisplay(this.value);
}

ClientMethod setUnitsString(str) [ Language = javascript ]
{
	var d = this.findElement('unitDiv');
	d.innerHTML = str;
	this.units = str;
}

ClientMethod setValueDisplay(v) [ Language = javascript ]
{
	this.setDisplayValue(v);
}

ClientMethod setDisplayValue(val) [ Language = javascript ]
{
	var v=parseInt(val,10);
	if (isNaN(v)|| v==null || v<this.minValue) v=this.minValue;
	if (v>this.maxValue) v=this.maxValue;
	this.value=v;
	var t = this.findElement("valueDiv");
	t.value=this.value;
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
	d.className = "spinnerIncDivActive";
	this._countDelta= 1;
	this.autoCount(0);
}

ClientMethod countDownCB() [ Language = javascript ]
{
	var d = this.findElement('decrement');
	d.className = "spinnerDecDivActive";
	this._countDelta= -1;
	this.autoCount(0);
}

ClientMethod stopCountCB() [ Language = javascript ]
{
	var d = this.findElement('increment');
	d.className = "spinnerIncDiv";
	var d = this.findElement('decrement');
	d.className = "spinnerDecDiv";
	this._countDelta=0;
}

ClientMethod autoIncDec() [ Language = javascript ]
{
	this.value=parseInt(this.value)+this._countDelta;
	if (this.value>this.maxValue) {
		this._countDelta=0;
		this.value=this.maxValue;
		var up = this.findElement("increment");
		up.className = "spinnerIncDiv";	
	}
	else if (this.value<this.minValue) {
		this._countDelta=0;
		this.value=this.minValue;
		var down = this.findElement("decrement");
		down.className="spinnerDecDiv";	
	}
	var t = this.findElement("valueDiv");
	t.value=this.value;
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod validate() [ Language = javascript ]
{
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

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
