/// Spinner control
Class %DeepSee.Report.UI.layoutEditorPanel Extends %ZEN.Component.composite [ DependsOn = %DeepSee.Report.UI.bannerWorkspace, LegacyInstanceContext, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.layoutEditorPanel {
	background: #afb7c2;
	border-left: 1px solid #C0C0C0;
	border-bottom: 1px solid gray;
	position:relative;
	top:0px;
	left:0px;
}

.editorWorkspace {
	position:absolute;
	width:100%;
	top:21pt;
	bottom:0pt;
	overflow:auto;
}
</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="layoutEditorPanel" >
	<html id="layoutEditorHeader"  OnDrawContent="DrawLayoutEditorHeader"></html>
	<bannerWorkspace id="layoutEditor" enclosingClass="editorWorkspace" />
</composite>
}

/// Draw the contents of the LayoutEditor Header
Method DrawLayoutEditorHeader(pSeed As %String) As %Status
{
	/* TODO restore arrange pick */
	
	/*
	Set msgLayoutEdit = $$$Text("Edit")
	Set hlpLayoutEdit = $$$Text("Cut, copy, paste and duplicate report elements")
	Set msgLayoutLayer = $$$Text("Layer")
	Set hlpLayoutLayer = $$$Text("Rearrange relative depth of report elements")
	Set msgLayoutArrange = $$$Text("Arrange")
	Set hlpLayoutArrange = $$$Text("Group and align report elements")
	Set msgLayoutTools = $$$Text("Tools")
	Set hlpLayoutTools = $$$Text("Select the active tool for the editor")
	Set captionLayout = $$$Text("Layout")
	*/
	
	Set msgLayoutEdit = "Edit"
	Set hlpLayoutEdit = "Cut, copy, paste and duplicate report elements"
	Set msgLayoutLayer = "Layer"
	Set hlpLayoutLayer = "Rearrange relative depth of report elements"
	Set msgLayoutArrange = "Arrange"	
	Set hlpLayoutArrange = "Manage groups and default alignment grid"
	Set msgLayoutAlign = "Align"
	Set hlpLayoutAlign = "Move, resize and space elements with respect to one another"
	Set msgLayoutTools = "Tools"
	Set hlpLayoutTools = "Select the active tool for the editor"
	Set captionLayout = "Layout"
	
	Set thisObj = "zenPage.getComponentById('"_$this.id_"')."
	
	Set editCB = thisObj_"showPalette(this,'edit');return(false);"
	Set layerCB = thisObj_"showPalette(this,'layer');return(false);"
	Set arrangeCB = thisObj_"showPalette(this,'arrange');return(false);"
	Set alignCB = thisObj_"showPalette(this,'align');return(false);"
	Set toolsCB = thisObj_"showPalette(this,'tools');return(false);"

	/*
	&html<<div class="headerDiv">#(captionLayout)#
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutEdit)#" onclick="#(editCB)#">#(msgLayoutEdit)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutLayer)#" onclick="#(layerCB)#">#(msgLayoutLayer)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutArrange)#" onclick="#(arrangeCB)#;">#(msgLayoutArrange)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutAlign)#" onclick="#(alignCB)#" >#(msgLayoutAlign)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutTools)#" onclick="#(toolsCB)#" >#(msgLayoutTools)#</a>
	</div>>
	*/
	&html<<div class="headerDiv">#(captionLayout)#
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutEdit)#" onclick="#(editCB)#">#(msgLayoutEdit)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutLayer)#" onclick="#(layerCB)#">#(msgLayoutLayer)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutAlign)#" onclick="#(alignCB)#" >#(msgLayoutAlign)#</a>
	&nbsp;<a class="hdrLink" href="#" title="#(hlpLayoutTools)#" onclick="#(toolsCB)#" >#(msgLayoutTools)#</a>
	</div>>
	Quit $$$OK
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._bannerWorkspaceObj = zenPage.getComponentById(this.id+".layoutEditor")
}

ClientMethod showPalette(node, pick) [ Language = javascript ]
{
	if (!this._editorCore) {
		this._editorCore = zenPage.getComponentById(zenPage._editorId);
	}
	
	var x = ZLM.getPageOffsetLeft(node);
	var y = ZLM.getPageOffsetTop(node)+node.offsetHeight;
	var p = null;
	if (pick=='edit') p=this._editorCore.getEditPopup();
	else if(pick == 'layer') p = this._editorCore.getLayerPopup();
	else if (pick == 'arrange') p = this._editorCore.getArrangePopup();
	else if (pick == 'align') p = this._editorCore.getAlignPopup();
	else if (pick == 'tools') p = this._editorCore.getToolsPopup();
	if (p) { 
		p.headerStyle = "anchor";
		p.show(x,y,true);
	}
}

ClientMethod restoreObj(o) [ Language = javascript ]
{
//	ZLM.cerr("In LEP restore...");
	var b = this.getChildById('layoutEditor');
	return(zenPage._bannerWorkspace.restoreObj(o));
}

ClientMethod exportObj() [ Language = javascript ]
{
	var b = this.getChildById('layoutEditor');
	return(zenPage._bannerWorkspace.exportObj());
}

ClientMethod exportJSON() [ Language = javascript ]
{
	var b = this.getChildById('layoutEditor');
	return(zenPage._bannerWorkspace.exportJSON());
}

ClientMethod exportZRS() [ Language = javascript ]
{
	var b = this.getChildById('layoutEditor');
	return(zenPage._bannerWorkspace.exportZRS());
}

ClientMethod setMode(mode) [ Language = javascript ]
{
	var b = this.getChildById('layoutEditor');
	b.setMode(mode);
}

ClientMethod resetMode() [ Language = javascript ]
{
	this.setMode("SELECT");
}

}
