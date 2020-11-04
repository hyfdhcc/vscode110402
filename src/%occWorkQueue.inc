ROUTINE %occWorkQueue [Type=INC]
#;
#; macros for the work queue code
#;
#; The build process creates a %SYS.WorkQueueMgr1.mac where it enables logging so we do not have
#; the cost of checking ^%ISCLOG in the regular production version but we can switch this over
#; if wanted.
#if $g(^%SYS("Compiler","EnableWorkLogging"))
#define WorkSysLog(%level,%cat,%message,%data)     Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data)
#def1arg WorkSysLogError(%params)                  Do:$get(^%ISCLOG,1)>0 LogError^%SYS.ISCLOG($ZNAME,%params)
#define WorkSysLogTag(%level,%cat,%message,%data,%tag)   Do:$get(^%ISCLOG,1)'<%level Log^%SYS.ISCLOG($ZNAME,%level,%cat,%message,%data,%tag)
#else
#define WorkSysLog(%level,%cat,%message,%data)
#def1arg WorkSysLogError(%params)
#define WorkSysLogTag(%level,%cat,%message,%data,%tag)
#endif
#define WORKdaemonlock  ^%ISCWorkQueue(":Daemon")
#define WORKdaemonstart ^%ISCWorkQueue(":DaemonStart")
#define WORKroot        ^%ISCWorkQueue
#def1arg WORK(%args)    ^%ISCWorkQueue(%args)
#define nameWORKCmd     "^%ISCWorkQueue(""WorkerCmd"")"
#define nameWORKWork(%group)	"^%ISCWorkQueue("_%group_",0)"
#define nameWORKComplete(%group)	"^%ISCWorkQueue("_%group_",1)"
#define nameWORKDaemon  "^%ISCWorkQueue(""Daemon"")"

#define CheckAccessVar(%sc) Set %sc=$$$OK If '$get(group) { $$$WorkSysLog(1,"WorkMgr","No work group specified",$lb(group,$zu(41,-2))) Set %sc=$$$ERROR($$$MultiNoZero) } ElseIf $listget($get($$$WORK(group,"Settings")))'=$job { If $listget($get($$$WORK(group,"Settings")))="" { $$$WorkSysLog(1,"WorkMgr","Access error, multi queue not present or deleted",$lb(group,$zu(41,-2))) Set %sc=$$$ERROR($$$MultiQueueDeleted,group) } Else { $$$WorkSysLog(1,"WorkMgr","Access error, no access to this queue",$lb(group,$listget($get($$$WORK(group,"Settings"))),$zu(41,-2))) Set %sc=$$$ERROR($$$MultiInvalidQueue,group,$job_":"_$listget($get($$$WORK(group,"Settings")))) } }
#define CheckAccess     $$$CheckAccessVar(sc) If $$$ISERR(sc) Quit sc
#define CheckAccessOK   If '$get(group)&&($data(^||%ISC.WorkQueueMgr("ZeroGroup"),group)#2=0)||('$data($$$WORK(group,"Settings"))) { Quit $$$OK } If $case($listget($get($$$WORK(group,"Settings"))),$job:0,"":0,:1) { Quit $$$OK }
#define TranSuspend     If $tlevel { Set transactionSuspend=$zutil(139,1) }
#define TranResume      If $data(transactionSuspend)#10=1 { Do $zutil(139,transactionSuspend) }
#define BreakSuspend    If $zjob\4#2 { Set tBreakFlag=1 Break 0 }
#define BreakResume     If $data(tBreakFlag) { Break 1 }
#define PosixTime       $zutil(99)
