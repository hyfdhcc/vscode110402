/// 
Class %DeepSee.Report.UI.pageNumberWizard Extends %ZEN.Component.component [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property driverNameTxt As %ZEN.Datatype.caption [ InitialExpression = "Dynamic Page Number" ];

Property driverFormatTxt As %ZEN.Datatype.caption [ InitialExpression = "Format" ];

Property okayTxt As %ZEN.Datatype.caption [ InitialExpression = "Okay" ];

Property cancelTxt As %ZEN.Datatype.caption [ InitialExpression = "Cancel" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.pageNumberWizard {
	position:relative;
	top:0px;
	left:0px;
	width:165px;
	height:121px;
	background:#e8e7e2;
}

.pageNumberHeading{
	position:absolute;
	left:5px;
	color:#000077;
	font: 12px Arial;
}

.pageNumberConstant{
	position:absolute;
	color:#000077;
	font: 12px Arial;
}

.pageNumberInput{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	top:25px;
	left:55px;
}

.pageNumberOption {
	position:absolute;
	color:#000077;
	font: 12px Arial;
	top:25px;
	left:75px;
}
	
.pageNumberOkay {
	position:absolute;
	width:75px;
	top:90px;
	right:5px;
}

.pageNumberCancel{
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
		<div id="#(..%MakeId("base"))#" class="pageNumberWizard" >
		<div class="pageNumberHeading" style="top:5px;width:100%;text-align:center;">#(..driverNameTxt)#</div>
		<div class="pageNumberHeading" style="top:27px;">#(..driverFormatTxt)#</div>
		<!--<input type="text" id="#(..%MakeId("format"))#" class="pageNumberInput"></input>-->
		<input type="radio" name="format" id="#(..%MakeId("format0"))#" class="pageNumberInput" value="#"></input>
		<div class="pageNumberOption">(#)</div>
		
		<input type="radio" name="format" id="#(..%MakeId("format1"))#" class="pageNumberInput" style="top:40px;" value="#/##" ></input>
		<div class="pageNumberOption" style="top:40px;">(# / ##)</div>
		
		<input type="radio" name="format" id="#(..%MakeId("format2"))#" class="pageNumberInput" style="top:55px;" value="# of ##"></input>
		<div class="pageNumberOption" style="top:55px;">(# of ##)</div>
		
		<input type="radio" name="format" id="#(..%MakeId("format3"))#" class="pageNumberInput" style="top:70px;" value="count"></input>
		<div class="pageNumberOption" style="top:70px;">($pageCount)</div>
		
		
		
		<input type="button" class="pageNumberOkay" value="#(..okayTxt)#" onclick="zenPage.getComponent(#(..index)#).handleOkay();"></input>
		<input type="button" class="pageNumberCancel" value="#(..cancelTxt)#" onclick="zenPage.getComponent(#(..index)#).handleCancel();"></input>
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

ClientMethod setFormat(fStr) [ Language = javascript ]
{
	for (var i=0;i<4;i++) {
		var box = this.findElement("format"+i);
		if (box.value == fStr) {
			box.checked = true;
			box.focus();
		}
		else box.checked = false;
	}
}

ClientMethod setOkayCB(cbStr) [ Language = javascript ]
{
	this.cbStr = cbStr;
}

ClientMethod getFormat() [ Language = javascript ]
{
	for (var i=0;i<4;i++) {
		var box = this.findElement("format"+i);
		if (box.checked) return(box.value);
	}
	return('#');
}

}
