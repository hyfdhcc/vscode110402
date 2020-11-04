Class %BI.WebCodeTableEnc [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddCategory(nCat, nGrp, nCol, codeStr)
{
	do AddCategory^%bi.SWr.WebCodeTableEnc(nCat,nGrp,nCol,codeStr)
}

ClassMethod DisplayCatList()
{
	do DisplayCatList^%bi.SWr.WebCodeTableEnc()
}

ClassMethod LoadGroup(xxCat)
{
	do LoadGroup^%bi.SWr.WebCodeTableEnc(xxCat)
}

}
