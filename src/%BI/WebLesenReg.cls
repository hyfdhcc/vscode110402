Class %BI.WebLesenReg [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod ChkLic(P0, P1, P2, P3, P4)
{
	d ChkLic^%bi.SWr.WebLesenReg(P0,P1,P2,P3,P4)
}

ClassMethod genLesen(P0, P1, P2, P3, P4, P5)
{
	s genCode = $$GenLicense^%bi.SMr.SpeedL(P0,P1,P2,P3,P4,P5)
	q genCode
}

ClassMethod genCopyFrenly(P0, P1, P2, P3, P4, P5)
{
	d genCopyFrenly^%bi.SWr.WebLesenReg(P0,P1, P2, P3, P4, P5)
}

}
