/// RGUI.hSlider
Class %DeepSee.Report.UI.colorPip Extends %ZEN.Component.control [ System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">

.colorPip {
	position:relative;
	top:0px;
	left:0px;
	border:1px solid #575757;
	padding:2px;
	height:12px;
	width:70px;
}

.colorPipPreview {
	border:1px solid #000000;
	background:red;
	height:10px;
	width:68px;
}

#colorsPalettePopup .popKidFrame {
	overflow:hidden;
	padding:0px;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="colorPip" > 
		<div id="#(..%MakeId("preview"))#" class="colorPipPreview" onclick="this.controller.serviceClick();"></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._base = this.findElement('base');
	this._controller = this;
	this._preview = this.findElement('preview');
	this._preview.controller = this;
}

ClientMethod bookmarkWidgets() [ Language = javascript ]
{
	this._editorCore = zenPage.getComponentById(zenPage._editorId);
	this._popup = this._editorCore.getColorsPopup();
	this._palette = this._editorCore.getColorsWidget();
	
	var f = this._popup.getChildDiv();
	f.style.overflow="hidden";
	f.style.padding="none";
}

ClientMethod serviceClick() [ Language = javascript ]
{
	if (!this._editorCore) this.bookmarkWidgets();

	//MAGIC NUMBER ALERT!!!
	var x = ZLM.getPageOffsetLeft(this._base)+this._base.offsetWidth-288;
	var y = ZLM.getPageOffsetTop(this._base)+this._base.offsetHeight;
	this._popup.headerStyle="none";
	this._palette.setValue(this.value);
	this._palette.setProperty("onchange","zenPage.getComponent("+this.index+").serviceChange();");
	this._popup.show(x,y,true);
}

ClientMethod serviceChange() [ Language = javascript ]
{
	if (!this._editorCore) this.bookmarkWidgets();

	this._popup.popAway();
	var v = this._palette.getValue();
	this.setValue(v);
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.value=value;
		this.findElement('preview').style.background=value;
		break;

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
