Class %BI.TestExcel [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DCon()
{
	s Con=Activate.Excel.Workbooks
	d Con.Open(filename)
}

}
