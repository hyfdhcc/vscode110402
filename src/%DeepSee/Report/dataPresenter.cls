/// Base class for all data presentation reports created by the 
/// DeepSee Report Builder.
Class %DeepSee.Report.dataPresenter Extends %DeepSee.Report.reportPage [ LegacyInstanceContext, System = 4 ]
{

/// Internal property used to hold metadata about the dataset.
Property TmpAxisLabels [ Internal, MultiDimensional ];

/// Internal property used to compensate for the lack of a MinValueDisplacment option
Property TmpMinValue [ Internal ];

/// This method creates a binary stream that contains source data 
/// when the source is a file or URL.
/// %zenStream is the stream containing the data.
/// If %zenStream="", then %zenStreamError is the error message for missing stream.
/// %response.CharSet is set according to the ?xml directive in the stream.
ClassMethod CreateOutputStream(source As %String, norecurse As %Boolean = 0) As %Status [ Internal ]
{
	If (source="") {
		Set %zenStream=""
		Set %zenStreamError="data source is undefined."
		quit $$$ERROR($$$GeneralError,%zenStreamError)
	}
	If $case($p(source,":"),"http":1,"https":1,:0) {
		Set HttpResponse=..%GetFileByAbsoluteURL(source,.sc)
		if $$$ISERR(sc) {
			d DecomposeStatus^%apiOBJ(sc,.Err) 
			Set %zenStreamError="%GetFileByAbsoluteURL("_source_") returns error:"_Err
			Quit sc
		}

		If $IsObject(HttpResponse) {
			Set %zenStream=HttpResponse.Data
	
			If '$D(%zenStream) {
				Set %zenStream=""
				Set %zenStreamError="%zenStream is undefined returning from ..%GetFileByAbsoluteURL("_source_")."
				quit $$$ERROR($$$GeneralError,%zenStreamError)
			}

		}
		Else {
			Set %zenStream=""
			Set %zenStreamError="Could not find absolute URL"
			Quit $$$ERROR($$$GeneralError,%zenStreamError)
		}
	}
	Else {
		Set %zenStream=..%GetFileByRelativeURL(source,.sc)
		if $$$ISERR(sc) {
			d DecomposeStatus^%apiOBJ(sc,.Err) 
			Set %zenStreamError="%GetFileByAbsoluteURL("_source_") returns error:"_Err
			Quit sc
		}
		
		//If '$D(%zenStream) {
			If ($F(source, ##class(%SYS.System).TempDirectory())=0) {
				Set %zenStream=""
				Set %zenStreamError="Access forbidden at "_source_"."
				Quit $$$ERROR($$$GeneralError,%zenStreamError)
			}
			Set %zenStream=##class(%FileBinaryStream).%New()
			Set %zenStream.Filename=source
			If '$D(%zenStream) {
				Set %zenStream=""
				Set %zenStreamError="%zenStream is undefined returning from ..%GetFileByRelativeURL("_source_")."
				Quit $$$ERROR($$$GeneralError,%zenStreamError)
			}
		//}

		If ('$IsObject(%zenStream) || '%zenStream.Size) {
			Set %zenStream=""
			Set %zenStreamError="Could not find/open file='"_source_"'"
			Quit $$$ERROR($$$GeneralError,%zenStreamError)
		}
	}

	Set first=$zstrip(%zenStream.Read(200),"*W")
	Do %zenStream.Rewind()
	If ($extract(first,1,5)="<?xml") {
		Set second=$piece($piece(first,">"),"encoding=",2)
		Set quote=$extract(second)
		Set charset=$piece($piece(second,quote,2),quote)
		If charset="" Set charset="UTF-8"
	}
	Else {
		Set charset="UTF-8"
	}
	
 	If $IsObject($get(%response)) {
	 	Set %response.CharSet=charset
 	}
	Quit $$$OK
}

Method GenerateReport(outputfile As %String, mode As %Integer = 0, log As %Boolean = 0, renderServer As %String = "", ExcelMode As %String = "", pStr As %String = "") As %Status
{
	New %context,%report
	If (..Datasource="") {
		Set rptMgr=##class(%DeepSee.Report.UI.reportPreviewer).%New()
		Quit rptMgr.GeneratePresentationReport(..%ClassName(1),pStr,outputfile,$this,log,renderServer)
	}
	else {
		Set ..OutputFileName=outputfile
		Quit ..CallReport(.XSL,.delay,outputfile, mode, log, renderServer, ExcelMode)
	}
}

ClassMethod QueryURL() As %ZEN.Datatype.string [ ZenMethod ]
{
	
	Set tRtn = ""
   	Set tStr = %request.CgiEnvs("QUERY_STRING")
   	Set tIdx = 1
   	Set tPart = $Piece(tStr,"&",tIdx)
   	While (tPart '= "") {
	 	Set tProp = $Piece(tPart,"=",1)
	 	Set tVal = $Piece(tPart,"=",2)
	 	Set tIdx = tIdx+1
	 	Set tRtn = tRtn_",?"_tProp_","_tVal
	   	Set tPart = $Piece(tStr,"&",tIdx)
   	}                                            
	Quit tRtn
}

/// Render the contents of this ZEN report.
ClassMethod OnPage() As %Status
{
	n %report
	Set tSC = $$$OK
	Do {
		#; DeepSee presentation reports are expected to be pdf print only at this point
		Set tMode = "pdf"
		Set tDisplayLog = 0
		Set tDatasource=""
		Set tEMBEDXSL=0
		Set tStripPI=$$$GETPARAMETER("STRIPPI")
		If $IsObject($G(%request)) {
			//Set tPS = $G(%request.Data("$PS",1),$$$GETPARAMETER("PS"))
			Set tMode = $zconvert($G(%request.Data("$MODE",1),tMode),"L")
			Set tSuppressExcelHeaders = $zconvert($G(%request.Data("$SUPPRESSEXCELHEADERS",1),$$$GETPARAMETER("SUPPRESSEXCELHEADERS")),"L")
			Set tDisplayLog = $G(%request.Data("$LOG",1),0)
			Set tRootName=..GetSafeRootName()
			If tRootName'="" Set tDisplayLog=1
			Set tDatasource=$G(%request.Data("$DATASOURCE",1))

			Set tStripPI=$G(%request.Data("$STRIPPI",1),$$$GETPARAMETER("STRIPPI"))
			;Set tSubReport=$G(%request.Data("$SUBREPORT",1),"")
			Set tSubReport=""
			Set tXSLTVERSION = $G(%request.Data("$XSLTVERSION",1),$$$GETPARAMETER("XSLTVERSION"))
			Set tXSLT = $zconvert($G(%request.Data("$XSLT",1),$$$GETPARAMETER("XSLTMODE")),"L")
			Set tRenderServer = $G(%request.Data("$RENDERSERVER",1),$$$GETPARAMETER("RENDERSERVER"))
			//Set tPrintServer = $G(%request.Data("$PRINTSERVER",1),$$$GETPARAMETER("PRINTSERVER"))
			if (tXSLTVERSION="2.0") Set tXSLT="server"
			Set tEMBEDXSL = $zconvert($G(%request.Data("$EMBEDXSL",1),$$$GETPARAMETER("EMBEDXSL")),"L")
			if ..hasDataSource() Set tEMBEDXSL=0
			if tEMBEDXSL set tXSLT="browser" ; can't use EMBEDXSL in server mode
			Set tUseTempFiles=0
			if 'tEMBEDXSL Set tUseTempFiles = $zconvert($G(%request.Data("$USETEMPFILES",1),$$$GETPARAMETER("USETEMPFILES")),"L")
		}
		if $IsObject($G(%session)) {
			s tBrowserName=$G(%request.Data("$BROWSER",1))
			if tBrowserName'="" s %session.BrowserName=tBrowserName
		}
	
		#; create instance of *this* report
		Set tUserReport = ..%New()
		d ..%checkNameSpace(tEMBEDXSL, tUserReport)		
		#; handle datasource URL parameter
		If tDatasource'="" {
			Set tUserReport.Datasource=tDatasource
		}

		If $IsObject($G(%request)) {
			Set tRenderTimeOut = $G(%request.Data("$RENDERTIMEOUT",1),$$$GETPARAMETER("RENDERTIMEOUT"))
			Set tPrintTimeOut = $G(%request.Data("$PRINTTIMEOUT",1),$$$GETPARAMETER("PRINTTIMEOUT"))
			Set tTimeOut = $G(%request.Data("$TIMEOUT",1),$$$GETPARAMETER("TIMEOUT"))
			Set tSplitAndMerge = $G(%request.Data("$SPLITANDMERGE",1),$$$GETPARAMETER("SPLITANDMERGE"))
			Set tRepeatingElement = $G(%request.Data("$REPEATINGELEMENT",1),$$$GETPARAMETER("REPEATINGELEMENT"))
			Set tCountRepeatingElement = $G(%request.Data("$COUNTREPEATINGELEMENT",1),$$$GETPARAMETER("COUNTREPEATINGELEMENT"))
			Set tCheckPDFNotZeroLength = $G(%request.Data("$CHECKPDFNOTZEROLENGTH",1),$$$GETPARAMETER("CHECKPDFNOTZEROLENGTH"))
			Set:tSplitAndMerge'="" tUserReport.SplitAndMerge = tSplitAndMerge
			Set:tRepeatingElement'="" tUserReport.RepeatingElement = tRepeatingElement
			Set:tCountRepeatingElement'="" tUserReport.CountRepeatingElement = tCountRepeatingElement
			Set:tSuppressExcelHeaders'="" tUserReport.SuppressExcelHeaders=tSuppressExcelHeaders
			Set:tCheckPDFNotZeroLength'="" tUserReport.CheckPDFNotZeroLength=tCheckPDFNotZeroLength
		}
		#; Set null properties to parameter values
		Set tSC = tUserReport.%InitProperties()
		If $$$ISERR(tSC) Quit
		#; copy URL parameters into specially marked properties.
		Set tSC = tUserReport.%ApplyURLParms()
		If $$$ISERR(tSC) Quit

		#; invoke callback
		Set tSC = tUserReport.%OnBeforeReport()
		If $$$ISERR(tSC) Quit

		#; serve appropriate content based on $MODE query parameter
		If (tMode = "pdf") {
				New %context,%report
				If (tDatasource="") {	
					Set tmpdir=..GetRootDirFromParam()
					Set pdffile=tmpdir_##class(%FileBinaryStream).NewFileName("pdf",..%GetTempDir())		
					Set rptMgr=##class(%DeepSee.Report.UI.reportPreviewer).%New()
					Set tSC = rptMgr.GeneratePresentationReport(..%ClassName(1),..QueryURL(),.pdffile,tUserReport)
					If $$$ISERR(tSC) Quit
					Set stream=##class(%FileBinaryStream).%New()
					Set stream.Filename=pdffile
					$$$SETIO("RAW")
					Do stream.OutputToDevice()
					Do ##class(%DeepSee.Report.UI.reportPreviewer).DeleteTempFile(.pdffile)
				}
				Else {
					#; serve PDF report
					Set tSC = tUserReport.%DisplayPDF(tDisplayLog,tRenderServer,0,.xmlfile,.xsltfile,.pdffile,.lockfile,0,"")
				}
		} ElseIf (tMode = "pdfprint") {
			#; print PDF
			Set tSC = tUserReport.%PrintPDF(tDisplayLog)
		}
		If $$$ISERR(tSC) Quit

		#; notify that report is complete
		Set tSC = tUserReport.%OnAfterReport()
		;if $g(txslfile)'="" d ##class(%File).Delete(txslfile)
		If $$$ISERR(tSC) Quit

	} While(0)
	Quit tSC
}

/// Extracts a value from XPath Result list. 
Method GetResultValue(Results, N As %Integer = 1) As %String
{
	Set result=Results.GetAt(N) 
	If ($IsObject(result)) {
		If (result.Type=2) {	// %XML.XPATH.DOMResult
			// Elements	follow this path
			Do result.Read() // element-node
			Do result.Read() // text-value
		} 
		Else { // %XML.XPATH.ValueResult
			// attributes follow this path			
		}
		Set value=result.Value
	}
	Else { Set value="" }
	Quit value
}

/// Specify seriesGroup or dataGroup as <var>dataGroup</var>.
/// <br/>Specify comma-separated list for <var>dataFields</var>, (no need for !-prefixes).
/// <p>When plotBy is "series" : the number of series equals the number of dataGroup elements found in the XML.
/// <br/>When plotBy is "item" : the number of series equals the number dataField entries specified.
/// <p>If the <var>dataGroup</var> name is not unique, specify the <var>context</var> using XPath syntax. The default is to match
/// elements of that name anywhere (context="//").
/// <p>Optionally specify a <var>seriesNameField</var> XPath expression. This is evaluated relative
/// to the <var>dataGroup</var>. If not specified, a default name is generated using 
/// the dataGroup and a positional predicate.
Method MakeXPath(ByRef values, dataGroup, dataFields, plotBy, context, seriesNameField)
{
	// NORMALIZATION of input
	Set:$g(context)="" context="//"
	Set:$extract(context,*)="/" context=$extract(context,1,*-1) // strip any trailing slash
	Set dataFields=$zstrip(dataFields,"<>W","!") // clean up common problems: remove whitespace and !-marks
	Set seriesNameField=$g(seriesNameField)
	Set plotBy=$case($zcvt($get(plotBy,"series"),"L"), "item":"item","field":"item","data":"item", :"series")
	Set firstValue = 1
	
	Quit:..xmlfile="" $$$ERROR(5001,"Class Property 'xmlfile' is blank.") 
	#dim XParser As %XML.XPATH.Document
	Set tSC = ##class(%XML.XPATH.Document).CreateFromFile(..xmlfile,.XParser)
	Quit:'tSC tSC
	
	Do XParser.EvaluateExpression(context, "count("_dataGroup_")", .GroupMatches )
	Set groupCount=..GetResultValue(GroupMatches,1)
	
	If (plotBy="item") {
		// The number of series is the number of data fields
		Set numSeries=$length(dataFields,",")
		
		// The number of items is determined by the XML -- assume one of each field per group.		
		Set numItems=groupCount
	} 
	Else {		
		// The number of series is determined by the XML.
		Set numSeries=groupCount
		
		// The number of items is the number of data fields -- assume one of each field per group.
		Set numItems=$length(dataFields,",")
	}
	For series=1:1:(numSeries) {
		If (plotBy="item") {
			// Each series is a data-field. Collect the name.
			Set thisField=$piece(dataFields,",",series)
			Set seriesName=thisField
						
			// Collect this field across all groups.
			// Will determine the group-context within inner loop.						
			// Could do EvaulateExpression for the one field across all series, at this point. 
			// Would set thisContext=context_"/"_dataGroup
			// But if there were a gap, no way to tell which series had it (it would shift to end).
		}
		Else {
			// Each series is one iteration of the group. Collect the position-number.
			Set thisSeries=dataGroup_"["_series_"]"
			If (seriesNameField'="") {		
				Do XParser.EvaluateExpression(context_"/"_dataGroup_"["_series_"]", seriesNameField, .NameMatches )
				set seriesName=..GetResultValue(NameMatches,1)
				set:seriesName="" seriesName=thisSeries				
			}
			Else {
				set seriesName=thisSeries
			}
			// Collect each field across this series. 
			// Will determine the specific field within inner loop.
			Set thisContext=context_"/"_thisSeries
						
		}
		For item=1:1:(numItems) {
			If (plotBy="item") {
				// Collect this field from this instance of the group.	
				Set thisItem=dataGroup_"["_item_"]"
				// Collect the name
				If (seriesNameField'="") {
					Do XParser.EvaluateExpression(context_"/"_thisItem, seriesNameField, .NameMatches )
					Set labelName=..GetResultValue(NameMatches,1)
					Set:labelName="" labelName=thisItem				
				}
				Else {
					Set labelName=thisItem
				}
				// The field name was already picked. Search in each group-iteration individually
				Set thisContext=context_"/"_thisItem
				// COULD HAVE done EvaluateExpression in outer loop.
				// If so, now we iterate over results to collect each hit: set hitNumber=item
				// But if there were a gap, no way to tell which series had it (it would shift to end).
		
			}
			Else {
				// Check for each field one-by-one
				Set thisField=$piece(dataFields,",",item)
				// Collect the name
				Set labelName=thisField				
			}	
			// Also record the item-name somewhere, so I can pull them out with ongetLabelX.
			Set ..TmpAxisLabels(item-1)=labelName		
			// Search for this field in this group. Assume each field will match only once per series.							
			Set tSC = XParser.EvaluateExpression(thisContext,thisField,.FieldMatches)
			Set hitNumber=1
			
			// get the value out of the results
			Set value=..GetResultValue(FieldMatches, hitNumber)				
			Set values(series-1,item-1)=value
			If (firstValue=1) {
				Set ..TmpMinValue = value
				Set firstValue = 0
			}
			If (value<..TmpMinValue) Set ..TmpMinValue = value
		}
	}
	
	Quit
}

}
