Class %BI.WebTableList [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod GenerateHeader(noOfCols, colNm, formNm, chkbox, bgColor)
{
	d GenerateHeader^%bi.SWr.WebTableList(noOfCols, colNm, formNm, chkbox, bgColor)
}

ClassMethod GenerateBodyTRow(listNo, valueList, id, rowBgColor, allowSel)
{
	d GenerateBodyTRow^%bi.SWr.WebTableList(listNo, valueList, id, rowBgColor, allowSel)
}

ClassMethod GenerateFooter(noOfList, footrCtnt, formNm, bgColor, rowBgColor)
{
	d GenerateFooter^%bi.SWr.WebTableList(noOfList, footrCtnt, formNm, bgColor, rowBgColor)
}

ClassMethod GenerateBodyTRow2(dataVal, delimRow, delimCol, rowBgCol, allowSel)
{
	d GenerateBodyTRow2^%bi.SWr.WebTableList(dataVal, delimRow, delimCol, rowBgCol, allowSel)
}

}
