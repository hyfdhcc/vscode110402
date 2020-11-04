Class %BI.CSPsuper Extends %CSP.Page [ LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter DOMAIN = "%BI";

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

// Parameter PRIVATE = 1;

ClassMethod OnPreHTTP() As %Boolean
{
	q $$OnPreHTTP^%bi.SWr.WebMain
}

}
