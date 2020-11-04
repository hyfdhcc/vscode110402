Class %BI.DocMgmt [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod AddFold(Foldtyp, hval, FoldName)
{
	d AddFold^%bi.SWrt.UploadF(Foldtyp, hval,FoldName)
}

ClassMethod AddNFold(sRtn)
{
	d AddNFold^%bi.SWrt.UploadF(sRtn)
}

ClassMethod DelTree(hval, tp)
{
	d DelTree^%bi.SWrt.UploadF(hval,tp)
}

ClassMethod SetHoldSes(loc)
{
	d SetHoldSes^%bi.SWrt.UploadF(loc)
}

ClassMethod SetHoldSes2(loc)
{
	d SetHoldSes2^%bi.SWrt.UploadF(loc)
}

ClassMethod OpenDoc(docid)
{
	d OpenDoc^%bi.SWrt.UploadF(docid)
}

ClassMethod DoDown(hv)
{
	d DoDown^%bi.SWrt.UploadF(hv)
}

ClassMethod UpdateDesc(hv, val)
{
	d UpdateDesc^%bi.SWrt.UploadF(hv,val)
}

ClassMethod AddOrEdit(typ)
{
	
	d AddOrEdit^%bi.SWrt.UploadF(typ)
}

ClassMethod CurrFolderId(FID, FoldNam)
{
	d CurrFolderId^%bi.SWrt.UploadF(FID,FoldNam)
}

ClassMethod HistSes(hv)
{
 	if (hv="N")
 	{
	  s hv=%session.Get("DcId")
 	}
	s %session.Data("Hist")=hv
}

ClassMethod ReloadTree()
{
	d LoadDocTree^%bi.SWrt.UploadF(1)
	//w "alert(DocTree);"
	//w "drawTree ('DocTree', '', DocTree,theme2,0,1);"
}

ClassMethod DPurgeNow()
{
	d DPurgeNow^%bi.SWrt.UploadF()
}

ClassMethod addFolders(parFolder, rClik, all)
{
	s newFold = $$addFolders^%bi.SWrt.UploadF($G(parFolder),rClik,$G(all))
	q newFold
}

ClassMethod delFolders(foldid, rClik, all)
{
	d delFolders^%bi.SWrt.UploadF(foldid,rClik,$G(all))
}

ClassMethod renFolders(parid, foldid, foldname, rClik, all)
{
	d renFolders^%bi.SWrt.UploadF(parid, foldid, foldname,rClik,$G(all))
}

ClassMethod Test(vs)
{
	//s ^ATest=vs
}

ClassMethod DelDoc(vS)
{
	d DelDoc^%bi.SWrt.UploadF(vS)
}

ClassMethod DoGetFileName(Fn)
{
	s LenFi=$l(Fn,"\")
	s Dafile=$p(Fn,"\",LenFi)
	w "NwNam="_##class(%CSP.Page).QuoteJS(Dafile)_";"
}

ClassMethod ReLoadSelDoc(seldoc)
{
	d ReLoadSelDoc^%bi.SWrt.UploadF(seldoc)
}

ClassMethod SetSelDSes(rtn)
{
	s %session.Data("SelectedDoc")=rtn
}

ClassMethod DoResetSelDoc()
{
	s %session.Data("SelectedDoc")=""
}

ClassMethod ShwMenu(ctx)
{
	d ShwMenu^%bi.SWrt.UploadF(ctx)
}

ClassMethod SwapLoc(UD, CurrSelDoc)
{
	//if UD=1 means up
	//UD=2 means down
	d SwapLoc^%bi.SWrt.UploadF(UD,CurrSelDoc)
}

ClassMethod RemoveThis(CurrSelDoc)
{
	d RemoveThis^%bi.SWrt.UploadF(CurrSelDoc)
}

ClassMethod GFolderName(hv)
{
	d GFolderName^%bi.SWrt.UploadF(hv)
}

ClassMethod AddNew(DocName, DocTyp, FoldId, DocDesc, DocLink, DocUp, DocHtml, AddUp, Vset)
{
	//s ^AlaTry("test")=DocHtml
	d AddNew^%bi.SWrt.UploadF(DocName,DocTyp,FoldId,DocDesc,DocLink,DocUp,DocHtml,AddUp,Vset)
}

ClassMethod AddDropV(FoldId)
{
	s OldSes=$g(%session.Data("SelectedDoc"))
	if (OldSes="")
	{
		s FoldId=$p(FoldId,"|",2)	
	}
	s %session.Data("SelectedDoc")=OldSes_FoldId
	d LoadCurrSelDoc2^%bi.SWrt.UploadF(0)
}

ClassMethod LoadCurrSelDoc2()
{
	d LoadCurrSelDoc2^%bi.SWrt.UploadF(0)
}

ClassMethod LoadTxtAr()
{
	d LoadTx^%bi.SWrt.UploadF(0)
}

ClassMethod ResetTxtAr()
{
	s %session.Data("DocHtmlLoc")=""
}

ClassMethod DPointLoc()
{
	//s ^AlaTry("TSS")=%session.Get("DocHtmlLoc")
	s PLoc=$g(%session.Data("DocHtmlLoc"))
	s PLoc=##class(%CSP.Page).QuoteJS(PLoc)
	w "PLoc="_PLoc_";"
}

ClassMethod TempStore(ht)
{
	d TempStore^%bi.SWrt.UploadF(ht)
}

ClassMethod FirstLoad()
{
	d FirstLoad^%bi.SWrt.UploadF()
}

ClassMethod DoDownloadcsp()
{
	d DoDownloadcsp^%bi.SWrt.UploadF()
}

}
