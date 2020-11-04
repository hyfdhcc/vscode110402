/// Where Clause Editor
/// This is the master display panel for the where clause editor that allows 
/// the user to inject filter selections the generated DeepSee report 
/// data collector classes at run time
Class %DeepSee.Report.UI.whereClauseEditor Extends %ZEN.Component.composite [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property helpMsg As %ZEN.Datatype.caption [ InitialExpression = "Question marks (?) should not be used as a placeholder on this screen, use #( _exp_ )# syntax instead." ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.whereClausePanel {
	position:relative;
	top:0px;
	left:0px;
	width: 95%;
	padding-left:25px;
	padding-right:25px;
	padding-top:10px;
	font:16px monospace;
	color:#404040;
}

.zruWhereClauseParams {
	position:relative;
	top:0px;
	left:10%;
	width: 80%;
}

.zruWhereClauseCaption {
	width:100%;
	font:16px monospace;
	color:#404040;
}

.zruWhereClauseInput {
	border:1px solid #c0c0c0;
	background:none;
	color:#404040;
	font:16px monospace;
	width:100%;
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none"  >
<html id="whereClauseHeader"  OnDrawContent="DrawWhereClauseHeader"></html>
<group id="body" enclosingClass="whereClausePanel" layout="none" >
<html OnDrawContent="DrawEmptyWhereClause"></html>
</group>
</composite>
}

/// Draw the contents of the Where Clause Header (the region above the table of known properties).
Method DrawWhereClauseHeader(pSeed As %String) As %Status
{
	
	&html<<div class="zruHeaderDiv">#("SQL Filters")#
	</div>>
	Quit $$$OK
}

/// Draw the contents of the Where Clause Header (the region above the table of known properties).
Method DrawEmptyWhereClause(pSeed As %String) As %Status
{
	
	&html<<div style="color:#ff0000;font:bold 18px Arial;">#("No Data Selected")#
	</div>>
	Quit $$$OK
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.model = [];
}

/// Reset the table
ClientMethod clear() [ Language = javascript ]
{
	var group = this.getChildById("body").getEnclosingDiv();
	group.innerHTML = "";
}

/// Add a new property edit line to the table
ClientMethod addNewClause() [ Language = javascript ]
{
	var id = this.id+'_';
	
	var group = this.getChildById("body");
	var objHook = "zenPage.getComponent("+this.index+").";
	var cb = "onchange='"+objHook+"syncModel();' onkeypress='"+objHook+"filterKeystroke(event);' ";
	
	var h=[];
	h.push("<div id='"+id+"sqlText' class='zruWhereClauseCaption'></div>");
	h.push("<div class='zruWhereClauseCaption'>WHERE</div>");
	h.push("<input id='"+id+"clauseText' style='width:100%;' class='zruWhereClauseInput' "+cb+"type='text'></input>");
	h.push("<div id='"+id+"parameterGroup' class='zruWhereClauseParams' ></div>");
	
	group.getEnclosingDiv().innerHTML = h.join("");
}

/// Users should not enter questions marks as parameter placeholders on this screen.
/// Trap the event if it happens and alert the user to the correct syntax
ClientMethod filterKeystroke(e) [ Language = javascript ]
{
	var qmCode = 63;
	if (e.which==qmCode||e.keyCode==qmCode||e.charCode==qmCode) {
		alert(this.helpMsg);
		e.preventDefault();
		return(false);
	}
}

/// Return a doctored WHERE clause where the parameters are embedded in the text 
/// as using a '#(' whatever ')#' notation
ClientMethod makeQuotedWhereStatement(pObj) [ Language = javascript ]
{
	var s = pObj.w;
	var p = pObj.p;
	var l = p.length;
	
	var piece = s.split('?');
	var pl=piece.length;
	
	var out = piece[0];
	for (var i=0;i<l;i++) {
		out+="#("+p[i]+")#";
		if (i+1<pl) out+=piece[i+1];
	}
	return(out);
}

ClientMethod parseQuotedWhereStatement(str) [ Language = javascript ]
{
	var pre = str.split('#(');
	var pl = pre.length;
	var a = [];
	var e = [];
	a.push(pre[0]);
	for (var i = 1;i<pl;i++) {
		var post = pre[i].split(')#');
		if (post.length!=2) {
			alert("Improperly quoted expression in clause\n"+str);
			return(null);
		}
		e.push(post[0]);
		a.push(post[1]);
	}
	return({w:a.join('?'),p:e});
}

/// Add the base fields to the screen and pre-poplate them from a model object
ClientMethod populatePane(pObj) [ Language = javascript ]
{
	this.addNewClause();
	var id = this.id+'_';
	var sqlCtrl = document.getElementById(id+"sqlText");
	var txtCtrl = document.getElementById(id+"clauseText");
	var groupDiv = document.getElementById(id+"parameterGroup");
	
	var s=[];
	s.push('SELECT ');
	s.push(pObj.fld.join(", "));
	s.push('<br />');
	s.push('FROM '+pObj.src);
	sqlCtrl.innerHTML = s.join("");
	
	txtCtrl.value = this.makeQuotedWhereStatement(pObj);
/*	
	if (pObj.p) {
		var objHook = "zenPage.getComponent("+this.index+").";
		var cb = "onchange='"+objHook+"syncModel();' ";
		var pList = []
		pList.push("? PARAMETERS:<br />");
		var len = pObj.p.length;
		for (var i=0;i<len;i++) {
			pList.push("<input id='"+id+p+i+"' type='text' "+cb+" class='zruWhereClauseInput' value='"+pObj.p[i]+"' /><br />");
		}
		groupDiv.innerHTML = pList.join("");
	}
*/
	txtCtrl.focus();
}

/// Synchronize the underlying model with the currently displayed values
ClientMethod syncModel() [ Language = javascript ]
{
	var id = this.id+'_';
	var sqlCtrl = document.getElementById(id+"sqlText");
	var txtCtrl = document.getElementById(id+"clauseText");
	var groupDiv = document.getElementById(id+"parameterGroup");

	var oldWhere = this.model.w;
	var obj = this.parseQuotedWhereStatement(txtCtrl.value);
	if (obj) {
		this.model.w = obj.w;
		this.model.p = [];
		for (var i=0;i<obj.p.length;i++) this.model.p[i]=obj.p[i];
	}
	// ZLM.dumpObj(this.model);
}

/// Get the current model
ClientMethod getModel() [ Language = javascript ]
{
	this.syncModel();
	return(this.model);
}

/// Populate the pane with data from the given model
ClientMethod restoreModel(m) [ Language = javascript ]
{
	// the model is a javascript object with the following fields:
	// src: The persistent data class to draw FROM
	// fld: An array of field names to extract
	// ob: The ORDER BY field list expressed as an array by precidence
	// w: The body of the WHERE clause with non-field/built-in function values
	//     expressed as '?' to be specified as parameter expressions
	// p: An array of expressions that map to parameters in the WHERE clause
	//     The order of the array binds to the order of the '?' placeholders
	//     in the body of the clause
	//
	// Example:
	// { src:"ZENApp_Report.Invoice",
	//   fld:["ID","Customer","Num","SalesRep","SaleDate"],
	//   w:"(Month(SaleDate) = ?) OR (? IS NULL)",
	//   ob:["SalesRep","SaleDate"],
	//   p:["..Month","..Month"]}
	
	this.model=m;
	this.clear();
	this.populatePane(m);
}

}
