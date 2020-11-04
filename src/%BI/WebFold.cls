Class %BI.WebFold [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod lDrvS()
{
	d lDrvS^%bi.SWr.WebFile
}

ClassMethod lFold(dir, fType)
{
	d lFold^%bi.SWr.WebFold(dir,fType)
}

ClassMethod CheckPath(path)
{
	d CheckPath^%bi.SWr.WebFold(path)
}

}
