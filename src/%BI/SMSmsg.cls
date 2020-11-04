Class %BI.SMSmsg Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	&html<<html>
	<head>
	</head>
	<body>>
	;To do...
	&html<</body>
	</html>>
	Quit $$$OK
}

ClassMethod CheckMsg(phone, msg)
{
	d CheckMsg^%bi.SWr.SMSmsg(phone,msg)
}

ClassMethod TstChkmsg(phone, msg)
{
	d 
	/*s ret = $$GetATE^%bi.SWr.SMSmsg(phone,msg)
	if ret '= "SMS Sent" d
	.w "alert('"_ret_"');"
	else  d
	.w "alert('"_ret_"');"
	.w "window.close();"*/
}

ClassMethod GetGrpName(grplist)
{
	//d GetGrpName^%bi.SWr.SMSmsg(grplist)
	if (grplist="") || (grplist="")
	{
		q	
	}
	s userid = %session.Get("currUserID")
	s uid =$P(userid,$C(6),1)
	
	s daLen=$l(grplist,";")
	s i=1
	s GrpNam=""
	while(i<=daLen)
	{
		s grpid=$p(grplist,";",i)
		
		if (GrpNam="")
		{
			s GrpNam="<"_$g(^BI.AddressBook(uid,"Grp",grpid))_">"	
		}
		else
		{
			s GrpNam=GrpNam_";<"_$g(^BI.AddressBook(uid,"Grp",grpid))_">"
		}
		
		s i=i+1	
	}
	
	w "GrpN="_##class(%CSP.Page).QuoteJS(GrpNam)_";"
}

ClassMethod Send(phone, msg)
{
	//s msg = $$Send^%bi.SWr.SMSmsg(phone,msg)
	//w "alert('"_msg_"');"
	d SaveMsg^%bi.SWr.msgSMS(phone,msg)
	w "alert('"_$$$Text("Message Queued For Sending")_"');"
}

ClassMethod Unlock()
{
	s pin = $G(^SYS("BI","CFG","Configuration","SMS",0,2))
	if pin'="" s ret = $$Unlock^%bi.SWr.SMSmsg(pin)
	e  s ret = $$$Text("You have no pin")
	w "alert('"_ret_"');"
}

}
