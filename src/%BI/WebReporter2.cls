Class %BI.WebReporter2 Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	s rptId=%session.Get("RptID")
	d GenRpt^%bi.SWr.SVGRpt04(rptId,1,"","")
	Quit $$$OK
}

ClassMethod genReport()
{
	s rptId=%session.Get("RptID")
	s temp=$$genReport^%bi.SWr.SVGRpt04(rptId)
	w "window.open("""_temp_""","""","""");"
}

}
