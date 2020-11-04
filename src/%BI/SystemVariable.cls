Class %BI.SystemVariable [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod SaveValue(val)
{
	d SaveValue^%bi.SWr.SystemVariable(val)
}

ClassMethod SaveValueByRole(val, id)
{
	d SaveValueByRole^%bi.SWr.SystemVariable(val,id)
}

ClassMethod LoadByRole(id)
{
	d LoadByRole^%bi.SWr.SystemVariable(id)
}

}
