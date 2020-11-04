Class %BI.WebReporter [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod OnPage() As %Status
{
	&html<<html>
	<head>
	</head>
	<body>>
	;To do...
	&html<</body>
	</html>>
	Quit $$$OK
}

ClassMethod initReporter()
{
	k %session.Data("secAmt")	
	k %session.Data("datRow")
	k %session.Data("AnalyzerBaseCls")
}

ClassMethod RptFrameHdr(obj)
{
}

ClassMethod RptFrameFtr()
{
	&html<
		</div>
		</div>
       </td>
         </tr>
        </table>
        </div>
      </td>
	>
}

ClassMethod loadSections()
{
	d loadSections^%bi.SWr.WebReporter
}

ClassMethod editSec(sSec, high)
{
	s %session.Data("secAmt",sSec) = high
}

ClassMethod setPageProp(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8)
{
	d setPageProp^%bi.SWr.WebReporter2(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8)
}

ClassMethod writeObj(sSec, ttObj, type)
{
	i type=1 {
		w "<div id=rObj"_sSec_"a"_ttObj_" class=defObj onmouseover=setObjDrageable('rObj"_sSec_"a"_ttObj_"','',1,1) onmouseout=unSetResize() oncontextmenu=riteClikMenu(2,'"_sSec_$C(2)_ttObj_"','',70,currObj) onclick=setContentEditable(newWin"_ttObj_"tb"_sSec_")>Label "_ttObj_"</div>"";" ;<div class=defResize><img src='img/resizeBall.jpg'></div>"
	}
}

// Report object related - adding, editing and deleting object.

ClassMethod addObj(type, sSec, xtra, xX, yY)
{
	d addObj^%bi.SWr.WebReporter(type, sSec, xtra, xX, yY)
}

ClassMethod insertImage()
{
	// Not used anymore
	if (%request.IsDefinedMimeData("attPicButton")){
		set picobj=%request.GetMimeData("attPicButton")
		s imageObj = %session.Get("imageObj")
		i (imageObj'="") {
			s objId = %session.Get("imgObjId")
			s objId= $E(objId,5,$L(objId))
			s sSec = $P(objId,"a",1)
			s ttObj = $P(objId,"a",2)
			s id = $G(%session.Data("secAmt",sSec,ttObj,11))
			i $P(id,$C(3),1)=1 {
				s tmpPicOBJ = ##class(%BI.WebTmpPic).%OpenId($P(id,$C(3),2))
				i tmpPicOBJ="" {
					s tmpPicOBJ = ##class(%BI.WebTmpPic).%New()
					s currTMPpic=""
				}
			} else {
				s tmpPicOBJ = ##class(%BI.WebTmpPic).%New()
				s currTMPpic=""
			}
		} else {
			s tmpPicOBJ = ##class(%BI.WebTmpPic).%New()
		}
		do tmpPicOBJ.ThePicture.CopyFrom(picobj)	
		do tmpPicOBJ.%Save()
		s aTempPic = tmpPicOBJ.%Id()
		do tmpPicOBJ.%Close()
		s %session.Data("aTempPic") = 1_$C(3)_aTempPic
	}
}

ClassMethod getPicture(id)
{
	d getPicture^%bi.SWr.WebReporter(id)
}

ClassMethod editObj(objID, type, sSec, changes, cCoord)
{
	d editObj^%bi.SWr.WebReporter(objID, type, sSec, changes, cCoord)
}

ClassMethod retCustSkrip(id, sSec)
{
	d retCustSkrip^%bi.SWr.WebReporter(id, sSec)
}

ClassMethod retCustSkripFld(P0, P1, P2, P3)
{
	d retCustSkripFld^%bi.SWr.WebReporter(P0,P1,P2,P3)
}

ClassMethod retRowBgColor(id, sSec)
{
	d retRowBgColor^%bi.SWr.WebReporter(id, sSec)
}

ClassMethod retPivI(id, sSec)
{
	d retPivI^%bi.SWr.WebReporter(id,sSec)
}

ClassMethod retPgNum()
{
	d retPgNum^%bi.SWr.WebReporter
}

ClassMethod doObjChange(sSec, allChanges, cCoord, nSz, nRoH)
{
	d doObjChange^%bi.SWr.WebReporter(sSec, allChanges, cCoord, nSz,nRoH)
}

ClassMethod reSaveCood(sSec, cCoord)
{
	d reSaveCood^%bi.SWr.WebReporter2(sSec,cCoord)
}

ClassMethod reSaveSize(sSec, newSize)
{
	d reSaveSize^%bi.SWr.WebReporter(sSec, newSize)
}

ClassMethod deleteObj(objID, sSec, cCoord, newSize, nrHi)
{
	d deleteObj^%bi.SWr.WebReporter2(objID, sSec, cCoord, newSize, nrHi)
}

ClassMethod tregenObj(sSec, cCoord, newSize, nrHi)
{
	d tregenObj^%bi.SWr.WebReporter(sSec, cCoord, newSize, nrHi)
}

ClassMethod regenObj(sSec, minus)
{
	// Regen the object holders
	d regenObj^%bi.SWr.WebReporter(sSec, minus)
}

// Data area

ClassMethod addDataArea(sSec, obj, trgt)
{
	n (sSec,%session,obj,trgt)
	d addDataArea^%bi.SWr.WebReporter(sSec, obj, trgt)
}

ClassMethod addFld(val, txt, trgt, onRow, sSec, xX)
{
	// add a field to the data row.
	d addFld^%bi.SWr.WebReporter(val, txt, trgt, onRow, sSec, xX)
}

ClassMethod editFld(nSz, nCood, nTxt, fObj, sSec, nColr, nAli, rHi, rWi, gV, fV)
{
	d editFld^%bi.SWr.WebReporter(nSz, nCood, nTxt, fObj, sSec, nColr, nAli, rHi, rWi, gV, fV)
}

ClassMethod delFld(sSec, trgt, tRow, tFld, nCord, nSz)
{
	d delFld^%bi.SWr.WebReporter(sSec, trgt, tRow, tFld, nCord, nSz)
}

ClassMethod reSaveFldCood(sSec, trgt, tRow, cCoord)
{
	d reSaveFldCood^%bi.SWr.WebReporter(sSec, trgt, tRow, cCoord)
}

ClassMethod reSaveFldSz(sSec, trgt, tRow, nSize)
{
	d reSaveFldSz^%bi.SWr.WebReporter(sSec, trgt, tRow, nSize)
}

ClassMethod reSetRowHi(nrHi)
{
	n (nrHi,%session)
	d reSetRowHi^%bi.SWr.WebReporter2(nrHi)
}

ClassMethod regenFld(sSec, trgt, onRow)
{
	n (sSec, trgt, onRow,%session)
	d regenFld^%bi.SWr.WebReporter(sSec, trgt, onRow)
}

ClassMethod retPageSetup()
{
	;d retPageSetup^%bi.SWr.WebReporter
	s pgMargin = %session.Get("pgMargin")
	s pgSize = %session.Get("pgSize")
	w "<div class=""fontTypeVrdna""><span class=""lfCol"">Top</span><span>"
        w "<input type=""text"" name=""tMarg"" class=""txtField"" value="""_$P(pgMargin,$C(2),1)_""">inch (1/16)"
        w "</span></div>"
	  w "<div class=""fontTypeVrdna""><span class=""lfCol"">Bottom</span><span>"
        w "<input type=""text"" name=""bMarg"" class=""txtField"" value="""_$P(pgMargin,$C(2),2)_""">inch (1/16)"
        w "</span></div>"
	  w "<div class=""fontTypeVrdna""><span class=""lfCol"">Left</span><span>"
        w "<input type=""text"" name=""lMarg"" class=""txtField"" value="""_$P(pgMargin,$C(2),3)_""">inch (1/16)"
        w "</span></div>"
	  w "<div class=""fontTypeVrdna""><span class=""lfCol"">Right</span><span>"
        w "<input type=""text"" name=""rMarg"" class=""txtField"" value="""_$P(pgMargin,$C(2),4)_""">inch (1/16)"
        w "</span></div>"
}

ClassMethod shiftItems(rptID)
{
	s bSec(1) = "RH" 
	s bSec(2) = "RB" 
	s bSec(3) = "RF" 
	s deleteNE = %session.Get("delAny")
	i deleteNE=1 {
		f sSec=1:1:3 {
			s totO = $o(%session.Data("patent",sSec,""),-1)
			//w "alert('"_totO_"');"
			i totO>1 {
				f i=1:1:totO {
					s tPicId = $G(%session.Data("patent",sSec,i))
					i tPicId'=i {
						s ^BI.ReportD(rptID,bSec(sSec),i) = ^BI.ReportD(rptID,"RH",tPicId)
						k ^BI.ReportD(rptID,bSec(sSec),tPicId)
					}
				}
			}
		}
	}
}

// Save Report

ClassMethod saveReport(c1, c2, c3, c4, c5, c6, c7, sSec, n1, n2, n3, n4, n5, n6, n7, rptName, rptNotes, cFoldid, grTyp, nrHi)
{
	d saveReport^%bi.SWr.WebReporter2(c1, c2, c3, c4, c5, c6, c7, sSec, n1, n2, n3, n4, n5, n6, n7, rptName, rptNotes, cFoldid, grTyp, nrHi)
}

ClassMethod selectPivot(pvtID, c1, c2, c3, c4, c5, c6, c7, n1, n2, n3, n4, n5, n6, n7)
{
	d selectPivot^%bi.SWr.WebReporter2(pvtID, c1, c2, c3, c4, c5, c6, c7, n1, n2, n3, n4, n5, n6, n7)
}

ClassMethod selectSQL(query, c1, c2, c3, c4, c5, c6, c7, n1, n2, n3, n4, n5, n6, n7)
{
	d selectSQL^%bi.SWr.WebReporter2(query, c1, c2, c3, c4, c5, c6, c7, n1, n2, n3, n4, n5, n6, n7)
	/*i c1'="" {
		d ..CheckQP(2,c1,c2,c3,c4,c5,c6,c7,n1,n2,n3,n4,n5,n6,n7)
	}
	;s query = $$ModiSQL^%bi.SMw.SVGR01(query)
	s %session.Data("sqlQuery") = query
	d SQLFLD^%bi.SMw.SVGR01(query)
	w "dataMenu = ["
	w "[null, 'Index', null, '0'],"
	f i=1:1:OLIST {
		s theName = OLIST(i)
		s theID = $TR(theName," ","#")
		w "[null, '"_theName_"', null, '"_i_"'],"
	}
	w "];"*/
}

ClassMethod CheckQP(ch, c1, c2, c3, c4, c5, c6, c7, n1, n2, n3, n4, n5, n6, n7)
{
	d CheckQP^%bi.SWr.WebReporter2(ch, c1, c2, c3, c4, c5, c6, c7, n1, n2, n3, n4, n5, n6, n7)
}

ClassMethod clearAllDField()
{
	d clearAllDField^%bi.SWr.WebReporter2
}

ClassMethod clearAllD3Field(sSec, c1, n1)
{
	d clearAllD3Field^%bi.SWr.WebReporter2(sSec, c1, n1)
}

ClassMethod loadReport(choice)
{
	d loadReport^%bi.SWr.WebReporter2(choice)
	/*s %session.Data("pivToo") = choice
	s %session.Data("SelVal") = %session.Get("Folder")
	s %session.Data("listTitle") = "Report List"*/
}

ClassMethod delReport(id)
{
	w "timeOut=1;"
	d delReport^%bi.SWr.WebReporter2(id)
}

ClassMethod delReport2(id)
{
	w "timeOut=1;"
	d delReport2^%bi.SWr.WebReporter2(id)
}

ClassMethod loadRpt(rpt)
{
	d loadRpt^%bi.SWr.WebReporter2(rpt)
}

ClassMethod genPDF()
{
	s %session.Data("genSVGType") = 2
	s str = "Report.csp" ;$$genPDF^%bi.SMw.PDF01()
	q str
}

ClassMethod genSVGRpt()
{
	s %session.Data("genSVGType") = 1
	s str = "Report.csp"
	q str
}

ClassMethod setSQLq(ch, p1, p2)
{
	d setSQLq^%bi.SWr.WebReporter2(ch,p1,p2)
}

ClassMethod setSQL4Grid(p1, p2, p3, p4, p5)
{
	d setSQL4Grid^%bi.SWr.WebReporter2(p1, p2, p3, p4, p5)
}

ClassMethod setPiv4Grid(p1, p2, p3, p4, p5)
{
	d setPiv4Grid^%bi.SWr.WebReporter2(p1, p2, p3, p4, p5)
}

ClassMethod setPgLim(p1)
{
	s %session.Data("pgLimit")=p1
}

ClassMethod loadDSN()
{
	d loadDSN^%bi.SWr.WebReporter2
}

ClassMethod setPRptNm(P0, P1)
{
	s %session.Data("pgPRptNm")=P0
	s %session.Data("svPerm") = P1
}

}
