Class %BI.WebAnalyzer2 [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod changeAgg()
{
	d changeAgg^%bi.SWr.WebAnalyzer2()
}

ClassMethod saveSetup(fdata)
{
	d saveSetup^%bi.SWr.WebAnalyzer2(fdata)
}

ClassMethod setPivot(saveType)
{
	d setPivot^%bi.SWr.WebAnalyzer2(saveType)
}

// Added by Kok Hong on 02/12/04

// Description: Store the filter into the session "lastQuery"

ClassMethod setMetric(filData)
{
	s %session.Data("lastQuery") = $g(filData)
	;d recountQueryCnt^%bi.SWr.WebAnalyzer($g(filData))
	d calQuery^%bi.SWr.WebAnalyzer("qCount","qPercent",$g(filData))
}

ClassMethod setTheMetric(chc, xtra, filter)
{
	//s ^ATest("filter")=filter
	s %session.Data("lastQuery")=$G(filter)
	//s ^ATest("filter2")=$g(%session.Data("lastQuery"))
	d setTheMetric^%bi.SWr.WebAnalyzer2(chc,xtra)
}

ClassMethod setMyClass(myCls)
{
	s %session.Data("MyClass")=myCls
	//s %session.Data("AnalyzerBaseCls")=myCls
}

ClassMethod getDListClass(DLnum)
{
	d getDListClass^%bi.SWr.WebAnalyzer2(DLnum)
}

ClassMethod setMyClass2(myCls)
{
	if ($g(%session.Data("MyClass"))'="")
	{
		s myCls=$g(%session.Data("MyClass"))
	}
	
	s %session.Data("MyClass")=myCls
	s %session.Data("AnalyzerBaseCls")=myCls
}

ClassMethod setTheMetric2(chc, xtra, filter)
{
	s %session.Data("tmpFilter") = $G(filter)
	d setTheMetric^%bi.SWr.WebAnalyzer2(chc,xtra)
}

ClassMethod UndoFilter()
{
	d UndoFilter^%bi.SWr.WebAnalyzer2
}

ClassMethod RedoFilter()
{
	d RedoFilter^%bi.SWr.WebAnalyzer2
}

ClassMethod resetQueryCnt()
{
	d resetQueryCnt^%bi.SWr.WebAnalyzer2
}

ClassMethod loadStatusLog(objID)
{
	d loadStatusLog^%bi.SWr.WebAnalyzer2(objID)
}

ClassMethod loadAsPivot(pivobj)
{
	d loadAsPivot^%bi.SWr.WebAnalyzer2(pivobj)
}

ClassMethod newPivot2()
{
	// Modified by Daniel on 13-01-05
	w "<script language=javascript>"
	d newPivot2^%bi.SWr.WebAnalyzer2
	w "</script>"
}

ClassMethod newPivot()
{
	w "timeOut=1;"
	d newPivot^%bi.SWr.WebAnalyzer2
}

// Modified by Kok Hong on 20-09-04

ClassMethod saveAsPivot(pvtName, pvtNotes, isStatica, cFoldid, folderName, wd, ht, topNSelectValA, unilkR, valueSet, pivID, gColWidth, grandVal, subVal, SQLVal)
{
	w "timeOut=1;"
	d saveAsPivot^%bi.SWr.WebAnalyzer2(pvtName, pvtNotes, isStatica, cFoldid, folderName, wd, ht, topNSelectValA, unilkR, valueSet, pivID, gColWidth, grandVal, subVal, SQLVal,"ana")
}

ClassMethod saveDA(tid, pivotTableID)
{
	d saveDA^%bi.SWr.WebAnalyzer2(tid,pivotTableID)
}

ClassMethod saveGS(tid, pivotTableID)
{
	d saveGS^%bi.SWr.WebAnalyzer2(tid,pivotTableID)
}

ClassMethod delPiv(pivID, rClick, all)
{
	w "timeOut=1;"
	d delPiv^%bi.SWr.WebAnalyzer2(pivID,rClick,all)
}

ClassMethod delPiv2(pivID, rClick, all)
{
	w "timeOut=1;"
	d delPiv2^%bi.SWr.WebAnalyzer2(pivID,rClick,all)
}

ClassMethod setChartCol(tid, tabNo, oriCoor, dimType)
{
	d setChartCol^%bi.SWr.WebAnalyzer2(tid,tabNo,oriCoor,dimType)
}

ClassMethod deleteDOther(P0)
{
	d deleteDOther^%bi.SWr.WebAnalyzer2(P0)
}

ClassMethod setClsSess(pivID, oriCoor, tid)
{
	d setClsSess^%bi.SWr.GridTable1(pivID,oriCoor,tid)
}

ClassMethod genPDF(pivID, tid)
{
	d genPDF^%bi.SWr.GridTable1(pivID,tid)
}

ClassMethod swapRowCol()
{
	d swapRowCol^%bi.SWr.WebAnalyzer3
}

ClassMethod refFilterTrig(objID, oriCoor, ddNum)
{
	i %session.Data("currLocation")'="analyzer.csp" {
		d refFilterTrig^%bi.SWr.WebAnalyzer3(objID,oriCoor,ddNum)
	}
}

ClassMethod loadNewSubjAreaForCurrPivot(P0)
{
	d loadNewSubjAreaForCurrPivot^%bi.SWr.WebAnalyzer4(P0)
}

ClassMethod GetRelatedClass()
{
	w $$GetRelatedClass^%bi.SWr.WebAnalyzer4($$getClass^%bi.SWr.WebEditQueryCom)
}

ClassMethod BuildMultiPassTree(cls, name)
{
	d BuildMultiPassTree^%bi.SWr.WebAnalyzer4(cls,name)
}

}
