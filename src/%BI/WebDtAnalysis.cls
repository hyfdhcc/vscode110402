Class %BI.WebDtAnalysis [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod distinct(dsn, sch, tbl, fld)
{
	d distinct^%bi.SWr.WebDtAnalysis(dsn,sch,tbl,fld)
}

ClassMethod genRpt(dsn, sch, tbl, fld)
{
	d genRpt^%bi.SWr.WebDtAnalysis(dsn,sch,tbl,fld)
}

ClassMethod lFld(dsn, sch, tbl)
{
	d lFld^%bi.SWr.WebDtAnalysis(dsn,sch,tbl)
}

}
