Class %BI.ExcelExport Extends %CSP.Page [ LegacyInstanceContext, System = 4 ]
{

Parameter CONTENTTYPE = "application/vnd.ms-excel";

/// Required for IE!
Parameter EXPIRES;

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

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
		i %request.Get("detID")'="" {
			d GenExcel^%bi.SWr.WebDList(%request.Get("detID"),%request.Get("type"),%request.Get("P2"),%request.Get("P0"),%request.Get("ExcWr"))
		}
		else {
			s filterinfo=%request.Get("filterinfo")
			i filterinfo="" {s filterinfo=$G(%session.Data("PIVOT","filterinfo"))}
			d ExportToExcel^%bi.SMw.GridTable(%request.Get("divId"),%request.Get("currentTable"),%request.Get("sid"),%request.Get("type"),%request.Get("drilldowninfo"),filterinfo)	
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
