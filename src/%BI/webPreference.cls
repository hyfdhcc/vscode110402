Class %BI.webPreference Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
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

ClassMethod loadLanguage(cnt)
{
	s userid = %session.Get("CurrentUsr")	
	i userid'="" {
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage=$$$Text("error open")
 			quit 0
		}
		s usrLanguage = usrobj.SysLanguage
		s languages = $$$Text("English|Chinese|Malay|Arabia|Thai")
		
		s coldlim = $C(5)
		s rowdlim = $C(4)
		s languages = $$getAllLang^%bi.SWrt.InitialTranslation()
		s cnt = 1
		s temprow = $P(languages,rowdlim,cnt)
		//s temprow = $P(languages,rowdlim,6)
		w "<select  class=""CboBox""  name=""cboLanName"" size=""1"" >",!
		while ($G(temprow)'="") {
			//w "alert('temprow = "_temprow_"');"
			s langid = $P(temprow,coldlim,1)
			s langname = $P(temprow,coldlim,2)
			//w "alert('temprow = "_langname_"');"
			//s langid = "1"
			//s langname = "English"
			
			s Defualtlangid = $G(%session.Data("wLang"))
			i $G(Defualtlangid)="" s Defualtlangid=1
			i usrLanguage = langid {	
				w "  <option value="""_langid_""" selected>"_$$Text^%bi.SWr.WebMain(langname,"%BI")_"</option>",!
			} else {
				w "  <option value="""_langid_""">"_$$Text^%bi.SWr.WebMain(langname,"%BI")_"</option>",!
			}
			s cnt = cnt + 1
			s temprow = $P(languages,rowdlim,cnt)
		}
		
		w "  </select>",!
		w "<script language=javascript>"
		s EightCharPwd = usrobj.EightCharPwd
		s AlphaNumPwd = usrobj.AlphaNumPwd
		s NoReUse = usrobj.NoReUse
		s PerfAlert = usrobj.PerfAlert
		s PerfAlertPopup = usrobj.PerfAlertPopup
		f pw=1:1:4 {
			s lastPwd(pw) = usrobj.ExPasswords.GetAt(pw)
		}
		w "EightPwd='"_EightCharPwd_"';alphaNum='"_AlphaNumPwd_"';NoReUse='"_NoReUse_"';"
		w "lastPwd[0]='"_lastPwd(1)_"';"
		w "lastPwd[1]='"_lastPwd(2)_"';"
		w "lastPwd[2]='"_lastPwd(3)_"';"
		w "lastPwd[3]='"_lastPwd(4)_"';"
		w "perfID = '"_PerfAlert_"';"
		s perfNm = ##class(%BI.PerfAlert).%OpenId(PerfAlert)
		i perfNm'="" w "perfMetGrp.value = '["_PerfAlert_"] "_perfNm.Name_"';"
		i PerfAlertPopup'="" w "perfAltChk.checked = "_PerfAlertPopup_";perfPop="_PerfAlertPopup_";"
		e  w "perfAltChk.checked = false;"
		w:usrobj.MyFolder'="" "document.getElementById('defaultFolder').value='["_usrobj.MyFolder_"] "_$LG(^BI.FolderD(usrobj.MyFolder),2)_"';"
		w "</script>"
		
		d usrobj.%Close()
	}
}

/*
	
	w "<select  class=""CboBox""  name=""cboLanName"" size=""1"" >",!
	while ($G(temprow)'="") {
		s langid = $P(temprow,coldlim,1)
		s langname = $P(temprow,coldlim,2)
	
		w "  <option value="""_langid_""">"_langname_"</option>",!}	
		s cnt = cnt + 1
		s temprow = $P(languages,rowdlim,cnt)
}
w "  </select>",!
	
	
	w "<select  class=""CboBox""  name=""cboLanName"" size=""1"" >",!
	for i=1:1:$L(languages,"|") {
		s langValue = $P(languages,"|",i)
		i usrLanguage=langValue {
			w "  <option value="""_langValue_""" selected>"_langValue_"</option>",!}
else{
			w "  <option value="""_langValue_""">"_langValue_"</option>",!}}
w "  </select>",!
}
*/
ClassMethod loadWebStartup()
{
	s userid = %session.Get("CurrentUsr")	
	s LinkC=%session.Get("LinksC")
	s Role=%session.Get("CurrRole")
	i userid'="" {
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage=$$$Text("error open")
 			quit 0
		}
	s usrApp = usrobj.shortcutLinks
	//To Not show what is not granted By Alan
	
	// To Not Show Ends here--by Alan
	s app = $$$Text("Analyzer:5|Dashboard:6|Reporter:10|Presenter:7|Schedular:3|Administrator:1|ETL:14")
	
	for i=1:1:$L(app,"|") {
		s appValue = $P($P(app,"|",i),":",1)
		s appNum = $P($P(app,"|",i),":",2)
		s Comp=1
		for c=1:1:$L(LinkC,"|") {
			s linkNum= $p($p(LinkC,"|",c),",",1)
			s linkRef= $p($p(LinkC,"|",c),",",2)
			
			if (appNum=linkNum) && ($p(^BI.RolesD(Role,"M",linkRef),$C(3),2)=0)
			{
				s Comp=0
				
			}
			
		}
			if (Comp=1)
			{
				w "<tr  class=""fontTypeVrdna"">",! 
        		w "<td width=""45%"">&nbsp;"_appValue_"</td>",!
        		w "<td width=""24%"">",!
       			s shortcuts = 0
       			s startup = 0
        	
        		for j=1:1:$L(usrApp,"|") {	
        			s usrAppNum =  $P($P(usrApp,"|",j),":",2)
        			s usrAppNum2 =  $P($P(usrApp,"|",j),":",3)
        			/*usrAppNum2 can be 0,1 or 2.  if usrAppNum=0 is a shortcutlink not a startup page
        			if usrAppNum2= 1 is iondicates startup page also shortcutlink
        			if usrAppNum2=2, it is a startup page but does not exist in shortcuts link*/
        				i ((appNum=usrAppNum) && (usrAppNum2'="2"))  { s shortcuts = 1 }
        		}
        		i shortcuts=0{
        			w "<input type=""checkbox"" name=""chkShortcut"" value="""_appNum_""">",!}
        		else {
	        		w "<input type=""checkbox"" name=""chkShortcut"" value="""_appNum_""" checked>",!}
        		w "</td>",!
        		w "<td width=""31%"">" ,!
        		for j=1:1:$L(usrApp,"|") {	
        			s usrAppNum =  $P($P(usrApp,"|",j),":",2)
        				i appNum=usrAppNum  { 
	        				s usrAppNum2 =  $P($P(usrApp,"|",j),":",3)
							i (usrAppNum2'="0"){s startup = appNum}
        				}    	
        			}
        		i startup=appNum{
        			w "<input type=""radio"" name=""rdoStart"" value="""_appNum_""" checked>",!
        			}
        		else {w "<input type=""radio"" name=""rdoStart"" value="""_appNum_""" >",!}
        		w "</td>",!
        		w "</tr>",!
        
				
			}
		}
	
		d usrobj.%Close()
	}
}

ClassMethod loadDashBStartup()
{
	s tempValue = ""
	s userid = %session.Get("CurrentUsr")	
	i userid'="" {
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage=$$$Text("error open")
 			quit 0
		}
	
		s display = 1
		Do {
			s dashobj = usrobj.DesktopItems.GetNext(.dbKey)
			s onTargetVal = "1"
			
			i dashobj '="" { 
				s valTxt = dashobj.DashBoardName
				s dshVal = dashobj.DashBoard
				s tempValue=""_valTxt
				s display = 0
			}
			
		} while (dbKey'="")
		
		i display=0 {
	    	w "<script Language=""JavaScript"">"
	    	w "valueTxt="""_tempValue_""";"
	    	w "onTarget=""1"";"
			w "popTree();"
			w "tempDBStartup='"_dshVal_"';"
	    	w "</script>"
		}
		
		d usrobj.%Close()
	}
}

ClassMethod loadDashBShortcuts()
{
 
	s tempValue = ""
	s userid = %session.Get("CurrentUsr")	
	i userid'="" {
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage=$$$Text("error open")
 			quit 0
		}
		s dbKey=""
		s i=0
		Do {
			s dashobj = usrobj.ShortCutDB.GetNext(.dbKey)
			i dashobj '="" { 
				s valTxt = dashobj.DashBoardName
				s val = dashobj.DashBoard
				i val'="" s val=":"_val
				i tempValue=""
					{s tempValue=""_valTxt_val}
				else
					{s tempValue = ""_tempValue_"/"_valTxt_val}
				
	    		s i=i+1
			}
		} while (dbKey'="")
		
		w "<script language=javascript>"
		w "valueTxt="""";"
	    w "onTarget=""2"";"
	    w "tempMenu="""_tempValue_""";"
	    i i'=0 {
	    w "popTree();"
	    }
	    w "</script>"
		
		d usrobj.%Close()
	}
}

ClassMethod saveUserPreference(languageSel, webStartup, webShortcuts, dashBStartup, dashBShortcuts, NoTOut, MailUsrN, MailPass, chkBoxFilter, dDate, scnDime, flScn, perfInfo, defFldr)
{
	s userid = %session.Get("CurrentUsr")	
	i userid'="" {
		d saveSC^%bi.SWr.WebSCMod
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage=$$$Text("error open")
 			quit 0
		}
		
		s numLinks = $LENGTH(webShortcuts,"/")
		i numLinks = 0 {s webTempStr=""}
		else {
			f i=1:1:numLinks {
				s tempVal=$PIECE(webShortcuts,"/",i)
				S numVal=$CASE(tempVal,
		  		"5":"Analyzer:5:0",
		  		"7":"Presenter:7:0",
		  		"6":"DashBoards:6:0",
		  		"10":"Reporter:10:0",
		  		"3":"Scheduler:3:0",
		  		"1":"Administrator:1:0",
		  		"9":"ETL:9:0",
		 		:"")
				if i=1 {s webTempStr= numVal }
				else { s webTempStr=webTempStr _"|"_ numVal }
				
			}
		}
	//validation
	s posVal = $FIND(webTempStr,webStartup)
	s webStartupStr = ..thePageId(webStartup)
	i webStartupStr'="" {
	i (posVal = 0) {
				i webTempStr'=""{
				s webTempStr = webTempStr _"|"_webStartupStr }
				else {s webTempStr = webStartupStr }
				s posVal = $FIND(webTempStr,webStartup)
				s $EXTRACT(webTempStr,posVal+1) = "2"
			 }
	else {s $EXTRACT(webTempStr,posVal+1) = "1"}
	}
	
	do {
		// This part will start to delete all.
		s obj = usrobj.DesktopItems.GetNext(.dbKey)
		if obj'="" { d usrobj.DesktopItems.RemoveAt(dbKey)}
	} while (dbKey'="")
	i $G(dashBStartup)'="" {
		s newDashObj=0
		//s dashbID = ..thePageId(dashBStartup)
		s dashbID = 1
		//s dashobj = usrobj.DesktopItems.GetAt(dashbID)		
		s dashobj = ##class(%BI.DashBoardItem).%New()
		s dashobj.DashBoard = dashBStartup
		d usrobj.DesktopItems.SetAt(dashobj,dashbID)
	}
	
	do {
		// This part will start to delete all.
		s obj = usrobj.ShortCutDB.GetNext(.dbKey)
		if obj'="" { d usrobj.ShortCutDB.RemoveAt(dbKey)}
	} while (dbKey'="")
	i $G(dashBShortcuts) '= "" {		
		s numLinks = $LENGTH(dashBShortcuts,"/")
		i numLinks = 0 {
				//w "alert(""hyde"");"
			s dashBTempStr=""
		}
		else {
			f i=1:1:numLinks {
				s tempVal=$PIECE(dashBShortcuts,"/",i)	
					s dashobj = ##class(%BI.DashBoardItem).%New()
					s tVal = $P(tempVal,":",2)
					i tVal'="" s dashobj.DashBoard =tVal
					//s key =  dashobj.%Id()
					//s dashbID = ..thePageId(tempVal)
					s dashbID = i
					d usrobj.ShortCutDB.SetAt(dashobj, dashbID)
			}
		}
	}
	
	//w "alert('"_languageSel_"');"
	s langChanged=$S(languageSel'=usrobj.SysLanguage:1,1:0)
	s usrobj.SysLanguage=languageSel
	s usrobj.shortcutLinks=webTempStr
	;s usrobj.NoTimeOut=NoTOut
	s usrobj.DisplayDate = dDate
	s scnW = $P(scnDime,$C(4),1)
	s scnH = $P(scnDime,$C(4),2)
	i scnW'="" i scnW<800 s scnW = 800
	i scnH'="" i scnH<600 s scnH = 600
	s usrobj.FullScreen = flScn
	s usrobj.screenWidth = scnW
	s usrobj.screenHeight = scnH
	s usrobj.PerfAlert = $P(perfInfo,$C(2),1)
	s usrobj.PerfAlertPopup = $P(perfInfo,$C(2),2)
	s usrobj.MyFolder = defFldr
	
	//save users mail detail (user name and password)
	if (MailUsrN'="")
	{
		if (MailPass'="")
		{
			s usrobj.MailUsrName=MailUsrN
			//s usrobj.MailPassword=##class(%CSP.Page).Encrypt(MailPass)
			//s usrobj.MailPassword=usrobj.Encrypt(MailPass)
			s usrobj.MailPassword=MailPass
		}
	}
	s usrobj.DisplayFilterCount=chkBoxFilter
	d usrobj.%Save()
	d usrobj.%Close()
	s wL=$G(%session.Data("wLang"))
	s Tx=$g(^BI.Translation(4,wL,24))
	w "alert('"_$$$Text("Preference Saved")_"');"  //Preference Saved
	i langChanged {d setLang^%bi.SWr.WebMain(languageSel) w "window.parent.location.reload();"}
	}
}

ClassMethod setDropFunction(valueSett As %String) As %Boolean
{
	i $e(valueSett,1)=$C(2) {q 0} 
	else {q 1}
}

ClassMethod thePageId(pageNum As %String) As %String
{
	S numVal=$CASE(pageNum,
  		"5":"Analyzer:5:0",
  		"7":"Presenter:7:0",
  		"6":"DashBoards:6:0",
  		"10":"Reporter:10:0",
  		"3":"Scheduler:3:0",
  		"1":"Administrator:1:0",
  		"9":"ETL:9:0",
 		:"")
 	q numVal
}

ClassMethod forceNavBar(P0)
{
	s %session.Data("navBar")=P0
}

ClassMethod ChkPass(oldp)
{
	s userid = %session.Get("CurrentUsr")	
	i userid'="" 
	{
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		
		s daoldp=usrobj.Password
		s usrOldp=usrobj.Encrypt(oldp)
		
		if (daoldp'=usrOldp) 
		{
			w "Stat=0;"	
		}
		else
		{
			w "Stat=1;"		
		}
		
		d usrobj.%Close()
	}
}

ClassMethod SavNewPass(newp)
{
	s userid = %session.Get("CurrentUsr")	
	i userid'="" 
	{
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		s usrobj.Password=usrobj.Encrypt(newp)
		s usrobj.ExpiryDate = ($P($H,",",1)*1)+30
		
		// Rearrange and re-set the 4 password
		f i=4:-1:1 {
			s xPwd = usrobj.ExPasswords.GetAt(i)
			i xPwd="" {
				s tmpNewp = usrobj.ExPasswords.GetAt(i-1)
				i tmpNewp'="" {
					d usrobj.ExPasswords.SetAt(newp,i)
				}
			} else {
					s tmpNewp = usrobj.ExPasswords.GetAt(i)
					d usrobj.ExPasswords.SetAt(newp,i)
					s newp=tmpNewp
			}	
		}
		d usrobj.%Save()
		d usrobj.%Close()
	}
}

ClassMethod noTimeOut()
{
	s userid = $P(%session.Get("currUserID"),$C(6),1)
	s usrObj=##class(%BI.Users).%OpenId(userid)
	i usrObj'="" {
		i $LG(^BI.UsersD(userid),9)'="" {
			s noTimeOut = usrObj.NoTimeOut
			i noTimeOut>1 {
				;w "<script language=javascript>"
				;s appTimeOut = %session.AppTimeout 
				;s appTO = (appTimeOut*0.7)*100
				s %session.AppTimeout = noTimeOut
				;w "refSessTime('"_appTO_"');"
				;w "</script>"
			} elseif noTimeOut=1 {
				w "<script language=javascript>"
				s appTimeOut = %session.AppTimeout 
				s appTO = (appTimeOut*0.8)*100
				;w "alert('"_appTimeOut_"');"
				w "refSessTime('"_appTO_"');"
				w "</script>"
			} else {}
		}
	}
}

ClassMethod chkNoTimeOut()
{
	n (%session)
	s userid = $P(%session.Get("currUserID"),$C(6),1)
	s usrObj=##class(%BI.Users).%OpenId(userid)
	
	s nTOut="",checkedMe="",scnDime="",fullScn=""
	i usrObj'="" {
		i $LG(^BI.UsersD(userid),9)'="" {
			s noTimeOut = usrObj.NoTimeOut
			s fullScn = usrObj.FullScreen
			s scnDime = usrObj.screenWidth_$C(4)_usrObj.screenHeight
			i noTimeOut>1 s nTOut=noTimeOut
			e  s nTOut=""
			i noTimeOut=1 s checkedMe="checked"
		}
	}
	q nTOut_$C(2)_checkedMe_$C(2)_scnDime_$C(2)_fullScn
}

ClassMethod loadTheFilterCount()
{
	s userid = %session.Get("CurrentUsr")
	i userid'="" 
	{
	s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
	s ckb=$CASE(usrobj.DisplayFilterCount="1",1:"true",0:"false")
	
	w "cBoxAnlFilter.checked="_ckb_";"
			
	d usrobj.%Close()
	}	
	q
}

/// For deLang.csp to load all languages, similiar to loadLanguage method
ClassMethod loadLanguage1(cnt)
{
	s userid = %session.Get("CurrentUsr")	
	i userid'="" {
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage=$$$Text("error open")
 			quit 0
		}
		s usrLanguage = usrobj.SysLanguage
		s languages = $$$Text("English|Chinese|Malay|Arabia|Thai")
		
		s coldlim = $C(5)
		s rowdlim = $C(4)
		s languages = $$getAllLang^%bi.SWrt.InitialTranslation()
		s cnt = 1
		s temprow = $P(languages,rowdlim,cnt)
		//s temprow = $P(languages,rowdlim,6)
		w "<select  class=""CboBox""  name=""cboLanName"" size=""1"" >",!
		while ($G(temprow)'="") {
		//w "alert('temprow = "_temprow_"');"
		s langid = $P(temprow,coldlim,1)
		s langname = $P(temprow,coldlim,2)
		//w "alert('temprow = "_langname_"');"
		//s langid = "1"
		//s langname = "English"
		
		s Defualtlangid = $G(%session.Data("wLang"))
		i $G(Defualtlangid)="" s Defualtlangid=1
		i usrLanguage = langid {	
			w "  <option value="""_langid_""" selected>"_langname_"</option>",!
		} else {
			w "  <option value="""_langid_""">"_langname_"</option>",!
		}
		s cnt = cnt + 1
		s temprow = $P(languages,rowdlim,cnt)
		}
		
		w "  </select>",!
	}
}

}
