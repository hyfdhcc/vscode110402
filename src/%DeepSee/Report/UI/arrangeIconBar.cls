/// Arrange Icon Bar
Class %DeepSee.Report.UI.arrangeIconBar Extends %DeepSee.Report.UI.abstractIconBar [ System = 4 ]
{

Property hintAutogrid As %ZEN.Datatype.caption [ InitialExpression = "Toggle Autogrid" ];

Property hintSnap As %ZEN.Datatype.caption [ InitialExpression = "Snap To Grid" ];

Property hintGroup As %ZEN.Datatype.caption [ InitialExpression = "Group Selections" ];

Property hintUngroup As %ZEN.Datatype.caption [ InitialExpression = "Ungroup Selection" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var tools = [
		{name:"autogrid", title:this.hintAutogrid, url:"url(portal/autogrid.png)", value:"AUTOGRID"},
		{name:"snap", title:this.hintSnap, url:"url(portal/snapToGrid.png)", value:"SNAP"},
		{name:"group", title:this.hintGroup, url:"url(portal/group.png)", value:"GROUP"},
		{name:"ungroup", title:this.hintUngroup, url:"url(portal/ungroup.png)", value:"UNGROUP"}];
		
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
	
	ZRE.arrangePalette = this;
}

}
