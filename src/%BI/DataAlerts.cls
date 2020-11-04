Class %BI.DataAlerts [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod SaveData(tbody, tid, saveType)
{
	d SaveData^%bi.SWr.DataAlerts(tbody,tid,saveType)
}

ClassMethod LoadData(tid)
{
	d LoadData^%bi.SWr.DataAlerts(tid)
}

ClassMethod getImgName(imgID)
{
	; Added by Kok Hong on 15/03/05
	; Description: Get Image Name & Path
	d getImgName^%bi.SWr.DataAlerts(imgID)
}

ClassMethod getImgID(imgName)
{
	d getImgID^%bi.SWr.DataAlerts(imgName)
}

ClassMethod checkAccess(pivDAID)
{
	; To check whether the user have the access to the pivot
	d checkAccess^%bi.SWr.DataAlerts(pivDAID)
}

ClassMethod getFltr(tabID, rownum, colnum, type)
{
	d getFltr^%bi.SWr.DataAlerts(tabID,rownum,colnum,type)
}

ClassMethod openDashboard(dbID)
{
	d openDashBoard^%bi.SWr.DataAlerts(dbID)
}

ClassMethod openExcel(dbID)
{
	d openExcel^%bi.SWr.DataAlerts(dbID)
}

ClassMethod runScript(assoc)
{
	d runScript^%bi.SWr.DataAlerts(assoc)
}

ClassMethod runQScript(assoc, row, col, tabid)
{
	d runScript2^%bi.SWr.DataAlerts(assoc,row,col,tabid)
}

ClassMethod DASecurityCheck(type)
{
	d DASecurityCheck^%bi.SWr.DataAlerts(type)
}

}
