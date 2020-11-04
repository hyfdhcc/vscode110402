/// Login page with password change.
Class %CSP.PasswordChange Extends %CSP.Login [ System = 4 ]
{

/// Login page localization domain
Parameter DOMAIN = "%UtilityPasswordChange";

/// Output the default login page as HTML
ClassMethod OnPage() As %Status
{
	// text strings
	Set ConfigName = $P($zu(86),"*",2)
	// get key, lookup in localization global
	Set lang = $get(^%SYS("LANGUAGE","CURRENT"),"en")
	Set title = $$FormatText^%occMessages($$$GetSysMessage(lang,..#DOMAIN,"logintitle","Password Change %1"),ConfigName)
	Set prompt = $$$GetSysMessage(lang,..#DOMAIN,"loginenter","Please enter your user name and existing password and new password to change passwords and login")
	Set userName = $$$GetSysMessage(lang,..#DOMAIN,"loginusername","User Name")
	Set password = $$$GetSysMessage(lang,..#DOMAIN,"loginpassword","Password")
	Set passwordrepeat = $$$GetSysMessage(lang,..#DOMAIN,"loginpasswordrepeat","Retype Password")
	Set oldpassword  = $$$GetSysMessage(lang,..#DOMAIN,"loginoldpassword","Old Password")
	Set login = $$$GetSysMessage(lang,..#DOMAIN,"login","Login")
	Set logout = $$$GetSysMessage(lang,..#DOMAIN,"loginlogout","You are logged out")
	Set usernameneeded = $$$GetSysMessage(lang,..#DOMAIN,"usernameneeded","Provide a username")
	Set passwordmatch = $$$GetSysMessage(lang,..#DOMAIN,"passwordmatch","New password fields do not match")
	Set differentpassword = $$$GetSysMessage(lang,..#DOMAIN,"differentpassword","Must pick a new password different from old one")
	&html<<html>>

	Do ..DrawHEAD(title)
	
	// js functions
	&html<<script language="javascript">
// called when page is loaded
function pageLoad()
{
	// see if we can give focus to the UserName field:
	if (self.document.Login && self.document.Login.CacheUserName) {
		self.document.Login.CacheUserName.focus();
		self.document.Login.CacheUserName.select();
	}

	return true;
}

function validateSubmit()
{
	if (self.document.Login.CacheUserName.value == '') {
		alert('#(usernameneeded)#');
		self.document.Login.CacheUserName.select();
		return false;
	}
	if (self.document.Login.CachePassword.value != self.document.Login.CacheRepeatPassword.value) {
		alert('#(passwordmatch)#');
		self.document.Login.CachePassword.select();
		return false;
	}
	if (self.document.Login.CachePassword.value == self.document.Login.CacheOldPassword.value) {
		alert('#(differentpassword)#');
		self.document.Login.CachePassword.select();
		return false;
	}
	return true;
}

	</script>>
 
 &html<</head>
 	<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="pageLoad();">
 	>
 
	Do ..DrawTitle(title)

	// Show standard login form
 	&html<<table border="0" align="center">
 	<tr>
	<td colspan="10" align="center">
 	<table border="0" class="LayoutMain" width="100%" cellpadding="0" cellspacing="0">
 	<tr><td class="LayoutContentCol" width="80%" align="left"><br>
	<div class="Text1" style="padding-bottom: 5px; color: darkblue; font-size: 0.9em;">#(prompt)#:</div>
	</td></tr>
	<tr><td align="center">
	<form name="Login" method="post" action="#(..EscapeURL(%request.Data("Error:URL",1)))#" autocomplete="off" onsubmit="return validateSubmit();">>

	Write ..InsertHiddenFields(%request.Data("Error:URL",1))

	&html<
	<table class="AutoForm">
	<tr><td> 
	<tr class="AutoForm" valign="center">
	<td class="AutoFormCaption" nowrap>#(userName)#:</td>
	<td class="AutoFormControl" nowrap>
 		<input type="text" size="40" name="CacheUserName" autocomplete="off" value="#($zconvert($get(%request.Data("CacheUserName",1)),"O","HTML"))#">&nbsp;
 	</td>
 	</tr>
	<tr class="AutoForm" valign="center">
	<td class="AutoFormCaption" nowrap>#(oldpassword)#:</td>
	<td class="AutoFormControl" nowrap>
 		<input type="password" size="40" name="CacheOldPassword" autocomplete="off">&nbsp;
 	</td>
 	</tr>
	<tr>
	<td class="AutoFormCaption" nowrap>#(password)#:</td>
	<td class="AutoFormControl" nowrap>
		<input type="password" size="40" name="CachePassword" autocomplete="off">&nbsp;
	</td>
	</tr>
	<tr class="AutoForm" valign="center">
	<td class="AutoFormCaption" nowrap>#(passwordrepeat)#:</td>
	<td class="AutoFormControl" nowrap>
 		<input type="password" size="40" name="CacheRepeatPassword" autocomplete="off">&nbsp;
 	</td>
 	</tr>
	<tr>
 	<td>&nbsp;</td>
	 <td><input type="submit" name="CacheLogin" value="#(login)#"></td>
	</tr>
	</table>
	</form>>

	// test for error
	Set tMsg = $Get(%request.Data("Error:ErrorCode",1))
 	If (tMsg'="") {
	 	If $$$GETERRORCODE(tMsg)=$$$ERRORCODE($$$RequireAuthentication)||($$$GETERRORCODE(tMsg)=$$$ERRORCODE($$$PasswordChangeRequired)) {
	 		Do DecomposeStatus^%apiOBJ(tMsg,.errorlist)
			If $get(errorlist(1,"embeddederror",1))'="" {
				Set tMsg=errorlist(1,"embeddederror",1)
			} Else {
				Set tMsg=""
			}
	 	}
		If tMsg'="" Do ShowError^%apiCSP(tMsg)
 	}

	&html<</body></html>>

	Quit $$$OK
}

}
