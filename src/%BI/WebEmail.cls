Class %BI.WebEmail [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod sendEmail(P0, P1, P2, P3, P4)
{
	s usr = $P(%session.Get("currUserID"),$C(6),1)
	d sendSmplEmail^%bi.SWr.WebEmail(P0,P1,P2,P3,usr,P4)
}

}
