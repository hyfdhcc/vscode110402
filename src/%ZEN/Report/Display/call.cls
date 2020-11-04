/// Include generated XSLT from another report in this report
Class %ZEN.Report.Display.call Extends (node, tableOutput) [ Inheritance = right, System = 4 ]
{

Property field As %ZEN.Datatype.string(XMLPROJECTION = "NONE");

Property group As %ZEN.Datatype.string(XMLPROJECTION = "NONE");

Property removeEmpty As %ZEN.Datatype.boolean(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

Property children As list Of node(XMLPROJECTION = "NONE");

/// Name of method that returns an XML stream to include
Property method As %ZEN.Datatype.string;

/// Name of subreport
/// As recorded in subreport property of calling method in report
/// For example:
/// Method getstreams(ByRef XSL As %GlobalCharacterStream, ByRef delay As %GlobalCharacterStream, mode As %Integer) As %Status
/// {
/// 	set rpt1=##class(ZENApp.MyReportCZ).%New()
/// 	set rpt1.Month=1
/// 	set rpt1.SubReport="MyReport"
///    set rpt1.MainReport="MAINReport"
/// 	set rpt1.StripPI=1
/// 	set Status=rpt1.CallReport(.XSL,.delay,"c:\temp\getstreams.xml",mode)
/// 	quit Status
/// }
Property subreport As %ZEN.Datatype.string;

/// This is the name of the subreport as in the following
/// <report xmlns="http://www.intersystems.com/zen/report/definition"
/// name='SUB1Report'
Property subreportname As %ZEN.Datatype.string;

Method %DrawToHTML(ByRef context As %String, ByRef XSL As %GlobalCharacterStream, delay As %GlobalCharacterStream, ByRef incell As %Boolean) As %Status
{
	d ..%BeginDrawHtml(.context,.XSL,.delay)	
	Set sc=$$$OK
	Set XSL2=$zobjmethod(%report,..method,3)
	Do XSL2.Rewind()
	;set chunksize=32000 while 'XSL2.AtEnd { s chunk=XSL2.Read(.chunksize) s ^foobar($i(^foobar),"XSL2")=chunk }
	;set chunksize=32000 while 'delay2.AtEnd { s chunk=delay2.Read(.chunksize) s ^foobar($i(^foobar),"delay2")=chunk }
	Do delay.CopyFrom(XSL2)
	;Do delay.CopyFrom(delay2)
	New %subreportname
	Set %subreportname=..subreportname
	if $e(%subreportname)="!" X "set %subreportname ="_$e(%subreportname,2,$L(%subreportname))
	New %subreport
	Set %subreport=..subreport
	if $e(%subreport)="!" X "set %subreport ="_$e(%subreport,2,$L(%subreport))
	d XSL.WriteLine("<xsl:apply-templates select='/"_context("Name")_$s(%subreportname'="":"/"_%subreportname,1:"")_"' mode='"_%subreport_"'/>")
	d ..%EndDrawHtml(.context,.XSL,.delay)	
	quit sc
}

Method %DrawToXSLFO(ByRef context As %String, ByRef XSL As %GlobalCharacterStream, delay As %GlobalCharacterStream, incell As %Boolean = 0) As %Status
{
	d ..%BeginDrawFo(.context,.XSL,.delay)
	Set sc=$$$OK
	Set XSL2=$zobjmethod(%report,..method,4)
	Do XSL2.Rewind()
	;Do XSL.CopyFrom(XSL2)
	Do delay.CopyFrom(XSL2)
	New %subreportname
	Set %subreportname=..subreportname
	if $e(%subreportname)="!" X "set %subreportname ="_$e(%subreportname,2,$L(%subreportname))
	New %subreport
	Set %subreport=..subreport
	if $e(%subreport)="!" X "set %subreport ="_$e(%subreport,2,$L(%subreport))
	d XSL.WriteLine("<xsl:apply-templates select='/"_context("Name")_$s(%subreportname'="":"/"_%subreportname,1:"")_"' mode='"_%subreport_"'/>")
	d ..%EndDrawFo(.context,.XSL,.delay)		
	quit sc
}

}
