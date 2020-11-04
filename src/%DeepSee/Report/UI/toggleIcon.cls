/// RGUI.toggleIcon
Class %DeepSee.Report.UI.toggleIcon Extends %ZEN.Component.control [ System = 4 ]
{

/// Default image for close group button.
Parameter DEFAULTIMAGE = "portal/checkmark_36.png";

Parameter INCLUDEFILES = "zenCSLM.js";

/// onresize event handler:
/// This event is fired when this drag group is resized.
Property ontoggle As %ZEN.Datatype.eventHandler;

Property caption As %ZEN.Datatype.caption;

/// URI of image to display for the close group button.
Property contextIcon As %ZEN.Datatype.uri;

/// URI of image to display for the close group button.
Property checkIcon As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTIMAGE} ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" style="position:relative; top:0px; left:0px; width:36px; height:36px" > 
		<img id="#(..%MakeId("iconLayer"))#" style="position:absolute; top:0px; left:0px;" title="#(..caption)#" src="#(..contextIcon)#" onclick="this.controller.serviceClick();"></img>
		<img id="#(..%MakeId("checkLayer"))#" style="position:absolute; top:0px; left:0px; display:none;" title="#(..caption)#" src="#(..checkIcon)#" onclick="this.controller.serviceClick();"></img>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var check = this.findElement('checkLayer');
	var div = this.findElement('base');
	var icon = this.findElement('iconLayer');
	icon.controller = this;
	div.controller = this;
	check.controller = this;
}

ClientMethod serviceClick() [ Language = javascript ]
{
	if (this.getValue()) {
		this.setValue(false);
	}
	else {
		this.setValue(true);
	}
	if (this.ontoggle) zenInvokeCallbackMethod(this.ontoggle,this,'ontoggle');;
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		var check = this.findElement('checkLayer');
		this.value = false;
		if (value && value!="false" ) this.value = true;
		if (this.value) {
			check.style.display='';
		}
		else {
			check.style.display='none';
		}		
		break;

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
