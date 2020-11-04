Class %BI.WebDLimitAcc [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod ChkAccess(stat)
{
	s AccGrant=$$ChkAccess^%bi.SWr.WebDLimitAcc(stat)
	w "AccGrant='"_AccGrant_"';"
}

ClassMethod LimitMenu(valset, pivToo, stShort)
{
	d LimitMenu^%bi.SWr.WebDLimitAcc(valset,pivToo,stShort)
}

}
