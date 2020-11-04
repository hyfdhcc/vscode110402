/// textStyleBar
/// value is a javaScript object with three binary fields: bold, italic and underline
Class %DeepSee.Report.UI.textStyleBar Extends %ZEN.Component.control [ System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textStyleBar {
	position:relative;
	top:0px;
	left:0px;
	width:78px;
	height:16px;
}

.textStyleBoldButton {
	position:absolute;
	top:0px;
	left:0px;
	width:26px;
	height:16px;
	background-image:url(portal/boldButton.png);
}

.textStyleBoldActive {
	position:absolute;
	top:0px;
	left:0px;
	width:26px;
	height:16px;
	background-image:url(portal/boldButtonB.png);
}

.textStyleItalicButton {
	position:absolute;
	top:0px;
	left:26px;
	width:26px;
	height:16px;
	background-image:url(portal/italicButton.png);
}

.textStyleItalicActive {
	position:absolute;
	top:0px;
	left:26px;
	width:26px;
	height:16px;
	background-image:url(portal/italicButtonB.png);
}

.textStyleUnderlineButton {
	position:absolute;
	top:0px;
	left:52px;
	width:26px;
	height:16px;
	background-image:url(portal/underlineButton.png);
}

.textStyleUnderlineActive {
	position:absolute;
	top:0px;
	left:52px;
	width:26px;
	height:16px;
	background-image:url(portal/underlineButtonB.png);
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	#; TODO: implement this method
	&html<
		<div id="#(..%MakeId("base"))#" class="textStyleBar" > 
			<div id="#(..%MakeId("boldButton"))#" class="textStyleBoldButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("boldButtonPlate"))#" class="textStyleBoldActive" onclick="this.controller.serviceClick(event);"></div>

			<div id="#(..%MakeId("italicButton"))#" class="textStyleItalicButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("italicButtonPlate"))#" class="textStyleItalicActive" onclick="this.controller.serviceClick(event);"></div>

			<div id="#(..%MakeId("underlineButton"))#" class="textStyleUnderlineButton" onclick="this.controller.serviceClick(event);"></div>
			<div id="#(..%MakeId("underlineButtonPlate"))#" class="textStyleUnderlineActive" onclick="this.controller.serviceClick(event);"></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.base = this.findElement('base');
	this.base.controller = this;
	this.boldButton = this.findElement('boldButton');
	this.boldButton.controller = this;

	this.boldButtonPlate = this.findElement('boldButtonPlate');
	this.boldButtonPlate.controller = this;

	this.italicButton = this.findElement('italicButton');
	this.italicButton.controller = this;

	this.italicButtonPlate = this.findElement('italicButtonPlate');
	this.italicButtonPlate.controller = this;

	this.underlineButton = this.findElement('underlineButton');
	this.underlineButton.controller = this;
	
	this.underlineButtonPlate = this.findElement('underlineButtonPlate');
	this.underlineButtonPlate.controller = this;

	this.setValue({'bold':false,'italic':false,'underline':false});
}

ClientMethod serviceClick(event) [ Language = javascript ]
{
	var t = event.target;
	var v = this.value;
	if (t==this.boldButton) v.bold = true;
	else if (t==this.boldButtonPlate) v.bold = false;
	else if (t==this.italicButton) v.italic = true;
	else if (t==this.italicButtonPlate) v.italic = false;
	else if (t==this.underlineButton) v.underline = true;
	else if (t==this.underlineButtonPlate) v.underline = false;
	this.setValue(v);

	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.value=value;
		if (value.bold) this.boldButtonPlate.style.display="block";
		else this.boldButtonPlate.style.display="none";
		if (value.italic) this.italicButtonPlate.style.display="block";
		else this.italicButtonPlate.style.display="none";
		if (value.underline) this.underlineButtonPlate.style.display="block";
		else this.underlineButtonPlate.style.display="none";
		break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
