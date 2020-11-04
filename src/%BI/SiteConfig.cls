Class %BI.SiteConfig Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadTree()
{
	d bTree^%bi.SWr.SiteConfig()
	q
}

ClassMethod LoadData(cat As %String, fid As %String, flag As %Integer)
{
	; 1) Load fields for the category selected and display
	; 2) Retrieve all the comments for each field into javascript array
	
	d ld^%bi.SWr.SiteConfig(cat, fid, flag)
	q
}

ClassMethod SaveData(parent As %String, child As %String, type As %Integer, data As %String)
{
	d sd^%bi.SWr.SiteConfig(parent, child, type, data)
	q
}

}
