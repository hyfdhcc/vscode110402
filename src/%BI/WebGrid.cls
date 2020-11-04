Class %BI.WebGrid [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod StoreGlobal(inStr)
{
	k ^tmpGlobal
	s ^tmpGlobal = $g(inStr)
}

ClassMethod loadDDSelection(rcNo, tid, tabNo, inType)
{
	d loadDDSelection^%bi.SWr.WebGrid(rcNo,tid,tabNo,inType)
}

ClassMethod gotoPage(pageNum, tableid, ddLevel)
{
	d gotoPage^%bi.SWr.WebGrid(pageNum,tableid,ddLevel)
}

ClassMethod loadPivInfo(tid)
{
	d loadPivInfo^%bi.SWr.WebGrid(tid)
}

ClassMethod cellInfo(tableid, inCoor, curTab)
{
	d cellInfo^%bi.SWr.WebGrid(tableid,inCoor,curTab)
}

ClassMethod killRC(tid)
{
	k ^mtemp(%session.%Id(),tid,"RnC")
}

}
