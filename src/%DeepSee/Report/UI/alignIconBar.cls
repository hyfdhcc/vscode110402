/// align Icon Bar
Class %DeepSee.Report.UI.alignIconBar Extends %DeepSee.Report.UI.abstractIconBar [ System = 4 ]
{

Property hintAlignLeft As %ZEN.Datatype.caption [ InitialExpression = "Align Left" ];

Property hintAlignTop As %ZEN.Datatype.caption [ InitialExpression = "Align Top" ];

Property hintAlignRight As %ZEN.Datatype.caption [ InitialExpression = "Align Right" ];

Property hintAlignBottom As %ZEN.Datatype.caption [ InitialExpression = "Align Bottom" ];

Property hintCenterHorizontal As %ZEN.Datatype.caption [ InitialExpression = "Center Horizontally" ];

Property hintCenterVertical As %ZEN.Datatype.caption [ InitialExpression = "Center Vertically" ];

Property hintEquispaceHorizontal As %ZEN.Datatype.caption [ InitialExpression = "Space Equally Along Horizontal" ];

Property hintEquispaceVertical As %ZEN.Datatype.caption [ InitialExpression = "Space Equally Along Vertical" ];

Property hintUniformWidth As %ZEN.Datatype.caption [ InitialExpression = "Force Uniform Width" ];

Property hintUniformHeight As %ZEN.Datatype.caption [ InitialExpression = "Force Uniform Height" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var tools = [
		{name:"alignLeft", title:this.hintAlignLeft, url:"url(portal/alignLeft.png)", value:"ALEFT"},
		{name:"alignTop", title:this.hintAlignTop, url:"url(portal/alignTop.png)", value:"ATOP"},
		{name:"alignRight", title:this.hintAlignRight, url:"url(portal/alignRight.png)", value:"ARIGHT"},
		{name:"alignBottom", title:this.hintAlignBottom, url:"url(portal/alignBottom.png)", value:"ABOTTOM"},
		{name:"centerHorizontal", title:this.hintCenterHorizontal, url:"url(portal/centerHorizontal.png)", value:"CHORIZONTAL"},
		{name:"centerVertical", title:this.hintCenterVertical, url:"url(portal/centerVertical.png)", value:"CVERTICAL"},
		{name:"equispaceHorizontal", title:this.hintEquispaceHorizontal, url:"url(portal/equispaceHorizontal.png)", value:"EHORIZONTAL"},
		{name:"equispaceVertical", title:this.hintEquispaceVertical, url:"url(portal/equispaceVertical.png)", value:"EVERTICAL"},
		{name:"uniformWidth", title:this.hintUniformWidth, url:"url(portal/uniformWidth.png)", value:"UWIDTH"},
		{name:"uniformHeight", title:this.hintUniformHeight, url:"url(portal/uniformHeight.png)", value:"UHEIGHT"}];
		
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
	
	ZRE.alignPalette = this;
}

}
