/// %DeepSee.Report.UI.dataPickPool
Class %DeepSee.Report.UI.dataPickPool Extends %ZEN.Component.component [ LegacyInstanceContext, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// URI of image to display for the close group button.
Property title As %ZEN.Datatype.caption [ InitialExpression = "Working Data Set" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.dataPickPool {
	position:relative;
	top:0px;
	left:0px;
	width:100%;
	height:100%;	
	overflow:auto;
}

.dataPickPoolBody {
	position:relative;
	top:0px;
	left:0px;
	width:100%;
	height:100%;
}

.dataPickPoolTitle {
	position:absolute;
	left:0px; top:0px;
	height:0px;
	width:100%;
	line-height:0px;
	background:#356b8d;
	font:bold 12px Arial;
	color:#ffffff;
	text-align:center;
}

.dataPickPoolArea {
	position:absolute;
	left:0px;
	top:0px;
	color:#000077;
	background:#e8e7e2;
	width:100%;
	height:100%;
}

.dataPickPoolAreaPad {
	position:relative;
	top:0px;
	left:0px;
	width:100%;
	height:20px;
}

.dataPickPoolGroupHeader {
	background:#356b8d;
	color:#ffffff;
	font:12px Arial;
}

.dataPickPoolItem {
	position:absolute;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 100%;
	cursor: pointer;
}

.dataPickPoolDatum {
	position:relative;
	left:0px;
	top:0px;
	width:100%;
	height:18px;
	color:#000077;
	font:12px Arial;
}


</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
	<div id="#(..%MakeId("base"))#" class="dataPickPool">
		<div id="#(..%MakeId("body"))#" class="dataPickPoolBody" >
			<div id="#(..%MakeId("title"))#" class="dataPickPoolTitle">Working Data Set</div>
			<div id="#(..%MakeId("area"))#" class="dataPickPoolArea">
				<div id="#(..%MakeId("pad"))#" class="dataPickPoolAreaPad"></div>
			</div>
		</div>
	</div>>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var d=this.getEnclosingDiv();
	
	//ZRU.srcDir="/csp/broker";
	d.controller = this;
}

ClientMethod setDataPoolFromXMLString(xmlStr, title) [ Language = javascript ]
{
	/*
	*/
}

ClientMethod setTitle(str) [ Language = javascript ]
{
	var t = this.findElement('title');
	t.innerHTML=str;
	this.title = str;
}

ClientMethod clear() [ Language = javascript ]
{
	var n = this.findElement('area');
	var a = this.findElement('areaPad');
	var p=n.firstChild;
	while(p!=null) {
		var q=p.nextSibling;
		if (p!=a) n.removeChild(p);
		p=q;
	}
}

ClientMethod addDatum(rDef, depth) [ Language = javascript ]
{
	var area = this.findElement('area');
	if (rDef.nodeName=="parameter") return;
	if (rDef.nodeName!="report") {
		var n=ZLM.makeElement("div");
		n.className="dataPickPoolDatum";
		n.wrap=ZLM.makeElement("div");
		n.appendChild(n.wrap);
		n.wrap.style.marginLeft=depth*10+"px";
		area.appendChild(n);
		n.rawTxt=rDef.getAttribute("name");
		if (rDef.parentNode && rDef.parentNode.nodeName=="group") {
			n.parentGroup = rDef.parentNode.getAttribute("name");
		}
		n.depth=depth;
		n.txt=document.createTextNode(n.rawTxt);
		n.wrap.appendChild(n.txt);
		if (rDef.nodeName=="group") {
			n.className = "dataPickPoolGroupHeader"
		}
		else {
			if (rDef.nodeName=="attribute") n.rawTxt="@"+n.rawTxt;
		
			n.plate=ZLM.makeElement("div");
			n.plate.className = "dataPickPoolItem";
			ZLM.setLocalAttribute(n.plate,"onDataDrag","zenIndex("+this.index+").startDrag();");

			if (navigator.userAgent.indexOf("Trident")>0) {
				n.plate.style.background="#ffffff";
				n.plate.style.opacity="0";
			}
			n.plate.controller=this;
			n.plate.node=n;
			n.appendChild(n.plate);
		}
	}
	for (var p=rDef.firstChild;p!=null;p=p.nextSibling) this.addDatum(p,depth+1);
}

/// Set the data tree from an XML source
ClientMethod setDataTree(rDef, noDrag) [ Language = javascript ]
{
	this.clear();
	for (var p=rDef.firstChild;p!=null;p=p.nextSibling) this.addDatum(p,1);	
	if (!noDrag) ZLM.initDataDragDrop();
}

ClientMethod addDSSDatum(o, parentName, depth) [ Language = javascript ]
{
	var area = this.findElement('area');
	if (o.nodeType!="root") {
		var n=ZLM.makeElement("div");
		n.className="dataPickPoolDatum";
		n.wrap=ZLM.makeElement("div");
		n.appendChild(n.wrap);
		n.wrap.style.marginLeft=depth*10+"px";
		area.appendChild(n);
		n.rawTxt=o.nodeName;
		
		if (parentName) {
			n.parentGroup = parentName;
		}
		n.depth=depth;
		n.txt=document.createTextNode(n.rawTxt);
		n.wrap.appendChild(n.txt);
		
		if (o.nodeType=="group") {
			n.className = "dataPickPoolGroupHeader"
		}
		else {
			if (o.nodeType=="attribute") n.rawTxt="@"+n.rawTxt;
		
			n.plate=ZLM.makeElement("div");
			n.plate.className = "dataPickPoolItem";
			ZLM.setLocalAttribute(n.plate,"onDataDrag","zenIndex("+this.index+").startDrag();");

			if (navigator.userAgent.indexOf("Trident")>0) {
				n.plate.style.background="#ffffff";
				n.plate.style.opacity="0";
			}
			
			n.plate.controller=this;
			n.plate.node=n;
			n.appendChild(n.plate);
		}
	}
	if (o.attr) {
		var len = o.attr.length;
		for (var p=0;p<len;p++) {
			this.addDSSDatum(o.attr[p],parentName+'/'+o.nodeName,depth+1);
		}
	}
	if (o.item) {			
		var len = o.item.length;
		for (var p=0;p<len;p++) {
			this.addDSSDatum(o.item[p],parentName+'/'+o.nodeName,depth+1);
		}
	}
}

/// Set the displayed data tree from a DSS object
ClientMethod setDataTreeFromDSS(obj, noDrag) [ Language = javascript ]
{
	this.clear();
	this.addDSSDatum(obj,"",0);
	if (!noDrag) ZLM.initDataDragDrop();
}

ClientMethod startDrag() [ Language = javascript ]
{
	var dSrc=ZLM.getDragSource();
	ZLM.setDragCaption(dSrc.node.rawTxt);
	if (zenPage.scopeDataDrag) zenPage.scopeDataDrag(dSrc.node.parentGroup);
	var o = {};
	o.name = dSrc.node.rawTxt;
	o.group = dSrc.node.parentGroup;
	ZLM.DragManager.endNotify = "zenIndex("+this.index+").endDrag();";
	return(o);
}

ClientMethod endDrag() [ Language = javascript ]
{
	ZLM.DragManager.endNotify = null;
	if (zenPage.resetCoverplates) zenPage.resetCoverplates();
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'title':
		this.setTitle(value);
		break;

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

}
