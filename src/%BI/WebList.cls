Class %BI.WebList Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	&html<<html>
	<head>
		<title>#($$$Text("Export To MS Excel-All"))#</title>
	</head>
	<link rel="stylesheet" href="webStyle.css" type="text/css">
	<link rel="stylesheet" href="css/formStyle.css" type="text/css">
	<script language=javascript>
	function openExcelFile(fileName) {
		window.open("%25cspapp.bi.reloadloc.cls?url="+fileName);
	}
	</script>
	<body>
	<div style="margin-bottom:10px;font-size:12pt;font-weight:bold;font-family:arial;">#($$$Text("Excel Files Exported Successfully."))# </div>
	
	<table width="100%" height="95%"  border="0" cellpadding="0" cellspacing="0" class="bdrStyle">
      <tr> 
        <td class="titleBar">#($$$Text("List of generated Excel files."))#</td>
      </tr>
        <tr height=300px style="overflow:hidden"><td height=100% width=100% style=padding:5px;overflow:auto><div class=overFlow style=height:100%;width:100%>
	>
	
	f exi=1:1:$O(%session.Data("EXLIST",""),-1) {
		w !,$$$Text("Excel file")_" #"_exi_" - <div onclick=openExcelFile('"_%session.Data("EXLIST",exi)_"') style=cursor:hand;text-decoration:underline;color:#0000FF class=divMargin>"_%session.Data("EXLIST",exi)_"</div>"	
	}
	k %session.Data("EXLIST")
	&html< </div></td></tr></table>
	#($$$Text("* Click on one of the files to view."))#
	</body>
	</html>>
	
	k %session.Data("EXLIST")
	Quit $$$OK
}

ClassMethod nPg(aVal, DetID, obj, DLSt)
{
	d nPg^%bi.SWr.WebList(aVal,DetID,obj,DLSt)
}

ClassMethod nRec(aVal, DetID, obj, DLSt)
{
	d nRec^%bi.SWr.WebList(aVal,DetID,obj,DLSt)
}

ClassMethod GenDetail(m, Id, detID)
{
	d GenDetail^%bi.SWr.WebList(m,Id,detID)
}

ClassMethod GenList(detID)
{
	;d GenList^%bi.SWr.WebList(detID)
	
	d nGenList^%bi.SWr.WebDList(detID)
	s P1 = $G(%session.Data("DList",detID,2))
	s P6 = $G(%session.Data("DList",detID,6))
	s V1 = $G(%session.Data("DList",detID,7))
	
	w "<script language=javascript>"
	d genRiteMenu^%bi.SWr.WebList(P1,detID,0,P6,V1)
	w "</script>"
}

ClassMethod drillDetList(P0, P1, P2, P3, P4, P5)
{
	d drillDetList^%bi.SWr.WebList(P0,P1,P2,P3,P4,P5)
}

ClassMethod SaveAttcDetailList(P0, P1)
{
	d SaveAttcDetailList^%bi.SWr.WebList(P0,P1)
}

ClassMethod GenExcel(P0, P1, P2, P3, ExcWr)
{
	d Export^%bi.SWr.WebDList(P0,P1,P2,P3,ExcWr)
}

ClassMethod GenIntoEmail(P0, P1, P2)
{
	d GenIntoEmail^%bi.SWr.WebList(P0,P1,P2)
}

// new add in on 25/4/05

ClassMethod GenPDF(P0, P1, P2)
{
	d GenPDF^%bi.SWr.WebList(P0,P1,P2)
}

ClassMethod generatePDFDLList()
{
	d generatePDFDLList^%bi.SWrt.WebPDFDL
}

ClassMethod generatePDFDL(val)
{
	d generatePDFDL^%bi.SWrt.WebPDFDL(val)
}

ClassMethod checkPDFGenerated()
{
	q $$checkPDFGenerated^%bi.SWrt.WebPDFDL()
}

ClassMethod loadPDFData()
{
	d loadPDFData^%bi.SWrt.WebPDFDL()
}

ClassMethod savePDFData(pdfname, pdflogopath)
{
	d savePDFData^%bi.SWrt.WebPDFDL(pdfname,pdflogopath)
}

ClassMethod goPopUp(ctrlID, m, detID, dlRowID)
{
	d goPopUp^%bi.SWr.WebList(ctrlID,m,detID,dlRowID)
}

ClassMethod doPostPopup(sRtn, m, detID)
{
	d doPostPopup^%bi.SWr.WebList(sRtn,m,detID)
}

ClassMethod genText(detId, delim)
{
	d genText^%bi.SWr.WebDListToText(detId, delim)
}

/// added for detail listing verification
ClassMethod Verification(detListID, detId)
{
	
	d Verification^%bi.SWr.WebList(detListID,detId)
}

}
