Class %BI.Trees [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod BuildMenu(type, xCut, loadId)
{
	s:'$D(xCut) xCut = 0
	s:'$D(loadId) loadId=""
	d BuildMenu^%bi.SWr.Trees(type,xCut,loadId)
}

ClassMethod delFolder(fldrId, type, loadId)
{
	s:'$D(xCut) xCut = 0
	s:'$D(loadId) loadId=""
	d delFolder^%bi.SWr.Trees(fldrId,type,loadId)
}

ClassMethod renFolders(foldid, folderName, type, loadId)
{
	s:'$D(loadId) loadId=""
	s checkNm = $$validOSFileName^%bi.SWr.WebUtil(folderName)
	if $l(checkNm)'=$l(folderName) {w "alert('"_$$$Text("Your Filename is Invalid. Please Try Another Name.","%BI")_"');" q "Invalid Folder Name"}
	d renFolders^%bi.SWr.Trees(foldid,folderName,type,loadId)
}

ClassMethod addFolders(parId, type, loadId)
{
	s:'$D(xCut) xCut = 0
	s:'$D(loadId) loadId=""
	d addFolders^%bi.SWr.Trees(parId,type,loadId)
}

ClassMethod deleteNode(id, type, chk)
{
	d deleteNode^%bi.SWr.Trees(id,type,chk)
}

}
