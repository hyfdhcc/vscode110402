Class %BI.WebPerfMet [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddPerfMetRoot(perfMetId, perfMetNodeName, kpiId)
{
	do AddPerfMetRoot^%bi.SWr.PerfMet(perfMetId,perfMetNodeName, kpiId)
}

ClassMethod AddPerfMetNode(perfMetNodeId, perfMetNodeName, kpiId, perfMetId)
{
	do AddPerfMetNode^%bi.SWr.PerfMet(perfMetNodeId, perfMetNodeName, kpiId, perfMetId)
}

ClassMethod ChangeGrp(perfMetId, perfMetNodeId1, perfMetNodeId2)
{
	do ChangeGrp^%bi.SWr.PerfMet(perfMetId, perfMetNodeId1, perfMetNodeId2)
}

ClassMethod ChangeGrpRoot(perfMetId, perfMetNodeId)
{
	do ChangeGrpRoot^%bi.SWr.PerfMet(perfMetId,perfMetNodeId)
}

ClassMethod CreatePerfMet(perfMetName, perfMetFldrId, alertType)
{
	do CreatePerfMet^%bi.SWr.PerfMet(perfMetName,perfMetFldrId,alertType)
}

ClassMethod DelPerfMet(perfMetId)
{
	do DelPerfMet^%bi.SWr.PerfMet(perfMetId)
}

ClassMethod DelPerfMetNode(perfMetNodeId, perfMetId)
{
	do DelPerfMetNode^%bi.SWr.PerfMet(perfMetNodeId,perfMetId)
}

ClassMethod DispPerfMetGrp(perfMetId)
{
	do DispPerfMetGrp^%bi.SWr.PerfMet(perfMetId)
}

ClassMethod DispPerfMetNodeRules(perfMetNodeId)
{
	do DispPerfMetNodeRules^%bi.SWr.PerfMet(perfMetNodeId)
}

ClassMethod GetFldrName(perfMetId)
{
	do GetFldrName^%bi.SWr.PerfMet(perfMetId)
}

ClassMethod GetPerfMetName(id)
{
	do GetPerfMetName^%bi.SWr.PerfMet(id)
}

ClassMethod Init()
{
	do Init^%bi.SWr.PerfMet
}

ClassMethod LoadPicSrc(vId)
{
	do LoadPicSrc^%bi.SWr.PerfMet(vId)
}

ClassMethod RenPerfMetGrp(perfMetId, perfMetNodeId, newName)
{
	do RenPerfMetGrp^%bi.SWr.PerfMet(perfMetId,perfMetNodeId,newName)
}

ClassMethod SaveRule(vRule, vAMsg, vImgId, vKpiId, vPerfMetNodeId, cnt)
{
	do SaveRule^%bi.SWr.PerfMet(vRule, vAMsg, vImgId, vKpiId, vPerfMetNodeId, cnt)
}

ClassMethod UpdatePerfMet(perfMetId, perfMetName, fldrId, alertType)
{
	do UpdatePerfMet^%bi.SWr.PerfMet(perfMetId,perfMetName,fldrId,alertType)
}

ClassMethod GetAlert(id, pid, boID)
{
	d GetAlert2^%bi.SWr.PerfMet2(id,pid,boID)
}

ClassMethod NodeAlert(id, pid, boID)
{
	d NodeAlert^%bi.SWr.PerfMet2(id,pid,boID)
}

ClassMethod DispPerfMetGrp2(perfMetId)
{
	do DispPerfMetGrp^%bi.SWr.PerfMet2(perfMetId)
}

ClassMethod LoadPerfMetData(perfMetId)
{
	d LoadPerfMetData^%bi.SWr.PerfMet(perfMetId)
}

ClassMethod RetPerfMetName(perfMetId)
{
	q $$RetPerfMetName^%bi.SWr.PerfMet(perfMetId)
}

ClassMethod openDetailList(kpiId)
{
	d openDetailList^%bi.SWr.PerfMet2(kpiId)
}

}
