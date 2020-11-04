Class %BI.ImportList [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadDat(dat)
{
	d LoadDat^%bi.SWr.ImportList(dat)
}

ClassMethod LoadFolderDat(dat)
{
	d LoadFolderDat^%bi.SWr.ImportList(dat)
}

ClassMethod Import(nm, oId, nId, fId)
{
	
	d Import^%bi.SWr.ImportList(nm,oId,nId,fId)
}

ClassMethod ImportAll(nm, oId, nId, fId, name, exists)
{
	d ImportAll^%bi.SWr.ImportList(nm,oId,nId,fId,name,exists)
}

}
