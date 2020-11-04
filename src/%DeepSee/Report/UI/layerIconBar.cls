/// Layer Icon Bar
Class %DeepSee.Report.UI.layerIconBar Extends %DeepSee.Report.UI.abstractIconBar [ System = 4 ]
{

Property hintToBack As %ZEN.Datatype.caption [ InitialExpression = "Move To Back" ];

Property hintBackward As %ZEN.Datatype.caption [ InitialExpression = "Move Backward" ];

Property hintForward As %ZEN.Datatype.caption [ InitialExpression = "Move Forward" ];

Property hintToFront As %ZEN.Datatype.caption [ InitialExpression = "Move To Front" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var tools = [
		{name:"toBack", title:this.hintToBack, url:"url(portal/moveToBack.png)", value:"TOBACK"},
		{name:"backward", title:this.hintBackward, url:"url(portal/moveBackward.png)", value:"BACKWARD"},
		{name:"forward", title:this.hintForward, url:"url(portal/moveForward.png)", value:"FORWARD"},
		{name:"toFront", title:this.hintToFront, url:"url(portal/moveToFront.png)", value:"TOFRONT"}];
		
	this._toolSet = tools;
	
	this._base = this.findElement('base');
	this._base.controller = this;

	var len = tools.length;
	for (var i=0;i<len;i++) {
		this.appendButton(tools[i]);
	}	
		
	this.arrangeHorizontal();
//	this.arrangeVertical();

	this.value = '';
	this.updateControls();
	
	ZRE.layerPalette = this;
}

}
