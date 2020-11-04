Class %BI.WebMapTable [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Save(type, data)
{
	d Save^%bi.SWr.WebMapTable(type,data)
}

ClassMethod Delete(type, id)
{
	d Delete^%bi.SWr.WebMapTable(type,id)
}

ClassMethod Update(type, data, oldCode)
{
	d Update^%bi.SWr.WebMapTable(type,data,oldCode)
}

ClassMethod LoadTables(type)
{
	d LoadTables^%bi.SWr.WebMapTable(type)
}

ClassMethod LoadTransTable(group)
{
	d LoadTransTable^%bi.SWr.WebMapTable(group)
}

ClassMethod Warn(type)
{
	d Warn^%bi.SWr.WebMapTable(type)
}

ClassMethod CleanQuote(str) As %String
{
	d CleanQuote^%bi.SWr.WebMapTable(str)
}

ClassMethod LoadSelectorTables(id) As %String
{
	d LoadSelectorTables^%bi.SWr.WebMapTable(id)
}

ClassMethod ReturnVal() As %String
{
	d ReturnVal^%bi.SWr.WebMapTable()
}

ClassMethod SaveGrp(grpName) As %String
{
	d SaveGrp^%bi.SWr.WebMapTable(grpName)
}

ClassMethod EditGrp(group, name) As %String
{
	d EditGrp^%bi.SWr.WebMapTable(group,name)
}

ClassMethod DelGrp(group) As %String
{
	d DelGrp^%bi.SWr.WebMapTable(group)
}

ClassMethod DeleteTrans(group, id) As %String
{
	d DeleteTrans^%bi.SWr.WebMapTable(group,id)
}

}
