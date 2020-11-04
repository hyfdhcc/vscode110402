/// 
Class %ZEN.Report.Display.xslt Extends (%ZEN.Report.Display.node, %ZEN.Report.Display.tableOutput) [ System = 4 ]
{

Property group As %ZEN.Datatype.string(XMLPROJECTION = "none");

Property removeEmpty As %ZEN.Datatype.boolean(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

Property children As list Of node(XMLPROJECTION = "NONE");

Property field As %ZEN.Datatype.string(XMLPROJECTION = "NONE");

Property vars As %ZEN.Datatype.list(DELIMITER = ";");

// a Cache' expression begins with ! (bang)

Property expressions As %ZEN.Datatype.list(DELIMITER = ";");

Property all As %ZEN.Datatype.string;

Property html As %ZEN.Datatype.string;

Property xslfo As %ZEN.Datatype.string;

// HTML and XSL-FO rendering routines - which just dump XDATA

Method %DrawToHTML(ByRef context As %String, ByRef XSL As %GlobalCharacterStream, delay As %GlobalCharacterStream, ByRef incell As %Boolean) As %Status
{
	d ..%BeginDrawHtml(.context,.XSL,.delay)
	d ..%SetVars(.XSL)
	d ##class(%ZEN.Report.Display.report).%CopyXsltXdata(.XSL,..all,..html)
	d ..%EndDrawHtml(.context,.XSL,.delay)		
	Quit $$$OK
}

Method %DrawToXSLFO(ByRef context As %String, ByRef XSL As %GlobalCharacterStream, delay As %GlobalCharacterStream, ByRef incell As %Boolean) As %Status
{
	d ..%BeginDrawFo(.context,.XSL,.delay)
	d ..%SetVars(.XSL)
	d ##class(%ZEN.Report.Display.report).%CopyXsltXdata(.XSL,..all,..xslfo)
	d ..%EndDrawFo(.context,.XSL,.delay)		
	Quit $$$OK
}

Method %SetVars(ByRef XSL As %GlobalCharacterStream) [ Internal ]
{
    for i=1:1:$L(..vars,";") {
	    Set %value=$P(..expressions,";",i)
	    if $e(%value)="!" {
		    ; string off bang, execute and put value in %value
		    X "Set %value="_$e(%value,2,$L(%value))
	    }
	    Set var=$P(..vars,";",i)
    	if %value'="",var'="" Do XSL.WriteLine("<xsl:variable name='"_var_"' select='"""_%value_"""'/>")
    }
}

}
