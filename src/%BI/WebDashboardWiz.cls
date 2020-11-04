Class %BI.WebDashboardWiz [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddSCGrp(val)
{
	d AddSCGrp^%bi.SWr.WebDashboardWiz(val)
	q
}

/// Main dashboard wizard module
ClassMethod CreateDashboard(type, name, title, foldid, remk, subjArea, detList, menu, imgId, imgWidth, imgHeight, filters, fields, captions, noOfRows, style) As %String
{
	q $$CreateDashboard^%bi.SWr.WebDashboardWiz(type,name,title,foldid,remk,subjArea,detList,menu,imgId,imgWidth,imgHeight,filters,fields,captions,noOfRows,style)
}

ClassMethod DispListingField(ctrl, val)
{
	d DispListingField^%bi.SWr.WebDashboardWiz(ctrl,val)
	q
}

ClassMethod GenArrChild(id, jsArr)
{
	d GenArrChild^%bi.SWr.WebDashboardWiz(id,jsArr)
	q
}

ClassMethod setSubjectArea()
{
	do setSubjectArea^%bi.SWr.WebDashboardWiz
	q
}

ClassMethod setDLClass(P0)
{
	do setDLClass^%bi.SWr.WebDashboardWiz(P0)
	q
}

ClassMethod genTree()
{
	do genTree^%bi.SWr.WebDashboardWiz
	q
}

ClassMethod killWizard()
{
	kill %session.Data("Wizard")
	q
}

}
