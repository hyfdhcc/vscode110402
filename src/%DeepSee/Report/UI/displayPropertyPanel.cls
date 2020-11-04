/// %DeepSee.Report.UI.displayPropertyPanel
Class %DeepSee.Report.UI.displayPropertyPanel Extends %ZEN.Component.composite [ DependsOn = (%DeepSee.Report.UI.colorPip, %DeepSee.Report.UI.hSlider, %DeepSee.Report.UI.pickBox, %DeepSee.Report.UI.spinner, %DeepSee.Report.UI.strokeStyleBar, %DeepSee.Report.UI.strokeWidthBar, %DeepSee.Report.UI.textJustifyBar, %DeepSee.Report.UI.textStyleBar, %DeepSee.Report.UI.toggleIcon), LegacyInstanceContext, System = 4 ]
{

/* A report element style object has the following cosmetic styles
strokeApropos: [T|F];
strokeColor: #XXXXXX;
strokeOpacity: {0-100};
strokeWidth: [1,3,5];
strokeStyle: [none,dotted,dashed,solid];

fillApropos: [T|F];
fillColor: #XXXXXX;
fillOpacity: {0-100}

textApropos: [T|F];
textColor: #XXXXXX;
textOpacity: {0-100};
textBold: [T|F];
textItalic: [T|F];
textUnderline: [T|F];
textSize: {8-72};
textJustify: {left,center,right}

tableApropos: [T|F];
tableBorder: [T|F];
tableHeaderBorder: [T|F];
tableHeaderBodyDivider: [T|F];
tableHeaderColumnDivider: [T|F];
tableBodyColumnDivider: [T|F];
tableBodyRowDivider: [T|F];
tableZebraStripe: [T|F];
tableZebraColor: #XXXXXX;
*/
/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.valuesDifferCoverPlate {
	position:absolute;
	top:0px;
	left:0px;
	right:0px;
	bottom:0px;
	background: #e8e7e2;
	opacity: 0.70;
}

.enforceValueSwitch {
	position:absolute;
	top:4px;
	left:3px;
	width:8px;
	height:8px;
	border:1px solid #000077;
	background: #356b8d;
	background-image: url('images/disclosure-contracted-inv.png');
	background-repeat:no-repeat;
	background-position: 0px -1px;
}

.displayPropertyPanel {
	position:relative;
	top:0px;
	left:0px;
	background: #e8e7e2;
	width: 190px;
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	overflow:hidden;
}

.displayPropertyHeader {	
	position:relative;
	left:0px; 
	top:0px;
	height:12pt;
	width:180px;
}

.expandoNode {
	background:#356b8d;
	font:12px sans-serif;
	color:#ffffff;
}

.expandoNode a{
	color:#ffffff;
	width:100%;
}

.expandoNode a:hover {
	width:100%;
	background:#356b8d;
	color:#ffffff;
}

.dppExpandoChildren {
	font:12px sans-serif;
	color:#000077;
	margin-left:0px;
	margin-right:0px;
}

.hSlider {
	width:78px;
}

/* ### STROKE STYLE OPTIONS ### */
.strokeStylePalette {
	position:relative;
	top:0px;
	left:0px;
	height:88px;
	overflow:hidden;
}

/* -- Color ---*/
.strokeColorArea {
	position:absolute;
	left:0px;
	top:2px;
	right:0px;
	height:21px;
}

.strokeColorLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.strokeColorWidget {
	position:absolute;
	left:75px;
	top:1px;
}

/* -- Color ---*/
.strokeOpacityArea {
	position:absolute;
	left:0px;
	top:23px;
	right:0px;
	height:21px;
}

.strokeOpacityLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.strokeOpacityWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Width ---*/
.strokeWidthArea {
	position:absolute;
	left:0px;
	top:44px;
	right:0px;
	height:21px;
}

.strokeWidthLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.strokeWidthWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Style ---*/
.strokeStyleArea {
	position:absolute;
	left:0px;
	top:65px;
	right:0px;
	height:21px;
}

.strokeStyleLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.strokeStyleWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* ### FILL STYLE OPTIONS ### */
.fillStylePalette {
	position:relative;
	top:0px;
	left:0px;
	height:44px;
	overflow:hidden;
}

/* -- Color ---*/
.fillColorArea {
	position:absolute;
	left:0px;
	top:2px;
	right:0px;
	height:21px;
}

.fillColorLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.fillColorWidget {
	position:absolute;
	left:75px;
	top:1px;
}

/* -- Opacity -- */
.fillOpacityArea {
	position:absolute;
	left:0px;
	top:23px;
	right:0px;
	height:21px;
}

.fillOpacityLabel {
	position:absolute;
	left:15px;
	top:0px;
}

.fillOpacityWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* ### TEXT STYLE OPTIONS ### */

.textStylePalette {
	position:relative;
	top:0px;
	left:0px;
	height:132px;
	overflow:hidden;
}

/* -- Color ---*/
.textColorArea {
	position:absolute;
	left:0px;
	top:2px;
	right:0px;
	height:21px;
}

.textColorLabel {
	position:absolute;
	left:15px;
	top:3px;
}

.textColorWidget {
	position:absolute;
	left:75px;
	top:2px;
}

/* -- Opacity ---*/
.textOpacityArea {
	position:absolute;
	left:0px;
	top:23px;
	right:0px;
	height:21px;
}

.textOpacityLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.textOpacityWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Style ---*/
.textStyleArea {
	position:absolute;
	left:0px;
	top:44px;
	right:0px;
	height:21px;
}

.textStyleLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.textStyleWidget {
	position:absolute;
	left:75px;
	top:1px;
}

/* -- Size ---*/
.textSizeArea {
	position:absolute;
	left:0px;
	top:65px;
	right:0px;
	height:21px;
}

.textSizeLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.textSizeWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Justify ---*/
.textJustifyArea {
	position:absolute;
	left:0px;
	top:86px;
	right:0px;
	height:21px;
}

.textJustifyLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.textJustifyWidget {
	position:absolute;
	left:75px;
	top:1px;
}

/* -- Font ---*/
.textFontArea {
	position:absolute;
	left:0px;
	top:107px;
	right:0px;
	height:21px;
}

.textFontLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.textFontWidget {
	position:absolute;
	left:75px;
	top:0px;
}

.textFontWidget .pickBoxValueDiv {
	font:11px sans-serif;
}




.borderPalette {
	position:relative;
	top:0px;
	left:0px;
	height:84px;
	overflow:hidden;
}

.tableZebraColorWidget {
	position:absolute;
	top:45px;
	left:125px;
}

.tableZebraColorWidget .colorPip {
	width:30px;
	height:30px;
}

.tableZebraColorWidget .colorPipPreview {
	width:28px;
	height:28px;
}


/* ### GEOMETRY OPTIONS ### */
.sizePalette {
	position:relative;
	top:0px;
	left:0px;
	height:88px;
	overflow:hidden;
}

/* -- Width ---*/
.sizeWidthArea {
	position:absolute;
	left:0px;
	top:2px;
	right:0px;
	height:21px;
}

.sizeWidthLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.sizeWidthWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Height ---*/
.sizeHeightArea {
	position:absolute;
	left:0px;
	top:23px;
	right:0px;
	height:21px;
}

.sizeHeightLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.sizeHeightWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Left ---*/
.sizeLeftArea {
	position:absolute;
	left:0px;
	top:44px;
	right:0px;
	height:21px;
}

.sizeLeftLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.sizeLeftWidget {
	position:absolute;
	left:75px;
	top:0px;
}

/* -- Top ---*/
.sizeTopArea {
	position:absolute;
	left:0px;
	top:65px;
	right:0px;
	height:21px;
}

.sizeTopLabel {
	position:absolute;
	left:15px;
	top:1px;
}

.sizeTopWidget {
	position:absolute;
	left:75px;
	top:0px;
}
</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="displayPropertyPanel" >
<html id="displayPropertyHeader"  OnDrawContent="DrawLayoutPropertyHeader"></html>

<group id="displayPropertyBody" layout="none" >
<expando id="strokeCtrl" layout="none" caption="Line Style" remember="true" imageContracted="images/disclosure-contracted-inv.png" imageExpanded="images/disclosure-expanded-inv.png" >
<group enclosingClass="strokeStylePalette" layout="none">

<group enclosingClass="strokeColorArea" layout="none">
<label enclosingClass="strokeColorLabel" value="Color:" />
<colorPip id="_strokeColor" enclosingClass="strokeColorWidget" onchange="zenThis.composite.applyChange('_strokeColor','strokeColor');"/>
<group id="strokeColorAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="strokeColorAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('strokeColor',1);"/>
</group>
</group>

<group enclosingClass="strokeOpacityArea" layout="none">
<label enclosingClass="strokeOpacityLabel" value="Opacity:" />
<hSlider id="_strokeOpacity" enclosingClass="strokeOpacityWidget" value="1" onchange="zenThis.composite.applyChange('_strokeOpacity','strokeOpacity');"/>
<group id="strokeOpacityAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="strokeOpacityAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('strokeOpacity',1);"/>
</group>
</group>

<group enclosingClass="strokeWidthArea" layout="none">
<label enclosingClass="strokeWidthLabel" value="Width:" />
<strokeWidthBar id="_strokeWidth" enclosingClass="strokeWidthWidget" onchange="zenThis.composite.applyChange('_strokeWidth','strokeWidth');"/>
<group id="strokeWidthAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="strokeWidthAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('strokeWidth',1);"/>
</group>
</group>

<group enclosingClass="strokeStyleArea" layout="none">
<label enclosingClass="strokeStyleLabel" value="Style:" />
<strokeStyleBar id="_strokeStyle" enclosingClass="strokeStyleWidget" onchange="zenThis.composite.applyChange('_strokeStyle','strokeStyle');"/>
<group id="strokeStyleAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="strokeStyleAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('strokeStyle',1);"/>
</group>
</group>

</group>
</expando>

<expando id="fillCtrl" layout="none" caption="Fill Style" remember="true"  imageContracted="images/disclosure-contracted-inv.png" imageExpanded="images/disclosure-expanded-inv.png" >
<group enclosingClass="fillStylePalette" layout="none">

<group enclosingClass="fillColorArea" layout="none">
<label enclosingClass="fillColorLabel" value="Color:" />
<colorPip id="_fillColor" enclosingClass="fillColorWidget" onchange="zenThis.composite.applyChange('_fillColor','fillColor');"/>
<group id="fillColorAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="fillColorAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('fillColor',1);"/>
</group>
</group>

<group enclosingClass="fillOpacityArea" layout="none">
<label enclosingClass="fillOpacityLabel" value="Opacity:" />
<hSlider id="_fillOpacity" enclosingClass="fillOpacityWidget" value="0" onchange="zenThis.composite.applyChange('_fillOpacity','fillOpacity');"/>
<group id="fillOpacityAreaPlate" enclosingClass="valuesDifferCoverPlate">
<group id="fillOpacityAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('fillOpacity',1);"/>
</group>

</group>

</group>
</expando>

<expando id="textCtrl" layout="none" caption="Text Style" remember="true"  imageContracted="images/disclosure-contracted-inv.png" imageExpanded="images/disclosure-expanded-inv.png" >
<group layout="none" enclosingClass="textStylePalette" >

<group enclosingClass="textColorArea" layout="none">
<label enclosingClass="textColorLabel" value="Color:" />
<colorPip id="_textColor" enclosingClass="textColorWidget" onchange="zenThis.composite.applyChange('_textColor','textColor');"/>
<group id="textColorAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="textColorAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('textColor',1);"/>
</group>
</group>

<group enclosingClass="textOpacityArea" layout="none">
<label enclosingClass="textOpacityLabel" value="Opacity:" />
<hSlider id="_textOpacity" enclosingClass="textOpacityWidget" value="1" onchange="zenThis.composite.applyChange('_textOpacity','textOpacity');"/>
<group id="textOpacityAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="textOpacityAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('textOpacity',1);"/>
</group>
</group>

<group enclosingClass="textStyleArea" layout="none">
<label enclosingClass="textStyleLabel" value="Style:" />
<textStyleBar id="_textStyle" enclosingClass="textStyleWidget" onchange="zenThis.composite.applyChange('_textStyle','textStyle');"/>
<group id="textStyleAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="textStyleAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('textStyle',1);"/>
</group>
</group>

<group enclosingClass="textSizeArea" layout="none">
<label enclosingClass="textSizeLabel" value="Size:" />
<spinner id="_textSize" enclosingClass="textSizeWidget" units="pt" value="12" minValue="8" maxValue="72" onchange="zenThis.composite.applyChange('_textSize','textSize');"/>
<group id="textSizeAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="textSizeAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('textSize',1);"/>
</group>
</group>

<group enclosingClass="textJustifyArea" layout="none">
<label enclosingClass="textJustifyLabel" value="Justify:" />
<textJustifyBar id="_textJustify" enclosingClass="textJustifyWidget" onchange="zenThis.composite.applyChange('_textJustify','textJustify');"/>
<group id="textJustifyAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="textJustifyAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('textJustify',1);"/>
</group>
</group>

<group enclosingClass="textFontArea" layout="none">
<label enclosingClass="textFontLabel" value="Font:" />
<pickBox id="_textFont" enclosingClass="textFontWidget" onchange="zenThis.composite.applyChange('_textFont','textFont');" valueList="monospace,serif,sans-serif" />
<group id="textFontAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="textFontAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('textFont',1);"/>
</group>
</group>

</group>
</expando>

<expando id="borderCtrl" layout="none" caption="Borders and Dividers" remember="true"  imageContracted="images/disclosure-contracted-inv.png" imageExpanded="images/disclosure-expanded-inv.png" >
<group layout="none" enclosingClass="borderPalette" >
<toggleIcon id="_tableBorder" caption="Toggle table border" contextIcon="portal/table_border.png" enclosingStyle="position:absolute; top:5px; left:5px;" ontoggle="zenThis.composite.applyChange('_tableBorder','tableBorder');"/>
<toggleIcon id="_headerBorder" caption="Toggle header border" contextIcon="portal/header_border.png" enclosingStyle="position:absolute; top:5px; left:45px;"  ontoggle="zenThis.composite.applyChange('_headerBorder','tableHeaderBorder');"/>
<toggleIcon id="_headerBodyDivider" caption="Toggle divider between header and body" contextIcon="portal/header_body_divide.png" enclosingStyle="position:absolute; top:5px; left:85px;"  ontoggle="zenThis.composite.applyChange('_headerBodyDivider','tableHeaderBodyDivider');"/>
<toggleIcon id="_headerColumnDivider" caption="Toggle divider between header columns" contextIcon="portal/header_col_divider.png" enclosingStyle="position:absolute; top:5px; left:125px;"  ontoggle="zenThis.composite.applyChange('_headerColumnDivider','tableHeaderColumnDivider');"/>
<toggleIcon id="_bodyColumnDivider" caption="Toggle divider between body columns" contextIcon="portal/body_col_divider.png" enclosingStyle="position:absolute; top:45px; left:5px;"  ontoggle="zenThis.composite.applyChange('_bodyColumnDivider','tableBodyColumnDivider');"/>
<toggleIcon id="_bodyRowDivider" caption="Toggle divider between body rows" contextIcon="portal/body_row_divider.png" enclosingStyle="position:absolute; top:45px; left:45px;"  ontoggle="zenThis.composite.applyChange('_bodyRowDivider','tableBodyRowDivider');"/>
<toggleIcon id="_zebraStripes" caption="Toggle zebra striping in body" contextIcon="portal/zebraStripes.png" enclosingStyle="position:absolute; top:45px; left:85px;"  ontoggle="zenThis.composite.applyChange('_zebraStripes','tableZebraStripe');"/>
<colorPip id="_zebraColor" enclosingClass="tableZebraColorWidget" onchange="zenThis.composite.applyChange('_zebraColor','tableZebraColor');" /> 
</group>

</expando>

<expando id="sizeCtrl" layout="none" caption="Size and Position" remember="true"  imageContracted="images/disclosure-contracted-inv.png" imageExpanded="images/disclosure-expanded-inv.png" >
<group layout="none" enclosingClass="sizePalette" >


<group enclosingClass="sizeWidthArea" layout="none">
<label enclosingClass="sizeWidthLabel" value="Width:" />
<spinner id="_sizeWidth" enclosingClass="sizeWidthWidget" units="pt" value="0" minValue="0" maxValue="468" onchange="zenThis.composite.applyChange('_sizeWidth','sizeWidth');" />
<group id="sizeWidthAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="sizeWidthAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('sizeWidth',1);"/>
</group>
</group>

<group enclosingClass="sizeHeightArea" layout="none">
<label enclosingClass="sizeHeightLabel" value="Height:" />
<spinner id="_sizeHeight" enclosingClass="sizeHeightWidget" units="pt" value="0" minValue="0" maxValue="648" onchange="zenThis.composite.applyChange('_sizeHeight','sizeHeight');"/>
<group id="sizeHeightAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="sizeHeightAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('sizeHeight',1);"/>
</group>
</group>

<group enclosingClass="sizeLeftArea" layout="none">
<label enclosingClass="sizeLeftLabel" value="Offset X:" />
<spinner id="_sizeLeft" enclosingClass="sizeLeftWidget" units="pt" value="0" minValue="0" maxValue="468" onchange="zenThis.composite.applyChange('_sizeLeft','sizeLeft');"/>
<group id="sizeLeftAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="sizeLeftAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('sizeLeft',1);"/>
</group>
</group>

<group enclosingClass="sizeTopArea" layout="none">
<label enclosingClass="sizeTopLabel" value="Offset Y:" />
<spinner id="_sizeTop" enclosingClass="sizeTopWidget" units="pt" value="0" minValue="0" maxValue="648" onchange="zenThis.composite.applyChange('_sizeTop','sizeTop');"/>
<group id="sizeTopAreaPlate" enclosingClass="valuesDifferCoverPlate" >
<group id="sizeTopAreaOverride" enclosingClass="enforceValueSwitch" layout="none" onclick="zenThis.composite.enableProperty('sizeTop',1);"/>
</group>
</group>

</group>
</expando>
</group>
</composite>
}

/// Draw the contents of the LayoutList Header (the region above the Layout view property list).
Method DrawLayoutPropertyHeader(pSeed As %String) As %Status
{
	&html<<div class="headerDiv">Properties
	</div>>
	Quit $$$OK
}

Method GetFontList() As %ZEN.Datatype.string [ ZenMethod ]
{
	Set model = ##class(%DeepSee.Report.Config.configData).GetFontList()
	Quit model
}

ClientMethod enableProperty(name, notify) [ Language = javascript ]
{
	var pl = this.propertyList;
	
	// traps for special cases
	if (name=="textBold" || name=="textItalic" || name=="textUnderline") {
		pl[name]=true;
		// All style options must be true in order for "textStyle" to be enabled
		if (!pl["textBold"] || !pl["textItalic"] || !pl["textItalic"]) return;
		name = "textStyle";
	}
	var groupName = this.id+"."+name+"AreaPlate"
	var div = document.getElementById(groupName);
	if (div) div.style.display="none";
	pl[name]=true;
	if (notify) this.applyChange("_"+name,name);
}

ClientMethod disableProperty(name) [ Language = javascript ]
{
	var pl = this.propertyList;
	// traps for special cases
	if (name=="textBold" || name=="textItalic" || name=="textUnderline") {
		pl[name]=false;
		// If any style option is disabled, "textStyle" is also disabled
		name = "textStyle";
	}
	var groupName = this.id+"."+name+"AreaPlate"
	var div = document.getElementById(groupName);
	if (div) div.style.display="block";
	pl[name]=false;
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.propertyList = {};
	
	var fc = zenPage.getComponentById(this.id+".strokeCtrl");
	var gp = fc.findElement("expandoChildren");
	gp.className = "dppExpandoChildren";
	
	var fc = zenPage.getComponentById(this.id+".fillCtrl");
	var gp = fc.findElement("expandoChildren");
	gp.className = "dppExpandoChildren";
	
	var fc = zenPage.getComponentById(this.id+".textCtrl");
	var gp = fc.findElement("expandoChildren");
	gp.className = "dppExpandoChildren";
	
	var fc = zenPage.getComponentById(this.id+".sizeCtrl");
	var gp = fc.findElement("expandoChildren");
	gp.className = "dppExpandoChildren";

	var fl = this.getChildById("_textFont");
	var fonts = this.GetFontList()+",monospace,serif,sans-serif";
	fl.setProperty("options",fonts);
	ZRU.layoutPropertyIndex = this.index;
	ZRU.layoutPropertyWidget = this;
	this.updateControls();
}

/// Set the maximum allowable position value (in points) based on the 
/// width and height of the printable body area.
ClientMethod setBodySize(width, height) [ Language = javascript ]
{
	this.getChildById("_sizeWidth").setProperty("maxValue",width);
	this.getChildById("_sizeHeight").setProperty("maxValue",height);
	this.getChildById("_sizeLeft").setProperty("maxValue",width);
	this.getChildById("_sizeTop").setProperty("maxValue",height);
}

ClientMethod adjustHeight(maxH) [ Language = javascript ]
{
	var hdr = document.getElementById(this.id+".displayPropertyHeader");
	var h = hdr.offsetHeight;
	var dpb = zen(this.id+".displayPropertyBody");
	dpb.getEnclosingDiv().style.height=(maxH-h)+"px";
	dpb.getEnclosingDiv().style.overflow="auto";
}

ClientMethod initializeStyleObject() [ Language = javascript ]
{
	this.styleObj = this.makeGC();
}

ClientMethod applyChange(deltaId, attr) [ Language = javascript ]
{
	var s = this.styleObj;
	
	var who = this.getChildById(deltaId);
	if (attr=='strokeWidth') {
		var v = who.getValue();
		if (v=="fine") s.strokeWidth="1";
		else if (v=="medium") s.strokeWidth="3";
		else if (v=="broad") s.strokeWidth="5";
	}
	else if (attr=='fillColor') {
		s.fillColor = who.getValue();
		if (this.getChildById('_fillOpacity').getValue()==0) {
			s.fillOpacity=1;
			this.updateControls();
		}
	} 
	else if (deltaId=='_textStyle') {
		var v = who.getValue();
		s.textBold = v.bold;
		s.textItalic = v.italic;
		s.textUnderline = v.underline;
	}
	else {		
		this.styleObj[attr] = who.getValue();
	}
	if (deltaId=="_zebraStripes") this.updateControls();
	// With multiselect enabled, now we only want to export "approved" properties
	var newGC = {};
	var pl = this.propertyList;
	for (var p in s) {
		if (pl[p]) newGC[p] = s[p];
	}
	zenPage._editor.updateGC(newGC);
}

ClientMethod updateControls() [ Language = javascript ]
{
	var n = this.id;
	this.strokePanelStyle = document.getElementById(n+'.strokeCtrl').style;
	this.fillPanelStyle = document.getElementById(n+'.fillCtrl').style;
	this.textPanelStyle = document.getElementById(n+'.textCtrl').style;
	this.borderPanelStyle = document.getElementById(n+'.borderCtrl').style;
	this.sizePanelStyle = document.getElementById(n+'.sizeCtrl').style;

	var s = this.styleObj;
	if (!s) {
		this.initializeStyleObject();
		s = this.styleObj;
	}

	if (s.strokeApropos) {
		this.strokePanelStyle.display="";
		this.getChildById("_strokeColor").setValue(s.strokeColor);
		this.getChildById("_strokeOpacity").setValue(s.strokeOpacity);
		var w="broad";
		if (s.strokeWidth<4) w="medium";
		if (s.strokeWidth<2) w="fine";
		this.getChildById("_strokeWidth").setValue(w);
		this.getChildById("_strokeStyle").setValue(s.strokeStyle);
	}
	else this.strokePanelStyle.display="none";
	
	if (s.fillApropos) {
		this.fillPanelStyle.display="";
		this.getChildById("_fillColor").setValue(s.fillColor);
		this.getChildById("_fillOpacity").setValue(s.fillOpacity);
	}
	else this.fillPanelStyle.display="none";
	if (s.textApropos) {
		this.textPanelStyle.display="";
		this.getChildById("_textColor").setValue(s.textColor);
		this.getChildById("_textOpacity").setValue(s.textOpacity);
		this.getChildById("_textStyle").setValue({'bold':s.textBold,'italic':s.textItalic,'underline':s.textUnderline});
		this.getChildById("_textSize").setValue(s.textSize);
		this.getChildById("_textJustify").setValue(s.textJustify);
		this.getChildById("_textFont").setValue(s.textFont);
	}
	else this.textPanelStyle.display="none";

	if (s.tableApropos) {
		this.borderPanelStyle.display="";
		this.getChildById("_tableBorder").setValue(s.tableBorder);
		this.getChildById("_headerBorder").setValue(s.tableHeaderBorder);
		this.getChildById("_headerBodyDivider").setValue(s.tableHeaderBodyDivider);
		this.getChildById("_headerColumnDivider").setValue(s.tableHeaderColumnDivider);
		this.getChildById("_bodyColumnDivider").setValue(s.tableBodyColumnDivider);
		this.getChildById("_bodyRowDivider").setValue(s.tableBodyRowDivider);
		this.getChildById("_zebraStripes").setValue(s.tableZebraStripe);
		var z = this.getChildById("_zebraColor");
		z.setValue(s.tableZebraColor);
		var d = z.getEnclosingDiv();
		if (s.tableZebraStripe) d.style.display="block";
		else d.style.display="none";
	}
	else this.borderPanelStyle.display="none";

	if (s.sizeApropos) {
		this.sizePanelStyle.display="";
		this.getChildById("_sizeWidth").setValue(parseInt(s.sizeWidth,10));
		this.getChildById("_sizeHeight").setValue(parseInt(s.sizeHeight,10));
		this.getChildById("_sizeLeft").setValue(parseInt(s.sizeLeft,10));
		this.getChildById("_sizeTop").setValue(parseInt(s.sizeTop,10));
	}
	else this.sizePanelStyle.display="none";
}

ClientMethod getBorderSettings() [ Language = javascript ]
{
	var r={};
	r.tableBorder = this.getComponentById("_tableBorder").getValue();
	r.headerBorder = this.getComponentById("_headerBorder").getValue();
	r.headerBodyDivider = this.getComponentById("_headerBodyDivider").getValue();
	r.headerColumnDivider = this.getComponentById("_headerColumnDivider").getValue();
	r.bodyColumnDivider = this.getComponentById("_bodyColumnDivider").getValue();
	r.bodyRowDivider = this.getComponentById("_bodyRowDivider").getValue();
	r.zebraStripes = this.getComponentById("_zebraStripes").getValue();
	return(r);
}

ClientMethod setTitle(title) [ Language = javascript ]
{
	var c = zenPage.getComponentById(this.id+'.titleBox');
	c.setProperty('value',title);
}

ClientMethod makeGC() [ Language = javascript ]
{
	var g = {
		'strokeApropos':true,
		'strokeColor':'#000000',
		'strokeOpacity':1,
		'strokeWidth':1,
		'strokeStyle':'solid',
		
		'fillApropos':true,
		'fillColor':'#ffffff',
		'fillOpacity':0,

		'textApropos':true,
		'textColor':'#000000',
		'textOpacity':1,
		'textBold':false,
		'textItalic':false,
		'textUnderline':false,
		'textSize':12,
		'textJustify':'left',
		'textFont':'sans-serif',

		'tableApropos':true,
		'tableBorder':false,
		'tableHeaderBorder':false,
		'tableHeaderBodyDivider':false,
		'tableHeaderColumnDivider':false,
		'tableBodyColumnDivider':false,
		'tableBodyRowDivider':false,
		'tableZebraStripe':false,
		'tableZebraColor':'#bfffcf',
		
		'sizeApropos':false,
		'sizeWidth':0,
		'sizeHeight':0,
		'sizeTop':0,
		'sizeLeft':0
	}
	return(g);
}

ClientMethod setDefaultGC(obj) [ Language = javascript ]
{
	this.defaultGC = obj;
}

ClientMethod setActiveGC(src) [ Language = javascript ]
{
	for (var p in src ) {
		this.styleObj[p] = src[p];
	}
	this.updateControls();
}

ClientMethod cloneGC(src) [ Language = javascript ]
{
	var gc = {};
	for (var p in src) {
		gc[p] = src[p];
	}
	return(gc);
}

/// Create a new GC based on the data of a shorthand object
ClientMethod makeGCFromObj(s) [ Language = javascript ]
{
	var sObj = {}
	for (var p in s) {
		var rp = p;
		if (p.indexOf('"')==0) rp=p.split('"')[1];
		else if (p.indexOf("'")==0) rp.split("'")[1];
		sObj[rp] = s[p];
	}
	s = sObj;
	var g = this.makeGC();
	if (s.sa) {
		g.strokeApropos = true;
		g.strokeColor = s.sc;
		g.strokeOpacity = s.so;
		g.strokeWidth = s.sw;
		g.strokeStyle = s.ss;
	}
	else g.strokeApropos=false;
		
	if (s.fa) {
		g.fillApropos = true;
		g.fillColor = s.fc;
		g.fillOpacity = s.fo;
	}
	else g.fillApropos = false;
	
	if (s.xa) {
		g.textApropos = true;
		g.textColor = s.xc;
		g.textOpacity = s.xo;
		g.textBold = s.xb;
		g.textItalic = s.xi;
		g.textUnderline = s.xu;
		g.textSize = s.xs;
		g.textJustify = s.xj;		
		g.textFont = s.xf;	
	}
	else g.textApropos = false;

	if (s.ta) {
		g.tableApropos = true;
		g.tableBorder = s.tb;
		g.tableHeaderBorder = s.thb;
		g.tableHeaderBodyDivider = s.thbd;
		g.tableHeaderColumnDivider = s.thcd;
		g.tableBodyColumnDivider = s.tbcd;
		g.tableBodyRowDivider = s.tbrd;
		g.tableZebraStripe = s.tzs;
		g.tableZebraColor = s.tzc;		
	}
	else g.tableApropos = false;
	
	if (s.za) {
		g.sizeApropos = true;
		g.sizeWidth = parseInt(s.zw,10);
		g.sizeHeight = parseInt(s.zh,10);
		g.sizeTop = parseInt(s.zt,10);
		g.sizeLeft = parseInt(s.zl,10);
	}
	else g.sizeApropos = false;
	return(g);
}

/// Return a shorthand notation of the give GC object for more
/// compact JSON transmission
ClientMethod projectGCAsObj(src) [ Language = javascript ]
{
	var s={};
	if (src.strokeApropos) {
		s.sa = 1;
		s.sc = src.strokeColor;
		s.so = src.strokeOpacity;
		s.sw = src.strokeWidth;
		s.ss = src.strokeStyle;
	}
	else s.sa = 0;
	
	if (src.fillApropos) {
		s.fa = 1;
		s.fc = src.fillColor;
		s.fo = src.fillOpacity;
	}
	else s.fa = 0;
	
	if (src.textApropos) {
		s.xa = 1;	
		s.xc = src.textColor;
		s.xo = src.textOpacity;
		s.xb = src.textBold;
		s.xi = src.textItalic;
		s.xu = src.textUnderline;
		s.xs = src.textSize;
		s.xj = src.textJustify;		
		s.xf = src.textFont;	
	}
	else s.xa = 0;

	if (src.tableApropos) {
		s.ta = 1;
		s.tb = src.tableBorder;
		s.thb = src.tableHeaderBorder;
		s.thbd = src.tableHeaderBodyDivider;
		s.thcd = src.tableHeaderColumnDivider;
		s.tbcd = src.tableBodyColumnDivider;
		s.tbrd = src.tableBodyRowDivider;
		s.tzs = src.tableZebraStripe;
		s.tzc = src.tableZebraColor;		
	}
	else s.ta = 0;
	
	if (src.sizeApropos) {
		s.za = 1;
		s.zw = parseInt(src.sizeWidth,10);
		s.zh = parseInt(src.sizeHeight,10);
		s.zt = parseInt(src.sizeTop,10);
		s.zl = parseInt(src.sizeLeft,10);
	}
	else s.za = 0;
	
	return(s);
}

ClientMethod projectGCAsJS(src) [ Language = javascript ]
{
	var s=[];
	if (src.strokeApropos) {
		s.push('color:'+src.strokeColor+';');
		s.push('opacity:'+src.strokeOpacity+';');
		s.push('borderWidth:'+src.strokeWidth+';');
		s.push('borderStyle:'+src.strokeStyle+';');
	}
	if (src.fillApropos) {
		if (src.fillColor=="#ffffff" && src.fillOpacity==0) {
			s.push('background:transparent;');
		}
		else {
			s.push('backgroundColor:'+src.fillColor+';');
			s.push('opacity:'+src.fillOpacity+';');
		}
	}
	if (src.textApropos) {	
		s.push("color:"+src.textColor+";");
		s.push("opacity:"+src.textOpacity+";");
		if (src.textBold) s.push("fontWeight:bold;");
		if (src.textItalic) s.push("fontStyle:italic;");
		if (src.textUnderline) s.push("textDecoration:underline;");
		s.push("fontSize:"+src.textSize+"pt;");
		s.push("textAlign:"+src.textJustify+";");		
		s.push("fontFamily:"+src.textFont+";");	
	}
	// TABLE SETTINGS ARE A DIFFERENT BEAST
	if (src.sizeApropos) {
		s.push('width:'+src.sizeWidth+'pt;');
		s.push('height:'+src.sizeHeight+'pt;');
		s.push('top:'+src.sizeTop+'pt;');
		s.push('left:'+src.sizeLeft+'pt;');
	}
	return(s.join(''));
}

ClientMethod projectGCAsJSON(src) [ Language = javascript ]
{
	var a = [];
	for (p in src) {
		a.push(p+':');
		if (typeof(src[p])=="string") a.push("'"+src[p]+"'");
		else a.push(src[p]);
		a.push(',');
	}
	a.pop();
	var str = a.join('');
	return(str);
}

ClientMethod mergeStyleSection(gc, altGC, section, sectionProperties) [ Language = javascript ]
{
	// If the altGC defines a section that we currently don't support, take its values
	// as the baseline and enable all the related properties.  If we both support this 
	// section, disable any properties were our values differ. 
	if (altGC[section]) {
		var l = sectionProperties.length;
		if (!gc[section]) {
			gc[section] = true;
			for (var j=0;j<l;j++) {
				var p = sectionProperties[j];
				gc[p]=altGC[p];
				this.enableProperty(p);
			}
		}
		else {
			for (var j=0;j<l;j++) {
				var p = sectionProperties[j];
				if (altGC[p]!=gc[p]) this.disableProperty(p);
			}
		}
	}
}

ClientMethod mergeStyleProperties(a) [ Language = javascript ]
{
	var len = a.length;
	if (len==0) {
		var src = this.defaultGC;
		for (var p in src) {
			this.enableProperty(p);
		}
		return(src);
	}
	var gc = {};
	var src = a[0].gc;
	for (var p in src) {
		gc[p] = src[p];
		this.enableProperty(p);
	}
	for (var i=1;i<len;i++) {
		src = a[i].gc;
		this.mergeStyleSection(gc,src,"strokeApropos",["strokeColor","strokeOpacity","strokeWidth","strokeStyle"]);
		this.mergeStyleSection(gc,src,"fillApropos",["fillColor","fillOpacity"]);
		this.mergeStyleSection(gc,src,"textApropos",["textColor","textOpacity","textBold","textItalic","textUnderline","textSize","textJustify","textFont"]);
		this.mergeStyleSection(gc,src,"tableApropos",["tableBorder","tableHeaderBorder","tableHeaderBodyDivider","tableHeaderColumnDivider","tableBodyColumnDivider","tableBodyRowDivider","tableZebraStripe","tableZebraColor"]);
		this.mergeStyleSection(gc,src,"sizeApropos",["sizeWidth","sizeHeight","sizeTop","sizeLeft"]);
	}	
	return(gc);
}

}
