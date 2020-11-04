Class %BI.WebSqlWiz [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod gSqlFld(cls, fld)
{
	d gSqlFld^%bi.SWr.WebSqlWiz(cls,fld)
}

ClassMethod lClsS(a, sch)
{
	d lClsS^%bi.SWr.WebSqlWiz(a,sch)
}

ClassMethod lClsT(cls, lSO)
{
	
	d lClsT^%bi.SWr.WebSqlWiz(cls,$G(lSO))
}

ClassMethod lSchS(a, fr, to)
{
	d lSchS^%bi.SWr.WebSqlWiz(a,fr,to)
}

ClassMethod lSub(id)
{
	d lSub^%bi.SWr.WebSqlWiz(id)
}

ClassMethod sCls(a, cls, lSO)
{
	d sCls^%bi.SWr.WebSqlWiz(a,cls,$G(lSO))
}

}
