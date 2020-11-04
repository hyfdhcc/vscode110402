/// Property Editor
/// This is the master display panel for the property editor that allows 
/// the user to inject parameterize the generated DeepSee report 
/// data collector classes at run time
Class %DeepSee.Report.UI.propertyEditor Extends %ZEN.Component.composite [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Parameter DEFAULTDELETEICON As STRING = "deepsee/close_a_16.png";

/// URI of image to display for the delete button.
Property iconDelete As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTDELETEICON} ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.propertyPanel {
	position:relative;
	top:0px;
	left:0px;
	background: #e8e7e2;
	width: 100%;
	border-bottom: 1px solid gray;
	overflow:hidden;
}

.zruPropertyTableHeader {	
	position:relative;
	left:0px; 
	top:0px;
	height:19px;
	width:100%;
	font:16px Arial;
	color:white;
	background:#356B8D;
}

.zruPropertyTableEntry {
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

.zruPropertyTableEntry input {
	border:none;
	background:none;
	color:#404040;
	font:16px monospace;
}

.zruPropertyTableDivider {
	position:absolute;
	top:0px;
	right:0px;
	border-left:1px solid gray;
	width:0px;
	height:100%;
}

.zruPropertyTableNameCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruPropertyTableTypeCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruPropertyTableURLCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruPropertyTableDefaultCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruPropertyTableConstraintCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruPropertyTableDescCol {
	position:absolute;
	top:0px;
	margin-left:5px;
}

.zruPropertyTableDeleteButton {
	position:absolute;
	top:1px;
	right:0px;
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="propertyPanel" >
	<html id="PropertyHeader"  OnDrawContent="DrawPropertyHeader"></html>
<group id="body" layout="none" >
<group id="header" enclosingClass="zruPropertyTableHeader" layout="none">
<html enclosingStyle="width:100%; overflow:auto;">
<div class="zruPropertyTableNameCol">Property</div>
<div class="zruPropertyTableTypeCol">Type</div>
<div class="zruPropertyTableURLCol">URL Token</div>
<div class="zruPropertyTableDefaultCol">Default</div>
<div class="zruPropertyTableConstraintCol">Constraint</div>
<div class="zruPropertyTableDescCol">Description</div>
</html>
</group>
</group>
</composite>
}

/// Draw the contents of the Property Header (the region above the table of known properties).
Method DrawPropertyHeader(pSeed As %String) As %Status
{
	Set msgChange = ("Add")
	Set hlpChange = ("Add a new run-time property to this data collector class")
	
	&html<<div class="zruHeaderDiv">#("Report Properties")#
	&nbsp;<a class="zruHeaderLink" href="#" title="#(hlpChange)#" onclick="zenPage.getComponent(#(..index)#).addNewProperty();return false;">#(msgChange)#</a>
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
		node = r[n];
		if (node.selectorText.indexOf(className)>=0) {
			if (node.cssText.indexOf(triggerStr)>=0) {
				if (ss.deleteRule) ss.deleteRule(n);
				else if (ss.removeRule) ss.removeRule(n);
				return;
			}
		}
	}
}

ClientMethod sizeColumns() [ Language = javascript ]
{
	var sz = [150,100,100,150,200,300];
	var cl = ["zruPropertyTableNameCol","zruPropertyTableTypeCol",
				"zruPropertyTableURLCol","zruPropertyTableDefaultCol",
				"zruPropertyTableConstraintCol","zruPropertyTableDescCol"];
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
ClientMethod addNewProperty() [ Language = javascript ]
{
	var idx = this.pIdx++;
	var id = 'zen'+this.index+'_'+idx+'_';
	var group = this.getChildById("body");
	var objHook = "zenPage.getComponent("+this.index+").";
	var line = ZLM.makeElement("div");
	var cb = "onchange='"+objHook+"syncModel();' ";
	line.className = "zruPropertyTableEntry";
	var initName = this.makeUniqueName(null);
	var initType = "%String";
	var initURL = initName.toUpperCase();
	var h=[];
	h.push("<div class='zruPropertyTableNameCol'>");
	h.push("<input id='"+id+"name' style='width:100%;' "+cb+"type='text' value='"+initName+"'></input>");
	h.push("<div class='zruPropertyTableDivider'></div></div>");
	
	h.push("<div class='zruPropertyTableTypeCol'>");
	h.push("<input id='"+id+"type' style='width:100%;' "+cb+"type='text' value='"+initType+"'></input>");
	h.push("<div class='zruPropertyTableDivider'></div></div>");
	
	h.push("<div class='zruPropertyTableURLCol'>");
	h.push("<input id='"+id+"url' style='width:100%;' "+cb+"type='text' value='"+initURL+"'></input>");
	h.push("<div class='zruPropertyTableDivider'></div></div>");

	h.push("<div class='zruPropertyTableDefaultCol'>");
	h.push("<input id='"+id+"default' style='width:100%;' "+cb+"type='text'></input>");
	h.push("<div class='zruPropertyTableDivider'></div></div>");

	h.push("<div class='zruPropertyTableConstraintCol'>");
	h.push("<input id='"+id+"constraint' style='width:100%;' "+cb+"type='text'></input>");
	h.push("<div class='zruPropertyTableDivider'></div></div>");
	
	h.push("<div class='zruPropertyTableDescCol'>");
	h.push("<input id='"+id+"desc' style='width:100%;' "+cb+"type='text'></input>");
	h.push("<div class='zruPropertyTableDivider'></div></div>");

	h.push("<img id='"+id+"delete' class='zruPropertyTableDeleteButton' src='"+this.iconDelete+"' onclick='zenPage.getComponent("+this.index+").deleteLine("+idx+");' >");
	line.innerHTML=h.join("");
	line.subIndex = idx;	 	

	group.getEnclosingDiv().appendChild(line);
	this.syncModel();
	return(line);
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

/// Add a new edit line to the table and pre-poplate it from a model object
ClientMethod populateLine(pObj) [ Language = javascript ]
{
	var line = this.addNewProperty();
	var id = 'zen'+this.index+'_'+line.subIndex+'_';
	var nCtrl = document.getElementById(id+'name');
	if (!pObj.n || pObj.n.length<1) {
		pObj.n = this.makeUniqueName(null);
	}
	nCtrl.value = pObj.n;
	nCtrl.disabled = pObj.l;
	var tCtrl = document.getElementById(id+'type');
	if (!pObj.t || pObj.t.length<1) {
		pObj.t = "%String";
	}
	tCtrl.value = pObj.t;
	tCtrl.disabled = pObj.l;
	
	if (!pObj.z || pObj.z.length<1) {
		pObj.z = pObj.n.toUppercase();
	}

	var zCtrl = document.getElementById(id+'url');
	zCtrl.value = pObj.z;
	
	var iCtrl = document.getElementById(id+'default');
	if (pObj.i) iCtrl.value = pObj.i;
	else iCtrl.value = "";

	var pCtrl = document.getElementById(id+'constraint');
	if (pObj.p && pObj.p.length>0) {
		var str = "";
		var len = pObj.p.length;
		for (var i = 0;i<len;i++) {
			if (i>0) str+=",";
			var o = pObj.p[i];
			if (o.v.indexOf(",")>-1) str+=o.n+'="'+o.v+'"';
			else str+=o.n+"="+o.v;
		}
		pCtrl.value = str;
	}
	else pCtrl.value = "";

	var dCtrl = document.getElementById(id+'desc');
	if (pObj.d) dCtrl.value = pObj.d;
	else dCtrl.value = "";

	var dCtrl = document.getElementById(id+'delete');
	if (pObj.l) dCtrl.style.display = "none";
	else dCtrl.style.display = "block";
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

/// Given a string and a delimiter, return an object with the first
/// delimited clause and the balance of the string (less the delimiter)
/// taking into account the possibility that a "false" delimiter might
/// appear in inside a double quoted string as part of the clause.
ClientMethod parseFirst(str, delimiter) [ Language = javascript ]
{
	if (!str) return({clause:null,rest:null});
	var l = str.length;
	var idx = 0;
	var inQuotes = false;
	while (idx<l) {
		var c = str.charAt(idx);
		if (c=='"') {
			inQuotes = !inQuotes;
		}
		else {
			if (c==delimiter && !inQuotes) {
				var o = {};
				o.clause = str.substring(0,idx);
				o.rest = str.substring(idx+1);
				return(o);
			}
		}
		idx++;
	}
	return({clause:str,rest:null});
}

/// Synchronize a given line of the table with a model property object
ClientMethod syncLine(idx) [ Language = javascript ]
{
	var o = {}
	var id = 'zen'+this.index+'_'+idx+'_';
	var nCtrl = document.getElementById(id+'name');
	o.n = this.makeUniqueName(nCtrl.value,idx);
	nCtrl.value = o.n;
	o.l = nCtrl.disabled;
	var tCtrl = document.getElementById(id+'type');
	o.t = tCtrl.value;
	if (!o.t || o.t.length==0) o.t = "%String";
	tCtrl.value = o.t;
	var zCtrl = document.getElementById(id+'url');
	o.z = zCtrl.value;
	if (!o.z || o.z.length<1) {
		o.z = o.n.toUpperCase();
		zCtrl.value = o.z;
	}
	var dCtrl = document.getElementById(id+'desc');
	o.d = dCtrl.value;
	var iCtrl = document.getElementById(id+'default');
	var v = iCtrl.value;
	if (v && v.charAt(0)!='{') v=v.split('"').join("");
	o.i = v;
	
	var pCtrl = document.getElementById(id+'constraint');
	var dtp = this.getDataTypeParameters();
	var dtpLen = dtp.length;
	var item = this.parseFirst(pCtrl.value,",");
	if (item.clause) {
		var arr = [];
		while (item.clause) {
			var obj = {};
			var nvp = item.clause.split('=');
			obj.n=nvp[0].toUpperCase();
			var ts = nvp[1];
			if (ts.charAt(0)=='"' && ts.charAt(ts.length-1)=='"') {
				ts = ts.substring(1,ts.length-1);
			}
			obj.v=ts;
			for (var i=0;i<dtpLen;i++) {
				if (obj.n == dtp[i]) {
					arr.push(obj);
					i = dtpLen;
				}
			}
			item = this.parseFirst(item.rest,",");
		}
		o.p = arr;
	}
	return(o);
}

/// Get the current model
ClientMethod getModel() [ Language = javascript ]
{
	this.syncModel();
	return(this.model);
}

ClientMethod getDataTypeParameters() [ Language = javascript ]
{
	var a = ["COLLATION","CONTENT","DISPLAYLIST","ESCAPE","FORMAT","INDEXSUBSCRIPTS","MAXLEN","MAXVAL","MINLEN","MINVAL","ODBCDELIMITER","MTOM","PATTERN","SCALE","TRUNCATE","VALUELIST","XMLTIMEZONE","XSDTYPE"];
	return(a);
}

/// Populate the table with data from the given model
ClientMethod restoreModel(m) [ Language = javascript ]
{
	// the model is an array of javascript objects (one property per object)
	// the objects themselves have the following fields:
	//  n : name
	//  d : description
	//  t : type
	//  p : an array of parameter objects
	//			where n:name and v:value
	//  i : intial value
	//  z : zen URL binding
	//  l : binary flag (locked) do not allow changes to name or type
	//Property objects:
	//{n:"ReportAuthor",d:"Author of Report",t:"%String",i:"BOB",z:"AUTHOR"}
	//{n:"Month",d:"Month (1 to 12) to run this report for. "" for all months.",t:"%Integer",p:[{n:"MAXVAL",v:"12"},{n:"MINVAL",v:"1"}],z:"MONTH"}	
	
	this.model=m;
	this.clear();
	var len = m.length;
	for (var i=0;i<len;i++) {
		this.populateLine(m[i]);
	}
}

/// Given a base root for a name, return a unique property name based on that
/// root and made unique by the addition of a numeric suffix if required.
ClientMethod makeUniqueName(root) [ Language = javascript ]
{
	if (!root) root = "RptProp";
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

/*
TODO get this screen resizing properly
ClientMethod adjustLayout() [ Language = javascript ]
{
	var group = this.getChildById("body");
	var kids = group.children;
	var len = kids.length
	for (var i=0;i<len;i++) {
		var comp = kids[i];
		if (comp.adjustLayout) comp.adjustLayout();
	}
}
*/
}
