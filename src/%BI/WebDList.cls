Class %BI.WebDList [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod nPg(aVal, DetID, obj, DLSt)
{
	d nPg^%bi.SWr.WebDList(aVal,DetID,obj,DLSt)
}

ClassMethod nRec(aVal, DetID, obj, DLSt)
{
	d nRec^%bi.SWr.WebDList(aVal,DetID,obj,DLSt)
}

ClassMethod alwMultSession(detID, currRow, id, rcdNum, checked)
{
	d alwMultSession^%bi.SWr.WebDList(detID,currRow,id,rcdNum,checked)
}

}
