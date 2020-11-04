Class %BI.WebTAClassDialogBox [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadPropertyByClass(className As %String, js)
{
	d loadSchema^%bi.SWrt.WebTAClassDialogBox(className,$G(js))
}

ClassMethod SetSes(daid)
{
	//1 for normal bts tree
	//0 is for the dialog tree
	
	s %session.Data("TheTreeID")=daid
}

}
