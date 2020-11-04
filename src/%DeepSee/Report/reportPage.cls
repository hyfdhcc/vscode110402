/// Base class for all reports created by the DeepSee Report Builder.
Class %DeepSee.Report.reportPage Extends %ZEN.Report.reportPage [ System = 4 ]
{

/// This projection is used to keep track of when reports are compiled or deleted.
Projection ReportProjection As %DeepSee.Report.ReportProjection [ Internal ];

/// This is used as a flag inside presentation type reports,  the value is either
/// 'local' or 'linked'.  If 'local' the required DSS information can be found in
/// the reportDSS section of this document.  If 'linked', the required DSS information
/// is to be extracted from the class named in DSSCLASS
Parameter DSSHOME = "linked";

/// This is the name of a DeepSee Report page whose reportDSS section will be used 
/// as the data schema for the current report
Parameter DSSCLASS;

Property reportDSSHome As %ZEN.Datatype.string [ InitialExpression = {..#DSSHOME} ];

Property reportDSSClass As %ZEN.Datatype.string [ InitialExpression = {..#DSSCLASS} ];

XData ReportDCR
{
<reportDCR>
	</reportDCR>
}

XData ReportDSS
{
<reportDSS>
	</reportDSS>
}

/// Report Model information supplied from Report Builder.
XData ReportModel
{
<reportModel>
	</reportModel>
}

/// Return the logical name of this report.
ClassMethod %GetReportName() As %String
{
	Quit ..#REPORTNAME
}

Method GetDSSHome() As %ZEN.Datatype.string [ ZenMethod ]
{
	Quit ..#DSSHOME
}

Method GetDSSClass() As %ZEN.Datatype.string [ ZenMethod ]
{
	Quit ..#DSSCLASS
}

Method GetReportDCR() As %String
{
	Quit ..%GetXDataTextSection($CLASSNAME()_"||ReportDCR")
}

Method GetReportDSS() As %String
{
	Quit ..%GetXDataTextSection($CLASSNAME()_"||ReportDSS")
}

Method GetReportModel() As %String
{
	Quit ..%GetXDataTextSection($CLASSNAME()_"||ReportModel")
}

ClassMethod %GetXDataTextSection(xdataID As %String) As %Status
{
   
   // Get a stream of XML from the XData block contained in this class
   Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xdataID)
   Set tStream=compiledXdata.Data
   If '$IsObject(tStream) Set tSC=%objlasterror Quit
   
   set status=##class(%XML.TextReader).ParseStream(tStream,.textreader)
   //check status
   if $$$ISERR(status) do $System.Status.DisplayError(status) quit
   
   Set m = ""
   
   //iterate through document, node by node
   while textreader.Read()
   {
       if (textreader.NodeType="chars")
       {
           Set m = m_textreader.Value
       }
   }
   Quit m
}

}
