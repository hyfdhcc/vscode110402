Class %BI.ExportImport [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod export(currType, filename, description, list)
{
	d export^%bi.SWr.Export(currType,filename,description,list)
}

ClassMethod listing(filepath)
{
	d listing^%bi.SWr.Import(filepath)
}

}
