/// 
Class %DeepSee.Report.UI.argTableEditor Extends %ZEN.Component.component [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Parameter DEFAULTUPICON As STRING = "deepsee/ds_up_16.png";

Parameter DEFAULTDOWNICON As STRING = "deepsee/ds_down_16.png";

Parameter DEFAULTDELETEICON As STRING = "deepsee/close_a_16.png";

Parameter DEFAULTADDICON As STRING = "deepsee/ds_plus_16.gif";

/// URI of image to display for the up button.
Property iconUp As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTUPICON} ];

/// URI of image to display for the down button.
Property iconDown As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTDOWNICON} ];

/// URI of image to display for the delete button.
Property iconDelete As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTDELETEICON} ];

/// URI of image to display for the up button.
Property iconAdd As %ZEN.Datatype.uri [ InitialExpression = {..#DEFAULTADDICON} ];

Property headerNameTxt As %ZEN.Datatype.string [ InitialExpression = "Name" ];

Property headerTypeTxt As %ZEN.Datatype.string [ InitialExpression = "Type" ];

Property headerDefaultTxt As %ZEN.Datatype.string [ InitialExpression = "Default" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.argTableHeader {
	font:bold 14px Arial;
	background:#356b8d;
	color:#ffffff;
	width:100%;
	height:22px;
	position:relative;
	top:0px;
	left:0px;
}

.argTableNameHeader {
	position:absolute;
	top:2px;
	width:35%;
	height:100%;
	padding-left:3px;
	display:inline-block;
}

.argTableTypeHeader {
	position:absolute;
	top:2px;
	left:35%;
	width:15%;
	height:100%;
	padding-left:3px;
	display:inline-block;
}

.argTableDefaultHeader {
	position:absolute;
	top:2px;
	left:50%;
	padding-left:3px;
	width:40%;
	height:100%;
	display:inline-block;
}

.argTableAddButton {
	position:absolute;
	top:2px;
	right:2px;
}

.argTableLine {
	position:relative;
	top:0px;
	left:0px;
	height:18px;
}

.argTableNameCell input {
	border:1px solid gray;
	background:#fefeff;
	color:#404040;
	font:14px monospace;
	width:100%;
}

.argTableNameCell {
	position:absolute;
	top:0px;
	left:0px;
	width:35%;
	height:100%;
	display:inline-block;
	border-right:1px solid gray;
}

.argTableTypeCell {
	position:absolute;
	top:0px;
	left:35%;
	width:15%;
	height:100%;
	display:inline-block;
	border-right:1px solid gray;
}

.argTableTypeCell input {
	border:1px solid gray;
	background:#fefeff;
	color:#404040;
	font:14px monospace;
	width:100%;
}
.argTableDefaultCell {
	position:absolute;
	top:0px;
	left:50%;
	width:50%;
	height:100%;
	display:inline-block;
}

.argTableDefaultCell input {
	border:1px solid gray;
	background:#fefeff;
	color:#404040;
	font:14px monospace;
	width:100%;
}

.argTableUpButton {
	position:absolute;
	top:3px;
	right:32px;
}

.argTableDownButton {
	position:absolute;
	top:3px;
	right:16px;
}

.argTableDeleteButton {
	position:absolute;
	top:3px;
	right:0px;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("editBase"))#" class="argTableEditor">
		<div class="argTableHeader">
			<span id="#(..%MakeId("nameHeader"))#" class="argTableNameHeader">#(..headerNameTxt)#</span>
			<span id="#(..%MakeId("typeHeader"))#" class="argTableTypeHeader">#(..headerTypeTxt)#</span>
			<span id="#(..%MakeId("defaultHeader"))#" class="argTableDefaultHeader">#(..headerDefaultTxt)#</span>
			<img id="#(..%MakeId("addButton"))#" class="argTableAddButton" src="#(..iconAdd)#" onclick="zenPage.getComponent(#(..index)#).addArgument();" ></img>		
		</div>
		<div id="#(..%MakeId("tableBody"))#" class="argTableBody">
		</div>
		</div>
	>
}

ClientMethod reset() [ Language = javascript ]
{
	var bDiv = this.findElement("tableBody");
if (!bDiv) {
	alert('toasted in reset');
	return;
}
	bDiv.innerHTML = "";
}

ClientMethod getModel() [ Language = javascript ]
{
	return(this.jsModel);
}

ClientMethod setJSModel(m) [ Language = javascript ]
{
	this.reset();
	this.line = [];
	if (!m) {
		this.jsModel=[];
		return;
	}
	this.jsModel = m;
	var l = m.length;
	for (var i=0;i<l;i++) {
		if (m[i]) this.appendEntry(m[i]);
	}
}

ClientMethod addArgument() [ Language = javascript ]
{
	var o = {};
	o.n = "Argument"+this.jsModel.length;
	o.t = "%String";
	o.d = "";
	this.jsModel.push(o);
	this.appendEntry(o);
}

ClientMethod appendEntry(jsObj) [ Language = javascript ]
{
	var bDiv = this.findElement("tableBody");
if (!bDiv) {
	alert('toasted in appendEntry');
	return;
}
	var lDiv = ZLM.makeElement("div",{"class":"argTableLine"});	
	var idxNum = this.line.length;
	this.line.push(lDiv);
	
	var nDiv= ZLM.makeElement("div",{"class":"argTableNameCell"});
	var nEdit = ZLM.makeElement("input",{type:"text", onchange:"this.controller.syncModel(this.idx,'name',this);"});
	nEdit.value = jsObj.n;
	nEdit.controller = this;
	nEdit.idx = idxNum;
	nDiv.appendChild(nEdit);
	lDiv.appendChild(nDiv);
	lDiv.nEdit = nEdit;

	var tDiv= ZLM.makeElement("div",{"class":"argTableTypeCell"});
	var tEdit = ZLM.makeElement("input",{type:"text", onchange:"this.controller.syncModel(this.idx,'type',this);"});
	tEdit.value = jsObj.t;
	tEdit.controller = this;
	tEdit.idx = idxNum;
	tDiv.appendChild(tEdit);
	lDiv.appendChild(tDiv);
	lDiv.tEdit = tEdit;

	var dDiv= ZLM.makeElement("div",{"class":"argTableDefaultCell"});
	var dEdit = ZLM.makeElement("input",{type:"text", onchange:"this.controller.syncModel(this.idx,'default',this);"});
	dEdit.value = jsObj.d;
	dEdit.controller = this;
	dEdit.idx = idxNum;
	dDiv.appendChild(dEdit);
	lDiv.appendChild(dDiv);
	lDiv.dEdit = dEdit;

	var iDiv = ZLM.makeElement("img",{"class":"argTableUpButton","src":this.iconUp,"onclick":"zenPage.getComponent("+this.index+").promoteLine(this.parentNode.idx);"});
	lDiv.appendChild(iDiv)

	var iDiv = ZLM.makeElement("img",{"class":"argTableDownButton","src":this.iconDown,"onclick":"zenPage.getComponent("+this.index+").demoteLine(this.parentNode.idx);"});
	lDiv.appendChild(iDiv)

	var iDiv = ZLM.makeElement("img",{"class":"argTableDeleteButton","src":this.iconDelete,"onclick":"zenPage.getComponent("+this.index+").deleteLine(this.parentNode.idx);"});
	lDiv.appendChild(iDiv)
	lDiv.idx = idxNum;
	
	bDiv.appendChild(lDiv);
}

ClientMethod findArgIdxByIdNum(num) [ Language = javascript ]
{
	var a = this.args;
	for (var i=a.length-1;i>=0;i--) {
		if (a[i].num==num) return(i);
	}
	return(-1);
}

ClientMethod syncModel(idx, field, ctrl) [ Language = javascript ]
{
	var o = this.jsModel[idx];
	var v = ctrl.value;
	switch(field) {
		case "name": o.n = v;
			break;
		case "type": o.t = v;
			break;
		case "default": o.d = v;
			break;
	}
}

ClientMethod promoteLine(num) [ Language = javascript ]
{
	if (num>0) {
		var n1 = num-1;
		var bDiv = this.findElement("tableBody");
if (!bDiv) {
	alert('toasted in promoteLine');
	return;
}
		var m = this.jsModel;
		var l = this.line;
		bDiv.removeChild(l[num]);
		bDiv.insertBefore(l[num],l[n1]);
		var t = l[num];
		l[num]=l[n1];
		l[n1]=t;
		var n = l[num];
		n.idx = num;
		n.nEdit.idx = num;
		n.tEdit.idx = num;
		n.dEdit.idx = num;
		n = l[n1];
		n.idx = n1;
		n.nEdit.idx = n1;
		n.tEdit.idx = n1;
		n.dEdit.idx = n1;
		var t = m[num];
		m[num]=m[n1];
		m[n1]=t;		
	}
//this.dumpModel();
	return;
}

ClientMethod demoteLine(num) [ Language = javascript ]
{
	if (num<this.line.length-1) {
		var n1 = num+1;
		var bDiv = this.findElement("tableBody");
		var m = this.jsModel;
		var l = this.line;
		bDiv.removeChild(l[n1]);
		bDiv.insertBefore(l[n1],l[num]);
		var t = l[num];
		l[num]=l[n1];
		l[n1]=t;
		var n = l[num];
		n.idx = num;
		n.nEdit.idx = num;
		n.tEdit.idx = num;
		n.dEdit.idx = num;
		n = l[n1];
		n.idx = n1;
		n.nEdit.idx = n1;
		n.tEdit.idx = n1;
		n.dEdit.idx = n1;
		var t = m[num];
		m[num]=m[n1];
		m[n1]=t;		
	}
	return;
}

ClientMethod deleteLine(num) [ Language = javascript ]
{
	var bDiv = this.findElement("tableBody");
	var m = this.jsModel;
	var l = this.line;
	bDiv.removeChild(l[num]);
	var len = m.length;
	for (var i=num+1;i<len;i++) {
		var n = l[i];
		m[i-1] = m[i];
		l[i-1] = n;
		n.idx = i-1;
		n.nEdit.idx = i-1;
		n.tEdit.idx = i-1;
		n.dEdit.idx = i-1;
	}
	m.pop();
	l.pop();
	return;
}

ClientMethod dumpModel() [ Language = javascript ]
{
	ZLM.cerr("Current model:");
	for (var i=0;i<this.jsModel.length;i++){
		ZLM.cerr("index: "+i);
		ZLM.dumpObj(this.jsModel[i]);
	}
}

}
