Class %BI.WebColorScheme [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadColorScheme()
{
	d LoadColorScheme^%bi.SWrc.WebColorScheme
}

ClassMethod DragNDropLegend()
{
	d DragNDropLegend^%bi.SWrc.WebColorScheme
}

ClassMethod SetColorScheme(sRtn)
{
	d SetColorScheme^%bi.SWrc.WebColorScheme(sRtn)
}

ClassMethod SaveColorScheme(idVal, name, seriesColor, seriesColor2, seriesColor3, backColor, borderColor, fontColor, storeText, storeText2, storeText3)
{
	d SaveColorScheme^%bi.SWrc.WebColorScheme(idVal,name, seriesColor,seriesColor2,seriesColor3,backColor,borderColor,fontColor, storeText, storeText2, storeText3)
}

ClassMethod LoadSchemeValues(idVal)
{
	d LoadSchemeValues^%bi.SWrc.WebColorScheme(idVal)
}

ClassMethod DeSelectScheme()
{
	d DeSelectScheme^%bi.SWrc.WebColorScheme
}

ClassMethod DelScheme(valId)
{
	d DelScheme^%bi.SWrc.WebColorScheme(valId)
}

}
