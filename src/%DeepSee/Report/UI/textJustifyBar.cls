/// RGUI.hSlider
Class %DeepSee.Report.UI.textJustifyBar Extends %ZEN.Component.control [ System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// onresize event handler:
/// This event is fired when this drag group is resized.
Property ontoggle As %ZEN.Datatype.eventHandler;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textJustifyBar {
	position:relative;
	top:0px;
	left:0px;
	width:78px;
	height:16px;
}

.textJustifyLeftButton {
	position:absolute;
	top:0px;
	left:0px;
	width:26px;
	height:16px;
	background-image:url(portal/justLeftButton.png);
}

.textJustifyLeftActive {
	position:absolute;
	top:0px;
	left:0px;
	width:26px;
	height:16px;
	background-image:url(portal/justLeftButtonB.png);
}

.textJustifyCenterButton {
	position:absolute;
	top:0px;
	left:26px;
	width:26px;
	height:16px;
	background-image:url(portal/justCenterButton.png);
}

.textJustifyCenterActive {
	position:absolute;
	top:0px;
	left:26px;
	width:26px;
	height:16px;
	background-image:url(portal/justCenterButtonB.png);
}

.textJustifyRightButton {
	position:absolute;
	top:0px;
	left:52px;
	width:26px;
	height:16px;
	background-image:url(portal/justRightButton.png);
}

.textJustifyRightActive {
	position:absolute;
	top:0px;
	left:52px;
	width:26px;
	height:16px;
	background-image:url(portal/justRightButtonB.png);
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	#; TODO: implement this method
	&html<
		<div id="#(..%MakeId("base"))#" class="textStyleBar" > 
			<div id="#(..%MakeId("leftButton"))#" class="textJustifyLeftButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("leftButtonPlate"))#" class="textJustifyLeftActive" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("centerButton"))#" class="textJustifyCenterButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("centerButtonPlate"))#" class="textJustifyCenterActive" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("rightButton"))#" class="textJustifyRightButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("rightButtonPlate"))#" class="textJustifyRightActive" onclick="this.controller.serviceClick(event);"></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var div = this.findElement('base');
	div.controller = this;
	
	this.leftButton = this.findElement('leftButton');
	this.leftButton.controller = this;
	this.leftButtonPlate = this.findElement('leftButtonPlate');
	this.leftButtonPlate.controller = this;

	this.centerButton = this.findElement('centerButton');
	this.centerButton.controller = this;
	this.centerButtonPlate = this.findElement('centerButtonPlate');
	this.centerButtonPlate.controller = this;

	this.rightButton = this.findElement('rightButton');
	this.rightButton.controller = this;
	this.rightButtonPlate = this.findElement('rightButtonPlate');
	this.rightButtonPlate.controller = this;
	
	this.value = 'left';
	this.updateControls();
}

ClientMethod serviceClick(event) [ Language = javascript ]
{
	var t = event.target;
	// if clicked on a plate option is already selected 
	if (t==this.leftButtonPlate || t==this.centerButtonPlate || t==this.rightButtonPlate) {
		return(ZLM.killEvent(event));
	}

	if (t==this.leftButton) this.value = "left";
	else if (t==this.centerButton) this.value = "center";
	else this.value = "right";	
	this.updateControls();
	
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

ClientMethod updateControls() [ Language = javascript ]
{
	var v = this.value;
	if (v=="left") this.leftButtonPlate.style.display = "";
	else this.leftButtonPlate.style.display = "none";
	if (v=="center") this.centerButtonPlate.style.display = "";
	else this.centerButtonPlate.style.display = "none";
	if (v=="right") this.rightButtonPlate.style.display = "";
	else this.rightButtonPlate.style.display = "none";
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
