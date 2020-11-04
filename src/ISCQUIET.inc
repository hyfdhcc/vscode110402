ROUTINE ISCQUIET [Type=INC]
#ifndef ISCQUIET
#define ISCQUIET
        ;ZQUIET.INC ;JO1988, 12/1/05
#if 0   /*=======================Maintenance========================*/
#;SML2161 10/21/15 Simon Li, Fix alert the system and Log the reasons when Quiesce failed.
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;SML739 07/17/06 Simon Li, Alert the system and Log the reasons when Quiesce failed.
JO1988  ; 12/01/05 Jeffrey Orlin, in Quesce after we timeout, change the
        ;          code which checks to see if only the WD is left running
        ;          for clusters. For clusters we need to remove both the WD
        ;          and the GC bits from the mask we use to see whether the
        ;          system is idle except for the WD. This is because $zu(51)
        ;          of either the WD or the GC in a cluster impilies that a
        ;          test of the other and if we include the GC bit, we can
        ;          "fail" if only the WD is still busy (eg. this defeats the
        ;          purpose of JO1816).
CFL1332	; 06/01/05 Carlos & Steve, replace %UTIL and %SYS.UTIL with LOGMSG
SAP227	; 09/15/04, Steve Pettibone, replace switch message
JO1816   ; 06/18/04, Jeffrey Orlin, allow $$Quiesce to exceed the timeout
         ;           if only the WD is busy
HYY887   ; 03/03/04, Huayong Yang, add timeout parameter to CluQuiet
SAP151	 ; 03/01/04, Steve Pettibone, remove switch message
HYY808   ; 09/22/03, Huayong Yang, add target to CluQuiet()
HYY798   ; 09/02/03, Huayong Yang, add CluQuiet()
HYY620   ; 05/13/02, Huayong Yang, add Quiesce() to return -1 on error
HYY567   ; 01/07/02, Huayong Yang, quiescence with timeout
LRS067   ; 05/26/95, Lee Smith: modified to parameterize $ZU(51) calls
                     and moved comments from SWSET.MAC into here
VGG143   ; 06/22/94, Added an option to it silently
DPB140   ; 07/12/93, Dan Smith add comment after ZQUIET(ARG,TEXT) to prevent
         ;           syntax errors when ZLOADing
DPB112   ; 04/28/93, initial creation
#endif  /*=====================End Maintenance======================*/
 
#if 0   /*======================Documentation=======================*/
         ; Family of subroutines that "wait for quiescence"
         ; Usage:
 
         ; 1) Don't #include anything, just call the copies in SWSET, e.g.
         ;           DO QUISYS^SWSET
 
         ; 2) Or: if you feel you need a local copy within your own routine,
         ;       ...
         ;           DO QUISYS
         ;       ...
         ;     #include ZQUIET
 
         ; $ZU(51,x) returns 1 if all activities selected by x are quiescent.
         ;        x = OR of values defined in ZQUIEDEF.INC
 
         ; The QUIET subroutines use $ZU(51) to wait for quiescence, while
         ;     giving appropriate user feedback.  Usually, it is appropriate
         ;     to call the copies in SWSET.   SWSET is chosen because
         ;     there's room and because these functions are often associated
         ;     with switch setting.
         ;
         ; Call                 Waiting for what:
 
         ; QUIWRITE^SWSET       "buffer activity"
         ; QUIGC^SWSET          "garbage collection"
         ; QUIDB^SWSET          "database expansion"
         ; QUIGLO^SWSET         "global activity"
         ; QUINET^SWSET         "network activity"
         ; QUIDISK^SWSET        "disk activity"
         ; QUIUPD^SWSET         "update activity"
         ; QUISYS^SWSET         "system activity"
 
         ; IMPLEMENTATION:
         ; The initial double test, IF $ZU(51,A) H 0.1 Q:$ZU(51,A)
         ; is important, according to Peter Cudhea.  QUIET is often called
         ; after a switch is set; e.g. set switch 10, then wait for globals to
         ; quiesce.  There's a time lapse between the initiation of a process
         ; and its logging of activity, so if you set a switch
         ; just after a process starts there's a time window during which
         ; you can possibly get an erroneous $ZU(51)=1 indication.
#endif  /*====================End Documentation=====================*/
 
#if 1    ; LRS067+
#include ISCQUIEDEF
#endif   ; LRS067-
#include %syCluster ;JO1988
 
#ifdef ZDPB112   ;Hook for debugging.
#define ZU51(%ARG) $$ZU51(%ARG)
#else
#define ZU51(%ARG) $ZU(51,%ARG)
#endif
#if 0   ;HYY567+ ;untimed checking for quiescence is seriously discouraged
#if 0    ; LRS067+
QUIWRITE DO QUIET(1,"buffer activity") Q
QUIGC DO QUIET(2,"garbage collection") Q
QUIDISK DO QUIET(3,"disk activity") Q
QUIDB DO QUIET(4,"database expansion") Q
QUIGLO DO QUIET(8,"global activity") Q
QUISYS DO QUIET(15,"system activity") Q
QUINET DO QUIET(16,"network activity") Q
#else    ; LRS067=
QUIWRITE DO QUIET($$$WDBUSYBIT,"buffer activity") Q
QUIGC DO QUIET($$$GCBUSYBIT,"garbage collection") Q
QUIDB DO QUIET($$$DBEXPANDBIT,"database expansion") Q
QUIGLO DO QUIET($$$GLBREFBIT,"global activity") Q
QUINET DO QUIET($$$NETBUSYBIT,"network activity") Q
QUIDISK DO QUIET($$$DISKBITS,"disk activity") Q
QUIUPD DO QUIET($$$DISKBITS+$$$DBEXPANDBIT+$$$GLBUPDBIT,"update activity") Q
QUISYS DO QUIET($$$DISKBITS+$$$DBEXPANDBIT+$$$GLBREFBIT,"system activity") Q
#endif   ; LRS067-
 
#if 0    ; DPB140+
QUIET(ARG,TEXT)
#else    ; DPB140=
QUIET(ARG,TEXT) ;ARG=$ZU(51) argument, TEXT=description for user
#endif   ; DPB140-
#if 0    ; VGG143+
 IF $$$ZU51(ARG) H 0.1 Q:$$$ZU51(ARG)
 W !,"Waiting for ",TEXT," to finish..."
 N I F I=1:1  H 1 Q:$$$ZU51(ARG)  I I#5=0 W "." W:$X>70 !,?5
 W " ready."
#else    ; VGG143=
 n SILENT        
 IF $$$ZU51(ARG) H 0.1 Q:$$$ZU51(ARG)
 s SILENT=+$g(%SILENT)
 W:'SILENT !,"Waiting for ",TEXT," to finish..."
 N I F I=1:1  H 1 Q:$$$ZU51(ARG)  I (I#5=0),'SILENT W "." W:$X>70 !,?5
 W:'SILENT " ready."
#endif   ; VGG143-
 Q 
#else   ;HYY567=
; Checking for quiescence with timeout
TQUIWRITE(verbose) q $$QUIESCE($$$WDBUSYBIT,"buffer activity",10,verbose)
TQUIGC(verbose) q $$QUIESCE($$$GCBUSYBIT,"garbage collection",10,verbose)
TQUIDB(verbose) q $$QUIESCE($$$DBEXPANDBIT,"database expansion",10,verbose)
TQUIGLO(verbose) q $$QUIESCE($$$GLBREFBIT,"global activity",10,verbose)
TQUIGLOUPD(verbose) q $$QUIESCE($$$GLBUPDBIT,"global updates",10,verbose)
TQUINET(verbose) q $$QUIESCE($$$NETBUSYBIT,"network activity",10,verbose)
TQUIDISK(verbose) q $$QUIESCE($$$DISKBITS,"disk activity",10,verbose)
TQUIUPD(verbose) q $$QUIESCE($$$DISKBITS+$$$DBEXPANDBIT+$$$GLBUPDBIT,"update activity",10,verbose)
TQUISYS(verbose) q $$QUIESCE($$$DISKBITS+$$$DBEXPANDBIT+$$$GLBREFBIT,"system activity",10,verbose)
#ifndef QUIESCEMSGOUT
#define QUIESCEMSGOUT(%msg) i verbose w %msg
#endif
#define CRLF $c(13,10)
QUIESCE(bits,text,retries,verbose,intv) ;
#;HYY620+
 ;return 0 on error or timeout quiescing system, 1 if system is quiescent
 s verbose=+$g(verbose),retries=+$g(retries,-1),intv=+$g(intv,1)
 q ($$Quiesce(bits,text,retries,verbose,intv)>0)
Quiesce(bits,text,retries,verbose,intv) ;
 ;return -1 on error, 0 on timeout quiescing system, 1 if system is quiescent
#;HYY620-
 n noWDbits  ;JO1988
 s $zt="QUIESCEE"
 q:$zu(51,bits) 1 ;double checking $ZU(51) is no longer necessary
 s verbose=+$g(verbose),retries=+$g(retries,-1),intv=+$g(intv,1)
#if 1    ;SAP227
 $$$QUIESCEMSGOUT($$$CRLF_"WARNING: Switch is set and may affect production for up to "_(retries*intv)_" seconds."_$$$CRLF_"Waiting for "_text_" to finish...")
#endif   ;SAP227-
 f  q:'retries  h intv q:$zu(51,bits)  s retries=retries-1 i retries#5=0 $$$QUIESCEMSGOUT(".")
#if 1  ;JO1816+
 ;If the system isn't quiet but the only thing busy is the WD and we're waiting
 ;for more than just the WD, then continue to wait for up to two minutes for
 ;the WD to finish. This caters for the case where a timeout is too short for
 ;the WD to finish a cycle.
#if 0 ;JO1988+
 if '$ZU(51,bits),bits'=$$$WDBUSYBIT,$zboolean(bits,$$$WDBUSYBIT,1),$zu(51,bits-$$$WDBUSYBIT) {
#else ;JO1988=
 ;If this system is a cluster member then we exclude both the WD and the 
 ;GC from the $ZU(51) to see whether it is only the WD which is busy.
 s noWDbits=$$$WDBUSYBIT
 s:$$$IsCluSys noWDbits=noWDbits+$$$GCBUSYBIT
 s noWDbits=$zboolean(bits,noWDbits,2)  ;2 = x & ~ y
 if '$ZU(51,bits),bits'=$$$WDBUSYBIT,$zboolean(bits,$$$WDBUSYBIT,1),$zu(51,noWDbits) {
#endif ;JO1988-
	 ;$ZU(51,bits) without the WDBUSYBIT reports 'idle'. Continue to wait for up to
	 ;2 minutes to give the WD a chance to finish.
	 $$$QUIESCEMSGOUT($$$CRLF_"System is idle except WD is still running."_$$$CRLF_"     Waiting up to 2 minutes for WD to finish")
	 f i=1:1:120 q:$ZU(51,bits)  h 1 if i#5=0 $$$QUIESCEMSGOUT(".")
	 if $ZU(51,bits) s retries=1 ;signal success
 }
#endif ;JO1816-
#;SML739+
 $$$QUIESCEMSGOUT($s(retries:" ready.",1:" abort. "_$$quiescefailmsg(bits))_$$$CRLF)
#;SML739-
 q retries
#;SML739+
quiescefailmsg(bits)
 N ret,clu,clumsg s ret="",clu=$zb(bits,$$$CHKCLUMASTER+$$$CHKCLUSLAVES+$$$CLUSTERBIT,1),clumsg=""
 if $zb(clu,$$$CLUSTERBIT,1)||($zb(clu,$$$CLUSTERWIDEBITS,1)=$$$CLUSTERWIDEBITS) s clu=$$$CLUSTERBIT,clumsg=" (cluster wide)"
 if $zb(clu,$$$CHKCLUMASTER,1) s clumsg=" (cluster master only)"
 if $zb(clu,$$$CHKCLUSLAVES,1) s clumsg=" (cluster slaves only)"
#;SML2161+ ; Should not compare the $zb()=1.
 if $zb(bits,$$$WDBUSYBIT,1)&&('$ZU(51,clu+$$$WDBUSYBIT)) S ret=ret_"write daemon"_clumsg_","
 if $zb(bits,$$$GCBUSYBIT,1)&&('$ZU(51,clu+$$$GCBUSYBIT)) S ret=ret_"garbage collector"_clumsg_"," 
 if $zb(bits,$$$DBEXPANDBIT,1)&&('$ZU(51,clu+$$$DBEXPANDBIT)) S ret=ret_"file expander"_clumsg_","
 if $zb(bits,$$$GLBREFBIT,1)&&('$ZU(51,clu+$$$GLBREFBIT)) S ret=ret_"global reference"_clumsg_","
 if $zb(bits,$$$GLBUPDBIT,1)&&('$ZU(51,clu+$$$GLBUPDBIT)) S ret=ret_"global update"_clumsg_","
 if $zb(bits,$$$NETBUSYBIT,1)&&('$ZU(51,clu+$$$NETBUSYBIT)) S ret=ret_"client-side network connections"_clumsg_","
 if $zb(bits,$$$NETSRVBIT,1)&&('$ZU(51,clu+$$$NETSRVBIT)) S ret=ret_"network server activity"_clumsg_","
#;SML2161-
 if ret'="" s ret="Quiesce failed reason: "_$e(ret,1,*-1) d $zu(9,"",ret,1,2) i $d(^rOBJ("ZQuiesceFail")) d ^ZQuiesceFail
 Q ret
#;SML739-
#;HYY620+ ;return -1, indicating an error condition, e.g., <INTERRUPT>, etc.
QUIESCEE s $zt="" d $$$LOGMSG("QUIESCE: "_$ze,0,1) q -1 ;0
#;HYY620-
#;HYY798+
#; similar to quietsw, defined in dbackrou.inc
#if 0   ;HYY808+
CluQuiet(switch,slaveonly)
#else   ;HYY808=
#; target: slave only (1), master only (2) or all (0, default)
#;         converted to bit values $$$CHKCLUSLAVES, $$$CHKCLUMASTER or combined
#if 0   ;HYY887+
CluQuiet(switch,target)
#else   ;HYY887=
#; timeout: how long to try quiescing before returning failure (default=10)
CluQuiet(switch,target,timeout)
#endif  ;HYY887-
#endif  ;HYY808-
 n flags,rc
 i $g(switch)-10,$g(switch)-13 ztrap "SWITCH"
#if 0   ;HYY808+
 s flags=$$$DISKBITS+$$$DBEXPANDBIT+$s(switch=10:$$$GLBREFBIT,1:$$$GLBUPDBIT)+$s('$g(slaveonly):$$$CLUSTERBIT,1:$$$CLUSLAVEBIT)
 s rc=$$Quiesce(flags,$s(switch=10:"system activity",1:"update activity")_$s('$g(slaveonly):" cluster wide",1:" on slave members"),10,'$g(QUIET,$g(QUIETLY)))
#else   ;HYY808=
 n targetmsg s target=$g(target)
 i target=1 s target=$$$CHKCLUSLAVES,targetmsg=" on cluster slave members"
 e  i target=2 s target=$$$CHKCLUMASTER,targetmsg=" on cluster master"
 e  s target=$$$CHKCLUMASTER+$$$CHKCLUSLAVES,targetmsg=" cluster wide"
 s flags=$$$DISKBITS+$$$DBEXPANDBIT+$s(switch=10:$$$GLBREFBIT,1:$$$GLBUPDBIT)
#if 0   ;HYY887+
 s rc=$$Quiesce(flags+target,$s(switch=10:"system activity",1:"update activity")_targetmsg,10,'$g(QUIET,$g(QUIETLY)))
#else   ;HYY887=
 s rc=$$Quiesce(flags+target,$s(switch=10:"system activity",1:"update activity")_targetmsg,$g(timeout,10),'$g(QUIET,$g(QUIETLY)))
#endif  ;HYY887-
#endif  ;HYY808-
 i rc<0 ztrap "Abort"
 q rc
#;HYY798-
#endif  ;HYY567-