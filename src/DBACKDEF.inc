ROUTINE DBACKDEF [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;HYY1607 12/10/10 Huayong Yang, add macros related to GFFORCEFULBK
#;JO1984  2/15/06 Jeffrey Orlin, change incbkpid to incbkjobid and change
#;                the GETincbkjobid stub to return our JOBID ($zu(61,30))
#;SML579  5/25/05 Simon Li, Force a full backup if backup operation is
#;               interrupted in a state that full backup is needed next time.
#;CFL284   ; 01/18/01, Carlos Lopes: added GETGFNOBACKUP
#;LRS218   ; 04/02/98, Lee Smith: change include %site to SITE
#;STC149   ; 08/28/97, Steve Clay: Change $ZU(15) call to $zu(12)
#;DAH001   ; 04/30/96, David Holbrook: Support both CHUI and GUI Backups
#;DKA187   ; 08/05/93, Keith Avery: Commonized for AlphaVMS.
#;DPB144   ; 07/15/93, Dan Smith. Removed tabs.
#;JAO580   ; 06/10/93, Jeffrey Orlin. Added functions to work with
#;         ;           incbkpid and to define the size of the overhead
#;         ;           section in each label block (the $ZU(52) functions
#;         ;           return a pointer to the data in the block. Subtract
#;         ;           the overhead to find the start of the block.
#;DPB107   ; 04/13/93, Dan Smith -- initial creation
#endif  /*=====================End Maintenance======================*/
  
#ifndef DBACK
#define DBACK
 
#if 1   ; CFL284+
#include SYSTEM
#endif  ; CFL284-
#include SITE      ;redundant, mainline should explicitly include for clarity
#include ST
  
         ; #define STUB
         ; #define STUBSW
#if 0
#define INSTRUMENT
#endif
 
#ifdef INSTRUMENT
#define SHOW ($D(^ZDPB107)'=0)
#endif
  
#if 0   /*======================Documentation=======================*/
         ; As of 04/15/93:
         ;                UX  VAX
         ;     iornone  = 0   0     activemap  = INC = 3
         ;     iorclear = 1   1     scratchmap = IND = 4
         ;     iordelete= -   2     recordmap  = INE = 5
         ;     iorusedb = 2   3     cummap     = INF = 6
         ;     iorcntbits=3   4     
#endif  /*====================End Documentation=====================*/
  
  
 #define STmapcum           0
 #define STmaprecord        1
 #define STmapscratch       2
 #define STmapactive        3
  
 #define STiornone          0
 #define STiorclear         1
 #define STiorusedb         2
 #define STiorcntbits       3
 #define STiordelete        1
  
#define DKCANON(%D) $$ZU(12,%D)
#if 1   ;STC200+
#define IOCANON(%D) $s($$$ISVMS:$$ZU(12,%D,1),1:$$ZU(12,%D))    
#endif  ;STC200-         
         ;These work in conjunction with the site-dependent $$INLOGOR extrinsic
         ;$$$DAT used with $$$STiorusedb, value is ignored.
  
#define INLOGOR  31
#define INC      $$$STmapactive
#define IND      $$$STmapscratch
#define INE      $$$STmaprecord
#define INF      $$$STmapcum
#define DAT      $$$STmapactive
  
  
#if 0   /*======================Documentation=======================*/
         ;MULTIVOLUME = environment that allows multivolume databases
         ;zu0args = number of arguments to $ZU(0) including the 0
#endif  /*====================End Documentation=====================*/
  
#define MULTIVOLUME
#define VOLUMES(%DIR) (+$P($ZU(49,%DIR),",",15))
#define zu0args 13
  
#if 0   /*======================Documentation=======================*/
         ;DISMOUNTABLE = environment in which volumes can and should be
         ;               dismounted during restore
#endif  /*====================End Documentation=====================*/
  
  
#ifdef STUB
  
#define  SETinbp(%VAL)       W !,"Pretending to set inbp to ",%VAL
#define  SETrinbp(%VAL)      W !,"Pretending to set rinbp to ",%VAL
#define  SETroutbp(%VAL)     W !,"Pretending to set routbp to ",%VAL
#define  SEToutbp(%VAL)      W !,"Pretending to set outbp to ",%VAL
	#; ;JO1984+
#define  JOBID  $ZU(61,30,$ZU(61))  ;our jobid
         ; JAO580+       
#define  SETincbkjobid(%VAL)  W !,"Prending to set incrkpid to ",%VAL
#define  GETincbkjobid   $$$JOBID  ; Return us so we clear this...
	#; ;JO1984-
#endif   ; STUB
  
#if 0   /*======================Documentation=======================*/
         ; Define a carrage return line feed  and  beep string
         ; in case  that some platform does not like $C(13,10)
         ; and $C(7). These are used to construct strings that
         ; can be displayed by both GUI and CHUI.
#endif  /*====================End Documentation=====================*/
#define  CRLF   $C(13,10)
#define  BEEP   $C(7)
 
#if $$$NEWINC   ; CFL284+
#if 0   /*======================Documentation=======================*/
 ; Define MACRO for getting GFNOBACKUP
#endif  /*====================End Documentation=====================*/
#if 0  ;SML579+
#define GETGFNOBACKUP(%D)       $zu(52,8,%D)
#else  ;SML579=
#define GETGFNOBACKUP(%D)       ($zu(52,8,%D)+$zu(52,9,%D))
#endif ;SML579-
								#;HYY1607+
#; Turn on or off GFFORCEFULBK flag for DB %dir
#define	GETGFFORCEFULBK(%dir)	$zu(52,9,%dir)
#define	SETGFFORCEFULBK(%dir)	$zu(52,9,%dir,1)
#define	CLRGFFORCEFULBK(%dir)	$zu(52,9,%dir,0)
								#;HYY1607-
#endif          ; CFL284-
 
#endif   ; ifdef DBACK