Class %BI.CodeTableCSP [ Abstract, System = 4 ]
{

ClassMethod LoadTable(x)
{
	d LoadTable^%bi.SWr.CodeTableCSP(x)
}

ClassMethod SaveData(typ, code, str, coll)
{
	d SaveData^%bi.SWr.CodeTableCSP(typ,code,str,coll)
	//w "alert('"_typ_","_code_","_str_","_coll_"');"
}

ClassMethod LoadNTBL(tp, c)
{
	d LoadType^%bi.SWr.CodeTableCSP(tp,c)
}

ClassMethod DeleteId(t, c)
{
	d DeleteId^%bi.SWr.CodeTableCSP(t,c)
}

ClassMethod ShowCollum(t, c)
{
	//d ShowCollum^%bi.SWr.CodeTableCSP(t,c)
	d LoadType^%bi.SWr.CodeTableCSP(t,c)
	//d LoadType^test.CodeTableCSP(t,c)
}

ClassMethod EditContent(typ, code, str, coll, pcoll)
{
	d EditContent^%bi.SWr.CodeTableCSP(typ, code, str, coll,pcoll)
}

ClassMethod DelType(t)
{
	d DelType^%bi.SWr.CodeTableCSP(t)
}

}
