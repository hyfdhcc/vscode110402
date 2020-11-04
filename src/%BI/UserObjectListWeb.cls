Class %BI.UserObjectListWeb [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod All(loA)
{
	//w "alert('server');"
	d All^%bi.SWr.UserObjectList(loA)
}

ClassMethod Folder(id, loA)
{
	d Folder^%bi.SWr.UserObjectList(id,loA)
}

ClassMethod ListNew()
{
	d ListNew^%bi.SWr.UserObjectList()
}

ClassMethod SaveList(Parr, toDel)
{
	d SaveList^%bi.SWr.UserObjectList(Parr,toDel)
}

ClassMethod DeleteObj(id)
{
	s chk = ##class(%BI.UserObjList).%DeleteId(id)	
	if chk = 1 w "alert('Record deleted');"
}

ClassMethod SetKnowledgeBVal(val, obj)
{
	s %session.Data("bItems",97,"bItm",obj,15) = val
}

ClassMethod GetPicture(id)
{
	d GetPicture^%bi.SWr.UserObjectList(id)
}

ClassMethod GenPicture(id)
{
	d GenPicture^%bi.SWr.UserObjectList(id)
}

ClassMethod SavePicture(id, pid)
{
	d SavePicture^%bi.SWr.UserObjectList(id,pid)
}

}
