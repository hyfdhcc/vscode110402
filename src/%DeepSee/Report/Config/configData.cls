/// Configuration and preference storage for DeepSee Report Builder.
Class %DeepSee.Report.Config.configData Extends %RegisteredObject [ System = 4 ]
{

/// Comma separated list of fonts to expose in the presentation editor pages
XData LegalFonts
{
<legalFonts>
<![CDATA[
Century,Candara,Broadway,Elephant,Garamond,Impact,Rockwell,Tahoma,Verdana

	]]></legalFonts>
}

/// This is a JSON object describing additional page sizes.  The parent object is
/// an array of objects.  The page descriptor object has four attributes:
/// displayName: the name of the stock to be exposed to the user;
/// units: either "in" or "mm";
/// width: the width of the stock in 'units';
/// height: the height of the stock in 'units'
XData CustomPageSizes
{
<pageSizes>
<![CDATA[
[
	{displayName:"Sticker",units:"mm",width:60.9,height:101}
]
	]]></pageSizes>
}

/* THIS SECTION IS NOT YET LIVE BUT RESERVED FOR PLANNED EXPANSION
/// This is a JSON object describing the the types of aggregation options to expose
/// in the QueryBasedDSS screen.  It is an array of objects where each object has up to 
/// four attributes: caption - the column header that appears on screen; numeric - a
/// binary flag that indicates if this option only makes sense for numeric fields or 
/// couple be applied to any sort of data; type - the type of aggregation, one of several 
/// built in options or "CUSTOM"; and, class - the name of a zen report aggregate function
/// class to be called in the case where the type of function is "CUSTOM"
*/
XData DefaultQueryAggregates
{
<queryAggregates>
	<![CDATA[
	[
		{caption:"COUNT",numeric:"0",type:"CUSTOM",class="%ZEN.Report.Aggregate.CountDistinct"},
		{caption:"AVE",numeric:"1",type:"AVE"},
		{caption:"SUM",numeric:"1",type:"SUM"},
		{caption:"MIN",numeric:"1",type:"MIN"},
		{caption:"MAX",numeric:"1",type:"MAX"}
	]
	]]></queryAggregates>
}

/// This is a JSON object describing the default superclasses for the various families 
/// of reports produced by DSVR. The values given for the %SYS namespace serve as 
/// the defaults for the system as a whole and must be fully specified with valid settings.
/// Changing these settings is not recommended. <br />
/// Subclasses of %DeepSee.Report.Config.configData may override this XData section  
/// to add custom defaults on a "by namespace" basis but new
/// superclasses must be extensions of the default classes given for the %SYS namespace.<br/>
/// The format of this variable is an object with up to (at curent)
/// five attributes.  These are the superclass overrides for the particular families of
/// reports: dcrClass, the data collectors; dssClass, the data schema interfaces; dprClass,
/// the data presentation classes; sqlClass, the DSS interfaces for queries and views; and,
/// defaultClass, the catch-all for any DSVR classes not specifically handled by one of the 
/// previous options. <br />
/// If an entry is only partially specified un a subclass the corresponding
/// defaults from the %SYS entry will be used to complete the template.
XData DefaultSuperClasses
{
<superClasses>
	<![CDATA[
	{
		dcrClass:"%DeepSee.Report.dataCollector",
		dssClass:"%DeepSee.Report.dataSchemaInterface",
		dprClass:"%DeepSee.Report.dataPresenter",
		sqlClass:"%DeepSee.Report.sqlQueryDSS",
		defaultClass:"%DeepSee.Report.reportPage"
	}
	]]></superClasses>
}

ClassMethod GetFontList() As %String
{
	Set fontList = $Get(^DeepSeeVisualReports.LegalFonts)
	If (fontList="") {
		Set xDataId = "%DeepSee.Report.Config.configData||LegalFonts"
 		Set fontList = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
	}
	Quit fontList
}

ClassMethod GetCustomPageSizes() As %String
{
	Set pageList = $Get(^DeepSeeVisualReports.CustomPageSizes)
	If (pageList="") {
		Set xDataId = "%DeepSee.Report.Config.configData||CustomPageSizes"
 		Set pageList = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
	}
	Quit pageList
}

ClassMethod GetDefaultQueryAggregates() As %String
{
	Set aggregateList = $Get(^DeepSeeVisualReports.DefaultQueryAggregates)
	If (aggregateList="") {
		Set xDataId = "%DeepSee.Report.Config.configData||DefaultQueryAggregates"
 		Set aggregateList = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
	}
	Quit aggregateList
}

ClassMethod GetDefaultSuperClasses() As %String
{
	Set xDataId = "%DeepSee.Report.Config.configData||DefaultSuperClasses"
 	Set superclassList = "["_##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
	Set localList = $Get(^DeepSeeVisualReports.DefaultSuperClasses)
	If (localList'="") {
		Set superclassList = superclassList_","_localList_"]"
	}
	Else {
		Set superclassList = superclassList_"]"
	}
	Quit superclassList
}

ClassMethod %InstallNamespaceDefaults() As %String
{
	Set thisClass = ..%ClassName(1)
	Set newSettings = thisClass
	If (thisClass'="%DeepSee.Report.Config.configData") {
		// DEFINE ^DeepSeeVisualReports.LegalFonts
		Set xDataId = thisClass_"||LegalFonts"
		Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xDataId)
		Set origin = compiledXdata.Origin
		If (origin=thisClass) {
		 	Set fontData = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
			Set ^DeepSeeVisualReports.LegalFonts = fontData
			Set newSettings = newSettings_"\n"_xDataId_": "_fontData
		}
		Else {
			Set ^DeepSeeVisualReports.LegalFonts = ""
		}

		// DEFINE ^DeepSeeVisualReports.CustomPageSizes
		Set xDataId = thisClass_"||CustomPageSizes"
		Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xDataId)
		Set origin = compiledXdata.Origin
		If (origin=thisClass) {
		 	Set pageData = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
			Set ^DeepSeeVisualReports.CustomPageSizes = pageData
			Set newSettings = newSettings_"\n"_xDataId_": "_pageData
		}
		Else {
			Set ^DeepSeeVisualReports.CustomPageSizes = ""
		}

		// DEFINE ^DeepSeeVisualReports.DefaultSuperClasses
		Set xDataId = thisClass_"||DefaultSuperClasses"
		Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xDataId)
		Set origin = compiledXdata.Origin
		If (origin=thisClass) {
		 	Set superclassData = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
			Set ^DeepSeeVisualReports.DefaultSuperClasses = superclassData
			Set newSettings = newSettings_"\n"_xDataId_": "_superclassData
		}
		Else {
			Set ^DeepSeeVisualReports.DefaultSuperClasses = ""
		}

		// DEFINE ^DeepSeeVisualReports.DefaultQueryAggregates
		Set xDataId = thisClass_"||DefaultQueryAggregates"
		Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(xDataId)
		Set origin = compiledXdata.Origin
		If (origin=thisClass) {
		 	Set aggregateData = ##class(%DeepSee.Report.Config.configData).%GetXDataTextSection(xDataId)
			Set ^DeepSeeVisualReports.DefaultQueryAggregates = aggregateData
			Set newSettings = newSettings_"\n"_xDataId_": "_aggregateData
		}
		Else {
			Set ^DeepSeeVisualReports.DefaultQueryAggregates = ""
		}
	}
	Quit newSettings
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
