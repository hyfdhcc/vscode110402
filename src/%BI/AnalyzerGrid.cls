Class %BI.AnalyzerGrid Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	d Gen^%bi.SMw.SVGC01(%session.Data("P0"),%session.Data("P1"),%session.Data("P2"),%session.Data("P3"),%session.Data("P4"),%session.Data("P5"),%session.Data("P6"),%session.Data("P7"),"", %session.Data("Width"), %session.Data("Height"),%session.Data("unionRpt"),%session.Data("chtType"))
	Quit $$$OK
}

ClassMethod getDDRptName(rptID)
{
	w "rptName="""_$LG(^BI.PivotTableD(rptID),1)_""";"
}

ClassMethod DCK()
{
}

}
