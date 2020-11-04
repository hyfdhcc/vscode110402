Class %BI.WebMessaging [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod SendMsgJS(dest, msgTo, msgSubj, msgDue, msgText, pivotDetail, staticCapture, priority)
{
	d SendMsgJS^%bi.SWr.WebMessaging(dest,msgTo,msgSubj,msgDue,msgText,pivotDetail,staticCapture,priority)
}

ClassMethod remLastJS(callFrom)
{
	;remove current user highlight
	i callFrom = "In" {
		; from Inbound
		w "LmsgID='"_%session.Get("LastInMsgID")_"';"
		w "oldRowNum='"_%session.Get("LastInMsgRow")_"';"
	}
	elseif callFrom = "Out" {
		; from Outbound
		w "LmsgID='"_%session.Get("LastOutMsgID")_"';"
		w "oldRowNum='"_%session.Get("LastOutMsgRow")_"';"
	}
	else {
		; from Inbox
		w "LmsgID='"_%session.Get("LastMailMsgID")_"';"
		w "oldRowNum='"_%session.Get("LastMailMsgRow")_"';"	
	}
}

ClassMethod keepLastJS(msgID, rowNum, callFrom)
{
	;set current user highlight
	i callFrom = "In" {
		; from Inbound
		s %session.Data("LastInMsgID") = msgID
		s %session.Data("LastInMsgRow") = rowNum
	}
	elseif callFrom = "Out" {
		; from Outbound
		s %session.Data("LastOutMsgID") = msgID
		s %session.Data("LastOutMsgRow") = rowNum
	}
	else {
		; from Inbox
		s %session.Data("LastMailMsgID") = msgID
		s %session.Data("LastMailMsgRow") = rowNum
	}
}

ClassMethod openMsgJS(msgID)
{
	d openMsgJS^%bi.SWr.WebMessaging(msgID)
}

ClassMethod setSubjArea(audID)
{
	d setSubjArea^%bi.SWr.WebMessaging(audID)
}

ClassMethod loadAsPivot(msgID, audID)
{
	d loadAsPivot^%bi.SWr.WebMessaging(msgID,audID)
}

ClassMethod loadAsPivot2(sRtn, msgID, audID)
{
	d loadAsPivot2^%bi.SWr.WebMessaging(sRtn,msgID,audID)
}

ClassMethod setCurr(msgID)
{
	;set current user highlight
	;session set only when user right clicks
	s callFrom = %session.Data("currMsgFolder")
	s %session.Data(callFrom,"setMsgFolder") = msgID
}

ClassMethod deleteMsg()
{
	s callFrom = %session.Data("currMsgFolder")
	s msgID = %session.Data(callFrom,"setMsgFolder")
	d deleteMsg^%bi.SWr.WebMessaging(msgID,callFrom)
}

ClassMethod loadTaskJS(msgID)
{
	; loads the sessions used by Task
	d loadTaskJS^%bi.SWr.WebMessaging(msgID)
}

ClassMethod saveTaskJS(msgID, sentDate, dueDate, taskStatus, taskPrior, taskCompletion, completedDate)
{
	; save task settings
	d saveTaskJS^%bi.SWr.WebMessaging(msgID,sentDate,dueDate,taskStatus,taskPrior,taskCompletion,completedDate)
}

ClassMethod setReFwd(msgID, sendType)
{
	d setReFwd^%bi.SWr.WebMessaging(msgID, sendType)
}

ClassMethod remReFwd()
{
	s %session.Data("msgReFwdRecipient") = ""
	s %session.Data("msgReFwdSubject") = ""
	s %session.Data("msgReFwdContent") = ""
}

}
