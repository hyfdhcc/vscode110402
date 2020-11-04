/// 
Class %DeepSee.Report.UI.imageURLWizard Extends %ZEN.Component.component [ System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property urlNameTxt As %ZEN.Datatype.caption [ InitialExpression = "Image source" ];

Property urlSourceTxt As %ZEN.Datatype.caption [ InitialExpression = "URL:" ];

Property browseTxt As %ZEN.Datatype.caption [ InitialExpression = "Browse local files" ];

Property okayTxt As %ZEN.Datatype.caption [ InitialExpression = "Okay" ];

Property cancelTxt As %ZEN.Datatype.caption [ InitialExpression = "Cancel" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.imageURLWizard {
	position:relative;
	top:0px;
	left:0px;
	width:265px;
	height:121px;
	background:#e8e7e2;
}

.imageURLHeading{
	position:absolute;
	left:5px;
	color:#000077;
	font: 12px Arial;
}

.imageURLInput{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	top:25px;
	left:40px;
	width:215px;
}

.imageURLBrowse {
	position:absolute;
	color:#404040;
	font: 12px Arial;
	top:50px;
	left:40px;
	width:215px;
}
	
.imageURLOkay {
	position:absolute;
	width:75px;
	top:90px;
	right:5px;
}

.imageURLCancel{
	position:absolute;
	width:75px;
	top:90px;
	left:5px;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="imageURLWizard" >
		<div class="imageURLHeading" style="top:5px;width:100%;text-align:center;">#(..urlNameTxt)#</div>
		<div class="imageURLHeading" style="top:27px;">#(..urlSourceTxt)#</div>
		<input type="text" name="source" id="#(..%MakeId("source"))#" class="imageURLInput"></input>	
		<input type="button" value="#(..browseTxt)#" id="#(..%MakeId("browse"))#" class="imageURLBrowse" onclick="zenPage.getComponent(#(..index)#).handleBrowse();"></input>
		<input type="button" class="imageURLOkay" value="#(..okayTxt)#" onclick="zenPage.getComponent(#(..index)#).handleOkay();"></input>
		<input type="button" class="imageURLCancel" value="#(..cancelTxt)#" onclick="zenPage.getComponent(#(..index)#).handleCancel();"></input>
		</div>
	>
}

ClientMethod handleOkay() [ Language = javascript ]
{
	if (this.cbStr) eval(this.cbStr);
	this.closeDialog();
}

ClientMethod handleCancel() [ Language = javascript ]
{
	this.closeDialog();
}

ClientMethod handleBrowse() [ Language = javascript ]
{
	var CB = "zenPage.getComponent("+this.index+").setSourceFile(value);"
	zenPage.getUserImageURLSelection(CB);
}

ClientMethod closeDialog() [ Language = javascript ]
{
	if (this.parent.popAway) this.parent.popAway();
}

ClientMethod setSourceFile(fname) [ Language = javascript ]
{
	this.blankURL = "http://"+window.location.host+"/csp/broker/images/placeimagehere.png";
	if (!fname || fname=="") this.setSource(this.blankURL);
	else {
		var rName = fname.substring(fname.indexOf("CSP"));
		rName = rName.split('\\').join('/');
		var url = location.protocol+"//"+location.host+"/"+rName;
		this.setSource(url);
	}
}

ClientMethod setSource(sStr) [ Language = javascript ]
{
	var box = this.findElement("source");
	box.value = sStr;
	box.focus();
}

ClientMethod setOkayCB(cbStr) [ Language = javascript ]
{
	this.cbStr = cbStr;
}

ClientMethod getSource() [ Language = javascript ]
{
	var box = this.findElement("source");
	return(box.value);
}

}
