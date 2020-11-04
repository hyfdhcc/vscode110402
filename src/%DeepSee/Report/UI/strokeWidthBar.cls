Class %DeepSee.Report.UI.strokeWidthBar Extends %ZEN.Component.control [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// onresize event handler:
/// This event is fired when this drag group is resized.
Property ontoggle As %ZEN.Datatype.eventHandler;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.strokeWidthBar {
	position:relative;
	top:0px;
	left:0px;
	width:77px;
	height:16px;
}

.strokeWidthBroadButton {
	position:absolute;
	top:0px;
	left:0px;
	width:26px;
	height:16px;
	background-image:url(portal/broadButton.png);
}

.strokeWidthBroadActive {
	position:absolute;
	top:0px;
	left:0px;
	width:26px;
	height:16px;
	background-image:url(portal/broadButtonB.png);
}

.strokeWidthMediumButton {
	position:absolute;
	top:0px;
	left:26px;
	width:26px;
	height:16px;
	background-image:url(portal/mediumButton.png);
}

.strokeWidthMediumActive {
	position:absolute;
	top:0px;
	left:26px;
	width:26px;
	height:16px;
	background-image:url(portal/mediumButtonB.png);
}

.strokeWidthFineButton {
	position:absolute;
	top:0px;
	left:51px;
	width:26px;
	height:16px;
	background-image:url(portal/fineButton.png);
}

.strokeWidthFineActive {
	position:absolute;
	top:0px;
	left:51px;
	width:26px;
	height:16px;
	background-image:url(portal/fineButtonB.png);
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="textStyleBar" > 
			<div id="#(..%MakeId("broadButton"))#" class="strokeWidthBroadButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("broadButtonPlate"))#" class="strokeWidthBroadActive" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("fineButton"))#" class="strokeWidthFineButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("fineButtonPlate"))#" class="strokeWidthFineActive" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("mediumButton"))#" class="strokeWidthMediumButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("mediumButtonPlate"))#" class="strokeWidthMediumActive" onclick="this.controller.serviceClick(event);"></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var div = this.findElement('base');
	div.controller = this;
	this.broadButton = this.findElement('broadButton');
	this.broadButtonPlate = this.findElement('broadButtonPlate');
	this.mediumButton = this.findElement('mediumButton');
	this.mediumButtonPlate = this.findElement('mediumButtonPlate');
	this.fineButton = this.findElement('fineButton');
	this.fineButtonPlate = this.findElement('fineButtonPlate');
	for (var p = div.firstChild; p!=null; p=p.nextSibling) {
		p.controller=this;
	}
	this.value="fine"
	this.updateControls();
}

ClientMethod serviceClick(event) [ Language = javascript ]
{
	var t = event.target;
	// if clicked on a plate option is already selected 
	if (t==this.broadButtonPlate || t==this.mediumButtonPlate || t==this.fineButtonPlate || t==this.solidButtonPlate) {
		return(ZLM.killEvent(event));
	}

	if (t==this.broadButton) this.value = "broad";
	else if (t==this.mediumButton) this.value = "medium";
	else this.value = "fine";
	
	this.updateControls();
	
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod updateControls() [ Language = javascript ]
{
	var v = this.value;
	if (v=="fine") this.fineButtonPlate.style.display = "";
	else this.fineButtonPlate.style.display = "none";
	if (v=="medium") this.mediumButtonPlate.style.display = "";
	else this.mediumButtonPlate.style.display = "none";
	if (v=="broad") this.broadButtonPlate.style.display = "";
	else this.broadButtonPlate.style.display = "none";
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
