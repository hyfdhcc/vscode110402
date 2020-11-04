/// bannerWorkspace
Class %DeepSee.Report.UI.bannerWorkspace Extends %ZEN.Component.component [ LegacyInstanceContext, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zendsrpt.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">

.bannerWorkspace {
	border:1pt solid black;
	margin-left:auto; 
	margin-right:auto;
	background: white;
}

.bannerItemBody {
	position:relative;	
	width:100%;
	height:100%;
	top:0px;
	left:0px;
	display:block;
}

.bannerItem {
	white-space:nowrap;
	position:absolute;
	overflow:hidden;
	background:transparent;
}

.bannerItemSelected {
	white-space:nowrap;
	position:absolute;
	overflow:hidden; 
	background:#ffeeaa;
}

.bannerItemAlsoSelected {
	white-space:nowrap;
	position:absolute;
	overflow:hidden; 
	background:#fffab6;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<<div id="#(..%MakeId("workArea"))#" class='bannerWorkspace' pageWidth='6.5' units='in' sections='0' ></div>>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace=new ZRU.BannerWorkspace(bDiv);
	
	zenPage._bannerWorkspaceIndex = this.index;
	zenPage._bannerWorkspaceWidget = this;
	zenPage._bannerWorkspace = bDiv.LIDRWorkspace;
}

ClientMethod initSchema(rDef) [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace.initSchema(rDef);
}

ClientMethod initSchemaFromDSS(obj) [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace.initSchemaDSS(obj);
}

ClientMethod autoFillFromDSS(rptName) [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace.autoFill(rptName);
}

ClientMethod setPageModel(obj) [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace.setPageModel(obj);
}

ClientMethod restoreSchema(rDef) [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace.restoreSchema(rDef);
}

ClientMethod setMode(mode) [ Language = javascript ]
{
	var bDiv = this.findElement("workArea");
	bDiv.LIDRWorkspace.setEditMode(mode);
}

ClientMethod resetMode() [ Language = javascript ]
{
	this.setMode("SELECT");
}

}
