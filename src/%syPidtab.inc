ROUTINE %syPidtab [Type=INC]
#;%syPidtab.INC -Defines for dynamic pidtab and ttyhash ;$Change:$
	; Revision: $Id:$
#if 0   /*=======================Maintenance========================*/
#;JO2965  12/15/16 Jeffrey Orlin add DEEPSEEAGENT as a jobtype
#;JLC1902  8/20/15 Jose' Cordeiro, fix $$$pidsperchunk
#;JO2673   6/14/13 Jeffrey Orlin, jobtype for mirror arbiter client
#;JO2429   4/11/11 Jeffrey Orlin, add relay mirror server job type
#;RJW1886 04/09/11 Ron Watt, Add job type for ems client side monitor.
#;SML1328 03/25/11 Simon Li, Fix altpidsize on some platforms could be 16 bytes.
#;RJW1847 10/01/10 Ron Watt, System Daemons started by super server 
#;			consume license with realtime or web key 
#;JO2141   6/03/09 Jeffrey Orlin, add mirroring job types
#;JO2213   3/24/08 Jeffrey Orlin, add CALLINJOB and LCBJOB job types
#;SML957  11/09/07 Simon Li, Fix getaltpid() macro for USETID platforms.
#;STC1086 10/04/06 Steve Clay, Update TASKMGR LOCATION field.
#;JO2062  8/02/06 Jeffrey Orlin, renumbered jobtypes to match pidtab.h.
#;		  Removed an unused type. Added PEX_ defined for resjob
#;		  exit status
#;SAP565  4/24/06 Steve Pettibone, fill in offsets for pidoff,tidoff
#;JO1984 11/16/05 Jeffrey Orlin, add PIDSIZE, PIDOFF, TIDOFF
#;STC977  03/19/06 Steve Clay, LDAP and User-Defined Authentication 
#;SML674  1/26/06 Simon Li, Change Clean Daemon's jobtype from 146 to 152.
#;GK383  12/14/04 Garen Kotikian, Added ECP process dmn to the process 
#;		  class system jobs.
#;LFT1316 11/10/4 Laura Tillem, %SYSTEM.Process -> SYS.Process
#;JO1834 09/23/04 Jeffrey Orlin, add SYSWATCHTYPE for ^SYSWATCH dmn and
#;                "names" for task mgr, clean dmn and syswatch dmn.
#;SML471 07/09/04 Simon Li, Add CLNDTYPE for clean daemon
#;STC471 09/19/03 Steve Clay, renamed, added %sySt
#;STC362 09/16/02 Steve Clay, Updated jobtype fields
#;STC351 06/03/02 Steve Clay, Add jobtype definitions
#;STC345 04/06/02 Steve Clay, Add lots of macros
#;LFT961 01/22/01 Laura Tillem, dynamic pidtab
#;LFT965 11/02/01 Laura Tillem, dynamic ttyhash
#endif  /*=====================End Maintenance======================*/
 
#ifndef %syPidtabinc
#define %syPidtabinc
#include %sySt
#; defines for %SS,JOBEXAM, and SYS.Process
#ifdef TESTPID
#define startpidnum 16
#define pidtabshift 4
#else
#define startpidnum 256
#define pidtabshift 5
#endif
#define pidsperchunk $zu(40,0,102)
#;SML1328 ; the altpid size could be 4, 8 or 16 bytes.
#define altpidsize $s($$$USETID:$zu(40,28,79)*2,1:4)
#define pidtabstart $ZU(40,2,139)
#; The following are all the offsets to the fields in the partition
#define pidtabsize $zu(40,28,0)
 
#define getaltpid(%x) $View($View($$$STALTPID+((%x\$$$pidsperchunk)*$$$STshmoff),-2,$$$STshmoff)+((%x#$$$pidsperchunk)*$$$altpidsize),-2,4)
 
#define pidchunkstart(%x) $View($$$pidtabstart+((%x\$$$pidsperchunk)*$$$STshmoff),-2,$$$STshmoff)
 
#;JO1984+
#; USETID means that process id's are structures not simple #'s. When
#; USETID is FALSE, $$$TIDOFF should not be used. $$$PIDOFF is valid.
#; This Cache' binary can interact with threaded Cache' processes but
#; this process cannot be multi-threaded.
#define USETID $ZBITGET($ZVERSION(0),40)
 
#; USETHREAD means that this process is running a Cache' binary which
#; supports multiple Cache' threads for a single job.
#define USETHREAD $ZBITGET($ZVERSION(0),38)
 
#;	PIDSIZE is the size in bytes of a ttypid entry
#define PIDSIZE		$ZU(40,0,77)
#;	PIDOFF is the offset to the 32-bit pid from a ttypid pointer
#define PIDOFF		$ZU(40,28,78)
#;	TIDOFF is the offset to the 32-bit tid from a ttypid pointer.
#;	This has no meaning when $$$USETID is false.
#define	TIDOFF		$ZU(40,28,79)
#;	jobid is the process' presqpnt->jobid field which is the
#;	job # plus a counter to differentiate different processes
#;	using the same job slot. It is used in cases where we want
#;	a 32-bit id and we clean up after a dead job so we don't worry
#;	about the counter portion wrapping (eg. job10only, transactions
#;	in the journal file).
#define	JOBID	$ZU(61,30,$zu(61))
#;JO1984- 
 
#; The following are definitions which get the values of the pidtab fields
#; Note that some are undefined as they are not currently either interesting
#; or required
#; The following are pidtab JobType defines (see pidtab.h)
#; ;JO2062+
#define NOJOB		0
#define FOREJOB		1
#define	APPMODE		2
#define FORAPPJOB	3
#define	CPTYPE		4
#define	WDTYPE		5
#define	GCTYPE		6
#define	JDTYPE		7
#define	ENQTYPE		8
#define	RDTYPE		9
#define	SLWDTYPE	10
#define	NETSRVTYPE	11
#define	NETDMNTYPE	12
#define	LICENSESRV	13
#define	BMCSRV		14
#define	CSPDMNTYPE	15
#define	DTMSRV		16
#define	DTMNSPSRV	17
#define	SHADMASTSRV	18
#define	SHADSRV		19
#define	SHADCLISRV	20
#define RCVDMNTYPE	21
#define	SHUTDOWNJOB	22
#define	JOBSRVTYPE	23
#define	CMTMASTSRV	24
#define	MSMACTSRV	25
#define	CDIRECTSRV	26
#define	CSPSRV		27
#define	ODBCSRV		28
#define	COMMCTRLTYPE	29
#define DBXDMNTYPE	30
#define ECPWorker	31
#define ECPCliR 	32
#define ECPCliW		33
#define ECPSrvR		34
#define ECPSrvW		35
#define TASKTYPE	36
#define SYSWATCHTYPE	37
#define CLNDTYPE	38
#define SNMPTYPE	39
#define WMITYPE		40
#define MONITORTYPE	41
#define MONAPPTYPE	42
#define LDAPTYPE	43
#;JO2141+
#define MIRRORMASTER  44
#define MIRRORPRIMARY 45
#define MIRRORBACKUP 46
#;JO2141-
#;JO2213+
#define CALLINTYPE	47
#define LCBTYPE		48
#;JO2213-
#;JO2141+
#define MIRRORPREFETCH	49
#define MIRRORSVRRDDMN	50
#define	MIRRORJRNREAD   51
#define MIRRORSETKILL   52
#define MIRRORCOMM	53
#define SPECCALLIN	54
#;JO2141-
#; ;JO2062-
#;RJW1847+
#define DAEMONJOB	55
#;RJW1847-
#;RJW1886+
#define EMSCLIENT	56
#;RJW1886-
#;JO2429+
#define MIRRORRELAY	57
#;JO2429-
#;JO2673+
#define MIRRORARBITERCLIENT	58
#;JO2673-
#define WORKQUEUESRV 59
#;JO2965+
#define DEEPSEEAGENT 60
#;JO2965-
#;
#;The INTERACTIVE/BACKGROUND job categorization is used as follows::
#;a) the clean dmn only cleans up interactive/background jobs
#;b) when halting only interactive/background jobs run CLEANUP^HALT
#;   (which does SQL cleanup) and %ZHALT/%ZSTOP.
#;c) DataMove & %Journal.File only check background & interactive jobs
#;   for open transactions   
#;d) Patrol, Studio Debugger and Jobexam don't check for 'vss' names
#;   for background/interactive jobs
#;e) Shutdown terminates INTERACTIVE/BACKGROUND jobs before others
#;   and then there are explicit tests for some of the system jobs
#;   which get shut down in a particular order.
#;
#define INTERACTIVEJOB(%x) (%x=$$$FOREJOB)||(%x=$$$FORAPPJOB)
#;JO2213: Add LCBTYPE and CALLLINTYPE to BACKGROUNDJOB() list
#;SAP1332: Add MONAPPTYPE to BACKGROUNDJOB() list
#;JO2965: Add DEEPSEEAGENT as a BACKGROUNDJOB()
#define BACKGROUNDJOB(%x) (%x=$$$APPMODE)||(%x=$$$CSPSRV)||(%x=$$$ODBCSRV)||(%x=$$$CDIRECTSRV)||(%x=$$$JOBSRVTYPE)||(%x=$$$MSMACTSRV)||(%x=$$$LCBTYPE)||(%x=$$$CALLINTYPE)||(%x=$$$MONAPPTYPE)||(%x=$$$WORKQUEUESRV)||(%x=$$$DEEPSEEAGENT)
#; %ProcessQuery uses the "vss" jobname where present and for certain other
#; jobs uses the values in the following definitions. These are done with a
#; series of explicit tests so if you add something here, you probably need to
#; update the code so it gets used.
#define FOREJOBNAME	"shell"
#define	APPMODENAME		
#define FORAPPJOBNAME
#define	CPTYPENAME	"CONTROL"	
#define	WDTYPENAME	"WRTDMN"	
#define	GCTYPENAME	"GARCOL"	
#define	JDTYPENAME	"JRNDMN"	
#define	ENQTYPENAME	"ENQDMN"	
#define	RDTYPENAME		
#define	SLWDTYPENAME "SLAVWD"		
#define	NETSRVTYPENAME	"DCP"	
#define	NETDMNTYPENAME	"DMNNET"	
#define	LICENSESRVNAME		
#define	BMCSRVNAME		
#define	CSPDMNNAME
#define	DTMSRVNAME		
#define	DTMNSPSRVNAME		
#define	SHADMASTSRVNAME		
#define	SHADSRVNAME		
#define	SHADCLISRVNAME		
#define RCVDMNTYPENAME		
#define	SHUTDOWNJOBNAME		
#define	JOBSRVTYPENAME	"JOBSRV"	
#define	CMTMASTSRVNAME		
#define	MSMACTSRVNAME		
#define	CDIRECTSRVNAME		
#define	COBJSRVNAME		
#define	CSPSRVNAME		
#define	ODBCSRVNAME		
#define	COMMCTRLTYPENAME		
#define DBXDMNTYPENAME	"EXPDMN"	
#define ECPWorkerNAME	"ECPWORK"
#define ECPCliRNAME		
#define ECPCliWNAME		
#define ECPSrvRNAME		
#define ECPSrvWNAME		
#define TASKNAME "TASKMGR"
#define CLNDNAME "CLEANDMN"
#define SYSWATCHNAME "SYSWATCH"	
 
#; size of ttyhash[] array
#define ttyhashtopnum    $ZU(40,0,66)
#;  ttyentry structure definitions
#define ttypid(%x)       %x+$ZU(40,33,0)
#define ttynamlen(%x)    %x+$ZU(40,33,1)
#define ttylow8(%x)      %x+$ZU(40,33,2)
#define ttynam(%x)       %x+$ZU(40,33,3)
#; ;JO2062+
#; PEXSHUTDOWN and PEXKILLJOB are exit code values for
#; $ZU(4,pid,exitcode). Certain processes will not respond to
#; resjob (see jtinfo table) unless one of these codes is
#; specified. See pidtab.h for more info.
#define PEXSHUTDOWN $ZU(40,0,79)
#define PEXKILLDMN  $ZU(40,0,80)
#;
#; The following return 1 if the pid/job# is an active
#; Cache' job (in the pidtab, passes 'checkjob') and 0 if
#; not.
#define PIDALIVE(%pid) $ZU(67,%pid)
#define JOBALIVE(%job) $ZU(61,%job)
#; JO2062-