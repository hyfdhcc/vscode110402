Class %BI.WebMetricsBuild [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod FirstDisplay()
{
	d FirstDisplayMet^%bi.SWr.WebMetrics
}

ClassMethod ShowSel(ID)
{
	
	d ShowSel^%bi.SWr.WebMetrics(ID)
}

ClassMethod kpiTree1()
{
	s KTot= ^BI.KPID
	s i =1
	
	//set available Bt to null for child adding
	while (i'>KTot)
	{
		s Bt($LG(^BI.KPID(i),10))=""
		s i=$i(i)	
	}
	
	s i =1
	
	/*while (i '> KTot)
	{
		s c= $LG(^BI.KPID(i),10)
		s n= $LG(^BI.KPID(i))
		s id=i
		s Bt(c)=Bt(c)_"[null,'"_n_"',null,'"_id_"'],"
		s i=$i(i)
	} */

	s %session.Data("Td")=0
	while (i'>KTot)
	{
		s Fn=$LG(^BI.KPID(i),10)
		s n= $LG(^BI.KPID(i))
		s PoC=^BI.FolderD(Fn)
		s id=i
		if (PoC=0) && (%session.Get("Td")=0)
		{
			s Tree="[null,'"_n_"',null,'"_id_"'],"
			s %session.Data("Td")=1	
		}	
		elseif (PoC=0)&&(%session.Get("Td")'=0)
		{
			s Tree=Tree_"[null,'"_n_"',null,'"_id_"']"	
		}
	}
}

ClassMethod TracRC(tp)
{
	s %session.Data("TracRC")=tp
}

ClassMethod GetUndoVal()
{
	s GUV=%session.Get("TracRC")
	//w "alert('"_GUV_"');"
	w "GUV='"_GUV_"';"
}

ClassMethod TotalR()
{
	s TotalR=%session.Get("TotalR")
	w "TotalR='"_TotalR_"';"
}

ClassMethod Check()
{
	w "alert("_%session.Get("tempstore")_");"
}

ClassMethod CurrR(current)
{
	s %session.Data("CurrR")=current
}

ClassMethod MUP()
{
	s curr= %session.Get("CurrR")
	s tempS= %session.Get("tempstore")
	s Trole= %session.Get("TotalR")	
	s i=1
	
	//assign temporary storage
	s temp1=$p(tempS,"||",curr)
	s temp2=$p(tempS,"||",curr-1)
	//swap the two ^_^
	s $p(tempS,"||",curr-1)=temp1
	s $p(tempS,"||",curr)=temp2
	
	d displayTemp^%bi.SWr.WebMetrics(tempS,Trole)
}

ClassMethod MDW()
{
	s curr= %session.Get("CurrR")
	s tempS= %session.Get("tempstore")
	s Trole= %session.Get("TotalR")	
	
	//assign temporary storage
	s temp1=$p(tempS,"||",curr)
	s temp2=$p(tempS,"||",curr+1)
	//swap the two ^_^
	s $p(tempS,"||",curr+1)=temp1
	s $p(tempS,"||",curr)=temp2
	
	d displayTemp^%bi.SWr.WebMetrics(tempS,Trole)
}

ClassMethod MDEL()
{
	s curr= %session.Get("CurrR")
	s tempS= %session.Get("tempstore")
	s Trole= %session.Get("TotalR")	
	s count=0
	s NTrole=Trole-1
	s i=1
	if (NTrole'=0)
	{
		while (i'>Trole)
		{
			if (i'=curr) && (count=0)
			{
				s tempSt=$p(tempS,"||",i)
				s count=1
			}	
			elseif (i'=curr) && (count'=0)
			{
				s tempSt=tempSt_"||"_$p(tempS,"||",i)	
			}
			s i=$i(i)
		}
	 	s tempS=""
	 	//w "alert('"_tempSt_"');"
	 	s tempS=tempSt
	}
	elseif (NTrole=0)
	{
		s tempS=""
	} 
	
	 s Trole= NTrole
	
	 d displayTemp^%bi.SWr.WebMetrics(tempS,Trole)
}

ClassMethod ShFold(FolV)
{
	//s sRtn=$p(sRtnV,"||",1)
	s %session.Data("NameK")=FolV
	//w "NsRtn='"_sRtn_"';"
}

ClassMethod DropDisplay()
{
	d DropDisplay^%bi.SWr.WebMetrics
}

ClassMethod DropId(valSet, valTxt)
{
	s h =$p(valSet,$C(2),2)
	//w "alert('"_h_"');"
	//s DropName=$LG(^BI.KPID(h),1)
	
	s %session.Data("DropNam")=valTxt
	s %session.Data("DropId")=h
}

ClassMethod Update(UModV, UBsV)
{
 
	d Update^%bi.SWr.WebMetrics(UModV,UBsV)
}

ClassMethod Newkpival(Val, IDcom, c, col)
{
	
	d Newkpival^%bi.SWr.WebMetrics(Val,IDcom,c,col)
}

ClassMethod AddN(ModV, BsV)
{
	s FolV=%session.Get("NameK")
	//s i=1
  	//s comp=$D(^BI.FolderD(i))
	
	/*while (comp'=0)
	{
		
		s FCheck=$LG(^BI.FolderD(i),2)
		if (FolV=FCheck)
		{
			s NF=i	
			
		}
		
		s i=$i(i)
		s comp=$D(^BI.FolderD(i))	
	}
	//w "alert('folder id"_NF_"');"*/
	d AddN^%bi.SWr.WebMetrics(FolV,ModV,BsV)
}

ClassMethod DelSel()
{
	s ToDel=%session.Get("SelModId")
	
	d ##class(%BI.BPM).%DeleteId(ToDel)
}

ClassMethod NewValAdded(loc, loc2, val)
{
	s NewAddVal= %session.Get("tempstore")
	s Lv1= $p(NewAddVal,"||",loc)
	s $p(Lv1,",",loc2)= val
	s $p(NewAddVal,"||",loc)=Lv1
	s %session.Data("tempstore")=NewAddVal
}

ClassMethod ChkFolder(id)
{
	s ret= $$isFolderExist^%bi.SWrt.KPI(id)
	//w "alert('"_ret_"');"	
	w "ret='"_ret_"';"
}

ClassMethod AddLine()
{
	d AddLine^%bi.SWr.WebMetrics()
}

ClassMethod TotLin()
{
	w "Tot='"_%session.Get("TotalLine")_"';"
}

ClassMethod tempSavNam(v, t)
{
	s SesId=%session.Get("SesId")
	s ^ProTemp(SesId,v)=t
}

ClassMethod tempSavV(v, l, t)
{
	s SesId=%session.Get("SesId")
	s ^ProTemp(SesId,v,"V",l)=t
}

ClassMethod AtempSavNam(v, t)
{
	s SesId=%session.Get("SesId")
	s ^ProTempN(SesId,v)=t
}

ClassMethod AtempSavV(v, l, t)
{
	s SesId=%session.Get("SesId")
	s ^ProTempN(SesId,v,"V",l)=t
}

ClassMethod DSav()
{
	//w "alert('Really Save?');"
	d DSav^%bi.SWr.WebMetrics()
	d ShowProCls^%bi.SWr.WebMetrics(0)
}

ClassMethod DDel()
{
	s ToDel=%session.Get("KeepSelect")
	w "alert('Delete this="_ToDel_"');"
	d DDel^%bi.SWr.WebMetrics(ToDel)
}

ClassMethod StoreRThis(val)
{
	s %session.Data("RunThis")=val
}

ClassMethod RThis()
{
	d RThis^%bi.SWr.WebMetrics()
}

ClassMethod KeepSelect(keepid)
{
	s %session.Data("KeepSelect")=keepid
}

ClassMethod TrackSelect(Ptn)
{
	
	s %session.Data("TrackSelect")=Ptn
}

ClassMethod DThis()
{
	d DDel^%bi.SWr.WebMetrics()
}

}
