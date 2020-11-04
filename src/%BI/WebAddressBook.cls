Class %BI.WebAddressBook [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddNew(Name, Email, Tel, Fax, Comp, Desc, Grp, chk)
{
	s userid = %session.Get("currUserID")
	s uid =$P(userid,$C(6),1)
	if ($D(^BI.AddressBook(uid,"Grp"))=0)
	{
		d Firsttime^%bi.SWr.AddressBook
			
	}	
	else
	{	}
	//w "alert('"_chk_"');"
	if (chk=1)
	{
		s GT=^BI.AddressBook(uid,"Grp")
		s GT=GT+1
		s ^BI.AddressBook(uid,"Grp")=GT
		s ^BI.AddressBook(uid,"Grp",GT)=Grp
		s Grp=GT	
	}
	
	s TracTot= ^BI.AddressBook(uid,"T")
	s NewTot=TracTot+1
	s ^BI.AddressBook(uid,"T")=NewTot
	s ^BI.AddressBook(uid,"T",NewTot)=$LB(Name,Email,Tel,Fax,Comp,Desc,Grp)
}

ClassMethod FirstSet()
{
	
	s %session.Data("IsNewGrp")=0
}

ClassMethod NewGrp()
{
	//s %session.Data("IsNewGrp")=1
	d loadGrpIn^%bi.SWr.AddressBook
}

ClassMethod ShowCon(id)
{
	d ShowCon^%bi.SWr.AddressBook(id)
}

ClassMethod GetCurr()
{
	w "CurrSel="_%session.Get("CurrSel")_";"
}

ClassMethod DisplayAdded()
{
	d FirstDisplay^%bi.SWr.AddressBook(0)
}

ClassMethod AddC(loc)
{
	d AddC^%bi.SWr.AddressBook(loc)
}

ClassMethod DelC(loc)
{
	d DelC^%bi.SWr.AddressBook(loc)
}

ClassMethod DoInsert()
{
	
	d DoInsert^%bi.SWr.AddressBook()
}

ClassMethod UpdateAdd(CurrSel, ShName, ShEmail, ShTel, ShFax, ShComp, ShDesc, ShGrp)
{
	s userid = %session.Get("currUserID")
	s uid =$P(userid,$C(6),1)
	
	s ^BI.AddressBook(uid,"T",CurrSel)=$LB(ShName,ShEmail,ShTel,ShFax,ShComp,ShDesc,ShGrp)
	d FirstDisplay^%bi.SWr.AddressBook(0)
	d ReShowBut^%bi.SWr.AddressBook()
	//w "btnAddNew.value="""_$LG(genlTrans,24)_""";"
}

ClassMethod DelAddCon(CurrSel)
{
	s userid = %session.Get("currUserID")
	s uid =$P(userid,$C(6),1)
	k ^BI.AddressBook(uid,"T",CurrSel)
	
	d FirstDisplay^%bi.SWr.AddressBook(0)
	d ReShowBut^%bi.SWr.AddressBook()
}

}
