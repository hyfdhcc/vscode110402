Class %BI.WebAnalyzerSetup [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod HideColumn(colNo, tid)
{
	d HideColumn^%bi.SWr.WebAnalyzerSetup(colNo,tid)
}

ClassMethod ShowColumn(tid)
{
	d ShowColumn^%bi.SWr.WebAnalyzerSetup(tid)
}

ClassMethod HideRow(rowNo, tid)
{
	d HideRow^%bi.SWr.WebAnalyzerSetup(rowNo,tid)
}

ClassMethod ShowRow(tid)
{
	d ShowRow^%bi.SWr.WebAnalyzerSetup(tid)
}

ClassMethod setSess(tabid)
{
	//s ^tmpStore("loadSetup","tabid") = $g(tabid)
	//d loadSetup^%bi.SWr.WebAnalyzerSetup(tabid)
	s %session.Data("SetupNow") = $g(tabid)
	s sessID = %session.%Id()
	;s ^tmpStore("setSess","tabid") = tabid
	;s ^tmpStore("setSess","sessID") = sessID
	s pivSID = $P($g(^mtemp("pivotID",sessID,tabid)),$c(4),1)
	;s ^tmpStore("setSess","pivSID") = pivSID
	
	;w "pivSID = '"_pivSID_"';"
	w "pivSID = '"_pivSID_"';"
}

// ClassMethod loadSetup(tabid)

ClassMethod loadSetup()
{
	;d loadSetup^%bi.SWr.WebAnalyzerSetup(tabid)
	d loadSetup^%bi.SWr.WebAnalyzerSetup()
}

ClassMethod saveColWidthC(col1, col2, tabid)
{
	d saveColWidthC^%bi.SWr.WebAnalyzerSetup(col1,col2,tabid)
}

ClassMethod saveSetup(inData, saveType, pivID)
{
	d saveSetup^%bi.SWr.WebAnalyzerSetup(inData,saveType,pivID)
}

ClassMethod loadDDownGridSetup(dDownGridStat)
{
	d loadDDownGridSetup^%bi.SWr.WebAnalyzerSetup(dDownGridStat)
}

ClassMethod saveDDSetup(inData, saveType, pivID)
{
	d saveDDSetup^%bi.SWr.WebAnalyzerSetup(inData,saveType,pivID)
}

}
