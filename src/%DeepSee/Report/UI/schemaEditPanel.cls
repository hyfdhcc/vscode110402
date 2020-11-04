/// %DeepSee.Report.UI.schemaEditPanel
/// Displays a table of elements inthe working data set
/// with columns for Name, Derivation, Sort, and Break
Class %DeepSee.Report.UI.schemaEditPanel Extends %ZEN.Component.component [ System = 4 ]
{

Property enclosingClass As %ZEN.Datatype.cssClass [ InitialExpression = "zruSchemaTable" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.zruSchemaEditPanel {
}

.zruSchemaTableItem {
	background:#ffffff;
	color: #404040;
	font: 10pt Arial;
	width:100%;
	border-bottom:1px solid #C0C0C0;
	position:relative;
	top:0px;
	left:0px;
	min-height:18px;
	padding:2px;
	overflow:hidden;
	overflow-y:visible;
}

.zruSchemaTableItemWarning {
	background:#ffffaa;
	color: #dd0000;
	font: 10pt Arial;
	width:100%;
	border-bottom:1px solid #C0C0C0;
	position:relative;
	top:0px;
	left:0px;
	height:18px;
	padding:2px;
	overflow:hidden;
}

.zruSchemaTableGroup {
	background:#356b8d;
	color: white;
	font: 11pt Arial;
	width:100%;
	border-top:1px solid #C0C0C0;
	border-bottom:1px solid #C0C0C0;
	position:relative;
	top:0px;
	left:0px;
	height:17px;
	padding:2px;
}

.zruSchemaTableGroupWarning {
	background:#ffff00;
	color: #ff0000;
	font: 11pt Arial;
	width:100%;
	border-top:1px solid #C0C0C0;
	border-bottom:1px solid #C0C0C0;
	position:relative;
	top:0px;
	left:0px;
	height:17px;
	padding:2px;
	overflow:hidden;
}

.zruSchemaTableItemSelected {
	background:#d0d0f0;
	color: #000000;
	font: 10pt Arial;
	width:100%;
	border-bottom:1px solid #C0C0C0;
	position:relative;
	top:0px;
	left:0px;
	height:18px;
	padding:2px;
	overflow:hidden;
}

.zruSchemaNameItem {
	position:absolute;
	top:0px;
	
	display:inline-block;
	width:250px;
}

.zruSchemaDerivationItem {
	position:relative;
	top:0px;
	left:250px;
	
	display:inline-block;
	width:250px;
}

.zruSchemaBreakItem {
	display:inline-block;
	position: relative;
	top: -2px;
	left: 150px;
}

.zruSchemaSortItem {
	display:inline-block;
	position: relative;
	top: -2px;
	left: 150px;
}

.zruSchemaDeleteItem {
	display:inline-block;
	position:absolute;
	top:3px;
	right:8px;
	width:16px;
}

.zruSchemaExplainError {
	display:inline-block;
	position:absolute;
	top:3px;
	right:36px;
	width:16px;
}

.zruSchemaTable {
	height:100%;
	width:100%;
}


.zruSchemaTableHeader {
	background:#356b8d;
	color:white;
	font:12pt Arial;
	width:100%;
}

.zruSchemaNameHeader {
	display:inline-block;
	width:250px;
}

.zruSchemaDerivationHeader {
	display:inline-block;
	width:250px;
}

.zruSchemaSortHeader {
	display:none;
	width:50px;
}

</style>
}

Method %DrawHTML()
{
	&html<
	<div id="#(..%MakeId("header"))#" class="zruHeaderDiv"></div>
	<div id="#(..%MakeId("base"))#" class="zruSchemaEditPanel"></div>
	>
}

ClientMethod drawHeader(title, msgGroup, hlpGroup, msgItem, hlpItem) [ Language = javascript ]
{
	var hook = "zenPage.getComponent("+this.index+").";
	var h=[];
	h.push('<span class="zruHeaderTitle">'+title+'</span>');
	if (msgItem) {
		h.push('&nbsp;<a class="zruHeaderLink" href="#" title="'+hlpItem+'" onclick="'+hook+'addDatum();return false;">'+msgItem+'</a>');
	}
	if (msgGroup) {
		h.push('&nbsp;<a class="zruHeaderLink" href="#" title="'+hlpGroup+'" onclick="'+hook+'addGrouping();return false;">'+msgGroup+'</a>');
	}
	var d = this.findElement("header");
	d.innerHTML=h.join("");
}

ClientMethod resetTable() [ Language = javascript ]
{
	this.root = this.makeNode("_root","group","","","","","",[]);
	this.renderTable();
	zenPage.zruSchemaTable = this;
	this.lastPick = null;
	this.lastPickId = null;
}

/// If the master data source for the report is being changed, remove all
/// table entries that referred to the old source
ClientMethod clearTable() [ Language = javascript ]
{
	this.pruneDataTree(this.root,null);
	this.renderTable();
	this.lastPick = null;
	this.lastPickId = null;
}

ClientMethod pruneDataTree(node, parent) [ Language = javascript ]
{
	if (node.projection=='group') {
		var k = node.kids;
		var l = k.length;
		for (var i=l-1;i>=0;i--) {
			this.pruneDataTree(k[i],node);
		}
	}
	else {
		if (node.field && node.field.length>0) { // field based, has to go
			this.removeChild(parent,node);
		}
	}
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.drawHeader("Data Fields","Group","Add a subgrouping of the data for this report","Item","Add a non-DB field based item to the data set for this report");
	this.resetTable();
}

ClientMethod setOptionSet(picks) [ Language = javascript ]
{
}

ClientMethod setTitle(title) [ Language = javascript ]
{
	var c = zenPage.getComponentById(this.id+'.titleBox');
	c.setProperty('value',title);
}

/* 
This panel needs to mimic (and resolve with) the reportSchema model
as that part of the puzzle is in flux, we'll work with a local copy
here and resolve things later.

The local copy is concerned with a tree of nodes.  Each node is schemaElement
schemaElement is:
	projection {group,element,attribute,aggregate,parameter}
	name
	field
	baseType (type of field)
	derivation (computed)
	lexFormat (lexical format)
	sort (sorting priority)
	break (breaking field {T|F}
	type (aggregates only) {none,count,sum,ave,min,max}
	kids (groups only) array of schemaElements;
	parent (name of parent node)
	depth (???)
*/
ClientMethod showWarning(code) [ Language = javascript ]
{
	switch (code) {
	case 1:
		alert(zenText('This group is has no defined contents.'));
		break;
	case 2: 
		alert(zenText('The purpose of nesting groups within groups is to define sorting criteria for detail information and subgrouping boundaries for aggregate data.  Nesting groups without defining either sorting or breaking fields for the hierarchy  should be avoided.'));
		break;
	case 3:
		alert(zenText('Raw datum outside of the inner-most grouping may vary with record retrieval.  Only fields that are marked as breaking fields by the parent group(s) can be safely placed outside the core grouping.  All other fields should only be used for aggregation purposes.'));
		break;
	case 4:
		alert(zenText('Field items in the inner-most group represent individual record values.  Statistical aggregations of these individual values must be placed in a parent grouping.'));
		break;
	default:
		alert(zenText('Suspect data topology detected.'));
	}
}

ClientMethod findNodeById(root, name) [ Language = javascript ]
{
	if (root.name==name) return(root);
	var k = root.kids;
	if (k) {
		for (var i=0;i<k.length;i++) {
			if (k[i].name==name) return(k[i]);
			if (k[i].projection=="group") {
				var result = this.findNodeById(k[i],name);
				if (result) return(result);
			}
		}
	}
	return(null);
}

ClientMethod findDOMNodeByName(n) [ Language = javascript ]
{
	var l = ZLM.getElementsByClassPrefix("zruSchemaNameItem",this.getEnclosingDiv());
	var ll = l.length;
	for (var i=0;i<ll;i++) {
		if (l[i].innerHTML==n) return(l[i].parentNode);
	}
	return(null);
}

ClientMethod makeUniqueName(baseName) [ Language = javascript ]
{
	var suffix = 1;
	if (this.findNodeById(this.root, baseName)==null) return(baseName);
	var name = baseName+"_"+suffix;
	while (this.findNodeById(this.root, name)) {
		suffix++;
		name = baseName+"_"+suffix;
	}
	return(name);
}

ClientMethod insertIntoGroup(group, child) [ Language = javascript ]
{
	if (group.projection!="group") return;
	if (!group.kids) group.kids=[];
	var k = group.kids;
	for (var i=k.length;i>0;i--) {
		k[i]=k[i-1];
	}
	k[0]=child;
}

ClientMethod insertBefore(oldNode, newNode) [ Language = javascript ]
{
	var parent = this.findNodeById(this.root,oldNode.parent);
	if (parent.projection!="group") return;
	if (!parent.kids) parent.kids=[];
	var k = parent.kids;
	for (var i=k.length;i>0;i--) {
		k[i]=k[i-1];
		if (k[i]==oldNode) {
			k[i-1]=newNode;
			return;
		}
	}
}

ClientMethod appendChild(parent, child) [ Language = javascript ]
{
	if (parent.projection!="group") return;
	if (!parent.kids) parent.kids=[];
	parent.kids.push(child);
}

ClientMethod removeChild(parent, child) [ Language = javascript ]
{
	if (parent.projection!="group") return;
	var k=parent.kids;
	var shift = false;
	for (var i=0;i<k.length;i++) {
		if (shift) k[i-1]=k[i];
		if (k[i]==child) shift=true;
	}
	k.pop();
}

ClientMethod calculateNodeDerivation(schemaNode) [ Language = javascript ]
{
	var n = schemaNode;
	if (n.projection=="group") {
		return("Subgrouping");
	}
	if (n.expression) {
		return(n.expression);
	}
	if (n.projection=="aggregate") {
		if (n.type=="") return(n.field);
		if (n.type=="COUNT") return("Count of "+n.field);
		if (n.type=="SUM") return("Sum of "+n.field);
		if (n.type=="AVG") return("Average of "+n.field);
		if (n.type=="MIN") return("Minimum of "+n.field);
		if (n.type=="MAX") return("Maximum of "+n.field);
		
	}
	return(n.field);
}

ClientMethod makeNode(name, projection, field, type, expr, sort, breaking, kids, sqlRef, sysType) [ Language = javascript ]
{
	var n = {};
	if (!sqlRef) sqlRef = field;
	n.name = name;
	n.projection = projection;
	n.field = field;
	n.sqlRef = sqlRef;
	n.sysType = sysType;
	n.baseType = "";
	n.type = type;
	//n.lexFormat = "";
	n.kids = kids;
	n.sort = sort;
	n.expression = expr;
	//n.descending = false;
	n.breaking = breaking;
	n.parent = "";
	n.depth = 0;
	n.derivation = this.calculateNodeDerivation(n);
	return(n);
}

ClientMethod dragAbortHandler() [ Language = javascript ]
{
	zenPage.restoreCurrentBackup();
	ZLM.DragManager.endNotify = null;
}

/// Built-in drag handler for tree component.
/// Let the user drag the selected node.
ClientMethod dragStartHandler(dragData) [ Language = javascript ]
{
	var hook = "zenPage.getComponent("+this.index+").";
	ZLM.DragManager.endNotify = hook+"dragAbortHandler()";
	zenPage.backupCurrentModel();
	
	var ok = false;
	var line= this.getLineByStructure(ZLM.getDragInnerSource());
	var name = "";
	if (line) name = this.getNodeNameByStructure(line);
	if (name!="") {
		ok = true;
		dragData.value = this.findNodeById(this.root,name);
		dragData.text = name;
			
		// construct avatar
		var icon = ZLM.makeElement("div",{style:'position:absolute;border:1px solid darkgray;background:#d0d0f0;'},name);
		ZLM.setDragAvatar(icon);
		this.removeSchemaElement(name);
	}
	return ok;
}

/*
 *
 * ENTRY POINTS FOR CALLBACKS
 *
 */
ClientMethod autopopulateDBItem(cosName, sqlName, cosType) [ Language = javascript ]
{
	var n =cosName;
	// Skip binary streams - at least until ZR adds support for them
	if (cosType && cosType.indexOf && cosType.indexOf("Binary")> -1) return;
 	var gp = this.findNodeById(this.root,"queryResult");
 	// IF we cant't find the group "queryResult" we should add one, then fill it
 	if (!gp) {
		gp  = this.makeNode(this.makeUniqueName("queryResult"),'group',"","","","","",[]);
		this.appendChild(this.root,gp);
		this.renderTable();
 	} 	
 	if (gp) {
	 	var tagName = n;
	 	if (n.indexOf('%')==0) {
		 	n = n.substring(1);
		 	tagName = "sys"+n;
	 	} 

		var node  = this.makeNode(this.makeUniqueName(tagName),'element',n,"","","","",null,sqlName,cosType);
		this.insertIntoGroup(gp,node);
		this.renderTable();
		zenPage._documentEdited = true;
 	}
}

ClientMethod addDBItemFromDrag(name, field, cosType) [ Language = javascript ]
{
	ZLM.DragManager.endNotify = null;
	var sqlRef = null;
	var zDD = ZLM.dragData;
	if (zDD.sourceComponent != this) { // came from the data tree
		var tree = zDD.sourceComponent;
		var fields = field.split(".");
		field = fields.join('->');

		field = field.split('%').join('');
		sqlRef = tree.parent.resolveNestedReference(zDD.sourceItem);
		sqlRef = sqlRef.split('%').join('');
	}
	
	var dropPoint = ZLM.getDragInnerDestination();
	var n = field;
	if (typeof(field)=="string") {
		n  = this.makeNode(this.makeUniqueName(name),'element',field,"","","","",null,sqlRef,cosType);
	}
	if (dropPoint.className=="zruSchemaTable") {
		// Simply append to end of base default group
		if (!this.root.kids) {
			this.appendChild(this.root,n);
		}
		else {
			var kIdx = this.root.kids.length-1;
			var insertPt = this.root.kids[kIdx];
			if (insertPt.projection=='group') this.appendChild(insertPt,n);
			else this.appendChild(this.root,n);
		}
	}
	else {
		// Need to find the insertion point
		var line = this.getLineByStructure(dropPoint);
		var name = ""
		if (line) {
			name = this.getNodeNameByStructure(line);
			if (name!="") {
				var insertPoint = this.findNodeById(this.root,name);
				if (insertPoint) {
					if (insertPoint.projection=="group") {
						this.insertIntoGroup(insertPoint,n);
					}
					else {
						this.insertBefore(insertPoint,n);
					}
				}
			}
		}
	}
	this.renderTable();
	zenPage._documentEdited = true;
}

ClientMethod addGrouping() [ Language = javascript ]
{
	var n = this.findNodeById(this.root,this.lastPickId);
	var parentGroup = this.root;
	if (n) {
		if (n.projection=='group') parentGroup = n;
		else parentGroup = this.findNodeById(this.root,n.parent); 
	}
	var n  = this.makeNode(this.makeUniqueName("Group"),'group',"","","","","",[]);
	this.appendChild(parentGroup,n);
	this.renderTable();
	zenPage._documentEdited = true;
}

ClientMethod addDatum() [ Language = javascript ]
{
	var n = this.findNodeById(this.root,this.lastPickId);
	var parentGroup = this.root;
	if (n) {
		if (n.projection=='group') parentGroup = n;
		else parentGroup = this.findNodeById(this.root,n.parent); 
	}
	var n = this.makeNode(this.makeUniqueName("PageItem"),'attribute',"","","0","","",[]);
	this.appendChild(parentGroup,n);
	this.renderTable();
	zenPage._documentEdited = true;
}

/// User click on data field remove button.
ClientMethod removeSchemaElement(who) [ Language = javascript ]
{
	var n = this.findNodeById(this.root,who);
	var p = this.findNodeById(this.root,n.parent);
	this.removeChild(p,n);
	this.renderTable();
	zenPage._documentEdited = true;
}

/// User click on line to edit .
ClientMethod editSchemaElement(who, dom) [ Language = javascript ]
{
	if (this.lastPick) {
		this.lastPick.style.background="";
		this.lastPick.style.color="";
	}
	var n = this.findNodeById(this.root,who);
	this.lastPick = dom;
	this.lastPickId = who;
	dom.style.background='#5ba4dc';
	dom.style.color="#ffffff";
	var editor = zenPage.getDataPropertiesWidget();
	editor.setWorkingObject(n);
}

/// User click on line to edit .
ClientMethod editSchemaGroup(who, dom) [ Language = javascript ]
{
	if (this.lastPick) {
		this.lastPick.style.background="";
		this.lastPick.style.color="";
	}
	var n = this.findNodeById(this.root,who);
	this.lastPick = dom;
	this.lastPickId = who;

	dom.style.background='#5ba4dc';
	dom.style.color="#ffffff";
	var editor = zenPage.getDataPropertiesWidget();
	editor.setWorkingObject(n);
}

ClientMethod updateProperties(who) [ Language = javascript ]
{
	if (who && who.name && who.name.length>0) this.lastPickId = who.name;
	var n = this.findNodeById(who.name);
	for (p in who) n[p] = who[p];
	this.renderTable();
	zenPage._documentEdited = true;
}

/*
 *
PROJECTION TO HTML STUFF
 *
 */
ClientMethod getLineByStructure(domNode) [ Language = javascript ]
{
	var n = domNode;
	while (!(n.tagName=="div" || n.tagName=="DIV") && n.parentNode) {
		n = n.parentNode;
	}
	if (n.className=="zruSchemaTableItem") return(n);
	if (n.className=="zruSchemaTableItemWarning") return(n);
	if (n.className=="zruSchemaTableItemSelected") return(n);
	if (n.className=="zruSchemaTableGroup") return(n);
	if (n.className=="zruSchemaTableGroupWarning") return(n);
	if (n.className=="zruSchemaTableGroupSelected") return(n);
	return(null);
}

ClientMethod getNodeNameByStructure(domNode) [ Language = javascript ]
{
	return(domNode.firstChild.innerHTML);
}

ClientMethod projectNodeAsHTML(schemaNode) [ Language = javascript ]
{
	var n = schemaNode;
	n.derivation = this.calculateNodeDerivation(n);
	var indent = 2+25*(n.depth-1);
	var width = 250-indent;
	var h = []
	var cl = 'zruSchemaTableItem'
	if (n.projection=="group") {
		if (n.warn>0) cl = 'zruSchemaTableGroupWarning';
		else cl = 'zruSchemaTableGroup';
	}
	else if (n.warn>0) cl = 'zruSchemaTableItemWarning';
	
	if (n.projection=="group") h.push("<div class='"+cl+"' onclick='zenPage.zruSchemaTable.editSchemaGroup("+'"'+n.name+'"'+",this);'>");
	else h.push("<div class='"+cl+"' onclick='zenPage.zruSchemaTable.editSchemaElement("+'"'+n.name+'"'+",this);'>");

	h.push("<span class='zruSchemaNameItem' style='width:"+width+"px;padding-left:"+indent+"px'>"+n.name+"</span>");
	h.push("<span class='zruSchemaDerivationItem' >"+n.derivation+"</span>");
	if (n.breaking && n.breaking.length>0) {
		h.push("<span class='zruSchemaBreakItem' >Break on "+n.breaking+"</span>");
	}
	if (n.sort && n.sort.length>0) {
		h.push("<span class='zruSchemaSortItem' >&nbsp;Sort by "+n.sort+"</span>");
	}

	if (n.warn>0) h.push("<image class='zruSchemaExplainError' src='images/warning.png' onclick='zenPage.zruSchemaTable.showWarning("+n.warn+");' />");

// Add up or down arrow for direction of sort
	h.push("<image class='zruSchemaDeleteItem' src='deepsee/close_a_16.gif' onclick='zenPage.zruSchemaTable.removeSchemaElement("+'"'+n.name+'"'+");' />");
	h.push("</div>");
	return(h.join(""));
}

ClientMethod validateTree(n, b, r) [ Language = javascript ]
{
	var parent = n.name;
	var depth = n.depth+1;
	var breaks = [];
	if (b && b.split) breaks = b.split(',');
	
	n.warn = 0; // assume no error
	if (n.projection=='group') {
		var k = n.kids;
		var l = k.length;
		//Test 1: All groups should have kids
		if (l==0) n.warn = 1;
		else {
			// Test 2: if this group contains other groups it should have a break or sort set
			var nested = false;
			var i=0;
			while (!nested && i<l) {
				if (k[i].projection=='group') nested = true;
				i++;
			}
			if (nested && !((n.breaking && n.breaking.length>0)||(n.sort && n.sort.length>0))) n.warn = 2;
			if (n.breaking && n.breaking.length>0) breaks.push(n.breaking);
			var breakingList = null;
			if (breaks.length>0) breakingList = breaks.join(',');
			for (var i=0;i<l;i++) this.validateTree(k[i],breakingList,nested);
		}
	}
	else { // item specific issues
		if (r) {
			if (n.projection=='element') {
				// this is an error, but it's our error, fix it
				n.projection='attribute';
			}
			// Test 3: if this item is part of nesting group it either needs to be on the 
			// the breaking list or be come form of aggregation
			if ((n.field && n.field.length>0)&& (!n.type) && (!n.expression)) { // raw field
				var i=breaks.length-1;
				while(i>=0 && breaks[i]!=n.field) i--;
				if (i<0) n.warn=3;
			}
		}
		else {
			// Test 4: no aggregation in the inner-most group
			if (n.type=="NONE") n.type="";
			if (n.type && n.type.length>0) {
				n.warn=4;
			}
			if (n.projection=='attribute') {
				// raw datum in innermost groups project as elements, not attributes
				if ((!n.type)&&(!n.expression)&&(n.field)) n.projection='element';
			}
		}
	}
}

ClientMethod projectTreeAsHTML(root) [ Language = javascript ]
{
	var parent = root.name;
	var depth = root.depth+1;
	
	var s = [];
	if (root!=this.root) s.push(this.projectNodeAsHTML(root));
	var k = root.kids;
	if (k) {
		for (var i=0;i<k.length;i++) {
			k[i].depth = depth;
			k[i].parent = parent;
			if (k[i].projection=="group") {
				k[i].derivation = "Subgrouping of "+parent;
			}
			s.push(this.projectTreeAsHTML(k[i]));
		}
	}
	return(s.join(""));
}

ClientMethod renderTable() [ Language = javascript ]
{
	this.validateTree(this.root);
	
	var h = []
	h.push("<div class='zruSchemaTableHeader' >");
	h.push("<span class='zruSchemaNameHeader' >Name</span>");
	h.push("<span class='zruSchemaDerivationHeader' >Derivation</span>");
	h.push("<span class='zruSchemaSortHeader' >Sort</span>");
	h.push("</div>");

	h.push(this.projectTreeAsHTML(this.root));
	var d = this.findElement("base");
	d.innerHTML=h.join("");
	this.updateReportModel();
	
	if (this.lastPickId && this.lastPickId.length>0) {
		var n = this.findDOMNodeByName(this.lastPickId);
		this.lastPick = n;
		if (n) {	
			n.style.background='#5ba4dc';
			n.style.color="#ffffff";
		}
		else this.lastPickId=null;
	}
}

/*
 *
 * SYNCHROMIZE WITH MODEL STUFF 
 *
 */
ClientMethod restoreNode(n) [ Language = javascript ]
{
	var name = n.n;
	var proj = "group"
	switch(n.t) {
		 case 'at': proj='attribute';
		 	break;
		 case 'ag': proj='aggregate';
		 	break;
		 case 'el': proj='element';
		 	break;
	}
	var field = n.f;
	if (!field) field="";
	var agType = n.o;
	if (!agType) agType="";
	var exp = n.e;
	if (!exp) exp = "";
	var sysT = n.st;
	if (!sysT) sysT = "";
	if (proj=="group") {
		var s = n.s;
		if (!s) s="";
		var br = n.br;
		if (!br) br="";
		var node = this.makeNode(name,proj,field,agType,exp,s,br,[]);
		var k = n.k;
		var len = k.length;
		for (var i=0;i<len;i++) {
			var kid = this.restoreNode(k[i]);
			this.appendChild(node,kid);
		}
		return(node);
	}
	else {
		var sqlRef = "";
		if (n.s && n.s.length>0) sqlRef = n.s;
		var node = this.makeNode(name,proj,field,agType,exp,"","",null,sqlRef,sysT);
		return(node);
	}
}

ClientMethod restoreModel(m) [ Language = javascript ]
{
 	this.jsModel = m;
 	this.root = this.restoreNode(m);
 	this.renderTable();
}

ClientMethod getModel() [ Language = javascript ]
{
	this.jsModel = this.buildGroupElement(this.root);
	return(this.jsModel);
}

ClientMethod buildModelElement(node) [ Language = javascript ]
{
	var e = {};
	
//	e.projection = node.projection;
//	e.name = node.name;
//	e.field = node.field;
//	e.type = node.type;

	e.n = node.name;
	switch(node.projection) {
		case 'attribute':
			e.t = 'at';
			break;
		case 'aggregate':
			e.t = 'ag';
			break;
		case 'element':
			e.t = 'el';
		 	break;
	}
	if (node.field && node.field.length>0) {
		e.f = node.field;
	}	
	if (node.type && node.type.length>0) {
		e.o = node.type;
	}
	if (node.expression && node.expression.length>0) {
		e.e	= node.expression;
	}
	if (node.sysType && node.sysType.length>0) {
		e.st = node.sysType;
	}
	if (node.sqlRef && node.sqlRef.length>0) {
		e.s = node.sqlRef;
	}
	else if (node.field && node.field.length>0) {
		e.s = node.field;
	}
	return(e);
}

ClientMethod buildGroupElement(node) [ Language = javascript ]
{
	var g = {};
//	g.name = node.name;
//	g.xpath = "";
//	g.breakOnField = "";
//	g.hasSQL = 0;
//	g.elements = [];
	g.n = node.name;
	g.t = 'gp';
	if (node.breaking && node.breaking.length>0) {
		g.br = node.breaking;
	}
	if (node.sort && node.sort.length>0) {
		g.s = node.sort;
	}
	g.k = [];
	var k = node.kids;
	for (var i=0;i<k.length; i++) {
		if (k[i].projection=='group') g.k.push(this.buildGroupElement(k[i]));
		else g.k.push(this.buildModelElement(k[i]));
	}
	return(g);
}

ClientMethod extractGroups(l, root) [ Language = javascript ]
{
	
	l.push(root);
	var k = root.kids;
	for (var i=0;i<k.length;i++) {
		if (k[i].projection=="group") this.extractGroups(l,k[i]);
	}
}

ClientMethod extractFields(l, root) [ Language = javascript ]
{
	if (root.field && root.field.length>0) {
		var f = root.field;
		var skip = false;
		for (var i=0;i<l.length;i++) {
			if (f==l[i]) {
				skip = true;
				i = l.length;
			}
		}
		if (!skip) l.push(f);
	}
	else if (root.projection=="group") {
		var k=root.kids;
		for (var i=0; i<k.length; i++) this.extractFields(l,k[i]);
	}
}

ClientMethod updateReportModel() [ Language = javascript ]
{
	if (!this.model) return;

	var s = this.model.schema;
	if (!s) s = {};
	s.description = "";
		
	var l = [];
	this.extractGroups(l,this.root);
	
	s.groups = [];
	for (var i=0;i<l.length;i++) s.groups.push(this.buildGroupElement(l[i]));

	var l = [];
	this.extractFields(l,this.root);
	s.dataFields = [];
	for (var i=0;i<l.length;i++) {
		s.dataFields.push({name:l[i], sourceProperty:l[i]});
	}
}

}
