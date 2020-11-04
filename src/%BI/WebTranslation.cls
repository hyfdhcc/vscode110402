Class %BI.WebTranslation Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	&html<<html>
	<head>
	</head>
	<body>>
	;To do...
	&html<</body>
	</html>>
	Quit $$$OK
}

ClassMethod loadTranslationTable2(module, language)
{
	
	w "alert('module = "_module_" language = "_language_"');"
	d loadTranslationTable^%bi.SWrt.WebTranslation(module,language)
	//d loadDataTypeName^%bi.SWrt.WebTransformation(class)
}

ClassMethod displayTranslation(module, language, id)
{
	q $$displayTranslation^%bi.SWrt.WebTranslation(module,language,id)
}

ClassMethod displayAllTranslation(module, language)
{
	// defualt language = 1
	s language = $CASE($G(%session.Data("wLang"))'="",1:$G(%session.Data("wLang")),0:1)
	q $$displayAllTranslation^%bi.SWrt.WebTranslation(module,language)
}

ClassMethod getGeneralTranslation()
{
	
	// defualt language = 1
	s language = $CASE($G(%session.Data("wLang"))'="",1:$G(%session.Data("wLang")),0:1)
	q $$displayAllTranslation^%bi.SWrt.WebTranslation(100,language)
}

ClassMethod displayTr(module, id)
{
	s language = $G(%session.Data("wLang"))
	//w "alert('language = "_language_"');"
	s language = 1

	q $$displayTranslation^%bi.SWrt.WebTranslation(module,language,id)
}

// displayTranslation(module,language,id)

ClassMethod iniTranslation(language)
{
	d iniTranslation^%bi.SWrt.WebTranslation(language)
}

ClassMethod loadTranslation(module, language)
{
	d loadTranslationTable^%bi.SWrt.WebTranslation(module,language)
}

ClassMethod loadTrTable(module, language)
{
	

	d loadTranslationTable^%bi.SWrt.WebTranslation(module,language)
}

ClassMethod saveAllTranslation(data)
{

	d saveAllTranslation^%bi.SWrt.WebTranslation(data)
}

ClassMethod loadTransSelectBox()
{

	d loadTransSelectBox^%bi.SWrt.WebTranslation()
}

ClassMethod startTranslation()
{

	d startTranslation^%bi.SWrt.WebTranslation()
}

ClassMethod ButtonNam(nn)
{
	s daN=$$DTransBut^%bi.SWrt.WebTranslation(nn)
	w "DaNameTr="""_daN_""" ;"
}

ClassMethod SaveRef(value)
{
	q $$SaveRef^%bi.SWr.WebTranslation(value)
}

ClassMethod Delete(Ref)
{
	d Delete^%bi.SWr.WebTranslation(Ref)
}

ClassMethod SaveTrans(type, lang, Ref, newVal)
{
	d SaveTrans^%bi.SWr.WebTranslation(type,lang,Ref,newVal)
	/*
	w "alert("""_type_""");"
	w "alert("""_lang_""");"
	w "alert("""_Ref_""");"
	w "alert("""_newVal_""");"
	*/
}

ClassMethod LoadTransTable(lang, filterAlp, checkStatus, matchFilter)
{
	d LoadTransTable^%bi.SWr.WebTranslation(lang,filterAlp,checkStatus,matchFilter)
}

ClassMethod LoadSysTable(lang, filterAlp, checkStatus, matchFilter)
{
	d LoadSysTable^%bi.SWr.WebTranslation(lang,filterAlp,checkStatus,matchFilter)
}

ClassMethod export(name, lang)
{
	s ok=$$export^%bi.SWr.WebTranslation(name,lang)
	w "alert('"_$S(ok:$$$Text("Translation exported successfully"),1:$$$Text("Export Translation failed"))_"');"
}

ClassMethod import(name, lang)
{
	set ok = $$import^%bi.SWr.WebTranslation(name,lang)
	w "alert('"_$S(ok:$$$Text("Translation imported successfully"),1:$$$Text("No Translation file found"))_"');"
	//q ok
}

ClassMethod addLang(name, lang)
{
	q $$AddLanguage^%bi.SWr.WebTranslation(name,lang)
}

}
