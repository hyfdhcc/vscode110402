Class %BI.WebFile [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod lDrvS()
{
	d lDrvS^%bi.SWr.WebFile
}

ClassMethod lFile(dir, fType, dis, fold)
{
	d lFile^%bi.SWr.WebFile(dir,fType,dis,$G(fold))
}

}
