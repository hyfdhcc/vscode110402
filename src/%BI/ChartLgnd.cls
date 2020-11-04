Class %BI.ChartLgnd Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
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
	d lgnd^%bi.SWr.ChartLgnd(%request.Get("d1"),%request.Get("d2"),%request.Get("e1"),%request.Get("e2"),%request.Get("cTyp"),%request.Get("cSId"),%request.Get("lgP"),%request.Get("lgD"),%request.Get("vw"),%request.Get("objId"))
	Quit $$$OK
}

}
