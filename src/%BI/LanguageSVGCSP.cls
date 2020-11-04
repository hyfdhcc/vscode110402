Class %BI.LanguageSVGCSP [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Save(bo)
{
	d Save^%bi.SWr.LanguageSVGCSP(bo)
}

ClassMethod SaveTest(lan, font, cnt)
{
	w "alert('"_lan_"');"
	//d SaveTest^%bi.SWr.LanguageSVGCSP(lan,font,cnt)
}

}
