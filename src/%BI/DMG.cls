Class %BI.DMG [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod setToGlobal(data)
{
	do setToGlobal^%bi.SWr.DMG(data)
	q
}

ClassMethod setToSession(data, id)
{
	do setToSession^%bi.SWr.DMG(data,id)
	q
}

ClassMethod loadFromSession(id)
{
	do loadFromSession^%bi.SWr.DMG(id)
	q
}

ClassMethod loadFromGlobal()
{
	do loadFromGlobal^%bi.SWr.DMG
	q
}

ClassMethod killBill()
{
	do killBill^%bi.SWr.DMG
	q
}

}
