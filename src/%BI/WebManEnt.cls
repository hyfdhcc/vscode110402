Class %BI.WebManEnt [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod search(key)
{
	d searchPartial^%bi.SWr.WebManEnt(key)
}

ClassMethod sRole(cat, rl, usr)
{
	d sRole^%bi.SWr.WebManEnt(cat,rl,usr)
}

ClassMethod checkPerm(cat)
{
	d checkPerm^%bi.SWr.WebManEnt(cat)
}

ClassMethod gRoleArr()
{
	d gRoleArr^%bi.SWr.WebManEnt
}

ClassMethod loadUserList()
{
	d loadUserList^%bi.SWr.WebManEnt
}

ClassMethod lRole(cat, type)
{
	d lRole^%bi.SWr.WebManEnt(cat,type)
}

ClassMethod Duplicate(oricat, newcat)
{
	d duplicate^%bi.SWr.WebManEnt(oricat,newcat)
}

ClassMethod aCat(name, row, type)
{
	d aCat^%bi.SWr.WebManEnt(name,row, type)
}

ClassMethod dCol(catName, colName)
{
	d dCol^%bi.SWr.WebManEnt(catName,colName)
}

ClassMethod dCat(name)
{
	d dCat^%bi.SWr.WebManEnt(name)
}

ClassMethod dEnt(cat, fr, to)
{
	d dEnt^%bi.SWr.WebManEnt(cat,fr,to)
}

ClassMethod dRow(cat, row)
{
	d dRow^%bi.SWr.WebManEnt(cat,row)
}

ClassMethod lACat()
{
	d lACat^%bi.SWr.WebManEnt
}

ClassMethod lCat(cat)
{
	d lCat^%bi.SWr.WebManEnt(cat)
}

ClassMethod lEnt(cat, fr, to)
{
	d lEnt^%bi.SWr.WebManEnt(cat,fr,to)
}

ClassMethod lCEnt(cat, col)
{
	d lCEnt^%bi.SWr.WebManEnt(cat,col)
}

ClassMethod sEnt(cat, row, col, cell)
{
	d sEnt^%bi.SWr.WebManEnt(cat,row,col,cell)
}

}
