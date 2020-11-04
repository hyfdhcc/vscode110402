Class %BI.WebDashboard [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod ClearParam(dbId, frmId) As %String
{
	d ClearParam^%bi.SWr.WebDashboard2(dbId,frmId)
}

ClassMethod LoadParam(dbId, frmId) As %String
{
	d LoadParam^%bi.SWr.WebDashboard2(dbId,frmId)
}

ClassMethod ResizeWin(width, height, frmCnt, left, top)
{
	d ResizeWin^%bi.SWr.WebDashboard4(width,height,frmCnt,left,top)
}

ClassMethod SaveParam(dbId, frmId)
{
	d SaveParam^%bi.SWr.WebDashboard2(dbId,frmId)
}

ClassMethod loadDB(P0)
{
	k %session.Data("filRi")
	k %session.Data("filRd")
	k %session.Data("filR")
	k %session.Data("bsInFrm")
	k %session.Data("chtInFrm")
	k %session.Data("spInFrm")
	k %session.Data("gridInFrm")
	k %session.Data("radioButtI")
	#; **Ken 4 August 06 - Kill Board Items session
	#; **Ken 8 Mar 2007 - Commented off because loading another dashboard 
	#; will kill the current dashboard session
	#; k %session.Data("bItems")
	d loadDB^%bi.SWr.WebDashboard2(P0)
}

ClassMethod loadDash(dID, valTxt, w1, w2, n)
{
	n (dID, valTxt,w1,w2,n,%request,%response,%session)
	k %session.Data("prevLocation") 
	s %session.Data("scnH")=$G(w1)
	s %session.Data("scnW")=$G(w2)
	i dID'="" {
		k %session.Data("EditDashboard")
		s:$G(n)'="" %session.Data("EditDashboard") = "1"
		i $E(dID,0,1)="s" {
			s scol=$P(dID,"s",2)
			s currLoc = $LG($G(^BI.WebSCModuleD(scol)),3)
			s scType = $LG($G(^BI.WebSCModuleD(scol)),2)
			i scType=1 {
				s %session.Data("currLocation") = currLoc
				i valTxt="Log Out" w "logout();"
				e  w "reloadIndexWin();"
				s %session.Data("DashBId")=""
			}
			i scType=2 {
				i currLoc=1 {
					w "parent.opImgList();"
				}
				i currLoc=2 {
					w "parent.openLi(0);"
				}
				i currLoc=3 {
					w "parent.openLi(1);"
				}
			}
			q	
		} else {
			s %session.Data("DashBId") = dID
			d ##class(%BI.WebDashboard).AddTrace(dID)
			#;w "window.location.reload();"
			w "window.location.href='"_##class(%CSP.Page).Link("%25cspapp.bi.dashboard.cls")_"';"
			s %session.Data("currLocation")="dashboard.csp"
		}
	} else {
		i %session.Get("DashBId")="" w "window.location.reload();"
		s %session.Data("currLocation")="dashboard.csp"
	}
}

ClassMethod loadShortCuts()
{
	d loadShortCuts^%bi.SWr.WebDashboard2
}

ClassMethod rmOpenDash()
{
	s id = %session.Get("eDashID")
	d rmOpenDash^%bi.SWr.WebDashboard(id)
}

ClassMethod refObj(p0, p1, p2, p3, p4)
{
	n (p0, p1, p2, p3, p4, %request, %response, %session)
	w "timeOut=1;"
	#;w "alert(""p0="_p0_" p1="_p1_" p2="_p2_" p3="_p3_" p4="_p4_""");"
	d refObj^%bi.SWr.WebDashboard(p0,p1,p2,p3,p4)
}

ClassMethod loadADetList(frmID, objID, P0, P1)
{
	n (frmID, objID, %session,P0,P1)
	q $$loadADetList^%bi.SWr.WebDashboard(frmID,objID,P0,P1)
}

ClassMethod firstLoad(dKey, frmID, xtraVal)
{
	n (dKey, frmID, xtraVal, %session)
	d firstLoad^%bi.SWr.WebDashboard2(dKey,frmID,xtraVal)
}

ClassMethod refBS(P0, P1)
{
	n (P0, P1, %session)
	d refBS^%bi.SWr.WebBS(P0,P1)
}

ClassMethod genDetList(oW, oH, cID, dTP, mxS, boID, vF, cF, dbObj)
{
	s oriHeight = oW
	s oriWidth = oH
	s ctrlID = cID
	s dispTP = dTP
	s MixStr2 = mxS
	s vFilter = vF, cFilter=cF
	;w "alert('vFilter"_vFilter_":"_cFilter_"');"
	w "dbObj = document.getElementById('"_dbObj_"');"
	w "if (dbObj!=null) {"
	w dbObj_".innerHTML="""
	s detID = $$genDetList^%bi.SWr.WebDashboard()
	w """;"
	i dispTP'=2 w "sColWd(""tblGrid"_detID_""");"
	w "}"
	i detID'="" {
	s P1 = $G(%session.Data("DList",detID,2))
	s P6 = $G(%session.Data("DList",detID,6))
	s V1 = $G(%session.Data("DList",detID,7))
	d genRiteMenu^%bi.SWr.WebList(P1,detID,0,P6,V1)
	}
	k %session.Data("riteMenu")
}

ClassMethod iMod()
{
	i modID'="" {
		s scObj = ##class(%BI.WebSCModule).%OpenId(modID)	
			;scObj.Param
		s scPm = ##class(%CSP.Page).Link("reporter.csp")
	}
	w "<iFrame id=iF"_boID_" width=100% height=100% frameborder=0 src="_scPm_"></iFrame>"
}

ClassMethod lateCallToPivot()
{
	// Generating the grids filters
	w "<script language='javascript'>"
	// Loading List box or combobox
	i $G(frmeID)="" s frmeID=""
	i $D(frmID) s frmeID=frmID
	s frmSet2 = $$getFrmSet2^%bi.SWr.WebDashboard2(frmeID)
	
	s filCBo = %session.Get("filCBo")
	i filCBo'="" {
		s frmSet2 = $$getFrmSet2^%bi.SWr.WebDashboard2(frmeID)
		f gM=1:1:$L(filCBo,$C(4)) {
			s lblFil = $P(filCBo,$C(4),gM)
			s P0 = $P(lblFil,$C(3),1),P1=$P(lblFil,$C(3),2),P2 = $P(lblFil,$C(3),3) ;7, dbID = $P(lblFil,$C(3),4)
			X "s dimex = $G(%session.Data(""bItems"""_$G(frmSet2)_",""bItm"","_$G(P1)_",20))"
			#; w "alert('1  "_dimex_" : "_$G(cFilter)_"');"
			s xStr = "["_dimex_" ="
			
			i $G(cFilter) [ xStr {
				s tmpCFil = cFilter
				s cFilter = ""
				d getFilterNQueryVar^%bi.SWr.WebDashboard2
				s cFilter = tmpCFil
			}else{
				d getFilterNQueryVar^%bi.SWr.WebDashboard2
			}
			i $G(cP3) '= "" s vFilter = cP3
			s qFilter = cP2
			s boID = P0_P1
			X "s oriHeight = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",6))"
			X "s oriWidth = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",5))"
			X "s SchemaName = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",19))"
			X "s SchemaId = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",18))"
			X "s DefVal = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",15))"
			X "s ctrlTP = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",2))"
			X "s KPISett = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",17))"
			X "s Dimension = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",20))"
			X "s PostAction = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",11))"
			X "s Condition = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",26))"
			X "s KPIFilter = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",23))"
			X "s AllowMultiSelect = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",22))"
			X "s outputvar = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",21))"
			X "s incFontProp = $G(%session.Data(""bItems"""_frmSet2_",""bItm"",3))"
			X "s yesno = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",31))"
			X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",12))"
			#;w "alert('"_defSess_"');"
			s dbKey = P1
			w "db"_boID_".innerHTML="""
			s frmID = frmeID
			s selVal = ""
			i ctrlTP=8 d genCboBox^%bi.SWr.WebDashboard()
			i ctrlTP=9 d genListBox^%bi.SWr.WebDashboard()
			i ctrlTP=30 d genSearchBox^%bi.SWr.WebDashboard4()
			w """;"
			#; **Ken 23 Apr 2007 - To override default value session based on available data
			i $G(selVal) '= "" s DefVal = selVal
			X "s %session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",15)=DefVal"
		}
	}
	k %session.Data("filCBo")

	s filDoc = %session.Get("filDoc")
	i filDoc'="" {
		f gM=1:1:$L(filDoc,$C(4)) {
			s lblFil = $P(filDoc,$C(4),gM)
			s P0 = $P(lblFil,$C(3),1),P1=$P(lblFil,$C(3),2),P2 = $P(lblFil,$C(3),3), defRoot = $P(lblFil,$C(3),4)
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			s vFilter = cP3, qFilter = cP2
			s boID = P0_P1
			s menuID="menu"_boID
			s %session.Data("pivToo")=5
			s stFold = P2
			i defRoot=1 s stFold=""
			;w "db"_boID_".innerHTML="""
			d LoadPivotTableJSCookTree^%bi.SWr.WebMain2(0)
			;w """;"
			w "ctDraw (""DMg"_boID_""", "_menuID_", ctThemeXP1, 'ThemeXP',0,0,2,1,0);"
			
		}
	}
	k %session.Data("filDoc")
	
	s gridInFrm = $G(%session.Data("gridInFrm"))
	i gridInFrm'="" {
		s frmSet2 = $$getFrmSet2^%bi.SWr.WebDashboard2(frmeID)
		f gM=1:1:$L(gridInFrm,$C(2)) {
			s crPiv = $P(gridInFrm,$C(2),gM)
			s P0=$P(crPiv,$C(3),1),P1=$P(crPiv,$C(3),2),P2=$P(crPiv,$C(3),3),P3=$P(crPiv,$C(3),4),P4=$P(crPiv,$C(3),5),P5=$P(crPiv,$C(3),6)
			X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P4_",12))"
			s cP2Out = MixStr
			s vFilterDashx = vFilter
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			#;w "alert('"_cP3_"');"
			i cP2[" OR " s cP2 = "["_cP2_"]"
			i $G(RefTrig)="" {
				i P1'="" {
					s %session.Data("SelVal") = P1
					s tmpPivName=P5
					s dKey = P4
					i $G(fromWF)="" {
						#; s objPiv = ##class(%BI.PivotTable).%OpenId(P1)
						#; i objPiv '= "" d GenTable^%bi.SWr.WebDashboard4(objPiv.PivotClass,$G(cP2),P1,$G(cP3),P0,0)
						d genTableChart^%bi.SWr.GridTable1(P1,$G(cP2),$G(cP3),P0,0)
					}
					s wfPiv = $O(%session.Data("pivAtWFlow",""),-1)
					s wfPiv=wfPiv+1
					s %session.Data("pivAtWFlow",wfPiv)="d genTableChart^%bi.SWr.GridTable1("""_P1_""","""_$G(cP2)_""","""_$$dlrTR2^%bi.SWr.WebMain2($G(cP3),"""","""""")_""","""_P0_""",0)"
					k tmpPivName
				}
			}
		}
	}
	k %session.Data("gridInFrm")
	
	s chtInFrm = $G(%session.Data("chtInFrm"))
	i chtInFrm'="" {
		f gM=1:1:$L(chtInFrm,$C(2)) {
			s crPiv = $P(chtInFrm,$C(2),gM)
			s P0=$P(crPiv,$C(3),1),P1=$P(crPiv,$C(3),2),P2=$P(crPiv,$C(3),3),P3=$P(crPiv,$C(3),4),P4=$P(crPiv,$C(3),5),P5=$P(crPiv,$C(3),6),P6=$P(crPiv,$C(3),7),P7=$P(crPiv,$C(3),8)
			s chtCtrlTP = $G(%session.Data("gCtrlTP",P0))
			X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P6_",12))"
			s cP2Out = MixStr
			s vFilterDashx = vFilter
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			i chtCtrlTP=1 {
				s %session.Data("gCFilter",P0) = $G(cP2)
				s %session.Data("gVFilter",P0) = $G(cP3)
				s ^tmpStore("DashBoard","Chart 1") = ""
				s dKey = P6
				s tmpPivName=P7
				#; s objPiv = ##class(%BI.PivotTable).%OpenId(P1)
				#; i objPiv '= "" d GenTable^%bi.SWr.WebDashboard4(objPiv.PivotClass,$G(cP2),P1,$G(cP3),"pv"_P0,1)
				d genTableChart^%bi.SWr.GridTable1(P1,$G(cP2),$G(cP3),"pv"_P0,1)
			} 		
		}
	}
	k %session.Data("chtInFrm")
	
	s gisInFrm = $G(%session.Data("gisInFrm"))
	i gisInFrm'="" {
		;s frmSet2 = $$getFrmSet2^%bi.SWr.WebDashboard2(frmeID)
		f gM=1:1:$L(gisInFrm,$C(2)) {
			s crPiv = $P(gisInFrm,$C(2),gM)
			s P0=$P(crPiv,$C(3),1),P1=$P(crPiv,$C(3),2),P2=$P(crPiv,$C(3),3),P3=$P(crPiv,$C(3),4),P4=$P(crPiv,$C(3),5),P5=$P(crPiv,$C(3),6)
			;X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P4_",12))"
			;s cP2Out = MixStr
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
				i P1'="" {
					w "BeginGIS('"_P0_"','"_P1_"','"_$G(cP2)_"','"_$G(cP3)_"','"_P5_"','"_P4_"','');"
				}
		}
	}
	k %session.Data("gisInFrm")
	
	s chtInFrm = $G(%session.Data("spInFrm"))
	i chtInFrm'="" {
		f gM=1:1:$L(chtInFrm,$C(2)) {
			s crPiv = $P(chtInFrm,$C(2),gM)
			s P0=$P(crPiv,$C(3),1),P1=$P(crPiv,$C(3),2),P2=$P(crPiv,$C(3),3),P3=$P(crPiv,$C(3),4),P4=$P(crPiv,$C(3),5),P5=$P(crPiv,$C(3),6)
			s chtCtrlTP = $G(%session.Data("gCtrlTP",P0))
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			i P4[" OR " s P4 = "["_P4_"]"
			i P4'="" {
				i $G(cP2)="" s cP2=P4
				e  s cP2=cP2_" AND "_P4
			}
			s %session.Data("gCFilter",P0) = $G(cP2)
			s %session.Data("gVFilter",P0) = $G(cP3)
		}
	}
	k %session.Data("spInFrm")
	
	s gridInFrm = $G(%session.Data("bsInFrm"))
	i gridInFrm'="" {
		f gM=1:1:$L(gridInFrm,$C(2)) {
			s crPiv = $P(gridInFrm,$C(2),gM)
			s P0=$P(crPiv,$C(3),1),P1=$P(crPiv,$C(3),2),P2=$P(crPiv,$C(3),3),P3=$P(crPiv,$C(3),4)
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			i $G(RefTrig)="" {
				i P1'="" {
					;s value = $$WPivot^%bi.SMr.HiQuery4($G(P1),$G(cP2),$G(cP3))
					d loadBS2^%bi.SWr.WebBS("")
					s jobid = %session.%Id()	;$j
					d initData^%bi.SMw.GridTable(jobid,"",P0)
					i $D(^mtemp(jobid,P0,"HC")) {
						d pData^%bi.SMw.GridTable(P0,"")
						w "displayType['"_P0_"'] = 0;"
						w "DisplayTable('"_P0_"',Grid_"_P0_",0);"
					}
				}
			}
		}
	}
	k %session.Data("bsInFrm")
	
	s filR = %session.Get("filR")
	i filR'="" {
		f gM=1:1:$L(filR,$C(4)) {
			s lblFil = $P(filR,$C(4),gM)
			s P0 = $P(lblFil,$C(3),1),P1=$P(lblFil,$C(3),2),P2 = $P(lblFil,$C(3),3)
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			s vFilter = cP3, cFilter = cP2
			w "db"_P0_P1_".innerHTML="""
			;w vFilter_"<br>"_cFilter
			X "s ctrlTP = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",1))"
			X "s oriHeight = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",6))"
			X "s oriWidth = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",5))"
			X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",12))"
			X "s PostAction = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",11))"
			X "s Caption = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",16))"
			X "s KPISett = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",17))"
			X "s KPIFilter = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",23))"

			s dbKey = P1, frmID=P0
			d genLabel^%bi.SWr.WebDashboard
			w """;"
		}
	}
	k %session.Data("filR")
	#; For Detail Listing
	
	s filR = %session.Get("filRd")
	i filR'="" {
		f gM=1:1:$L(filR,$C(4)) {
			s lblFil = $P(filR,$C(4),gM)
			s P0 = $P(lblFil,$C(3),1),P1=$P(lblFil,$C(3),2),P2 = $P(lblFil,$C(3),3)
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			s boID = P0_P1
			s vFilter = cP3, cFilter = cP2
			X "s oriHeight = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",6))"
			X "s oriWidth = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",5))"
			X "s ctrlID = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",1))"
			X "s dispTP = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",3))"
			X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",12))"
			X "s MixStr2 = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",13))"
			X "s Caption = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",16))"
			X "s KPISett = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",17))"
			;w "alert('vFilter: "_vFilter_" cFilter:"_cFilter_"');"
			w "db"_P0_P1_".innerHTML="""
			s detID = $$genDetList^%bi.SWr.WebDashboard()
			w """;"
			i dispTP'=2 w "sColWd(""tblGrid"_detID_""");"
			s cnt = $O(%session.Data("runRefObj",""),-1)
			i cnt>0 {
				;w "alert('"_$G(%session.Data("runRefObj",cnt))_"');"
				s refObjVal = $G(%session.Data("runRefObj",cnt))
				s dlXtraVal = $P(refObjVal,$C(2),4)
				s dlFrmID = $P(refObjVal,$C(2),3)
				s dlDKey = $P(refObjVal,$C(2),2)
				s dlCtrlTP = $P(refObjVal,$C(2),5)
				s dlDefVal = ""
				;s ^TMPDAN2 = dlDefVal_":"_dlCtrlTP_":"_dlDKey_":"_dlFrmID_":"_dlXtraVal
				;w "refObj('"_dlDefVal_"','"_dlDKey_"','"_dlFrmID_"','"_dlXtraVal_"','');"
				d refObj^%bi.SWr.WebDashboard(dlDefVal,dlDKey,dlFrmID,dlXtraVal,"")
			}
			
			i detID'="" {
				s P1 = $G(%session.Data("DList",detID,2))
				s P6 = $G(%session.Data("DList",detID,6))
				s V1 = $G(%session.Data("DList",detID,7))
				d genRiteMenu^%bi.SWr.WebList(P1,detID,0,P6,V1)
			}
			s loadUPDLen = $O(%session.Data("loadUPDL",""),-1)
			f gM2=1:1:+loadUPDLen {
				w $G(%session.Data("loadUPDL",gM2))	
			}
		}
	}
	k %session.Data("filRd")
	// Loading Images
	s filR = %session.Get("filRi")
	i filR'="" {
		
		f gM=1:1:$L(filR,$C(4)) {
			s lblFil = $P(filR,$C(4),gM)
			s P0 = $P(lblFil,$C(3),1),P1=$P(lblFil,$C(3),2),P2 = $P(lblFil,$C(3),3)
			d getFilterNQueryVar^%bi.SWr.WebDashboard2

			i cP2[" OR " s cP2 = "["_cP2_"]"
			s vFilter = cP3, cFilter = cP2
			s boID = P0_P1
			w "db"_boID_".innerHTML="""
			
			;w vFilter_"<br>"_cFilter
			X "s oriHeight = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",6))"
			X "s oriWidth = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",5))"
			X "s ToolTips = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",7))"
			X "s MixStr = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",12))"
			X "s MixStr2 = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",13))"
			X "s DetFld = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",14))"
			X "s DefVal = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",15))"
			X "s Caption = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",16))"
			X "s KPISett = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",17))"
			X "s PostAction = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",11))"
			X "s Dimension = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",20))"
			X "s OutputVar = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",21))"
			X "s KPIFilter = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",23))"
			X "s imgID = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",24))"
			X "s itmPicIsNull = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P1_",25))"
			s vFilter = vFilter_$C(4)_OutputVar_$C(5)_""""_Dimension_""""
			s dbKey = P1, ctrlTP =6
			s frmID = frmeID
			s dbID = %session.Get("DashBId")
			s dObj2 = ##class(%BI.DashBoard).%OpenId(dbID)
			Set uBObj = dObj2.BoardItems.GetAt(P1)
			s detID = $P(lblFil,$C(3),5)
			d genImage^%bi.SWr.WebDashboard
			w """;"
			d dObj2.%Close()
		}
	}
	k %session.Data("filRi")
	s dropDMenu = %session.Get("dropDMenu")
	k %session.Data("dropDMenu")
	i dropDMenu'="" {
		s frmSet2 = $$getFrmSet2^%bi.SWr.WebDashboard2(frmeID)
		f gM=1:1:$L(dropDMenu,$C(2)) {
			X "s wwCoord = $G(%session.Data(""bItems"""_frmSet2_",""dProp""))"
			s wwLeft = $P(wwCoord,$C(2),1), wwTop = $P(wwCoord,$C(2),2)
			s ddMen = $P(dropDMenu,$C(2),gM)
			s divTag = $P(ddMen,$C(3),1),P0= $P(ddMen,$C(3),2),frmID= $P(ddMen,$C(3),3),mixStr=$P(ddMen,$C(3),4),mixStr2=$P(ddMen,$C(3),5),dbKey=$P(ddMen,$C(3),6)
			s hideorshow = $P(ddMen,$C(3),7)
			#;w "alert('"_$G(hideorshow)_"');"
			s boID = frmID_dbKey
			d getSVGDDMenu2^%bi.SWr.WebDDMenu
		}
	}
	s vnInFrm = %session.Get("vnInFrm")
	s cnt = 1
	i vnInFrm'="" {
		f gM=1:1:$L(vnInFrm,$C(4)) {
			s vnFil = $P(vnInFrm,$C(4),gM)
			; P0 = boID
			; P1 = ctrlID
			; P2 = fO
			; P3 = Caption
			; P4 = KPISett
			; P5 = dbKey
			s P0 = $P(vnFil,$C(3),1),P1=$P(vnFil,$C(3),2),P2 = $P(vnFil,$C(3),3),P3 = $P(vnFil,$C(3),4),P4 = $P(vnFil,$C(3),5),P5=$P(vnFil,$C(3),6)
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i cP2[" OR " s cP2 = "["_cP2_"]"
			s vFilter = cP3, cFilter = cP2
			X "s oriHeight = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P5_",6))"
			X "s oriWidth = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P5_",5))"
			d DashVennDiag^%bi.SWr.VanDiagSetup(P1,P4,P3,cFilter,vFilter,"vd"_P0,oriWidth,oriHeight)
		}
	}
	k %session.Data("vnInFrm")
	
	s custCom = %session.Get("custCom")
	k %session.Data("custCom")
	i custCom'="" {
		f gM=1:1:$L(custCom,$C(2)) {
			s cusCM = $P(custCom,$C(2),gM)
			s boID = $P(cusCM,$C(3),1),script2=$P(cusCM,$C(3),2),frmID = $P(cusCM,$C(3),3),P5 = $P(cusCM,$C(3),4)
			s P2=""
			d getFilterNQueryVar^%bi.SWr.WebDashboard2
			i $G(cP2)[" OR " s cP2 = "["_$G(cP2)_"]"
			s vFilter = $G(cP3), cFilter = $G(cP2)
			X "s oriHeight = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P5_",6))"
			X "s oriWidth = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P5_",5))"
			X "s DefVal = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P5_",15))"
			X "s ctrlTP = $G(%session.Data(""bItems"""_frmSet2_",""bItm"","_P5_",2))"
			s dbKey = P5
			;w "alert('"_gM_":"_script2_"');"
			X script2
		}
	}
	s PerfMet = %session.Get("perfMet")
	
	if PerfMet '= ""
	{
		for i = 1:1:$LL(PerfMet)
		{
			s perf = $LG(PerfMet,i)
			s id = $LG(perf,1)
			s boID = $LG(perf,2)
			d DispPerfMetGrp^%bi.SWr.PerfMet(id)
			w "var dragIco = document.getElementById('dragIco"_boID_"');",!
			w "ctDraw('perfMetTree"_boID_"',arrPerfMetGrp,ctThemeXP1,'ThemeXP',0,0,2,null,0);",!
		}
	}
	k %session.Data("perfMet")

	s rptSub = %session.Get("rptSub")
	i rptSub'="" {
		for i = 1:1:$LL(rptSub)
		{
			s rpt = $LG(rptSub,i)
			s P0 = $LG(rpt,1), P1 = $LG(rpt,2)
			s P2 = $LG(rpt,3)
			d MainLoadReptSub^%bi.SWr.ReportSub(P0,P1,P2)
		}
	}
	k %session.Data("rptSub")
	
	s TIMER = %session.Get("MYTIMER")
	
	if TIMER'=""
	{
		d genJAVA^%bi.SWr.DashTimer(TIMER)	
	}
	k %session.Data("MYTIMER")

	s KPIalert = %session.Get("KPIAlert")
	if KPIalert '= "" 
	{
		w "var KPIpage = new Array();"
		for x = 1:1:$LL(KPIalert)
		{
			s bid = $LG($LG(KPIalert,x),1)	
			s kpiid = $LG($LG(KPIalert,x),2)
			w "KPIpage["_bid_"] = new Array();"
			w "KPIpage["_bid_"][0] = new Array("_kpiid_",'*');"	
		}	
	}
	k %session.Data("KPIAlert")
	#; **Ken 11 Apr 2007 - For Component Tree

	s returnVal = $G(%session.Data("returnVal"))
	
	i returnVal'="" {
		//w "alert();"
		s reAdjust=$P(returnVal,$C(3),1)
		i $G(reAdjust2)'="" {s reAdjust=reAdjust_$C(2)_reAdjust2}
		s lasClick=$P(returnVal,$C(3),2)
		s aFrm = $P(returnVal,$C(3),3)
		
		f fM=1:1:$L(aFrm,$C(4)) {
			s aaFrm = $P(aFrm,$C(4),fM)
			i $P(aaFrm,"|",1)'="" {
				;w "firstLoad('"_$P(aaFrm,"|",1)_"','"_$P(aaFrm,"|",2)_"','"_$P(aaFrm,"|",3)_"');"
				//w "alert('loaded?');"
				d firstLoad^%bi.SWr.WebDashboard2($P(aaFrm,"|",1),$P(aaFrm,"|",2),$P(aaFrm,"|",3)_"|"_$P(aaFrm,"|",4)_"|"_$P(aaFrm,"|",6)_"|"_frmeID,$P(aaFrm,"|",5))
			}
		}
		f lC=1:1:$L(lasClick,$C(2)) {
			s lClick = $P(lasClick,$C(2),lC)
			i lClick'="" {d firstClik^%bi.SWr.WebDashboard2	}
		}
		;i reAdjust'="" {w "reAdjustSize('"_reAdjust_"');"}
 	}
 	w "addInfo = '"_dbID_"';"
 	w "frameID = '"_frmeID_"';LoadParam('');"
 	w "</scr","ipt>"
}

ClassMethod chkDash(P0, P1)
{
	d chkDash^%bi.SWr.WebDashboard2(P0,P1)
}

ClassMethod genSearchMenu(P0)
{
	d genSearchMenu^%bi.SWr.WebDashboard4(P0)
}

ClassMethod reloadCondition4Search(P0, P1)
{
	d reloadCondition4Search^%bi.SWr.WebDashboard4(P0,P1)
}

ClassMethod nxtCondition4Search(P0, P1, P2)
{
	d nxtCondition4Search^%bi.SWr.WebDashboard4(P0,P1,P2)
}

ClassMethod SpeedoGetDelList(sRtn)
{
	d SpeedoGetDelList^%bi.SWrt.WebSVGSpeedoJS(sRtn)
}

ClassMethod LoadDashSaveRecent(dID, valTxt, w1, w2)
{
	#; **Ken 21 Mar 2007 - Added calling to add to recent dashboard
	d ##class(%BI.WebDashboard).AddTrace(dID)
	d ##class(%BI.WebDashboard).loadDash(dID, valTxt, w1, w2)
}

ClassMethod AddTrace(dID, type, ref)
{
	#; **Ken 22 Mar 2007 - to save recently opened dashboard
	#; if type = 0 means don't add recent access
	s usrId = $P($G(%session.Data("currUserID")),$C(6),1)
	i ($G(usrId) '= "")&($G(dID) '= "") {
		if $G(ref)=1 {
			s %session.Data("newOrNot") = dID
			s %session.Data("New")= dID
		}
		d open^%bi.SWr.Trace(4,dID,usrId,$G(type))
	}
}

}
