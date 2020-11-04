Class %DeepSee.Report.UI.editLIDR Extends %ZEN.Component.composite [ DependsOn = (%DeepSee.Report.UI.captionEditor, %DeepSee.Report.UI.popGroup, %DeepSee.Report.UI.chartInfoWizard, %DeepSee.Report.UI.imageURLWizard, %DeepSee.Report.UI.textInfoWizard, %DeepSee.Report.UI.editIconBar, %DeepSee.Report.UI.layerIconBar, %DeepSee.Report.UI.arrangeIconBar, %DeepSee.Report.UI.alignIconBar, %DeepSee.Report.UI.toolIconBar, %DeepSee.Report.UI.colorPalette, %DeepSee.Report.UI.workingDataSetPane, %DeepSee.Report.UI.layoutEditorPanel, %DeepSee.Report.UI.displayPropertyPanel), LegacyInstanceContext, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">

.headerDiv {
	width:100%;
	padding: 5px;
	height: 12pt;
	color: #404040;
	background: #e8e7e2;
	border-bottom: 1px solid #C0C0C0;
}


</style>
}

/// Contents of this composite component:
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none">

	<captionEditor id="txtEditor" />
	
	<popGroup id="chartWizardPopup" height="350px" width="456px" header="Chart Wizard" >
	<chartInfoWizard id="chartInfoWizard" />
	</popGroup>
	
	<popGroup id="textObjectInfoPopup" height="102px" width="171px" header="Object Info">
	<textInfoWizard id="textInfoWizard" />
	</popGroup>

	<popGroup id="pgNumObjectInfoPopup" height="142px" width="171px" header="Object Info">
	<pageNumberWizard id="pageNumberWizard" />
	</popGroup>
	
	<popGroup id="barcodeInfoPopup" height="307px" width="286px" header="Object Info">
	<barcodeWizard id="barcodeWizard" />
	</popGroup>
	
	<popGroup id="imageURLInfoPopup" height="142px" width="273px" header="Object Info">
	<imageURLWizard id="imageURLWizard" />
	</popGroup>
	
	<!-- Pop groups for tool palettes should be 49 px tall and 34*n+4 -->
	<popGroup id="editPalettePopup" height="49px" width="174px" header="Edit Operations">
	<editIconBar id="editPalette" onchange="zenThis.composite.editCB();" />
	</popGroup>

	<popGroup id="layerPalettePopup" height="49px" width="140px" header="Layer Operations">
	<layerIconBar id="layerPalette" onchange="zenThis.composite.layerCB();" />
	</popGroup>

	<popGroup id="arrangePalettePopup" height="49px" width="140px" header="Arrangement Operations">
	<arrangeIconBar id="arrangePalette" onchange="zenThis.composite.arrangeCB();" />
	</popGroup>

	<popGroup id="alignPalettePopup" height="49px" width="339px" header="Alignment Operations">
	<alignIconBar id="alignPalette" onchange="zenThis.composite.alignCB();" />
	</popGroup>

	<popGroup id="toolsPalettePopup" height="49px" width="240px" header="Tools">
	<toolIconBar id="toolsPalette" onchange="zenThis.composite.toolChangeCB();" />
	</popGroup>

	<popGroup id="colorsPalettePopup" height="104px" width="296px" header="Colors">
	<colorPalette id="colorsPalette" />
	</popGroup>

	<hgroup cellVAlign="top">
	<workingDataSetPane layout="none" id="workingDataSetPanel"  />
	<layoutEditorPanel layout="none" id="layoutEditorPanel" />
	<displayPropertyPanel layout="none" id="displayPropertyPanel" enclosingClass="displayPropertyPanel" />
	</hgroup>
    </composite>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	zenPage._editorId = this.id;
	zenPage._editor = this;
	
	this._chartWPopup = zenPage.getComponentById(this.id+".chartWizardPopup");
	this._chartWidget = zenPage.getComponentById(this.id+".chartInfoWizard");

	this._textInfoPopup = zenPage.getComponentById(this.id+".textObjectInfoPopup");
	this._textInfoWidget = zenPage.getComponentById(this.id+".textInfoWizard");

	this._pageNumberPopup = zenPage.getComponentById(this.id+".pgNumObjectInfoPopup");
	this._pageNumberWidget = zenPage.getComponentById(this.id+".pageNumberWizard");

	this._barcodePopup = zenPage.getComponentById(this.id+".barcodeInfoPopup");
	this._barcodeWidget = zenPage.getComponentById(this.id+".barcodeWizard");

	this._imageURLPopup = zenPage.getComponentById(this.id+".imageURLInfoPopup");
	this._imageURLWidget = zenPage.getComponentById(this.id+".imageURLWizard");

	this._editPopup = zenPage.getComponentById(this.id+".editPalettePopup");
	this._editWidget = zenPage.getComponentById(this.id+".editPalette");

	this._layerPopup = zenPage.getComponentById(this.id+".layerPalettePopup");
	this._layerWidget = zenPage.getComponentById(this.id+".layerPalette");

	this._arrangePopup = zenPage.getComponentById(this.id+".arrangePalettePopup");
	this._arrangeWidget = zenPage.getComponentById(this.id+".arrangePalette");

	this._alignPopup = zenPage.getComponentById(this.id+".alignPalettePopup");
	this._alignWidget = zenPage.getComponentById(this.id+".alignPalette");

	this._toolsPopup = zenPage.getComponentById(this.id+".toolsPalettePopup");
	this._toolsWidget = zenPage.getComponentById(this.id+".toolsPalette");
	
	this._colorsPopup = zenPage.getComponentById(this.id+".colorsPalettePopup");
	this._colorsWidget = zenPage.getComponentById(this.id+".colorsPalette");
	this._wdsPanel = zenPage.getComponentById(this.id+".workingDataSetPanel");
	this._editorPanel = zenPage.getComponentById(this.id+".layoutEditorPanel");
	this._propertyPanel = zenPage.getComponentById(this.id+".displayPropertyPanel");
	
	this._txtEditor = zenPage.getComponentById(this.id+".txtEditor");
	
	this._defaultGC = this._propertyPanel.makeGC();
	this.initializeApplicationClipboard();
	this.clearSelection();
	this.setMode("SELECT");
}

/*
VARIOUS GETTERS TO FIND THE PARTS OF THE EDITOR
*/
ClientMethod getWorkingDataSetPanel() [ Language = javascript ]
{
	if (!this._wdsPanel) {
		this._wdsPanel = zenPage.getComponentById(this.id+".workingDataSetPanel");
	}
	return(this._wdsPanel);
}

ClientMethod getChartWizardPopup() [ Language = javascript ]
{
	if (!this._chartWPopup) {
		this._chartWPopup = zenPage.getComponentById(this.id+".chartWizardPopup");
	}
	return(this._chartWPopup);
}

ClientMethod getChartWizard() [ Language = javascript ]
{
	if (!this._chartWizard) {
		this._chartWizard = zenPage.getComponentById(this.id+".chartInfoWizard");
	}
	return(this._chartWizard);
}

ClientMethod getDisplayPropertyPanel() [ Language = javascript ]
{
	if (!this._propertyPanel) {
		this._propertyPanel = zenPage.getComponentById(this.id+".displayPropertyPanel");
	}
	return(this._propertyPanel);
}

ClientMethod getTextInfoPopup() [ Language = javascript ]
{
	if (!this._textInfoPopup) {
		this._textInfoPopup = zenPage.getComponentById(this.id+".textObjectInfoPopup");
	}
	return(this._textInfoPopup);
}

ClientMethod getTextInfoWizard() [ Language = javascript ]
{
	if (!this._textInfoWizard) {
		this._textInfoWizard = zenPage.getComponentById(this.id+".textInfoWizard");
	}
	return(this._textInfoWizard);
}

ClientMethod getPageNumPopup() [ Language = javascript ]
{
	if (!this._pageNumberPopup) {
		this._pageNumberPopup = zenPage.getComponentById(this.id+".pgNumObjectInfoPopup");
	}
	return(this._pageNumberPopup);
}

ClientMethod getPageNumWizard() [ Language = javascript ]
{
	if (!this._pageNumberWizard) {
		this._pageNumberWizard = zenPage.getComponentById(this.id+".pageNumberWizard");
	}
	return(this._pageNumberWizard);
}

ClientMethod getBarcodePopup() [ Language = javascript ]
{
	if (!this._barcodePopup) {
		this._barcodePopup = zenPage.getComponentById(this.id+".barcodeInfoPopup");
	}
	return(this._barcodePopup);
}

ClientMethod getBarcodeWizard() [ Language = javascript ]
{
	if (!this._barcodeWizard) {
		this._barcodeWizard = zenPage.getComponentById(this.id+".barcodeWizard");
	}
	return(this._barcodeWizard);
}

ClientMethod getImageURLPopup() [ Language = javascript ]
{
	if (!this._imageURLPopup) {
		this._imageURLPopup = zenPage.getComponentById(this.id+".imageURLInfoPopup");
	}
	return(this._imageURLPopup);
}

ClientMethod getImageURLWizard() [ Language = javascript ]
{
	if (!this._imageURLWizard) {
		this._imageURLWizard = zenPage.getComponentById(this.id+".imageURLWizard");
	}
	return(this._imageURLWizard);
}

ClientMethod getEditPopup() [ Language = javascript ]
{
	if (!this._editPopup) {
		this._editPopup = zenPage.getComponentById(this.id+".editPalettePopup");
	}
	return(this._editPopup);
}

ClientMethod getEditWidget() [ Language = javascript ]
{
	if (!this._editWidget) {
		this._editWidget = zenPage.getComponentById(this.id+".editPalette");
	}
	return(this._editWidget);
}

ClientMethod getLayerPopup() [ Language = javascript ]
{
	if (!this._layerPopup) {
		this._layerPopup = zenPage.getComponentById(this.id+".layerPalettePopup");
	}
	return(this._layerPopup);
}

ClientMethod getLayerWidget() [ Language = javascript ]
{
	if (!this._layerWidget) {
		this._layerWidget = zenPage.getComponentById(this.id+".layerPalette");
	}
	return(this._layerWidget);
}

ClientMethod getArrangePopup() [ Language = javascript ]
{
	if (!this._arrangePopup) {
		this._arrangePopup = zenPage.getComponentById(this.id+".arrangePalettePopup");
	}
	return(this._arrangePopup);
}

ClientMethod getArrangeWidget() [ Language = javascript ]
{
	if (!this._arrangeWidget) {
		this._arrangeWidget = zenPage.getComponentById(this.id+".arrangePalette");
	}
	return(this._arrangeWidget);
}

ClientMethod getAlignPopup() [ Language = javascript ]
{
	if (!this._alignPopup) {
		this._alignPopup = zenPage.getComponentById(this.id+".alignPalettePopup");
	}
	return(this._alignPopup);
}

ClientMethod getAlignWidget() [ Language = javascript ]
{
	if (!this._alignWidget) {
		this._alignWidget = zenPage.getComponentById(this.id+".alignPalette");
	}
	return(this._alignWidget);
}

ClientMethod getToolsPopup() [ Language = javascript ]
{
	if (!this._toolsPopup) {
		this._toolsPopup = zenPage.getComponentById(this.id+".toolsPalettePopup");
	}
	return(this._toolsPopup);
}

ClientMethod getToolsWidget() [ Language = javascript ]
{
	if (!this._toolsWidget) {
		this._toolsWidget = zenPage.getComponentById(this.id+".toolsPalette");
	}
	return(this._toolsWidget);
}

ClientMethod getColorsPopup() [ Language = javascript ]
{
	if (!this._colorsPopup) {
		this._colorsPopup = zenPage.getComponentById(this.id+".colorsPalettePopup");
	}
	return(this._colorsPopup);
}

ClientMethod getColorsWidget() [ Language = javascript ]
{
	if (!this._colorsWidget) {
		this._colorsWidget = zenPage.getComponentById(this.id+".colorsPalette");
	}
	return(this._colorsWidget);
}

ClientMethod getTextEditorWidget() [ Language = javascript ]
{
	return(this._txtEditor);
}

ClientMethod findDiv(subId) [ Language = javascript ]
{
	return(document.getElementById(this.id+'.'+subId));
}

ClientMethod adjustSizes(maxW, maxH) [ Language = javascript ]
{
	// MAGIC NUMBERS - FIX LATER
	var wdsWidth = 225;
	var propertiesWidth = 190;
	
	var wds = this.findDiv('workingDataSetPanel');
	var editor = this.findDiv('layoutEditorPanel');
	var properties = this.findDiv('displayPropertyPanel');
	
	var height = (maxH-1)+"px";
	wds.style.height = height;
	wds.style.width = wdsWidth+"px";
	editor.style.height = height;
	editor.style.width = (maxW-wdsWidth-propertiesWidth)+"px";
	properties.style.height = height;
	properties.style.width = propertiesWidth;
	var wdsp = this.getWorkingDataSetPanel();
	wdsp.adjustHeight(maxH-1);
	this._propertyPanel.adjustHeight(maxH-1);
}

ClientMethod toolChangeCB() [ Language = javascript ]
{
	this.setMode(this._toolsWidget.getValue());
	if (this._toolsPopup.headerStyle=="anchor") this._toolsPopup.popAway();
}

ClientMethod editCB() [ Language = javascript ]
{
	var w = this._editWidget;
	var op = w.getValue();
	if (op == "DELETE" ) this.deleteSelection();
	else if (op == "DUPLICATE" ) this.duplicateSelection();
	else if (op == "PASTE" ) this.pasteSelection();
	else if (op == "COPY" ) this.copySelection();
	else if (op == "CUT" ) this.cutSelection();
	w.setValue("");
	if (this._editPopup.headerStyle=="anchor")this._editPopup.popAway();
}

ClientMethod layerCB() [ Language = javascript ]
{
	var op = this._layerWidget.getValue();
	if (op == "TOBACK") this.moveToBack();
	else if (op == "BACKWARD" ) this.moveBackward();
	else if (op == "FORWARD" ) this.moveForward();
	else if (op == "TOFRONT" ) this.moveToFront();
	this._layerWidget.setValue("");
}

ClientMethod arrangeCB() [ Language = javascript ]
{
	ZLM.cerr(this._arrangeWidget.getValue()+" REQUESTED");
}

ClientMethod alignCB() [ Language = javascript ]
{
	var op = this._alignWidget.getValue();
	if (op == "ATOP") this.alignTop();
	else if (op == "ALEFT") this.alignLeft();
	else if (op == "ARIGHT") this.alignRight();
	else if (op == "ABOTTOM") this.alignBottom();
	else if (op == "CHORIZONTAL") this.centerHorizontal();
	else if (op == "CVERTICAL") this.centerVertical();
	else if (op == "EHORIZONTAL") this.equispaceHorizontal();
	else if (op == "EVERTICAL") this.equispaceVertical();
	else if (op == "UHEIGHT") this.setUniformHeight();
	else if (op == "UWIDTH") this.setUniformWidth();	
	this._alignWidget.setValue("");
}

/*
CORE FUNCTIONS
*/
ClientMethod save() [ Language = javascript ]
{
//IS THIS THE REAL SAVE OP??
	var b = this._editorPanel;
	var data = b.exportZRS();
//	for (var i=0;i<data.length;i++) ZLM.cerr(data[i]);
}

ClientMethod getMode() [ Language = javascript ]
{
	return(this._editMode);
}

ClientMethod setMode(mode) [ Language = javascript ]
{
	var e = this.getTextEditorWidget();
	e.abort();
	this._editMode = mode;
	this._toolsWidget.setValue(mode);
	this._editorPanel.setMode(mode);
}

ClientMethod resetMode() [ Language = javascript ]
{
	this.setMode("SELECT");
}

/*
SELECTION RELATED FUNCTIONS
*/

// SELECTION BASED EDIT CALLBACKS

/// Delete selected items WITHOUT moving them to the clipboard
ClientMethod deleteSelection() [ Language = javascript ]
{
	if (this._selItems) {
		var s = this._selItems;
		for (var i=0;i<s.length;i++) {
			if (s[i].unselect) s[i].unselect();
			if (s[i].remove) s[i].remove();
		}
	}
	this._selItems = [];
	this._propertyPanel.setActiveGC(this._defaultGC);
	zenPage._documentEdited = true;
}

/// Clone all nodes within a slection and add them as siblings to the originals
/// Offest their locations slightly (preferably based on most recent move of a recent clone
/// and make the new nodes the current selection.  Do not disturb clipboard contents.
ClientMethod duplicateSelection() [ Language = javascript ]
{
	if (this._selItems) {
		zenPage._documentEdited = true;
//ZLM.cerr("Duplicate selection requested but not yet implemented");
		var s = [];
		for (var i=0;i<this._selItems.length;i++) s.push(this._selItems[i]);
		zenPage._editor.clearSelection();
		for (var i=0;i<s.length;i++) {
			if (s[i].cloneObj) {
				var c = s[i].cloneObj();
				var b = s[i].banner;
				var gc = c.gc;
// SHOULD ADDRESS CLONE_MOVE_SET OFFSET OPERATION
				gc.sizeTop+=10;
				gc.sizeLeft+=10;
//ZLM.cerr("PLACE CLONE AT: "+gc.sizeLeft+","+gc.sizeTop);
				c.setGC(gc);
				b.area.appendChild(c.base);
				b.addItemNode(c,true,s.length>1);
			}
		}
	}
}

/// Clone all nodes on the cuurent clipboard and add them to the page
/// Offest their locations slightly (preferably based on most recent mouse location
/// and make the new nodes the current selection.  Do not disturb clipboard contents.
ClientMethod pasteSelection() [ Language = javascript ]
{
//ZLM.cerr("Paste selection requested but not yet implemented");
	zenPage._documentEdited = true;
	var inPlace = false;
	if (!ZRU.lastBannerClicked) {
		inPlace=true;
	}
	var b=ZRU.lastBannerClicked;
	var a=this.getClipboardArray();
	var len = a.length;
	if (len<1) return;
	zenPage._editor.clearSelection();
	var dx = a[0].gc.sizeLeft-ZRU.lastClickX;
	var dy = a[0].gc.sizeTop-ZRU.lastClickY;
	for (var i=0;i<len;i++) {
			if (a[i].cloneObj) {
				if (inPlace) {
					b = a[i].banner;
					dx=0;
					dy=0;
				}
				var c = a[i].cloneObj();
				b.area.appendChild(c.base);
				var gc = c.gc;
				gc.sizeTop-=dy;
				gc.sizeLeft-=dx;
//ZLM.cerr("PLACE CLONE AT: "+gc.sizeLeft+","+gc.sizeTop);
				c.setGC(gc);
				b.addItemNode(c,true,len>1);
			}
	}
}

/// copy the set of selected items to the application clipboard
/// by destructive overwrite of the current clipboard's contents
/// Leave the original selection unchanged.
ClientMethod copySelection() [ Language = javascript ]
{
	if (this._selItems) {
		var s = this._selItems;
		this.initializeApplicationClipboard();
		for (var i=0;i<s.length;i++) {
			this.addToClipboard(s[i]);
		}
	}
}

/// Copy the set of selected items to the application clipboard
/// by destructive overwrite of the current clipboard's contents
/// and delete the original selection from the page
ClientMethod cutSelection() [ Language = javascript ]
{
	if (this._selItems) {
		zenPage._documentEdited = true;
		ZRU.lastBannerClicked=null;
		ZRU.lastClickX = 0;
		ZRU.lastClickY = 0;
		this.copySelection();
		this.deleteSelection();
	}
}

// SELECTION CONTENTS MANAGEMENT

ClientMethod clearSelection() [ Language = javascript ]
{
	if (this._selItems) {
		var s = this._selItems;
		for (var i=0;i<s.length;i++) {
			if (s[i].unselect) s[i].unselect();
		}
	}
	this._selItems = [];
this._propertyPanel.setDefaultGC(this._defaultGC);
	this._propertyPanel.setActiveGC(this._defaultGC);
	zenPage._documentEdited = true;
}

ClientMethod setSelection(who) [ Language = javascript ]
{
	this.clearSelection();
	this.addToSelection(who);
}

ClientMethod addToSelection(who) [ Language = javascript ]
{
	for (var i=0;i<this._selItems.length;i++) {
		if (this._selItems[i]==who) return; // already in selection
	}
	this._selItems.push(who);
	if (who.select) who.select();	
	this.resolveMultiStyles();
	zenPage._documentEdited = true;
}

ClientMethod resolveMultiStyles() [ Language = javascript ]
{
	var mergeGC = this._propertyPanel.mergeStyleProperties(this._selItems);
	this._propertyPanel.setActiveGC(mergeGC);
}

ClientMethod removeFromSelection(who) [ Language = javascript ]
{
	var newAnchor = false;
	var shift=false;
	var items = this._selItems;
	var len = items.length-1;
	if (len==0) {
		this.clearSelection();
		this._propertyPanel.setActiveGC(this._defaultGC);
		zenPage._documentEdited = true;
		return;
	}
	for (var i=0;i<len;i++) {
		if (items[i]==who) {
			shift=true;
			if (i==0) newAnchor=true;
		}
		if (shift) this._selItems[i]=this._selItems[i+1];
	}
	if (shift || this._selItems[i]==who) {
		this._selItems.pop();
		if (who.unselect) who.unselect();
		if (newAnchor && items[0].select) items[0].select();
	}
	this.resolveMultiStyles();
	zenPage._documentEdited = true;
}

ClientMethod hasSelection() [ Language = javascript ]
{
	return(this._selItems.length>0);
}

// CLIPBOARD MANAGEMENT

/// Initialize clipboard buffer
ClientMethod initializeApplicationClipboard() [ Language = javascript ]
{
	this._clipItems = [];
}

/// Append an item to the application clipboard
ClientMethod addToClipboard(item) [ Language = javascript ]
{
	this._clipItems.push(item);
	zenPage._documentEdited = true;
}

/// Recall all items from the clipboard
ClientMethod getClipboardArray() [ Language = javascript ]
{
	return(this._clipItems);
}

// SELECTION BASED ALIGNMENT CALLBACKS

/// Given a selection of elements, align the top edge of each element to the 
/// topmost edge of the anchor element of the selection.  This only applies to 
/// document sections where vertical alignment can be explicitly controlled.
ClientMethod alignTop() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return; // nothing to align
		var newTop = s[0].gc.sizeTop;
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0) {
					if (s[i].setPosition) s[i].setPosition(s[i].gc.sizeLeft,newTop);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, align the left edge of each element to the 
/// left-most edge of the anchor element of the selection.  This only applies to 
/// document sections where horizontal alignment can be explicitly controlled.
ClientMethod alignLeft() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, ParaEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return; // nothing to align
		var newLeft = s[0].gc.sizeLeft;
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0 || section.indexOf("ParaEdit")>0) {
					if (s[i].setPosition) s[i].setPosition(newLeft,s[i].gc.sizeTop);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, align the bottom edge of each element to the 
/// bottom-most edge of the anchor element of the selection.  This only applies to 
/// document sections where vertical alignment can be explicitly controlled.
ClientMethod alignBottom() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return; // nothing to align
		var newBottom = s[0].gc.sizeTop+s[0].gc.sizeHeight;;
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0) {
					var t = newBottom-s[i].gc.sizeHeight;
					if (s[i].setPosition) s[i].setPosition(s[i].gc.sizeLeft,t);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, align the right edge of each element to the 
/// right-most edge of the anchor element of the selection.  This only applies to 
/// document sections where horizontal alignment can be explicitly controlled.
ClientMethod alignRight() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, ParaEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return; // nothing to align
		var max = s[0].gc.sizeLeft+s[0].gc.sizeWidth;
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0 || section.indexOf("ParaEdit")>0) {
					var l = max-s[i].gc.sizeWidth;
					if (s[i].setPosition) s[i].setPosition(l,s[i].gc.sizeTop);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, align the horizontal midpoint of each element to
/// align with the midpoint of the anchor element of the selection.  If only one item
/// is selected, this will center it on its section. This only applies
/// to document sections where horizontal alignment can be explicitly controlled.
ClientMethod centerHorizontal() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, ParaEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<1) return;
		if (s.length<2) {
			var node = s[0];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0 || section.indexOf("ParaEdit")>0) {
					var mid = node.banner.pageWidth/2;
					node.setPosition(mid-(node.gc.sizeWidth/2),node.gc.sizeTop);
					node.box.bindToNode(node.base);
					this.resolveMultiStyles();
					return; 
				}
			}
		}
		var mid = s[0].gc.sizeLeft+(s[0].gc.sizeWidth/2);
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0 || section.indexOf("ParaEdit")>0) {
					var l = mid-(s[i].gc.sizeWidth/2);
					if (s[i].setPosition) s[i].setPosition(l,s[i].gc.sizeTop);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, align the vertical midpoint of each element to
/// align with the midpoint of the anchor element of the selection. This only applies
/// to document sections where vertical alignment can be explicitly controlled.
ClientMethod centerVertical() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return;
		var mid = s[0].gc.sizeTop+(s[0].gc.sizeHeight/2);
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0 ) {
					var t = mid-(s[i].gc.sizeHeight/2);
					if (s[i].setPosition) s[i].setPosition(s[i].gc.sizeLeft,t);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Segregate the members of the current selection list by section
ClientMethod partitionSelectionListBySection() [ Language = javascript ]
{
	var segList = [];
	var s = this._selItems;
	var len = s.length;
	if (len<1) return(null); // nobody to sort
	var node = s[0];
    var segObj = {banner:node.banner, nodes:[s[0]]};
    segList.push(segObj);
    for (var i=1;i<len;i++) {
	    node = s[i];
	    var j=segList.length-1;
	    while (j>=0) {
		    var sObj = segList[j];
		    if (sObj.banner==node.banner) {
			    sObj.nodes.push(node);
			   	j= -5;
		    }
		    else j--;
	    }
	    if (j== -1) { // no matching banner found, add one
		    var segObj = {banner:node.banner, nodes:[s[i]]};
		    segList.push(segObj);
	    }
    }
    return(segList);
}

/// Return a sorted version of the given array of objects using the mergeSort algorithm
/// and testing on the given snippet
ClientMethod sortJSNodeArray(a, test) [ Language = javascript ]
{
	var l = a.length;
	if (l<=1) return(a);
	var left = [];
	var right = [];
	var result = null;
	var middle = Math.ceil(l/2);
	for (var i=0;i<middle;i++) left[i]=a[i];
	while (i<l) {
		right[i-middle]=a[i];
		i++;
	}
	left = this.sortJSNodeArray(left,test);
	right = this.sortJSNodeArray(right,test);
	result = this.mergeJSNodeArray(left,right,test);
	return(result);
}

/// Merge given two sorted arrays of objects into one using the mergeSort algorithm
/// and testing on the given property (ascending)
ClientMethod mergeJSNodeArray(l, r, test) [ Language = javascript ]
{
	var out = [];
	var lIdx = 0;
	var rIdx = 0;
	var lLen = l.length;
	var rLen = r.length;
	while (lIdx<lLen || rIdx<rLen) {
		if (lIdx<lLen && rIdx<rLen) {
			var node1 = l[lIdx];
			var node2 = r[rIdx];
			if (eval(test)==true) out.push(l[lIdx++]);
			else out.push(r[rIdx++]);
		}
		else if (lIdx<lLen) {
			while (lIdx<lLen) out.push(l[lIdx++]);
		}
		else {
			while (rIdx<rLen) out.push(r[rIdx++]);
		}
	}
	return(out);
}

/// Within each banner, align the selected elements such that such that  
/// they are evenly spaced (equal amounts of whitespace between them) within the area
/// occupied by the selection. This only applies to document sections where absolute positioning can be explicitly controlled.
ClientMethod equispaceHorizontal() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return;
		
		var sections = this.partitionSelectionListBySection();
		for (var sec = sections.length-1;sec>=0;sec--) {
			var bannerType = sections[sec].banner.objClass;
			var worthDoing = sections[sec].nodes.length>1;
			if (worthDoing && (bannerType.indexOf("BodyEdit")>0 || bannerType.indexOf("BannerEdit")>0 )) {
				var nodes = this.sortJSNodeArray(sections[sec].nodes,"node1.gc.sizeLeft<=node2.gc.sizeLeft");
				var min = nodes[0].gc.sizeLeft;
				var max = nodes[0].gc.sizeWidth+min;
				var totalUsed = nodes[0].gc.sizeWidth;
				for (var k=1;k<nodes.length; k++) {
					var ngc = nodes[k].gc;
					var nodeMax = ngc.sizeLeft+ngc.sizeWidth;
					if (nodeMax>max) max = nodeMax;
					totalUsed += ngc.sizeWidth;
				}
				if (min+totalUsed>max) max = min+totalUsed;
				var spare = max-min-totalUsed;
				var pad = spare/(nodes.length-1);
				for (var k=1;k<nodes.length;k++) {
					var pgc = nodes[k-1].gc;
					var n = nodes[k];
					n.setPosition(pgc.sizeLeft+pgc.sizeWidth+pad,n.gc.sizeTop);
					if (n.box) n.box.bindToNode(n.base);
				}					
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Within each banner, align the selected elements such that such that  
/// they are evenly spaced (equal amounts of whitespace between them) within the area
/// occupied by the selection. This only applies to document sections where absolute positioning can be explicitly controlled.
ClientMethod equispaceVertical() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return;
		
		var sections = this.partitionSelectionListBySection();
		for (var sec = sections.length-1;sec>=0;sec--) {
			var bannerType = sections[sec].banner.objClass;
			var worthDoing = sections[sec].nodes.length>1;
			if (worthDoing && (bannerType.indexOf("BodyEdit")>0 || bannerType.indexOf("BannerEdit")>0 )) {
				var nodes = this.sortJSNodeArray(sections[sec].nodes,"node1.gc.sizeTop<=node2.gc.sizeTop");
				var min = nodes[0].gc.sizeTop;
				var max = nodes[0].gc.sizeHeight+min;
				var totalUsed = nodes[0].gc.sizeHeight;
				for (var k=1;k<nodes.length; k++) {
					var ngc = nodes[k].gc;
					var nodeMax = ngc.sizeTop+ngc.sizeHeight;
					if (nodeMax>max) max = nodeMax;
					totalUsed += ngc.sizeWidth;
				}
				if (min+totalUsed>max) max = min+totalUsed;
				var spare = max-min-totalUsed;
				var pad = spare/(nodes.length-1);
				for (var k=1;k<nodes.length;k++) {
					var pgc = nodes[k-1].gc;
					var n = nodes[k];
					n.setPosition(n.gc.sizeLeft,pgc.sizeTop+pgc.sizeHeight+pad);
					if (n.box) n.box.bindToNode(n.base);
				}					
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, set the vertical extent of each element to
/// match the height of the anchor element of the selection. This only applies
/// to document sections where vertical alignment can be explicitly controlled.
ClientMethod setUniformHeight() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return;
		var hgt = s[0].gc.sizeHeight;
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("BannerEdit")>0 ) {
					if (s[i].setSizePt) s[i].setSizePt(parseInt(s[i].gc.sizeWidth,10),hgt);
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

/// Given a selection of elements, set the horizontal extent of each element to
/// match the width of the anchor element of the selection. This only applies
/// to document sections where horizontal alignment can be explicitly controlled.
ClientMethod setUniformWidth() [ Language = javascript ]
{
	// Applies to section types: BodyEdit, ConditionalBannerEdit, paraEdit, and BannerEdit
	if (this._selItems) {
		var s = this._selItems;
		if (s.length<2) return;
		var wd = s[0].gc.sizeWidth;
				
		for (var i=1;i<s.length;i++) {
			var node = s[i];
			if (node && node.banner) {
				var section = node.banner.objClass;
				if (section.indexOf("BodyEdit")>0 || section.indexOf("ParaEdit") || section.indexOf("BannerEdit")>0 ) {
					if (s[i].setSizePt) s[i].setSizePt(wd,parseInt(s[i].gc.sizeHeight,10));
					if (s[i].box) s[i].box.bindToNode(s[i].base);
				}
			}
		}
		this.resolveMultiStyles();
		zenPage._documentEdited = true;
	}
}

// SELECTION LAYERING CALLBACKS

/// Return an array of javascript objects where each object consists of a pointer to a 
/// given banner and an array holding the subset of the current selected items list that
/// occur in that banner.
ClientMethod getSelectedItemsByBanner() [ Language = javascript ]
{
	var a=[];
	var s = this._selItems;
	if (s) {
		var aLen = 0;
		var sLen = s.length;
		for (var i=0;i<sLen;i++) {
			var obj = s[i];
			var b = obj.banner;
			var filed = false;
			for (var j=0;j<aLen && !filed;j++) {
				if (a[j].banner==b) {
					a[j].item.push(obj);
					filed = true;
				}
			}
			if (!filed) {
				var newObj = {};
				newObj.banner = b;
				newObj.item=[];
				newObj.item[0]=obj;
				a.push(newObj);
				aLen++;
			}
		}
	}
	return(a)
}

/// Within each banner, move all selected elements to the background (drawn first) 
/// such that later elements may obscure them.  This will result in all members of the 
/// selection group being clustered together in the painting stack but will preserve the 
/// relative layering order of elements within the selection.
ClientMethod moveToBack() [ Language = javascript ]
{
	if (this._selItems) {
		var a = this.getSelectedItemsByBanner();
		for (var i=0;i<a.length;i++) {
			var b = a[i].banner;
			if (b.moveToBack) b.moveToBack(a[i].item)
		}
		zenPage._documentEdited = true;
	}
}

/// Within each banner, move all selected elements backward (drawn earlier)
/// with respect to the earliest drawn element in the selection group 
/// such that later elements may obscure them.  This will result in all members of the 
/// selection group being clustered together in the painting stack but will preserve the 
/// relative layering order of elements within the selection. 
ClientMethod moveBackward() [ Language = javascript ]
{
	if (this._selItems) {
		var a = this.getSelectedItemsByBanner();
		for (var i=0;i<a.length;i++) {
			var b = a[i].banner;
			if (b.moveBackward) b.moveBackward(a[i].item)
		}
		zenPage._documentEdited = true;
	}
}

/// Within each banner, move all selected elements forward (drawn later)
/// with respect to the latest drawn element in the selection group 
/// such that they may obscure elements drawn earlier.  This will result in all members of the 
/// selection group being clustered together in the painting stack but will preserve the 
/// relative layering order of elements within the selection. 
ClientMethod moveForward() [ Language = javascript ]
{
	if (this._selItems) {
		var a = this.getSelectedItemsByBanner();
		for (var i=0;i<a.length;i++) {
			var b = a[i].banner;
			if (b.moveForward) b.moveForward(a[i].item)
		}
		zenPage._documentEdited = true;
	}
}

/// Within each banner, move all selected elements to the foreground (drawn later)
/// such that they may obscure elements drawn earlier.  This will result in all members of the 
/// selection group being clustered together in the painting stack but will preserve the 
/// relative layering order of elements within the selection. 
ClientMethod moveToFront() [ Language = javascript ]
{
	if (this._selItems) {
		var a = this.getSelectedItemsByBanner();
		for (var i=0;i<a.length;i++) {
			var b = a[i].banner;
			if (b.moveToFront) b.moveToFront(a[i].item)
		}
		zenPage._documentEdited = true;
	}
}

// ============================================================

ClientMethod updateGC(newGC) [ Language = javascript ]
{
	if (this.hasSelection()) {
		zenPage._documentEdited = true;
		var s = this._selItems;
		for (var i=0;i<s.length;i++) {
			if (s[i].updateGC) s[i].updateGC(newGC);
			else if (s[i].setGC) s[i].setGC(newGC,multiSet);
		}
	}
	else {  // if no one is selected assume the edit is to change the default
		this._defaultGC = this._propertyPanel.cloneGC(this._propertyPanel.styleObj);
	}
}

ClientMethod disable() [ Language = javascript ]
{
	this.getEnclosingDiv().style.display="none";
}

ClientMethod enable() [ Language = javascript ]
{
	this.getEnclosingDiv().style.display="block";
}

}
