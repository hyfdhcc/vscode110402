/// This class contains various utility methods
/// used by the DeepSee report classes.
Class %DeepSee.Report.Utils Extends %RegisteredObject [ System = 2 ]
{

Parameter DOMAIN = "%DeepSee";

/// Given a report model (typically supplied
/// by the report designer) create a class that implements the report.
ClassMethod %GenerateReport(pModel As %DeepSee.Report.Model.Report) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		// check name
		If (pModel.name="") {
			Set tSC = $$$ERROR($$$GeneralError,"Report must have a name.")
			Quit
		}
		If (pModel.name[".") {
			Set tSC = $$$ERROR($$$GeneralError,"Report name cannot contain a ".": " _ pModel.name)
			Quit
		}
		
		// check data source
		If (pModel.dataSource="") {
			Set tSC = $$$ERROR($$$GeneralError,"Report must have a data source.")
			Quit
		}
		If ('$$$comClassDefined(pModel.dataSource)) {
			Set tSC = $$$ERROR($$$GeneralError,"Report data source not found: " _ pModel.dataSource)
			Quit
		}

		// determine the class name to use for the report
		Set tClassName = ..%ReportNameToClassName(pModel.name)

		// open the class definition
		If (##class(%Dictionary.ClassDefinition).%ExistsId(tClassName)) {
			Set tClassDefinition = ##class(%Dictionary.ClassDefinition).%OpenId(tClassName)
			#; delete the old XDATA block named ReportModel
			Set tIndex = tClassDefinition.XDatas.FindObjectId(tClassName_"||ReportModel")
			If tIndex'="" Do tClassDefinition.XDatas.RemoveAt(tIndex)
		}
		Else {
			// create a new class
			Set tClassDefinition = ##class(%Dictionary.ClassDefinition).%New()
			Set tClassDefinition.Name = tClassName
			Set tClassDefinition.Super = "%DeepSee.Report.reportPage"
		}

		// sequence number controls the order in which class members are displayed
		Set tSeqNo = 0

		// report class parameters
		Set tIndex = tClassDefinition.Parameters.FindObjectId(tClassName_"||REPORTNAME")
		If tIndex'="" Do tClassDefinition.Parameters.RemoveAt(tIndex)
		Set tParm = ##class(%Dictionary.ParameterDefinition).%New()
		Set tParm.Name = "REPORTNAME"
		Set tParm.Default = pModel.name
		Set tParm.SequenceNumber = $I(tSeqNo)
		Set tParm.Description = "Name of this report."
		Set tParm.parent = tClassDefinition

		Set tIndex = tClassDefinition.Parameters.FindObjectId(tClassName_"||APPLICATION")
		If tIndex'="" Do tClassDefinition.Parameters.RemoveAt(tIndex)
		Set tParm = ##class(%Dictionary.ParameterDefinition).%New()
		Set tParm.Name = "APPLICATION"
		Set tParm.SequenceNumber = $I(tSeqNo)
		Set tParm.Description = "Class name of the application this report belongs to."
		Set tParm.parent = tClassDefinition

		Set tIndex = tClassDefinition.Parameters.FindObjectId(tClassName_"||DEFAULTMODE")
		If tIndex'="" Do tClassDefinition.Parameters.RemoveAt(tIndex)
		Set tParm = ##class(%Dictionary.ParameterDefinition).%New()
		Set tParm.Name = "DEFAULTMODE"
		Set tParm.SequenceNumber = $I(tSeqNo)
		Set tParm.Default = "html"
		Set tParm.Description = "This is the default display mode for this report."
		Set tParm.parent = tClassDefinition

		// add report parameters (properties)

		// create XData block to hold the Report Model
		Set tModelXData = ##class(%Dictionary.XDataDefinition).%New()
		
		Set tModelXData.SequenceNumber = $I(tSeqNo)
		Set tModelXData.Description = "Report Model information supplied from Report Builder."
		Set tModelXData.XMLNamespace = ""

		Set tModelXData.Name = "ReportModel"
		Set tModelXData.parent = tClassDefinition

		// contents of xdata block is the xml for the model
		// use XML Writer for cleaner output

		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1
		Set tSC = tWriter.OutputToStream(tModelXData.Data)
		If $$$ISERR(tSC) Quit
		Set tSC = tWriter.StartDocument()
		If $$$ISERR(tSC) Quit
		Set tSC = tWriter.RootObject(pModel)
		If $$$ISERR(tSC) Quit
		Set tSC = tWriter.EndDocument()
		If $$$ISERR(tSC) Quit

		//Set tSC = pModel.XMLExportToStream(tModelXData.Data)
		//If $$$ISERR(tSC) Quit
	
		// description
		Set tClassDefinition.Description = "This is a generated class."_$C(13,10)_"DO NOT EDIT."

		// create the ReportDefinition XData block
		Set tIndex = tClassDefinition.XDatas.FindObjectId(tClassName_"||ReportDefinition")
		If tIndex'="" Do tClassDefinition.XDatas.RemoveAt(tIndex)

		Set tRDefXData = ##class(%Dictionary.XDataDefinition).%New()
		Set tRDefXData.Name = "ReportDefinition"
		Set tRDefXData.SequenceNumber = $I(tSeqNo)
		Set tRDefXData.Description = "This XML defines the logical contents of this report."
		Set tRDefXData.XMLNamespace = "http://www.intersystems.com/zen/report/definition"
		Set tRDefXData.parent = tClassDefinition

		Set tSC = ..%ModelToReportDefinition(pModel,tRDefXData.Data)
		If $$$ISERR(tSC) Quit

		// create the ReportDisplay XData block
		Set tIndex = tClassDefinition.XDatas.FindObjectId(tClassName_"||ReportDisplay")
		If tIndex'="" Do tClassDefinition.XDatas.RemoveAt(tIndex)

		Set tRDspXData = ##class(%Dictionary.XDataDefinition).%New()
		Set tRDspXData.Name = "ReportDisplay"
		Set tRDspXData.SequenceNumber = $I(tSeqNo)
		Set tRDspXData.Description = "This XML defines the display for this report."
		Set tRDspXData.XMLNamespace = "http://www.intersystems.com/zen/report/display"
		Set tRDspXData.parent = tClassDefinition

		Set tSC = ..%ModelToReportDisplay(pModel,tRDspXData.Data)
		If $$$ISERR(tSC) Quit

		// save and compile the report class
		Set tSC = tClassDefinition.%Save()
		If $$$ISERR(tSC) Quit

		// if error occurs, remove the reportDefinition and reportDisplay blocks
		// and save the model only
		Set tSC = $System.OBJ.Compile(tClassDefinition.Name,"-d")
		If $$$ISERR(tSC) Quit

	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Given the name of a report, return a class name that can be used to
/// implement the report.
ClassMethod %ReportNameToClassName(pReportName As %String) As %String [ Internal ]
{
	Set tName = "Rpt"_$ZCRC(pReportName,7)  // use hash of name
	Quit "DeepSee.Reports." _ tName
}

/// Given the name of a report, see if it exists and if so return the name of the
/// class that implements it.
ClassMethod %GetClassNameForReport(pReportName As %String) As %String
{
	Set tClassName = ..%ReportNameToClassName(pReportName)
	If ('##class(%Dictionary.ClassDefinition).%ExistsId(tClassName)) {
		Quit ""
	}
	Quit tClassName
}

/// Convert a report model to a report definition (as a stream in XML format).
ClassMethod %ModelToReportDefinition(pModel As %DeepSee.Report.Model.Report, pOutput As %Stream.GlobalCharacter) As %Status [ Internal ]
{
	#define ESCAPEXML(%x) $ZCVT(%x,"O","XML")
	try {
		Set tSC=..CalcSQL(pModel,pModel,.tSQL)
		if $$$ISERR(tSC) quit
		Do pOutput.WriteLine("<report xmlns=""http://www.intersystems.com/zen/report/definition""")
		Do pOutput.WriteLine("name="""_..%XMLName(pModel.name)_"""")
		Do pOutput.WriteLine("sql="""_$$$ESCAPEXML(tSQL)_"""")
		Do pOutput.WriteLine(">")
		Set pModel.xpath = "/"_..%XMLName(pModel.name)
		do ..ProcessGroups(pModel,pModel,pModel.groups,pOutput,.pSeen)
		Do pOutput.WriteLine("</report>")
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// A groupoid can be a model or a group.
ClassMethod CalcSQL(pModel As %DeepSee.Report.Model.Report, pGroupoid, ByRef pSQL As %String) As %Status
{
	#define ESCAPEXML(%x) $ZCVT(%x,"O","XML")

	Set tSC = $$$OK
	do {
		// get list of fields referenced by the model or group.
		// also pick up information on groups
		if pGroupoid.%Extends("%DeepSee.Report.Model.Report") {
			set list = pGroupoid.groups
			Set hasSQL=1
		} else {
			set list = pGroupoid.elements
			Set hasSQL = pGroupoid.hasSQL
		}
		Do ..getItemGroups(list,.tFields,.tOrderBy,.tParams)
		// use model to convert each field into its sql expression
		Set f = $O(tFields(""))
		While (f '= "") {
			Set tSC = pModel.%GetSQLForField(f,.tExpr)
			If $$$ISERR(tSC) Quit
			Set tFields(f) = tExpr
			Set f = $O(tFields(f))
		}
		If $$$ISERR(tSC) Quit

		Set tSC = pGroupoid.%GetSQLTableName(.tTable)
		If $$$ISERR(tSC) Quit

		// construct SQL for report
		Set tSELECT = ""
		Set tORDER = ""
		Set f = $O(tFields(""))
		While (f '= "") {
			Set tExpr = tFields(f)
			Set tSELECT = tSELECT _ $S(tSELECT="":"",1:",") _ tExpr
			Set f = $O(tFields(f))
		}
		
		If (tSELECT="") {
			// make sure we at least have a valid query
			Set tSELECT = "%ID"
		}

		Set n = $O(tOrderBy(""))
		While (n '= "") {
			Set tExpr = tFields(tOrderBy(n))
			Set tORDER = tORDER _ $S(tORDER="":"",1:",") _ tExpr
			Set n = $O(tOrderBy(n))
		}
		Set tSQL = "SELECT "_tSELECT_" FROM "_tTable
		set tWHERE=""
		Set p = $O(tParams(""))
		Set sep=""
		Set sep2=" WHERE"
		While (p '= "") {
			Set tWHERE=sep2_" "_p_" = ? "_sep_tWHERE
			Set sep=" AND "
			Set sep2=""
			Set p = $O(tParams(p))
		}
		Set:tORDER'="" tSQL = tSQL _ tWHERE _ " ORDER BY " _ tORDER
		Set pSQL=""
		if hasSQL'=0 Set pSQL=tSQL

	} while 0
	Quit tSC
}

ClassMethod getItemGroups(pList, ByRef pFields, ByRef pOrderBy, ByRef pParams)
{
	For g = 1:1:pList.Count() {
		Set tEl = pList.GetAt(g)
		if tEl.%Extends("%DeepSee.Report.Model.Group") {
			Set tGroup=tEl
			If ((tGroup.category="group") && (tGroup.breakOnField'="")) {
				Set pFields(tGroup.breakOnField) = ""
				If (tGroup.index'="") {
					Set pOrderBy(tGroup.index) = tGroup.breakOnField
				}
			
			} 
			If ((tGroup.category="group") && (tGroup.index'="")) {
				Do ..getItemFields(tGroup, .pFields,.pParams)
			}
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Parameter")) {
			w !,"parameter from inner group="_tEl.field
			Set pParams(tEl.field) = ""

		} elseif ((tEl.%Extends("%DeepSee.Report.Model.Table"))||(tEl.%Extends("%DeepSee.Report.Model.Div"))||(tEl.%Extends("%DeepSee.Report.Model.BlockContainer"))||(tEl.%Extends("%DeepSee.Report.Model.Template"))) {
			Do ..getItemGroups(tEl.elements, .pFields, .pOrderBy, .pParams)
		}
	}
}

ClassMethod getItemFields(pCollection, ByRef pFields, ByRef pParams)
{
	// w !,"getItemFields for "_pCollection.name_" class="_pCollection.%ClassName(1)
	For e = 1:1:pCollection.elements.Count() {
		Set tEl = pCollection.elements.GetAt(e)
		if (tEl.%Extends("%DeepSee.Report.Model.Item")) {
			w !,"El "_tEl.name_" extends Item"
			If (tEl.field'="") {
				w !,"field from inner group="_tEl.field
				Set pFields(tEl.field) = ""
			}
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Parameter")) {
			w !,"parameter from inner group="_tEl.field
			Set pParams(tEl.field) = ""
		} elseif ((tEl.%Extends("%DeepSee.Report.Model.Table"))||(tEl.%Extends("%DeepSee.Report.Model.Div"))||(tEl.%Extends("%DeepSee.Report.Model.BlockContainer"))||(tEl.%Extends("%DeepSee.Report.Model.Template"))) {
			Do ..getItemFields(tEl,.pFields,.pParams)
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Group") && (tEl.hasSQL=0)) { //??? 6-10-09
			Do ..getItemFields(tEl,.pFields,.pParams)
		}
	}
}

/// list is a polymorphic list that may include non-groups
/// parent is Report or Group
ClassMethod ProcessGroups(pModel As %DeepSee.Report.Model.Report, parent As %DeepSee.Report.Model.Node, list, pOutput As %Stream.GlobalCharacter, ByRef pSeen)
{
	For g = 1:1:list.Count() {
		Set tGroup = list.GetAt(g)
		If ((tGroup.%Extends("%DeepSee.Report.Model.Group"))&&(tGroup.category="group") ) {
			If (tGroup.index'="") {
				Set tGrouping(tGroup.index) = tGroup
				;w !,"parent.xpath="_parent.xpath_" tGroup.name="_tGroup.name
				;Set tGroup.xpath=parent.xpath_"/"_tGroup.name
			}
			// loop over elements
			
		
		
		}
	}

	// create groups
	Set g = $O(tGrouping(""))
	While (g '= "") {
		Set tGroup = tGrouping(g)
		Set tGroup.xpath=parent.xpath_"/"_tGroup.name
		do ..ProcessElements(tGroup,tGroup.elements,.tFields,.tAttr,.tAggr,.tGroups,.tParams)
		Do ..DisplayGroupDefinition(pModel, tGroup,.tFields,.tAttr,.tAggr,.tGroups,.tParams,pOutput,.pSeen)
		Set g = $O(tGrouping(g))
	}
}

ClassMethod DisplayGroupDefinition(pModel As %DeepSee.Report.Model.Report, pGroup, ByRef pFields, ByRef pAttr, ByRef pAggr, ByRef pGroups, ByRef pParams, pOutput As %Stream.GlobalCharacter, ByRef pSeen)
{
		;if $D(pSeen(..%XMLName(pGroup.name))) quit
		Do pOutput.WriteLine("<group ")
		Do pOutput.WriteLine("name="""_..%XMLName(pGroup.name)_"""")
		Set pSeen(..%XMLName(pGroup.name))=""
		Do pOutput.WriteLine("breakOnField="""_$$$ESCAPEXML(pGroup.breakOnField)_"""")
		Set tSC=..CalcSQL(pModel,pGroup,.tSQL)
		if tSQL'="" Do pOutput.WriteLine("sql="""_$$$ESCAPEXML(tSQL)_"""")
		Do pOutput.WriteLine(">")
		// items within group
		Set g=pGroup.index
		Set a = $O(pParams(g,""))
		While (a '= "") {
			Set tEl = pParams(g,a)
			Do pOutput.WriteLine("<parameter ")
			if tEl.field'="" Do pOutput.WriteLine("field="""_$$$ESCAPEXML(tEl.field)_"""")
			if tEl.expression'="" Do pOutput.WriteLine("value="""_$$$ESCAPEXML(tEl.value)_"""")
			if tEl.value'="" Do pOutput.WriteLine("expression="""_$$$ESCAPEXML(tEl.expression)_"""")
			Do pOutput.WriteLine("/>")
			Set a = $O(pParams(g,a))
		}
		
		Set a = $O(pAttr(g,""))
		While (a '= "") {
			Set tEl = pAttr(g,a)
			Do pOutput.WriteLine("<attribute ")
			Do pOutput.WriteLine("name="""_..%XMLName(tEl.name)_"""")
			Do pOutput.WriteLine("field="""_$$$ESCAPEXML(tEl.field)_"""")
			Do pOutput.WriteLine("/>")
			Set a = $O(pAttr(g,a))
		}
		// aggregates within group
		Set a = $O(pAggr(g,""))
		While (a '= "") {
			Set tEl = pAggr(g,a)
			Do pOutput.WriteLine("<aggregate ")
			Do pOutput.WriteLine("name="""_..%XMLName(tEl.name)_"""")
			if tEl.field'="" Do pOutput.WriteLine("field="""_$$$ESCAPEXML(tEl.field)_"""")
			Do pOutput.WriteLine("type='"_tEl.type_"'")
			if tEl.class'="" Do pOutput.WriteLine("class='"_tEl.class_"'")
			if tEl.fields'="" Do pOutput.WriteLine("fields='"_tEl.fields_"'")
			if tEl.format'="" Do pOutput.WriteLine("format='"_tEl.format_"'")
			if tEl.accumIf'="" Do pOutput.WriteLine("accumIf='"_tEl.accumIf_"'")
			Do pOutput.WriteLine("/>")
			Set a = $O(pAggr(g,a))
		}
		// groups within group
		Set a = $O(pGroups(g,""))
		While (a '= "") {
			Set tEl = pGroups(g,a)
			;Do pOutput.WriteLine("<group ")
			;Do pOutput.WriteLine("name="""_..%XMLName(tEl.name)_"""")
			do ..ProcessElements(tEl,tEl.elements,.tFields,.tAttr,.tAggr,.tGroups,.tParams)
			do ..DisplayGroupDefinition(pModel, tEl,.tFields,.tAttr,.tAggr,.tGroups,.tParams,pOutput,.pSeen)
			;Do ..ProcessGroups(pModel, tEl,tEl.elements,pOutput,.pSeen)
			Set a = $O(pGroups(g,a))
		}
		Do pOutput.WriteLine("</group>")
}

/// pElements is a list
ClassMethod ProcessElements(pGroup, pElements, ByRef pFields, ByRef pAttr, ByRef pAggr, ByRef pGroups, ByRef pParams)
{
	For e = 1:1:pElements.Count() {
		Set tEl = pElements.GetAt(e)
		if (tEl.%Extends("%DeepSee.Report.Model.Item")) {
			If (tEl.field'="") {
				Set pFields(tEl.field) = ""
				If ((pGroup.category="group") && (pGroup.index'="")) {
					Set pAttr(pGroup.index,e) = tEl
				}
			}
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Parameter")) {
			If ((pGroup.category="group") && (pGroup.index'="")) {
				Set pParams(pGroup.index,e)=tEl
			}
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Aggregate")) {
				If ((pGroup.category="group") && (pGroup.index'="")) {
					Set pAggr(pGroup.index,e) = tEl
				}
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Group")) {
			If ((pGroup.category="group") && (pGroup.index'="")) {
				If ((tEl.category="group") && (tEl.index'="")) {
					w !,"adding group name="_tEl.name
					Set pGroups(pGroup.index,e)=tEl
					Set tEl.xpath=pGroup.xpath_"/"_tEl.name
				}
			}
		} elseif ((tEl.%Extends("%DeepSee.Report.Model.Table"))||(tEl.%Extends("%DeepSee.Report.Model.Div"))||(tEl.%Extends("%DeepSee.Report.Model.BlockContainer"))||(tEl.%Extends("%DeepSee.Report.Model.Template"))) {
			if (tEl.%Extends("%DeepSee.Report.Model.Table")) {
				Set pGroup.display=0
			}
			do ..ProcessElements(pGroup,tEl.elements,.pFields,.pAttr,.pAggr,.pGroups,.pParams)
		}
		
}
}

/// Convert <var>pValue</var> to a valid XML element or attribute name.
ClassMethod %XMLName(pValue As %String) As %String
{
	Quit $TR($ZCVT(pValue,"O","XML")," ","")
}

/// Convert a report model to a report display (as a stream in XML format).
ClassMethod %ModelToReportDisplay(pModel As %DeepSee.Report.Model.Report, pOutput As %Stream.GlobalCharacter) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Do pOutput.WriteLine("<report xmlns=""http://www.intersystems.com/zen/report/display""")
		Do pOutput.WriteLine("name="""_..%XMLName(pModel.name)_"""")
		Do pOutput.WriteLine(">")
		Do pOutput.Write("<document")
		Do pOutput.Write(" height='"_pModel.document.height_"' width='"_pModel.document.width_"'")
		Do pOutput.Write(" marginLeft='"_pModel.document.marginLeft_"' marginRight='"_pModel.document.marginRight_"'")
		Do pOutput.Write(" marginTop='"_pModel.document.marginTop_"' marginBottom='"_pModel.document.marginBottom_"'")
		Do pOutput.Write(" footerHeight='"_pModel.document.footerHeight_"' headerHeight='"_pModel.document.headerHeight_"'")
		Do pOutput.WriteLine(">")
		Do pOutput.WriteLine("</document>")
		if pModel.pageHeader'="" {
			Do pOutput.WriteLine("<pageheader>")
			do ..DisplayElements(pModel,pModel.pageHeader.elements,pOutput)
			Do pOutput.WriteLine("</pageheader>")
		}
		if pModel.pageFooter'="" {
			Do pOutput.WriteLine("<pagefooter>")
			do ..DisplayElements(pModel,pModel.pageFooter.elements,pOutput)
			Do pOutput.WriteLine("</pagefooter>")
		}
		Do pOutput.WriteLine("<body>")
		For g = 1:1:pModel.groups.Count() {
			Set tGroup = pModel.groups.GetAt(g)
			If ((tGroup.category="group") && (tGroup.index'="") && (tGroup.display=1)) {
				Do pOutput.WriteLine("<!-- top level group -->")
				Do pOutput.WriteLine("<group name='"_tGroup.name_"'>")
			}
			// loop over elements
			
			do ..DisplayElements(tGroup,tGroup.elements,pOutput)
			If ((tGroup.category="group") && (tGroup.index'="") && (tGroup.display=1)) {
				Do pOutput.WriteLine("</group>")
			}

		}
		
		Do pOutput.WriteLine("</body>")
		Do pOutput.WriteLine("</report>")
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// pElements is a list
ClassMethod DisplayElements(pGroup, pElements, pOutput As %Stream.GlobalCharacter)
{
	For e = 1:1:pElements.Count() {
		Set tEl = pElements.GetAt(e)
		if (tEl.%Extends("%DeepSee.Report.Model.Item")) {
			if tEl.visible=0 {
				continue
			}
			Do pOutput.Write(tEl.tagBegin)
			if (tEl.%Extends("%DeepSee.Report.Model.Summary")) {
					Do pOutput.Write(" field='"_tEl.field_"'")
			} else {
				if (tEl.name'="") {
					Do pOutput.Write(" field='@"_tEl.name_"'")
				}
			}
			If (tEl.value'="") {
				Do pOutput.Write(" value='"_tEl.value_"'")
			}
			If (tEl.caption'="") {
				Do pOutput.Write(" caption='"_tEl.caption_"'")
			}
			Do ..DisplayStyle(tEl, pOutput)			
			If (tEl.special'="") {
				Do pOutput.Write(" special='"_tEl.special_"'")
			}

			Do pOutput.WriteLine(">")
			do ..DisplayElements(pGroup,tEl.elements,pOutput)
			Do pOutput.WriteLine(tEl.tagEnd)
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Aggregate")) {
#if 0 // aggregates part of report definition not report display			
			Do pOutput.Write("<item")
			If (tEl.field'="") {
				Do pOutput.Write(" field='"_tEl.name_"'")
			}
			If (tEl.caption'="") {
				Do pOutput.Write(" caption='"_tEl.caption_"'")
			}
			Do ..DisplayStyle(tEl, pOutput)
			Do pOutput.WriteLine(">")
			Do pOutput.WriteLine("</item>")
#endif			
			
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Table")) {
			if (tEl.groupOverride'="") {
				Do pOutput.Write("<table group='"_tEl.groupOverride_"'")
			} else {
				Do pOutput.Write("<table group='"_pGroup.name_"'")
			}
			Do ..DisplayStyle(tEl, pOutput)
			Do pOutput.Write(" orient='"_tEl.orient_"'")
			Do pOutput.WriteLine(">")
			do ..DisplayElements(pGroup,tEl.elements,pOutput)
			Do pOutput.WriteLine("</table>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Paragraph")) {
			Do pOutput.Write("<p")
			Do ..DisplayStyle(tEl, pOutput)
			Do pOutput.WriteLine(">")
			If (tEl.content'="") {
				Do pOutput.Write(tEl.content)
			}			

			Do pOutput.Write("</p>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Inline")) {
			Do pOutput.Write("<inline")
			Do ..DisplayStyle(tEl, pOutput)
			Do pOutput.WriteLine(">")
			If (tEl.content'="") {
				Do pOutput.Write(tEl.content)
			}			

			Do pOutput.Write("</inline>")

		} elseif (tEl.%Extends("%DeepSee.Report.Model.Div")) {
			Do pOutput.Write("<div")
			Do ..DisplayStyle(tEl, pOutput)
			Do pOutput.WriteLine(">")
			do ..DisplayElements(pGroup,tEl.elements,pOutput)
			Do pOutput.WriteLine("</div>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Template")) {
			Do pOutput.Write("<group")
			if tEl.match'="" Do pOutput.WriteLine(" name='"_tEl.match_"'")
			Do pOutput.WriteLine(">")
			do ..DisplayElements(pGroup,tEl.elements,pOutput)
			Do pOutput.WriteLine("</group>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Group")) {
			w !,"processing group tEl.name="_tEl.name
			if (tEl.display) {
				Do pOutput.Write("<group")
				if tEl.name'="" Do pOutput.WriteLine(" name='"_tEl.name_"'")
				Do pOutput.WriteLine(">")
			}
			do ..DisplayElements(tEl,tEl.elements,pOutput)
			if (tEl.display) {
				Do pOutput.WriteLine("</group>")			
			}
		} elseif (tEl.%Extends("%DeepSee.Report.Model.BlockContainer")) {
			Do pOutput.Write("<container")
			Do ..DisplayStyle(tEl, pOutput)
			if tEl.backgroundImage'="" Do pOutput.Write(" backgroundImage="_tEl.backgroundImage)
			Do pOutput.WriteLine(">")
			do ..DisplayElements(pGroup,tEl.elements,pOutput)
			Do pOutput.WriteLine("</container>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Image")) {
			Do pOutput.Write("<img")
			Do ..DisplayStyle(tEl, pOutput)
			if (tEl.src'="") {
				Do pOutput.Write(" src='"_tEl.src_"'")
			}
			if (tEl.height'="") {
				Do pOutput.Write(" src='"_tEl.height_"'")
			}
			if (tEl.width'="") {
				Do pOutput.Write(" src='"_tEl.width_"'")
			}
			if (tEl.contentHeight'="") {
				Do pOutput.Write(" src='"_tEl.contentHeight_"'")
			}
			if (tEl.contentWidth'="") {
				Do pOutput.Write(" src='"_tEl.contentWidth_"'")
			}

			Do pOutput.WriteLine("/>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Link")) {
			Do pOutput.Write("<link")
			Do ..DisplayStyle(tEl, pOutput)
			if (tEl.destination'="") {
				Do pOutput.Write(" destination='"_tEl.destination_"'")
			}
			if (tEl.internal'="") {
				Do pOutput.Write(" internal='"_tEl.internal_"'")
			}
			if (tEl.name'="") {
				Do pOutput.Write(" name='"_tEl.name_"'")
			}

			Do pOutput.WriteLine("/>")
		} elseif (tEl.%Extends("%DeepSee.Report.Model.Chart.Chart")) {
		
			Do pOutput.Write(tEl.tagBegin)
			if (tEl.backgroundStyle'="") {
				Do pOutput.WriteLine(" backgroundStyle='"_tEl.backgroundStyle_"'")
			}
			if (tEl.plotAreaStyle '="") {
				Do pOutput.WriteLine(" plotAreaStyle ='"_tEl.plotAreaStyle _"'")
			}
			if (tEl.title'="") {
				Do pOutput.WriteLine(" title='"_tEl.title_"'")
			}
			if (tEl.titleStyle'="") {
				Do pOutput.WriteLine(" titleStyle='"_tEl.titleStyle_"'")
			}
			if (tEl.titleX'="") {
				Do pOutput.WriteLine(" titleX='"_tEl.titleX_"'")
			}
			if (tEl.titleY'="") {
				Do pOutput.WriteLine(" titleY='"_tEl.titleY_"'")
			}
			if (tEl.dataFields'="") {
				Do pOutput.WriteLine(" dataFields='"_tEl.dataFields_"'")
			}
			if (tEl.seriesCount'="") {
				Do pOutput.WriteLine(" seriesCount='"_tEl.seriesCount_"'")
			}
			if (tEl.seriesSize '="") {
				Do pOutput.WriteLine(" seriesSize ='"_tEl.seriesSize _"'")
			}
			if (tEl.seriesColors'="") {
				Do pOutput.WriteLine(" seriesColors='"_tEl.seriesColors_"'")
			}
			if (tEl.seriesNames'="") {
				Do pOutput.WriteLine(" seriesNames='"_tEl.seriesNames_"'")
			}
			if (tEl.seriesGroup'="") {
				Do pOutput.WriteLine(" seriesGroup='"_tEl.seriesGroup_"'")
			}
			if (tEl.dataGroup'="") {
				Do pOutput.WriteLine(" dataGroup='"_tEl.dataGroup_"'")
			}
			if (tEl.markerShapes'="") {
				Do pOutput.WriteLine(" markerShapes='"_tEl.markerShapes_"'")
			}
			if (tEl.markerScale'="") {
				Do pOutput.WriteLine(" markerScale='"_tEl.markerScale_"'")
			}
			if (tEl.gridStyle'="") {
				Do pOutput.WriteLine(" gridStyle='"_tEl.gridStyle_"'")
			}
			if (tEl.height'="") {
				Do pOutput.WriteLine(" height='"_tEl.height_"'")
			}
			if (tEl.width'="") {
				Do pOutput.WriteLine(" width='"_tEl.width_"'")
			}

			if (tEl.labelStyle'="") {
				Do pOutput.WriteLine(" labelStyle='"_tEl.labelStyle_"'")
			}
			if (tEl.legendVisible'="") {
				Do pOutput.WriteLine(" legendVisible='"_tEl.legendVisible_"'")
			}
			if (tEl.legendX'="") {
				Do pOutput.WriteLine(" legendX='"_tEl.legendX_"'")
			}
			if (tEl.legendY'="") {
				Do pOutput.WriteLine(" legendY='"_tEl.legendY_"'")
			}
			if (tEl.legendWidth'="") {
				Do pOutput.WriteLine(" legendWidth='"_tEl.legendWidth_"'")
			}
			if (tEl.legendHeight'="") {
				Do pOutput.WriteLine(" legendHeight='"_tEl.legendHeight_"'")
			}
			if (tEl.legendStyle'="") {
				Do pOutput.WriteLine(" legendStyle='"_tEl.legendStyle_"'")
			}
			if (tEl.legendLabelStyle'="") {
				Do pOutput.WriteLine(" legendLabelStyle='"_tEl.legendLabelStyle_"'")
			}
			if (tEl.marginTop'="") {
				Do pOutput.WriteLine(" marginTop='"_tEl.marginTop_"'")
			}
			if (tEl.marginBottom'="") {
				Do pOutput.WriteLine(" marginBottom='"_tEl.marginBottom_"'")
			}
			if (tEl.marginLeft'="") {
				Do pOutput.WriteLine(" marginLeft='"_tEl.marginLeft_"'")
			}
			if (tEl.marginRight'="") {
				Do pOutput.WriteLine(" marginRight='"_tEl.marginRight_"'")
			}
			if (tEl.markersVisible'="") {
				Do pOutput.WriteLine(" markersVisible='"_tEl.markersVisible_"'")
			}
			if (tEl.plotToEdge'="") {
				Do pOutput.WriteLine(" plotToEdge='"_tEl.plotToEdge_"'")
			}
			if (tEl.bandUpper'="") {
				Do pOutput.WriteLine(" bandUpper='"_tEl.bandUpper_"'")
			}
			if (tEl.bandLower'="") {
				Do pOutput.WriteLine(" bandLower='"_tEl.bandLower_"'")
			}
			if (tEl.bandUpperStyle'="") {
				Do pOutput.WriteLine(" bandUpperStyle='"_tEl.bandUpperStyle_"'")
			}
			if (tEl.bandLowerStyle'="") {
				Do pOutput.WriteLine(" bandLowerStyle='"_tEl.bandLowerStyle_"'")
			}
			if (tEl.plotStyle'="") {
				Do pOutput.WriteLine(" plotStyle='"_tEl.plotStyle_"'")
			}
			if (tEl.markerStyle'="") {
				Do pOutput.WriteLine(" markerStyle='"_tEl.markerStyle_"'")
			}
			if (tEl.%Extends("%DeepSee.Report.Model.Chart.BarChart")) {
				if (tEl.chartStacked'="") {
					Do pOutput.WriteLine(" chartStacked='"_tEl.chartStacked_"'")
				}
				if (tEl.chartPivot'="") {
					Do pOutput.WriteLine(" chartPivot='"_tEl.chartPivot_"'")
				}

			} elseif (tEl.%Extends("%DeepSee.Report.Model.Chart.LineChart")) {
				if (tEl.chartStacked'="") {
					Do pOutput.WriteLine(" chartStacked='"_tEl.chartStacked_"'")
				}
				if (tEl.chartPivot'="") {
					Do pOutput.WriteLine(" chartPivot='"_tEl.chartPivot_"'")
				}
				if (tEl.chartFilled'="") {
					Do pOutput.WriteLine(" chartFilled='"_tEl.chartFilled_"'")
				}
								
			} elseif (tEl.%Extends("%DeepSee.Report.Model.Chart.PieChart")) {
				if (tEl.labelValues'="") {
					Do pOutput.WriteLine(" labelValues='"_tEl.labelValues_"'")
				}

			}
			Do pOutput.WriteLine(" >")
			Do ..DisplayAxes(tEl.children,pOutput)
			Do pOutput.WriteLine(tEl.tagEnd)
		}

		
		
	}
}

ClassMethod DisplayStyle(pEl As %DeepSee.Report.Model.Stylable, pOutput As %Stream.GlobalCharacter)
{
	If (pEl.style'="") {
		Do pOutput.Write(" style='"_pEl.style_"'")
	}
	If (pEl.htmlstyle'="") {
		Do pOutput.Write(" style='"_pEl.htmlstyle_"'")
	}
	If (pEl.xslfostyle'="") {
		Do pOutput.Write(" style='"_pEl.xslfostyle_"'")
	}

	If (pEl.class'="") {
		Do pOutput.Write(" class='"_pEl.class_"'")
	}
}

/// Given a report class name, return the contents of its ReportModel XData block
/// as a stream.
ClassMethod %GetModelStream(pClassName As %String, Output pSC As %Status) As %Stream.Object [ Internal ]
{
	Set pSC = $$$OK
	Set tStream = ""
	Try {
		// pClassName is the name of a ZenReport class, try to find it
		If ('##class(%Dictionary.ClassDefinition).%ExistsId(pClassName)) {
			Set pSC = $$$ERROR($$$GeneralError,"Report class does not exist: " _ pClassName)
			Quit
		}
		Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(pClassName)

		Set tIndex = cdef.XDatas.FindObjectId(cdef.Name_"||ReportModel")
		// xdata not found, quit
		If (tIndex = "") {
			Quit
		}

		// get XDATA as stream
		Set tStream = cdef.XDatas.GetAt(tIndex).Data
		If ($IsObject(tStream)) {
			Do tStream.Rewind()
		}
	}
	Catch(ex) {
		Set pSC = ex.AsStatus()
		Set tStream = ""
	}
	Quit tStream
}

/// Given the name of a DeepSee report, open an instance
/// of the report model that created it.
ClassMethod %OpenReportModel(pReportName As %String, Output pModel As %DeepSee.Report.Model.Report) As %Status
{
	Set tSC = $$$OK
	Set pModel = ""
	Try {
		Set tClassName = ..%ReportNameToClassName(pReportName)
		Set tStream = ..%GetModelStream(tClassName,.tSC)
		If $$$ISERR(tSC) {
			Quit
		}

		// render the stream into a report model (with children)
		Set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tStream)
		If $$$ISERR(tSC) Quit
		Do tReader.Correlate("model","%DeepSee.Report.Model.Report")

		#; there should only be one model defined
		Do tReader.Next(.pModel,.tSC)
		If $$$ISERR(tSC) Quit
		If '$IsObject(pModel) {
			Set tSC = $$$ERROR($$$GeneralError,"No <model> element defined in ReportModel block: " _ tClassName)
			Quit
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Set pModel = ""
	}
	Quit tSC
}

ClassMethod DisplayAxes(list, pOutput As %Stream.GlobalCharacter)
{
	For a = 1:1:list.Count() {
		Set tAxis = list.GetAt(a)
		w !," processing axis list class="_tAxis.%ClassName(1)
		if (tAxis.%Extends("%DeepSee.Report.Model.Chart.Axis")) {
			Do pOutput.WriteLine(tAxis.tagBegin)
			if (tAxis.minValue'="") {
				Do pOutput.WriteLine(" minValue='"_tAxis.minValue_"'")
			}
			if (tAxis.maxValue '="") {
				Do pOutput.WriteLine(" maxValue ='"_tAxis.maxValue _"'")
			}
			if (tAxis.minValueDisplacement '="") {
				Do pOutput.WriteLine(" minValueDisplacement ='"_tAxis.minValueDisplacement _"'")
			}
			if (tAxis.maxValueDisplacement '="") {
				Do pOutput.WriteLine(" maxValueDisplacement ='"_tAxis.maxValueDisplacement _"'")
			}
			if (tAxis.title '="") {
				Do pOutput.WriteLine(" title ='"_tAxis.title _"'")
			}
			if (tAxis.baseValue'="") {
				Do pOutput.WriteLine(" baseValue='"_tAxis.baseValue_"'")
			}
			if (tAxis.majorUnits '="") {
				Do pOutput.WriteLine(" majorUnits ='"_tAxis.majorUnits _"'")
			}
			if (tAxis.minorUnits '="") {
				Do pOutput.WriteLine(" minorUnits ='"_tAxis.minorUnits _"'")
			}
			if (tAxis.labelUnits '="") {
				Do pOutput.WriteLine(" labelUnits ='"_tAxis.labelUnits _"'")
			}
			if (tAxis.labelAngle '="") {
				Do pOutput.WriteLine(" labelAngle ='"_tAxis.labelAngle _"'")
			}
			if (tAxis.majorGridLines '="") {
				Do pOutput.WriteLine(" majorGridLines ='"_tAxis.majorGridLines _"'")
			}
			if (tAxis.minorGridLines '="") {
				Do pOutput.WriteLine(" minorGridLines ='"_tAxis.minorGridLines _"'")
			}
			if (tAxis.labelStyle '="") {
				Do pOutput.WriteLine(" labelStyle ='"_tAxis.labelStyle _"'")
			}
			if (tAxis.textAnchor '="") {
				Do pOutput.WriteLine(" textAnchor ='"_tAxis.textAnchor _"'")
			}
			if (tAxis.labelValues '="") {
				Do pOutput.WriteLine(" labelValues ='"_tAxis.labelValues _"'")
			}
			if (tAxis.labelGroup '="") {
				Do pOutput.WriteLine(" labelGroup ='"_tAxis.labelGroup _"'")
			}
			if (tAxis.labelValue '="") {
				Do pOutput.WriteLine(" labelValue ='"_tAxis.labelValue _"'")
			}
			if (tAxis.majorGridStyle '="") {
				Do pOutput.WriteLine(" majorGridStyle ='"_tAxis.majorGridStyle _"'")
			}
			if (tAxis.minorGridStyle '="") {
				Do pOutput.WriteLine(" minorGridStyle ='"_tAxis.minorGridStyle _"'")
			}
			if (tAxis.labelDisplacement '="") {
				Do pOutput.WriteLine(" labelDisplacement ='"_tAxis.labelDisplacement _"'")
			}
			Do pOutput.WriteLine(" >")			
			Do pOutput.WriteLine(tAxis.tagEnd)
		}
	}
}

}
