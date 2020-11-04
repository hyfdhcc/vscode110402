ROUTINE %cspInclude [Type=INC]
 ;
#define GETIO                   $zutil(96,18,0)
#define SETIO(%table)           Do $zutil(96,18,2,%table)
#define NormalizeFilename(%url) $zconvert($tr(%url,"\","/"),"l")
#define URLENCODE(%string)      $zconvert($zconvert(%string,"O",$replace($$$GETIO,"JSML","UTF8")),"O","URL")
#define URLDECODE(%string)      $zconvert($zconvert(%string,"I","URL"),"I",$replace($$$GETIO,"JSML","UTF8"))
#define HTMLENCODE(%string)     $zconvert(%string,"O","HTML")
#define HTMLDECODE(%string)     $zconvert(%string,"I","HTML")
#define cspEncode(%k,%d)        $translate($System.Encryption.AESBase64Encode(%d,%k),"+=/"_$char(32,13,10),"_-$")
#define cspDecode(%k,%d)        $System.Encryption.AESBase64Decode($translate(%d,"_-$","+=/"),%k)
#define cspBase64Encode(%d)     $translate($System.Encryption.Base64Encode(%d),"+=/"_$char(32,13,10),"_-$")
#define cspBase64Decode(%d)     $System.Encryption.Base64Decode($translate(%d,"_-$","+=/"))
#define cspRewriteUrl(%u)       ##class(%CSP.Page).RewriteURL(%u)
#define EOL                     $c(13,10)
 
#define PROCESSCHILDREN		1
#define SKIPCHILDREN		0
 
#define cspBrokerInsertJS           "<script language=""JavaScript"" type=""text/javascript"" src="""_$select($isobject($get(%request)):%request.URLPrefix,1:"")_"/csp/broker/cspbroker.js""></script>"
#define cspStrictBrokerInsertJS     "<script type=""text/javascript"" src="""_$select($isobject($get(%request)):%request.URLPrefix,1:"")_"/csp/broker/cspbroker.js""></script>"
#define cspBrokerInsertHttpJS       "<script language=""JavaScript"" type=""text/javascript"" src="""_$select($isobject($get(%request)):%request.URLPrefix,1:"")_"/csp/broker/cspxmlhttp.js""></script>"
#define cspStrictBrokerInsertHttpJS "<script type=""text/javascript"" src="""_$select($isobject($get(%request)):%request.URLPrefix,1:"")_"/csp/broker/cspxmlhttp.js""></script>"
 
#define cspBrokerRunCode		    """cspHttpServerMethod"""
#define cspBasicBrokerRunCode	    """cspHttpServerMethod"""
#define cspBrokerCallCode		    """cspCallHttpServerMethod"""
#define cspBasicBrokerCallCode	    """cspCallHttpServerMethod"""
#define cspMVBasicBrokerRunCode	    "'cspHttpServerMethod'"
#define cspMVBasicBrokerCallCode	"'cspCallHttpServerMethod'"
 
#define cspJavaScriptStart          "<script language=""JavaScript"" type=""text/javascript"">"
#define cspStrictJavaScriptStart    "<script type=""text/javascript"">"
#define cspJavaScriptEnd            "</script>"
 
#define htmlJavaScriptStart         <script language="JavaScript" type="text/javascript">
#define htmlStrictJavaScriptStart   <script type="text/javascript">
#define htmlJavaScriptEnd           </script>

#define SessionIdx 1
#define ApplIdx  2
#define lboSecHashIdx 1 
#define lboLoginStateIdx 2
#define lboExpireTimeIdx 3
#define lboAutheEnabledIdx 4

#define TIMESTAMP(%t)     (($P(%t,",")*86400)+$P(%t,",",2))
#; for Security Token Limbo
#define LimboExists (($Data(^%cspSession(-2)))&&($Data(^%cspSession(-1))))
#;define ByExpireTimeSlot(%ts)  ^%cspSession(-2,%ts)
#define ByApplSlot(%sessionId,%appl) ^%cspSession(-1,%sessionId,%appl)
#;define NextApplBySessionFromLimbo(%sessionId,%appl) $o(^%cspSession(-1,%sessionId,%appl))

#; for Group-by-Id applications 
#define GroupByIdRoot           ^%cspSession(-3)
#define GroupByIdSlot(%groupId) 	^%cspSession(-3,%groupId)
#define GroupByIdItem(%groupId,%sessionList,%loginState,%language) $lb(%groupId,%sessionList,%loginState,%language)
#define giGroupIdG(%list)		$ListGet(%list,1)
#define giSessionListG(%list) 	$ListGet(%list,2)
#define giLoginStateG(%list) 	$ListGet(%list,3)
#define giLanguageG(%list) 		$ListGet(%list,4)
#define giGroupIdS(%list)		$List(%list,1)
#define giSessionListS(%list) 	$List(%list,2)
#define giLoginStateS(%list) 	$List(%list,3)
#define giLanguageS(%list)	 	$List(%list,4)

#define CSPtokendefaulttimeout  300 

#define ecEventClassIdx 1
#define ecNamespaceIdx 2
#define ecSecContextIdx 3
 
#define LoginStateBuild(%applname, %username, %securitycontext, %logintoken, %isnewlogin, %passed2fa, %auditLogin, %appSwitchOnly ) $ListBuild(%applname, %username, %securitycontext, %logintoken, %isnewlogin, %passed2fa, %auditLogin, %appSwitchOnly )
#define lsAppNameIdx 			1
#define lsUsernameIdx 			2
#define lsSecContextIdx			3
#define lsLoginTokenIdx			4
#define lsIsNewLoginIdx			5
#define lsPassedTwoFactorIdx	6
#define lsAuditLoginIdx			7
#define lsTradeLicense			8
#define lsAppNameG(%list)		$ListGet(%list,$$$lsAppNameIdx)
#define lsUsernameG(%list)		$ListGet(%list,$$$lsUsernameIdx)
#define lsSecContextG(%list)	$ListGet(%list,$$$lsSecContextIdx)
#define lsLoginTokenG(%list)	$ListGet(%list,$$$lsLoginTokenIdx)
#define lsIsNewLoginG(%list)	$ListGet(%list,$$$lsIsNewLoginIdx)
#define lsPassedTwoFactorG(%list) 	$ListGet(%list,$$$lsPassedTwoFactorIdx)
#define lsAuditLoginG(%list) 	$ListGet(%list,$$$lsAuditLoginIdx)
#define lsTradeLicenseG(%list) 	$ListGet(%list,$$$lsTradeLicense)

#define UseLegacySessionSharing "UseLegacySessionSharing"

#define ZuFinishOpOnWebServerTCPDevice 		$zutil(166,1)
#define ZuNoFlushOpOnWebServerTCPDevice     $zutil(166,1,1)
#define ZuClientOSParms2(%arg1,%arg2) 		$zutil(67,14,%arg1,%arg2)
#define ZuClientOSParms1(%arg1)       		$zutil(67,14,%arg1)
#define ZuIODevice(%routine) 				$zutil(111,%routine)
#define ZuSendMsgToOperator(%msg) 			$zutil(9,"",%msg)
#define ZuLicenseCheck 						$zutil(112,17,0)
#define ZuPSW2SUSPENDTRANSbit				$zutil(139)
#define ZuPSW2SUSPENDTRANSbitSet(%value) 	$zutil(139,%value)
#define ZuSetState(%index,%value) 			$zutil(68,%index,%value)
#define ZuGetDefault(%index) 				$zutil(69,%index)
#define ZuSetPzuints(%index,%value)			$zutil(115,%index,%value)
#define ZuFixDate  							$zutil(71,0)
#define ZuGetFileSize(%filename)			$zutil(140,1,%filename)
#define ZuErasePrivateGlobals 				$zutil(21,2)


#; Log key names
#define CatLicense "CSPLicense"
#; triggered by ^%ISCLOG
#define CSPLogAll(%level,%cat,%message,%data,%tag,%sessonid) $$$SysLogVarSession(%level,%cat,%message,%data,%tag,%sessonid)
#; triggered by %SYSLOG
#define CSPLogVar(%level,%cat,%message,%data,%tag) $$$SysLogVarTag(%level,%cat,%message,%data,%tag)
#def1arg CSPLogErrorVar(%params) $$$SysLogErrorVar(%params)
#def1arg CSPLogError(%params)  $$$SysLogError(%params)

#define MultiPageSession 2
#define ImmediateLicenseRelease -1
#define ScheduleLicenseRelease -2

#define SetExternalInterrupts(%setting) Do $System.Util.SetInterruptEnable(%setting)
#define ISEXTINTERRUPT(%sc)  ("|EXTERNAL INTERRUPT|"[("|"_$p($p($lg($lg($e(%sc,3,*),1),2),">"),"<",2)_"|"))

#define DefaultErrorPage 			"/csp/sys/%CSP.ErrorLog.cls"
#define FileServerPage 				$get(^%SYS("CSP","FileServerPage"),"%CSP.StreamServer.cls")
