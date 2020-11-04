/// 
Class %DeepSee.Report.UI.barcodeWizard Extends %ZEN.Component.component [ System = 4 ]
{

Parameter INCLUDEFILES = "zenCSLM.js";

Property driverNameTxt As %ZEN.Datatype.caption [ InitialExpression = "Barcode Image" ];

Property driverFormatTxt As %ZEN.Datatype.caption [ InitialExpression = "Format" ];

Property driverSourceTxt As %ZEN.Datatype.caption [ InitialExpression = "Data source" ];

Property driverDynamicTxt As %ZEN.Datatype.caption [ InitialExpression = "Dynamic" ];

Property driverStaticTxt As %ZEN.Datatype.caption [ InitialExpression = "Static" ];

Property driverOptionsTxt As %ZEN.Datatype.caption [ InitialExpression = "Options" ];

Property driverModWidthTxt As %ZEN.Datatype.caption [ InitialExpression = "Module Width" ];

Property driverWideFactorTxt As %ZEN.Datatype.caption [ InitialExpression = "Wide Factor" ];

Property driverICGTxt As %ZEN.Datatype.caption [ InitialExpression = "Interchar Gap" ];

Property driverHumanReadableTxt As %ZEN.Datatype.caption [ InitialExpression = "Human Readable" ];

Property okayTxt As %ZEN.Datatype.caption [ InitialExpression = "Okay" ];

Property cancelTxt As %ZEN.Datatype.caption [ InitialExpression = "Cancel" ];

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.barcodeWizard {
	position:relative;
	top:0px;
	left:0px;
	width:280px;
	height:286px;
	background:#e8e7e2;
}

.barcodeHeading{
	position:absolute;
	left:5px;
	color:#000077;
	font: bold 12px Arial;
}

.barcodeRadio{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	left:35px;
}

.barcodeOption {
	position:absolute;
	color:#000077;
	font: 12px Arial;
	left:55px;
}

.barcodeInput{
	position:absolute;
	color:#404040;
	font: 12px Arial;
	left:110px;
	width:150px;
}
	
.barcodeSelect {
	position:absolute;
	font: 12px Arial;
	left:35px;
	width:225px;
}


.barcodeConstant{
	position:absolute;
	color:#000077;
	font: 12px Arial;
}

.barcodeOkay {
	position:absolute;
	width:75px;
	bottom:5px;
	right:5px;
}

.barcodeCancel{
	position:absolute;
	width:75px;
	bottom:5px;
	left:5px;
}

</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="barcodeWizard" >
		<div class="barcodeHeading" style="top:5px;width:100%;text-align:center;">#(..driverNameTxt)#</div>
		<!--<input type="text" id="#(..%MakeId("format"))#" class="barcodeInput"></input>-->

		<div class="barcodeHeading" style="top:25px;">#(..driverSourceTxt)#</div>

		<input type="radio" name="source" id="#(..%MakeId("source0"))#" style="top:40px;" class="barcodeRadio" value="0"></input>
		<div class="barcodeOption" style="top:42px;">#(..driverStaticTxt)#</div>
		<input type="text" id="#(..%MakeId("staticSrc"))#" style="top:40px;" class="barcodeInput"></input>
		
		<input type="radio" name="source" id="#(..%MakeId("source1"))#" style="top:63px;"class="barcodeRadio" style="top:40px;" value="1" ></input>
		<div class="barcodeOption" style="top:65px;">#(..driverDynamicTxt)#</div>
		<input type="text" id="#(..%MakeId("dynamicSrc"))#" style="top:63px;"class="barcodeInput"></input>
		
		<div class="barcodeHeading" style="top:86px;">#(..driverFormatTxt)#</div>
	
		<select class="barcodeSelect" id="#(..%MakeId("select"))#" style="top:101px;" value="code39" >
			<option value="code39">Code-39</option>
			<option value="code128">Code-128</option>
	<!--
			<option value="codabar">CodaBar</option>
			<option value="datamatrix">Data Matrix</option>
			<option value="ean-128">EAN-128</option>
			<option value="ean-13">EAN-13</option>
			<option value="ean-8">EAN-8</option>
			<option value="init2of5">Init 2 of 5</option>
			<option value="itf-14">ITF-14</option>
			<option value="pdf417">PDF-417</option>
			<option value="postnet">Post Net</option>
			<option value="royal-mail-cbc">Royal Mail CBC</option>
			<option value="upc-a">UPC-A</option>
			<option value="upc-b">UPC-B</option>
			<option value="usps4cb">USPS 4CB</option>
	-->
		</select>		
		
		<div class="barcodeHeading" style="top:124px;">#(..driverOptionsTxt)#</div>
		
		<div class="barcodeOption" style="top:141px;left:15px;">#(..driverModWidthTxt)#</div>
		<input type="text" id="#(..%MakeId("MWBox"))#" style="top:139px;" class="barcodeInput"></input>
		
		<div class="barcodeOption" style="top:164px;left:15px;">#(..driverWideFactorTxt)#</div>
		<input type="text" id="#(..%MakeId("WFBox"))#" style="top:162px;" class="barcodeInput"></input>
		
		<div class="barcodeOption" style="top:187px;left:15px;">#(..driverICGTxt)#</div>
		<input type="text" id="#(..%MakeId("IGCBox"))#" style="top:185px;" class="barcodeInput"></input>
		
		<div class="barcodeOption" style="top:210px;left:15px;">#(..driverHumanReadableTxt)#</div>
		<select class="barcodeSelect" id="#(..%MakeId("HRBox"))#" style="top:224px;" value="default" >
			<option value="default">Default</option>
    		<option value="none">None</option>
		</select>
		
		<input type="button" class="barcodeOkay" value="#(..okayTxt)#" onclick="zenPage.getComponent(#(..index)#).handleOkay();"></input>
		<input type="button" class="barcodeCancel" value="#(..cancelTxt)#" onclick="zenPage.getComponent(#(..index)#).handleCancel();"></input>
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

ClientMethod setValueObj(jsObj) [ Language = javascript ]
{
	if (jsObj.dSrc) {
		var b = this.findElement("source1");
		b.checked = true;
		var b = this.findElement("dynamicSrc");
		b.value = jsObj.dSrc;
		var b = this.findElement("staticSrc");
		b.value = "";
	}
	else {
		var b = this.findElement("source0");
		b.checked = true;
		var b = this.findElement("dynamicSrc");
		b.value = "";
		var b = this.findElement("staticSrc");
		b.value = jsObj.value;
	}		
	var c = this.findElement("select");
	c.value = jsObj.encoding;
	
	var b = this.findElement("MWBox");
	b.value = jsObj.modWidth;

	var b = this.findElement("WFBox");
	b.value = jsObj.wideFactor;

	var b = this.findElement("IGCBox");
	b.value = jsObj.icg;

	var b = this.findElement("HRBox");
	b.value = jsObj.humanReadable;
}

ClientMethod setOkayCB(cbStr) [ Language = javascript ]
{
	this.cbStr = cbStr;
}

ClientMethod getValueObj() [ Language = javascript ]
{
	var o={}
	var c = this.findElement("source0");
	if (c.checked) {
		var b = this.findElement("staticSrc");
		o.value = b.value;
		if (!o.value || o.value=="") o.value = "BARCODE";
		o.dSrc = null;
	}
	else {
		var b = this.findElement("dynamicSrc");
		o.value = b.value;
		if (!o.value || o.value=="") {
			o.value = "BARCODE";
			o.dSrc = null;
		}
		else {
			o.dSrc = b.value;
		}
	}

	var c = this.findElement("select");
	o.encoding = c.value;
	var b = this.findElement("MWBox");
	var v = parseFloat(b.value);
	if (!v || v<0.19) v = 0.19;
	o.modWidth = v;

	var b = this.findElement("WFBox");
	var v = parseFloat(b.value);
	if (!v || v<2 ) v = 2.0;
	if (v>3) v=3.0;
	if (o.modWidth<0.5 && v>2.2) v=2.2;
	o.wideFactor = v;

	var b = this.findElement("IGCBox");
	var v = parseFloat(b.value);
	if (!v || v<1 ) v = 1.0;
	if (v>5.6) v=5.6;
	o.icg = v;
	
	var b = this.findElement("HRBox");
	o.humanReadable =b.value;

	return(o);
}

}
