Class %BI.WebQueryVariable [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DoAdd(TNam, TDecs, TScript)
{
		set DAdd=##class(%BI.SMrQueryVariable).%New()
		s DAdd.Name=TNam
		s DAdd.Description=TDecs
		s DAdd.TaskScript=TScript
		d DAdd.%Save()	
		d LoadTask^%bi.SWr.WebQueryVariable(0) //d LoadTask^%bi.SWr.WebTaskMgmt(0)
}

ClassMethod UpdateTask(NowTask, TNam, TDecs, TScript)
{
		d UpdateTask^%bi.SWr.WebQueryVariable(NowTask,TNam,TDecs,TScript)
}

ClassMethod ShowTask(daTaskId)
{
		d ShowTask^%bi.SWr.WebQueryVariable(daTaskId) //d ShowTask^%bi.SWr.WebTaskMgmt(daTaskId)
}

ClassMethod DelTask(NowTask)
{
		d DelTask^%bi.SWr.WebQueryVariable(NowTask) //d DelTask^%bi.SWr.WebTaskMgmt(NowTask)
}

ClassMethod RedrawT(stat)
{
		d LoadTask^%bi.SWr.WebQueryVariable(stat) //d LoadTask^%bi.SWr.WebTaskMgmt(stat)
}

}
