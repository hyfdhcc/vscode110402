/// Supplemental Code Editor
/// This is the master display panel for the code editors that allows 
/// the user to inject server side code into generated DeepSee report 
/// data collector classes
Class %DeepSee.Report.UI.supplementalCodeEditor Extends %ZEN.Component.composite [ DependsOn = %DeepSee.Report.UI.methodDefinitionPanel, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zenCEM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.supplementalCodePanel {
	position:relative;
	top:0px;
	left:0px;
	background: #e8e7e2;
	width: 100%;
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
}

.expandoChildren {
	font:14px Arial;
	color:#000077;
	margin-left:15px;
	margin-right:15px;
	margin-bottom:10px;
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="supplementalCodePanel" >
	<html id="supplementalCodeHeader"  OnDrawContent="DrawSupplementalCodeHeader"></html>
<group id="body" layout="none" >
<!--<methodDefinitionPanel/>-->
</group>
</composite>
}

/// Draw the contents of the Supplemental Code Header (the region above the list of known code blocks).
Method DrawSupplementalCodeHeader(pSeed As %String) As %Status
{
	Set msgChange = ("Add")
	Set hlpChange = ("Add a new method to this data collector class")
	
	&html<<div class="zruHeaderDiv">#("Supplemental Code")#
	&nbsp;<a class="zruHeaderLink" href="#" title="#(hlpChange)#" onclick="zenPage.getComponent(#(..index)#).addNewMethod();return false;">#(msgChange)#</a>
	</div>>
	Quit $$$OK
}

ClientMethod getNewMethodPanel() [ Language = javascript ]
{
	if (this.activeKids<this.kidList.length) {
		// recycle an existing child to skip a trip to the server
		for (var i=this.activeKids;i<this.kidList.length;i++) {
			var mdp = this.kidList[i];
			var mdps = mdp.getEnclosingDiv().style;
			if (mdps.display=="none") {
				mdps.display="block";
				mdp.recycled=true;
				return(mdp);
			}
		}
	}
 	var group = this.getChildById("body");
	zenSynchronousMode=true;
	var mdp = zenPage.createComponentNS("","methodDefinitionPanel");
	this.kidList.push(mdp);
	group.addChild(mdp,true);
	group.refreshContents();
	zenSynchronousMode=false;
	this.activeKids++;
	return(mdp);
}

/// Add a new method to the set
ClientMethod addNewMethod() [ Language = javascript ]
{
	var objHook = "zenPage.getComponent("+this.index+")."; 	
	var mdp = this.getNewMethodPanel();
	if (!mdp) {
		alert("Timing error while attempting to create new method panel");
		return;
	}
	mdp.setProperty("onrefresh",objHook+"populatePanel("+mdp.index+","+this.jsModel.length+");");
	mdp.setProperty("ondelete",objHook+"deleteMethod("+mdp.index+","+this.jsModel.length+");");
	// inital refresh doesn't fire for recycled widgets
	try {
		this.populatePanel(mdp.index,this.jsModel.length);
	}
	catch (err) {
	}
	return(mdp);
}

/// Remove any active method panels from this screen
ClientMethod reset() [ Language = javascript ]
{
	if (this.kidList) {
		var k = this.kidList;
		for (var i=k.length-1;i>=0;i--) {
			k[i].getEnclosingDiv().style.display="none";
		}
	}
	this.activeKids = 0;
}

/// Delete a given method from the model and update the screen accoridngly
ClientMethod deleteMethod(editorIdx, modelIdx) [ Language = javascript ]
{
	this.kidList[modelIdx].getEnclosingDiv().style.display="none";
	this.restoreModel(this.getModel());
}

/// Set underlying model of the widget and update the screen accordingly
/// 	The model object is an array of JSON method objects
/// 	A methodObj has the following properties <br />
/// 	n: (string) The method name <br />
/// 	t: (string) The return type <br />
/// 	l: (string) The language used (currently only ObjectScript is supported) <br />
/// 	a: (array)	A list of argument objects <br />
/// b: (long string) The body of the method <p />
/// 	Each entry of the args array is an argObj, and looks like: <br />
/// 	n: (string) The name of the parameter
/// t: (string) The parameter type
/// d: (string) The default value of the parameter
ClientMethod restoreModel(m) [ Language = javascript ]
{
	this.reset();
	if (!m || !m.length) m=[];	
	this.jsModel = m
	var objHook = "zenPage.getComponent("+this.index+")."; 	
	var len = m.length;
	for (var i = 0;i<len;i++) {
		var mdp = this.getNewMethodPanel();
		mdp.setProperty("onrefresh",objHook+"populatePanel("+mdp.index+","+i+");");
		mdp.setProperty("ondelete",objHook+"deleteMethod("+mdp.index+","+i+");");
		try {
			this.populatePanel(mdp.index,i);
		}
		catch (err) {
		}
	}
}

ClientMethod getModel() [ Language = javascript ]
{
	// need to filter out any deleted records
	var m = this.kidList;
	var ml = m.length;
	var ex = [];
	for (var i=0;i<ml;i++) {
		var disp = m[i].getEnclosingDiv().style.display;
		if (disp!="none") {
			ex.push(m[i].getModel());
		}
	}
	return(ex);
}

/// Given a proposed method name, return true is the method name is unique 
/// with respect to the other method names in the model
ClientMethod isUniqueMethodName(n) [ Language = javascript ]
{
	var m = this.jsModel;
	var idx = 0;
	var l = m.length;
	for (var i=0;i<l;i++) {
		if (m[i].n==n) return(false);
	}
	return(true);
}

/// Given a proposed method name, deconflict it with all existing method 
/// names in the model by appending a numeric suffix 
ClientMethod deconflictMethodName(n) [ Language = javascript ]
{
	var m = this.jsModel;
	var name=n;
	if (!m) {
		alert('No active model in deconflict');
		return(n);
	}
	var idx = 0;
	var done = false;
	var l = m.length;
	while (!done) {
		done = true;
		name = n+idx;
		for (var i=0;i<l;i++) {
			if (m[i].n==name) done=false;
		}
		idx++;
	}
	return(name);
}

/// After the creation of a new Method Definition Panel, populate it with the 
/// appropriate data based on the methods of the class being edited.
ClientMethod populatePanel(panelIdx, methodIdx) [ Language = javascript ]
{
	var m = this.jsModel;
	if (!m) {
		return;
	}
	var l = m.length;
	var data = null;
	if (methodIdx<l) data = m[methodIdx];
	else {
		var name = this.deconflictMethodName("NewMethod");
		data = {n:name,t:'%String',l:'ObjectScript',a:null,b:'\tSet tVal = ""\n\tQuit tVal'};
		m.push(data);
	}
	var mdp = zenPage.getComponent(panelIdx);
	if (mdp) {
		mdp.restoreModel(data);
		mdp.adjustLayout();
	}
}

/// Correct the layout of the screen to account for the current window size
ClientMethod adjustLayout() [ Language = javascript ]
{
	var group = this.getChildById("body");
	var kids = group.children;
	var len = kids.length;
	for (var i=0;i<len;i++) {
		var comp = kids[i];
		if (comp.adjustLayout) comp.adjustLayout();
	}
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.kidList=[];
	this.activeKids=0;
}

}
