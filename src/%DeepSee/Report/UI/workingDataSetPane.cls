/// Spinner control
Class %DeepSee.Report.UI.workingDataSetPane Extends %ZEN.Component.composite [ DependsOn = %DeepSee.Report.UI.dataPickPool, LegacyInstanceContext, System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.workingDataSetPanel {
	background: #e8e7e2;
	width: 225px;
	overflow: hidden;
	border-bottom: 1px solid gray;
}
</style>
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<composite layout="none" enclosingClass="workingDataSetPanel" >
	<html id="workingDataSetHeader" OnDrawContent="DrawWorkingDataSetHeader"/>
	<dataPickPool id="workingDataSet" />
</composite>
}

/// Draw the contents of the WorkingDataSet Header.
Method DrawWorkingDataSetHeader(pSeed As %String) As %Status
{
	Set hlpAutoFill = "Generate a first draft report based on this data set"
	Set hlpSetSrc = "Set the data source for the report"
	Set setSrcCB = "zenPage.getComponentById('"_$this.id_"').getDataSource();"
	Set autoFillCB = "zenPage.autoFillData();"
	Set msgSetSrc = "Set source"
	Set msgAutoFill = "Auto-fill"
	Set captionFields = "Fields"
	
	&html<
	<div class="headerDiv">#(captionFields)#
	&nbsp;<a id="setSrcTag" class="hdrLink" href="#" title="#(hlpSetSrc)#" onclick="#(setSrcCB)#">#(msgSetSrc)#</a>
	&nbsp;<a id="autoFillTag" class="hdrLink" href="#" title="#(hlpAutoFill)#" onclick="#(autoFillCB)#">#(msgAutoFill)#</a>
	</div>
	>
	Quit $$$OK
}

ClientMethod fixDataSource() [ Language = javascript ]
{
	var div = document.getElementById("setSrcTag");
	if (div) div.style.display="none";
	this.enableAutoFillOption();
}

/// Invoke dialog to open a report.
ClientMethod getDataSource() [ Language = javascript ]
{
	var parms = {
		SUPER:'%DeepSee.Report.abstractDSS'
	};
	zenLaunchPopupWindow('_DeepSee.UI.Dialog.finderDialog.cls','DataSource','status,scrollbars,resizable=yes,width=800,height=600',parms);
}

ClientMethod adjustHeight(maxH) [ Language = javascript ]
{
	var hdr = document.getElementById("setSrcTag").parentNode;
	var h = hdr.offsetHeight;
	var wds = zen(this.id+".workingDataSet");
	wds.getEnclosingDiv().style.height=(maxH-h)+"px";
}

ClientMethod reset() [ Language = javascript ]
{
	var div = document.getElementById("autoFillTag");
	if (div) div.style.display="none";
	var div = document.getElementById("setSrcTag");
	if (div) div.style.display="";
	var wds = zen(this.id+".workingDataSet");
	wds.clear();
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	var div = document.getElementById("autoFillTag");
	if (div) div.style.display="none";
	zenPage._workingDataSetPane = this;
}

ClientMethod enableAutoFillOption() [ Language = javascript ]
{
	var div = document.getElementById("autoFillTag");
	if (div) div.style.display="";
}

}
