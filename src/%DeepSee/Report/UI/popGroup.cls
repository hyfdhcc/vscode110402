/// A pop group displays a header (which can include various buttons).
/// The user can drag the group around within its containing desktop group.
Class %DeepSee.Report.UI.popGroup Extends %ZEN.Component.group [ System = 3 ]
{

/// Subclasses can set this to change default layout for a group.
Parameter DEFAULTLAYOUT As STRING = "none";

/// Subclasses can set this to change default css class for a group.
Parameter DEFAULTENCLOSINGCLASS = "popGroup";

/// Default image for close group button.
Parameter DEFAULTCLOSEIMAGE = "portal/close_b_11.png";

/// Default header layout pattern
Parameter DEFAULTHEADERLAYOUT = "CT";

Property tearable As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// Header style is one of "full" "anchor" or "none"
Property headerStyle As %ZEN.Datatype.string [ InitialExpression = "anchor" ];

/// Title to display in header section for this group.
Property header As %ZEN.Datatype.caption [ InitialExpression = "Untitled Group" ];

/// URI of image to display for the close group button.
Property imageClose As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTCLOSEIMAGE} ];

/// Width (in pixels) of image to display for the close group button.
Property imageCloseWidth As %ZEN.Datatype.integer [ InitialExpression = 11 ];

/// If set, this boolean flag indicates that the title section of the header
/// should be centered over the dragGroup 
Property centerHeader As %Boolean [ InitialExpression = 1 ];

/// The header layout pattern determines the order in which control windows are added
/// to the header section of the dragGroup window frame.  This is encoded as a four
/// character string consisting of the following tokens <br>
/// 'T' represents the Title section with both application logo and header caption<br>
/// 'C' represents the Close button <br>
Property headerLayout As %ZEN.Datatype.string [ InitialExpression = {..#DEFAULTHEADERLAYOUT} ];

XData Style
{
<style type="text/css">
.popGroup {
	position: absolute;
	width:250px;
	display: none;
}

.popHeader {
	position:absolute;
	top:0px;
	left:0px;
	width:100%;
	height:15px;
}

.popAnchor {
	position:absolute;
	top:0px;
	left:0px;
	width:100%;
	height:15px;
}

.popAnchorNib {
	background-image:url(portal/popAnchor.png);
	position:absolute;
	left:15px;
	top:0px;
	width:31px;
	height:15px;
	cursor:move;
}


.popFullHeader {
	border-bottom: 1px solid #808080;
	background: #23242C;
	background-image: url(images/grayDragHeader.png);
	background-repeat: repeat-x;
	cursor: move;
	color: #000066;	
	white-space:nowrap;
	text-align:left;
	height:22px;
	position:relative;
}

.popHeaderText {
	font:11px sans-serif;
	text-align:center;
 	white-space: nowrap;
	position:absolute;
	top:0px;
	left:15px;
	margin-left:auto;
	margin-right:auto;
}

.popCloseDiv {
	cursor:pointer;
	height:11px;
	width:11px;
	background-image:url(portal/close_b_11.png);
	background-position: center center;
	background-repeat:no-repeat;
	position:absolute;
	top:2px;
	left:2px;
}

.popChildren {
	position:absolute;
	top:15px;
	left:0px;
	width:100%;
	height:100%;
    margin: 0px;
}

.popKidFrame {
	position:relative;
	top:0px;
	left:0px;
	width:100%;
	height:100%;
	overflow:hidden;
    background:#356B8D; 
    padding:3px;
}

.popShadow {
	position:absolute;
	background-image: url(images/shadow.png);
	width:100%;
	height:100%;
	top:8px;
	left:8px;
}


</style>
}

Method %DrawHTML()
{
	#; header
	&html<<div class="popHeader" id="#(..%MakeId("header"))#">

	<div class="popShadow" id="#(..%MakeId("headerShadow"))#">
	</div>

	<div class="popAnchor" id="#(..%MakeId("anchor"))#">
		<div class="popAnchorNib" id="#(..%MakeId("anchorNib"))#" ></div>
	</div>	

	<div class="popFullHeader" id="#(..%MakeId("fullHeader"))#">
		<div class="popCloseDiv" id="#(..%MakeId("closeButton"))#" onclick="this.controller.closeCB();"></div>
		<div class="popHeaderText" if="#(..%MakeId("textDiv"))#">#(..header)#</div>
	</div>
	
	</div>>

	#; children
	&html<<div class="popChildren" id="#(..%MakeId("children"))#" style="position:absolute" >
	<div class="popShadow" id="#(..%MakeId("bodyShadow"))#">
	</div>
	<div class="popKidFrame" id="#(..%MakeId("childFrame"))#" >>
	Do ..%LayoutChildren(..tuple)
	&html<</div></div>>

	#; Modify renderFlag to be force client-side call to renderContents
	Set ..renderFlag = ..renderFlag + 1
}

/// Client-side method to ensure that the controller has an accurate model
/// to work with even if the DOM has been modified externally
ClientMethod onRefreshContents() [ Language = javascript ]
{
	this.initializeCS();
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.initializeCS();
}

ClientMethod initializeCS() [ Language = javascript ]
{
	if (!this._mouseTrap) {
		var m = ZLM.makeElement("div");
		var s = m.style;
		s.width="100%";
		s.height="100%";
		s.display="none";
		s.position="absolute";
		s.top="0px";
		s.left="0px";
		ZLM.setLocalAttribute(m,"onmousedown","this.controller.popAway();");
		m.controller = this;
		this._mouseTrap = m;
		document.body.appendChild(m);
	}
	this._popBase = this.getEnclosingDiv();
	this._popHeader = this.findElement("header");
	this._popHeader.controller = this;
	this._popAnchor = this.findElement("anchor");
	this._popAnchor.controller = this;
	this._popFullHeader = this.findElement("fullHeader");
	this._popFullHeader.controller = this;
	this._popCloseButton = this.findElement("closeButton");
	this._popCloseButton.controller = this;
	this._popChildren = this.findElement("children");
	this._popChildren.controller = this;
	this._popHeaderShadow = this.findElement("headerShadow");
	this._popHeaderShadow.controller = this;
	this._popBodyShadow = this.findElement("bodyShadow");
	this._popBodyShadow.controller = this;

	// Set up callbacks for dragging
	if (this.tearable) {
		ZLM.registerDragItem(this._popAnchor,this);
		ZLM.setLocalAttribute(this._popAnchor,"onmousedown","ZLM.drag(this,event);");
	}
	else {
		this._popAnchor.style.cursor="";
	}
	ZLM.registerDragItem(this._popFullHeader,this);
	ZLM.setLocalAttribute(this._popFullHeader,"onmousedown","ZLM.drag(this,event);");
	
	this.layoutHeader();
}

ClientMethod show(x, y, modal) [ Language = javascript ]
{
	var z = this.getMaxDepth()+1;
//ZLM.cerr("max depth:"+z);
	var s = this._popBase.style;
	s.zIndex = z+1;
	s.top = y+"px";
	s.left = x+"px";
	s.display = "block";
	this.layoutHeader();
	var s = this._popChildren.style;
	s.width = (this._popBase.offsetWidth-6)+"px";
	s.height = (this._popBase.offsetHeight-this._popHeader.offsetHeight-6)+"px";
	var s = this._popBodyShadow.style;
	s.width = this._popChildren.offsetWidth+6+"px";
	s.height = this._popChildren.offsetHeight+6+"px";
	if (modal) {
		this._mouseTrap.style.display = "";
		this._mouseTrap.style.zIndex = z;
	}
}

ClientMethod popAway() [ Language = javascript ]
{
	this._mouseTrap.style.display = "none";
	this._popBase.style.display = "none";
}

ClientMethod closeCB() [ Language = javascript ]
{
	this._popBase.style.display = "none";
}

ClientMethod getMaxDepth() [ Language = javascript ]
{
	if (document.body.currentStyle) return(this.getMaxDepthIE(document.body,0));
	return(this.getMaxDepthStd(document.body,0));
}

ClientMethod getMaxDepthStd(root, max) [ Language = javascript ]
{
	var s = window.getComputedStyle(root,null);
	if (s.display=="none") return(max);
	if (s.zIndex!="auto" && s.zIndex>max) max = s.zIndex;
	for (var p=root.firstChild;p!=null;p=p.nextSibling) {
		if (p.nodeType==1) {
			var kMax = this.getMaxDepthStd(p,max);
			if (kMax>max) max=kMax;
		}
	}
	return(max);
}

ClientMethod getMaxDepthIE(root, max) [ Language = javascript ]
{
	var s = root.currentStyle;
	if (s.display=="none") return(max);
	if (s.zIndex!="auto" && s.zIndex>max) max = s.zIndex;
	for (var p=root.firstChild;p!=null;p=p.nextSibling) {
		if (p.nodeType==1) {
			var kMax = this.getMaxDepthIE(p,max);
			if (kMax>max) max=kMax;
		}
	}
	return(max);
}

ClientMethod layoutHeader() [ Language = javascript ]
{

	// Set header style stuff
	if (this.headerStyle == "none" ) {
		this._popHeader.style.display="none";
		this._popHeaderShadow.style.display="none";
		this._popChildren.style.top = "0px";
	}
	else {
		this._popHeader.style.display = "";
		this._popChildren.style.top = this._popHeader.style.height;
		if (this.headerStyle == "anchor" ) {
			this._popFullHeader.style.display="none"
			this._popHeaderShadow.style.display="none";
			this._popAnchor.style.display="";
		}
		else {
			this._popFullHeader.style.display="";
			var pHSS = this._popHeaderShadow.style;
			pHSS.display="";
			this._popAnchor.style.display="none";
		}
	}
	
//	this.renderContents();
}

ClientMethod startDrag() [ Language = javascript ]
{
	this._dStartX = this._popBase.offsetLeft;
	this._dStartY = this._popBase.offsetTop;
}

ClientMethod constrainDragY(mgr, wrapper, newY) [ Language = javascript ]
{
	this._popBase.style.top = (this._dStartY+newY)+"px";
	return(0);
}

ClientMethod constrainDragX(mgr, wrapper, newX) [ Language = javascript ]
{
	this._popBase.style.left = (this._dStartX+newX)+"px";
	return(0);
}

ClientMethod endDrag() [ Language = javascript ]
{
	this.headerStyle = "full";
	this._mouseTrap.style.display = "none";
	this.layoutHeader();
}

/// Client-side method to render control.
ClientMethod renderContents() [ Language = javascript ]
{
return;
	var header = this.getHeaderDiv();
	if (header.textCell) return;
	this.renderCoverplate();
	this.renderResize();
	this.renderHeader();
	var thisDiv = this.getEnclosingDiv();
	thisDiv.compressed = 0;
	thisDiv.maximized = 0;
	if (!thisDiv.prefWidth) thisDiv.prefWidth = thisDiv.offsetWidth;
	if (!thisDiv.prefHeight) thisDiv.prefHeight = thisDiv.offsetHeight;
	if (!thisDiv.minWidth) thisDiv.minWidth = thisDiv.prefWidth;
	if (!thisDiv.minHeight) thisDiv.minHeight = thisDiv.iconHeight+thisDiv.resize.size+1;
	thisDiv.oldTop = 0;
	thisDiv.oldLeft = 0;
	thisDiv.oldWidth = 0;
	thisDiv.oldHeight = 0;
	thisDiv.oldPrefHeight = 0;
	this.adjustChildArea();
}

ClientMethod verifyHeaderGeometry() [ Language = javascript ]
{
	var ofsX=0;	
	if (this.headerLeft.hasChildNodes()==false) this.headerLeft.style.display='none';
	else {
		this.headerLeft.style.display='block';
		var k = this.headerLeft.childNodes;
		for (var i=0;i<k.length;i++) {
			if (k[i]==this.iconify) {
				k[i].style.left=ofsX+"px";
				this.expander.style.left=ofsX+"px";
				ofsX+=k[i].nativeWidth+2;
			}
			else if (k[i]==this.maxxer) {
				k[i].style.left=ofsX+"px";
				this.minner.style.left=ofsX+"px";
				ofsX+=k[i].nativeWidth+2;
			}
			else if (k[i]==this.closer) {
				k[i].style.left=ofsX+"px";
				ofsX+=k[i].nativeWidth+2;
			}
		}
		this.headerLeft.style.width=ofsX+"px";
	}

	if (this.centerLayout) {
		var cOfsX = (this.headerDiv.offsetWidth-this.titleDiv.offsetWidth)/2;
		if (cOfsX<ofsX)cOfsX=ofsX;
		this.headerMiddle.style.left=cOfsX+"px";
	}
	else this.headerMiddle.style.left=(ofsX+4)+"px";

	var k = this.headerRight.childNodes;
	var ofsX=0;
	for (var i=0;i<k.length;i++) {
		if (k[i]==this.iconify) {
			k[i].style.left=ofsX+"px";
			this.expander.style.left=ofsX+"px";
			ofsX+=k[i].nativeWidth+2;
		}
		else if (k[i]==this.maxxer) {
			k[i].style.left=ofsX+"px";
			this.minner.style.left=ofsX+"px";
			ofsX+=k[i].nativeWidth+2;
		}
		else if (k[i]==this.closer) {
			k[i].style.left=ofsX+"px";
			ofsX+=k[i].nativeWidth+2;
		}
	}
	this.headerRight.style.width=ofsX+"px";
}

ClientMethod setCloseIcon(iconURL, width) [ Language = javascript ]
{
	this.imageCloseWidth=this.setIcon(this.closer,iconURL,width);
	this.imageClose=iconURL;
}

ClientMethod setIcon(iconDiv, iconURL, width) [ Language = javascript ]
{
	if (!width) var w=16;
	else var w=parseInt(width,10);
	if (iconURL && iconURL.length>0) {
		iconDiv.style.backgroundImage = "url("+iconURL+")";
		iconDiv.style.width = w+"px";
		iconDiv.nativeWidth = w;
	}
	this.verifyHeaderGeometry();
	return(w);
}

ClientMethod setCenterLayout(flag) [ Language = javascript ]
{
	var m=this.headerMiddle.style;
	var v=this.headerMiddleVDiv.style;
	v.position = "absolute";
	v.left = (this.imageAppLogoWidth+4)+"px";
	this.centerLayout=flag;
	this.verifyHeaderGeometry();
}

/// Render the contents of the header section of this component.
ClientMethod renderHeader() [ Language = javascript ]
{
	var header = this.getHeaderDiv();
	var group = this.getEnclosingDiv();
	
	if (ZLM.isIE) {
		group.iFrame = ZLM.simulateTag("iframe src='' frameBorder='0' style='filter:alpha(opacity=0); z-index:0; position:absolute; top:0px; left:0px; width:100%; height:100%; border: 0px solid black; background:transparent;'");
		group.insertBefore(group.iFrame,group.firstChild);
		header.style.position='relative';
		header.style.zIndex="1";
	}

	if (header) {
		this.headerLeft = ZLM.simulateTag("div class='dragHeaderLeft'");
		this.headerMiddle = ZLM.simulateTag("div class='dragHeaderMiddle'");
		this.headerRight = ZLM.simulateTag("div class='dragHeaderRight'");
		
		header.appendChild(this.headerLeft);
		header.appendChild(this.headerMiddle);
		header.appendChild(this.headerRight);
		
		this.closer = ZLM.simulateTag("div class='dragCloseDiv' onclick='this.pane.zenObj.close(event);' onmousedown='ZLM.killEvent(event);'");
		
		this.headerMiddle.appendChild(this.appLogo);
		this.headerMiddleVDiv = ZLM.simulateTag("div style='position:relative; top:50%; height:100%;'");
		this.headerMiddle.appendChild(this.headerMiddleVDiv);
		
        this.titleDiv = ZLM.makeElement("div",null,this.header);
        this.titleDiv.className = "dragHeaderText";
		this.headerMiddleVDiv.appendChild(this.titleDiv);
		
		this.setCenterLayout(this.centerLayout);
		this.setContractIcon(this.imageContract,this.imageContractWidth);
		this.setExpandIcon(this.imageExpand,this.imageExpandWidth);
		this.setMaximizeIcon(this.imageMaximize,this.imageMaximizeWidth);
		this.setMinimizeIcon(this.imageMinimize,this.imageMinimizeWidth);
		this.setCloseIcon(this.imageClose,this.imageCloseWidth);
	
		this.setHeaderLayout(this.headerLayout);
		
		ZLM.setLocalAttribute(header,"onmousedown","ZLM.drag(this.parentNode,event);");
		
		header.maxxer = this.maxxer;
		header.minner = this.minner;
		header.closer = this.closer;
		header.iconifier = this.iconify;
		header.expander = this.expander;
		header.textCell=this.titleDiv;
        
		this.closer.pane = group;

		group.dragHandle=header;
		group.dragItem=this.getChildDiv();
		group.zenObj=this;
		this.adjustHandleWidth();
		this.adjustResizeBox();
		this.headerDiv=header;
	}
}

ClientMethod renderCoverplate() [ Language = javascript ]
{
		var g = this.getChildDiv();
		var plate=ZLM.simulateTag("div class='dragCoverplate'");
        ZLM.setLocalAttribute(plate,"onmousemove","ZLM.killEvent(event);");
		g.appendChild(plate);
		var div = this.getEnclosingDiv();
		div.coverplate=plate;
		this.coverplate=plate;
}

/// Resize the active group to the given geometry
ClientMethod resize(width, height) [ Language = javascript ]
{
	var thisDiv = this.getEnclosingDiv();
    thisDiv.style.width=width;
    thisDiv.style.height=height;
    this.adjustHandleWidth();
    this.adjustChildArea();
//   this.adjustResizeBox();
}

/// Utility to adjust the width of the drag header to correctly position
/// the header controls based on the current drag group width
ClientMethod adjustHandleWidth() [ Language = javascript ]
{
	if (this.centerLayout) this.verifyHeaderGeometry();
}

/// Utility to adjust the size of the dragChildren area in the
/// event of a resize action
ClientMethod adjustChildArea() [ Language = javascript ]
{
	var thisDiv = this.getEnclosingDiv();
	var headerDiv = this.getHeaderDiv();
	var childDiv = this.getChildDiv();
	childDiv.style.height=thisDiv.clientHeight-headerDiv.offsetHeight;
}

/// Callback to close the subwindow
ClientMethod close(event) [ Language = javascript ]
{
//	var thisDiv = this.getEnclosingDiv();
	this.setHidden(true);
//    thisDiv.layoutMgr.closePane(thisDiv);
    ZLM.killEvent(event);
}

/// Return the HTML div element that wraps the header of this group.
ClientMethod getHeaderDiv() [ Language = javascript ]
{
	return this.findElement('header');
}

/// Return the HTML div element that wraps the children of this group.
ClientMethod getChildDiv() [ Language = javascript ]
{
	return this.findElement('childFrame');
}

/// Return the internal width of the drag window in pixles
ClientMethod getWindowWidth() [ Language = javascript ]
{
	var div =this.getEnclosingDiv();
	return(div.clientWidth);
}

/// Return the internal height of the drag window in pixles
ClientMethod getWindowHeight() [ Language = javascript ]
{
	var e = this.getEnclosingDiv();
	var d = this.findElement('header');
	if (!d) return(0);
	return(e.clientHeight-d.offsetHeight);
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'header':
		this.header = value;
		break;
	case 'imageClose':
		this.setCloseIcon(value,value2);
		break;
	case 'centerLayout':
		this.setCenterLayout(value);
		break;
	case 'headerLayout':
		this.setHeaderLayout(value);
		break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
