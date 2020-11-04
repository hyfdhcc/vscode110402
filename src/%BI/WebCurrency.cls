Class %BI.WebCurrency [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Save(fromCurr, toCurr, effDate, cRate, mode)
{
	d Save^%bi.SWr.WebCurrency(fromCurr,toCurr,effDate,cRate,mode)
}

ClassMethod LoadData()
{
	d LoadData^%bi.SWr.WebCurrency
}

ClassMethod delete(fc, tc, ed)
{
	d Delete^%bi.SWr.WebCurrency(fc,tc,ed)
}

}
