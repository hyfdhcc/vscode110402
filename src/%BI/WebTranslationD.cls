Class %BI.WebTranslationD [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod alertme()
{
	w "alert('hihi');"
}

ClassMethod loadTranslation(module, language)
{
	
	s module = 1,language = 1
	w "alert('hihi');"
	//q $$getAllTranslation^%bi.SWrt.WebTranslation(module,language)	
	//d loadDataTypeName^%bi.SWrt.WebTransformation(class)
}

}
