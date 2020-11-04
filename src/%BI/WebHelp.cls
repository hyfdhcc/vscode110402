Class %BI.WebHelp [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddNew(hid, title, url, hhtm, type, hsH, hsW, hLang, chkurl)
{
	d AddNew^%bi.SWr.WebHelp(hid,title,url,hhtm,type,hsH,hsW,hLang,chkurl)
}

ClassMethod loadNew(stat)
{
	d loadHelpList^%bi.SWr.WebHelp(stat)
}

ClassMethod GetHelpDet(curid, langid)
{
	d GetHelpDet^%bi.SWr.WebHelp(curid,langid)
}

ClassMethod UpdateHelp(Crid, Nwid, huptitle, hupurl, hupHtml, type, hsH, hsW, hLang, chkurl)
{
	d UpdateHelp^%bi.SWr.WebHelp(Crid,Nwid,huptitle,hupurl,hupHtml,type,hsH,hsW,hLang,chkurl)
}

ClassMethod DelHelp(todel)
{
	d DelHelp^%bi.SWr.WebHelp(todel)
}

ClassMethod SavSize(daHeight, daWidth)
{
	d SavSize^%bi.SWr.WebHelp(daHeight,daWidth)
}

ClassMethod LangSet(Lset, Nowid)
{
	d LangSet^%bi.SWr.WebHelp(Lset,Nowid)
}

ClassMethod ChangeAll(langid, Nowid)
{
	d ChangeAll^%bi.SWr.WebHelp(langid,Nowid)
}

}
