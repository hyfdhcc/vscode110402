Class %BI.Chart Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	
	//JKG - Fix for SVG/HTTPS/IE problem
	s %response.ContentType="image/svg+xml"
	if %request.Secure, %request.UserAgent[" MSIE " {
    	d %response.SetHeader("Cache-Control","private")
	}
	
	quit 1
}

ClassMethod OnPage() As %Status
{
	s X="|"
	s d1S=%request.Get("d1"),d1=$P(d1S,X,1),htD1=$P(d1S,X,2),wdD1=$P(d1S,X,3),ht2D1=$P(d1S,X,4),wd2D1=$P(d1S,X,5)
	s d2S=%request.Get("d2"),d2=$P(d2S,X,1),htD2=$P(d2S,X,2),wdD2=$P(d2S,X,3),ht2D2=$P(d2S,X,4),wd2D2=$P(d2S,X,5)
	s e1=%request.Get("e1"),e2=%request.Get("e2"),cTyp=%request.Get("cTyp"),cSId=%request.Get("cSId"),dDwn=%request.Get("dDwn"),lgP=%request.Get("lgP"),lgD=%request.Get("lgD"),objId=%request.Get("objId"),rLd=%request.Get("rLd")

	s objId = $tr(objId,"x"," ")
		
	
	d genCht^%bi.SWr.Chart(e1,cTyp,%session.Data("CHART",e1,"ht"),%session.Data("CHART",e1,"wd"),%session.Data("CHART",e1,"pivId"),%session.Data("CHART",e1,"p0"),%session.Data("CHART",e1,"p1"),rLd,0,objId)
	Quit $$$OK
}

ClassMethod bSChtProp(objId)
{
	d bSChtProp^%bi.SWr.Chart(objId)
}

ClassMethod drawChart(objId, cTyp, ht, wd, dDwn)
{
	w objId_"_chart.innerHTML="""_$$gen^%bi.SWr.Chart(objId,cTyp,ht,wd,"","","",0,0,dDwn)_""";"
}

ClassMethod lRef(pivId)
{
	d lRef^%bi.SWr.Chart(pivId)
}

ClassMethod rCht(e1)
{
	d rCht^%bi.SWr.Chart(e1)
}

ClassMethod rfCht(e1)
{
	d rfCht^%bi.SWr.Chart(e1)
}

ClassMethod sChtProp(pivId, chtS, barS, linS, pieS, sav, type, objId)
{
	d sChtProp^%bi.SWr.Chart(pivId,chtS,barS,linS,pieS,sav,type,objId)
}

ClassMethod sChtTyp(pivId, cTyp, cN)
{
	d sChtTyp^%bi.SWr.Chart(pivId,cTyp,cN)
}

ClassMethod sCus(pivId, bCus, fCus, sav, type, objId)
{
	d sCus^%bi.SWr.Chart(pivId,bCus,fCus,sav,type,objId)
}

ClassMethod sRef(pivId, refS, sav)
{
	d sRef^%bi.SWr.Chart(pivId,refS,sav)
}

ClassMethod sSes(sesS, subs, X, X2)
{
	s:$G(X)="" X=$C(2) s:$G(X2)="" X2=$C(3)
	d sSes^%bi.SWr.Chart(sesS,$G(subs),X,X2)
}

ClassMethod view(d1, d2, e1, e2, cTyp, cSId, dDwn, lgP, lgD, rLd)
{
	d view^%bi.SWr.Chart(d1,d2,e1,e2,cTyp,cSId,dDwn,lgP,lgD,rLd)
}

ClassMethod setChtWidthHeight(e1, wd, ht)
{
	s %session.Data("CHART",e1,"height") = ht
	s %session.Data("CHART",e1,"width") = wd
}

}
