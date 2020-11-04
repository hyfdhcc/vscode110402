/// Edit Icon Bar
Class %DeepSee.Report.UI.editIconBar Extends %DeepSee.Report.UI.abstractIconBar [ System = 4 ]
{

Property hintCut As %ZEN.Datatype.caption [ InitialExpression = "Cut Selection" ];

Property hintCopy As %ZEN.Datatype.caption [ InitialExpression = "Copy Selection" ];

Property hintPaste As %ZEN.Datatype.caption [ InitialExpression = "Paste Selection" ];

Property hintDuplicate As %ZEN.Datatype.caption [ InitialExpression = "Duplicate Selection" ];

Property hintDelete As %ZEN.Datatype.caption [ InitialExpression = "Delete Selection" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var tools = [
		{name:"cut", title:this.hintCut, url:"url(images/cut.png)", value:"CUT"},
		{name:"copy", title:this.hintCopy, url:"url(images/copy.png)", value:"COPY"},
		{name:"paste", title:this.hintPaste, url:"url(images/paste.png)", value:"PASTE"},
		{name:"dup", title:this.hintDuplicate, url:"url(portal/duplicate.png)", value:"DUPLICATE"},
		{name:"delete", title:this.hintDelete, url:"url(deepsee/close_a_16.gif)", value:"DELETE"}];

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
	
	ZRE.editPalette = this;
}

}
