Class %BI.WebChartList Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	d gen^%bi.SMw.SVGCtxt02
	Quit $$$OK
}

ClassMethod drawChart(objId, cTyp, ht, wd, dDwn, objId2)
{
	s pivId=$P($G(^mtemp("pivotID",%session.SessionId,objId2)),$C(4),1)
	w objId_"_chart.innerHTML="""_$$gen^%bi.SWr.Chart(objId,cTyp,ht,wd,pivId,"","",0,0,$G(dDwn),$G(objId2))_""";"
	w "aE("_("e1"_objId)_");"
}

ClassMethod genChartList()
{
	s mStr ="<embed id=SVGEmbed type=image/svg-xml src="""_..Link("%25BI.WebChartList.cls")_""" width=""130"" height=""80"" pluginspage=""http://www.adobe.com/svg/viewer/install/""></embed>"
    w "chlb.innerHTML='"_mStr_"';aE(SVGEmbed);"
}

ClassMethod genDashMenu()
{
	s mStr ="<embed src=%BI.SVGCtxtMenu.cls type=image/svg-xml height=86 width=170></embed>"
    w "lblb2.innerHTML='"_mStr_"';"
}

ClassMethod setChtLi(cht)
{
	;k ^mtemp(%session.SessionId,"e1showMe") m ^mtemp(%session.SessionId,"e1showMe")=^mtemp(%session.SessionId,"showMe")
	;s ^BI.ASetupD(%session.SessionId,"e1showMe",6,"Hide Columns")=$G(^BI.ASetupD(%session.SessionId,"showMe",6,"Hide Columns"))
	s %session.Data("chtType")=cht
	q:'$D(%session.Data("Height"))
	s svgStr=$$gen^%bi.SWr.Chart("showMe",cht,%session.Data("Height"),%session.Data("Width"),$G(%session.Data("SelVal")),"","",0,0)
	
	;For Saving Purpose added by GTM
	if $G(%session.Data("SelVal")) = "" {s pivID = 0}
	else {s pivID = $G(%session.Data("SelVal"))}
	s %session.Data(pivID,"CHART","PROP",0) = cht
	
	w "var thBar='';"
	w "if ((typeof Grid_showMe[20] != 'undefined') && (Grid_showMe[20][5] == 1)) { thBar = genTopBanner('showMe'); }"
	w "showMe.innerHTML = thBar+'"_svgStr_"';"
}

}
