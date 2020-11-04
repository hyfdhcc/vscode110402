Class %BI.ChartCus Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
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
	
	d gen^%bi.SWr.ChartCus
	Quit $$$OK
}

ClassMethod dCus(id)
{
	d dCus^%bi.SWr.ChartCus(id)
}

ClassMethod lCus(id)
{
	d lCus^%bi.SWr.ChartCus(id)
}

ClassMethod lCusL()
{
	d lCusL^%bi.SWr.ChartCus
}

ClassMethod sCus(id, nm, desc, help, code)
{
	d sCus^%bi.SWr.ChartCus(id,nm,desc,help,code)
}

}
