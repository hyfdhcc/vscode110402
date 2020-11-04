Class %BI.FilterLocation [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod checkedLoc(checkNo)
{
	do FilterLoc^%bi.SWr.MedList(checkNo)
	q
}

ClassMethod Reload()
{
	do FilterRow^%bi.SWr.MedList
	q
}

}
