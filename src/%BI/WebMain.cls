Class %BI.WebMain [ Abstract, Not ProcedureBlock, System = 4 ]
{

// Login and logout functionality

ClassMethod UserLogin() As %String
{
	d UserLogin^%bi.SWr.WebMain
}

ClassMethod UserLoginEcho() As %String
{
	d UserLoginEcho^%bi.SWr.WebMain
}

ClassMethod logOff()
{
	d logOff^%bi.SWr.WebMain
}

ClassMethod checkLoginStatus(way)
{
	n (%session,way)
	// Check User Status
	s status = %session.Get("usrStatus")
	i status'=1 {
		i $G(way)="" {
			w "<script language=javascript>"	
			w "window.parent.location.href='login.csp?logoff=2';"
			w "</script>"
		} else {q}
	}
	q 1
}

// License functionality

ClassMethod DisplayLicense()
{
	w "[License here]"
}

// Nav panel functionality

ClassMethod LoadQuickLinks()
{
	d LoadQuickLinks^%bi.SWr.WebMain
}

ClassMethod loadAllShortCuts()
{
	d loadAllShortCuts^%bi.SWr.WebMain
}

ClassMethod getShortcutLinks()
{
	s sApp = $$getShortcutLinks^%bi.SWr.WebMain
	q sApp
}

ClassMethod LoadQuickAppLinks()
{
	d LoadQuickAppLinks^%bi.SWr.WebMain
}

ClassMethod loadClasses()
{
	d loadClasses^%bi.SWr.WebMain
}

ClassMethod tagClass(tag, cls)
{
	d tagClass^%bi.SWr.WebClsDesc(tag,cls)
}

ClassMethod AddOLAP(cls)
{
	d AddOLAP^%bi.SWr.WebClsDesc(cls)
}

ClassMethod MarkOLAP(cls, onoff, delim)
{
	d MarkOLAP^%bi.SWr.WebClsDesc(cls,onoff,delim)
}

ClassMethod callJavaApp()
{
	s a = $ZF(-1,"java -classpath d:\web testconnection")
}

ClassMethod setBaseCls(baseCls, saID)
{
	d setBaseCls^%bi.SWr.WebMain(baseCls,saID)
}

ClassMethod setCurrPage(thePg)
{
	s stats = $$setCurrPage^%bi.SWr.WebMain(thePg)	
	q stats
}

ClassMethod killAllPictures()
{
	d killAllPictures^%bi.SWr.WebMain
}

ClassMethod killReportSessions()
{
	d killReportSessions^%bi.SWr.WebMain
}

ClassMethod reCheckLogin()
{
	s logPass = $$reCheckLogin^%bi.SWr.WebMain()
	q logPass
}

ClassMethod redirectURL()
{
	s newURL = $$redirectURL^%bi.SWr.WebMain()
	q newURL
}

ClassMethod goToUsrPref()
{
	s currUsr = $G(%session.Data("UsdId"))
	s roleId = $G(%session.Data("CurrRoleID"))
	s moduleOnLogin = $$getSCOL^%bi.SWr.WebMain(currUsr,roleId)
	i moduleOnLogin '= "" {
		
		s type=$l(moduleOnLogin,"*")
		
		i type=2 {
			s %session.Data("DashBId") = $p(moduleOnLogin,"*",2)
			s %session.Data("currLocation") = "dashboard.csp"
		} elseif type=1 {
			s %session.Data("currLocation") = $LG(^BI.WebSCModuleD(moduleOnLogin),3)
		}
	}else{s %session.Data("currLocation") = "userPref.csp"}
	//w "location.href='dashboard.csp';"
}

ClassMethod refSessTime()
{
	;w "debug('No Timeout call.');"
	s %session.Data("sessTime")=1
}

ClassMethod onLoadPivot(sRtn)
{
	s %session.Data("pivi") = sRtn
	q 1
}

ClassMethod testingSession()
{
	d testingSession^%bi.SWr.WebMain
}

ClassMethod clearOffLogGlo()
{
	d clearOffLogGlo^%bi.SWr.WebMain3
}

ClassMethod setRealIP(P0)
{
	s %session.Data("RealIP") = P0
}

ClassMethod loadRoles(usr, pwd)
{
	d loadRoles^%bi.SWr.WebMain(usr,pwd)
}

ClassMethod loadClsNm(dm)
{
	q:dm="" ""
	q $$GetClass^%bi.SMr.DataMart1(dm)
}

}
