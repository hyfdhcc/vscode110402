Class %BI.RulesSetup [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod addWF(P0, P1, P2)
{
	d addWF^%bi.SWr.RulesSetup(P0,P1,P2)
}

ClassMethod getWorkFlowObjProp(P0)
{
	d getWorkFlowObjProp^%bi.SWr.RulesSetup(P0)
}

ClassMethod setWorkFlowObjProp(P0, P1, P2)
{
	d setWorkFlowObjProp^%bi.SWr.RulesSetup(P0,P1,P2)
}

ClassMethod saveWorkFlow(P0, P1, P2, P3, P4, P5)
{
	d saveWorkFlow^%bi.SWr.RulesSetup(P0,P1,P2,P3,P4,P5)
}

ClassMethod setLinkage(P0, P1, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, W0)
{
	d setLinkage^%bi.SWr.WebWorkFlowE(P0,P1,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,W0)
}

ClassMethod setGoCond(toObj, frmObj, val, val2, val3)
{
	d setGoCond^%bi.SWr.RulesSetup(toObj,frmObj,val,val2,val3)
}

ClassMethod getTheGoCond(P0, P1)
{
	d getTheGoCond^%bi.SWr.RulesSetup(P0,P1)
}

ClassMethod delFlowObj(P0, P1, W0)
{
	d delFlowObj^%bi.SWr.RulesSetup(P0,P1,W0)
}

ClassMethod loadWFNow(P0)
{
	d loadWFNow^%bi.SWr.RulesSetup(P0)
}

ClassMethod clearWFNow()
{
	// Clear off a particular work flow
	k %session.Data("RuleWorkFlowID")
	w "window.location.reload();"
}

ClassMethod deleteWF()
{
	d deleteWF^%bi.SWr.RulesSetup()
}

}
