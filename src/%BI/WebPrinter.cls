Class %BI.WebPrinter [ Abstract, Not ProcedureBlock, StorageStrategy = StorageSQL, System = 4 ]
{

ClassMethod saveData(title, fId, desc, clsname, loop, data, cs, checkbox)
{
	d saveData^%bi.SWr.Printer(title,fId,desc,clsname,loop,data,cs,checkbox)
}

ClassMethod loadData(rId)
{
	d loadData^%bi.SWr.Printer(rId)
}

ClassMethod updateData(title, fId, desc, clsname, loop, data, cs, checkbox, rId)
{
	d updateData^%bi.SWr.Printer(title,fId,desc,clsname,loop,data,cs,checkbox,rId)
}

ClassMethod jsExecution(jsexe)
{
	d jsExecution^%bi.SWr.Printer(jsexe)
}

ClassMethod deleteData(rid)
{
	d deleteData^%bi.SWr.Printer(rid)
}

ClassMethod retrieveEscSeq()
{
	d retrieveEscSeq^%bi.SWr.Printer
}

ClassMethod startPrinting(device, rId)
{
	d startPrinting^%bi.SWr.Printer(device,rId)
}

ClassMethod listclass(name, cname)
{
	d classlist^%bi.SWr.Printer(name,cname)
}

}
