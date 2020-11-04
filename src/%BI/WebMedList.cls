Class %BI.WebMedList [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod ListDoctor(loc)
{
	do ListDoctor^%bi.SWr.MedList(loc)
}

ClassMethod SearchByDate(locRow, doctor, from, to)
{
	do SearchByDate^%bi.SWr.MedList(locRow,doctor,$ZD($ZDH(from,4),2),$ZD($ZDH(to,4),2))
}

ClassMethod SetSession(str, x)
{
	s %session.Data("smsList",x) = str
}

ClassMethod SetApptAdv(days)
{
	s ^BI.APPT = days
}

ClassMethod SetPath(path)
{
	s ^BI.logPath = path
}

ClassMethod Null()
{
}

ClassMethod SaveConfig(days, msg, validTelco, scheId)
{
	do SaveConfig^%bi.SWr.MedList(days,msg,validTelco,scheId)
}

ClassMethod SaveCustMsg(msg)
{
	do SaveCustMsg^%bi.SWr.MedList(msg)
}

ClassMethod SavePhone(patId, number)
{
	d SavePhone^%bi.SWr.MedList(patId,number)
}

ClassMethod SendEmail(email, msg)
{
	s subj = "Appointment"
	s usrId = %session.Data("UsdId")
	do sendSmplEmail^%bi.SWr.WebEmail(email,"",subj,msg,usrId,"")
}

ClassMethod SendOut(type, recepient, nameStr, dtStr, tmStr, drStr, sexStr, telStr, emailStr, hpStr)
{
	do SendOut^%bi.SWr.MedList(type,recepient,nameStr,dtStr,tmStr,drStr,sexStr,telStr,emailStr,hpStr)
}

ClassMethod SendSms(number, msg)
{
	s number = $TR(number,"~!@#$%^&*()_{}|:""<>?`-=[]\;'.,/abcdefghijklmnopqrstuvwxyz ")
	s retMsg = $$Send^%bi.SWr.SMSmsg(number,msg)
	if retMsg = 0 w "alert('Message Not Sent: "_$G(^SMS("Err"))_"');"
	else  w "alert('Message Successfully Sent');"
}

}
