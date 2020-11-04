/// 
Class %DeepSee.Report.UI.textInfoWizard Extends %ZEN.Component.component [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property driverNameTxt As %ZEN.Datatype.caption [ InitialExpression = "Source" ];

Property driverFormatTxt As %ZEN.Datatype.caption [ InitialExpression = "Format" ];

Property okayTxt As %ZEN.Datatype.caption [ InitialExpression = "Okay" ];

Property cancelTxt As %ZEN.Datatype.caption [ InitialExpression = "Cancel" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.textInfoWizard {
	position:relative;
	top:0px;
	left:0px;
	width:165px;
	height:81px;
	background:#e8e7e2;
}

.textInfoHeading{
	position:absolute;
	left:5px;
	color:#000077;
	font: 12px Arial;
}

.textInfoConstant{
	position:absolute;
	color:#000077;
	font: 12px Arial;
}

.textInfoInput{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	width:100px;
	top:25px;
	right:5px;
}

.textInfoOkay {
	position:absolute;
	width:75px;
	top:50px;
	right:5px;
}

.textInfoCancel{
	position:absolute;
	width:75px;
	top:50px;
	left:5px;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="textInfoWizard" >
		<div class="textInfoHeading" style="top:5px;">#(..driverNameTxt)#</div>
		<div id="#(..%MakeId("source"))#" class="textInfoConstant" style="top:5px;left:60px;"></div>
		<div class="textInfoHeading" style="top:27px;">#(..driverFormatTxt)#</div>
		<input type="text" id="#(..%MakeId("format"))#" class="textInfoInput"></input>
		<input type="button" class="textInfoOkay" value="#(..okayTxt)#" onclick="zenPage.getComponent(#(..index)#).handleOkay();"></input>
		<input type="button" class="textInfoCancel" value="#(..cancelTxt)#" onclick="zenPage.getComponent(#(..index)#).handleCancel();"></input>
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

ClientMethod closeDialog() [ Language = javascript ]
{
	if (this.parent.popAway) this.parent.popAway();
}

ClientMethod setSource(fName) [ Language = javascript ]
{
	var src = this.findElement("source");
	src.innerHTML = fName;
}

ClientMethod setFormat(fStr) [ Language = javascript ]
{
	var box = this.findElement("format");
	box.value = fStr;
	box.focus();
}

ClientMethod setOkayCB(cbStr) [ Language = javascript ]
{
	this.cbStr = cbStr;
}

ClientMethod getFormat() [ Language = javascript ]
{
	var box = this.findElement("format");
	return(box.value);
}

}
