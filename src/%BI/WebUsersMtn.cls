Class %BI.WebUsersMtn [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DupUser(id)
{
	d DupUser^%bi.SWrc.UserMtn(id)
}

ClassMethod AddFolderAccess(val, folderId)
{
	// if folder already added, quit 
	d AddFolderAccess^%bi.SWrc.UserMtn(val,folderId)
}

ClassMethod OpenUser(usrID)
{
	// Open a particular user detail.
	d OpenUser^%bi.SWrc.UserMtn(usrID)
}

ClassMethod DisplayUserList()
{
	
 s %session.Data("lastfoldid")=""
 s %session.Data("lasti")="" 	
 // List out the users in a list.
 d DisplayUserList^%bi.SWrc.UserMtn
}

ClassMethod ListRoles()
{
 // List out the users in a list.
 d ListRoles^%bi.SWrc.Roles
}

ClassMethod ListDashboard()
{
 // List out the users in a list.
 d ListDashboard^%bi.SWrc.DashBoards
}

ClassMethod SaveUser(usrId, FullName, uCode, pwd, language, level, superUsr, defaultVal, chkboxlimit, MinChar, Alphanum, NuReuse, PassExp, MyMis, EnSc, CHKBoxLock, DGSIG, chkboxUPlimit, defaultLog, mindd, noTimeout)
{
	// Save a newly created user to the database.
	d SaveUser^%bi.SWrc.UserMtn(usrId, FullName, uCode, pwd,language, level, superUsr, defaultVal,chkboxlimit,MinChar,Alphanum,NuReuse,PassExp,MyMis,EnSc,CHKBoxLock,DGSIG,chkboxUPlimit,defaultLog,mindd,noTimeout)
}

ClassMethod SaveMail(usrID, emailAdd, emailsig, chkboxlimit)
{
	d SaveMail^%bi.SWrc.UserMtn(usrID,emailAdd,emailsig,chkboxlimit)
}

ClassMethod ChkFolderAccess(valId, num)
{
	// when user click on the check box, it will change the folder
	// access value
	d ChkFolderAccess^%bi.SWrc.UserMtn(valId, num)
}

ClassMethod CreateFolder(folderId As %String)
{
	d CreateFolder^%bi.SWrc.UserMtn(folderId)
}

ClassMethod ClearFields()
{
	d ClearFields^%bi.SWrc.UserMtn()
}

ClassMethod DelFolder(folderId As %String, usrId)
{
	d DelFolder^%bi.SWrc.UserMtn(folderId,usrId)
}

ClassMethod DeleteUsrFolder(val As %String)
{
	d DeleteFolderAccess^%bi.SWrc.UserMtn(val)
}

ClassMethod HiliteRow(val As %String, onTarget As %Integer)
{
	d HiliteRow^%bi.SWrc.UserMtn(val, onTarget)
}

ClassMethod RenFolderName(folderId As %String, folderName As %String)
{
	d RenFolderName^%bi.SWrc.UserMtn(folderId,folderName)
}

ClassMethod AddDashToList(dashId)
{
	// Add the dashboard to the list of dashboard belonging to the user.
	d AddDashToList^%bi.SWrc.UserMtn(dashId)
}

ClassMethod KillDashFromList(dashId, numOfDash)
{
	// Remove the dashboard from the list of dashboard belonging the user.
	d AddDashToDelList^%bi.SWrc.UserMtn(dashId, numOfDash)
}

ClassMethod AddRoleToList(roleId)
{
	// Add a role or set permission for a user.
	d AddRoleToList^%bi.SWrc.UserMtn(roleId)
}

ClassMethod KillRoleFromList(roleId, numOfRoles)
{
	// Remove a role and set 
	d AddRoleToDelList^%bi.SWrc.UserMtn(roleId, numOfRoles)
}

ClassMethod ChangeDefaultFolder(valueTxt As %String, valueSet)
{
	d ChangeDefaultFolder^%bi.SWrc.UserMtn(valueTxt,valueSet)
}

ClassMethod LoadFolders()
{
	// Remove a role and set 
	d LoadFolders^%bi.SWrc.UserMtn()
}

ClassMethod DeleteUser(usrID)
{
	if (usrID=1)
	{
		w "alert('"_$$$Text("Deletion of this SuperUser is prohibited","%BI")_"');"
	}
	else
	{
		d DeleteUser^%bi.SWrc.UserMtn(usrID)
		
	}
}

ClassMethod RemLast()
{
	w "LtrName='"_%session.Get("LastKName")_"';"
	w "LuId='"_%session.Get("LastKId")_"';"
}

ClassMethod KeepLast(trName, uId)
{

	s %session.Data("LastKName")=trName
	s %session.Data("LastKId")=uId
}

ClassMethod KeepLastFold(i, foldid)
{
	s %session.Data("lasti")=i
	s %session.Data("lastfoldid")=foldid
}

ClassMethod lastfold()
{
	w "dalastFold='"_%session.Get("lastfoldid")_"';"
	w "li='"_%session.Get("lasti")_"';"
}

ClassMethod GetIcoName(id)
{
	d GetIcoName^%bi.SWrc.UserMtn(id)
}

ClassMethod loadLanguage()
{
	s userid = %session.Get("CurrentUsr")	
	i userid'="" {
		s usrobj = ##class(%BI.Users).%OpenId($P(userid,$C(6),1))
		i usrobj=$$$NULLOREF {
 			set ErrorMessage="error open"
 			quit 0
		}
		s usrLanguage = usrobj.SysLanguage
		s languages = "English|Chinese|Malay|Arabia|Thai"
		
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
				
		d usrobj.%Close()
	}
}

}
