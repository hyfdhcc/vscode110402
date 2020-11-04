Class %BI.WebDashboardE Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

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

ClassMethod loadDB()
{
	s dbID = %session.Get("eDashID")
	i dbID'="" {
		d loadDB^%bi.SWr.WebDashboardE4(dbID)	
	}
}

ClassMethod saveDB(P0, P1)
{
	s dbID = %session.Get("eDashID")
	i dbID'="" {
		d saveDB^%bi.SWr.WebDashboardE(dbID,P0,P1)	
	}
}

ClassMethod editObj(P0, P1, P2, P3)
{
	d editObj^%bi.SWr.WebDashboardE(P0,P1,P2,P3)
}

ClassMethod chkGrp(P0)
{
	set rtn = $$chkGrp^%bi.SWr.WebDashboardE(P0)
	q rtn
}

ClassMethod addObj(P0, P1, P2)
{
	d addObj^%bi.SWr.WebDashboardE(P0,P1,P2)
}

ClassMethod genReport()
{
	d genReport^%bi.SWr.WebDashboard
}

ClassMethod setDashbProp(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15, P16)
{
	d setDashbProp^%bi.SWr.WebDashboardE3(P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16)
}

ClassMethod loadImgIDPicIn(P0)
{
	d loadImgIDPicIn^%bi.SWr.WebDashboardE(P0)
}

ClassMethod loadImgIDPicIn2(P0, P1)
{
	d loadImgIDPicIn2^%bi.SWr.WebDashboardE(P0,P1)
}

ClassMethod exitDE()
{
	d exitDE^%bi.SWr.WebDashboardE2
}

ClassMethod regenDB()
{
	d regenDB^%bi.SWr.WebDashboardE2
}

ClassMethod setNewOrNot(dbID)
{
	k:dbID="" %session.Data("dProp")
	s %session.Data("newOrNot")=dbID
	s %session.Data("closeDProp")=0
}

ClassMethod loadConditionJS(P0, P1)
{
	d loadConditionJS^%bi.SWr.WebDashboardE2(P0,$G(P1))
}

ClassMethod editPicObj(P0, P1)
{
	d editPicObj^%bi.SWr.WebDashboardE(P0,P1)
}

ClassMethod setRefTrig(P0, P1)
{
	d setRefTrig^%bi.SWr.WebDashboardE2(P0,P1)
}

ClassMethod setFilterObj(P0, P1)
{
	d setFilterObj^%bi.SWr.WebDashboardE2(P0,P1)
}

ClassMethod redrawLine(P0, P1, P2)
{
	d redrawLine^%bi.SWr.WebDashboardE2(P0,P1,P2)
}

ClassMethod deleteObj(P0, P1, P2)
{
	d deleteObj^%bi.SWr.WebDashboardE2(P0,P1,P2)
}

ClassMethod sent2Back(P0, P1, P2)
{
	d sent2Back^%bi.SWr.WebDashboardE2(P0, P1, P2)
}

ClassMethod bring2Front(P0, P1, P2)
{
	d bring2Front^%bi.SWr.WebDashboardE2(P0, P1, P2)
}

ClassMethod alert27(key)
{
	s tmpPic = $G(%session.Data("ebItems",key,27))
	s fil = $G(%session.Data("ebItems",key,11))
	s trig = $G(%session.Data("ebItems",key,10))
	w "alert('"_tmpPic_":"_fil_":"_trig_"');"
}

ClassMethod duplicateDashB(P0)
{
	d duplicateDashB^%bi.SWr.WebDashboardE2(P0)
}

ClassMethod saveDup(P0, P1, P2)
{
	d saveDup^%bi.SWr.WebDashboardE2(P0,P1,$G(P2))
}

ClassMethod setPostAction(P0, P1)
{
	d setPostAction^%bi.SWr.WebDashboardE2(P0,P1)
}

ClassMethod chosePostAction(P0)
{
	d chosePostAction^%bi.SWr.WebDashboardE2(P0)
}

ClassMethod duplicateObj(P0, P1, P2)
{
	d duplicateObj^%bi.SWr.WebDashboardE2(P0,P1,P2)
}

ClassMethod deleteAllLineToObj(P0, P1, P2)
{
	d deleteAllLineToObj^%bi.SWr.WebDashboardE2(P0,P1,P2)
}

ClassMethod deleteDsb()
{
 	s dbID = %session.Get("eDashID")
	k %session.Data("DashBId")
	s ret = ##class(%BI.DashBoard).%DeleteId(dbID)
	s ret = 1
	i (ret) {
		w "alert('"_$$$Text("Dashboard Successfully Deleted")_"');"
		w "window.close();"
		w "window.opener.refreshWin();"
	} else {w "alert('"_$$$Text("Unable to Delete Dashboard")_"');"}
}

ClassMethod updateChg(P0, P1, P2)
{
	d updateChange^%bi.SWr.WebDashboardE3(P0,P1,P2)
}

ClassMethod saveDBm()
{
	d saveDB^%bi.SWr.WebDashboardE3
}

ClassMethod delChg(dKey)
{
	d delChg^%bi.SWr.WebDashboardE3(dKey)
}

ClassMethod deleteDSBdirect(dID, rClik)
{
	s retVal = $$retRolesPermsn^%bi.SWr.WebMain2("4,4")
	i (retVal) {
		s dbID =$P(dID,$C(2),2)
		i (dbID=%session.Get("DashBId")) k %session.Data("DashBId")
		s ret = ##class(%BI.DashBoard).%DeleteId(dbID)
		i (ret) w "alert('Dashboard successfully deleted');" e  w "alert('Unable to delete dashboard');"	
		d LoadPivotTableJSCookTree^%bi.SWr.WebMain2(0)
		w "ctDraw (""pivotTree"", menu, ctThemeXP1, 'ThemeXP',0,0,2,1,0);"
	} else {
		w "alert('Permission denied, you are not allowed to delete dashboard');"
	}
}

ClassMethod deleteDSBdirect2(dID, rClik)
{
	s retVal = $$retRolesPermsn^%bi.SWr.WebMain2("4,4")
	i (retVal) {
		s dbID =$P(dID,$C(2),2)
		i (dbID=%session.Get("DashBId")) k %session.Data("DashBId")
		s ret = ##class(%BI.DashBoard).%DeleteId(dbID)
		i (ret) w "alert('Dashboard successfully deleted');" e  w "alert('Unable to delete dashboard');"	
		//d LoadPivotTableJSCookTree^%bi.SWr.WebMain2(0)
		//w "ctDraw (""pivotTree"", menu, ctThemeXP1, 'ThemeXP',0,0,2,1,0);"
		d BuildMenu^%bi.SWr.Trees(4)
		w "GenTree(""pivotTree"",""treeArr"");"
	} else {
		w "alert('Permission denied, you are not allowed to delete dashboard');"
	}
}

ClassMethod resetSzCd(P0, P1)
{
	d resetSzCd^%bi.SWr.WebDashboardE(P0,P1)
}

ClassMethod setSRtn(P0)
{
	d setSRtn^%bi.SWr.WebDashboardE3(P0)
}

ClassMethod addToList(P0, P1)
{
	d addToList^%bi.SWr.WebDashboardE4(P0,P1)
}

ClassMethod remFrmList(P0, P1, P2)
{
	d remFrmList^%bi.SWr.WebDashboardE4(P0,P1,P2)
}

ClassMethod addAll(P0, P1)
{
	d addAll^%bi.SWr.WebDashboardE4(P0,P1)
}

ClassMethod remAll(P0)
{
	d remAll^%bi.SWr.WebDashboardE4(P0)
}

ClassMethod setSubjectArea()
{
	d setSubjectArea^%bi.SWr.WebDashboardE3
}

ClassMethod setDLClass(P0)
{
	d setDLClass^%bi.SWr.WebDashboardE3(P0)
}

ClassMethod loadListingField(P0)
{
	d loadListingField^%bi.SWr.WebDashboardE3(P0)
}

ClassMethod setDataObj(P0)
{
	s ^TMPDAN= P0
}

ClassMethod loadSubjNDetLi4Frame(P0)
{
	d loadSubjNDetLi4Frame^%bi.SWr.WebDashboardE3(P0)
}

ClassMethod setSubjectArea4Frame()
{
	d setSubjectArea4Frame^%bi.SWr.WebDashboardE3
}

ClassMethod setDLClass4Frame(P0)
{
	d setDLClass4Frame^%bi.SWr.WebDashboardE3(P0)
}

ClassMethod generateSampleScript(P0)
{
	d generateSampleScript^%bi.SWr.WebDashboardE3(P0)
}

ClassMethod CheckBorder(objId) As %String
{
	q $$CheckBorder^%bi.SWr.WebDashboardE4(objId)
}

ClassMethod refreshWin()
{
	s xDB = $G(%session.Data("newOrNot"))
	s xxDB = $G(%session.Data("New"))
	k %session.Data("newOrNot"),%session.Data("New")
	
	//for strategymap
	k %session.Data("StrategyMap")
	k %session.Data("StrategyMapD")
	k %session.Data("StrategyMapI")
	//end
	if xxDB'="" w "if(window.opener){window.opener.LoadDashSaveRecent('"_xxDB_"');}"
}

ClassMethod LineCoords(id, from, to)
{
	//s oriHeight = $G(%session.Data("ebItems",dbKey,6))
		//s oriWidth = $G(%session.Data("ebItems",dbKey,7))
	//s %session.Data("ebItems",id,6) = from
	//s %session.Data("ebItems",id,7) = to
	s %session.Data("ebItems",id,33) = from_"/"_to
}

ClassMethod LabelObjectProp(dkey)
{
	s val = $G(%session.Data("ebItems",dkey,17))
	q val
}

ClassMethod UpdateLabel(id, val)
{
	s dkey = $E(id,3,999)
	
	if (id'=""),$D(%session.Data("ebItems",dkey)),(%session.Data("ebItems",dkey,2)=5)
	{
		s currCap = %session.Data("ebItems",dkey,17)
		if $P(currCap,$C(2),2)=""
		{
			s %session.Data("ebItems",dkey,17) = val
			w "document.getElementById('"_id_"').firstChild.innerHTML = "_##class(%CSP.Page).QuoteJS(val)_";" q
		}
	}
	w "document.getElementById('PB_L').value = '';"
}

}
