Class %BI.VennSVG Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	k ^AlaTry
	s vennid=%request.Get("VennID")
	s ^TMPAL("VENN")=vennid
	if (vennid'="")
	{
	
		s daQry=""
		s con=$O(^BI.VennDiagramD(vennid,"Q",""))
		while(con'="")
		{
			s daQryCap=$LG(^BI.VennDiagramD(vennid,"Q",con),1)
			s daQryFilter=$LG(^BI.VennDiagramD(vennid,"Q",con),2)
			if (daQry="")
			{
				s daQry=daQryCap_"|"_daQryFilter	
			}
			else
			{
				s daQry=daQry_"||"_daQryCap_"|"_daQryFilter
			}
			s con=$O(^BI.VennDiagramD(vennid,"Q",con))		
		}	
		
		s DisTab=$D(^BI.VennDiagramD(vennid,"T"))
		if (DisTab=0) 
		{ //if DisTab is 0 here means the global does not exist
		  //so by default will display the Venn diagram
			s DisTabStat=0
		}
		else
		{
			if (^BI.VennDiagramD(vennid,"T")=0)
			{
				// means the that it should display the Venn Diagram
				s DisTabStat=0
			}
			else
			{
				// means that the Table should be shown
				s DisTabStat=1
			}
		}
		s Stat=$$MouldQry^%bi.SWr.VanDiagSetup(daQry)
		
		d genTest^%bi.SWr.VanDiagSetup2(Stat,daQry,%request.Get("ColrID"),%request.Get("clsn"),%request.Get("DWidth"),%request.Get("DHeight"),DisTabStat,vennid,%request.Get("DDiv"),%request.Get("CapName"))
		
	}
	else
	{
	s Stat=$$MouldQry^%bi.SWr.VanDiagSetup(%request.Get("DQry"))
	s ^TMPAL("SVGSTAT")=Stat
	d genTest^%bi.SWr.VanDiagSetup2(Stat,%request.Get("DQry"),%request.Get("ColrID"),"","","",0,"","","")
	}
	Quit $$$OK
}

}
