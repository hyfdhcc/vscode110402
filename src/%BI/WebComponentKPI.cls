Class %BI.WebComponentKPI [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DetInfo(id)
{
	d DetInfo^%bi.SWr.WebComponentKPI(id)
}

ClassMethod CallKPI(valueSet, ht, wd, tree, style1, style2, chk, prop)
{
	d CallKPI^%bi.SWr.WebComponentKPI(valueSet,ht,wd,tree,style1,style2,chk,prop)
}

ClassMethod tempVal(val, id)
{
	s %session.Data(id) = val
}

ClassMethod NewWin(id, ht, wd, tid)
{
	d NewWin^%bi.SWr.WebComponentKPI(id,ht,wd,tid)
}

ClassMethod DashNextLvl(id, boid, height, width, chk, b1, b2)
{
	d DashNextLvl^%bi.SWr.WebComponentKPI(id,boid,height,width,chk,b1,b2)
}

ClassMethod OpenDetailList(KPIID)
{
	d OpenDetailList^%bi.SWr.WebComponentKPI(KPIID)
}

ClassMethod CheckByFolder(fldrId, ht, wd, tree, style1, style2, chk, prop)
{
	d CheckByFolder^%bi.SWr.WebComponentKPI(fldrId, ht, wd, tree, style1, style2, chk, prop)
}

}
