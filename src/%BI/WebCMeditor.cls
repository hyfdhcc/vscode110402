Class %BI.WebCMeditor [ Abstract, Not ProcedureBlock, System = 4 ]
{

// Editor for metric or computation

// Compute only /////////////////////////////////////////////////

// Usage for retrieving compute value for the respective editor.

// Compute only /////////////////////////////////////////////////

ClassMethod retVal(valIn, chc)
{
	w "timeOut=1;"
	s val = $$retVal^%bi.SWr.WebCMeditor(valIn, chc)
	q val
}

ClassMethod loadDisplayStyle()
{
	d loadDisplayStyle^%bi.SWr.WebCMeditor
}

ClassMethod SaveCompute(name, formula, dFormat, decPoint, procOrder, font, aCapt, aNRow, kpiID, ddN, formula2)
{
	s quiter = $$SaveCompute^%bi.SWr.WebCMeditor(name, formula, dFormat, decPoint,procOrder,font,aCapt,aNRow,kpiID,ddN,formula2)
	q quiter
}

ClassMethod DeleteCompute(gID)
{
	d DeleteCompute^%bi.SWr.WebCMeditor(gID)
}

ClassMethod LoadDescription(selValue)
{
	d LoadDescription^%bi.SWr.WebCMeditor(selValue)
}

// Metric only /////////////////////////////////////////////////

// Usage for retrieving Metric values for the respective editor.

// Metric only /////////////////////////////////////////////////

ClassMethod DisplayMeasures()
{
	d DisplayMeasures^%bi.SWr.WebCMeditor
}

ClassMethod loadMeasure()
{
	d loadMeasure^%bi.SWr.WebCMeditor
}

ClassMethod SaveMetric(name, formula, dFormat, decPoint, qFilter)
{
	s quiter = $$SaveMetric^%bi.SWr.WebCMeditor(name, formula, dFormat, decPoint, qFilter)
	q quiter
}

ClassMethod DeleteMetric(gID)
{
	d DeleteMetric^%bi.SWr.WebCMeditor(gID)
}

ClassMethod LoadDetails()
{
	// Display the compute name - might not be needed.
	d LoadDetails^%bi.SWr.WebCMeditor
}

ClassMethod loadTheProperMet(P0)
{
	d loadTheProperMet^%bi.SWr.WebCMeditor(P0)
}

}
