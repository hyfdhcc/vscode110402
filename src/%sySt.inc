ROUTINE %sySt [Type=INC]
#ifndef  %syStinc
#define %syStinc
#;       ST - Defines for various important locations
  
#if 0   /*=======================Maintenance========================*/
#;SJ2964   4/11/14 Scott Jones, improve GLOREC
#;SML1457  2/15/12 Simon Li, Fix COS codes to get global vector address.
#;HYY1725 01/19/12 Huayong Yang, add gfowner-related macros	
#;CDS1966 06/14/11 Chuck Sorenson, add rtncache entries
#;JPL1355 12/22/10 Jeffrey Orlin, Add $$$STnextfreesfn to return High 
#;                 Water Mark to SFN to avoid looping through all 
#;                 SFNMAX (16000) entries. 
#;SML1183 12/25/09 Simon Li, Remove Legacy Network codes.
STC1605 ;06/02/09, Set max journal file size to 4079
JO2141  ;05/06/09 Jeffrey Orlin, remove STGFIMPL, as GFIMPL bit was removed
RJW1645 ;01/11/09 Ron Watt, Expose MINBBSZ and MAXBBSZ in $zu(40,0) 
HYY1416 ;09/17/08 Huayong Yang, remove macros related to tsnumkilljrn
HYY1347 ;09/20/07 Huayong Yang, add macros related to psortsize & psortchunks
HYY1312 ;04/06/07 Huayong Yang, add STjrnencoff
HYY1248 ;08/15/06 Huayong Yang, add STjrnvermin
JO2047  ;06/16/06 Jeffrey Orlin, add STGFSPRIVATE and STgstate as glovec offsets
LRS1039 ;05/09/06 Lee Smith, change STDIRLEN to use new $zu(40,0,78)
JO1984 ;02/15/06 Jeffrey Orlin, remove $$$STSW10, $$$SVSW10, $$$GETSW10 and
       ;     $$$SETSW10. Change incbkpid to incbkjobid in STincbkpid,
       ;         GETincbkpid and SETincbkpid. Add JOBID as this process'
       ;         jobid for use with SETincbkjobid/GETincbkjobid.
LFT1479;03/22/06 Laura Tillem, add STnsdsmhost
JO1939 ;06/23/05 Jeffrey Orlin, remove STMTLBL
HYY1084 ;06/02/5 Huayong Yang, add $$$SHDWCVTENDIAN
JO1844 ;12/03/04 Jeffrey Orlin, add $$$USEPRIVATEGLOBALS (true/false)
PWC936 ;12/02/04 Peter Cudhea, use $System.Util.GetSwitch etc.
HYY989 ;09/29/04 Huayong Yang, add STcurgmhpages and GETCURGMHPAGES
SML467 ;08/03/04 Simon Li, Cache DLL support.
STC471 ;08/19/03, Steve Clay rename to %sySt
PWC718 ;12/10/02, Peter Cudhea-Pierce, Handle wraparound in GLOREC utility
PWC637 ;05/22/02 Peter Cudhea-Pierce, add STOldNetLockSysBase
STC347 ;05/17/02 Steve Clay, remove UIC and CURPRI
DAS403 ;05/02/02 Diane Steidler, add GLOREC fields
SML198 ;04/12/02 Simon Li, Support DDM display client's system name in ^LOCKTAB.
CFL509 ;04/24/01 Carlos Lopes, fix SETincbkpid and GETincbkpid
STC271 ;04/23/01 Steve Clay, Add buffer display
HYY478 ;04/10/01 Huayong Yang, add STjrnmaxsiz and STjrnblksiz
CFL478 ;03/20/01 Carlos Lopes, add STgbuffcnt
DAS341 ;01/10/01 Diane Steidler, add STguidaddress 
CFL422 ;12/27/00 Carlos Lopes, add STgbdb0off
LFT863 ;11/26/00 Laura Tillem, add STgfblksinvol and STszblksinvol
JO1244 ;07/19/00 Jeffrey Orlin, add STsfnundef
JO1243 ;07/18/00 Jeffrey Orlin, add STGFSPARSEDB
RAM366 ;07/18/00 Jeffrey Orlin, add STGFNOBACKUP
JO1160 ;07/18/00 Jeffrey Orlin, add STGFNOJRN
LFT806 ;03/23/00 Laura Tillem, add STbigdb
DAS309 ;10/20/99 Diane Steidler, use correct length for _ddpgroups
DAS280 ;06/29/99 Diane Steidler, add STDDPGroups
LFT717 ;04/23/99 Laura Tillem, add STtsnumkilljrn
DAS263 ;04/06/99 Diane Steidler, add STmaxudppktsiz, SZNTBUF and SZNBOV
STC200 ;02/26/99 Steve Clay, Removed site is macro, cleaned
HYY234 ;12/11/98 Huayong Yang, $zu(40,0,28) as JRNVERSION
LFT632 ;11/12/98 Laura Tillem, put back STUNAME
HYY172 ;06/12/98 Huayong Yang, new parameter to set number of DCP daemons
       ;         the client asks the server for
HYY168 ;05/20/98 Huayong Yang, allow more DCP daemons
HYY167 ;05/04/98 Huayong Yang, make UDP receive/send buffer size configurable
LRS194 ;10/29/97 Lee Smith, add STshmoff, STmaxpid, STpidtab, and STaltpid
LFT477 ;08/04/97 Laura Tillem, add STpswitch and STustart
JAO949 ;07/02/97 Jeffrey Orlin, reduce cluster mount states from 3 to 2
LFT444 ;03/17/97 Laura Tillem, fix $$$STPV
NGA033 ;03/27/97 Neil Alton, fixed $$$SETbfcnt
PWC394 ;09/19/96 Laura Tillem, add STnnroutines
LFT381 ;08/01/96 Laura Tillem, add STpidoff
LRS124 ;03/20/96 Lee Smith, change $$$MGRNSP to be "%SYS"
DKA293 ;01/16/95 Keith Avery, added STENQWDRECOVERY for Cluster support
DKA290 ;11/22/95 Keith Avery, changed #include %site to #include SITE
AHS171 ;08/11/95 Amir Shokrollahi, added $$$SETbfcnt
VGG195 ;06/16/95 Vadim Goldin, added $$$MGRNSP, cleaned up old features
JAO749 ;12/19/94 Jeffrey Orlin, added $$$STgjobquota
JAO742 ;12/12/94 Jeffrey Orlin, changes for cluster support
VGG146 ;07/27/94 Vadim Goldin, added netconntab, maxnpconnection,
 ;                        portstats and connection
PWC280 ;03/29/94 Peter Cudhea-Pierce, fixed pjobquota
PWC279 ;03/10/94 Peter Cudhea-Pierce, added pjobquota, fixed altpid
       ;         linkdir, and ttyhash to use system-independent offsets
DKA217 ;02/10/94 Keith Avery, changed STMGDIR to user $ZU(12)
CLEAN  ;03/10/94 Peter Cudhea-Pierce, cleaned out old changes
PWC259 ;10/27/93 Peter Cudhea-Pierce, added $$$STnnpasswd
PWC250 ;09/16/93 Peter Cudhea-Pierce, added $$$STlksysdiv
DKA187 ;08/05/93 Keith Avery: Commonized for AlphaVMS
DPB155 ;07/27/93 Dan Smith. Add $$$STDIRLEN and $$$STMTDEVNML.  These are
       ;         currently hardcoded constants, but putting them here
       ;         avoids constants elsewhere.  Hopefully someday they'll be
       ;         available through $ZU(40) calls.
DPB151 ;07/21/93 Dan Smith Add $$$STSZSTR, STGBIG, STAUINT1, STAUINT2.  Add
       ;         #show comment line.
JAO580 ;06/10/93 Jeffrey Orlin, add incbkpid for incremental backup.
       ;         Also added JAO580 definitions for GETincbkpid,
       ;         SETincbkpid and INCBKHEADSZ
DPB107 ;04/13/93 Add definitions used by concurrent backup
       ;         Add duplicate SV definitions named GET, with the
       ;         intention of revising all $$$SV references.  (SET and
       ;         GET are the naming conventions used now in %view).
DPB104 ;04/06/93 Add SVNNODE
DPB101 ;03/25/93 Add STILEN, -CPLEN, -PPLEN
       ;         change -PLEN from $ZU(40,0,1) to $ZU(40,0,4)
       ;         Commonize with PC by adding SITE dependency
       ;         Correct $ZU(40,2,11)+20 -> $ZU(40,2,11)+4*$$$STILEN,
       ;                 by introducing new macro $$$%STSYPWO
       ;         Conditionalize use of $ZU(40,2,72) on %STNO72
       ;            (transition mechanism for PC and 5.1)
BEB539 ;03/25/93 Ben Bishop.  Commonize $$$ST value from Site macro
RAM320 ;03/25/93 Keith Avery, Changes for Alpha/OSF
DPB098 ;03/18/93 Dan Smith, remove references to defunct $ZU(40) JRN's 
       ;                    add definition of $$$STREPTYP
PWC204 ;12/21/92 Peter Cudhea, Separate DCP daemons for each client system
PWC198 ;11/13/92 Peter Cudhea, added syspnt->nnpeer
PWC195 ;10/26/92 Peter Cudhea, added defines for recent CST entries
PJH054 ;02/07/91 PJ Hill.  Location of hash table for varname is now a
       ;         STNAMEOFF instead of a magic number.
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
DPB101 ;03/30/93, Dan Smith
       ;                     MAINTENANCE NOTE
       ;   $$$STJRN, -JRNNEW, -JRNNEW, -JRNPNT, -JRNLAST, -JRNIND
       ;   and the similarly-named %ST nodes are retained solely for
       ;   the PC and should be removed when flat-file journalling is
       ;   implemented.  Systems with flat-file journalling return 0 for
       ;   the associated $ZU functions.
  
       ;   $ZU(40,2,72) should be used for REPTYP when available.
       ;        For now, SitePC defines %STNO72,
       ;        %STNO72 may be hand-defined for a /util51 version,
       ;        %STNO72 conditionalizes definition of $$$STREPTYP
       ;        Remove this mechanism when $ZU(40,2,72) is available
       ;        on all platforms.
#endif  /*====================End Documentation=====================*/
  
#include %sySite
  
 #define STpswitch          $ZU(40,1,29)
 #define STustart           $ZU(40,2,115)
  
 #define ST                 $$$Site
  
 #define STILEN             $ZU(40,0,1)
 #define STPPLEN            $ZU(40,0,2)
 #define STCPLEN            $ZU(40,0,3)
 #define STPLEN             $ZU(40,0,4)
  
  
#if 0   /*======================Documentation=======================*/
DPB151 ;$$$STSZSTR    Maximum possible length of a string.
       ;              Currently 32767.  If gets a <FUNCTION> error,
       ;              it's a pre-long-string system and length is 510.
       ;$$$STGBIG     Threshold at which a string becomes a "big string."
       ;              Currently 757.  Affects format in which string is
       ;              stored in a global.
       ;$$$STAUINT1   Size of an AUINT1 = a UINT that's guaranteed to hold
       ;              at least one byte and guaranteed to be atomic for
       ;              memory updates.  Currently only relevant for Alpha.
       ;              If it gets a <FUNCTION> error, it's a pre-6.0 system
       ;              and value could be taken as 1.
       ;$$$STAUINT2   Size of an AUINT2, guaranteed atomic and >= 2 bytes 
DPB155 ;$$$STDIRLEN   Maximum bytes in directory name for a global vector.
       ;              Directory names _should_ get limited to this size
       ;              in utilities such as MSU.
       ;$$$STMTDEVNML Length of a magtape device name in the MTDEV table.
#endif  /*====================End Documentation=====================*/
  
 #define STSZSTR            $ZU(40,0,20)
 #define STGBIG             $ZU(40,0,21)
 #define STAUINT1           $ZU(40,0,22)
 #define STAUINT2           $ZU(40,0,23)
  
 #define STDIRLEN           $ZU(40,0,78)
 #define STMTDEVNML         32
  
  
 #define STPV               $ZU(67,2,$J)
 #define STPVPID(%x)        $ZU(67,2,%x)
 #define STMGDIR            $ZU(12)
 #define MGRNSP             "%SYS"
 #define STUNAME            $ZU(40,1,19)
 #;SML1457+
 #define STGVEC             $V($ZU(40,1,11),-1,"J")
  
 #define STGV0              $V($ZU(40,1,12),-1,"J")
 #;SML1457-
 #define STDIR              ($$$STPV+$ZU(40,1,13))
 #define STALLOC            ($$$STPV+$ZU(40,1,0))
  
  
       ; BEGIN defs retained for PC.  Delete when PC gets flat-file jr
 #define STJRN              $ZU(40,2,2)
 #define STJRNNEW           $ZU(40,2,3)
 #define STJRNPNT           $ZU(40,2,4)
 #define STJRNLAST          $ZU(40,2,5)
 #define STJRNUIC           $ZU(40,2,6)
 #define STJRNIND           $ZU(40,2,8)
       ; END defs retained for PC.
 #define STJRNTYP           $ZU(40,2,7)
 #define STREPTYP           $ZU(40,2,72)
 #define STLOCKTAB          $ZU(40,2,16)
 #define STDEV              $ZU(40,1,17)
 #define STVBUF             $ZU(40,1,5)
 #define STPRIN             $ZU(40,1,18)
 #define STROU              $ZU(40,1,1)
 #define STSYPNTR           $ZU(40,2,11)
 #define STBDB0             $V($ZU(40,2,21),-2,"S")
 #define %STSYPWO(%I)       $V($$$STSYPNTR+($$$STPLEN*%I),-2,"S")
 #define STGID              $$$%STSYPWO(3)
  
 ;#define STUIC              $ZU(40,1,3)  ;STC347
 #define STUICTAB           $V($ZU(40,2,20),-2,"P")
 #define STGPRIBAS          $ZU(40,2,14)
 #define STGPRILOW          $ZU(40,2,12)
 #define STGPRICH           $ZU(40,2,15)
 #define STGPRIHIGH         $ZU(40,2,13)
 #define STGPROTDEF         $ZU(40,2,18)
 #define STPRIBAS           $ZU(40,1,8)
 ;#define STPRICUR           $ZU(40,1,10)  ;STC347
 #define STPRIUSR           $ZU(40,1,9)
 #define STBUFCNT           $ZU(40,2,17)
#if 1 ;STC271+
 #define STBUFFERS          $ZU(40,2,135)
#endif ;STC271-
 #define STRBUFCNT          $ZU(40,2,26)
 #define STNUMRBUF          $ZU(40,2,26)
 #define STOP               $ZU(40,1,16)
 #define STPAP              $ZU(40,1,15)
 #define STSSP              $ZU(40,1,14)
 #define STPLINES           $ZU(40,1,6)
 #define STPOBJECT          $ZU(40,1,7)
 #define STNHASH            $V($ZU(40,2,22),-2,"P")
 #define STGIND             $$$%STSYPWO(4)
       ;1*4 in next is probably wrong
 #define STGT               $V($$$%STSYPWO(4)+2,-3,2)+1*4+$$$%STSYPWO(4)
 #define STNETREPA          $$$%STSYPWO(5)
 #define STFLAGSA           ($ZU(40,2,33)+$$$%STSYPWO(6))
 #define STPID              $ZU(40,1,4)
 #define STROUREF           $ZU(40,2,1)
 #define STPJOURN           $ZU(40,1,2)
 #define STVERSION          $ZU(40,2,23)
 #define STGARCUR           $ZU(40,2,25)
 #define STGARNEXT          $ZU(40,2,24)
 #define STMTBUFF           $ZU(40,1,20)
 #define STMTDEV            $ZU(40,2,28)
 #define STSFLAGS           $ZU(40,2,38)
#if 0   ;SML467+
 #define STLOGTAB           $V($ZU(40,2,39),-2,"P")
#else   ;SML467=
 #define STLOGTAB           $V($ZU(40,2,39),-2,"S")
#endif  ;SML467-
 #define STLOGENTRY         $ZU(40,0,16)
#if 0   ;SML467+
 #define STTRANSTAB         $V($ZU(40,2,40),-2,"P")
#else   ;SML467=
 #define STTRANSTAB         $V($ZU(40,2,40),-2,"S")
#endif  ;SML467-
 #define STENQWDRECOVERY    $ZU(40,2,95)
#if 1   ;STC200+
 #define STMTTYPE           $s($$$ISUNIX:$ZU(40,17,0),1:0)
 #define STMTINFO           $s($$$ISUNIX:$ZU(40,17,1),1:0)
#endif  ;STC200-
 #define STshmoff           $zu(40,0,25)
 #define STmaxpid           $v($zu(40,2,118),-2,4)
 #define STpidtab           $v($zu(40,2,119),-2,$$$STshmoff)
 #define STaltpid           $v($zu(40,2,47),-2,"S")
 #define STALTPID           $ZU(40,2,47)
 #define STTTYHASH          $ZU(40,2,48)
 #define STpjobquota        $ZU(40,1,23)
 #define STgjobquota        $ZU(40,2,96)
 #define STLINKDIR          $ZU(40,2,84)
 #define STlksysdiv         $ZU(40,0,24)
  
 ; gvec definitions
 #define STgsyi             $ZU(40,3,1)
 #define STgbdb             $ZU(40,3,2)
 #define STgbeg             $ZU(40,3,3)
 #define STgend             $ZU(40,3,4)
 #define STgnak             $ZU(40,3,5)
 #define STguic             $ZU(40,3,6)
 #define STgpro             $ZU(40,3,7)
 #define STgdat             $ZU(40,3,8)
 #define STglength          $ZU(40,3,9)
 #define STgtype            $ZU(40,3,10)
 #define STgnew             $ZU(40,3,11)
 #define STgpnt             $ZU(40,3,12)
 #define STglast            $ZU(40,3,13)
 #define STgtab             $ZU(40,3,16)
 #define STglastpnt         $ZU(40,3,18)
 #define STgdirpnt          $ZU(40,3,19)
 #define STgcollate         $ZU(40,3,20)
#if 1   ;JO2047+
 #define STgstate           $ZU(40,3,24)
 #define STGFSPRIVATE       $ZU(40,3,25)
#endif  ;JO2047-
 #define STindian           $ZU(40,0,0)
  
#if 0   /*======================Documentation=======================*/
DPB107 ; Definitions for concurrent backup (DBACK/DBACKA/DBREST)
       ; Non-VAX branch: new, intended-to-be-common definitions.
       ; VAX branch: current, different-but-equivalent.
       ; Remove the VAX branch when the VAX cst.c is brought into sync.
#endif  /*====================End Documentation=====================*/
  
  
 #define STincrbak          $ZU(40,2,77)
 #define STrinbp            $ZU(40,2,78)
 #define STroutbp           $ZU(40,2,79)
 #define STinbp             $ZU(40,2,80)
 #define SToutbp            $ZU(40,2,81)
 #define STbfcnt            $ZU(40,2,99)
    #; ;JO1984+
 #define STincbkjobid       $ZU(40,2,82)
    #; ;JO1984-
    
 #define STdssys            $ZU(40,22,1)
 #define STdslen            $ZU(40,22,3)
 #define STdsnam            $ZU(40,22,4)
      
 ; MISC ;
 #define STNAMEOFF          $ZU(40,25,0)
 #define  STpidoff          $ZU(40,28,1)
 #define STMINBBSZ          $ZU(40,0,83)
 #define STMAXBBSZ          $ZU(40,0,84)
  
 ; GFSCON ;
 #define STGFOFFSET         $ZU(40,0,5)
 #define STBLTYPE           $ZU(40,0,6)
 #define STBLOFF            $ZU(40,0,7)
 #define STMAPLABEL         $ZU(40,0,8)
 #define STBLLNK            $ZU(40,0,9)
 #define STBLENGTH          $ZU(40,0,10)
 #define STGFPRIMVOL        $ZU(40,8,0)
 #define STGFNEXTVOL        $ZU(40,8,1)
 #define STGFREAD           $ZU(40,8,2)
 #define STGFNOMOUNT        $ZU(40,8,3)
 #define STGFDISMOUNT       $ZU(40,8,4)
 #define STGFREMOUNT        $ZU(40,8,5)
 #define STGFREPL           $ZU(40,8,7)
 #define STGFVOL            $ZU(40,8,8)
 #define STGFSKELETON       $ZU(40,8,9)
 #define STGFDISAIMPL       $ZU(40,8,15)
 #define STLBLAUTOMATIC     $ZU(40,8,16)
 #define STLBLEXPLICIT      $ZU(40,8,17)
 #define STGFNOJRN          $ZU(40,8,18)
 #define STGFNOBACKUP       $ZU(40,8,19)
 #define STGFSPARSEDB       $ZU(40,8,20)
 #define STgfformat         $ZU(40,5,10)
 #define STszformat         $ZU(40,4,10)
#if 1  ;LFT863+
 #define STgfmaxvol         $ZU(40,10,1)
 #define STszmaxvol         $ZU(40,9,1)
#endif ;LFT863-
 
#; RTNCACHE offsets  ;CDS1966
 #define STPCURRC			$ZU(40,1,60)
 #define STPRBUFNO			$ZU(40,1,61)
 #define STrcNUMBUF			$ZU(40,38,0)
 #define STrcBUFFTAB		$ZU(40,38,1)
 #define STrcLINES			$ZU(40,38,2)
 #define STrcLINBUFT		$ZU(40,38,3)
 #define STrcB1NLINES		$ZU(40,38,4)
 #define STrcB1LINES		$ZU(40,38,5)
  
  
#define  SVBUFCNT    $V($$$STBUFCNT,-2,$$$STILEN)
#define  SVLOCKTAB   $V($$$STLOCKTAB,-2,"C")
#define  SVNUMRBUF   $V($$$STNUMRBUF,-2,$$$STILEN)
#define  SVPRIBAS    $V($$$STPRIBAS,-1,$$$STILEN)
#if 0 ;PWC936+
#define  SVSWITCH    $V(0,-2,$$$STILEN)
#else     ;PWC936=
#define  SVSWITCH    $System.Util.GetSwitch()
#endif    ;PWC936-
  
#if 0   /*======================Documentation=======================*/
DPB107 ;GETBUFCNT, etc. are equivalents for the $$$SV's and are
       ;intended to replace them.  The naming style is that established
       ;by %view.inc.
  
       ;GET and SET definitions are added as needed and maintained
       ;in case-insensitive alphabetical order.
  
       ;"C" in SETinbp, rinbp, routbp, outbp is provisional
#endif  /*====================End Documentation=====================*/ 
  
#define  GETBUFCNT    $V($$$STBUFCNT,-2,$$$STILEN)
#define  GETLOCKTAB   $V($$$STLOCKTAB,-2,"C")
#define  GETNUMRBUF   $V($$$STNUMRBUF,-2,$$$STILEN)
#define  GETPRIBAS    $V($$$STPRIBAS,-1,$$$STILEN)
#if 0 ;PWC936+
#define  GETSWITCH    $V(0,-2,$$$STILEN)
#else     ;PWC936=
#define  GETSWITCH    $System.Util.GetSwitch()
#endif    ;PWC936-
  
    #; ;JO1984+
    #; JOBID is $J for non-USETID otherwise it is presqpnt->jobid
#define  JOBID  $ZU(61,30,$ZU(61))
    #; ;JO1984-
  
#define  SETinbp(%VAL)       V $$$STinbp:-2:"C":%VAL
    #; ;CFL509+, JO1984+
#define  SETincbkjobid(%VAL)   V $$$STincbkjobid:-2:4:%VAL
#define  GETincbkjobid         $V($$$STincbkjobid,-2,4)
    #; ;CFL509-, JO1984-
#define  SETrinbp(%VAL)      V $$$STrinbp:-2:"C":%VAL
#define  SETroutbp(%VAL)     V $$$STroutbp:-2:"C":%VAL
#if 0 ;PWC936+
#define  SETSWITCH(%VAL)     V 0:-2:$$$STILEN:%VAL
#else     ;PWC936=
#define  SETSWITCH(%VAL)     $System.Util.SetSwitch(%VAL)
#endif    ;PWC936-
#define  SEToutbp(%VAL)      V $$$SToutbp:-2:"C":%VAL
#define  SETbfcnt(%VAL)      V $$$STbfcnt:-2:4:%VAL 
  
       ;JAO580+
       ; INCBKHEADSZ is the # of bytes that the header on each internal
       ; block (dir header, volume label, end-of-set marker, etc) takes
       ; up. It must be kept in sync with the size of the label id # and
       ; IBID_STR/IBID_SIZE in incrbk.h. The $ZU(52) functions that return
       ; a pointer to a buffer return a pointer to the 1st piece of data
       ; in a buffer. Subtracting this value from that pointer gets you
       ; the address of the label id # if you are interested in it.
#define  INCBKHEADSZ    16  
  
#define STrcvbufsiz         $ZU(40,2,120)                     
#define STsndbufsiz         ($ZU(40,2,120)+4)
#define SETRCVBUF(%a)       V $$$STrcvbufsiz:-2:$$$STILEN:%a   
#define SETSNDBUF(%a)       V $$$STsndbufsiz:-2:$$$STILEN:%a           
#define STUJOBNUM           $ZU(40,2,114)
#; STUJOBNUM is either UJOBNUM or MOFF(UJOBNUM), depending on whether
#; MULTI_WRT_DMN is defined (bit 6 in $zversion(0))           
#define STujobnum           $S($ZBITGET($ZVERSION(0),6):$V($$$STUJOBNUM,-2,$$$STILEN),1:$$$STUJOBNUM)
#define STjrnver            $zu(40,0,28)
                                #;HYY1248+
#define STjrnvermin     $zu(40,0,81)
                                #;HYY1248-
                                #;HYY1312+
#define STjrnencoff     $zu(40,0,82)
                                #;HYY1312-
#;HYY478+
#;max size in MB, used by utilities.
#define jrnmaxsize          4079
#define STjrnmaxsiz            $zu(40,0,62)
#define STjrnblksiz            $zu(40,0,63)
#;HYY478-
#if 1    ;LFT806+
#define STbigdb $zbitget($zversion(0),21)  
#endif   ;LFT806-
#if 1   ;JO1244+
#define STsfnundef $ZU(40,0,41)
#endif  ;JO1244-
#; JPL1355+
#;STnextfreesfn is one more than the highest sfn used on
#; this system. Loops for 1...sfnmax should use this value 
#; rather than $$$STsfnundef or $$$SFNMAX (%sySystem.inc)
#define STnextfreesfn ($V($ZU(40,2,176),-2,4))
#; JPL1355-
#if 1   ;CFL422+
#define STgbdb0off $zu(40,2,128)
#endif  ;CFL422-
#; DAS341+
#define STguidaddress           $zu(40,2,133)
#define SETGUIDADDRESS(%a)      v $$$STguidaddress:-2:-6:%a
#define GETGUIDADDRESS          $v($$$STguidaddress,-2,-6)
#; DAS341-
#if 1   ;CFL478+
#define STgbuffcnt $zu(40,2,135)
#define GETGBUFFCNT(%a)                 $v(%a*$$$STILEN+$$$STgbuffcnt,-2,$$$STILEN)
#endif  ;CFL478-
#; DAS403+
#define STglorecordflags        $zu(40,2,134)
#define GETGLORECORDFLAGS       $v($$$STglorecordflags,-2,4)
#define STmaxglorecord          $zu(40,2,140)
#define GETMAXGLORECORD         $v($$$STmaxglorecord,-2,4)
#define STglonextslot           $zu(40,2,141)
#if 0 ;PWC718+
#define GETGLONEXTSLOT          $v($$$STglonextslot,-2,2)
#else ;PWC718=
#define GETGLONEXTSLOT          $v($$$STglonextslot,-2,4)
#endif ;PWC718-
#define STglorectab         $zu(40,2,142)
#define GETGLORECTAB            $v($$$STglorectab,-2,"C")
#define GETGLORECSIZE           $zu(40,41,0)
#; DAS403-
#define STOldNetLockSysBase     $zu(40,0,67)  /* PWC637 */
                                #;HYY989+
#define STcurgmhpages           $zu(40,2,150)
#define GETCURGMHPAGES          $v($$$STcurgmhpages,-2,$$$STILEN)
                                #;HYY989-
                                #;HYY1347+
    #; psortsize - process memory, in KBs, allocated for each sorted global
#define STpSortSize     $zu(40,1,31)
    #; GetpSortSize=0 by default, meaning 1MB (1024KB)
#define GetpSortSize        $v($$$STpSortSize,-1,4)
#define GetpSortSizeKB      $case($$$GetpSortSize,0:1024,:$$$GetpSortSize)
#define SetpSortSize(%s)    v $$$STpSortSize:-1:4:%s
    #; psortchunks - # of chunks (db blocks) in cachetemp used for sorting
#define STpSortChunks       $zu(40,1,55)
#define GetpSortChunks      $v($$$STpSortChunks,-1,4)
#define SetpSortChunks(%c)  v $$$STpSortChunks:-1:4:%c
                                #;HYY1347-
								#;HYY1725+
    #; gfowner[sfn] - exclusive write owner of an sfn (cf. dkownsfn())
#define STgfowner0	    $zu(40,2,92)
#define Getgfowner(%sfn)    $v(%sfn*4+$$$STgfowner0,-2,4)
								#;HYY1725-
                                #;JO1844-
#define USEPRIVATEGLOBALS $zbitget($zversion(0),34)
                                #;JO1844-
                                #;HYY1084+
#define SHDWCVTENDIAN   $zbitget($zversion(0),36)
                                #;HYY1084-
 
#endif ; #ifndef %syStinc