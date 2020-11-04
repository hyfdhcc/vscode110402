Class %BI.PivotHeader [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod GetPrefJS(pivID)
{
    s fontSet = $G(^BI.PivotHeader(pivID))
    q fontSet
}

ClassMethod SetPrefJS(pivID, fontSet)
{
	i pivID'="" s ^BI.PivotHeader(pivID) = fontSet
	e  s %session.Data("PivotHeaderPref") = fontSet
}

}
