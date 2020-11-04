Class %BI.GridChartDisplay [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadDisplayTypeJS(pivID)
{
	d loadDisplayTypeJS^%bi.SWr.GridChartDisplay(pivID)
}

ClassMethod SaveDisplayType(pivID, tid, gridPosition, cellSize, saveType)
{
	d saveDisplayType^%bi.SWr.GridChartDisplay(pivID,tid,gridPosition,cellSize,saveType)
}

ClassMethod getVal(tid)
{
	d getVal^%bi.SWr.GridChartDisplay(tid)
}

}
