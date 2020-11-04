ROUTINE %occDiagnostics [Type=INC]
#; Object Diagnostics macros
#define diagReference                          %objDIAG
  
#define diagInitialize                         s $$$diagReference=""
#define diagSetError(%error)                   s $$$diagReference=$$Error^%occSystem(%error)
#define diagAppendError(%error)                s $$$diagReference=$$AppendError^%occSystem($g($$$diagReference),%error)
#define diagAppendWarning(%warning)            s $$$diagReference=$$AppendWarning^%occSystem($g($$$diagReference),%warning)
  
 
#define SysLogSession(%level,%cat,%message,%data,%tag,%sessionid)  Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data,%tag,%sessionid)
#define SysLogTag(%level,%cat,%message,%data,%tag)   Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data,%tag)
#define SysLog(%level,%cat,%message,%data)     Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
#def1arg SysLogError(%params)                  Do:$get(^%ISCLOG,1)>0 LogError^%SYS.ISCLOG($ZNAME,%params)
#def1arg SysLogUser                            Do:$get(^%ISCLOG,1)>1 LogUserInfo^%SYS.ISCLOG($ZNAME)
#define SysLogLevel                            $get(^%ISCLOG,1)
#define SysLogVarSession(%level,%cat,%message,%data,%tag,%sessionid)  Do:$get(%SYSLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data,%tag,%sessionid)
#define SysLogVarTag(%level,%cat,%message,%data,%tag)  Do:$get(%SYSLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data,%tag)
#define SysLogVar(%level,%cat,%message,%data)  Do:$get(%SYSLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
#def1arg SysLogErrorVar(%params)               Do:$get(%SYSLOG,1)>0 LogError^%SYS.ISCLOG($ZNAME,%params)
#def1arg SysLogUserVar                         Do:$get(%SYSLOG,1)>1 LogUserInfo^%SYS.ISCLOG($ZNAME)
#define SysLogCondSetVar                       If '$data(%SYSLOG) New %SYSLOG Set %SYSLOG=$get(^%ISCLOG,1)
#define SysLogSetVar                           New %SYSLOG Set %SYSLOG=$get(^%ISCLOG,1)
#define SysLogResetVar                         Set %SYSLOG=$get(^%ISCLOG,1)
