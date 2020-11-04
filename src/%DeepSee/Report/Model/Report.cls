/// This class is used by the DeepSee Report Generator.<br/>
/// It contains the report-level information about the report to be
/// generated.
Class %DeepSee.Report.Model.Report Extends %DeepSee.Report.Model.Node [ System = 4 ]
{

Parameter XMLNAME = "model";

Property xpath As %String(MAXLEN = "", XMLPROJECTION = "none");

/// document element
Property document As Document(XMLPROJECTION = "element");

/// page header element
Property pageHeader As PageHeader(XMLNAME = "pageheader", XMLPROJECTION = "element");

/// page footer element
Property pageFooter As PageFooter(XMLNAME = "pagefooter", XMLPROJECTION = "element");

/// Optional description for this report.
Property description As %String(MAXLEN = 5000, XMLPROJECTION = "attribute");

/// Name of the dataSource (class) that supplies data for this report.
Property dataSource As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// Set of groups within this report.
Property groups As list Of Group(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

/// Set of data fields defined for this report.
Property dataFields As list Of DataField(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

ClassMethod ImportFile(filename As %String) As Report
{
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenFile(filename)
	Do reader.Correlate("model","%DeepSee.Report.Model.Report")
	while (reader.Next(.report,.status)) {
		Write "report name="_report.name
		quit  ; only one report
	}
	If $system.Status.IsError(status) do $System.Status.DisplayError(status)
	quit report
}

/// Return the SQL table that supplies data for this report.
Method %GetSQLTableName(Output pTable As %String) As %Status
{
	Set tSC = $$$OK
	Set pTable=$$TableName^%occLGUtil(..dataSource)
	Quit tSC
}

/// Given a field name, return the SQL expression needed to fetch it.
Method %GetSQLForField(pField As %String, Output pExpr As %String) As %Status
{
	Set tSC = $$$OK
	Set pExpr = pField
	Quit tSC
}

}
