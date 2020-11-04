Class %BI.SVGCtxtMenu Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	d gen^%bi.SWr.SVGCtxtMenu(%request.Get("objId"),%request.Get("wd"),%request.Get("menu"))
	Quit $$$OK
}

}
