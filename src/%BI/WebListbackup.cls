Class %BI.WebListbackup [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod nPg(aVal, DetID, obj, DLSt)
{
	d nPg^%bi.SWr.WebList(aVal,DetID,obj,DLSt)
}

ClassMethod nRec(aVal, DetID, obj, DLSt)
{
	d nRec^%bi.SWr.WebList(aVal,DetID,obj,DLSt)
}

ClassMethod GenDetail(m, detID)
{
	d GenDetail^%bi.SWr.WebList(m,detID)
}

ClassMethod GenList(detID)
{
	d GenList^%bi.SWr.WebList(detID)
	s P1 = $G(%session.Data("DList",detID,2))
	s P6 = $G(%session.Data("DList",detID,6))
	s V1 = $G(%session.Data("DList",detID,7))
	w "<script language=javascript>"
	d genRiteMenu^%bi.SWr.WebList(P1,detID,0,P6,V1)
	w "</script>"
}

ClassMethod drillDetList(P0, P1, P2, P3, P4, P5)
{
	d drillDetList^%bi.SWr.WebList(P0,P1,P2,P3,P4,P5)
}

ClassMethod SaveAttcDetailList(P0, P1)
{
	d SaveAttcDetailList^%bi.SWr.WebList(P0,P1)
}

ClassMethod GenExcel(P0)
{
	d GenExcel^%bi.SWr.WebList(P0)
}

ClassMethod GenIntoEmail(P0, P1)
{
	d GenIntoEmail^%bi.SWr.WebList(P0,P1)
}

}
