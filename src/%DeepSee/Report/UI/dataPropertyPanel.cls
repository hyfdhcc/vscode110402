/// %DeepSee.Report.UI.dataPropertyPanel
Class %DeepSee.Report.UI.dataPropertyPanel Extends %ZEN.Component.composite [ LegacyInstanceContext, System = 4 ]
{

/// Set this to the correct domain.
Parameter DOMAIN;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.zruDataPropertyPanelTitle {
	position:relative;
	left:0px; top:0px;
	height:12pt;
	width:180px;
	border-bottom:1px solid #c0c0c0;
	background:#e8e7e2;
	color:#404040;
	text-align:left;
	padding: 5px;
}

.zruDataPropertyPanelBody {
	position:relative;
	left:0px;
	top:0px;
	right:0px;
	padding: 5px;
	background: #ffffff;
	font: 12px Arial;
	color: #000077;	
}

</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="cssIsland" >
<group id="titleBox" layout="none" enclosingClass="zruHeaderDiv" >
<label controlClass="zruHeaderTitle" value="Properties"    />
</group>

<group layout="none" enclosingClass="zruDataPropertyPanelBody" >
<text id="ctrlFieldName" label="Field Name" value="" size="30" disabled="true" onchange="zenThis.controller.updateValue(zenThis,'name');" onkeypress="zenThis.controller.validateFieldNameKeystroke(zenThis,'name');" onkeydown="zenThis.controller.notifyFieldNameDelete(zenThis,'name');"/>
<text id="ctrlFieldSource" label="Source Expression"  value="" size="30" disabled="true" onchange="zenThis.controller.updateValue(zenThis,'src');" onkeypress="zenThis.controller.updateValue(zenThis,'src');"/>
<group layout="none" enclosingStyle="position:relative; width:100%; height:0px; margin-top:3px; margin-bottom:3px; border:1px solid #a0a0a0; line-spacing:0px; font-size:0px;" />

<group id="aggregationGroup" layout="none" enclosingClass="cssIsland">
<label value="Aggregation:" enclosingStyle="position:absolute; top:2px; left:0px; color:#434343;font:10pt Arial;" />
<combobox size="6" id="ctrlFieldAggregation" buttonImage="portal/comboGrayButton.png" buttonImageDown="portal/comboBlueButton.png" value="None" valueList="NONE,COUNT,SUM,AVG,MIN,MAX" displayList="None,Count,Sum,Average,Minimum,Maximum" enclosingStyle="position:absolute; top:0px; left:100px;" controlStyle="color:#434343; font:10pt Arial;" onchange="zenPage.getDataPropertiesWidget().updateValue(zenThis,'type');"/>
</group>

<!--
<label value="Logical format:" enclosingStyle="position:absolute; top:24px; left:0px; color:#434343;font:10pt Arial;" />
<combobox size="6" id="ctrlFieldFormat" buttonImage="portal/comboGrayButton.png" buttonImageDown="portal/comboBlueButton.png" valueList="String" enclosingStyle="position:absolute; top:22px; left:100px;"  controlStyle="color:#434343; font:10pt Arial;" onchange="zenPage.getDataPropertiesWidget().updateValue(zenThis,'format');"/>
-->

<group id="sortOptionsGroup" enclosingClass="cssIsland" enclosingStyle="position:relative;" >

<label value="Break On" enclosingStyle="color:#434343;font:10pt Arial;" />
<combobox size="22" id="ctrlFieldBreak" buttonImage="portal/comboGrayButton.png" buttonImageDown="portal/comboBlueButton.png"  valueList="(none)" enclosingStyle=""  controlStyle="color:#434343; font:10pt Arial;" onchange="zenThis.controller.updateValue(zenThis,'break');"/>

<label value="Secondary Sort By" enclosingStyle="color:#434343;font:10pt Arial;" />
<combobox size="22" id="ctrlFieldSort" buttonImage="portal/comboGrayButton.png" buttonImageDown="portal/comboBlueButton.png"  valueList="(none)" enclosingStyle=""  controlStyle="color:#434343; font:10pt Arial;" onchange="zenThis.controller.updateValue(zenThis,'sort');"/>

<!--
<label value="Descending:" enclosingStyle="position:absolute; top:0px; left:20px; color:#434343;font:10pt Arial; white-space:nowrap;" />
<label value="Breaking:" enclosingStyle="position:absolute; top:20px; left:20px; color:#434343;font:10pt Arial; white-space:nowrap;" />

<checkbox id="ctrlFieldBreak" enclosingStyle="position:absolute; top:0px; left:100px;" disabled="true" onchange="zenPage.getDataPropertiesWidget().updateValue(zenThis,'breaking');"/>
<checkbox id="ctrlFieldDirection" enclosingStyle="position:absolute; top:20px; left:100px;" disabled="true" onchange="zenPage.getDataPropertiesWidget().updateValue(zenThis,'descending');"/>
-->
</group>

</group>
</composite>
}

ClientMethod disableAggregationGroup() [ Language = javascript ]
{
	var n = this.getChildById("aggregationGroup").getEnclosingDiv();
	n.style.display="none";
}

ClientMethod enableAggregationGroup() [ Language = javascript ]
{
	var n = this.getChildById("aggregationGroup").getEnclosingDiv();
	n.style.display="block";
}

ClientMethod disableSortOptionsGroup() [ Language = javascript ]
{
	var n = this.getChildById("sortOptionsGroup").getEnclosingDiv();
	n.style.display="none";
}

ClientMethod enableSortOptionsGroup() [ Language = javascript ]
{
	var n = this.getChildById("sortOptionsGroup").getEnclosingDiv();
	n.style.display="block";
}

ClientMethod disableSourceBox() [ Language = javascript ]
{
	var n = this.getChildById("ctrlFieldSource");
	n.setProperty("disabled",true);

	var ni = n.findElement("control");
	var nis = ni.style;
	nis.border="1px solid #ffffff";
	nis.background="#ffffff";
	nis.color="#000077";
}

ClientMethod enableSourceBox() [ Language = javascript ]
{
	var n = this.getChildById("ctrlFieldSource");
	n.setProperty("disabled",false);

	var ni = n.findElement("control");
	var nis = ni.style;
	nis.border="1px solid #a0a0a0";
	nis.background="";
	nis.color="#404040";
}

ClientMethod notifyFieldNameDelete(ctrl, fieldID) [ Language = javascript ]
{
	var ze = zenEvent;
	var cd = ze.keyCode;
	if (!cd) cd=ze.charCode;
	if (!cd) cd=ze.which;
	if (cd==8) {
		var panel = this;
		setTimeout(function(){panel.updateValue(ctrl,fieldID);},0);
	}
	return(true);
}

ClientMethod validateFieldNameKeystroke(ctrl, fieldID) [ Language = javascript ]
{
	var cc = ctrl.findElement("control");
	var ze = zenEvent;
	var cd = ze.keyCode;
	if (!cd) cd=ze.charCode;
	if (!cd) cd=ze.which;
	if ((cd<32) || (cd>=48 && cd <=57) || (cd>=65 && cd<=90) || (cd>=97 && cd<=122) ||
		(cd>=192 && cd <=214) || (cd>=216 && cd<=246) || (cd>=248 && cd<=255)) {
		var panel = this;
		setTimeout(function(){panel.updateValue(ctrl,fieldID);},0);
		return(true);
	}
	return(ZLM.killEvent(ze));
}

ClientMethod updateValue(ctrl, fieldID) [ Language = javascript ]
{
	var value = ctrl.getValue();
	var obj = this._activeObj;
	if (!obj) return;
	switch (fieldID) {
		case 'name':
			obj.name = value;
			break;
		case 'src':
			obj.expression = value;
			break;
		case 'type':
			if (obj.field != null) { // Item is DB driven...
				if (value == 'NONE' || value == "") {
					if (obj.projection =='aggregate') obj.projection = 'attribute';
					obj.type = "";
				}
				else {
					if (obj.projection == 'attribute' || obj.projection == 'element') obj.projection = 'aggregate';
					//if (value!="Count") value = value.substring(0,3);
					obj.type = value.toUpperCase();
				}
			}
			break;
//		case 'format':
//			break;
		case 'sort':
			if (value == '(none)') {
				obj.sort = ""
			}
			else {
				obj.sort = value;
			}
			break;
		case 'break':
			if (value == '(none)') {
				obj.breaking = ""
			}
			else {
				obj.breaking = value;
			}
			break;
//		case 'descending':
//			obj.descending = value;
//			break;
	}
	zenPage.getSchemaTableWidget().updateProperties(this._activeObj);
}

/// Set the working object for this editor
ClientMethod setWorkingObject(who) [ Language = javascript ]
{
	this.getChildById("ctrlFieldName").findElement("control").blur();
	this.getChildById("ctrlFieldSource").findElement("control").blur();

	this._activeObj = who;
	this.initializeDataFields(who);
}

ClientMethod getChildFields(k) [ Language = javascript ]
{
	var list = "(none)";
	var kl = k.length;
	for (var i=0;i<kl;i++) {
		var n = k[i];
		if (n.field && n.field.length>0) {
			var s = ","+n.field;
			if (list.indexOf(s)<0) list+=s;
		}
		if (n.projection=='group') {
			var tmpL = this.getChildFields(n.kids);
			tmpL = tmpL.substring(6);
			if (tmpL.length>0) list+=tmpL;
		}
	}
	return(list);
}

ClientMethod initializeDataFields(who) [ Language = javascript ]
{
	this.src = who;
	
	if (!who) {
		var nameW = this.getChildById("ctrlFieldName");
		nameW.setValue("");
		var sourceW = this.getChildById("ctrlFieldSource");
		sourceW.setValue("");
		this.disableAggregationGroup();
		this.disableSortOptionsGroup();
		return;
	}
	var nameW = this.getChildById("ctrlFieldName");
	nameW.setValue(who.name);
	nameW.setProperty("disabled",false);
	var sourceW = this.getChildById("ctrlFieldSource");
	if (who.expression && who.expression.length>0) {
		sourceW.setValue(who.expression);
		this.enableSourceBox();
		this.disableAggregationGroup();
		this.disableSortOptionsGroup();
		return;
	}
	if (who.field) sourceW.setValue(who.field);
	else sourceW.setValue("Data Grouping");
	this.disableSourceBox();
	
	if (who.projection=="group") {
		this.disableAggregationGroup();
		this.enableSortOptionsGroup();
		var kList = this.getChildFields(who.kids);

		var breakW = this.getChildById("ctrlFieldBreak");
		breakW.setProperty("valueList",kList);
		breakW.setValue(who.breaking);

		var sortW = this.getChildById("ctrlFieldSort");
		sortW.setProperty("valueList",kList);
		sortW.setValue(who.sort);

//		var directionW = this.getChildById("ctrlFieldDirection");
//		directionW.setValue(who.descending);
//		var breakW = this.getChildById("ctrlFieldBreak");
//		breakW.setValue(who.breaking);
	}
	else {	
		this.disableSortOptionsGroup();
		this.enableAggregationGroup();
		var aggW = this.getChildById("ctrlFieldAggregation");
		if (!who.type || who.type=="") aggW.setValue("NONE");
		else aggW.setValue(who.type);
//		var formatW = this.getChildById("ctrlFieldFormat");
//		formatW.setValue(who.lexFormat);
	}
}

ClientMethod setOptionSet(picks) [ Language = javascript ]
{
}

ClientMethod setTitle(title) [ Language = javascript ]
{
	var c = zenPage.getComponentById(this.id+'.titleBox');
	c.setProperty('value',title);
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this.disableAggregationGroup();
	this.disableSortOptionsGroup();
	
	var d = this.getChildById("ctrlFieldName");
	d.controller = this;
	d.setValue("");

	this.disableSortOptionsGroup();
	var d = this.getChildById("ctrlFieldSource");
	d.controller = this;
	d.setValue("");
	
	var d = this.getChildById("ctrlFieldBreak");
	d.controller = this;
	
	var d = this.getChildById("ctrlFieldSort");
	d.controller = this;
}

}
