Include (%occSAX, %occXSLT)

Class %ZEN.Report.Display.COSChart.test Extends (%ZEN.Report.Display.childrenNode, %ZEN.Report.Display.tableOutput) [ Inheritance = right, System = 4 ]
{

/// Width of the chart within the report.
Property width As %ZEN.Datatype.length [ InitialExpression = "10in" ];

/// Height of the chart within the report.
Property height As %ZEN.Datatype.length [ InitialExpression = "8in" ];

Method %DrawToXSLFO(ByRef context As %String, XSL As %GlobalCharacterStream, delay As %GlobalCharacterStream, ByRef incell As %Boolean, ByRef xmlfile As %String) As %Status
{
	Set tSC=$$$OK
	s ^foobar($i(^foobar))="in chart test xmlfile='"_$g(xmlfile)_"'"
	Do XSL.WriteLine("<fo:block><fo:instream-foreign-object><svg:svg x='0' y='0'>")
	Do:..width'="" XSL.WriteLine("<xsl:attribute name='width'>"_..width_"</xsl:attribute>")
	Do:..height'="" XSL.WriteLine("<xsl:attribute name='height'>"_..height_"</xsl:attribute>")
	Set chartid=100
	Do XSL.WriteLine("<svg:svg id='"_chartid_"'>")
	Do:..width'="" XSL.WriteLine("<xsl:attribute name='width'>"_..width_"</xsl:attribute>")
	Do:..height'="" XSL.WriteLine("<xsl:attribute name='height'>"_..height_"</xsl:attribute>")
	Do XSL.WriteLine("  <xsl:attribute name='viewBox'>0 0 "_100_" "_100_"</xsl:attribute>")
	Do XSL.WriteLine("  <xsl:attribute name='preserveAspectRatio'>"_"none"_"</xsl:attribute>")
	
	do {

	#if 0
		Set file=##class(%FileCharacterStream).%New()
		Set file.Filename=xmlfile
		Set len=32000
		Set input=file.Read(.len,.tSC)
		Set input=$ZCVT(input,"O","XML")
		s ^foobar($i(^foobar))="input="_input
		Do XSL.WriteLine("<svg:text x='1' y='50'>")
		Do XSL.Write(input)
		Do XSL.WriteLine("</svg:text>")
	#endif
		Set tSC=##class(%XML.XPATH.Document).CreateFromFile(xmlfile,.tDoc)
		if $$$ISERR(tSC) quit
		Set tSC=tDoc.EvaluateExpression("/test","Person",.tResults)
		Set ^foobar($i(^foobar))="tSC="_tSC
		if $$$ISERR(tSC) quit
		Set y=1
		Set ^foobar($i(^foobar))="Count="_tResults.Count()
		For tI=1:1:tResults.Count()
		{
			Set tResult=tResults.GetAt(tI)
		
			if (tResult.Type=$$$XPATHDOM)
			{
				
			
				While tResult.Read() {
					do tResult.MoveToAttributeName("Age")
					Do XSL.WriteLine("<svg:text x='1' y='"_y_"' font-size='1'>")
					Set y=y+1
					Set input=tResult.Value
					s ^foobar($i(^foobar))="input="_input
					Do XSL.Write(input)
					Do XSL.WriteLine("</svg:text>")

				}
			
			}
		}
	} while (0) ;
	Do XSL.WriteLine("</svg:svg>")
	Do XSL.WriteLine("</svg:svg></fo:instream-foreign-object></fo:block>")
	
	quit tSC
}

Storage Default
{
<Data name="testDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^%ZEN.Report.Display.C2E79.testD</DataLocation>
<DefaultData>testDefaultData</DefaultData>
<IdLocation>^%ZEN.Report.Display.C2E79.testD</IdLocation>
<IndexLocation>^%ZEN.Report.Display.C2E79.testI</IndexLocation>
<StreamLocation>^%ZEN.Report.Display.C2E79.testS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
