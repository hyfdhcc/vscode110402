/// RGUI.hSlider
Class %DeepSee.Report.UI.strokeStyleBar Extends %ZEN.Component.control [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.strokeStyleBar {
	position:relative;
	top:0px;
	left:0px;
	width:77px;
	height:16px;
}

.strokeStyleNoneButton {
	position:absolute;
	top:0px;
	left:0px;
	width:20px;
	height:16px;
	background-image:url(portal/noneButton.png);
}

.strokeStyleNoneActive {
	position:absolute;
	top:0px;
	left:0px;
	width:20px;
	height:16px;
	background-image:url(portal/noneButtonB.png);
}

.strokeStyleDottedButton {
	position:absolute;
	top:0px;
	left:20px;
	width:19px;
	height:16px;
	background-image:url(portal/dottedButtonS.png);
}

.strokeStyleDottedActive {
	position:absolute;
	top:0px;
	left:20px;
	width:19px;
	height:16px;
	background-image:url(portal/dottedButtonB.png);
}

.strokeStyleDashedButton {
	position:absolute;
	top:0px;
	left:38px;
	width:19px;
	height:16px;
	background-image:url(portal/dashedButtonS.png);
}

.strokeStyleDashedActive {
	position:absolute;
	top:0px;
	left:38px;
	width:19px;
	height:16px;
	background-image:url(portal/dashedButtonB.png);
}

.strokeStyleSolidButton {
	position:absolute;
	top:0px;
	left:57px;
	width:20px;
	height:16px;
	background-image:url(portal/solidButtonS.png);
}

.strokeStyleSolidActive {
	position:absolute;
	top:0px;
	left:57px;
	width:20px;
	height:16px;
	background-image:url(portal/solidButtonB.png);
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="textStyleBar" > 
			<div id="#(..%MakeId("noneButton"))#" class="strokeStyleNoneButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("noneButtonPlate"))#" class="strokeStyleNoneActive" onclick="this.controller.serviceClick(event);"></div>

			<div id="#(..%MakeId("dottedButton"))#" class="strokeStyleDottedButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("dottedButtonPlate"))#" class="strokeStyleDottedActive" onclick="this.controller.serviceClick(event);"></div>

			<div id="#(..%MakeId("dashedButton"))#" class="strokeStyleDashedButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("dashedButtonPlate"))#" class="strokeStyleDashedActive" onclick="this.controller.serviceClick(event);"></div>

			<div id="#(..%MakeId("solidButton"))#" class="strokeStyleSolidButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("solidButtonPlate"))#" class="strokeStyleSolidActive" onclick="this.controller.serviceClick(event);"></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var div = this.findElement('base');
	div.controller = this;
	
	this.noneButton = this.findElement('noneButton');
	this.noneButton.controller = this;
	this.noneButtonPlate = this.findElement('noneButtonPlate');
	this.noneButtonPlate.controller = this;
	
	this.dottedButton = this.findElement('dottedButton');
	this.dottedButton.controller = this;
	this.dottedButtonPlate = this.findElement('dottedButtonPlate');
	this.dottedButtonPlate.controller = this;
	
	this.dashedButton = this.findElement('dashedButton');
	this.dashedButton.controller = this;
	this.dashedButtonPlate = this.findElement('dashedButtonPlate');
	this.dashedButtonPlate.controller = this;
	
	this.solidButton = this.findElement('solidButton');
	this.solidButton.controller = this;
	this.solidButtonPlate = this.findElement('solidButtonPlate');
	this.solidButtonPlate.controller = this;
}

ClientMethod serviceClick(event) [ Language = javascript ]
{
	var t = event.target;
	// if clicked on a plate option is already selected 
	if (t==this.noneButtonPlate || t==this.dottedButtonPlate || t==this.dashedButtonPlate || t==this.solidButtonPlate) {
		return(ZLM.killEvent(event));
	}

	if (t==this.noneButton) this.value = "none";
	else if (t==this.dottedButton) this.value = "dotted";
	else if (t==this.dashedButton) this.value = "dashed";
	else this.value = "solid";
	
	this.updateControls();
	
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod updateControls() [ Language = javascript ]
{
	var v = this.value;
	if (v=="none") this.noneButtonPlate.style.display = "";
	else this.noneButtonPlate.style.display = "none";
	if (v=="dotted") this.dottedButtonPlate.style.display = "";
	else this.dottedButtonPlate.style.display = "none";
	if (v=="dashed") this.dashedButtonPlate.style.display = "";
	else this.dashedButtonPlate.style.display = "none";
	if (v=="solid") this.solidButtonPlate.style.display = "";
	else this.solidButtonPlate.style.display = "none";
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
