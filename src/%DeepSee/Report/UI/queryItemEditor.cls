/// Item Editor
/// This is the master display panel for the query item editor that allows 
/// the user to inject additional items into the generated DeepSee report 
/// data collector classes at run time
Class %DeepSee.Report.UI.queryItemEditor Extends %ZEN.Component.composite [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Parameter DEFAULTDELETEICON As STRING = "deepsee/close_a_16.png";

/// URI of image to display for the delete button.
Property iconDelete As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTDELETEICON} ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.itemPanel {
	position:relative;
	top:0px;
	left:0px;
	background: #e8e7e2;
	width: 100%;
	border-bottom: 1px solid gray;
	overflow:hidden;
}

.zruItemTableHeader {	
	position:relative;
	left:0px; 
	top:0px;
	height:19px;
	width:100%;
	font:16px Arial;
	color:white;
	background:#356B8D;
}

.zruItemTableEntry {
	position:relative;
	left:0px; 
	top:0px;
	height:19px;
	width:100%;
	font:16px Arial;
	color:#404040;
	background:#fefeff;
	border-bottom: 1px solid gray;
}

.zruItemTableEntry input {
	border:none;
	background:none;
	color:#404040;
	font:16px monospace;
}

.zruItemTableDivider {
	position:absolute;
	top:0px;
	right:0px;
	border-left:1px solid gray;
	width:0px;
	height:100%;
}

.zruItemTableNameCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruItemTablePDepCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruItemTableFDepCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruItemTableExpressionCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruItemTableDeleteButton {
	position:absolute;
	top:1px;
	right:0px;
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="itemPanel" >
	<html id="ItemHeader"  OnDrawContent="DrawItemHeader"></html>
<group id="body" layout="none" >
<group id="header" enclosingClass="zruItemTableHeader" layout="none">
<html enclosingStyle="width:100%; overflow:auto;">
<div class="zruItemTableNameCol">Item Name</div>
<div class="zruItemTablePDepCol">Parameter Dependencies</div>
<div class="zruItemTableFDepCol">Field Dependencies</div>
<div class="zruItemTableExpressionCol">Expression</div>
</html>
</group>
</group>
</composite>
}

/// Draw the contents of the Item Header (the region above the table of known properties).
Method DrawItemHeader(pSeed As %String) As %Status
{
	Set msgChange = ("Add")
	Set hlpChange = ("Add a new data item to this working data set")
	
	&html<<div class="zruHeaderDiv">#("Derived Data Items")#
	&nbsp;<a class="zruHeaderLink" href="#" title="#(hlpChange)#" onclick="zenPage.getComponent(#(..index)#).addNewItem();return false;">#(msgChange)#</a>
	</div>>
	Quit $$$OK
}

ClientMethod insertCSSRule(className, styleStr) [ Language = javascript ]
{
	var ss = document.styleSheets[document.styleSheets.length-1];
	var r = ss.cssRules?ss.cssRules:ss.rules;
	var l = r.length;
	if (ss.insertRule) { //std
		ss.insertRule('.'+className+' { '+styleStr+'}',l);
	}
	else if (ss.addRule) { //ie
		ss.addRule('.'+className,styleStr,l);
	}
}

ClientMethod deleteDynamicCSSRule(className, triggerStr) [ Language = javascript ]
{
	var ss = document.styleSheets[document.styleSheets.length-1];
	var r = ss.cssRules?ss.cssRules:ss.rules;
	var l = r.length;
	for (var n = l-1; n>=0; n--) {
		var node = r[n];
		if (node.selectorText.indexOf(className)>=0) {
			if (node.cssText) {
				if (node.cssText.indexOf(triggerStr)>=0) {
					if (ss.deleteRule) ss.deleteRule(n);
					else if (ss.removeRule) ss.removeRule(n);
					return;
				}
			}
			else {
				if (ss.removeRule) ss.removeRule(n);
				return;
			}
		}
	}
}

ClientMethod sizeColumns() [ Language = javascript ]
{
	var sz = [250,200,200,500];
	var cl = ["zruItemTableNameCol","zruItemTablePDepCol",
				"zruItemTableFDepCol","zruItemTableExpressionCol"];
	var m = 0;
	for (var i=0;i<6;i++) {
		this.deleteDynamicCSSRule(cl[i],"left");
		this.insertCSSRule(cl[i],"left:"+m+"px; width:"+sz[i]+"px; height:100%;");
		m+=sz[i];
	}
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.pIdx = 1;
	this.sizeColumns();
	this.model = [];
	return;
}

/// Reset the table
ClientMethod clear() [ Language = javascript ]
{
	var group = this.getChildById("body").getEnclosingDiv();
	var j = null;
	for (var i=group.firstChild;i!=null;i=j) {
		j = i.nextSibling;
		if (i.subIndex) {
			group.removeChild(i);
		}
	}
}

/// Add a new property edit line to the table
ClientMethod addNewItem() [ Language = javascript ]
{
	var idx = this.pIdx++;
	var id = 'zen'+this.index+'_'+idx+'_';
	var group = this.getChildById("body");
	var objHook = "zenPage.getComponent("+this.index+").";
	var line = ZLM.makeElement("div");
	var cb = "onchange='"+objHook+"syncModel();' ";
	line.className = "zruItemTableEntry";
	var initName = this.makeUniqueName(null);
	var h=[];
	h.push("<div class='zruItemTableNameCol'>");
	h.push("<input id='"+id+"name' style='width:100%;height:100%;' "+cb+"type='text' value='"+initName+"'></input>");
	h.push("<div class='zruItemTableDivider'></div></div>");
	
	h.push("<div class='zruItemTablePDepCol'>");
	h.push("<select id='"+id+"pdep0' style='width:100%;position:absolute;top:2px;' "+cb+"'>");
	if (this.context) {
		var pList = this.context.prms;
		h.push("<option value='(none)'>(none)</option>");
		var l = pList.length;
		for (var i=0;i<l;i++) {
			h.push("<option value='"+pList[i]+"'>"+pList[i]+"</option>");
		}
	}
	else h.push("<option value='(none)'>(none)</option>");
	h.push("</select>");
	h.push("<div class='zruItemTableDivider'></div></div>");
	
	h.push("<div class='zruItemTableFDepCol'>");
	h.push("<select id='"+id+"fdep0' style='width:100%;position:absolute;top:2px;' "+cb+"'>");
	if (this.context) {
		var fList = this.context.flds;
		h.push("<option value='(none)'>(none)</option>");
		var l = fList.length;
		for (var i=0;i<l;i++) {
			h.push("<option value='"+fList[i]+"'>"+fList[i]+"</option>");
		}
	}
	else h.push("<option value='(none)'>(none)</option>");
	h.push("</select>");
	h.push("<div class='zruItemTableDivider'></div></div>");

	h.push("<div class='zruItemTableExpressionCol'>");
	h.push("<input id='"+id+"expression' style='width:100%;height:100%;' "+cb+"type='text'></input>");
	h.push("<div class='zruItemTableDivider'></div></div>");

	h.push("<img id='"+id+"delete' class='zruItemTableDeleteButton' src='"+this.iconDelete+"' onclick='zenPage.getComponent("+this.index+").deleteLine("+idx+");' >");
	line.innerHTML=h.join("");
	line.subIndex = idx;	 	

	group.getEnclosingDiv().appendChild(line);
	this.syncModel();
	return(line);
}

/// Given a base root for a name, return a unique property name based on that
/// root and made unique by the addition of a numeric suffix if required.
ClientMethod makeUniqueName(root) [ Language = javascript ]
{
	if (!root) root = "RptItem";
	if (this.isUniqueName(root,-1)) return(root);
	var i=1;
	while (i<1000) {
		var name = root+i;
		if (this.isUniqueName(name,-1)) return(name);
		i++;
	}
	return("TooManyProperties");
}

/// Check the given name against all known names in the model with the exception
/// of exemptIdx.  Return true is the name is unique, false otherwise.  Note that 
/// this check is not case sensitive  
ClientMethod isUniqueName(name, exemptIdx) [ Language = javascript ]
{
	var uName = name.toUpperCase();
	var m = this.model;
	if (!m) return(true);
	var len = m.length;
	if (!len || len==0) return(true);
	for (var i=0;i<len;i++) {
		if (i!=exemptIdx) {
			var node = m[i]
			if (node && node.n && node.n.length) {
				if (node.n.toUpperCase() == uName) return(false);
			}
		}
	}
	return(true);
}

/// Delete a given line from the table and update the underlying model
ClientMethod deleteLine(idx) [ Language = javascript ]
{
	var group = this.getChildById("body").getEnclosingDiv();
	for (var i=group.firstChild;i!=null;i=i.nextSibling) {
			if (i.subIndex==idx) {
				group.removeChild(i);
				this.syncModel();
			}
	}
}

ClientMethod generateSelectControls(vList, ctx, baseId) [ Language = javascript ]
{
	var src = [];	
	var objHook = "zenPage.getComponent("+this.index+").";
	var cb = "onchange='"+objHook+"syncModel();' ";
	var len = vList.length;
	if (!len) len = 0;
	for (var i=0;i<=len;i++) {
		var tCtrl = document.getElementById(baseId+i);
		var cLen = ctx.length;
		var val = vList[i];
		if (!val) val='(none)';
		src.push("<select id='"+baseId+i+"' style='width:100%;position:absolute;top:"+(22*i+2)+"px;' "+cb+" value='"+val+"'>");
		src.push("<option value='(none)'>(none)</option>");
		for (var j=0;j<cLen;j++) {
			var opt = ctx[j];
			var skip=false;
			for (var k=0;k<i;k++) if (opt==vList[k]) skip=true;
			if (!skip) src.push("<option value='"+opt+"'>"+opt+"</option>");
		}
		src.push("</select>");
	}	
	src.push("<div class='zruItemTableDivider'></div></div>");
	return(src);
}

/// Add a new edit line to the table and pre-poplate it from a model object
ClientMethod populateLine(pObj) [ Language = javascript ]
{
	var line = this.addNewItem();
	this.updateLine(line.subIndex,pObj);
}

ClientMethod updateLine(idx, pObj) [ Language = javascript ]
{
	var id = 'zen'+this.index+'_'+idx+'_';
	var nCtrl = document.getElementById(id+'name');
	if (!pObj.n || pObj.n.length<1) {
		pObj.n = this.makeUniqueName(null);
	}
	nCtrl.value = pObj.n;

	var tCtrl = document.getElementById(id+'pdep0');
	var pn = tCtrl.parentNode;
	var src = this.generateSelectControls(pObj.pd,this.context.prms,id+"pdep");
	pn.innerHTML = src.join("");
	
	var len = pObj.pd.length;
	for (var i=0;i<len;i++) {
		tCtrl = document.getElementById(id+'pdep'+i);
		tCtrl.value=pObj.pd[i];
	}
	tCtrl = document.getElementById(id+'pdep'+i);
	tCtrl.value = "(none)";	

	var tCtrl = document.getElementById(id+'fdep0');
	var pn = tCtrl.parentNode;
	var src = this.generateSelectControls(pObj.fd,this.context.flds,id+"fdep");
	pn.innerHTML = src.join("");
	
	var len = pObj.fd.length;
	for (var i=0;i<len;i++) {
		tCtrl = document.getElementById(id+'fdep'+i);
		tCtrl.value=pObj.fd[i];
	}
	tCtrl = document.getElementById(id+'fdep'+i);
	tCtrl.value = "(none)";	

	var lineH = Math.max(pObj.pd.length+1,pObj.fd.length+1);

	var iCtrl = document.getElementById(id+'expression');
	iCtrl.value = pObj.x;

	pn.parentNode.style.height=lineH*24+"px";
}

/// Synchronize the underlying model with the currently displayed values
ClientMethod syncModel() [ Language = javascript ]
{
	this.model = [];
	var group = this.getChildById("body").getEnclosingDiv();
	for (var i=group.firstChild;i!=null;i=i.nextSibling) {
		if (i.subIndex>=0) {
			var obj = this.syncLine(i.subIndex);
			if (obj) this.model.push(obj);
		}
	}
}

ClientMethod syncSelectControl(baseId, lst) [ Language = javascript ]
{
	// If the select control is set to none, no subsequent controls
	// in the same column should be visible
	// If a given select control is not set to none, there should be at
	// least one more control in the column tht IS set to none and has
	// fewer options than the current one.
	var a = [];
	var aLen = 0;
	var val = "";
	var tCtrl = document.getElementById(baseId+'0');
	var pn = tCtrl.parentNode;
	while (tCtrl && val!="(none)") {
		val = tCtrl.value;
		if (val!="(none)") a.push(val);
		aLen++;
		tCtrl = document.getElementById(baseId+aLen);
	}
	return(a);
}

/// Synchronize a given line of the table with a model property object
ClientMethod syncLine(idx) [ Language = javascript ]
{
	var o = {}
	var id = 'zen'+this.index+'_'+idx+'_';
	var nCtrl = document.getElementById(id+'name');
	o.n = this.makeUniqueName(nCtrl.value,idx);
//	o.n = nCtrl.value;

	if (!o.n || o.n.length<1) return(null);
	
	var a = this.syncSelectControl(id+'pdep',this.context.prms);
	if (a && a.length>0) o.pd = a;
	else o.pd = [];
				
	var a = this.syncSelectControl(id+'fdep',this.context.flds);

	if (a && a.length>0) o.fd = a;
	else o.fd = [];

	var dCtrl = document.getElementById(id+'expression');
	o.x = dCtrl.value;
// NOW CLEANUP THE SELECTION CONTROLS TO REFLECT THE CURRENT VALUE
// AND RESIZE LINE
	this.updateLine(idx,o);
	return(o);
}

/// Get the current model
ClientMethod getModel() [ Language = javascript ]
{
	this.syncModel();
	return(this.model);
}

/// Populate the table with data from the given model
ClientMethod restoreModel(m, context) [ Language = javascript ]
{
	// the model is an array of javascript objects (one item per object)
	// the objects themselves have the following fields:
	//  n  : name
	//  pd : property dependency (may be a list or none)
	//  fd : field dependency (may be a list or none)
	//  x  : expression
	//Item objects:
	//{n:"ReportAuthor",d:"Author of Report",t:"%String",i:"BOB",z:"AUTHOR"}
	
	// the context is a js object with two arrays
	// prms : Array of defined parameter names
	// flds : Array of defined raw data fields
	this.context = context;
	this.model=m;
	this.clear();
	var len = m.length;
	for (var i=0;i<len;i++) {
		this.populateLine(m[i]);
	}
}

}
