Class %BI.WebAnalyzer [ Abstract, Not ProcedureBlock, System = 4 ]
{

// Variable and session usage

/*
%session.Data("AnlBaseCls")			-- Contains only the name of the Schema
%session.Data("AnalyzerBaseCls")	-- Contains the fullset of data/string for the schema, including ID,schema name, schema class and etc.
%session.Data("computeVals",x)		-- Holds all the compute node value, the tree cant hold these value so session will hold it.
%session.Data("allCmpVals")			-- Total compute nodes in computeVals session
%session.Data("metricVals",theI)	-- Holds all the metric node value, the tree cant hold these value so session will hold it.
%session.Data("allMetVals")			-- Total metric nodes in computeVals session
-- All the nodes selected and dropped into the dropped area of row/column/metric will be stored in these sessions.
-- It'll be retrieved later for analysis. If retrieved data is part of compute or metric then additional data will be drawn from the above session.
%session.Data("rowM",x)				-- for row
%session.Data("colM",x)				-- for column
%session.Data("metM",x)				-- for metrics
*/
ClassMethod calQuery(div1, div2, query)
{
	;s ^tmpStore("calQuery","query1") = query
	d calQuery^%bi.SWr.WebAnalyzer(div1,div2,query)
}

ClassMethod firstLoad(flFlag)
{
	s:(flFlag=0) %session.Data("firstLoad") = 0
}

ClassMethod setBaseCls(baseCls)
{
	s %session.Data("AnlBaseCls")=baseCls
}

ClassMethod setBaseCls1(baseCls)
{
	d setBaseCls1^%bi.SWr.WebAnalyzer(baseCls)
}

ClassMethod setDLClass(strIn, tabid)
{
	;s bsCLS = %session.Data("AnlBaseCls")
	s detID = $P(strIn,$C(2),1)
	s %session.Data("DLSelect",tabid) = detID
}

ClassMethod setDLClass2(strIn, tabid)
{
	// Created by Chun Eng on 20/7/2005
	// Description: To set temp %session.Data for temp detail listing selection
	s detID = $P(strIn,$C(2),1)
	s %session.Data("tmpDLSelect",tabid) = detID
}

ClassMethod DisplayList(tid)
{
	// Created on 05/01/05 by Kok Hong
	// Description: Display Detail Listing
	d DisplayList^%bi.SWr.WebAnalyzer(tid)
}

ClassMethod setDLC(sRtn, tid)
{
	// Created on 05/01/05 by Kok Hong
	// Description: Set the Detail Listing class
	d setDLC^%bi.SWr.WebAnalyzer(sRtn,tid)
}

ClassMethod genListing(rcCoor, pdID, currTabNo, inType)
{
	// Created on 04/01/05 by Kok Hong
	// Description: Generate Detail Listing
	;s %session.Data("DLDime",pdID,5) = 1
	;i (%session.Data("DLDime",pdID,5) = "") {
	/*
	i ($g(%session.Data("DLSelect",pdID)) = "") {
		w "alert('Please define Query Component for the Data Mart.');"
		w !,"noDL = 1;"		; Modified by Kok Hong on 24/11/04
	}
	else {
		w "noDL = 0;"		; Modified by Kok Hong on 24/11/04
	*/
		d genListing^%bi.SWr.WebAnalyzer(rcCoor, pdID, currTabNo, inType)
	//}
}

ClassMethod genListing2(QueryRow, QueryCol, rcDIM, cellInfo, pdID)
{
	
	i (%session.Data("DLDime",pdID,5) = "") {
		w "alert('Please define Query Component for the Data Mart.');"
		w !,"noDL = 1;"		; Modified by Kok Hong on 24/11/04
	}
	else {
		d genListing^%bi.SWr.WebAnalyzer(QueryRow,QueryCol,rcDIM,cellInfo,pdID)
		w "noDL = 0;"		; Modified by Kok Hong on 24/11/04
	}
}

ClassMethod genListing1(QueryRow As %String, QueryCol As %String, pdID As %String, cellId As %String)
{
	// Created by Kok Hong
	// Date: 20/09/2004
	i (%session.Data("DLDime",pdID,5) = "") {
		w "alert('Please define Query Component for the Data Mart.');"
		w !,"noDL = 1;"		; Modified by Kok Hong on 24/11/04
	}
	else {
		d genListing^%bi.SWr.WebAnalyzer(QueryRow,QueryCol,pdID,cellId)
		w "noDL = 0;"		; Modified by Kok Hong on 24/11/04
	}
}

// ---------------------------------------------------------------------

ClassMethod BuildTree(treeType)
{
	d BuildTree^%bi.SWr.WebAnalyzer(treeType)
}

// ddReport

ClassMethod ddReport(oriCoor, tableID, ddID, currentTab)
{
	d ddReport^%bi.SWr.WebAnalyzer(oriCoor,tableID,ddID,currentTab)
}

ClassMethod ddReport1(currentRow, rcDIM, ddID, tableid, cellInfo)
{
	d ddReport1^%bi.SWr.WebAnalyzer(currentRow,rcDIM,ddID,tableid,cellInfo)
}

ClassMethod ddReport2(tableid)
{
	
	s sessID = %session.%Id()
	i ($d(^mtemp(sessID,tableid))'=0 ){
		s pivID = $LG(^mtemp(sessID,tableid),5)
		s tabid = $tr(tableid," ","x")
		
		d initData^%bi.SMw.GridTable(sessID,pivID,tabid)
		
		w "displayType['"_tabid_"']=0;"

		d pData^%bi.SMw.GridTable(tabid,tableid)	
		w "DisplayTable('"_tabid_"',Grid_"_tabid_",1);"

	}
}

ClassMethod ddReport3(tableid)
{
	s sessID = %session.%Id()
	s pivID = "" //$LG(^mtemp(%session.%Id(),tableid),5)
	s tabid = $tr(tableid," ","x")
	
	d initData^%bi.SMw.GridTable(sessID,pivID,tabid)
	//w "displayType['"_tabid_"']=0;"
	d pData^%bi.SMw.GridTable(tabid,tableid)
	w "DisplayTable('"_tabid_"',Grid_"_tabid_",1);"
}

// Created on 03/01/04 by Kok Hong

ClassMethod DrillDown(tableID, valueSet, valueTxt, Coor, currentTab, inType)
{
	d DrillDown^%bi.SWr.WebAnalyzer(tableID,valueSet,valueTxt,Coor,currentTab,inType)
}

ClassMethod ColDrillDown(tableID, valueSet, valueTxt, Coor, currentTab, inType)
{
	d ColDrillDown^%bi.SWr.WebAnalyzer3(tableID,valueSet,valueTxt,Coor,currentTab,inType)
}

// Added by Kok Hong

// Date: 08/09/04

ClassMethod DrillDown1(filter, valueSet, valueText, lastQ, filterDIV, currentTable, tableid, cellInfo, rcDIM)
{
	
	d DrillDown^%bi.SWr.WebAnalyzer(filter,valueSet,valueText,lastQ,filterDIV,currentTable,tableid,cellInfo,rcDIM)
}

ClassMethod ExportToExcel(divId, tab, sid, type, drilldowninfo, filterinfo)
{
	d ExportToExcel^%bi.SMw.GridTable(divId,tab,sid,$G(type),$g(drilldowninfo),$g(filterinfo))
}

ClassMethod ExportToExcelAsChart(divId, tab, sid, type)
{
	d ExportToExcelAsChart^%bi.SMw.GridTable(divId,tab,sid,$G(type))
}

ClassMethod ExportToText(divId, currTabId, delim)
{
	d ExportToText^%bi.SMw.GridTable(divId,currTabId,delim)
}

// ----------------------------------------------------------------------

ClassMethod genDimeList()
{
	s currClass = %session.Get("AnalyzerBaseCls")
	D gUsrSMCat^%bi.SMr.DataMart2($P(currClass,$C(3),2))
	w "<option value=""""></option>"
	
	for I=1:1:$G(OLIST) {
		s Str = $P(OLIST(I),$C(4),2)
		s StrId = $P(OLIST(I),$C(4),1)
		w "<option value="_StrId_">"_Str_"</option>"
	}
}

ClassMethod LoadCompute()
{
	;s ^tmpStore("lpflag") = lpflag
	d LoadCompute^%bi.SWr.WebAnalyzer
}

ClassMethod loadMetric()
{
	d loadMetric^%bi.SWr.WebAnalyzer
}

ClassMethod loadOthers()
{
	w "<script language=javascript>"
	d loadDrillDowns^%bi.SWr.WebAnalyzer2
	w "</script>"
}

ClassMethod loadMetricSel()
{
	d loadMetricSel^%bi.SWr.WebAnalyzer
}

ClassMethod setMenuTree(trgt, valueSet, valueTxt, valueSet2, frmTrgt)
{
	d setMenuTree^%bi.SWr.WebAnalyzer(trgt, valueSet, valueTxt, valueSet2, frmTrgt)
	;w "debug('" _ trgt _ "," _ valueSet _ "," _ valueTxt _ "," _ frmTrgt_ "');"
}

ClassMethod editMenuTree(trgt, valueSet, valueTxt)
{
	d editMenuTree^%bi.SWr.WebAnalyzer(trgt, valueSet, valueTxt)
}

ClassMethod editCondMenuTree(trgt, valueSet)
{
	d editCondMenuTree^%bi.SWr.WebAnalyzer(trgt, valueSet)
}

ClassMethod delNode(valueSet, trgt)
{
	w "timeOut=1;"
	d delNode^%bi.SWr.WebAnalyzer(valueSet, trgt)
}

ClassMethod setToZero()
{
	d setToZero^%bi.SWr.WebAnalyzer
}

ClassMethod clearCriteria(critC)
{
	d clearCriteria^%bi.SWr.WebAnalyzer(critC)
}

ClassMethod doFind(wd, ht, topN, lkUnionRpt, fg, ag, gT, sT, SQLVal)
{
	
	;k ^tmpStore
	;k ^mtemp("SM",$j)
	s rs = 0, cs = 0
	s tTabID = "showMe"
	;s lkR = 
	;s %session.Data("chtType") = 0
	s wLnkRpt = $P(lkUnionRpt,$c(1),1)
	s wLnkRpt = $$removeNotAllowedPiv^%bi.SWr.WebAnalyzer2(wLnkRpt)
	s wUnionRpt = $P(lkUnionRpt,$c(1),2)
	s wUnionRpt = $$removeNotAllowedPiv^%bi.SWr.WebAnalyzer2(wUnionRpt)
	s wDrillDn = $P(lkUnionRpt,$c(1),3)
	s wDrillDn = $$removeNotAllowedPiv^%bi.SWr.WebAnalyzer2(wDrillDn)
	s wNestedRpt = $P(lkUnionRpt,$C(1),4)
	s wNestedRpt = $$removeNotAllowedPiv^%bi.SWr.WebAnalyzer2(wNestedRpt)
	s %session.Data("colLink") = wLnkRpt
	s %session.Data("unionRpt") = wUnionRpt
	s %session.Data("ddRpt",tTabID) = wDrillDn
	s %session.Data("nestedRpt") = wNestedRpt
	s %session.Data("SQLVal",tTabID) = $g(SQLVal)
	w "ddRpt.value = '"_wDrillDn_"';"
	w "lnkRpt.value = '"_wLnkRpt_"';"
	w "unionRpt.value = '"_wUnionRpt_"';"
	w "nestedRpt = '"_wNestedRpt_"';"
	
	s %session.Data("P8")=$P(lkUnionRpt,$c(1),1)_$c(3)_"0"_$c(3)_$P(lkUnionRpt,$c(1),2)_$c(3)_$P($g(%session.Data("rcGrouping",tTabID)),$c(3),1)_$c(3)_$P($g(%session.Data("rcGrouping",tTabID)),$c(3),2)
	s %session.Data("Width")=wd
	s %session.Data("Height")=ht
	
	// topN is split by $C(2); #1 - Top/Bottom (0/1), #2 - Numbers of row, #3 - Which column, #4 - Remaining classification
	s %session.Data("P6",1)=$P(topN,$C(2),1)
	s %session.Data("P6",2)=$P(topN,$C(2),2)
	s %session.Data("P6",3)=$P(topN,$C(2),3)
	s %session.Data("P6",4)=$P(topN,$C(2),4)
	s %session.Data("P6",5)=$P(topN,$C(2),5)
	
	;if (fg = 0) k %session.Data("lastQuery")
	
	; Grand & Sub Aggregate
	s %session.Data("gT")=$g(gT)
	s %session.Data("sT")=$g(sT)
	
	s r=""
	f {
		s r=$o(%session.Data("rowM",r))
		q:((r="") || (rs=1))
		s:(%session.Data("rowM",r)'["c$") rs = 1
	}
	
	s c=""
	f {
		s c=$o(%session.Data("colM",c))
		q:((c="") || (cs=1))
		
		s:(%session.Data("colM",c)'["c$") cs = 1
	}
	
	/*i (%session.Get("rowM") = 0) {
		w !, "alert('Please select a dimension for row');"
		w !, "norowselected = 1;"
	}
	if ((%session.Get("rowM") '= 0) && (rs=0)) {
		w !, "alert('Please select at least one dimension for row');"
		w !, "norowselected = 1;"
	}
	elseif ((cs=0) && (%session.Data("colM") '= 0)) {
		w !, "alert('Please select at least one dimension for column');"
		w !, "norowselected = 1;"
	}
	else {*/
		;s ^mtemp("GridID",$j)="showMe"
		w !,"showMe.innerHTML = '';"
		;w !,"showMe1.innerHTML = '';"
		;w !,"P1.innerHTML = '&nbsp;';"
		;w !,"P2.innerHTML = '&nbsp;';"
		d doFind^%bi.SWr.WebAnalyzer
		;s jobid = $g(%session.Data("jobID"))
		;i (ag '= 0) d doAggregate^%bi.SWr.WebAggregate(jobid,ag)	// Added by Kok Hong on 06/12/04
		; Modified by Kok Hong on 24/11/04
		;d ##class(%BI.WebChartList).setChtLi($g(%session.Data("chtType")))
		w !, "norowselected = 0;"
	;}
}

// For filter window function

// Used to use ^%bi.SWr.WebAnalyzer

ClassMethod loadConditionJS(measureID, condBegin)
{
	d loadConditionJS^%bi.SWr.WebEditQueryCom(measureID, $G(condBegin))
}

ClassMethod addToFilter(query)
{
	d addToFilter^%bi.SWr.WebEditQueryCom(query)
}

ClassMethod UndoFilter()
{
	d UndoFilter^%bi.SWr.WebEditQueryCom
}

ClassMethod RedoFilter()
{
	d RedoFilter^%bi.SWr.WebEditQueryCom
}

ClassMethod clearQuery()
{
	s chc = %session.Get("filterCHC")
	i chc=1 {
		s %session.Data("currLn") = 0
		s %session.Data("tFilter") = 0
		s %session.Data("lastQuery")=""
	} else {
		s %session.Data("currLn2") = 0
		s %session.Data("tFilter2") = 0
		s %session.Data("tmpFilter")=""
	}
}

ClassMethod genDLDime(pivotID As %String, tableID As %String, cFilter As %String, vFilter As %String, currentTable As %String)
{
	d genDLDime^%bi.SWr.WebAnalyzer(pivotID,tableID,cFilter,vFilter,currentTable)
}

ClassMethod loadFilterTree(trgt As %String)
{
	d loadFilterTree^%bi.SWr.WebAnalyzer(trgt)
}

ClassMethod resetQueryCnt()
{
	d resetQueryCnt^%bi.SWr.WebEditQueryCom
	;d resetQueryCnt^%bi.SWr.WebAnalyzer
}

ClassMethod recountQueryCnt(query)
{
	d recountQueryCnt^%bi.SWr.WebEditQueryCom(query)
	;d recountQueryCnt^%bi.SWr.WebAnalyzer(query)
}

ClassMethod recountQueryCntwClass(currClass, query)
{
	//w "alert('currClass = "_currClass_"');"
	//d recountQueryCnt^%bi.SWrt.WebEditQuery(currClass,query)
	d recountQueryCnt^%bi.SWr.WebAnalyzer(query)
}

// Save Query

ClassMethod saveFilter(queryCom, meaName, cdName)
{
	d saveFilter^%bi.SWr.WebAnalyzer(queryCom, meaName, cdName)
}

ClassMethod setGrouping(str As %String)
{
	s %session.Data("rcGrouping","showMe") = str
}

ClassMethod BuildTree2(class)
{
	d BuildTree^%bi.SWrt.WebEditQuery(class)
}

ClassMethod reshuffROWCOL(P0, P1, P2)
{
	w "timeOut=1;"
	d reshuffROWCOL^%bi.SWr.WebAnalyzer2(P0,P1,P2)
}

ClassMethod getFProp2ROWCOL(P0, P1)
{
	w "timeOut=1;"
	s fP = $$getFProp2ROWCOL^%bi.SWr.WebAnalyzer2(P0,P1)
	q fP
}

ClassMethod setFProp2ROWCOL(P0, P1, P3)
{
	d setFProp2ROWCOL^%bi.SWr.WebAnalyzer2(P0,P1,P3)
}

ClassMethod svDrillDn(P0, P1, P2, P3)
{
	w "timeOut=1;"
	d svDrillDn^%bi.SWr.WebAnalyzer2(P0,P1,P2,P3)
}

ClassMethod ReturnSession()
{
	d ReturnSession^%bi.SWr.WebAnalyzer4
}

ClassMethod canAccessAnalyzer()
{
	
	q $$canAccessAnalyzer^%bi.SWr.WebAnalyzer4()
}

ClassMethod canOpenPivot()
{
	
	q $$canOpenPivot^%bi.SWr.WebAnalyzer4()
}

ClassMethod setPrevSession()
{
	; Whenever analyzer.csp is invoked, the %session.Data("currLocation") is set as analyzer.csp
	; Senario ~ from dashboard button to invoke analyzer and then navigate away 
	; %session.Data("currLocation") should set as dashboard.csp instead of analyzer.csp
	; Solution - %session.Data("prevLocation") is used at setCurrPage^%bi.SWr.WebMain for analyzer
	if $g(%session.Data("prevLocation")) = "dashboard.csp" ,  $g(%session.Data("currLocation")) = "analyzer.csp" {
		s %session.Data("currLocation") = "dashboard.csp"
	}

	k %session.Data("prevLocation")
}

}
