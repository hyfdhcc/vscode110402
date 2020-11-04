ROUTINE %sySystem [Type=INC]
#ifndef %sySysteminc
#define %sySysteminc
#;  ; Revision: $Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/inc/_sySystem.inc#1 $ ($Change: 4521965 $)
#if 0   /*=======================Maintenance========================*/
#;JLC1903  8/21/15 Jose' Cordeiro, remove USEDYNPIDTAB conditionals (always on)
#;RJW2259 12/15/14 Ron Watt, Increase $S memory during startup and shutdown.
#;SML1802 11/26/13 Simon Li, Update for 'Database Latency' in Mirror Monitor.
#;STC1916 03/07/11 Steve Clay, When activating namespaces, take a lock 
#;                 to prevent readers from reading changing namespace tables 
#;JO2397  02/09/11 Jeffrey Orlin, add USEDSONLY and USEUNICODE
#;HYY1600 12/09/10 Huayong Yang, add GETECPSYSID
#;SML1265 12/01/10 Simon Li, Replace ^CacheTemp with private global in system query codes.
STC1772; 03/23/10 Steve Clay, System will start if config globals are corrupted
STC1719; 12/09/09 Steve Clay, New CACHE database 
JO2141 ; 2/04/09 Jeffrey Orlin, add note re SFNMAX and SFNUNDEF
RJW1652; 1/23/09 Ron Watt, change value of $$$MAXBBSZ in %sySystem.inc
STC1529; 01/20/09 Steve Clay, Add %syNamespace
STC1509; 12/9/08 Steve Clay Return error code to script if STU fails 
STC1461; 9/30/2008 Steve clay Optimize retrieval of database references
SML1052; 09/08/08 Simon Li, Fix backup history date subscript problem.
STC1394; 05/05/08 Steve Clay, Display additional error messages to terminal during startup 
STC1348; 05/05/08 Steve Clay, Display fatal startup message to terminal for VMS and UNIX
HYY1347;09/20/07 Huayong Yang, define SFNtoDIR
STC1066; 09/26/06 Steve Clay, Define MAXBBSIZE for $ZU(163)
STC1049;08/18/06 Steve Clay, Fix RemoteCacheTempDir macro
KMK484 ;08/01/06 Keith Knowles.  Define USELOST.
STC988 ;05/05/06 Steve Clay, Improve performance of retrieving the temp work directory
SAP584 ;05/01/06 Steve Pettibone, map rMAP
STC964 ;01/30/06 Steve Clay, Fix possible loss of data during shutdown
JO1908 ;8/21/05 Jeffrey Orlin, add $$$USEU2 as bit #30 in $zversion(0)
SML592 ;6/07/05 Simon Li, Use DEFAULTFETCH macro for default fetch routine to
       ;         initialize Row to null string.
SML562 ;05/04/05 Simon Li, Support compatibility for remote 5.0 server/client.
SML556 ;04/26/05  Simon Li, define backup system globals.
HYY1034 ;01/07/5  Huayong Yang, add GotoUpperErrTrap
HYY828 ;11/13/03  Huayong Yang, add macros for sorting and concurrent restore
LFT1135;10/07/03  Laura Tillem, additions for support of ^DATABASE
STC471 ;03/20/03  Steve Clay, move to %sySystem
STC421 ;01/13/03  Steve Clay, Added rINDEX defs
LFT986 ;09/23/02  Laura Tillem, add USETTYHASH and turn it on
HYY691 ;08/28/02  Huayong Yang, define SFNUNDEF as $zu(40,0,41) instead of 255
LFT961 ;01/10/02  Laura Tillem, 2 level pidtab, turn USEDYNPIDTAB on
LFT965 ;01/10/02  Laura Tillem, 2 level ttyhash, turn USEDYNTTYHASH on
STC317 ;01/10/02  Steve CLay, Change definition of SYSUSECLUSTER
CLN043 ;01/10/02  Steve Clay, CLEANED
CFL427 ;01/05/01  Carlos Lopes, turn USEBIGDB and NEWINC on.
CFL373 ;12/19/00  Carlos Lopes, define NEWINC and USEBIGDB
LFT865 ;11/08/00  Laura Tillem, add ALLOWPERCENTS and ALLOWDOTS
LRS439 ;06/30/00  Lee Smith: turn on certain old feature codes
       ;          unconditionally until they can be purged
DAS280 ;06/29/99  Diane Steidler: add DDPGROUPS
STC200 ;02/26/99 Steve Clay: Remove Sit is macro, USEWDIJ definition
HYY210 ;10/21/98, Huayong Yang: default mapping of temp globals
HYY198 ;09/11/98, Huayong Yang, support unlimited database expansion
LRS252 ;08/17/98, Lee Smith, add DBMSNSP "temporary" DBMS feature code
HYY176 ;08/12/98, Huayong Yang, cpreconv changes (& change CACHESQL to
       ;          CACHELIB. and cachesql to cachelib.)  
HYY168 ;05/21/98, Huayong Yang, add NETMOREDCPDMN (allow more DCP daemons)
LRS218 ;03/30/98, Lee Smith, remove include of %site
JSL001 ;03/09/98, Huayong Yang, turn on NETWIDENAMESPACE as default
LRS181 ;09/23/97, Lee Smith, Cache' nomenclature changes 
       ;          also redefined RTNINGBL as .NOT.NORTNINGBL
JSL001 ;08/15/97, Jonathan Levinson, added NETWIDENAMESPACE
LFT477 ;08/01/97, Laura Tillem, added NOUSEUSTART
HYY101 ;06/24/97, Huayong Yang, routine name change (2nd ver)
JAO944 ;06/13/97, Jeffrey Orlin, added NOUSEROBJ macro
HYY097 ;06/12/97, Huayong Yang, routine name change
LRS169 ;05/14/97, Lee Smith, added NOFULLNLS
VVS030 ;03/22/97, Vlad Skaletsky, Added NOUSESQL (for start up routines)
DAS121 ;02/07/97, Diane Steidler, Added NETHARDEN
APJ028 ;08/27/96, Phil Johnson, Added NOGUICONFIG
AVB001 ;07/26/96, Edward Valenti, Added NOUSESLM option
DKA294 ;06/10/96, Keith Avery, Added NONEWZURETVAL option
EAV000 ;05/27/96, Edward Valenti, added RTNINGBL option
DKA294 ;04/22/96, Keith Avery, Changed basis for USECLUSTER definition
AFH218 ;05/01/96, Al Hammel, added NOUSEMACGLOBAL option
JAO838 ;02/27/96, Jeffrey Orlin, added NONETTRANSPROC option
JAO742 ;01/16/96, Keith Avery: Added USECLUSTER option
DKA280 ;10/23/95, Keith Avery: Added NONEWLICENSE
LRS094 ;10/06/95, Lee Smith: Add ZVERSION except for VAX
TR406 ;05/31/95, Vadim Goldin: Add NONAMESPACE
VGG173 ;05/01/95, Vadim Goldin: Add NOIMPRANGES
JAO652 ;03/03/94, Jeffrey Orlin: Add definition of SFN_UNDEF
LRS004 ;02/23/94, Keith Avery: Added definition of NOSETEXTRACT
DKA212 ;11/16/93, Keith Avery: Added NOUSENEWCOL
DKA210 ;10/15/93, Keith Avery: Implement NOLOCKTARGETS option 
DKA209 ;10/15/93, Keith Avery: Further changes for long names
SPJ927 ;9/10/93, Scott Jones: changes for long names
DPB124 ; 06/09/93 use ^mutil("ENVIRON") instead of ^FORENVIR
       ; 06/03/93, add NOLONGSTRINGS -- negativism parallels system code
       ;           also NOWILDCARDS for wild-card implicits
#endif  /*=====================End Maintenance======================*/
  
#include %sySite
#include %sySt     ; DKA294         
#define	USELOST				; KMK484
#undef  USEGCNT
#define USEGOFF
#define ALLOCGVEC
#define USEDIRCACHE
#define NETNEWHASH
#define ALLOWPERCENTS 1
#define ALLOWDOTS 1
#define ZU55 1
#define FORKNETDMN
#define ZVERSION
  
#define HASHLOCK
#define GCOLRULE  ; JAO554 added. On for ux, vms, pc and single-pc
                 #;JAO652+ HYY691
                 #; SFNUNDEF and SFNMAX have the same value
#define SFNUNDEF $zu(40,0,41)
                 #;JAO652-
  
#define CACHENAMES 
  
#if 1    ; DPB124+
  
#if 0   /*======================Documentation=======================*/
       ; $$$ENVOPTION(NOWILDCARDS) (e.g.) does the following:
  
       ;    At compile time, the node ^mutil("ENVIRON") is examined.
  
       ;    NOWILDCARDS is always defined:
  
       ;         to 0 if ^mutil("ENVIRON","NOWILDCARDS") is undefined,
       ;         to 1 if ^mutil("ENVIRON","NOWILDCARDS") is defined
#endif  /*====================End Documentation=====================*/
  
#define ENVNODE $name(^mutil("ENVIRON"))
#define ENVOPTION(%X) ##continue
#if $D(^mutil("ENVIRON","%X")) ##continue
#define %X 1 ##continue
#else ##continue
#define %X 0 ##continue
#endif
  
#define DDPGROUPS 1
 #define NETWIDENAMESPACE 1
 #define NETMOREDCPDMN 1
 $$$ENVOPTION(NOUSESQL)
 $$$ENVOPTION(NONETHARDEN)
 $$$ENVOPTION(NOGUICONFIG)
 #define RTNINGBL 1
 $$$ENVOPTION(NOUSESLM)
 $$$ENVOPTION(NONETTRANSPROC)
 $$$ENVOPTION(NOWILDCARDS)
 $$$ENVOPTION(NOLONGSTRINGS)
 $$$ENVOPTION(NOLONGNAMES)
 $$$ENVOPTION(NOLOCKTARGETS)
 $$$ENVOPTION(NOUSENEWCOL)
 $$$ENVOPTION(NOSETEXTRACT)
 $$$ENVOPTION(NOIMPRANGES)
 $$$ENVOPTION(NONAMESPACE)
 $$$ENVOPTION(NONEWLICENSE)
 $$$ENVOPTION(NOUSEMACGLOBAL)
 $$$ENVOPTION(NONEWZURETVAL)
 $$$ENVOPTION(NOUSEUSTART)
 #define USECLUSTER 1
 #if $$$USECLUSTER
#if 0 ;STC317+
 #define SYSUSECLUSTER +$$$STENQWDRECOVERY
#else ;STC317=
 #define SYSUSECLUSTER $S($ZBITGET($ZVERSION(0),2):$V($ZU(40,2,136),-2,4),1:0)
#endif ;STC317-
 #else   ; $$$USECLUSTER
 #define SYSUSECLUSTER 0
 #endif
 $$$ENVOPTION(NOFULLNLS)
 #define DBMSNSP 1
 $$$ENVOPTION(NOAUTODBEXP)
 #define NEWINC          1
 #define USEBIGDB        1
 #define USEDYNTTYHASH   1
 #define USETTYHASH      1

#endif   ; DPB124-
  
#if $$$NOLONGNAMES ; DKA209+
#define GCMAJVER 7
#define NEWTOKVER 8
#else
#define GCMAJVER 8
#define NEWTOKVER 8
#endif             ; DKA209-
#define OBJNAME "rOBJ"
#define MAPNAME "rMAP"
#define INCNAME "rINC"
#define MACNAME "rMAC"
#define ROUTINEINDEXNAME "rINDEX"
#define INCSAVENAME "rINCSAVE"
#define MACSAVENAME "rMACSAVE"
#define OBJGLO "^rOBJ"
#define INCGLO "^rINC"
#define MACGLO "^rMAC"
#define ROUTINEINDEXGLO "^rINDEX"
#define INCSAVEGLO "^rINCSAVE"
#define MACSAVEGLO "^rMACSAVE"
#define OBJNAMB rOBJ
#define INCNAMB rINC
#define MACNAMB rMAC
#define ROUTINEINDEXNAMEB rINDEX
#define INCSAVENAMB rINCSAVE
#define MACSAVENAMB rMACSAVE
#ifdef  CACHENAMES ; LRS181+ 
#define LCPRODNAME      "Cache" 
#define UCPRODNAME      "CACHE" 
#define LCFILENAME      "cache" 
#define UCFILENAME      "CACHE" 
#define MGRDATASET      "CACHESYS" 
#define SQLDATASET      "CACHELIB"
#define SQLDSDIR        "cachelib"
#define TMPDATASET      "CACHETEMP"
#define TMPDSDIR        "cachetemp"
#define CACHEDSDIR    "cache"
#else 
#define LCPRODNAME      "Open M" 
#define UCPRODNAME      "OPEN M" 
#define LCFILENAME      "openm" 
#define UCFILENAME      "OPENM" 
#define MGRDATASET      "SYS$M" 
#endif   ; LRS181- 
  
#;HYY828+
#;return mnumcpu value
#define NUMCPU	$System.Util.NumberOfCPUs()
#; %db can be either directory name or sfn
#define DBMAXSIZ(%db)	$p($zu(49,%db),",",6)
#define DBBLKSIZ(%db)	$p($zu(49,%db),",",2)
								#;HYY1347+
	#; given the sfn of a database, return its directory path
#define	SFNtoDIR(%sfn)	$p($zu(49,%sfn,3),"^",2)
								#;HYY1347-
#;HYY828-
  
#;LFT1135+
#define OK 1
#define NOTOK 0
#define ISERR(%x) ('%x)
#;LFT1135-
  
								#;HYY1034+
#; for 5.1 and up (cf. "zq 1 g @$zt" in 5.0 and earlier)
#define GotoUpperErrTrap	ztrap $ze
								#;HYY1034-
#;SML556+
#define	BACKUPDBLISTGLO	^SYS("BACKUPDB")
#define	BACKUPDBLIST(%db)	^SYS("BACKUPDB",%db)
#define	BACKUPHISTORYGLO	^SYS("BUHISTORY")
#define	BACKUPHISTORY(%i)	^SYS("BUHISTORY",%i)
#define	BACKUPHISTORYDATA(%i,%d)	^SYS("BUHISTORY",%i,%d)
#define	BACKUPTASKGLO	^SYS("BACKUPTASK")
#define	BACKUPTASK(%db)	^SYS("BACKUPTASK",%db)
#define	BACKUPTASKDATA(%db,%d)	^SYS("BACKUPTASK",%db,%d)
#define	DH2INTEGER(%h)	(+%h*1000000+$p(%h,",",2))
#;SML1052+
#define DHGetDate(%h)   (%h\1000000)
#define DHGetTime(%h)   (%h#1000000)
#define DINTEGER2H(%h)  ((%h\1000000)_","_(%h#1000000))
#;SML1052-
#;SML556-
#;SML562+
#;Handle old version 5.2 location also
#define GetBinDirectory $s($$$ISVMS:$ZU(12,"[-.bin]"),$$$ISUNIX:$ZU(12,"../bin"),1:$ZU(12,"..\bin"))
#define	RemoteCacheTempDir(%s)	$g(^|"^"_%s_"^CACHESYS"|%SYS("CacheTempDir"),$g(^|"^"_%s_"^CACHESYS"|%SYS("tmpdir")))
#define	RemoteCacheSysDir(%s)	^|"^"_%s_"^CACHESYS"|%SYS("sysdir")
#define	SYSCacheSysDir			^%SYS("sysdir")
#define	SYSCacheBinDir			^%SYS("bindir")
#define	SYSCacheTempDir			^%SYS("CacheTempDir")
#define	SYSCacheDocDir			^%SYS("docdir")
#define	SYSTempDir			^%SYS("TempDir")
#;SML562-
#;SML1265+
#define ISCQUERYTEMP	^||%ISCQueryTemp
#define	DEFAULTFETCHPPG   ##continue
 s d=$p(qHandle,"^",2),i=$p(qHandle,"^",1),Row="",d=$Order($$$ISCQUERYTEMP(i,d),1,Row)  ##continue
 If d="" { s AtEnd=1 } else { s qHandle=i_"^"_d }
#;SML1265-
#;JO1908+
#define USEU2 $ZBITGET($ZVERSION(0),30)
#;JO1908- 
#;Values to pass to $zu(9)
#define	MALERT	1 /* broadcast and log message*/
#define MALERTONLY 2	/* broadcast message*/
#define MVMSG	3	/* message goes to mv.log */
#define MINFO   0  /* Informational message */
#define MWARN   1  /* Warning */
#define MSEVERE 2  /* Severe error */
#define MFATAL  3  /* Fatal */
 
#;The following macros log to the console log file 
#define InfoMsg(%Message)   d $zu(9,"",%Message,0,$$$MINFO)
#define WarnMsg(%Message)   d $zu(9,"",%Message,$$$MALERT,$$$MWARN)
#define SevereMsg(%Message) d $zu(9,"",%Message,$$$MALERT,$$$MSEVERE)
#define FatalMsg(%Message)  d $zu(9,"",%Message,$$$MALERT,$$$MFATAL)

#;The following macros log to the console log file, and to %ETN 
#define InfoError(%Error)   d $zu(9,"","Error: "_%Error,0,$$$MINFO),BACK^%ETN
#define WarnError(%Error)   d $zu(9,"","Error: "_%Error,$$$MALERT,$$$MWARN),BACK^%ETN
#define SevereError(%Error) d $zu(9,"","Error: "_%Error,$$$MALERT,$$$MSEVERE),BACK^%ETN
#define FatalError(%Error)  d $zu(9,"","Error: "_%Error,$$$MALERT,$$$MFATAL),BACK^%ETN

#;The following macros log to the console.log file, %ETN, terminal, and then may do other stuff.
#define SevereErrorConsole(%Error) s %Msg001="Error: "_%Error_" - Logins are disabled" w:('$$$ISWINDOWS) !,%Msg001 d $zu(9,"",%Msg001,$$$MALERT,$$$MSEVERE),BACK^%ETN
#define FatalErrorLoginDisabled(%Error)  s ^%SYS("STARTUPERROR")=%Error s %Msg001="Error: "_%Error_" - Logins are disabled" w:('$$$ISWINDOWS) !,%Msg001 d $zu(9,"",%Msg001,$$$MALERT,$$$MFATAL),BACK^%ETN,$zu(4,$j) halt
#;Return an error code of 7 means force it down on VMS to release shared memory. We reset the CPF
#;file so that it is read in again on next startup to make sure that the ^CONFIG global
#;and the CPF objects are reformed.
#define FatalErrorShutdown(%Error)  s ^%SYS("STARTUPERROR")=%Error try { d ##Class(Config.CPF).Reset() } catch {} s %Msg001="Error: "_%Error_" - Shutting down the system" w:('$$$ISWINDOWS) !,%Msg001 d $zu(9,"",%Msg001,$$$MALERT,$$$MFATAL),BACK^%ETN i '$$$ISVMS {d STARTUPSHUTDOWN^SHUTDOWN} d $zu(4,$j,7)
#;The following is used by network activation to log network errors
#define NetError(%Error) s ^NET("ERR",$o(^NET("ERR",""),-1)+1)=%Error
#define ConfigName $p($zu(86),"*",2)
#;Value to pass to $zu(163)
#define MAXBBSZ (2**31)
								#;HYY1600+
#; Given a remsysid (%sysid), return ECP system # or 0 (for local or mirror) 
#define	GETECPSYSID(%sysid) $zu(34,22,%sysid)
#; Given a system # (%sysid), return its value with the jobid type bit (to
#; indicate the associated jobid value is really a pid value)
#define	SETPIDBITINSYSID(%sysid) $zu(34,23,%sysid)
								#;HYY1600-
								#;JO2397+
#define	USEDSONLY $ZBITGET($ZVERSION(0),46)
#define USEUNICODE $zbitget($zversion(0),1)
								#;JO2397-
#;The lock used to lock the namespace table during activation and reading it
#define NamespaceTableLock NamespaceTableLock

#;SML1802 ; macro to tell the different of two $H/$ZTS format string.
#define	HTIMEDIFF(%end,%beg) ((%end-%beg)*86400+$p(%end,",",2)-$p(%beg,",",2))

#;used to kill a root level global node when the process has the kill disabled switch set
#define KillRootNode(%Global) Try { s zZzZz1245=$SYSTEM.Process.GlobalKillDisabled(0) Kill %Global i zZzZz1245 {d $SYSTEM.Process.GlobalKillDisabled(1)} } catch { i $d(zZzZz1245),zZzZz1245 { d $SYSTEM.Process.GlobalKillDisabled(1) } ztrap $ze }
#endif   ;#ifndef sySysteminc