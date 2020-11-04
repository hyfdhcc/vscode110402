Class %BI.WebAccessLog [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Redraw()
{
	
	d IniDisplayLog^%bi.SWrt.WebAccessLog(2)
}

ClassMethod Tes(vs)
{
	s V=vs
	s a=$p(V,$C(2),2)
	s b=$p(V,$C(2),3)
	w "alert('2,$C(2)"_a_"');"
	w "alert('3,$C(2)"_b_"');"
}

ClassMethod CompCls(cls, Clw, Sc)
{
	w "alert('hello');"
	//d loadDrillDownByClass^%bi.SWrt.WebSMHelpDoc(cls)
	//s Dret = $$loadDrillDownByClass^%bi.SWrt.WebSMHelpDoc(cls)
	//w "dCl1.innerHTML='"_Dret_"';"
	//w "Dret='"_Dret_"';"
}

ClassMethod Hee(cls)
{
	//this is for classcompare.csp
	s Dret = $$loadDrillDownByClass^%bi.SWrt.WebSMHelpDoc(cls)
	w "Dret='"_Dret_"';"
}

}
