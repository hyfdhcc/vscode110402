Include (%sqlui, %sySecurity, %sySystem)

/// Provide a default login and security-token pages for CSP applications.
/// User can override the look of this page by creating a subclass and 
/// overriding the DrawTitle method and the LOGINTITLE and LOGO parameters.
Class %CSP.Login Extends %CSP.Page [ System = 3 ]
{

/// Name of stylesheet used for login page.<br/>
/// Not used by default page: styles come from the DrawSTYLE method.
Parameter STYLESHEET;

/// Title displayed for login page.<br>
/// Users can override this value to customize the login page.
Parameter LOGINTITLE = "Login Page";

/// Corporate logo displayed in standard title.<br/>
/// No longer used.
Parameter LOGO;

/// Login page localization domain
Parameter DOMAIN = "%UtilityLogin";

/// Output the default login page as HTML
ClassMethod OnPage() As %Status
{
/// CSP Applications now allow for two-factor authentication. This requires two-pages 
/// in the login page: the password page and the security token page.
	Set wantLoginPage = $G(%request.Data("CacheLoginPage"),1)
	Set %Status = $$$OK
	If (wantLoginPage) {
		Set %Status = ..OnLoginPage()
	}
	Else {
		Set %Status = ..OnSecurityTokenPage()
	}
	Quit %Status
}

ClassMethod OnLoginPage() As %Status
{
	// text strings
	Set ConfigName = $P($zu(86),"*",2)
	// get key, lookup in localization global
	Set tLang = $$$SessionLanguage
	Set tTitle = $$FormatText^%occMessages($$$GetSysMessage(tLang,..#DOMAIN,"logintitle","Login %1"),ConfigName)
	Set tPrompt = $$$GetSysMessage(tLang,..#DOMAIN,"loginenter","Please login")
	Set tUserName = $$$GetSysMessage(tLang,..#DOMAIN,"loginusername","User Name")
	Set tPassword = $$$GetSysMessage(tLang,..#DOMAIN,"loginpassword","Password")
	Set tLogin = $$$GetSysMessage(tLang,..#DOMAIN,"login","LOGIN")
	Set OtherAutheEnabled = $$OtherAuthEnabled^%SYS.cspServer(%request)
	&html<<html>>
	Do ..DrawHEAD(tTitle)

	&html<
		<body style="background-color:rgb(232,231,226);" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="pageLoad();">>
 
	Do ..DrawTitle(tTitle)

 	&html<<tr><td><table border="0" cellpadding="10" align="center" class="LayoutTable">
 	<tr>
	<td align="center">
 	<table border="0" class="LayoutMain" width="100%" cellpadding="5" cellspacing="0">>
 	&html<<tr><td style="height:90px;"><br/></td></tr>>
 	
 	&html<<tr><td><center>>

  If OtherAutheEnabled = 1 {
	// Show standard login form

	&html<
	
	<form name="Login" method="post" action="#(..EscapeURL(($ZConvert($G(%request.Data("Error:URL",1)),"O","HTML"))))#" autocomplete="off">>

	Write ..InsertHiddenFields($ZConvert($G(%request.Data("Error:URL",1)),"O","HTML"))

	&html<
	<table class="login" style="background-color:rgb(232,231,226);" border="0" cellspacing="6" cellpadding="2" >
	<tr valign="bottom">
	<td nowrap class="loginCaption">#(tUserName)#</td>
	<td style="padding-top:18px;padding-right:20px;"><input type="text" size="30" name="CacheUserName" class="loginInput" autocomplete="off" value="#($ZCVT($get(%request.Data("CacheUserName",1)),"O","HTML"))#"/>
 	</td>
 	</tr>
	<tr valign="bottom">
	<td nowrap class="loginCaption">#(tPassword)#</td>
	<td><input type="password" size="30" name="CachePassword" autocomplete="off" class="loginInput"/>
	</td>
	</tr>
	<tr><td>&nbsp;</td>
	 <td style="padding-bottom:10px;"><input type="submit" name="CacheLogin" class="button" value="#(tLogin)#"></td>
	</tr>
	</table>
	</form></center>>

  }  // End OtherAutheEnabled = 1 block
  Else {
	  // This is accessed when Cache is installed with minimum security and user clicked Logout.
	  Set msg1 = $$$GetSysMessage(tLang,..#DOMAIN,"loginclickhere","Please click here to log in.")
	  Set tLink = ..Link("/csp/sys/UtilHome.csp")
	&html<
	<a href="#(tLink)#" class="loginlink">#(msg1)#</a>
	</center>
	</td>
	</tr>
	</table>
	>
  }

 	// test for error
 	Set tMsg = $Get(%request.Data("Error:ErrorCode",1))
 	If ((tMsg'="")&&($$$GETERRORCODE(tMsg)'=$$$ERRORCODE($$$RequireAuthentication))) {
 		&html<<tr><td><center>>
 		Do ShowError^%apiCSP(tMsg)
 		&html<</center></td></tr>>
 	}

 	&html<</td></tr><tr><td style="height:180px;"><br/></td></tr></table></body></html>>

 	Quit $$$OK
}

/// Draw the HEAD section of the login page.<br>
/// Users can override this method to customize the login page.
ClassMethod DrawHEAD(pTitle = "")
{
	&html<<head>
	<title>#(pTitle)#</title>>

	// link in stylesheet specified by parameter
	If (..#STYLESHEET '= "") {
		&html<<link rel="stylesheet" type="text/css" href="#(..Link(..#STYLESHEET))#">>
	}
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
	</script>>
	If ##class(%ZEN.Utils).%BrowserSupportsHTML5(%request.UserAgent) {
		Do ..DrawCSS3STYLE()
	}
	Else {
		Do ..DrawSTYLE()
	}
	&html<</head>>
}

/// Draw the title section of the login page.<br>
/// <var>pTitle</var> is the title for the page.<br>
/// Users can override this method to customize the login page.
ClassMethod DrawTitle(pTitle As %String)
{
	Set tLang = $$$SessionLanguage
	Set tAction = $$$GetSysMessage(tLang,..#DOMAIN,"login","Login")
	Set msgs("title") = pTitle
	Set msgs("tAction") = tAction
	
	Do ..DrawTitleSection( .msgs )
}

/// Draw the title section of the security token page.<br>
/// <var>pTitle</var> is the title for the page.<br>
/// Users can override this method to customize the security token page.
ClassMethod DrawSTTitle(pTitle As %String)
{
	Set tLang = $$$SessionLanguage
	Set tAction = $$$GetSysMessage(tLang,..#DOMAIN,"loginsecurityttoken","Security Token")
	Set msgs("title") = pTitle
	Set msgs("tAction") = tAction
	
	Do ..DrawTitleSection( .msgs )
}

/// Draw the title section of the page.<br>
/// <var>pTitle</var> is the title for the page.<br>
/// Users can override this method to customize the page title section.
ClassMethod DrawTitleSection(ByRef msgs As %String)
{
	Set tLang = $$$SessionLanguage
	Set cmdServer = $$$GetSysMessage(tLang,..#DOMAIN,"loginserver","Server")
	Set cmdInstance = $$$GetSysMessage(tLang,..#DOMAIN,"logininstance","Instance")
	Set msgServer = $$$GetSysMessage(tLang,..#DOMAIN,"loginmsgserver","Name of the machine this system is running on")

	Set InstanceName = $zconvert($P($zu(86),"*",2),"O","HTML")
	Set ProductName = $$$TextHTML("Management Portal")
	Set home = %request.URL
	If home '= "" Set ProductName = ##class(%CSP.UI.Portal.Template).%GetProductName()
	Set tPower = $$$TextHTML("Powered by Zen")
	Set tBy = $$$TextHTML("by InterSystems")
	&html<<table class="portalTitle" id="group_1" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr valign="bottom">
	<td width="99%" align="left">
		<div class="portalTitleInfoBox">
		<table border="0">
		<tr>
		<td class="portalTitleInfoLabel">#(cmdInstance)#:</td><td class="portalTitleInfoVal">#(InstanceName)#&nbsp;</td>
		</tr>
		</table>
		</div>
	</td>
	<td width="10%" align="right" valign="top">
	<div class="portalLogoBox">
	<div class="portalLogo" title="#(tPower)#">#(ProductName)#</div>
	<div class="portalLogoSub">#(tBy)#</div>
	</div>
	</td>
	</tr>
	</table>>
}

/// This is called before the OnPreHTTP and will handle the HyperEvents logout issues
/// It will refresh the main page by default unless a javascript function called
/// 'cspRunServerMethodError' is defined in which case it will call this instead
ClassMethod OnErrorSetup(ByRef skipheader As %Boolean) As %Boolean [ ProcedureBlock = 1 ]
{
	If $get(%request.Data("CharSet",1))'="" Set %response.CharSet=$get(%request.Data("CharSet",1))
	#; HyperEvent error handling is performed by the CSP server and the error page currently in use.
	Quit 1
}

ClassMethod OnSecurityTokenPage() As %Status
{
	// text strings
	Set ConfigName = $P($zu(86),"*",2)
	// get key, lookup in localization global
	Set tLang = $$$SessionLanguage
	Set tTitle = $$FormatText^%occMessages($$$GetSysMessage(tLang,..#DOMAIN,"sectoktitle","Security Token %1"),ConfigName)
	Set Application = $E(%request.Application,1,$L(%request.Application)-1)
	s Status=$$GetSecurityApplicationInfo^%SYS.SECURITY(Application,.Properties)
	s AutheEnabled=+Properties("AutheEnabled")
	Set tSecurityToken = $$$GetSysMessage(tLang,..#DOMAIN,"sectok","Security Token")
	i $zb(AutheEnabled,$$$AutheTwoFactorSMS,1) Set tSecurityToken = $$$GetSysMessage(tLang,..#DOMAIN,"sectok","Security Token")
	i $zb(AutheEnabled,$$$AutheTwoFactorPW,1) Set tSecurityToken = $$$GetSysMessage(tLang,..#DOMAIN,"sectokver","Verification Code")
	Set tSubmit = $$$GetSysMessage(tLang,..#DOMAIN,"sectoksubmit","Submit")
	Set tCancel = $$$GetSysMessage(tLang,..#DOMAIN,"sectokcancel","Cancel")
#;%request.Data("CacheUserName",1) has the username of the user who is trying to log in
	&html<<meta http-equiv="X-UA-Compatible" content="IE=edge" />>
	&html<<html><head><title>#(tTitle)#</title>>

	Do ..DrawSTHEAD()

 	&html<</head>
 	   <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="pageSTLoad();">>

	Do ..DrawSTTitle(tTitle)
	// Show standard login form
 	&html<<tr><td><table border="0" cellpadding="10" align="center" class="LayoutTable">
 	<tr>
	<td colspan="10" align="left">
	<table border="0" class="LayoutMain" width="100%" cellpadding="0" cellspacing="0">
	>
	s Status=$$$OK
	i $zb(AutheEnabled,$$$AutheTwoFactorPW,1) {
		s Status=$$GenerateQRCode^%SYS.SECURITY(%request.Data("CacheUserName",1),,.QRCode,.Code,.Account,.Issuer,.DisplayQRCode)
	} else {
		s DisplayQRCode=0
	}
    i DisplayQRCode {
		s Text=$$$Text("The system administrator has enabled Two-factor authentication for your account.")_"<br><br>"
		s Text=Text_$$$Text("Your Two-factor authentication requires the use of an authenticator application.")_"<br>"
		s Text=Text_$$$Text("These applications require you to enter a Time-based One-time Password key.")_"<br><br>"
		i '$$$ISVMS,($$$ISOK(Status)) {
			s Text=Text_$$$Text("If your authenticator application supports scanning a QR code (barcode) to enter the key, ")_"<br>"
			s Text=Text_$$$Text("you can enter the key by scanning the following QR code:")_"<br>"
		}
		&html<<tr><td style="height:60px;"><br/></td></tr>>
		&html<#(Text)#<br>>
		s Text=""
		i '$$$ISVMS,($$$ISOK(Status)) {
			&html<<image id="qrcode" width="150" height="150" src="#(QRCode)#">>
    		s Text="<br><br>"_$$$Text("Once you have scanned the QR code, enter the 6-digit verification code generated by your authenticator application.")_"<br><br>" 
    		s Text=Text_$$$Text("If you cannot scan the QR code, then you must enter the following information into your authenticator manually,")_"<br>"
		} else {
    		s Text="<br><br>"_Text_$$$Text("You must enter the following information into your authenticator manually,")_"<br>"
		}
   		s Text=Text_$$$Text("then enter the 6-digit verification code generated by your authenticator application.")_"<br><br>"
    	s Text=Text_$$$Text("Issuer:")_" "_Issuer_"<br>"
    	s Text=Text_$$$Text("Account:")_" "_Account_"<br>"
    	s Text=Text_$$$Text("Base 32 Time-based OTP Key:")_" "_Code
    
		&html<#(Text)#>
	} else {

	 	&html<<tr><td style="height:60px;"><br/></td></tr>>
	
	}
	&html<<tr><td><center>
	<form name="SecurityToken" method="post" action="#(..EscapeURL($G(%request.Data("Error:URL",1))))#" autocomplete="off">>

    Write ..InsertHiddenFields($G(%request.Data("Error:URL",1)))
	
	&html<
	<table class="login" style="background-color:rgb(232,231,226);" cellpadding="5" >
	<tr><td align="center">&nbsp;</td></tr>
	<tr><td class="loginCaption" nowrap="1">#(tSecurityToken)#</div>
 	<input type="password" size="30" name="CacheSecurityToken" autocomplete="off" value="#($ZCVT($get(%request.Data("CacheSecurityToken",1)),"O","HTML"))#">
 	</td>
 	</td>
 	</tr>
 	<tr><td>&nbsp;</td></tr>
	<tr>
 	<td nowrap="1" style="padding-bottom:10px;" align="right">
 		<input type="submit" class="button" name="CacheSecuritySubmit" value="#(tSubmit)#">&nbsp;
	 	<input type="submit" class="button" name="CacheSecurityCancel" value="#(tCancel)#">&nbsp;
	 </td>
	</tr>
	</table>
	</form>>
	// test for error
	Set tMsg = $Get(%request.Data("Error:ErrorCode",1))
 	If ((tMsg'="")&&($$$GETERRORCODE(tMsg)'=$$$ERRORCODE($$$CSPPendingTwoFactorAuthentication))) {
	 	Do ShowError^%apiCSP(tMsg)
 	}

	&html<</td></tr></table></body></html>>

	Quit $$$OK
}

/// Draw the HEAD section of the security token page.<br>
/// Users can override this method to customize the security token page.
ClassMethod DrawSTHEAD()
{
	// link in stylesheet specified by parameter
	If (..#STYLESHEET '= "") {
		&html<<link rel="stylesheet" type="text/css" href="#(..Link(..#STYLESHEET))#">>
	}
	// js functions
	&html<<script language="javascript">
	// called when page is loaded
	function pageSTLoad()
	{
		// see if we can give focus to the Security Token field:
		if (self.document.SecurityToken && self.document.SecurityToken.CacheSecurityToken) {
			self.document.SecurityToken.CacheSecurityToken.focus();
			self.document.SecurityToken.CacheSecurityToken.select();
		}
		return true;
	}
	</script>>
	If ##class(%ZEN.Utils).%BrowserSupportsHTML5(%request.UserAgent) {
		Do ..DrawCSS3STYLE()
	}
	Else {
		Do ..DrawSTYLE()
	}
}

/// Draw the style definitions for the login page.<br>
/// Users can override this method to customize the login page.
ClassMethod DrawCSS3STYLE()
{
 	&html<
 	<style type="text/css">
body {
	background-color: rgb(232,231,226);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));	
	background: linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	font-family: arial;
	overflow: hidden;
}

input {
    font-family: arial;                
}

table.LayoutTable {
	background: white;
	width: 98%;
	border: 2px solid black;
}

.portalTitle {
	width: 100%;
	height: 60px;
	position: relative;		
}

.portalTitleInfoBox {
	left: 20px;
}

.portalTitleInfoLabel {
	padding-left: 40px;
	font-size: 9pt;	
	color: #606060;
	text-align: left;
}

.portalTitleInfoVal {
	font-size: 9pt;	
	color: black;
	text-align: left;
	font-weight: bold;
}

table.login	{ 
	font-family: Arial, Helvetica, sans-serif;
	border: rgb(138,138,138) solid 1px; 
	border-radius: 5px;	
	background-color: rgb(232,231,226);
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	background: linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));

}
table.login td.loginCaption {
	color: rgb(67,67,67);
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	text-align: left;
	padding-left:20px;
}

table.login td.loginInput {
	border: rgb(165,172,178) 1px solid;
}

/* Logout message */
h3 {
	color: rgb(67,67,67);
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
}

div.loginPrompt {
	color: #D0D0D0;
	font-size: 16pt;
	padding: 0px;
	padding-bottom: 5px;
	text-align: center;
	text-shadow: black 1px 1px 1px;
}

div.isc {
	color: #808080;
	font-size: 10pt;
	padding-top: 2px;
	text-shadow: #6374AB 1px 1px 1px;
}

.portalLogoBox {
	position: static;
	padding: 10px;
	padding-bottom: 4px;
	padding-right: 30px;
	text-align: center;
}

.portalLogo {
	color: rgb(53,107,141);
	position: relative;
	font-weight: bold;
	font-size: 12pt;
	top: 0px;
	right: 0px;
	border: 2px solid rgb(53,107,141);
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;
	border-radius: 4px;
	background: #E0E0F0;
}
.portalLogoSub {
	position: relative;
	color: #808080;
	font-size: 8pt;
	top: 3px;
	right: 0px;
}
.loginlink {
	color: rgb(52,108,141);
}
.button {
	background-color: rgb(52,108,141);
	color: white;
	font-family: Arial, Helvetica, sans-serif;
	font-size:10px;
	text-transform: uppercase;
	text-decoration: none;
	font-weight: bold;
	padding: 3px;
	padding-left: 8px;
	padding-right: 8px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 1px solid gray;
    border-bottom: 1px solid gray;
    cursor: pointer;
}
.button:hover {
	background-color: rgb(53,107,141);
	color: white;
	background-image: url(portal/button_hover.png);
	background-repeat: repeat-x;
}
</style>>
}

/// Draw the style definitions for the login page.<br>
/// Users can override this method to customize the login page.
ClassMethod DrawSTYLE()
{
 	&html<
 	<style type="text/css">
body {
	background: rgb(232,231,226);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType='0', startColorstr='#e8e7e2', endColorstr='#e0d9d9');
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));	
	background: linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	font-family: arial;
	overflow: hidden;
}

input {
    font-family: arial;                
}

table.LayoutTable {
	background: white;
	width: 98%;
	border: 2px solid black;
}

.portalTitle {
	width: 100%;
	height: 60px;
	position: relative;
		
}

.portalTitleInfoBox {
	left: 20px;
}

.portalTitleInfoLabel {
	padding-left: 40px;
	font-size: 9pt;	
	color: #606060;
	text-align: left;
}

.portalTitleInfoVal {
	font-size: 9pt;	
	color: black;
	text-align: left;
	font-weight: bold;
}

table.login	{ 
	font-family: Arial, Helvetica, sans-serif;
	border: rgb(138,138,138) solid 1px; 
	opacity: 1.0;
	border-radius: 5px;
	
	background: rgb(237,236,228);
	-moz-border-radius: 5px;
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType='0', startColorstr='#e8e7e2', endColorstr='#e0d9d9');
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0,rgb(232,231,226)), color-stop(0.5,rgb(242,241,236)), color-stop(1.0,rgb(232,231,226)));
	background: -moz-linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));
	background: linear-gradient(top, rgb(232,231,226), rgb(242,241,236),rgb(222,221,216));

}

table.login td.loginCaption {
	filter:alpha(opacity=100);
	opacity: 1.0;
	color: rgb(67,67,67);
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	text-align: left;
	padding-left:20px;
}

table.login td.loginInput {
	border: rgb(165,172,178) 1px solid;
}

/* Logout message */
h3 {
	color: rgb(67,67,67);
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-weight: bold;
}

div.loginPrompt {
	color: #D0D0D0;
	font-size: 16pt;
	padding: 0px;
	padding-bottom: 5px;
	text-align: center;
	text-shadow: black 1px 1px 1px;
}

div.isc {
	color: #808080;
	font-size: 10pt;
	padding-top: 2px;
	text-shadow: #6374AB 1px 1px 1px;
}

.portalLogoBox {
	position: static;
	padding: 10px;
	padding-bottom: 4px;
	padding-right: 30px;
	text-align: center;
}

.portalLogo {
	color: rgb(53,107,141);
	position: relative;
	font-weight: bold;
	font-size: 12pt;
	top: 0px;
	right: 0px;
	border: 2px solid rgb(53,107,141);
	padding: 2px;
	padding-left: 5px;
	padding-right: 5px;
	-moz-border-radius: 4px;
	border-radius: 4px;
	background: #E0E0F0;
}
.portalLogoSub {
	position: relative;
	color: #808080;
	font-size: 8pt;
	top: 3px;
	right: 0px;
}
.loginlink {
	color: rgb(52,108,141);
}
.button {
	background: rgb(52,108,141);
	color: white;
	font-family: Arial, Helvetica, sans-serif;
	font-size:10px;
	text-transform: uppercase;
	text-decoration: none;
	font-weight: bold;
	padding: 3px;
	padding-left: 8px;
	padding-right: 8px;
	-moz-border-radius: 5px;
	border-radius: 5px;
 	border-top: 1px solid lightgray;
    border-left: 1px solid lightgray;
    border-right: 1px solid gray;
    border-bottom: 1px solid gray;
    cursor: pointer;
}
.button:hover {
	background: rgb(53,107,141);
	color: white;
	background-image: url(portal/button_hover.png);
	background-repeat: repeat-x;
}
</style>>
}

/// Determine if we need login CSRF tokens and if so add them.
/// If a login page subclass overrides this method it should call this implementation
/// to ensure we set the login CSRF tokens if needed.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	If '$$UseCSRFtoken^%SYS.cspServer(%request.AppData) RETURN 1
	Set token=$translate($piece($system.Encryption.Base64Encode($system.Encryption.GenCryptRand(12),1),"=",1),"+/","-_")
	Set %response.Context("CacheSessionToken")=token
	Set cookiepath=%session.CookiePath
	If $extract(cookiepath,*)'="/" Set cookiepath=cookiepath_"/"
	Do %response.SetCookie("CacheSessionToken",token,,$zcvt($zcvt(cookiepath,"O","UTF8"),"O","URL"),,%request.Secure,1)
	RETURN 1
}

}
