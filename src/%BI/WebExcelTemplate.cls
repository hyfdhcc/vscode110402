Class %BI.WebExcelTemplate [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod setSess(txt)
{
	
	//d setSess^%bi.SWr.WebExcelTemplate(txt)
	s %session.Data("ExTemp") = txt
	s %session.Data("currentHTMLAreaCall") = "Knowledge"
}

ClassMethod saveData(fullD, id, type)
{
	d saveData^%bi.SWr.WebExcelTemplate(fullD,id,type)
}

ClassMethod loadData(Det, type)
{
	d loadData^%bi.SWr.WebExcelTemplate(Det,type)
}

ClassMethod loadData2(det, type)
{
	d loadData2^%bi.SWr.WebExcelTemplate(det,type)
}

ClassMethod deleteData(id, type)
{
	d deleteData^%bi.SWr.WebExcelTemplate(id,type)
}

}
