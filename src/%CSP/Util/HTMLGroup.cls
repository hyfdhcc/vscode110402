/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
Class %CSP.Util.HTMLGroup Extends %CSP.Util.HTMLMeter [ ServerOnly = 1, System = 4 ]
{

/// Meters belonging to this group
Property Meters As list Of HTMLMeter(XMLNAME = "Meters", XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

/// Direction in which to layout meters within this group.
Property Orientation As %String(MAXLEN = 10, VALUELIST = ",horizontal,vertical", XMLPROJECTION = "attribute") [ InitialExpression = "horizontal" ];

/// Style to use for Group
Property Style As %String(MAXLEN = 200, XMLPROJECTION = "attribute");

/// Insert a meter into this group
Method InsertMeter(pMeter As HTMLMeter)
{
	Do ..Meters.Insert(pMeter)
	Set pMeter.Parent = $this
}

/// Draw the style section of this HTML meter
ClassMethod OnHTMLStyle()
{
	&html<
table.HTMLGroup {
}

.HTMLGroupLabel {
	background: #404040;
	background-image: url(images/grad-gray-10x100.png);
	background-repeat: repeat-x;

	color: #404040;
	font-size: 10pt;
	font-weight: bold;
	padding: 2px;
	text-align: left;
	padding-left: 20px;
	font-variant: small-caps;
}
	>
}

Method OnHTMLBody()
{
	&html<<table class="HTMLGroup" style="#(..Style)#" border="0" cellspacing="0" cellpadding="0" width="#(..Width)#">>
	If (..Orientation = "horizontal") {
		&html<<tr valign="top">>
		If (..Label '= "") {
			&html<<td class="HTMLGroupLabel" nowrap>#($ZCVT(..Label,"O","HTML"))#</td>>
		}
				
		// Draw meter horizontally
		For i = 1:1:..Meters.Count() {
			Set tMeter = ..Meters.GetAt(i)
			&html<<td width="#(tMeter.Width)#">>
			Do tMeter.OnHTMLBody()
			&html<</td>>
		}
		&html<</tr>>
	}
	Else {
		If (..Label '= "") {
			&html<<tr><td width="100%" nowrap class="HTMLGroupLabel">#($ZCVT(..Label,"O","HTML"))#</td></tr>>
		}
		// Draw meters vertically
		For i = 1:1:..Meters.Count() {
			Set tMeter = ..Meters.GetAt(i)
			&html<<tr><td width="100%" style="font-size: 12px;">>
			Do tMeter.OnHTMLBody()
			&html<</td></tr>>
		}
	}

	&html<</table>>
}

Method GenerateCode(pCode As %CharacterStream, pLevel As %Integer = 1) As %Status
{
	Set %code = pCode

	Set tVar = "tGroup" _ pLevel
	Do %code.WriteLine(" Set "_tVar_" = tMeter")
	Do:(..Label'="") pCode.WriteLine(" Set "_tVar_".Label=$$$Text(""" _ ..Label _ """)")
	Do:(..Property'="") pCode.WriteLine(" Set "_tVar_".Property=""" _ ..Property _ """")
	Do:(..Orientation'="") pCode.WriteLine(" Set "_tVar_".Orientation=""" _ ..Orientation _ """")
	Do:(..Width'="") pCode.WriteLine(" Set "_tVar_".Width=" _ ..Width)
	Do:(..Height'="") pCode.WriteLine(" Set "_tVar_".Height=" _ ..Height)
	Do:(..Style'="") pCode.WriteLine(" Set "_tVar_".Style=""" _ ..Style _ """")

	#; Generate code for each Meter within this group
	For i=1:1:..Meters.Count() {
		Set tMeter = ..Meters.GetAt(i)
		Do %code.WriteLine(" // " _ tMeter.%ClassName(1))
		Do %code.WriteLine(" Set tMeter = ##class(" _ tMeter.%ClassName(1) _ ").%New()")
		Do %code.WriteLine(" Do "_tVar_".InsertMeter(tMeter)")
		Do %code.WriteLine(" Set tMeter.Dashboard = "_tVar_".Dashboard")
		
		// default value of label		
		If (tMeter.Label = "") {
			Set tMeter.Label = tMeter.Property
		}

		Set tSC = tMeter.GenerateCode(%code, pLevel + 1)
		If $$$ISERR(tSC) Quit
	}

	Quit $$$OK
}

}
