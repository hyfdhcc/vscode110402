Class %BI.QueryVariableMgmt [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DoAdd(TNam, TDecs, TScript)
{
		set DAdd=##class(%BI.SMrQueryVariable).%New()
		s DAdd.Name=TNam
		////s DAdd.Type=1
		////s DAdd.Folder=TFold
		s DAdd.Description=TDecs
		s DAdd.QueryVariableScript=TScript
		d DAdd.%Save()		
		d LoadQueryVariable^%bi.SWr.WebQueryVariableMgmt(0)
}

ClassMethod UpdateQueryVariable(NowQueryVariable, TNam, TDecs, TScript)
{
		d UpdateQueryVariable^%bi.SWr.WebQueryVariableMgmt(NowQueryVariable,TNam,TDecs,TScript)
}

ClassMethod ShowQueryVariable(daQueryVariableId)
{
		d ShowQueryVariable^%bi.SWr.WebQueryVariableMgmt(daQueryVariableId)
}

ClassMethod DelQueryVariable(NowQueryVariable)
{
		d DelQueryVariable^%bi.SWr.WebQueryVariableMgmt(NowQueryVariable)
}

ClassMethod RedrawT(stat)
{
		d LoadQueryVariable^%bi.SWr.WebQueryVariableMgmt(stat)
}

}
