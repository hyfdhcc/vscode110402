/// Method defintion panel
/// This is the display panel for a code editor that allows 
/// the user to inject server side code into generated DeepSee report 
/// data collector classes
Class %DeepSee.Report.UI.methodDefinitionPanel Extends %ZEN.Component.composite [ DependsOn = (%DeepSee.Report.UI.codeEditor, %DeepSee.Report.UI.argTableEditor), System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zenCEM.js";

/// ondelete event handler:
/// This event is fired when the contents of this component are
/// marked for deletion by the user.
Property ondelete As %ZEN.Datatype.eventHandler;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">

.methodDefNameSection {
	position:absolute;
	top:0px;
	left:0px;
	width:45%;
}

.methodDefNameLabel {
	position:absolute;
	top:0px;
	left:0%;
}

.methodDefNameWidget {
	position:absolute;
	top:0px;
	left:10%;
	width:80%;
}

.methodDefNameWidget .text {
	font: 12px monospace;
	width:100%;
}

.methodDefTypeSection {
	position:absolute;
	top:0px;
	left:45%;
	width:25%;
}

.methodDefTypeLabel {
	position:absolute;
	top:0px;
	left:0px;
}

.methodDefTypeWidget {
	position: absolute;
	top:0px;
	left:20%;
	width:70%;
}

.methodDefTypeWidget .text {
	font: 12px monospace;
	width:100%;
}

.methodDefLanguageSection {
	position:absolute;
	top:0px;
	left: 70%;
	width: 15%;
}

.methodDefLanguageLabel {
	position:absolute;
	top:0px;
	left:0px;
}

.methodDefLanguageWidget {
	position:absolute;
	top:0px;
	right:1px;
	width:60%;
}

.methodDefArgsLabel {
}

.methodDefBodyLabel {
}

.methodDefBodyWidget {
}

.codeEditor {
	height:150px;
}

.textarea {
	width:100%;
	height:100px;
	color:#404040;
	font: 12px monospace;
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="methodDefinitionPanel" >
<expando id="collapseCtrl" layout="none" caption="NewMethod" remember="true" imageContracted="images/disclosure-contracted-inv.png" imageExpanded="images/disclosure-expanded-inv.png" onshow="zenThis.composite.adjustLayout();" >
<group enclosingClass="methodDefEditor" layout="none">
<group layout="none" enclosingStyle="position:relative; top:0px; left:0px; height:26px; margin-top:3px;" >

<group layout="none" enclosingClass="methodDefNameSection">
<label id="_methodDefNameLbl" enclosingClass="methodDefNameLabel" value="Name:" />
<text id="_methodDefName" enclosingClass="methodDefNameWidget" onchange="zenThis.composite.setName(zenThis.getValue());"/>
</group>

<group layout="none" enclosingClass="methodDefTypeSection">
<label id="_methodDefTypeLbl" enclosingClass="methodDefTypeLabel" value="Returns:" />
<text id="_methodDefType" enclosingClass="methodDefTypeWidget" onchange="zenThis.composite.setType(zenThis.getValue());"/>
</group>

<group layout="none" enclosingClass="methodDefLanguageSection">
<label id="_methodDefLanguageLbl" enclosingClass="methodDefLanguageLabel" value="Language:" />
<combobox id="_methodDefLanguage" enclosingClass="methodDefLanguageWidget" buttonImage="portal/comboGrayButton.png" buttonImageDown="portal/comboBlueButton.png" valueList="ObjectScript" onchange="zenThis.composite.setLanguage(zenThis.getValue());"/>
</group>

<image id="_methodDefDelete" enclosingClass='zruSchemaDeleteItem' src='deepsee/close_a_16.gif' onclick='zenThis.composite.handleDeleteRequest();' />

</group>

<label enclosingClass="methodDefArgsLabel" value="Arguments:" />
<group layout="none" enclosingStyle="margin-left:10px; margin-right:10px; margin-bottom:5px">
<argTableEditor id="_argDefTable" />
</group>

<label enclosingClass="methodDefBodyLabel" value="Implementation:" />
<textarea id="_methodDefBody" enclosingClass="methodDefBodyWidget" onchange="zenThis.composite.setBody(zenThis.getValue());" />
<!--
TODO restore this:
<codeEditor id="_methodDefBody" enclosingClass="methodDefBodyWidget" onchange="zenThis.composite.setBody(zenThis.getValue());" />
-->
</group>
</expando>
</composite>
}

ClientMethod handleDeleteRequest() [ Language = javascript ]
{
	if (!confirm('About to permanently delete '+this.jsModel.n+'() method.\nClick Ok to proceed or Cancel to abort.')) return;
	if (this.ondelete) {
		zenInvokeCallbackMethod(this.ondelete,this,'ondelete');
	}
}

ClientMethod adjustLayout() [ Language = javascript ]
{
	var ed = this.getEnclosingDiv();
	if (!ed || !ed.offsetWidth) return;  // no point in adjusting a hidden element
	var prefix = "id"+this.index+".";
	if (!this._nameLabel) this._nameLabel=zenPage.getComponentById(prefix+"_methodDefNameLbl");
	if (!this._nameCtrl) this._nameCtrl=zenPage.getComponentById(prefix+"_methodDefName");
	if (!this._typeLabel) this._typeLabel=zenPage.getComponentById(prefix+"_methodDefTypeLbl");
	if (!this._typeCtrl) this._typeCtrl=zenPage.getComponentById(prefix+"_methodDefType");
	if (!this._languageLabel) this._languageLabel=zenPage.getComponentById(prefix+"_methodDefLanguageLbl");
	if (!this._languageCtrl) this._languageCtrl=zenPage.getComponentById(prefix+"_methodDefLanguage");
	if (!this._deleteCtrl) this._deleteCtrl=zenPage.getComponentById(prefix+"_methodDefDelete");
	if (!this._argCtrl) this._argCtrl=zenPage.getComponentById(prefix+"_argDefTable");
	if (!this._nameLabel) return;
	var g = this._nameLabel.getEnclosingDiv().parentNode;
	var tW = g.clientWidth - this._deleteCtrl.getEnclosingDiv().offsetWidth-24;
	var nameW = tW/2;
	var typeW = tW/4;
	var langW = tW/4;
	
	var s = this._nameCtrl.getEnclosingDiv().style;
	var ref = this._nameLabel.getEnclosingDiv();
//	s.width = (nameW-2-ref.offsetWidth)+"px";
//	s.left = (ref.offsetLeft+ref.offsetWidth+2)+"px";
	var s = this._typeCtrl.getEnclosingDiv().style;
	var ref = this._typeLabel.getEnclosingDiv();
//	s.width = typeW-2-ref.offsetWidth+"px";
//	s.left = (ref.offsetLeft+ref.offsetWidth+2)+"px";
	var s = this._languageCtrl.getEnclosingDiv().style;
	var ref = this._languageLabel.getEnclosingDiv();
//	s.width = langW-2-ref.offsetWidth+"px";
//	s.left = (ref.offsetLeft+ref.offsetWidth+2)+"px";
	this._languageCtrl.setProperty("dropdownWidth","150px");
	this._languageCtrl.setProperty("dropdownHeight","69px");
}

ClientMethod unquoteBody(str) [ Language = javascript ]
{
	var s = str.split('\\t').join('\t');
	var s = s.split('\\n').join('\n');
	var s = s.split('\\\\').join('\\');
	return(s);
}

ClientMethod quoteBody(str) [ Language = javascript ]
{
	var s = str.split('\\').join('\\\\');
	var s = s.split('\n').join('\\n');
	var s = s.split('\t').join('\\t');
	return(s);
}

ClientMethod getModel() [ Language = javascript ]
{
	var d6 = this.getChildById('_argDefTable');
	this.jsModel.a = d6.getModel();
	return(this.jsModel);
}

/// Set the associated JSON model object for this editor
ClientMethod restoreModel(jsObj) [ Language = javascript ]
{
	if (!jsObj) {
		alert("Bad Method Model in restoreModel");
		return;
	}
	this.jsModel = jsObj;
	var d1 = this.getChildById('_methodDefName');
	if (!d1) return;
	d1.setValue(jsObj.n);
	var d2 = this.getChildById('collapseCtrl');
	d2.setProperty('caption',jsObj.n);
	var d3 = this.getChildById('_methodDefType');
	d3.setValue(jsObj.t);
	var d4 = this.getChildById('_methodDefLanguage');
	d4.setValue(jsObj.l);
	var d5 = this.getChildById('_methodDefBody');
	d5.setValue(this.unquoteBody(jsObj.b));
	var d6 = this.getChildById('_argDefTable');
	d6.setJSModel(jsObj.a);
}

ClientMethod setName(n) [ Language = javascript ]
{
	if (!n) {
//ZLM.cerr('no name, resetting');
		var d = this.getChildById('_methodDefName');
		d.setValue(this.jsModel.n);
	}
	else {
//ZLM.cerr('setting model name to '+n);
		this.jsModel.n=n;
		var d = this.getChildById('collapseCtrl');
		d.setProperty('caption',n);
	}
//ZLM.dumpObj(this.jsModel);
}

ClientMethod setType(v) [ Language = javascript ]
{
	if (!v) {
//ZLM.cerr('no value, resetting');
		var d = this.getChildById('_methodDefType');
		d.setValue(this.jsModel.t);
	}
	else {
//ZLM.cerr('setting model type to '+v);
		this.jsModel.t=v;
	}
//ZLM.dumpObj(this.jsModel);
}

ClientMethod setLanguage(v) [ Language = javascript ]
{
	if (!v) {
//ZLM.cerr('no value, resetting');
		var d = this.getChildById('_methodDefLanguage');
		d.setValue(this.jsModel.l);
	}
	else {
//ZLM.cerr('setting model langauge to '+v);
		this.jsModel.l=v;
	}
//ZLM.dumpObj(this.jsModel);
}

ClientMethod setBody(v) [ Language = javascript ]
{
//ZLM.cerr('setting model body to '+v);
	this.jsModel.b=this.quoteBody(v);
//ZLM.dumpObj(this.jsModel);
}

}
