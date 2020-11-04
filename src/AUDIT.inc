ROUTINE AUDIT [Type=INC]
#ifndef AUDITinc
#define AUDITinc
 /* AUDIT.INC */
#include %sySite
#if 0   /*=======================Maintenance========================*/
#;STC2106 06/26/12 Steve Clay, Add username to process terminate audit message
#;STC1927 03/30/11 Steve Clay, Log audit Description properly when auditing a Terminate event
#;STC1600 05/19/09 Steve Clay, Fix TASKMGR audit records 
#;STC1136 12/20/06 Steve Clay, Fix NOROUTINE error during HALT in INSTALL 
#;STC1119 12/01/06 Steve Clay, Don't do extra work if not auditing logout
#;STC1094 10/23/06 Steve Clay, Add RoutineChange and Terminate events
#endif  /*=====================End Maintenance======================*/
#;From Partitio.h
#define	PEXTEXIT	0	/* Application exited the stack. */
#define	PEXTRESJOB	1	/* A RESJOB signal is received. */
#define	PEXTSIGTERM	2	/* A SIGTERM signal is received. */
#define PEXTEXCEPTION 3	/* An exception was hit */
#define PEXTHALT	4	/* A halt command was executed */
#define PEXTSUICIDE	5	/* Process resjobbed itself (not that different than halt but we get to specify an exit status) */
#define	PEXTDISCON	6	/* Terminal/Client disconnected & we're set to halt if that happens */
#define PEXTMFORCE	7	/* mforce told us to exit */
#define	PEXTSIGHUP	8	/* A SIGHUP signal was received */
#define PEXTEXITAST	9	/* A VMS $FORCEX or $DELPRC was delivered and set the stopid flag which we converted to paterm */
#define	PEXTWINDOWCLOSE    10	/* windows: window close event */
#define PEXTUSERLOGOFF     11	/* windows: user logged off */
#define PEXTSYSTEMSHUTDOWN 12	/* windows: system shutdown event */
AUDITLOGOUT(Data="",Description="") PUBLIC {
 s $zt="Error"
 s Reason=$zu(96,34)
#;Don't do all this work if Logout is not audited
 i '($$$LogoutAuditIsOn||$$$TerminateAuditIsOn) g NoAudit
 i Description="" {
	s ExeName=$zu(67,13,$j)
	i ExeName="" {
		s x=$$UsersGetLoginRoutineName^%SYS.SECURITY(.Label,.Routine)
 		i (Label_Routine)'="" {
	 		i Routine="%SYS.PMODE" {
 		 		s ShellRoutine=$$$GetMsg($$$UsersMsg,"ProgrammerMode")
		 	} else {
			 	i Routine["%SYS.Task" {
			 		s ShellRoutine=$$$GetMsg($$$AuditMsg,"Task")
			 	} else {
				 	s ShellRoutine=Label_"^"_Routine
			 	}
	 		}
 		} else {
	 		s ShellRoutine=$$$GetMsg($$$UsersMsg,"ProgrammerMode")
 		}
	} else {
		i ExeName="CspMs.dll" {
			s ShellRoutine=$$$ServiceCSP
		} else { 
			s ShellRoutine=ExeName
		}
	}
    s Description=ShellRoutine_" "_$$$FormatMsg($$$AuditMsg,$case(Reason,$$$PEXTEXIT:"EXIT",$$$PEXTRESJOB:"RESJOB",$$$PEXTSIGTERM:"SIGTERM",$$$PEXTEXCEPTION:"EXCEPTION",$$$PEXTHALT:"HALT",$$$PEXTSUICIDE:"SUICIDE",$$$PEXTDISCON:"DISCON",$$$PEXTMFORCE:"MFORCE",$$$PEXTSIGHUP:"SIGHUP",$$$PEXTEXITAST:"EXITAST",$$$PEXTWINDOWCLOSE:"WINDOWCLOSE",$$$PEXTUSERLOGOFF:"USERLOGOFF",$$$PEXTSYSTEMSHUTDOWN:"SYSTEMSHUTDOWN",:"UNKNOWN"))
 }
#;Pad any passed in data with a CRLF
 i Data'="" s Data=Data_$c(13,10)
 i (Reason=$$$PEXTRESJOB)!(Reason=$$$PEXTSUICIDE) {
#;Suicides - $zu(4,$j) - come through with a pid of 0
	i (Reason=$$$PEXTSUICIDE) {
		s Pid=$j
	} else {
		s Pid=$zu(96,35) 
	}
	s User=$zu(67,22,Pid)
	i $$$ISVMS s Pid=$zhex(Pid)
	s Data=Data_$$$FormatMsg($$$AuditMsg,"ProcessTerminatedBy",Pid_":"_User)_$c(13,10)
 }
#;%0ze0 and %0zu560 are set by ^HALT, otherwise undefined
 i $g(%0ze0)'="" s Data=Data_$$$FormatMsg($$$AuditMsg,"ProcessExit",$c(13,10)_"$ZE:       "_$g(%0ze0)_$c(13,10)_"$ZU(56,2): "_$g(%0zu560)_$c(13,10))
#;Log as a normal logout for these ones. Consider everything else 
#;as a "terminate" so we can choose to audit just abnormal process exits.
#;Treat Suicidal processes as normal logouts.
NoAudit
 i (Reason=$$$PEXTEXIT)||(Reason=$$$PEXTHALT)||(Reason=$$$PEXTSUICIDE) {
	 s Name=$$$NameLogout
 } else {
	 s Name=$$$NameTerminate
 }
 d $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeLogin,Name,Data,Description)
 q
Error s $zt="Error1"
 d $SYSTEM.Security.Audit("%System","%Login","Logout","","Error: "_$ze_" during HALT")
Error1 q
}
#endif AUDITinc