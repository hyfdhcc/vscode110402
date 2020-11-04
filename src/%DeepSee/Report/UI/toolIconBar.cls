/// Tool Icon Bar
Class %DeepSee.Report.UI.toolIconBar Extends %DeepSee.Report.UI.abstractIconBar [ System = 4 ]
{

Property hintPointer As %ZEN.Datatype.caption [ InitialExpression = "Selection Tool" ];

Property hintText As %ZEN.Datatype.caption [ InitialExpression = "Text Tool" ];

Property hintLine As %ZEN.Datatype.caption [ InitialExpression = "Line Tool" ];

Property hintRect As %ZEN.Datatype.caption [ InitialExpression = "Box Tool" ];

Property hintChart As %ZEN.Datatype.caption [ InitialExpression = "Chart Tool" ];

Property hintBarcode As %ZEN.Datatype.caption [ InitialExpression = "Barcode Tool" ];

Property hintImage As %ZEN.Datatype.caption [ InitialExpression = "Image Tool" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var tools = [
		{name:"pointer", title:this.hintPointer, cvs:"ZIS.drawPointerToolIcon(this.canvas);", value:"SELECT"},
		{name:"text", title:this.hintText, cvs:"ZIS.drawTextToolIcon(this.canvas);", value:"TEXT"},
		{name:"line", title:this.hintLine, url:"url(portal/lineToolWide2.png)", value:"LINE"},
		{name:"rect", title:this.hintRect, url:"url(portal/rectToolWide2.png)", value:"RECT"},
		{name:"chart", title:this.hintChart, url:"url(portal/chartToolWide2.png)", value:"CHART"},
		{name:"barcode", title:this.hintBarcode, url:"url(portal/barcodeToolWide.png)", value:"BCODE"},
		{name:"image", title:this.hintImage, url:"url(portal/imageToolWide2.png)", value:"IMAGE"}];

	this._toolSet = tools;
	
	this._base = this.findElement('base');
	this._base.controller = this;

	var len = tools.length;
	for (var i=0;i<len;i++) {
		this.appendButton(tools[i]);
	}	
		
	this.arrangeHorizontal();
//	this.arrangeVertical();

	this.value = 'SELECT';
	this.updateControls();
	
	ZRE.toolsPalette = this;
}

}
