Class %BI.DashboardGrid Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

/// Event handler for <B>PreHTTP</B> event: this is invoked before
/// the HTTP headers for a CSP page have been sent.  All changes to the
/// <class>%CSP.Response</class> class, such as adding cookies, HTTP headers,
/// setting the content type etc. must be made from within the OnPreHTTP() method.
/// Also changes to the state of the CSP application such as changing
/// %session.EndSession or %session.AppTimeout must be made within the OnPreHTTP() method.
/// It is prefered that changes to %session.Preserve are also made in the OnPreHTTP() method
/// as this is more efficient, although it is supported in any section of the page.
/// Return <B>0</B> to prevent <method>OnPage</method> from being called.
ClassMethod OnPage() As %Status
{
	n zzZero,zzMaxHeight,zzMaxWidth,zzStartX,zzChartWidth,zzFirst,zzCOLOR,zzChartAWidth,zzFMetric,zzOneMetric
	n zzOLine,zzLine,zzMinCnt
	#; The line below are moved down from OnPreHTTP method
	s boID=$Get(%request.Data("boID",1))
	s onclickevent = $G(%request.Data("event",1))
	
	s ctrlID = $G(%session.Data("gCtrlID",boID))
	s ctrlTP = $G(%session.Data("gCtrlTP",boID))
	s cFilter = $G(%session.Data("gCFilter",boID))
	s vFilter =$G(%session.Data("gVFilter",boID))
	
	s pWidth = $G(%session.Data("pWidth",boID))
	s pHeight = $G(%session.Data("pHeight",boID))
	s KPIID = $G(%session.Data("pKPISett",boID))
	s isMain = $G(%session.Data("isMain",boID))
	//JKG+
	s autoLoad = $CASE($G(%session.Data("AutoLoad",boID)),0:0,:1)
	set ^JKG=$G(%session.Data("AutoLoad",boID),"NONE")
	k %session.Data("AutoLoad",boID)
	//JKG-
	
	i ctrlTP=1 {
		// Retrieve the pivot table.
		;w $G(ctrlID)_":"_$G(cFilter)_":"_$G(vFilter)
		/*s value = $$WPivot^%bi.SMr.Query1($G(ctrlID),$G(cFilter),$G(vFilter))
		s pObj=##class(%BI.PivotTable).%OpenId(ctrlID)
		;s zzChartType = pObj.ChartFormat
		s zzChartType = $G(^BI.PivotTableD(ctrlID,"CHT"))
		i zzChartType="" s zzChartType = 8
		d pObj.%Close()
		
		// Gen Chart
		
		s zzLblLine2=12,zzLblLine1=14,zzStartY=15,zzStartX=100,zzYLblPos=40
		s zzMaxHeight=pHeight-zzLblLine2-zzLblLine1-zzStartY-zzYLblPos,zzMaxWidth=pWidth-zzStartX-80
		s zzLineNode=1      ; line chart show node
		s PLIST=0
		
		set Label("xAxis")="",Label("yAxis")=$P(^TOM(2),$C(3),1)
		s zzOneMetric=1,zzOLine=OLIST(OLIST),zzFMetric=$P(zzOLine,$C(9),1)
		f zzLine=2:1:$L(zzOLine,$C(9)) if $P(zzOLine,$C(9),zzLine)'=zzFMetric s zzOneMetric=0
		i zzOneMetric s Label("xAxis")=zzFMetric
		
		d hdr^%bi.SMw.SVGC01
		;w zzChartType_"xxxxxxxxxxxxxxxxxxxxxxxxxx"_pWidth_":"_pHeight
		i (zzChartType=0) {
			d pData^%bi.SMw.SVGC03
		} elseif (zzChartType=14) {d pData^%bi.SMw.SVGC04}
		elseif (zzChartType=1)!(zzChartType=8) {d pData^%bi.SMw.SVGC05}
		else { s zzChartType = 8 d pData^%bi.SMw.SVGC05 }
		d close^%bi.SMw.SVGC01*/
	} else {
		//JKG+
		//d Speedo^%bi.SMw.SVGC06($G(%session.Data("gMixStr",boID)),$G(%session.Data("gCaption",boID)))
		d:autoLoad=1 Speedo^%bi.SMw.SVGC06($G(%session.Data("gMixStr",boID)),$G(%session.Data("gCaption",boID)))
		//JKG-
	}
	Quit $$$OK
}

}
