Class %BI.WordExport Extends %CSP.Page [ LegacyInstanceContext, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

Parameter CONTENTTYPE = "application/msword";

/// Required for IE!
Parameter EXPIRES;

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	#; Avoid IE HTTP 1.1 bugs with plugins
	If (%request.UserAgent["MSIE") {
		Set %response.HTTPVersion = "HTTP/1.0"
		If (%request.Secure) {
			#; work-around IE HTTPS bug
			Do %response.SetHeader("Cache-Control","private")
		}
	}
	Quit 1
}

ClassMethod OnPage() As %Status
{
	Set tSC = $$$OK
	Try {
		d GenExcel^%bi.SWr.WebDList(%request.Get("detID"),%request.Get("type"),%request.Get("P2"),%request.Get("P0"),%request.Get("ExcWr"))
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
