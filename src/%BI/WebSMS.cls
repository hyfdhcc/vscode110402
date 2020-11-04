Class %BI.WebSMS [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod genTreeMB(mode)
{
	d genTreeMB^%bi.SWr.WebSMS(mode)
}

ClassMethod genTempTree(mode)
{
	d genTempTree^%bi.SWr.WebSMS(mode)
}

ClassMethod saveTemplate(tName, msg, fldrId)
{
	d saveTemplate^%bi.SWr.WebSMS(tName,msg,fldrId)
}

ClassMethod updateTemplate(tName, msg, fldrId, tId)
{
	d updateTemplate^%bi.SWr.WebSMS(tName,msg,fldrId,tId)
}

ClassMethod loadSMS(sId)
{
 	d loadSMS^%bi.SWr.WebSMS(sId)
}

ClassMethod loadSMS2(sId)
{
	d loadSMS2^%bi.SWr.WebSMS(sId)
}

ClassMethod loadTemplate(mode, tId)
{
	d loadTemplate^%bi.SWr.WebSMS(mode,tId)
}

ClassMethod loadSavedContact(contactNo)
{
	d loadSavedContact^%bi.SWr.WebSMS(contactNo)
}

ClassMethod delTemplate(mode, tId)
{
	d delTemplate^%bi.SWr.WebSMS(mode,tId)
}

ClassMethod setpivTooWifJS()
{
 	d setpivToo^%bi.SWr.WebMain2(20)
	d LoadPivotTableJSCookTree^%bi.SWr.WebMain2(20)
}

ClassMethod sendSMS(cNo, Msg, schDetails)
{
	d testSend^%bi.SWr.WebSMS(cNo,Msg,schDetails)
}

ClassMethod deleteSMS(tId)
{
	d deleteSMS^%bi.SWr.WebSMS(tId)
}

ClassMethod sendSMS2(phoneNo, msg)
{
	d sendSMS^%bi.SWr.WebSMS(phoneNo,msg)
}

ClassMethod saveSMSToDraft(cNo, msg)
{
	d saveSMSToDraft^%bi.SWr.WebSMS(cNo,msg)
}

ClassMethod stopStartD(type)
{
	i type="K" { d StopServer^%bi.SWr.msgSMS }
	else  { d runmodem^%bi.SWr.msgSMS w "alert(""Running"");" } //j StartServer^%bi.SWr.msgSMS }
	//d saveSMSToDraft^%bi.SWr.WebSMS(cNo,msg)
}

ClassMethod showFolders(type)
{
	d showFolders^%bi.SWr.WebSMS(type)
}

ClassMethod createFldr(fldrName)
{
	d createFldr^%bi.SWr.WebSMS(fldrName)
}

ClassMethod renFldr(fldrId, fldrName)
{
	d renFldr^%bi.SWr.WebSMS(fldrId,fldrName)
}

ClassMethod delFldr(fldrId)
{
	d delFldr^%bi.SWr.WebSMS(fldrId)
}

ClassMethod extractParameter(val)
{
	w "document.getElementById('taMsg').value +="_##class(%CSP.Page).QuoteJS($$extractParameter^%bi.SWr.WebSMS(val))_"",!
}

ClassMethod extractParameter2(val, para)
{
	w "document.getElementById('pMsgTA').value ="_##class(%CSP.Page).QuoteJS($$extractParameter2^%bi.SWr.WebSMS(val,para))_"",!
}

ClassMethod ChangeStat(id, no, msg)
{
	d ChangeStat^%bi.SWr.WebSMS(id,no,msg)
}

ClassMethod modemStat()
{
	d modemStat^%bi.SWr.msgSMS
}

ClassMethod restart()
{
	d StopServer^%bi.SWr.msgSMS
	s cnt = 0
	H 10
	d StartServer^%bi.SWr.msgSMS
	h 1
	w "alert();"
	w "restarted();"
}

}
