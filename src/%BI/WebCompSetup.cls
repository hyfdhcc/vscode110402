Class %BI.WebCompSetup [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Delete(id As %Integer)
{
	d Delete^%bi.SWr.CompSetup(id)
}

ClassMethod LoadComputation()
{
	d LoadComputation^%bi.SWr.CompSetup
}

ClassMethod Save(data As %String)
{
	d Save^%bi.SWr.CompSetup(data)
}

ClassMethod UpdateMisc(data, id)
{
	
	d UpdateMisc^%bi.SWr.CompSetup(data, id)
}

ClassMethod Update(data As %String, id As %Integer)
{
	d Update^%bi.SWr.CompSetup(data,id)
}

ClassMethod Warn()
{
	d Warn^%bi.SWr.CompSetup
}

ClassMethod PassOptions(misc)
{
	d PassOptions^%bi.SWr.CompSetup(misc)
}

}
