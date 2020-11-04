Class %BI.WebETL [ Abstract, ProcedureBlock, System = 4 ]
{

ClassMethod asc(cls)
{
	d asc^%bi.SWr.WebETL(cls)
}

ClassMethod cFKy(cls, rCls, pNm, fKyS, dlmt, idx)
{
	d cFKy^%bi.SWr.WebETL(cls,rCls,pNm,fKyS,dlmt,idx)
}

ClassMethod clsNm(sqlTblNm, js)
{
	d clsNm^%bi.SWr.WebETL(sqlTblNm,$G(js))
}

ClassMethod compile(cls)
{
	d compile^%bi.SWr.WebETL(cls)
}

ClassMethod dDL(cls)
{
	d dDL^%bi.SWr.WebETL(cls)
}

ClassMethod dDt(cls)
{
	d dDt^%bi.SWr.WebETL(cls)
}

ClassMethod dETL(cls)
{
	d dETL^%bi.SWr.WebETL(cls)
}

ClassMethod dStat(cls, n)
{
	d dStat^%bi.SWr.WebETL(cls,n)
}

ClassMethod gTFHdr(fl, dlmt, cWd)
{
	d gTFHdr^%bi.SWr.WebETL(fl,dlmt,cWd)
}

ClassMethod iSQLF(sql, stR, mxL, gRC)
{
	d iSQLF^%bi.SWr.WebETL(sql,stR,mxL,gRC)
}

ClassMethod lADt(cls)
{
	d lADt^%bi.SWr.WebETL(cls)
}

ClassMethod lAIFS(cls)
{
	d lAIFS^%bi.SWr.WebETL(cls)
}

ClassMethod lAStat(shM)
{
	d lAStat^%bi.SWr.WebETL(shM)
}

ClassMethod lCls(cls)
{
	d lCls^%bi.SWr.WebETL(cls)
}

ClassMethod lClsT(jsT)
{
	d lClsT^%bi.SWr.WebETL(jsT)
}

ClassMethod lDSNS(dsn)
{
	d lDSNS^%bi.SWr.WebETL(dsn)
}

ClassMethod lDQry(dsn, sch, tbl)
{
	d lDQry^%bi.SWr.WebETL(dsn,sch,tbl)
}

ClassMethod lEStat(cls)
{
	d lEStat^%bi.SWr.WebETL(cls)
}

ClassMethod lFld(gWy, sch, tbl, cls, aFld, nKy, oKy, qry, isJDBC, isProc)
{
	d lFld^%bi.SWr.WebETL(gWy,sch,tbl,cls,aFld,nKy,oKy, qry,isJDBC,isProc)
}

ClassMethod lGWy()
{
	d lGWy^%bi.SWr.WebETL
}

ClassMethod lIdx(cls)
{
	d lIdx^%bi.SWr.WebETL(cls)
}

ClassMethod lIdxS(cls)
{
	d lIdxS^%bi.SWr.WebETL(cls)
}

ClassMethod lMltS(mltS)
{
	d lMltS^%bi.SWr.WebETL(mltS)
}

ClassMethod lMsg(cls, msg, stR, mxL)
{
	d lMsg^%bi.SWr.WebETL(cls,msg,stR,mxL)
}

ClassMethod lMsgN(cls, msg, mNo)
{
	d lMsgN^%bi.SWr.WebETL(cls,msg,mNo)
}

ClassMethod lODt(cls, id)
{
	d lODt^%bi.SWr.WebETL(cls,id)
}

ClassMethod lRB(recS, tbl, mxC, id, cls)
{
	d lRB^%bi.SWr.WebETL(recS,tbl,mxC,id,cls)
}

ClassMethod lRec(sql, stR, mxL, gRC, mxC, site, gId)
{
	d lRec^%bi.SWr.WebETL(sql,stR,mxL,gRC,mxC,$G(site),$G(gId))
}

ClassMethod lRecD(sql, stR, mxL, gRC, dsn, mxC)
{
	d lRecD^%bi.SWr.WebETL(sql,stR,mxL,gRC,dsn,mxC)
}

ClassMethod lRel(dsn)
{
	d lRel^%bi.SWr.WebETL(dsn)
}

ClassMethod lStat(cls, n)
{
	d lStat^%bi.SWr.WebETL(cls,n)
}

ClassMethod lTblT(gWy, isJDBC, tbl, view, proc, sch)
{
	d lTblT^%bi.SWr.WebETL(gWy,isJDBC,tbl,view,proc,sch)
}

ClassMethod lTFHdr(file, dlmt, colWd)
{
	d lTFHdr^%bi.SWr.WebETL(file,dlmt,colWd)
}

ClassMethod lTFFld(fld, tCol)
{
	d lTFFld^%bi.SWr.WebETL(fld,tCol)
}

ClassMethod lTFTbl(file)
{
	d lTFTbl^%bi.SWr.WebETL(file)
}

ClassMethod oETLC(cls)
{
	d oETLC^%bi.SWr.WebETL(cls)
}

ClassMethod oRB(cls, mxC, val)
{
	d oRB^%bi.SWr.WebETL(cls,mxC,val)
}

ClassMethod oTxtC(cls)
{
	d oTxtC^%bi.SWr.WebETL(cls)
}

ClassMethod pplt(cls, rNo)
{
	d pplt^%bi.SWr.WebETL(cls,rNo)
}

ClassMethod sETL(new, cls, isODBC, gWy, exS, key, ftr, aIF, mTL, mail, fFN, sql, oOM, noV, bBd, dMt, lADND, qry, srtSz, bISCD, db, cdc, cdcTbl, bRl, fld, ppC, prC, poC, conS, prL, poL, pop, his)
{
	d sETL^%bi.SWr.WebETL(new,cls,isODBC,gWy,exS,key,ftr,aIF,mTL,mail,fFN,sql,oOM,noV,bBd,dMt,lADND,qry,srtSz,bISCD,db,cdc,cdcTbl,bRl,fld,ppC,prC,poC,conS,prL,poL,pop,his)
}

ClassMethod sETLC(gWy, oSch, oTbl, nSch, nTbl, qry, pk1, pk2, cDt, noV, dtM, aFld, fldS, isProc)
{
	d sETLC^%bi.SWr.WebETL(gWy,oSch,oTbl,nSch,nTbl,qry,pk1,pk2,cDt,noV,dtM,aFld,fldS, isProc)
}

ClassMethod sIdx(cls, idxS)
{
	d sIdx^%bi.SWr.WebETL(cls,idxS)
}

ClassMethod sMail(cls, mTo, mSb, mIf)
{
	d sMail^%bi.SWr.WebETL(cls,mTo,mSb,mIf)
}

ClassMethod gSqlFld(qry, dsn)
{
	d gSqlFld^%bi.SWr.WebETL(qry,$G(dsn))
}

ClassMethod sSes(sesS, X, X2)
{
	s:$G(X)="" X=$C(2) s:$G(X2)="" X2=$C(3)
	d sSes^%bi.SWr.WebETL(sesS,X,X2)
}

ClassMethod sTxtC(cls, file, dlmt, noV, dtM, oOM, fFN, pKy, sCD, fldS, cDt, fVDF, mltS)
{
	d sTxtC^%bi.SWr.WebETL(cls,file,dlmt,noV,dtM,oOM,fFN,pKy,sCD,fldS,cDt,fVDF,mltS)
}

ClassMethod toXcl(sql, stR, mxL, mxC, site, type)
{
	d toXcl^%bi.SWr.WebETL(sql,stR,mxL,mxC,$G(site),$G(type))
}

ClassMethod toXclD(sql, stR, mxL, dsn, mxC, sch, tbl, type)
{
	d toXclD^%bi.SWr.WebETL(sql,stR,mxL,dsn,mxC,$G(sch),$G(tbl),$G(type))
}

ClassMethod toXclM(cls, msg, stR, mxL)
{
	d toXclM^%bi.SWr.WebETL(cls, msg, stR, mxL)
}

ClassMethod toXclS(shM)
{
	d toXclS^%bi.SWr.WebETL(shM)
}

ClassMethod toXml(sql, stR, mxL, mxC, site)
{
	d toXml^%bi.SWr.WebETL(sql,stR,mxL,mxC,$G(site))
}

ClassMethod toXmlD(sql, stR, mxL, dsn, mxC, sch, tbl)
{
	d toXmlD^%bi.SWr.WebETL(sql,stR,mxL,dsn,mxC,$G(sch),$G(tbl))
}

ClassMethod tstRn(cls, stR, mxL)
{
	d tstRn^%bi.SWr.WebETL(cls,stR,mxL)
}

ClassMethod uIdx(cls)
{
	d uIdx^%bi.SWr.WebETL(cls)
}

ClassMethod gC(temp)
{
	s str=""
	s rs=##class(%ResultSet).%New("%BI.Roles:ByParentRoleId")
	d rs.Execute(temp)
	while rs.Next()
	{	i str'="" {s str=str_","}
		s str=str_$$nd^%bi.SWr.WebETL("['<img src=treeDnD/theme_XP2/page.gif>','<img src=treeDnD/theme_XP2/page.gif>']",rs.Data("Description"),"")_",",str=str_..gC(rs.Data("ID"))
		i $E(str,$L(str))="," {s str=$E(str,1,$L(str)-1)}
		s str=str_"]"
	}
	q str
}

ClassMethod gP()
{
	s str=""
	s rs=##class(%ResultSet).%New("%BI.Roles:AllParentRoles")
	d rs.Execute()
	while rs.Next()
	{	i rs.Data("pRID")=""
		{	i str'="" {s str=str_","}
			s str=str_$$nd^%bi.SWr.WebETL("['<img src=treeDnD/theme_XP2/page.gif>','<img src=treeDnD/theme_XP2/page.gif>']",rs.Data("Description"),"")_",",str=str_..gC(rs.Data("ID"))
			i $E(str,$L(str))="," {s str=$E(str,1,$L(str)-1)}
			s str=str_"]"
		}
	}
	s str="<script language=javascript>menu=["_str_"];drawTree('tree','',menu,theme,2,2);</script>"
	w str
}

ClassMethod test()
{
	s type="T1"
	s x=""
	f  s x=$O(^BI.CodeTableD(type,x)) q:x=""  d
	. w !,x
}

ClassMethod CheckForSpace(path)
{
        set rs=##class(%ResultSet).%New("%File:FileSet")
        set sc = rs.Execute(path,"*",,1)
        while rs.Next() {
                set name = rs.GetData(1)
                set type = rs.GetData(2)
                if type = "D" {
                        do ..CheckForSpace(name)
                }
                set filename = ##class(%File).GetFilename(name)
                if type = "F", $F(filename," ") {
                        write name,!
                }

        }
        set sc=rs.Close()
}

}
