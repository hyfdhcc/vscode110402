Class %BI.WebADTM [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadDataTypeName(class)
{

	d loadDataTypeName^%bi.SWrt.WebADTM(class)
}

ClassMethod loadDataTypeData(id)
{

	d loadDataTypeData^%bi.SWrt.WebADTM(id)
}

ClassMethod DeleteADTM(id)
{

	d DeleteADTM^%bi.SWrt.WebADTM(id)
}

ClassMethod SaveADTM2(id, typename)
{
	d saveADTM2^%bi.SWrt.WebADTM(id,typename)
	//d SaveADTM^%bi.SWrt.WebADTM(id,typename,day,dow,wk,mth,qtr,per,yr,decpt,rouding,txtconversion,dlm,minchar,mtranslation,ranges,btype,customDim,init)
}

ClassMethod SaveADTM(id, typename, day, dow, wk, mth, qtr, per, yr, decpt, rouding, txtconversion, dlm, minchar, mtranslation, ranges, btype, customDim, init, exValue, startFinPeriod, excludedWords, mthweek, childFunc, ColtSeq, time, timestamp, hourRange)
{

	q $$SaveADTM^%bi.SWrt.WebADTM(id,typename,day,dow,wk,mth,qtr,per,yr,decpt,rouding,txtconversion,dlm,minchar,mtranslation,ranges,btype,customDim,init,exValue,startFinPeriod,excludedWords,mthweek,childFunc,ColtSeq,time,timestamp,hourRange)
}

ClassMethod laodBitMap(id)
{
	d laodBitMap^%bi.SWrt.WebADTM(id)
}

ClassMethod AddBitMap(id, val)
{
	d AddBitMap^%bi.SWrt.WebADTM(id,val)
}

ClassMethod loadPicture(id)
{
	d loadPicture^%bi.SWrt.WebADTM(id)
}

ClassMethod checkADTname(typeName)
{
	q $$checkADTname^%bi.SWrt.WebADTM(typeName)
}

}
