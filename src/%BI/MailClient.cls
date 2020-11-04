Class %BI.MailClient [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod GetSelect(hdlTxt, hval)
{
	s %session.Data("Now")=hdlTxt
	s %session.Data("HVal")=hval
}

ClassMethod SelThis(msnum, ty)
{
	s userid = %session.Get("currUserID")
	s Uid =$P(userid,$C(6),1)
	
	s %session.Data("MailId")=msnum
	s %session.Data("Type")=ty
	
	if (ty=1)
	{
		s UqID=^BI.MailC(Uid,"Mid",msnum)
		s ^BI.MailC(Uid,UqID)=1
	}
	
	d Displaytemp^%bi.SWrt.MailClient(0)
	w "parent.rightMailDis.location.href="""_##class(%CSP.Page).Link("%25cspapp.bi.mainmc.cls")_""";"
	//w "parent.rightMailDis.location.href='MainMc.csp';"
}

ClassMethod SetOpen()
{
	
	//d Displaytemp^%bi.SWrt.MailClient(1)
}

ClassMethod EndIt()
{
	//d EndIt^%bi.SWrt.MailClient
}

ClassMethod ConnectStat(stat)
{
	//d ConnectStat^%bi.SWrt.MailClient(stat)
	d ConnectMailV2^%bi.SWrt.MailClient(stat)
}

ClassMethod ViewThis(PicDir)
{
	s %session.Data("PicView")="attach/"_PicDir
}

ClassMethod PrepareD(curr)
{
	s %session.Data("ToDel")=curr
}

ClassMethod DeleteMsg()
{
	d DelMsg^%bi.SWrt.MailClient()
	d Displaytemp^%bi.SWrt.MailClient(0)
}

ClassMethod RedrawT()
{
	d ToDrawTree^%bi.SWrt.MailClient(0)
	//w "drawTree ('Tfolder', '', Tfolder,theme,0,1);"
}

ClassMethod ToolBarDel()
{
	s %session.Data("ToDel")=$g(%session.Data("MailId"))
	d DelMsg^%bi.SWrt.MailClient()
}

ClassMethod RedrawTable()
{
	d Displaytemp^%bi.SWrt.MailClient(0)
}

ClassMethod ToReplay(typ)
{
	s userid = %session.Get("currUserID")
	s Uid =$P(userid,$C(6),1)
	
	//typ 0=compose 1=reply 2=foward
	
	if (typ=1)
	{
		s MsgId=$g(%session.Data("MailId"))
		s Fwd=0
	}
	elseif(typ=0)
	{
		s MsgId=""
		s Fwd=0
	}
	else
	{
		k ^Mail.Up(Uid)
		s MsgId=$g(%session.Data("MailId"))
		s con=1
		//to foward attaced files 
		if (MsgId'="")
		{
			s count=""
			s La=$o(^BI.MailC(Uid,"Msg",MsgId,"Con2",count))
			while (La'="")
			{
				if ($LG(^BI.MailC(Uid,"Msg",MsgId,"Con2",La),1)'="")
				{
					s RName=$LG(^BI.MailC(Uid,"Msg",MsgId,"Con2",La),1)
					s CName=RName
					s Rid=0
					s ^Mail.Up(Uid,con)=$LB(RName,CName,Rid)
					s con=$i(con)
				}
				s La=$o(^BI.MailC(Uid,"Msg",MsgId,"Con2",La))
			}
		}
		
		
		s Fwd=1
	}
	
	
	s %session.Data("Foward")=Fwd
	s %session.Data("ToReply")=MsgId
}

ClassMethod DoSendMail(mTo, mCc, mSubj, mText, username, password, mBcc)
{
	//d password^%bi.SWrt.MailClientSend(mTo, mCc, mSubj, mText,$g(username), $g(password))
	
	//s sesid=%session.%Id()
	s userid = %session.Get("currUserID")
	s sesid =$P(userid,$C(6),1)
	
	//sendSmplEmail may no longer be use.Has been change to sendEmail by Jimmy. Alan 23/7/08
	//d sendSmplEmail^%bi.SWrt.MailClientSend(mTo,mCc,mSubj,mText,sesid)
	d sendEmail^%bi.SWrt.MailClientSend(mTo,mCc,mSubj,mText,sesid,mBcc)
	d SetToOutbox^%bi.SWrt.MailClientExt1(mTo,mCc,mSubj,mText,mBcc) 
	//s ^TMPAL("MAILSTAT")=stmat
	s clsonot=$g(%session.Data("RplyMailId"))
	if (clsonot'="")
	{
		w "window.close();"
	}
	
	//May need to revamp
	//d DeleteUploadList^%bi.SWrt.MailClientSend()
	//s DaTime=$ZDATE($HOROLOG,0)
	//d MsgToSentBox^%bi.SWrt.MailClientSend(mTo,mCc,mSubj,mText,DaTime)
}

ClassMethod StartAttach(Fi)
{
	s lenFil=$l(Fi,"\")
	s daFil=$p(Fi,"\",lenFil)
	s daDir=$p(Fi,daFil,1)
	s sesid=%session.%Id()
	
	if ($g(%session.Data("Atc"))="")
	{
		s %session.Data("Atc")=daFil_"||"_daDir
	}
	else
	{
		s %session.Data("Atc")=%session.Get("Atc")_","_daFil_"||"_daDir
	}
	s ^BI.MailAttach(sesid,daFil)=daDir
	//w "alert("_daDir_");"
	s DaSesAtt=$g(%session.Data("Atc"))
	s LenAtt=$l(DaSesAtt,",")
	s conA=1
	s Att=""
	while(conA'>LenAtt)
	{
		s FilNam=$p(DaSesAtt,",",conA)
		s daFilName=$p(FilNam,"||",1)
		if (Att="")
		{
			s Att=daFilName	
		}
		else
		{
			s Att=Att_","_daFilName	
		}
		s conA=$i(conA)	
	}
	w "Att='"_Att_"';"
	
	w "alert(Atc="_##class(%CSP.Page).QuoteJS(DaSesAtt)_");"
}

ClassMethod Reset()
{
	s %session.Data("Atc")=""
}

ClassMethod SesStat()
{
	s St=$d(%session.Data("Atc"))
	w "ST="_St_";"
}

ClassMethod DoTest()
{
	s userid = %session.Get("currUserID")
	s usr =$P(userid,$C(6),1)
	s totAt=""
	s Tot=$o(^Mail.Up(usr,totAt))
	while(Tot'="")
	{
		s tod=$LG(^Mail.Up(usr,Tot),3)
		d ##class(%BI.GetMail).%DeleteId(tod)
		s Tot=$o(^Mail.Up(usr,Tot))
	}
	
	k ^Mail.Up(usr)
}

ClassMethod ShowNow()
{
	//if ($data(%request.MimeData("FileStream",1)))	
	//datafile1
	s FName=MimeData("FileStream",1).FileName
	w "alert("_##class(%CSP.Page).QuoteJS(FName)_");"
}

ClassMethod TryNow()
{
	d TryNow^%bi.SWrt.MailClientSend
}

ClassMethod ShowAtt()
{
	d LoadAny^%bi.SWrt.MailClientSend(1)
}

ClassMethod GoinD(curr, curr2)
{
	
	s %session.Data("GoinD")=curr
	s %session.Data("GoinD2")=curr2
}

ClassMethod DelUp()
{
	d DelUp^%bi.SWrt.MailClient
}

ClassMethod DisplayAtt()
{
	d DisplayAtt^%bi.SWrt.MailClientSend(1)
}

ClassMethod ChkUnread()
{
	d DisplayUnread^%bi.SWrt.MailClient(1)
}

ClassMethod SOp(t)
{
	
	s %session.Data("TempS")=t
}

ClassMethod ResetMailId()
{
	s %session.Data("MailId")=""
	w "parent.rightMailDis.location.href="""_##class(%CSP.Page).Link("%25cspapp.bi.mainmc.cls")_""";"
	s a = ##class(%CSP.Page).Link("%25cspapp.mainmc.cls")
}

ClassMethod GenerateSav(fname)
{
	//this one calls an asp to perform a save for the user
	//FPath here is the location of all the files that you want to allow user to save from
	 
	
	s FPath="attach/"
	if (fname'="")
	{
		w "FileOpt2.innerHTML=""<div onmouseover=mover2(this),wentout(0) onmouseout=mout2(this),wentout(1) onmousedown=''><a href=TrySave.asp?FName="_fname_"&FPath="_FPath_"> Save</a></div>"";"
	}
	//d GenerateSav^%bi.SWrt.MailClient(fname)
}

ClassMethod CleanUpload()
{
	d CleanUpload^%bi.SWrt.MailClientSend()
}

ClassMethod MUserUp(UsrN, UsrP)
{
	d MUserUp^%bi.SWrt.MailClient(UsrN,UsrP)
}

ClassMethod ShowSMS(sms)
{
	d ShowSMS^%bi.SWrt.MailClient(sms)
}

ClassMethod ShowSMS2(sms, tt)
{
	d ShowSMS2^%bi.SWrt.MailClient(sms,tt)
}

ClassMethod LoadCont(idv)
{
	d LoadCont^%bi.SWrt.MailClient(idv)
}

ClassMethod LoadNewTit(idv)
{
	d LoadNewTit^%bi.SWrt.MailClient(idv)
}

ClassMethod OpenGetMail()
{
	d OpenGetMail^%bi.SWrt.MailClientExt1()
}

ClassMethod DeleteInMail(lst As %String)
{
	d DeleteInMail^%bi.SWrt.MailClientExt1(lst)
}

ClassMethod DeleteInMailData(lst As %String)
{
	d DeleteInMailData^%bi.SWrt.MailClientExt1(lst)
}

ClassMethod MailInTabCont(str, typ)
{
	d LoadMailInContTabl^%bi.SWrt.MailClientExt1(str,typ)
}

ClassMethod DwinRply()
{
	d WindowMailReply^%bi.SWrt.MailClientExt1()
}

ClassMethod MailDetailInMain(mid, typ)
{
	d OpenGetMailMain^%bi.SWrt.MailClientExt1(mid,typ)
}

}
