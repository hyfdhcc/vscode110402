Class %BI.WebTransformation [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod alerme()
{
	
	s module = 1
	s language = 1
	w "alert('hihi');"
	//q $$getAllTranslation^%bi.SWrt.WebTranslation(module,language)	
	//d loadDataTypeName^%bi.SWrt.WebTransformation(class)
}

ClassMethod loadDataTypeName(class)
{

	d loadDataTypeName^%bi.SWrt.WebTransformation(class)
}

ClassMethod loadDataTypeData(id)
{

	d loadDataTypeData^%bi.SWrt.WebTransformation(id)
}

ClassMethod DeleteTransformation(id)
{

	d DeleteTransformation^%bi.SWrt.WebTransformation(id)
}

ClassMethod SaveTransformation2(id, typename)
{
	d saveTransformation2^%bi.SWrt.WebTransformation(id,typename)
}

ClassMethod SaveTransformation(id, typename, mtranslation, ranges, casetype, NF, NP, exValue, Jst)
{
	q $$SaveTransformation^%bi.SWrt.WebTransformation(id,typename,mtranslation,ranges,casetype,NF,NP,exValue,Jst)
	//d SaveTransformation^%bi.SWrt.WebTransformation(id,typename,mtranslation,ranges,casetype,NF,NP,exValue)
}

ClassMethod AddBitMap(id, val)
{
	d AddBitMap^%bi.SWrt.WebTransformation(id,val)
}

ClassMethod LoadRangeTable(div, i, Cap)
{
	//s temp = div_"Cap"_i
	//w "tempHTML = tempHTML+'<div id="_div_"Cap"_i_" contenteditable=true>"_##class(%CSP.Page).QuoteJS(Cap)_"</div></td>';"
	//w "tempHTML = tempHTML+<div id=1 contenteditable=true>Test</div></td>"
	//"_##class(%CSP.Page).QuoteJS(Cap)_"
}

ClassMethod CheckTransformationName(typeName)
{
	q $$checkTransformationName^%bi.SWrt.WebTransformation(typeName)
}

}
