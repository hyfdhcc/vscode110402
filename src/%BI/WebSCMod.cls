Class %BI.WebSCMod Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
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

ClassMethod loadAllSCinSelect(P0)
{
	w "selSCStr ="""
	d loadAllSCinSelect^%bi.SWr.WebSCMod(P0)
	w """;"
}

ClassMethod delSCMod(valSet)
{
	s id = $P(valSet,$C(2),1)
	s userid = %session.Get("currUserID")
	s wUID = $P(userid,$C(6),1)
	s usrObj = ##class(%BI.Users).%OpenId(wUID)
	s superUsr=0
	i usrObj'="" {s superUsr = usrObj.FolderSuperUser}
	s cantGoIn=0
	s scTP = $LG($G(^BI.WebSCModuleD(id)),2)
	i superUsr {s cantGoIn=0}
	else { i id<10001 s cantGoIn=1}
	i cantGoIn'=1 {
		s scObj=##class(%BI.WebSCModule).%OpenId(id)
		i scObj'="" {	
			s scTp=scObj.Type
			i (scTp=1)!(scTp=4) {
				s oriUsr = $P(scObj.Param2,$C(2),1)
				i oriUsr'="" {
					i oriUsr'=wUID {
						i superUsr'=1 {
							w "alert('"_$$$Text("You are not super user or the owner. You cannot delete it.")_"');"	
							q	
						}
					}
				} else { s oriUsr = wUID }
			} else {
				i superUsr'=1 {
					w "alert('"_$$$Text("You are not a super user. You cannot delete it.")_"');"	
					q	
				}
			}
		}
		d ##class(%BI.WebSCModule).%DeleteId(id)
		d loadAll^%bi.SWr.WebSCMod
		w "drawTree ('uPTree2', '', ddMenu, theme,0,1);"
	} else {
		w "alert('"_$$$Text("Cannot delete")_"');"	
	}
}

ClassMethod loadAllSCJs()
{
	d loadAll^%bi.SWr.WebSCMod
	w "drawTree ('uPTree2', '', ddMenu, theme,0,1);"
}

ClassMethod saveSCMod(P0, P1)
{
	d saveUpSC^%bi.SWr.WebSCMod(P0,P1)
}

ClassMethod addToSCList(P0)
{
	d addToSCList^%bi.SWr.WebSCMod(P0)
}

ClassMethod addToOLList(P0, P1)
{
	d addToOLList^%bi.SWr.WebSCMod(P0,P1)
}

ClassMethod SetHideVal(P0, P1)
{
	d SetHideVal^%bi.SWr.WebSCMod(P0,P1)
}

ClassMethod swapSCPlace(P0, P1)
{
	d swapSCPlace^%bi.SWr.WebSCMod(P0,P1)
}

ClassMethod remvSCFrmList(P0)
{
	d remvSCFrmList^%bi.SWr.WebSCMod(P0)
}

ClassMethod remvOLFrmList(P0)
{
	s %session.Data("scOL") = ""
	w "uPTree3.innerHTML = """";"
}

ClassMethod loadSCAction(P0)
{
	d loadSCAction^%bi.SWr.WebSCMod(P0)
}

ClassMethod DoCL()
{
	d DoCL^%bi.SWr.WebSCMod()
}

ClassMethod editSCMod(P0)
{
	d loadUpSC2^%bi.SWr.WebSCMod(P0)
}

ClassMethod saveSCMod2(P0, P1)
{
	d saveUpSC^%bi.SWr.WebSCMod(P0,P1)
	d loadAll^%bi.SWr.WebSCMod
	w "drawTree ('uPTree2', '', ddMenu, theme,0,1);"
}

ClassMethod loadAllSCJsFeb08(scID)
{
	d loadUpSC^%bi.SWr.WebSCMod(scID) //get from the db - not called from the pop up screen
	d loadSCPropFeb08^%bi.SWr.WebSCMod(scID) //to load the properties
}

ClassMethod checkCanEdit(inCheckCanEdit)
{
	q $$checkCanEdit^%bi.SWr.WebSCMod(inCheckCanEdit)
}

}
