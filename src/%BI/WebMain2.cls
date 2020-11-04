Class %BI.WebMain2 [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadQueryCom()
{
	d loadQueryCom^%bi.SWr.WebMain2
}

ClassMethod LoadPivotTable(P0)
{
	//w "<script language=javascript> alert('Load'); </script>" 
	d LoadPivotTable^%bi.SWr.WebMain2(P0)
	//w "<script language=javascript> alert('Loaded'); </script>"
}

ClassMethod LoadPivotTableJS(P0)
{
	d LoadPivotTableJS^%bi.SWr.WebMain2(P0)
}

ClassMethod LoadPivotTableJSCookTree(P0)
{
	//for those who hit error, please pass in the extra parameter
	//as "" empty --> extra parameter = isMFold
	w "<script language=javascript>"
	d LoadPivotTableJSCookTree2^%bi.SWr.WebMain2(P0,"")
	w "</script>"
}

ClassMethod LoadPivotTableJSCookTree2(P0)
{
	// Call from Hyperevent.
	//for those who hit error, please pass in the extra parameter
	//as "" empty --> extra parameter = isMFold
	d LoadPivotTableJSCookTree2^%bi.SWr.WebMain2(P0,"")
}

ClassMethod LoadPivotTableJSCookTree3(P0, isMFold)
{
	//for those who hit error, please pass in the extra parameter
	//as "" empty --> extra parameter = isMFold
	w "<script language=javascript>"
	d LoadPivotTableJSCookTree2^%bi.SWr.WebMain2(P0,isMFold)
	w "</script>"
}

ClassMethod LoadPivotTableJSCookTree4(P0, isMFold)
{
	// Call from Hyperevent.
	//for those who hit error, please pass in the extra parameter
	//as "" empty --> extra parameter = isMFold
	d LoadPivotTableJSCookTree2^%bi.SWr.WebMain2(P0,isMFold)
}

ClassMethod genPivotTree(jobid)
{
	d genPivotTree^%bi.SWr.WebMain2
}

ClassMethod rearrangeFldr(fLi, hdList, cnt, iS)
{
	s cnt = $$rearrangeFldr^%bi.SWr.WebMain2(fLi, hdList, cnt, iS)
	q cnt
}

ClassMethod testLa()
{
	D LoadAllFolder^%bi.SMr.Folder1(1)
	s pivotParam = ""
	for i=1:1:OLIST {
		s fLIST(i) = OLIST(i)
	}
		
	s fLIST=OLIST
	d ..rearrangeFldr(.fLIST,.hdList,0,1)
}

ClassMethod setpivToo(pivToo)
{
	//w "timeOut=1;"
	d setpivToo^%bi.SWr.WebMain2(pivToo)
}

ClassMethod setpivToo2(pivToo)
{
	d setpivToo2^%bi.SWr.WebMain2(pivToo)
}

ClassMethod addFolders(parFolder, rClik, all, isMFold)
{
	s newFold = $$addFolders^%bi.SWr.WebMain2($G(parFolder),rClik,$G(all),"") //isMFold is removed - "" is used instead - Kevin 09Jul2008
	q newFold
}

ClassMethod renFolders(parid, foldid, foldname, rClik, all, isMFold)
{
	d renFolders^%bi.SWr.WebMain2(parid, foldid, foldname,rClik,$G(all),"") //isMFold is removed - "" is used instead - Kevin 09Jul2008
}

ClassMethod delFolders(foldid, rClik, all, isMFold)
{
	d delFolders^%bi.SWr.WebMain2(foldid,rClik,$G(all),"") //isMFold is removed - "" is used instead - Kevin 09Jul2008
}

ClassMethod loadUpEverything(user, pivToo, all)
{
	s ret = $$loadUpEverything^%bi.SWr.WebMain2(user, pivToo,all)
	q ret
}

ClassMethod displayTitle(type)
{
	d displayTitle^%bi.SWr.WebMain2(type)
}

ClassMethod dlrTR(str, dlm, rep)
{
	d dlrTR^%bi.SWr.WebMain2(str, dlm, rep)
}

ClassMethod FindId(daid)
{
	d FindId^%bi.SWr.WebMain2(daid)
}

ClassMethod chkIfCanAccess(P0, P1, P2, P3)
{
	w "timeOut=1;"
	i $G(P2)="" s P2 = $$getUserID^%bi.SWr.WebMain2()
	d dashPassword^%bi.SWr.WebDashboard2(P1,"")
	s wCanGoIn = $$chkIfCanAccess^%bi.SWr.WebMain2(P0,P1,P2,P3)
	q wCanGoIn
}

ClassMethod getDLCount(tableid, oriCoor)
{
	//; new feature to allow users to select a detail listing type for only that particular selection of data
	//; completed by Chun Eng on 20/7/2005
	s count = $$getDLCount^%bi.SWr.WebMain2(tableid,oriCoor)
	q count
}

ClassMethod retRolesPermsn(obj)
{
	q $$retRolesPermsn^%bi.SWr.WebMain2(obj)
}

ClassMethod listRecent(objType)
{
	d listRecent^%bi.SWr.WebMain2(objType)
}

ClassMethod CheckIfInMyFold(objId, MyFold)
{
	s:%session.Get("pivToo")'="" pivToo = %session.Get("pivToo")
	q:('pivToo)!(pivToo = "0")
	d CheckIfInMyFold^%bi.SWr.WebMain2(objId,MyFold,pivToo)
}

}
