ROUTINE %occStatus [Type=INC]
/// Create a success %Status code
#define OK                     1
 
#define  ERRORCODE(%ErrorArgList)      ##safeexpression($$macroERRORCODE^%occMsgXML(%literalargs))
 
/// Create an error %Status code
/// %arg1 - Error code, total list of codes in %occErrors.inc
/// %arg2 - Optional additional information
#def1arg ERROR(%ErrorArgList)          ##safeexpression($$macroERROR^%occMsgXML(%literalargs))
 
#define  ERR(%ErrorArgList)            ##safeexpression($$macroERROR^%occMsgXML(%literalargs))
#def1arg ERRORSTATUS(%ErrorArgList)    ##safeexpression($$macroERRORSTATUS^%occMsgXML(%literalargs))
#def1arg EMBEDERROR(%ErrorArgList)     ##safeexpression($$macroEMBEDERROR^%occMsgXML(%literalargs))
 
/// Return true if the %Status code is success, and false otherwise
/// %sc - %Status code
#define ISOK(%sc)              (''%sc)
 
/// Return true if the %Status code if an error, and false otherwise
/// %sc - %Status code
#define ISERR(%sc)             ('%sc)
#define LISTINTERRUPTERRORS    "|INTERRUPT|FILEFULL|DISKHARD|DATABASE|SYSTEM|STORE|EXTERNAL INTERRUPT|ALARM|DSKFUL|"
#define ISINTERRUPT(%sc)       ($$$ISERR(%sc)&&$case($lg($lg($e(%sc,3,*))),$$$ERRORCODE($$$MultiShutdown):1,$$$ERRORCODE($$$MultiQueueDead):1,$$$ERRORCODE($$$CacheError):$$$LISTINTERRUPTERRORS[("|"_$p($p($lg($lg($e(%sc,3,*),1),2),">"),"<",2)_"|"),:0))
#define ZERRORTOSTATUS(%sc)    If $piece($piece($zerror,">"),"<",2)="THROW",$isobject($throwobj) { Set %sc=$throwobj.AsStatus() } Else { Set %sc=$$$ERROR($$$CacheError,$zerror) }
#define ISINTERRUPTTHROW(%sc)  If $$$ISINTERRUPT(%sc) { $$$DecErrorNum Throw ##class(%Exception.StatusException).ThrowIfInterrupt(%sc) }
#define ISEXCEPTIONINTERRUPTTHROW(%ex) If $classname(%ex)="%Exception.SystemException",(%ex.Code=$$$ERRORCODE($$$CacheError)&&($$$LISTINTERRUPTERRORS[("|"_$piece($piece(%ex.Name,">"),"<",2)_"|")))||(%ex.Code=$$$ERRORCODE($$$MultiShutdown))||(%ex.Code=$$$ERRORCODE($$$MultiQueueDead)) { ZTrap $zerror }
 
/// Return the error code from a %Status value
/// %sc - %Status code
#define GETERRORCODE(%sc)      $listget($listget($extract(%sc,3,*)),1,0)
 
/// Append a %Status code to an existing %Status value
/// %sc1 - Existing %Status value
/// %sc2 - %Status value to append
#define ADDSC(%sc1,%sc2)       $select(+%sc1:%sc2,1:$$AppendStatus^%occSystem(%sc1,%sc2))
 
/// Embed additional information about %Status code
/// %sc1 - Existing %Status code
/// %sc2 - %Status value to embed in %sc1
#define EMBEDSC(%sc1,%sc2)     $$EmbedStatus^%apiOBJ(%sc1,%sc2)
 
#define GETERRORCOUNT(%sc)     $listlength($extract(%sc,3,*))
#;
#define QuitOnError(%expr)     Set sc=%expr Quit:$$$ISERR(sc) sc
#define QUITONERROR(%sc,%expr) Set %sc=%expr Quit:$$$ISERR(%sc) %sc
#define ThrowOnError(%expr)    Set sc=%expr Throw:$$$ISERR(sc) ##class(%Exception.StatusException).ThrowIfInterrupt(sc)
 
/// If the expression returns an error %Status code then throw this as an exception
/// %sc - Local variable to return %Status code into
/// %expr - Expression to evaluate that returns a %Status code
#define THROWONERROR(%sc,%expr) Set %sc=%expr Throw:$$$ISERR(%sc) ##class(%Exception.StatusException).ThrowIfInterrupt(%sc)
 
#define TOE(%sc,%expr)         $$$THROWONERROR(%sc,%expr)
 
/// Throw a %Status code as an exception
/// %sc - %Status code to throw
#define ThrowStatus(%sc)       Throw ##class(%Exception.StatusException).ThrowIfInterrupt(%sc)
 
#define YES 1
#define NO  0

#; Throw a swizzle failure error
#define THROWSWIZZLEERR        Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1)

#def1arg AutoLock(%LockrefTypeTimeout) ##safeexpression($$macroLock^%occMsgXML(%literalargs))
#define BitMerge(%dest,%source) ##safeexpression($$bitmerge^%occMsgXML(%literalargs))