Class %BI.WebWorkFlowE [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadWFNow(P0)
{
	d loadWFNow^%bi.SWr.WebWorkFlowE(P0)
}

ClassMethod clearWFNow()
{
	d clearWFNow^%bi.SWr.WebWorkFlowE
}

ClassMethod saveWorkFlow(P0, P1, P2, P3, P4)
{
	d saveWorkFlow^%bi.SWr.WebWorkFlowE(P0, P1, P2, P3,P4)
}

ClassMethod addWF(P0, P1, P2)
{
	d addWF^%bi.SWr.WebWorkFlowE(P0,P1,P2)
}

ClassMethod setLinkage(P0, P1, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, W0)
{
	d setLinkage^%bi.SWr.WebWorkFlowE(P0,P1,Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,W0)
}

ClassMethod resetCoord(P0, P1, P3, W0)
{
	d resetCoord^%bi.SWr.WebWorkFlowE(P0,P1,P3,W0)
}

ClassMethod getWorkFlowObjProp(P0)
{
	d getWorkFlowObjProp^%bi.SWr.WebWorkFlowE(P0)
}

ClassMethod setWorkFlowObjProp(P0, P1, P2)
{
	d setWorkFlowObjProp^%bi.SWr.WebWorkFlowE(P0,P1,P2)
}

ClassMethod DeleteWF()
{
	d DeleteWF^%bi.SWr.WebWorkFlowE
}

ClassMethod delFlowObj(P0, P1, W0)
{
	d delFlowObj^%bi.SWr.WebWorkFlowE(P0,P1,W0)
}

ClassMethod removeLinkTo(P0, W0, x)
{
	d removeLinkTo^%bi.SWr.WebWorkFlowE(P0,W0,x)
}

ClassMethod removeLinkFrom(P0, W0, x)
{
	d removeLinkFrom^%bi.SWr.WebWorkFlowE(P0,W0,x)
}

}
