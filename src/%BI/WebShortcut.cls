Class %BI.WebShortcut [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod save(nm, folder, id, type, cur)
{
	k %session.Data("isShortcut")
	d save^%bi.SWr.WebShortcut(nm,folder,id,type,cur)
}

ClassMethod redraw(rclik, all, type, isMFold)
{
	d redraw^%bi.SWr.WebShortcut(rclik,all,type,isMFold)
}

ClassMethod redraw2(type, xCut)
{
	#;w "alert('%BI.WebShortcut:redraw2 = "_$G(xCut)_"');"
	d redraw2^%bi.SWr.WebShortcut(type,xCut)
}

ClassMethod deleteShort(id, type, isMFold)
{
	d deleteShort^%bi.SWr.WebShortcut(id,type,isMFold)
}

ClassMethod deleteShort2(id, type, loadId)
{
	d deleteShort2^%bi.SWr.WebShortcut(id,type,loadId)
}

ClassMethod DeleteShortcut(id, isMFold)
{
	d DeleteShortcut^%bi.SWr.WebShortcut(id,isMFold)
}

ClassMethod getName(type, id)
{
	s name = $$getName^%bi.SWr.RecentAccess(type,id)
	if type '= 0 s name = "["_id_"] "_name
	w "valueTxt = "_##class(%CSP.Page).QuoteJS(name)_";"
}

ClassMethod deleteShort2008(id)
{
	d deleteShort2008^%bi.SWr.WebShortcut(id) //150808
}

}
