Class %BI.WebContactFunc [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Add(group, name, email, tel, fax, company, desc, rowid, type)
{
	d Add^%bi.SWr.WebContactFunc(group,name,email,tel,fax,company,desc,$g(rowid), $g(type))
}

ClassMethod Del(id)
{
	if ( ##class(%BI.WebContacts).%DeleteId(id) ) { w "alert('"_$$$Text("Contact Deleted","%BI")_"');" }	
	else  { w "alert('"_$$$Text("Failed to Delete the Contact","%BI")_"');" }
	do Load^%bi.SWr.WebContactFunc("ContactList",1)
}

ClassMethod Filter(value)
{
	d Load^%bi.SWr.WebContactFunc("ContactList",0,value)
}

ClassMethod FilterContact(value, keyword, string)
{
	d LoadContact^%bi.SWr.WebContactFunc("ListCons",value,1,$g(keyword),$g(string))
}

ClassMethod EditGroup(string)
{
	d EditGroup^%bi.SWr.WebContactFunc(string)
}

ClassMethod DeleteGroup(keyword)
{
	d DeleteGroup^%bi.SWr.WebContactFunc(keyword)
}

ClassMethod Refresh()
{
	d GroupComboE^%bi.SWr.WebContactFunc(1)
}

ClassMethod Load(string)
{
	d LoadContact^%bi.SWr.WebContactFunc("ListCons",$$$Text("ALL","%BI"),1,"",string)
}

// not being used

ClassMethod AddNew(Name, Email, Tel, Fax, Comp, Desc)
{
	 d AddNew^%bi.SWr.WebContactFunc(Name,Email,Tel,Fax,Comp,Desc)
}

ClassMethod FindName(fthis, div)
{
	d FindName^%bi.SWr.WebContactFunc(fthis,div)
}

ClassMethod DisplayAdded(div, st)
{
	d LoadDisplayAll^%bi.SWr.WebContactFunc(div,st)
}

ClassMethod ShowCon(id)
{
	d ShowCon^%bi.SWr.WebContactFunc(id)
}

ClassMethod UpdateAdd(CurrSel, ShName, ShEmail, ShTel, ShFax, ShComp, ShDesc)
{
	d UpdateAdd^%bi.SWr.WebContactFunc(CurrSel,ShName,ShEmail,ShTel,ShFax,ShComp,ShDesc)
}

}
