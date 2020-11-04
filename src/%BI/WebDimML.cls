Class %BI.WebDimML [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddDimCapTable(hval, htxt)
{
	s Las=%session.Get("LastO")+1
	
	if (%session.Get("TracC")="")
		{
			s %session.Data("TracC")=Las
		}
	else
		{
			s %session.Data("TracC")=%session.Get("TracC")_"|"_Las
		}
		
	s %session.Data("ML",Las)=htxt_"|"_htxt
	s %session.Data("LastO")=Las
	d InitDisplayDimCap^%bi.SWrt.WebDimML(2)
	d AddNewArr^%bi.SWrt.WebDimML(Las)
}

ClassMethod ToDel(daOne)
{
	s %session.Data("toDel")=daOne
}

ClassMethod ToDelAs(daO)
{
	s %session.Data("toDelAs")=daO
}

ClassMethod DelNowAs()
{
	s toDAs=%session.Get("toDelAs")
	s CAsr=%session.Data("CurrAs")
	
	s TrA=$g(%session.Data("TracA"))
	s LenTrA=$L(TrA,"|")
	s NT=""
	s TrCo=1
	while(TrCo'>LenTrA)
	{
		if (TrCo'=toDAs)
		{
			if (NT="")
			{
				s NT=$p(TrA,"|",TrCo)
			}
			else
			{
				s NT=NT_"|"_$p(TrA,"|",TrCo)
			}	
		}
		
		s TrCo=$i(TrCo)	
	}
	s toDelete=$p(TrA,"|",toDAs)
	K %session.Data("TracA")
	s %session.Data("TracA")=NT
	K %session.Data("AscTab",CAsr,toDelete)
	
	if 
	s DaLasA=%session.Get("LastA")	
	if (DaLasA=1)
	{
		s %session.Data("LastA")=""	
	}	
	
	d InitDisplayAssTable^%bi.SWrt.WebDimML(2,CAsr)
}

ClassMethod DelNow()
{
	s toD=%session.Get("toDel")
	
	s LenTD=$L(%session.Get("TracC"),"|")
	s Lcount=1
	s DelTrac=""
	while(Lcount'>LenTD)
	{
		if ($p(%session.Get("TracC"),"|",Lcount)'=toD)
		{
			if (DelTrac="")
			{
				s DelTrac=$p(%session.Get("TracC"),"|",Lcount)
			}
			else
			{
				s DelTrac=DelTrac_"|"_$p(%session.Get("TracC"),"|",Lcount)
			}	
		}
		
		s Lcount=$i(Lcount)	
	}
	
		K %session.Data("TracC")
		K %session.Data("ML",toD)
		s %session.Data("TracC")=DelTrac
		
	if (%session.Data("RDel")="")
	{
		s %session.Data("RDel")=toD
	}
	else
	{
		s %session.Data("RDel")=%session.Get("RDel")_"|"_toD
	} 
				
	s DaLas=%session.Get("LastO")	
	if (DaLas=1)
	{
		s %session.Data("LastO")=""	
	}	
		d InitDisplayDimCap^%bi.SWrt.WebDimML(2)
		
		s TDEL=$g(%session.Data("TracA"))
		if ($d(TDEL)=0)
		{
			S LentDel=$L(TDEL,"|")
			s d=1
			while(d'>LentDel)
			{
				s ChPos=$p(TDEL,"|",d)
				k %session.Data("AscTab",toD,ChPos)
				s d=$i(d)	
			}
			k %session.Data("TracA")
		}
}

ClassMethod AddNow()
{
	s Asr =%session.Get("CurrAs")
	w "alert('"_Asr_"');"
	
	//s LasA=%session.Get("LastA")
	s LasA=%session.Get("LastA")
	s LastA=1+LasA
	
	//w "alert('LasTa="_LastA_"');"
	//s T=""
	if ($g(%session.Data("TracA"))="")
	{
		s %session.Data("TracA")=LastA
	}
	else
	{
		s %session.Data("TracA")=$g(%session.Data("TracA"))_"|"_LastA
	}
	//w "alert('"_$g(%session.Data("TracA",Asr))_"');"	
	s NewSA=""
	s NewADim=""
	s %session.Data("AscTab",Asr,LastA)=NewSA_"|"_NewADim
	
	s %session.Data("LastA")=LastA	
	d InitDisplayAssTable^%bi.SWrt.WebDimML(2,Asr)
}

ClassMethod InitDisplayAssTable(stat, Asr)
{
	
	d LoadAssTabToSession^%bi.SWrt.WebDimML(Asr)
	//d InitDisplayAssTable^%bi.SWrt.WebDimML(stat,Asr)
}

ClassMethod SavNow()
{
	s cr=%session.Get("CurrAs")
	s TracC=%session.Get("TracC")
	s TracA=%session.Get("TracA")
	w "alert('TracC="_TracC_"');"
	s tc=1
	s Ltc=$l(TracC,"|")
	while(tc'>TracC)
	{
		s wh=$p(TracC,"|",tc)
		w "alert('"_$g(%session.Data("ML",wh))_"');"	
		s tc=$i(tc)
	}
	
	/*w "alert('TracA="_TracA_"');"
	s ta=1
	s Lta=$l(TracA,"|")
	while(ta'>TracA)
	{
		w whc=$p(TracA,"|",ta)
		w "alert('"_$g(%session.Data("AscTab",cr,whc))_"');"
		s ta=$i(ta)	
	}*/
}

ClassMethod UpdateSes(newt, id, loc)
{
	s Cur=%session.Get("CurrMain")
	s DaML=$g(%session.Data("AscTab",Cur,id))
	s Ncap=$p(DaML,"|",1)
	s Ndim=$p(DaML,"|",2)
	if (loc=1)
	{
		s Ncap=newt	
	}
	else
	{
		s Ndim=newt
	}
	
	s %session.Data("AscTab",Cur,id)=Ncap_"|"_Ndim
}

ClassMethod DisplayParJS(ParSt)
{
	//w "alert('"_ParSt_"');"
	
	d DisplayParJS^%bi.SWrt.WebDimML(ParSt)
}

ClassMethod LoadAssTabToJs(ParId)
{
	d LoadAssTabToJs^%bi.SWrt.WebDimML(ParId)
}

ClassMethod DisplayChdJS(AcsChd)
{
	d DisplayChdJS^%bi.SWrt.WebDimML(AcsChd)
}

ClassMethod DelChd(DDPar, tdch)
{
	//w "alert('Hi');"
	d TRemN^%bi.SWrt.WebDimML(DDPar,tdch)
}

ClassMethod DoSaveJs(toS)
{
	;w "alert('Cache="_toS_"');"
	d DoSaveJs^%bi.SWrt.WebDimML(toS)
}

ClassMethod TRemN(par, chd)
{
	d RemovingAll^%bi.SWrt.WebDimML(par,chd)
	//w "alert('Heelo');"
}

ClassMethod GoinRem(pa)
{
	w "alert('"_pa_"');"
	d RemovingAll^%bi.SWrt.WebDimML(pa)
}

ClassMethod DoneNone()
{
	d DoneNone^%bi.SWrt.WebDimML()
}

ClassMethod GetLastPar()
{
	d GetLastPar^%bi.SWrt.WebDimML()
}

ClassMethod UpdateLastPar(parNum)
{
	d UpdateLastPar^%bi.SWrt.WebDimML(parNum)
}

}
