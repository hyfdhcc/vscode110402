Class %BI.ExportList [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadData(set)
{
	//w "alert('"_$ZUTIL(5)_"');"
	d LoadData^%bi.SWr.ExportList(set)
}

ClassMethod LoadDataFolderMgmtExport(set, typf, list)
{
	d LoadDataFolderMgmtExport^%bi.SWr.ExportList(set,typf,list)
}

ClassMethod Export(filenm, type, data, olap)
{
	d Export^%bi.SWr.ExportList(filenm,type,data,olap)
}

ClassMethod LoadClassType(cls, type, list)
{
	d LoadClassType^%bi.SWr.ExportList(cls,$G(type),list)
}

ClassMethod SelectAll(chk)
{
	d SelectAll^%bi.SWr.ExportList(chk)
}

ClassMethod FolderSelectAll(chk, type)
{
	d FolderSelectAll^%bi.SWr.ExportList(chk,type)
}

ClassMethod ViewAll(list)
{
	d ViewAll^%bi.SWr.ExportList(list)
}

ClassMethod ViewAllFolderExport(list)
{
	d ViewAllFolderExport^%bi.SWr.ExportList(list)
}

ClassMethod ViewAllSelected(list, type)
{
	d ViewAllSelected^%bi.SWr.ExportList(list,type)
}

ClassMethod ViewAllSelectedBTS(list, type, currCls)
{
	d ViewAllSelectedBTS^%bi.SWr.ExportList(list,type,currCls)
}

ClassMethod ListStuffSingle(type)
{
	d ListStuffSingle^%bi.SWr.ExportList(type)
}

ClassMethod validOSFileName(name)
{
	q $$validOSFileName^%bi.SWr.WebUtil(name)
}

ClassMethod checkPer(rolePer)
{
	q $$retRolesPermsn^%bi.SWr.WebMain2(rolePer)
}

}
