Class %BI.SMSTemplateMod [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod NewTempID(templateName, txtEnglish, txtMalay, txtMandarin, txtThai, txtArabic, txtKorean, txtJapanese, txtGerman)
{
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Desc") = templateName
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Default") = "Malay"
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","English") = txtEnglish
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Malay") = txtMalay
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Mandarin") = txtMandarin
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Thai") = txtThai
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Arabic") = txtArabic
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Korean") = txtKorean
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","Japanese") = txtJapanese
	set ^BI.TrakSMSTemplate(^BI.TrakSMSTemplate,"Lang","German") = txtGerman
	set ^BI.TrakSMSTemplate = $increment(^BI.TrakSMSTemplate)
	if (('$D(^BI.TrakSMSTemplate(0)))||(^BI.TrakSMSTemplate(0)="")) {
		do ##class(%BI.SMSTemplateMod).setDefaultTemplate(templateName)
		w "defaultTemplateEnabled = 0;"
	}
}

ClassMethod Edit(objID, templateName, txtEnglish, txtMalay, txtMandarin, txtThai, txtArabic, txtKorean, txtJapanese, txtGerman)
{
	set ^BI.TrakSMSTemplate(objID,"Desc") = templateName
	set ^BI.TrakSMSTemplate(objID,"Lang","English") = txtEnglish
	set ^BI.TrakSMSTemplate(objID,"Lang","Malay") = txtMalay
	set ^BI.TrakSMSTemplate(objID,"Lang","Mandarin") = txtMandarin
	set ^BI.TrakSMSTemplate(objID,"Lang","Thai") = txtThai
	set ^BI.TrakSMSTemplate(objID,"Lang","Arabic") = txtArabic
	set ^BI.TrakSMSTemplate(objID,"Lang","Korean") = txtKorean
	set ^BI.TrakSMSTemplate(objID,"Lang","Japanese") = txtJapanese
	set ^BI.TrakSMSTemplate(objID,"Lang","German") = txtGerman
}

ClassMethod setDefaultTemplate(templateName)
{
	set ^BI.TrakSMSTemplate(0) = ##class(%BI.SMSTemplateMod).RetrieveTempID(templateName)
}

ClassMethod setDefaultLanguage(templateName, text)
{
	set objID = ##class(%BI.SMSTemplateMod).RetrieveTempID(templateName)
	s ^BI.TrakSMSTemplate(objID,"Lang","Default") = text
}

ClassMethod loadAsterisk(templateName)
{
	set id = ""
	set objID = ##class(%BI.SMSTemplateMod).RetrieveTempID(templateName)
	if ($D(^BI.TrakSMSTemplate(objID,"Lang","Default"))){
		set id = ^BI.TrakSMSTemplate(objID,"Lang","Default")_"Asterisk"
	}
	quit id
}

ClassMethod RetrieveTempName(objID) As %String
{
	q ^BI.TrakSMSTemplate(objID,"Desc")
}

ClassMethod RetrieveTempID(templateName) As %String
{
	
	set objID=""
	set x=0
	for {
		set x = $Order(^BI.TrakSMSTemplate(x))
		quit:x=""
		
		if (^BI.TrakSMSTemplate(x,"Desc") = templateName){
			set objID = x
			quit
		}		
	}
	quit objID
}

ClassMethod RetrieveMsg(language, objID) As %String
{
	q ^BI.TrakSMSTemplate(objID,"Lang",language)
}

ClassMethod Delete(templateName)
{
	set objID = ##class(SMSTemplateMod).RetrieveTempID(templateName)
	kill ^BI.TrakSMSTemplate(objID)
	if $O(^BI.TrakSMSTemplate(0)) '= ""
	{
		if (^BI.TrakSMSTemplate(0) = objID) 
		{
			set xx = $O(^BI.TrakSMSTemplate(objID))
			if (xx = "") s xx = $O(^BI.TrakSMSTemplate(0))
			set ^BI.TrakSMSTemplate(0) = xx
		}
	}
	else {s ^BI.TrakSMSTemplate(0) = ""}
}

ClassMethod ValidateDefault(templateID)
{
	set flag = 0
 	if (^BI.TrakSMSTemplate(0) = templateID){
 		s flag = 1	
 	}
	q flag
}

ClassMethod Validate(templateName, objID)
{
	set flag=0
	set x = ##class(SMSTemplateMod).RetrieveTempID(templateName)
	if (x '= ""){
		set flag = 1	
	}
	if (x = objID){
		set flag = 0
	}
	
	quit flag
}

}
