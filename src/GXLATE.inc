ROUTINE GXLATE [Type=INC]
#if 0   /*=======================Maintenance========================*/
EAV003 ;08/30/96 Edward Valenti, Add SLM and routine mapping
DXU001   ; 08/15/95, changed M/SQL to Open M
VGG197   ; 07/13/95, zu(90) calls to handle GIND table
TR406    ; 05/29/95, namespace implementation
VGG173   ; 02/06/95, changes due to implicit ranges
VGG158   ; 10/03/94, add GXLDEACT 
VGG143   ; 06/15/94, add GXLDUMIMP - implicit dest. for <PROTECT> error
DPB125   ; 06/04/93, Add convenience definitions for GXISREP, GXISIMP, GXISLOCK
#endif  /*=====================End Maintenance======================*/
  
 ; GXLATE include file
 ;
 ; Global structure in ^SYS is....
 ;
 ; ^SYS("GXLATE","SYS"...
 ;  For translation entries which are installed for the currently running Open M
 ; ^SYS("GXLATE","a/e"...
 ;  For translation entries which users have added or edited and which will
 ;   only be usable after Open M is shutdown and brought back up (mstop/mstart)
 ;
 ; ^SYS("GXLATE","a/e","PATHS",<Path Name>)= <Directory Set>^<Directory>
 ;  Defines one or more remote pathways to a specific namespace (directory)
 ;
 ; ^SYS("GXLATE","a/e","REPLS",<Replication Scheme Name>)= # of paths
 ;        1)=<Path Name#1>
 ;        2)=<Path Name#2>
 ;       ...
 ;        N)=<Path Name#N>
 ;         where N is maximum of ***
 ;  Defines replication schemes based on defined remote pathways
 ;
 ; ^SYS("GXLATE","a/e","TRANS",<Translation scheme name>)=
 ;       =<Replication Scheme>^<Path Name#1>^<Path Name#2>
 ;  Defines transalation schemes based on one replication scheme and two remote
 ;   paths.  The second remote path is tp determine the home machine for the
 ;   purposes of the LOCK command.
 ;
 ; ^SYS("GXLATE","a/e","GTRAN",<From Directory>,<Order #>)=
 ;       =<Globa1 Name Pattern> ^ <Translation Scheme Name>
 ;
  
#ifndef GXLATE
#define GXLATE
#if 1    ; DPB125+, traceability
#show
 ; GXLATE.INC DPB125 06/04/93
#noshow
#endif   ; DPB125-
  
  #define GXLTGLOSYS ^SYS("GXLATE","SYS")
  #define GXLTGLOAE ^SYS("GXLATE","a/e")
  #define GXLNUMENTS $ZU(90,0)
  #define GXLENTID(%d,%p) $ZU(90,0,%d,%p)
#if $$$NOIMPRANGES ;VGG173+
  #define GXLADDENT(%d,%p,%r,%i,%l) $ZU(90,0,%d,%p,%r,%i,%l)
  #define GXLNEXTENT(%d,%p) $ZU(90,1,%d,%p)
  #define GXLENTDIR(%n) $ZU(90,2,%n)
  #define GXLENTPAT(%n) $ZU(90,3,%n)
  #define GXLENTREP(%n) $ZU(90,4,%n)
  #define GXLENTIMP(%n) $ZU(90,5,%n)
  #define GXLENTLCK(%n) $ZU(90,6,%n)
  #define GXSLMENT(%n) $ZU(90,2,8,%n)
  #define GXSLMDATA(%n) $ZU(90,16,%n)
  #define GXSLMSUB(%n,%d) $ZU(90,17,%n,%d)
  #define GXSLMREPL(%n,%d) $ZU(90,18,%n,%d)
#else    ; VGG173=
  #define GXLDIRNUM(%d) $ZU(90,0,%d)
  #define GXLDIRSTR(%d) $ZU(90,1,%d)         
  #define GXLADDENT(%d,%p,%r1,%i1,%l1,%r2,%i2,%l2) $ZU(90,0,%d,%p,%r1,%i1,%l1,%r2,%i2,%l2)
  #define GXLNEXTENT(%d,%p) $ZU(90,1,%d,%p)
  #define GXLENTDIR(%n) $ZU(90,2,0,%n)
  #define GXLENTPAT(%n) $ZU(90,2,1,%n)
  #define GXLENTREP1(%n) $ZU(90,2,2,%n)
  #define GXLENTIMP1(%n) $ZU(90,2,3,%n)
  #define GXLENTLCK1(%n) $ZU(90,2,4,%n)
  #define GXLENTREP2(%n) $ZU(90,2,5,%n)
  #define GXLENTIMP2(%n) $ZU(90,2,6,%n)
  #define GXLENTLCK2(%n) $ZU(90,2,7,%n)
  #define GXSLMENT(%n) $ZU(90,2,8,%n)
  #define GXSLMDATA(%n) $ZU(90,16,%n)
  #define GXSLMSUB(%n,%d) $ZU(90,17,%n,%d)
  #define GXSLMREPL(%n,%d) $ZU(90,18,%n,%d)
#if 1    ;VGG197+
  #define GXLNUMTRG $ZU(90,5)
  #define GXLDSSYS(%n) $ZU(90,6,%n)
  #define GXLDSDIR(%n) $ZU(90,7,%n)
  #define GXLFINDTRG(%s,%d) $ZU(90,8,%s,%d)
  #define GXLADDTRG(%s,%d) $ZU(90,9,%s,%d)
#endif   ;VGG197-
#endif   VGG173-
#if '$$$NONAMESPACE ;TR406+
  #define GXLNUMNS $ZU(90,3,0)
  #define GXLADDNS(%n,%g,%r) $ZU(90,3,0,%n,%g,%r)
  #define GXLDEFGLO(%n) $ZU(90,3,1,%n)
  #define GXLDEFPROU(%n) $ZU(90,3,2,%n)
#endif   ;TR406-
#if 1    VGG143+
  #define GXLDUMIMP 255  
#endif   VGG143-
#if 1    VGG158+
  #define GXLDEACT $zu(90,-1)         
#endif   VGG158-
  
#if 0   /*======================Documentation=======================*/
  
         $$$GXLISREP(directory,name)
         $$$GXLISIMP(directory,name)
         $$$GXLISLCK(directory,name)
  
         evaluate to 1 if the global is replicated/implicited/lock-translated
         otherwise 0
  
         These might be done more cleanly as extrinsics; I'm doing them
         as macros to bypass issues about how to #include them.
#endif  /*====================End Documentation=====================*/
  
#if 1    ; DPB125+
#if $$$NOIMPRANGES ;VGG173+
#define GXLISREP(%d,%n) ($S($$$GXLNEXTENT(%d,%n):$$$GXLENTREP($$$GXLNEXTENT(%d,%n)),1:0)'=0)
#define GXLISIMP(%d,%n) ($S($$$GXLNEXTENT(%d,%n):$$$GXLENTIMP($$$GXLNEXTENT(%d,%n)),1:0)'=0)
#define GXLISLCK(%d,%n) ($S($$$GXLNEXTENT(%d,%n):$$$GXLENTLCK($$$GXLNEXTENT(%d,%n)),1:0)'=0)
#else    ;VGG173=
#define GXLISREP(%d,%n) ($S($$$GXLNEXTENT(%d,%n)>0:$$$GXLENTREP1($$$GXLNEXTENT(%d,%n)),$$$GXLNEXTENT(%d,%n)<0:$$$GXLENTREP2(-$$$GXLNEXTENT(%d,%n)),1:0)'=0)
#define GXLISIMP(%d,%n) ($S($$$GXLNEXTENT(%d,%n)>0:$$$GXLENTIMP1($$$GXLNEXTENT(%d,%n)),$$$GXLNEXTENT(%d,%n)<0:$$$GXLENTIMP2(-$$$GXLNEXTENT(%d,%n)),1:0)'=0)
#define GXLISLCK(%d,%n) ($S($$$GXLNEXTENT(%d,%n)>0:$$$GXLENTLCK1($$$GXLNEXTENT(%d,%n)),$$$GXLNEXTENT(%d,%n)<0:$$$GXLENTLCK2(-$$$GXLNEXTENT(%d,%n)),1:0)'=0)
#endif   ;VGG173-
#endif   ; DPB125-
  
#endif
 ; The old global structure was:
 ;     ^SYS("GIND",1)=0^^/usr/msql/
 ;
 ;     ^SYS("REPL",1
#if 1    ;TR406+
#define  CANDIR(%dir) $ZU(12,%dir)
#define  CANVALID(%dir) $ZU(12,%dir,1)
#define  CANDIREXIST(%dir) $ZU(12,%dir,2)
#define  CANSPECEXIST(%dir) $ZU(12,%dir,3)
#define  CHKMUMPS(%dir) $ZU(49,%dir)
#endif
#if '$$$NONAMESPACE ;TR406+
#define  GXLNSIGNON(%nsp) $ZU(90,4,%nsp)
#endif   ;TR406-  