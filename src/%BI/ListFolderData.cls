Class %BI.ListFolderData [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod chkID(id)
{
	s chk = $D(^BI.FolderD(id))
	w "fileExistChk = "_chk_";"
}

ClassMethod LoadRoot(chk)
{
	d LoadRoot^%bi.SWr.FolderTest(chk)
}

ClassMethod TestPivot(id, chos, determ)
{
	//w "alert('"_id_"::"_chos_"::"_determ_"');"
	d LoadFiles^%bi.SWr.FolderTest(id,chos,determ)
}

/*ClassMethod ListFolderData(id,chos,determ)
{
	d LoadFiles^%bi.SWr.ListFolderData(id,chos,determ)
}*/
ClassMethod deLete(id, type)
{
	d deLete^%bi.SWr.FolderTest(id,type)
}

ClassMethod OpenFile(id, type)
{
	d OpenFile^%bi.SWr.FolderTest(id,type)
}

ClassMethod LoadAll(chk, byFold, foldId)
{
	d LoadAll^%bi.SWr.FolderTest(chk,byFold,foldId) //byFold added by kevin 29 july 2008 - load  by fold4 export
}

ClassMethod MoveFile(fileId, type, newFold)
{
	d MoveFile^%bi.SWr.FolderTest(fileId,type,newFold)
}

}
