Class %BI.WebStoredProc [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod dProc(id)
{
	d dProc^%bi.SWr.WebStoredProc(id)
}

ClassMethod lProc(id)
{
	d lProc^%bi.SWr.WebStoredProc(id)
}

ClassMethod lProcS(cls)
{
	d lProcS^%bi.SWr.WebStoredProc(cls)
}

ClassMethod lProcT()
{
	d lProcT^%bi.SWr.WebStoredProc
}

ClassMethod lRptProc(id)
{
	d lRptProc^%bi.SWr.WebStoredProc(id)
}

ClassMethod sProc(id, nm, fldr, desc, help, cls, proc, param)
{
	d sProc^%bi.SWr.WebStoredProc(id,nm,fldr,desc,help,cls,proc,param)
}

ClassMethod checkSPname(typeName)
{
	q $$checkSPname^%bi.SWr.WebStoredProc(typeName)
}

}
