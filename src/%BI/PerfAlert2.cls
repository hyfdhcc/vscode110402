Class %BI.PerfAlert2 [ Abstract, Not ProcedureBlock, StorageStrategy = StorageSQL, System = 4 ]
{

ClassMethod testDelAccCtrl(PerfId)
{
	d testDelAccCtrl^%bi.SWr.PerfMet2(PerfId)
}

ClassMethod UpdPerfAlert(PerfId, fldrId, nm, PerfMat, remark)
{
	d EditPerfAlert^%bi.SWr.PerfMet2(PerfId, fldrId, nm, PerfMat, remark)
}

ClassMethod testLoadAccCtrl(EditId, PerfId)
{
	d testLoadAccCtrl^%bi.SWr.PerfMet2(EditId, PerfId)
}

ClassMethod testSaveAccCtrl(fldrId, nm, PerfMat, remark)
{
	d testSaveAccCtrl^%bi.SWr.PerfMet2(fldrId, nm, PerfMat, remark)
}

ClassMethod UpdateStatus(chk, id, node)
{
	d UpdateStatus^%bi.SWr.PerfMet2(chk,id,node)
}

ClassMethod setpivTooWifJS()
{
 	do setpivToo^%bi.SWr.WebMain2(18)
	d LoadPivotTableJSCookTree^%bi.SWr.WebMain2(18)
}

ClassMethod testEditAccCtrl(objID, foldL, txtName, txtMet, txtRem)
{
	d testEditAccCtrl^%bi.SWr.PerfMet2(objID, foldL, txtName, txtMet, txtRem)
}

}
