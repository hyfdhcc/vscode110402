Class %BI.WebPivTable [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod regenGrid(P0, P1, P2, P3)
{
	d regenGrid^%bi.SWr.WPivotTable(P0,P1,P2,P3)
}

ClassMethod setTheData(P0, P1, P2)
{
	d setTheData^%bi.SWr.WPivotTable(P0,P1,P2)
}

ClassMethod setTheColV(P0, P1)
{
	d setTheColV^%bi.SWr.WPivotTable(P0,P1)
}

ClassMethod setTheRowV(P0, P1)
{
	d setTheRowV^%bi.SWr.WPivotTable(P0,P1)
}

ClassMethod savePivot(P0, P1, P2, P3, P4)
{
	d savePivot^%bi.SWr.WPivotTable(P0,P1,P2,P3,P4)
}

ClassMethod loadAsPivot(P0)
{
	d loadAsPivot^%bi.SWr.WPivotTable(P0)
}

ClassMethod newFlexPivot()
{
	d newFlexPivot^%bi.SWr.WPivotTable
}

ClassMethod addFilterToList(P0)
{
	d addFilterToList^%bi.SWr.WPivotTable(P0)
}

ClassMethod delFilterList(P0)
{
	d delFilterList^%bi.SWr.WPivotTable(P0)
}

ClassMethod editFilterList(P0, P1)
{
	d editFilterList^%bi.SWr.WPivotTable(P0,P1)
}

ClassMethod getFilterID(P0)
{
	d getFilterID^%bi.SWr.WPivotTable(P0)
}

ClassMethod delPivTable(P0)
{
	w "timeOut=1;"
	d delPivTable^%bi.SWr.WPivotTable(P0)
}

ClassMethod droppedOnXY(P0, P1, P2, P3, P4, P5)
{
	d droppedOnXY^%bi.SWr.WPivotTable(P0,P1,P2,P3,P4,P5)
}

ClassMethod loadConditionJS(P0, P1)
{
	d loadConditionJS^%bi.SWr.WPivotTable(P0,P1)
}

ClassMethod loadMetric()
{
	d loadMetric^%bi.SWr.WPivotTable
}

ClassMethod deleteARow()
{
	d deleteARow^%bi.SWr.WPivotTable
}

}
