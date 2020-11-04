Class %BI.WebKPIClass [ Abstract, Not ProcedureBlock, System = 4 ]
{

// done by chris 10/9/2004

ClassMethod displayKPIvalue(id)
{
	d displayKPIvalue^%bi.SWrt.KPI(id)
}

ClassMethod UpdateKPI(queryVal, formulaVal, file, folderid, min, max, activate, strschema, strmeasure, kpiDR)
{

	d UpdateKPI^%bi.SWrt.KPI(queryVal,formulaVal,file,folderid,min,max,activate,strschema,strmeasure, kpiDR)
}

ClassMethod AddNewKPI(query, formula, filename, folderid, min, max, activate, strschema, strmeasure, kpiDR)
{

	d AddNewKPI^%bi.SWrt.KPI(query,formula,filename,folderid,min,max,activate,strschema,strmeasure, kpiDR)
}

ClassMethod LoadPivotTableJS()
{
	
	d LoadPivotTableJS^%bi.SWrt.KPI()
}

ClassMethod LoadPivotTable()
{
	
	d LoadPivotTable^%bi.SWrt.KPI()
}

ClassMethod delKPI(KPIId)
{
	
	d delKPI^%bi.SWrt.KPI(KPIId)
}

ClassMethod LoadFormula(id As %String)
{
	
	d LoadFormula^%bi.SWrt.KPIFormula(id)
}

ClassMethod KPIListIsFolder(valset As %String) As %Boolean
{
	
	q $$IsFolder^%bi.SWrt.KPI(valset)
}

ClassMethod RenFolderName(folderId As %String, folderName As %String)
{
	
	d RenFolderName^%bi.SWrt.KPI(folderId,folderName)
}

ClassMethod DelFolder(folderId As %String)
{
	
	d DelFolder^%bi.SWrt.KPI(folderId)
}

ClassMethod FromKPIListToSession(TreeTxt As %String, Treeval As %String) As %Boolean
{
	if (TreeTxt'="" & Treeval'=""){	
	do %session.Set("KPIDetailsNameTxt",TreeTxt)
 	do %session.Set("KPIDetailsNameValue",Treeval)
 	q 1
	}
	q 0
}

ClassMethod HiliteRow(val As %String, onTarget As %String)
{
	
	d HiliteRow^%bi.SWrt.KPIChild(val, onTarget)
}

ClassMethod AddKPIChildList(val, folderId, KPIChildId) As %Boolean
{
	if ((val'="")&&(folderId'="")){
		d AddKPIChildList^%bi.SWrt.KPIChild(val,folderId,KPIChildId)
		q 1
	}
	q 0
}

ClassMethod UpdateKPICaption(i, caption) As %Boolean
{
	if ((i'="")&&(caption'="")){
		d UpdateKPICaption^%bi.SWrt.KPIChild(i,caption)
		q 1
	}
	q 0
}

ClassMethod DeleteKPIChildList(val) As %Boolean
{
	if (val'=""){
		d DeleteKPIChildList^%bi.SWrt.KPIChild(val)
		q 1
	}
	q 0
}

ClassMethod moveKPIChildList(mypos, pos) As %Boolean
{
	if (mypos'=""&&pos'=""){
		d Swap^%bi.SWrt.KPIChild(mypos,pos)
		q 1
	}
	q 0
}

ClassMethod ChildListGenerator()
{
	
	d ChildListGenerator^%bi.SWrt.KPIChild()
}

ClassMethod KillChildListSession()
{
	
	d KillChildListSession^%bi.SWrt.KPIChild()
}

ClassMethod BuildTreeJS(treeType As %String) As %Boolean
{
	if (treeType'=""){	
	//d BuildTreeJS^%bi.SWrt.WebAnalyzer("1")
	d BuildTreeJS^%bi.SWrt.KPI("1")
 	q 1
	}
	q 0
}

ClassMethod ColorSelector(divTag As %String, color As %String) As %Boolean
{
	if (divTag'=""){	
	d ColorSelector^%bi.SWrt.KPIValueRange(divTag,color)	
 	q 1
	}
	q 0
}

ClassMethod ClearKPIVRCell(i, divTag, type) As %Boolean
{
	
	d ClearKPIVRCell^%bi.SWrt.KPIValueRange(i,divTag,type)
}

ClassMethod KillValueRangeSession()
{

	d KillValueRangeSession^%bi.SWrt.KPIValueRange
}

ClassMethod ValueRangeSessionGenerator()
{
	d KillValueRangeSession^%bi.SWrt.KPIValueRange
	d ValueRangeSessionGenerator^%bi.SWrt.KPIValueRange
}

ClassMethod KPIKilladdLine()
{
	d KPIKilladdLine^%bi.SWrt.KPIValueRange
}

ClassMethod KPIVRaddLine()
{
	d KPIVRaddLine^%bi.SWrt.KPIValueRange("aa")
}

ClassMethod KPIVRdeleteLine(LineNo)
{
	d KPIVRdeleteLine^%bi.SWrt.KPIValueRange(LineNo)
}

ClassMethod KPIVRgetImageName(id As %String, propertyName As %String)
{
	d KPIVRgetImageName^%bi.SWrt.KPIValueRange(id,propertyName)
}

ClassMethod UpdateVRSession(i As %String, type As %String, value As %String)
{
	d UpdateVRSession^%bi.SWrt.KPIValueRange(i,type,value)
}

ClassMethod UpdateVRFontSession(i, FontName, FontBold, FontItalic, FontSize, FontUnderline, FontStrikethru)
{
	d UpdateVRFontSession^%bi.SWrt.KPIValueRange(i,FontName,FontBold,FontItalic,FontSize,FontUnderline,FontStrikethru)
}

ClassMethod UpdateValueRange()
{
	
	d UpdateValueRange^%bi.SWrt.KPIValueRange
}

ClassMethod AddNewValueRange()
{
	
	d AddNewValueRange^%bi.SWrt.KPIValueRange
}

ClassMethod ValueRangeGenerator(KPIId)
{
	
	d ValueRangeGenerator^%bi.SWrt.KPIValueRange(KPIId)
}

ClassMethod setVRRow(i As %String) As %Boolean
{
	d ValueRangeGenerator^%bi.SWrt.KPIValueRange(KPIId)
}

ClassMethod loadMetricJS() As %Boolean
{
	if (treeType'=""){	
	//d loadMetricJS^%bi.SWr.WebAnalyzer()
	d loadMetricJS^%bi.SWrt.KPI()
 	q 1
	}
	q 0
}

ClassMethod FromSessionToKPIDetails() As %Boolean
{
	
	if (%session.Get("KPIDetailsNameTxt")'=""){
		write "txtName.value = ",##class(%CSP.Page).QuoteJS(%session.Get("KPIDetailsNameTxt")),";",!
		if %session.Get("KPIDetailsFolder")=""{
			write "txtSelectFolder.value = 'KPI';",!
		
		}
		
			
		
	}
	d createSelectClassJS^%bi.SWrt.KPI("selectOne","1")
	//d createSelectClassJS^%bi.SWrt.KPI("selectMeasure","1")
	d createSelectMeasureJS^%bi.SWrt.KPI("selectMeasure","1")
	q 1
}

ClassMethod createSelectMeasureJS()
{
	d createSelectMeasureJS^%bi.SWrt.KPI("selectMeasure","1")
}

ClassMethod loadClasses()
{
	d loadClasses^%bi.SWrt.KPI
}

ClassMethod UndoFilter()
{
	//w "alert('undo')"
	d UndoFilter^%bi.SWr.WebEditQueryCom
}

ClassMethod RedoFilter()
{
	//w "alert('redo')"
	d RedoFilter^%bi.SWr.WebEditQueryCom
}

ClassMethod createSelectJS(SelectName, Selected)
{
	d createSelectJS^%bi.SWrt.KPI(SelectName, Selected)
}

ClassMethod createSelectOnLoad(SelectName, Selected)
{
	
	d createSelectOnLoad^%bi.SWrt.KPI(SelectName,Selected)
}

ClassMethod a()
{
	w "str="""
	d ##class(%BI.WebEditQueryCom).genConditionCom(1)
	w """;"
}

ClassMethod xxxxloadConditionJS(measureID, condBegin, myDiv)
{
	
	//loadConditionJS(measureID, condBegin, DivTag, DivIdName, DblClick, OnClick)
	//d loadConditionJS^%bi.SWr.WebEditQueryCom(measureID, $G(condBegin))
	//d loadConditionJS^%bi.SWrt.KPIQuery(measureID, $G(condBegin), "help")

	d loadConditionJS^%bi.SWrt.KPIQuery(measureID, $G(condBegin), myDiv,"lNm","addCond","hiLiteMe")
	//		DivIdName, DblClick = addCond DivIdName = 1Nm
}

ClassMethod addToFilter(query)
{
	d addToFilter^%bi.SWr.WebEditQueryCom(query)
}

ClassMethod genDMForm()
{
	s currPg = %session.Get("currLocation")
	i currPg=8 {	
		d genDMForm^%bi.SWr.WebEditQueryCom
	}
}

ClassMethod GetTreeItem(onTarget, valueSet, valueTxt)
{
	if (onTarget'=""&&valueSet'=""&&valueTxt'=""){
		d GetTreeItem^%bi.SWrt.KPIValueRange(onTarget,valueSet,valueTxt)
	}
}

ClassMethod setKPIId(val)
{
	d setKPIId^%bi.SWrt.KPI(val)
}

ClassMethod resetQuery()
{
	//d resetQueryCnt^%bi.SWr.WebEditQueryCom
	d resetQueryCnt^%bi.SWr.WebEditQueryCom
}

ClassMethod UpdateChildList()
{
	d UpdateChildList^%bi.SWrt.KPIChild()
}

ClassMethod AddNewChildList()
{
	d AddNewChildList^%bi.SWrt.KPIChild()
}

Method SearchFileName(Filename) As %Boolean
{

	 q $$SearchFileName^%bi.SWrt.KPI(Filename)
}

ClassMethod setBaseCls()
{
	//d resetQueryCnt^%bi.SWr.WebEditQueryCom
	d setBaseCls^%bi.SWrt.KPI
}

ClassMethod setSelectBaseCls(id)
{
	//d resetQueryCnt^%bi.SWr.WebEditQueryCom
	d setSelectBaseCls^%bi.SWrt.KPI(id)
}

}
