/// Spinner control
Class %DeepSee.Report.UI.captionEditor Extends %ZEN.Component.control [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Parameter CONTROLCLASS = "captionEditor";

/// onabort event handler:
/// This event is fired when the user discards changes to the value of this control.
Property onabort As %ZEN.Datatype.eventHandler;

/// onaccept event handler:
/// This event is fired when the user commits changes to the value of this control.
Property onaccept As %ZEN.Datatype.eventHandler;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.captionEditorBody {
	position:relative;
	width:100%;
	height:100%;
	top:0px;
	left:0px;
}

.captionEditorWindow {
	position:relative;
	width:25px;
	top:0px;
	left:0px;
	overflow:hidden;
	border:1px dotted #000042;
}

.captionEditorInput {
	position:relative;
	top: 0px;
	left: 0px;
	background: none;
	border: none;
	margin: 0px;
	width: 4000px;
	white-space: nowrap;
}

.captionEditorTest {
	position:absolute;
	top:0px;
	left:0px;
	display:none;
	white-space:nowrap;
}
</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("body"))#" class="captionEditorBody" >
			<div id="#(..%MakeId("window"))#" class="captionEditorWindow" >
				<input id="#(..%MakeId("input"))#" type='text' maxLength='1000' class="captionEditorInput" onkeyup="this.controller.monitorKeys(event);" />
			</div>
			<div id="#(..%MakeId("testDiv"))#" class="captionEditorTest" ></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._base = this.getEnclosingDiv();
	this._base.controller = this;
	this._body = this.findElement('body');
	this._body.controller = this;
	this._win = this.findElement('window');
	this._win.controller = this;
	this._input = this.findElement('input');
	this._input.controller = this;
	this._test = this.findElement('testDiv');
	this._test.controller = this;

	this._isActive=false;
	this._base.style.display="none";
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.value=value;
		break;
	case 'onabort':
		this.onabort = value;
		break;
	case 'onaccept':
		this.onaccept = value;
		break;
	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

ClientMethod adjustWidth() [ Language = javascript ]
{
	var d=this._test;
	var ws=this._win.style;
	d.innerHTML=this._input.value+"W";
	d.style.display="block";
	if (this._win.offsetWidth<d.offsetWidth) ws.width=(d.offsetWidth+2)+"px";
	d.style.display="none";
}

ClientMethod applyGC(gc) [ Language = javascript ]
{
	if (!gc) return;
	var str = zenPage._editor._propertyPanel.projectGCAsJS(gc);
	var nvl=str.split(";");
	for (var i=0;i<nvl.length;i++) {
		var s=nvl[i].split(":");
		if (s[0]) {
			var toWhom = null;
			if (s[0].indexOf("text")>=0 || s[0].indexOf("font")>=0 || s[0]=="color") toWhom="I";
			else if (s[0]=="width" || s[0]=="height" || s[0].indexOf("background")>=0) toWhom="W";
			if (toWhom=="I") {
				this._input.style[s[0]]=s[1];
				this._test.style[s[0]]=s[1];
			}
			else if (toWhom=="W") this._win.style[s[0]]=s[1];
		}
	}
	this._input.style.border="none";
	this._input.style.margin="none";
	this._input.style.padding="none";
	this._input.style.width="100%";
	this._test.style.border="none";
	
	//WINDOW DIV SHOULD MATCH GEOMETRY and fill OF BOX IN GC
	//INPUT BOX SHOULD MATCH FONT metrics and color
}

ClientMethod anchor(x, y, parent, acceptCB, abortCB, gc) [ Language = javascript ]
{
	if (this._isActive) this.done();
	this._anchorX=x;
	this._anchorY=y;
	this._abortStr="";
	var s=this._base.style;
	s.position="absolute";
	s.top=ZLM.getPageOffsetTop(parent)+y+"px";
	s.left=ZLM.getPageOffsetLeft(parent)+x+"px";
	s.display="block";
	s.zIndex="10";
	this.value="";
	this._input.value="";
	this.onaccept = acceptCB;
	this.onabort = abortCB;
	this.adjustWidth();
	this._input.focus();	
	if (gc) this.applyGC(gc);
	this._isActive=true;
}

ClientMethod bindToNode(node, value, acceptCB, abortCB, gc) [ Language = javascript ]
{
	if (this._isActive) this.done();
	var s=this._base.style;
	s.position="absolute";
	s.top=ZLM.getPageOffsetTop(node)-2+"px";
	s.left=ZLM.getPageOffsetLeft(node)-2+"px";
	s.display="block";
	this.value=value;
	this._abortValue=this.value;
	this._input.value=this.humanizeXMLString(this.value);
	this.onaccept=acceptCB;
	this.onabort=abortCB;
	if (gc) this.applyGC(gc);
	this.adjustWidth();	
	this._input.focus();
	this._base.style.zIndex=5;
	this._isActive=true;
}

ClientMethod monitorKeys(event) [ Language = javascript ]
{
	if (event.keyCode=="13") {
		this.done();
		zenPage._editor.resetMode();
	}
	else if (event.keyCode=="27") {
		this.abort();
		zenPage._editor.resetMode();
	}		
	else {
		var safeInput = this.sanitizeXMLString(this._input.value);
		if (safeInput!=this.value) {
			this.value = safeInput;
			this.adjustWidth();	
		}
	}
}

ClientMethod done() [ Language = javascript ]
{
	this._base.style.display="none";
	if (!this._isActive) return;
	this._isActive=false;
	if (this.onaccept) zenInvokeCallbackMethod(this.onaccept,this,'onaccept');;
}

ClientMethod abort() [ Language = javascript ]
{
	this._base.style.display="none";
	if (!this._isActive) return;
	this.value=this._abortValue;
	this._isActive=false;
	if (this.onabort) zenInvokeCallbackMethod(this.onabort,this,'onabort');;
}

ClientMethod sanitizeXMLString(origStr) [ Language = javascript ]
{
		return(origStr);
	
	if (!origStr || !(origStr.split)) return(origStr)
	var str = origStr.split("&").join('&amp;');
	str = str.split('"').join('&quot;');
	str = str.split("'").join('&apos;');
	str = str.split("<").join('&lt;');
	str = str.split(">").join('&gt;');
	return(str);
}

ClientMethod humanizeXMLString(origStr) [ Language = javascript ]
{
		return(origStr);
	
	if (!origStr || !(origStr.split)) return(origStr)
	var str = origStr.split('&gt;').join(">");
	str = str.split('&lt;').join("<");
	str = str.split('&apos;').join("'");
	str = str.split('&quot;').join('"');
	str = str.split('&amp;').join('&');
	return(str);
}

}
