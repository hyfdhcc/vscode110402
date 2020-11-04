Class %BI.WebMessagingExt [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod setDataJS(pivotDetail, staticCapture)
{
	s msgID = $$setDataJS^%bi.SWr.WebMessagingExt(pivotDetail,staticCapture)
	q msgID
}

ClassMethod getPiv(msgID)
{
	s pivDetail = $$getPivJS^%bi.SWr.WebMessagingExt(msgID)
	q pivDetail
}

ClassMethod setSubjArea(audID)
{
	d setSubjArea^%bi.SWr.WebMessagingExt(audID)
}

ClassMethod loadPivot(sRtn)
{
	d loadPivot^%bi.SWr.WebMessagingExt(sRtn)
}

ClassMethod loadAsPivot(msgID, audID)
{
	d loadAsPivot^%bi.SWr.WebMessagingExt(msgID,audID)
}

ClassMethod loadAsPivot2(sRtn, msgID, audID)
{
	d loadAsPivot2^%bi.SWr.WebMessagingExt(sRtn,msgID,audID)
}

}
