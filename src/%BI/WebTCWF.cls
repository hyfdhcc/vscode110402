Class %BI.WebTCWF [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadTCWF(id)
{
	d loadTCWF^%bi.SWr.TCWF(id)
}

ClassMethod loadTempTCWF(id)
{
	d loadTempTCWF^%bi.SWr.TCWF(id)
}

ClassMethod saveTCWF(Tempid, id, valueHeader, valueStation)
{
	d saveTCWF^%bi.SWr.TCWF(Tempid,id,valueHeader,valueStation)
}

ClassMethod saveTempTCWF(id, valueHeader, valueStation)
{
	d saveTempTCWF^%bi.SWr.TCWF(id,valueHeader,valueStation)
}

ClassMethod deleteTCWF(id)
{
	d deleteTCWF^%bi.SWr.TCWF(id)
}

ClassMethod deleteTempTCWF(id)
{
	d deleteTempTCWF^%bi.SWr.TCWF(id)
}

ClassMethod displayTCWFList()
{
	d displayTCWFList^%bi.SWr.TCWF
}

ClassMethod displayTempTCWFList()
{
	d displayTempTCWFList^%bi.SWr.TCWF
}

ClassMethod process(id, code)
{
	d Process^SMTC.01(id,code)
}

ClassMethod getRIdName(id)
{
	d getRIdName^%bi.SWr.TCWF(id)
}

}
