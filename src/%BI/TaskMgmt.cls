Class %BI.TaskMgmt [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DoAdd(TNam, TDecs, TFold, TScript)
{
	set DAdd=##class(%BI.SMrTask).%New()
	s DAdd.Name=TNam
	s DAdd.Type=1
	s DAdd.Folder=TFold
	s DAdd.Description=TDecs
	s DAdd.TaskScript=TScript
	
	
	d DAdd.%Save()
	
	d LoadTask^%bi.SWr.WebTaskMgmt(0)
}

ClassMethod UpdateTask(NowTask, TNam, TDecs, TFold, TScript)
{
	d UpdateTask^%bi.SWr.WebTaskMgmt(NowTask,TNam,TDecs,TFold,TScript)
}

ClassMethod ShowTask(daTaskId)
{
	d ShowTask^%bi.SWr.WebTaskMgmt(daTaskId)
}

ClassMethod DelTask(NowTask)
{
	d DelTask^%bi.SWr.WebTaskMgmt(NowTask)
}

ClassMethod RedrawT(stat)
{
	d LoadTask^%bi.SWr.WebTaskMgmt(stat)
}

}
