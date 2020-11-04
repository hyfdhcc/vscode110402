Class %BI.TestSVG Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	d genTest^%bi.SWr.TestSVG()
	Quit $$$OK
}

}
