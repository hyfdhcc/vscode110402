/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>Simple HTML-based meter that displays a value as a bar.
Class %CSP.Util.HTMLBarMeter Extends %CSP.Util.HTMLMeter [ ServerOnly = 1, System = 4 ]
{

/// Draw the style section of this HTML meter
ClassMethod OnHTMLStyle()
{
	&html<

.Bar 	{ border-top: 1px black solid; }

.BarOn 	{ background: blue; 
			border-left: 1px darkblue solid;
			color: white; 
			font-family: courier; 
			font-size: 0.8em; }

.BarOnWARNING 	{ background: orange; 
			border-left: 1px darkblue solid; 
			color: white; 
			font-family: courier; 
			font-size: 0.8em; }

.BarOnERROR 	{ background: red; 
			border-left: 1px darkblue solid; 
			color: white; 
			font-family: courier; 
			font-size: 0.8em; }

.BarOff { background: silver; 
			border-left: 1px lightblue solid; 
			color: white; 
			font-family: courier; 
			font-size: 0.8em; }

table.BarMeterLabel {
	background: lightgreen;
	font-weight: normal;
	text-decoration: none;
	padding: 2px;
}

	>
}

/// Draw the script section of this HTML meter
ClassMethod OnHTMLScript()
{
	Write "function gteq(a,b) { return a>=b; }",!
	Write "function lteq(a,b) { return a<=b; }",!
	
	&js<
function HTMLBarMeter_setProperty(prop, value, status)
{
	if ('level' == prop) {
		var barOn = self.document.getElementById("BarOn_" + this.id);
		var barOff = self.document.getElementById("BarOff_" + this.id);
		
		// normalize and round
		value = Math.floor(Math.round(value * 100) / 100);

		if (lteq(value,0)) {
			// below 0
			barOn.style.display = "none";
			barOff.style.display = "";
			barOff.width = "100%";
			barOff.innerHTML = value + "%";
		}
		else if (gteq(value,100)) {
			// above 100
			barOn.width = "100%";
			barOn.style.display = "";
			barOff.style.display = "none";
			barOn.innerHTML = value + "%";
		}
		else {
			// within normal range
			if (lteq((value.toString().length + 1) * 5,value)) {
				// too big to fit: use on bar to show value
				barOn.innerHTML = value + "%";
				barOff.innerHTML = "&nbsp;";
			}
			else {
				// show value in off bar
				barOn.innerHTML = "&nbsp;";
				barOff.innerHTML = value + "%";
			}
			
			barOn.style.display = "";
			barOff.style.display = "";
			barOn.width = (value + "%");
			barOff.width = ((100-value) + "%");
		}

		barOn.className = 'barOn' + status;

		var style =	'HTMLMeterStatus' + status;
		var tbl = self.document.getElementById("meter_" + this.id);
		if (tbl) {
			tbl.className = style;
		}	

		setMeterStatus(this.id, status);
	}
	return true;
}	
	>
}

/// Draw the body of this HTML meter
Method OnHTMLBody()
{
	Set tTitle = $$$Text("Click to show details for this item.")
	Set tLabel = ..Label _ $S(..Label'="":":",1:"")
	Set:tLabel="" tLabel="&nbsp;" 
	Set tValue = +..InitialValue
	Set:tValue>100 tValue=100
	Set:tValue<0 tValue=0

	&html<
	<table class="HTMLMeterStatus#(..InitialStatus)#" cellspacing="0" cellpadding="0" border="0" 
				id="meter_#(..MeterId)#"
				style="border-top: 1px solid black; padding: 2px;"
				onclick="selectMeter(#(..MeterId)#);"
				width="#(..Width)#">
	<tr align="left">>
	Do ..DrawSelector()
	&html<<td align="left" nowrap class="HTMLMeterLabel" id="label_#(..MeterId)#" ><a href="javascript:selectMeter(#(..MeterId)#);">#($ZCVT(tLabel,"O","HTML"))#</a></td>
	</tr></table>
	>

	&html<
<table class="Bar" cellspacing="0" cellpadding="0" border="0" width="#(..Width)#" >
<tr>
<td id="BarOn_#(..MeterId)#" class="BarOn#(..InitialStatus)#" width="#(tValue)#%" align="center">#(tValue)#%</td>
<td id="BarOff_#(..MeterId)#" class="BarOff" width="#(100-tValue)#%">&nbsp;</td>
</tr>
</table>
	>
}

}
