ROUTINE DBACKROU [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;HYY1719 12/19/11 Huayong Yang, replace "zq 1 g @$zt" with "ztrap $ze"
#;STC1397 05/15/08 Steve Clay, Remove use of obsolete ^MTDEV from backup routines
#;SML864  5/15/07 Simon Li, Allow backup to remote shared file.
#;SML643 11/09/05 Simon Li, avoid indefinitely timeout for ENQ10 and ENQ13.
#;SML579 5/25/05 Simon Li, Force a full backup if backup operation is
#;               interrupted in a state that full backup is needed next time.
HYY887 ;03/19/04, Huayong Yang, add timeout parameter to quietsw
HYY808 ;09/22/03, Huayong Yang, an option to quiesce master only with switch 10
HYY805 ;09/10/03, Huayong Yang, add error trap to ENQ* to clear switch on exit
HYY799 ;09/04/03, Huayong Yang, back out HYY797 and use CLU^SWSET in ENQ10/13
HYY797 ;08/26/03, Huayong Yang, derive quiesce timeout from network timeout
JO1651 ;12/06/02, Jeffrey Orlin, increase quiescence timeout to 30 sec
HYY711 ;10/17/02, Huayong Yang, allow QUIET undefined in quietsw
HYY641 ;07/19/02, Huayong Yang, suspend WD instead of inhibiting db access
HYY620 ;05/03/02, Huayong Yang, allow timeout in waiting for system to quiesce
HYY567 ;01/04/02, Huayong Yang, quiescence with timeout
CFL519 ;05/22/01, Carlos Lopes, FILENORM now sets ISREG for regular files
AVS040 ;08/30/00, Alex Sverdlov, ported the <NOLINE> cleanup from 4.0
LRS442 ;07/21/00, Lee Smith, "recieved" -> "received"
LRS330 ;04/15/99, Lee Smith: change Cache' to Cache in visible text
STC200 ;02/26/99, Steve Clay, Cleaned, removed site is macro
LRS218 ;03/30/98, Lee Smith: change include %site to SITE
DAW007 ;10/10/97 Dan Williams, Change Ijc*^%Wprim to Ijc*^%Wprima
JAO928 ;05/02/97, Jeffrey Orlin, restored behavior of msgout and created
       ;          a msgouta() for DBSIZE to use which uses indirection. When
       ;          DBSIZE gets "GUIized" it will use msgout() too and msgouta()
       ;          can be removed. To "get" the msgouta() routine, USEMSGOUTA
       ;          must be defined before including this file. Backed out
       ;          NGA040
NGA040 ;04/29/97, Neil Alton, changed msgout write to chui as indirect argument
DAH001 ;04/30/96, Dave Holbrook: GUI support
NGA023 ;05/10/96 Neil Alton, added check for logfile defined in msgout
STC103 ;04/11/95, Steve Clay Added timestamp subroutine
DKA290 ;11/29/95, Keith Avery: Added support for Windows NT
 ;          Removed old code for DPB144
AHS169 ;07/05/95, Amir Shokrollahi, fixed a bug in FILENORM.
RAM498 ;07/05/95, Rick Miller, FILENORM modified for VMS case.
RAM420 ;11/23/94, Rick Miller, FILENORM modified to support magtape
         ;          devices.  In the non-VMS case, M device numbers
         ;          47 through 62 are left as is instead of being
         ;          translated to an operating system device name. 
JAO614 ;12/12/93, Jeffrey Orlin, FILENORM was trashing VMS filenames
DPB156 ;07/27/93, Dan Smith, translate M magtape device numbers
DPB135 ;06/29/93, Dan Smith, Add comments to entry points as needed,
         ;          without change marks, to prevent syntax errors when
         ;          the routine is ZLOADED.
DPB107 ;04/14/93, Dan Smith, Initial creation
         ;Subroutines for use within DBACK, included at end of routine
#endif  /*=====================End Maintenance======================*/
  
#include SITE      ;Mainline should have already included these
#include ST

#define from 47
#define to 62
 
  
INLOGOR(DIR,SOURCE,TARGET,DISPOSE) ;Adapter, present same i'face for VAX & UX
								#;HYY2383+
 n rc
 try {
   s rc=$ZU($$$INLOGOR,DIR,SOURCE,TARGET,DISPOSE)
 } catch {
   s rc=-1_","_$ze
   s $ze=""
 }
 q rc
								#;HYY2383-
  
         ; PROVISIONAL code for normalizing a UNIX filename
  
FILENORM(NAME) ;Return normalized version of NAME
 ; DPB156+ ;If it has an MTDEV translation, use it.
#if 1   ;CFL519+
 S OK=1,$ZT="FNERR"
#endif  ;CFL519-
 i $$$ISVMS N MTDEV S MTDEV=$$OSDEVICE(NAME) I MTDEV'="" D  Q MTDEV
#if 0   ;LRS330+
 . W !,"Cache' device numbers are not legal here.  Substituting ",MTDEV
#else   ;LRS330=
#if 1   ;CFL519+
 . s ISREG=0
#endif  ;CFL519-
 . W !,"Cache device numbers are not legal here.  Substituting ",MTDEV
#endif  ;LRS330-
#if 0   ;CFL519+
 i '$$$ISVMS N MTDEV,DIR S MTDEV=$$OSDEVICE(NAME) Q:MTDEV'="" NAME
#else   ;CFL519=
 i '$$$ISVMS N MTDEV,DIR S MTDEV=$$OSDEVICE(NAME) I MTDEV'="" S ISREG=0 Q NAME
#endif  ;CFL519-
 
 i $$$ISVMS S DIR=NAME
 i $$$ISVMS q $ZU(12,DIR)
#;SML864+ ; Check if this is a tape device.
 i $$$ISWINDOWS,$E(NAME,1,2)="\\" S L=$$CheckForTape(NAME) I L'="" S ISREG=0 Q L
#;SML864-
 i $$$ISWINDOWS S L=$L(NAME,"\"),DIR=$P(NAME,"\",1,L-1)
 i $$$ISWINDOWS IF L>1 S DIR=DIR_"\"
#if 0   ;CFL519+
 i $$$ISWINDOWS Q $ZU(12,DIR)_$P(NAME,"\",L,L)
#else   ;CFL519=
#;SML864 ;remove this line i $$$ISWINDOWS,$E(DIR,1,2)="\\" S OK=0,ERRMSG="Remote devices not allowed." Q NAME
 i $$$ISWINDOWS S NAME=$ZU(12,DIR)_$P(NAME,"\",L,L),ISREG=$ZU(140,7,NAME),ISREG=$S(ISREG>0:1,ISREG=-2:1,1:0) Q NAME
#endif  ;CFL519-
 i $$$ISUNIX S L=$L(NAME,"/"),DIR=$P(NAME,"/",1,L-1)
 i $$$ISUNIX IF L>1 S DIR=DIR_"/"
#if 0   ;CFL519+
 i $$$ISUNIX Q $ZU(12,DIR)_$P(NAME,"/",L,L)
#else   ;CFL519=
 i $$$ISUNIX S NAME=$ZU(12,DIR)_$P(NAME,"/",L,L),ISREG=$ZU(140,7,NAME),ISREG=$S(ISREG=-2:1,ISREG/32768#2:1,1:0) Q NAME
FNERR S OK=0,ERRMSG="Not a valid device name." Q
#endif  ;CFL519-
#;SML864+ ; Check if this is a tape device.
CheckForTape(NAME)
#; Check if it matches the name for device 47 to 62.
 S NAME=$ZCVT(NAME,"U")
 N I,TAPE
 For I=47:1:62 s TAPE=$$OSDEVICE(I) I NAME=$ZCVT(TAPE,"U") S NAME=I Q
 I NAME?2N Q NAME
 I NAME?1"\\.\TAPE"1N Q NAME
 Q ""
#;SML864-
  
#if 0   /*======================Documentation=======================*/
         ; This is used throughout the backup software whenever it wants
         ;   to display a message.  See DBACKA for more info.
#endif  /*====================End Documentation=====================*/
  
#;HYY567+
#; QUIESCEMSGOUT, if not default, must be defined before ZQUIET is included
#define QUIESCEMSGOUT(%msg) d msgout(%msg,NOFORCE)
#include ISCQUIET
#;HYY620+
 ;return: 1 if system is quiescent, 0 otherwise; ztrap if error or interrupted
#if 0   ;HYY887+
quietsw(switch) ;quiesce activities w/ timeout after setting switch 10 or 13
#else   ;HYY887=
quietsw(switch,timeout) ;quiesce activities w/ timeout after setting switch 10 or 13
#endif  ;HYY887-
 n flags,rc
 i $g(switch)-10,$g(switch)-13 ztrap "SWITCH"
 s flags=$$$DISKBITS+$$$DBEXPANDBIT+$s(switch=10:$$$GLBREFBIT,1:$$$GLBUPDBIT)
 i CLUBACKUP s flags=flags+$$$CLUSTERBIT
#if 1   ;HYY797+, HYY799
 #;HYY711+
#if 0   ;JO1651+
 s rc=$$Quiesce(flags,"disk cleanup",10,'$g(QUIET))
#else   ;JO1651=
#if 0   ;HYY887+
 s rc=$$Quiesce(flags,"disk cleanup",30,'$g(QUIET))
#else   ;HYY887=
 s rc=$$Quiesce(flags,"disk cleanup",$s($g(timeout)="":30,1:timeout),'$g(QUIET))
#endif  ;HYY887-
#endif  ;JO1651-
 #;HYY711-
#else   ;HYY797=
#if 0   ;HYY887+
 n timeout s timeout=+$g(^SYS("BACKUP","TIMEOUT")) i 'timeout d
#else   ;HYY887=
 i $g(timeout)="" s timeout=+$g(^SYS("BACKUP","TIMEOUT")) i 'timeout d
#endif  ;HYY887-
 #; We could use network timeout in noncluster backup too, but cluster backup
 #; is the main issue as server is being blocked when we quiesce the clients,
 #; who may be waiting for answers to $incr (update) or lock (read) requests.
 . i 'CLUBACKUP s timeout=10
 #; ECP-based cluster (NETTYPE=D) is not an issue (SML369)
 . e  i $g(^SYS("CLUSTER","NETTYPE"))="D" s timeout=10
 #; If there is no network activity, no need to extend quiescence timeout.
 #; There won't be any network activity of the kind (update and/or read) we 
 #; are trying to suspend as long as the proper switch is set (cluster wide).
 . e  i $zu(51,$$$NETBUSYBIT+$$$CLUSTERBIT) s timeout=10
 #; network timeout + network max retransmit timeout + 10 seconds 
 #; NB: network timeout values in system are in milliseconds
 . e  s timeout=($v($$$STNETSYSTAB+$$$STnsnmxtimer,-3,$$$STILEN)+$v($$$STNETSYSTAB+$ZU(40,18,24),-3,$$$STILEN))/1000+10
 s rc=$$Quiesce(flags,"disk cleanup",timeout,'$g(QUIET))
#endif  ;HYY797-
 i rc<0 ztrap "Abort"
 q rc
hibernate(switch,released,timeo) ;
 i +$g(released) d msgout($$$CRLF_"Switch "_switch_" is released.",NOFORCE)
 n hibtime s hibtime=$s(timeo>3:10,timeo>2:1,timeo>1:.1,timeo>0:.01,1:10)
 d msgout($$$CRLF_"Backup will hibernate for "_hibtime_" second(s) and try again."_$$$CRLF_"You may abort Backup via Ctrl-C. ",NOFORCE) 
 i hibtime<1 h hibtime
 e  n i f i=1:1:hibtime h 1 d msgout(".",NOFORCE)
 d msgout($$$CRLF,NOFORCE)
 q
ENQ10 ;
#;SML643+
 n t s t=$g(quietimeout,60) s:t>0 t=(t+9)\10 ;rounded up to 10 sec
#;SML643-
 #;HYY805+
 s $zt="ENQ10e"
 #;HYY805-
#if 0   ;HYY799+
 f  d  q:$$quietsw(10)  s t=t-1 zt:'t "Abort" d DEQ10,hibernate(10,'ALRDY10,t)
 . i 'ALRDY10 S %SW=10,%VAL=1 D INT^SWSET
 . i CLUBACKUP,$ZU(95,10,1)  ; Set SW10 clusterwide
#else   ;HYY799=
 i CLUBACKUP d  q
#if 0   ;HYY808+
 . f  q:$$CLU^SWSET(10,1,ALRDY10)  s t=t-1 zt:'t "Abort" d DEQ10,hibernate(10,'ALRDY10,t)
#else   ;HYY808=
 . f  q:$$CLU^SWSET(10,1,ALRDY10,$g(QUIETMASTERONLY))  s t=t-1 zt:'t "Abort" d hibernate(10,'ALRDY10,t)
#endif  ;HYY808-
 ; non-cluster backup
 #; If switch 10 is already set, then there is no pointer hibernating as we
 #; cannot clear the switch.
 i ALRDY10 q:$$quietsw(10)  zt "Abort"
 f  S %SW=10,%VAL=1 D INT^SWSET  q:$$quietsw(10)  s t=t-1 zt:'t "Abort" d DEQ10,hibernate(10,1,t)
#endif  ;HYY799-
 Q
							#;HYY805+,HYY1719+
ENQ10e s $zt="" d DEQ10 ztrap $ze
							#;HYY805-,HYY1719-
DEQ10 ;
 i CLUBACKUP,$ZU(95,10,0)  ; Clear SW10 clusterwide
 i 'ALRDY10 s %SW=10,%VAL=0 D INT^SWSET
 Q
ENQ13 ;
#;SML643+
 n t s t=$g(quietimeout,60) s:t>0 t=(t+9)\10 ;rounded up to 10 sec
#;SML643-
 #;HYY805+
 s $zt="ENQ13e"
 #;HYY805-
#if 0   ;HYY799+
 f  d  q:$$quietsw(13)  s t=t-1 zt:'t "Abort" d DEQ13,hibernate(13,'ALRDY13,t)
 . i 'ALRDY13 S %SW=13,%VAL=1 D INT^SWSET
 . i CLUBACKUP,$ZU(95,13,1)  ; Set SW13 clusterwide
#else   ;HYY799=
 i CLUBACKUP d  q
 . f  q:$$CLU^SWSET(13,1,ALRDY13)  s t=t-1 zt:'t "Abort" d DEQ13,hibernate(13,'ALRDY13,t)
 ; non-cluster backup
 #; If switch 10 is already set, then there is no pointer hibernating as we
 #; cannot clear the switch.
 i ALRDY13 q:$$quietsw(13)  zt "Abort"
 f  S %SW=13,%VAL=1 D INT^SWSET  q:$$quietsw(13)  s t=t-1 zt:'t "Abort" d DEQ13,hibernate(13,1,t)
#endif  ;HYY799-
 Q
#;HYY620-
#;HYY805+
ENQ13e s $zt="" d DEQ13 zq 1 g:$zt'="" @$zt q
#;HYY805-
DEQ13 ;
 i CLUBACKUP,$ZU(95,13,0)  ; Clear SW13 clusterwide
 i 'ALRDY13 s %SW=13,%VAL=0 D INT^SWSET
 Q
#;HYY567-
#;HYY641+
HOLDWD(dir) ;suspend write daemon (dir may be passed as an array)
 n n
 i $zu(182,1,0) ;clear any remaining backup request
 f  q:'$zu(182,0)  h 1  ;wait until write daemon runs again
#if 0  ;SML579+
 i $d(dir)<10 d $zu(182,2,0,+$zu(49,dir)) s n=1 i 1
 e  s dir="" f n=0:1 s dir=$o(dir(dir)) q:dir=""  i $zu(182,2,n,+$zu(49,dir))
#else  ;SML579=
#; Turn on GFFORCEFULBK flag for each DB by $zu(52,9,dir,1).
 i $d(dir)<10 d $zu(52,9,dir,1) d $zu(182,2,0,+$zu(49,dir)) s n=1 i 1
 e  s dir="" f n=0:1 s dir=$o(dir(dir)) q:dir=""  d $zu(52,9,dir,1) d $zu(182,2,n,+$zu(49,dir))
#endif ;SML579-
 i $zu(182,1,n)  ;set number of databases to back up
 f  q:$zu(182,0)  h 1  ;wait until write daemon suspends
 q
FREEWD ;unsuspend write daemon
 i $zu(182,1,0)
 q
#;HYY641-
msgout(aaamess,flag) ;
         s flag=$g(flag,1) ; default to FORCE
         W *-1            ;Flush the input buffer                     ;SSG012
         q:'$L(aaamess)   ; Avoid argumentless writes...
         i $g(logfile)'="" u logfile w aaamess
         u 0
         q:flag=3  ; 1 = FORCE, FORCE, 2 = NOFORCE, 3 = LOGONLY
         i '$G(INTERNAL,0)!('$G(NOINPUT,0)&(flag=1!'$G(QUIET,0))) w aaamess
         ; Send string to client
         ; "DI" is a display directive, the first 2 characters
         ; of a message to the client is a directive that the
         ; client understands.
         i $g(gui) D  
         . s return=$$IjcMsg^%Wprima("DI"_aaamess) ; Retval might =  cancel msg
         . i return="CANCEL" d  
         . . i $$IjcMsg^%Wprima("DI"_$$$CRLF_"Abort received!"_$$$CRLF)
         . . zt "Abort"
         u 0 
         q
#ifdef   USEMSGOUTA  ; JAO928+  (only used by DBSIZE 'till it get GUIzed)
msgouta(aaamess,flag) ;
         s flag=$g(flag,1) ; default to FORCE
         W *-1            ;Flush the input buffer                     ;SSG012
         q:'$L(aaamess)   ; Avoid argumentless writes...
         i $g(logfile)'="" u logfile w @aaamess
         u 0
         q:flag=3  ; 1 = FORCE, FORCE, 2 = NOFORCE, 3 = LOGONLY
         i '$G(INTERNAL,0)!('$G(NOINPUT,0)&(flag=1!'$G(QUIET,0))) w @aaamess
         ; Send string to client
         ; "DI" is a display directive, the first 2 characters
         ; of a message to the client is a directive that the
         ; client understands.
         i $g(gui) D  
         . s return=$$IjcMsg^%Wprima("DI"_aaamess) ; Retval might =  cancel msg
         . i return="CANCEL" d  
         . . i $$IjcMsg^%Wprima("DI"_$$$CRLF_"Abort received!"_$$$CRLF)
         . . zt "Abort"
         u 0 
         q
#endif   ; JAO928-         
  
timestmp(flag) 
         n msg,%TS,%TN
         s msg="TIMESTAMP: "
         s %DN=+$H d INT^%DO
         s msg=msg_%DS
         s %TN=$P($h,",",2) d ^%TO
         s msg=msg_" "_%TS
         d msgout($$$CRLF_msg_$$$CRLF)
         q
#; $$OSDEVICE(mdevice[,new])
#;
#; This unsupported/undocumented entry point is not intended 
#; for customer use and is subject to change without notice.
#;
#; mdevice is the M device number of a magtape device
#; OSDEVICE returns the corresponding OS device name, or null if none
#; If the second argument is supplied, OSDEVICE returns the OLD 
#;     OS device while setting the table entry to the NEW device.
#; If mdevice is out of range, OSDEVICE returns "" and does nothing.
 
OSDEVICE(mdevice,new) ;osdevice + range check, pad input, strip output.
 s mdevice=+mdevice q:mdevice<$$$from ""  q:mdevice>$$$to ""
 i $d(new) s new=$$zpad(new,$$$STMTDEVNML)
 q $$zstrip($$osdevice(mdevice,.new))
 
osdevice(mdevice,new) ;"Raw" osdevice
 n adr,old,size,where,charsize
 s $ZT="osdeverr"
 s charsize=$$charsize^%Wprim() ; check size one char
 s size=$$$STMTDEVNML,adr=(mdevice-$$$from)*(size*charsize)+$$$STMTDEV,where=-2
 s old=$v(adr,where,-size_"w")
 i $d(new) v adr:where:-size_"w":new
 q old
osdeverr q ""
 
zstrip(x) ;Return x with ASCII NUL's removed
 q $tr(x,$c(0),"")
 
zpad(x,len) ;x, maybe truncated, NUL-padded to length len, one NUL guaranteed
 n zeroes
 s zeroes=$j("",len),zeroes=$tr(zeroes," ",$c(0)) ;String of len NUL's
 s x=$e(x,1,len-1) ;Silently truncate x if necessary
 s $e(zeroes,1,$l(x))=x
 q zeroes
 