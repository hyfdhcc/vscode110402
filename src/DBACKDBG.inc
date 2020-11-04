ROUTINE DBACKDBG [Type=INC]
#if 0   /*=======================Maintenance========================*/
CFL284   ;01/18/01, Carlos Lopes, USEBIGDB changes
STC200   ;02/26/99, Steve Clay remove Site is macro
LRS277   ;10/28/98, Lee Smith, fix $TEXT usage to not require source code
LRS218   ;04/02/98, Lee Smith: change include %site to SITE
DPB135   ;06/29/93, Dan Smith, add comments at entry points as needed
         ;          to prevent syntax errors when ZLOADed
JAO580   ;06/15/93, Jeffrey Orlin, define MORE as a noop for the non-
         ;          instrumented case.
DPB107   ;04/14/93, Dan Smith Initial creation
         ;Subroutines for use within DBACK, included at end of routine
#endif  /*=====================End Maintenance======================*/
  
#if 0   ; LRS218+
#include %site     ;Mainline should have already included these
#else   ; LRS218=
#include SITE      ;Mainline should have already included these
#endif  ; LRS218-
#include ST
  
         ;DEVELOPMENT SCAFFOLDING
  
#ifndef INSTRUMENT
  
ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N,P) ;so needn't change $$ZU's to $ZU's
 IF '$D(B) Q $ZU(A)
 IF '$D(C) Q $ZU(A,B)
 IF '$D(D) Q $ZU(A,B,C)
 IF '$D(E) Q $ZU(A,B,C,D)
 IF '$D(F) Q $ZU(A,B,C,D,E)
 IF '$D(G) Q $ZU(A,B,C,D,E,F)
 IF '$D(H) Q $ZU(A,B,C,D,E,F,G)
 IF '$D(I) Q $ZU(A,B,C,D,E,F,G,H)
 IF '$D(J) Q $ZU(A,B,C,D,E,F,G,H,I)
 IF '$D(K) Q $ZU(A,B,C,D,E,F,G,H,I,J)
 IF '$D(L) Q $ZU(A,B,C,D,E,F,G,H,I,J,K)
 IF '$D(M) Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L)
 IF '$D(N) Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L,M)
 IF '$D(P) Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N)
           Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N,P)
  
MORE Q      ;JAO580 added 
#else
 
#if 0   ; CFL284+        
MORE Q:'$$$SHOW
 N X R:$Y>20 !,"Press RETURN:",X,!,"---------------------------------",#
 Q
  
ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N,P)          ;Development/debugging hook for $ZU 
 IF '$$$SHOW Q $$ZUNORMAL
#else   ; CFL284=
MORE Q
  
ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N,P)          ;Development/debugging hook for $ZU 
 i $g(logfile)'="" u logfile
 IF '$$$SHOW U 0 Q $$ZUNORMAL
#endif  ; CFL284-
 NEW ABORT,RESULT,TARGET,V  
 D MORE W:$X'=0 ! W "Calling $ZU(",A 
 S ABORT=0
 FOR V="B","C","D","E","F","G","H","I","J","K","L","M","N","P" DO  Q:ABORT
 . IF '$D(@V) S ABORT=1 Q
#if 0   ; CFL284+
 . W ",",@V
#else   ; CFL284=
 . W ",",$P(@V,DELIM)
#endif  ; CFL284-
 W ")"
 S TARGET="ZU"_A
 IF $TEXT(@TARGET)'="" D @TARGET G ZUDONE
 S RESULT=$$ZUNORMAL
#if 0   ; CFL284+
ZUDONE   W ?78-$L(RESULT),"=",RESULT,!
 Q RESULT
#else   ; CFL284=
ZUDONE I +RESULT>0 W "=",$P("RCSUCCESS,RCEOT,RCOFFLINE,RCDEVFUL",",",+RESULT),",",$P(RESULT,",",2,999),! U 0 Q RESULT
 W "=",$P("RCINERR,RCOUTERR,RCOUTCLUMNT,RCMOUNT,RCMAPERR,RCOLDFORMAT,RCBADVOLUME,RCBADRECORDONRESTORE,-9,RCENDOFVOL,RCBADMAP,RCBLKSIZE,RCMAPINERR,RCINERRLABELGOOD,RCBADRECORDONCOPY,RCMISSINGBLKS,RCENDOFVOLSET,RCDIRLABELRECORD,RCDIRLABELMISSING",",",-RESULT),",",$P(RESULT,",",2,999),!
 U 0 Q RESULT
#endif  ; CFL284-
  
  
ZUNORMAL() ; Actually process the $ZU
 IF '$D(B) Q $ZU(A)
 IF '$D(C) Q $ZU(A,B)
 IF '$D(D) Q $ZU(A,B,C)
 IF '$D(E) Q $ZU(A,B,C,D)
 IF '$D(F) Q $ZU(A,B,C,D,E)
 IF '$D(G) Q $ZU(A,B,C,D,E,F)
 IF '$D(H) Q $ZU(A,B,C,D,E,F,G)
 IF '$D(I) Q $ZU(A,B,C,D,E,F,G,H)
 IF '$D(J) Q $ZU(A,B,C,D,E,F,G,H,I)
 IF '$D(K) Q $ZU(A,B,C,D,E,F,G,H,I,J)
 IF '$D(L) Q $ZU(A,B,C,D,E,F,G,H,I,J,K)
 IF '$D(M) Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L)
 IF '$D(N) Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L,M)
 IF '$D(P) Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N)
           Q $ZU(A,B,C,D,E,F,G,H,I,J,K,L,M,N,P)
  
  
#if 0   ;LRS277+
ZU15 W !,*7,*7,?10,"$ZU(15)"
#else   ;LRS277=
ZU15 ;;
 W !,*7,*7,?10,"$ZU(15)"
#endif  ;LRS277-
#ifdef STUB
 S RESULT=$G(B) Q
#else
 S RESULT=$$ZUNORMAL Q
#endif
  
ZREPORT(B,C,D)
#if 0   ; CFL284+
 Q:'$$$SHOW
 N FROM,TO S FROM=$P(B,".",2),TO=$P(C,".",2)
 W !,?10," VAX INLOGOR ",FROM," -> ",TO,?60,$P("no change to,clear,delete,database,count bits",",",D+1)," ",FROM
 Q
#else   ; CFL284=
 i $g(logfile)'="" u logfile
 i '$$$SHOW u 0 q
 N FROM,TO S FROM=$P(B,".",2),TO=$P(C,".",2)
 W !,?10," VAX INLOGOR ",FROM," -> ",TO,?60,$P("no change to,clear,delete,database,count bits",",",D+1)," ",FROM
 u 0 Q
#endif  ; CFL284-
  
#if 0   ;LRS277+
ZU31 
#else   ;LRS277=
ZU31 ;;
#endif  ;LRS277-
 N FOO,BAR,FROM,TO
 S FOO(+$$$STiorclear)="clear",FOO(+$$$STiornone)="no change to"
 S FOO(+$$$STiordelete)="clear",FOO(+$$$STiorusedb)="database"
 S FOO(+$$$STiorcntbits)="count bits"
 S BAR(+$$$STmapactive)="INC",BAR(+$$$STmapscratch)="IND"
 S BAR(+$$$STmaprecord)="INE",BAR(+$$$STmapcum)="INF"
 S FROM=$G(BAR(+C)),TO=$G(BAR(+D)),FN=$G(FOO(+E))
 S:FROM="" FROM="???" S:TO="" TO="???" S:FN="" FN="UNKNOWN"
 W !,?10,"UNIX INLOGOR ",FROM," -> ",TO,?60,FN," ",FROM
#ifdef STUB
 S RESULT=1 Q
#else
 S RESULT=$$ZUNORMAL Q
#endif
  
#if 0   ;LRS277+
ZU32 W !,?10,"IBUpass "
#else   ;LRS277=
ZU32 ;;
 W !,?10,"IBUpass "
#endif  ;LRS277-
#if 0   ; CFL284+
 W $P("start,partial,full,continue,restart,stop",",",B+1)
#else   ; CFL284=
 W $P("init I/O structs,open dir,start/continue copy,write end-of-volume,write end-of-volume-set,stop",",",B+1)
#endif  ; CFL284-
#ifdef STUB
 S RESULT=1 Q   ;Simulate success
#else
 S RESULT=$$ZUNORMAL Q
#endif
  
#if 0   ;LRS277+
ZU50 IF B=0 K SIMLABEL S SIMLABEL=C,SIMLABEL(0)=0
#else   ;LRS277=
ZU50 ;;
 IF B=0 K SIMLABEL S SIMLABEL=C,SIMLABEL(0)=0
#endif  ;LRS277-
 IF B=1 S SIMLABEL(0)=SIMLABEL(0)+1,SIMLABEL(SIMLABEL(0))=C
#if 0   ; CFL284+
 I B=2 W !,?15,"Label written on ",SIMLABEL F I=1:1:SIMLABEL(0) W !,?20,I,?25,SIMLABEL(I)
#else   ; CFL284=
 I B=2 W !,?15,"Label written on ",SIMLABEL F I=1:1:SIMLABEL(0) W !,?20,I,?25,$P(SIMLABEL(I),DELIM)
#endif  ; CFL284-
#ifdef STUB
 S RESULT=1 Q
#else
 S RESULT=$$ZUNORMAL Q
#endif
  
#if 0   ;LRS277+
ZU52 
#else   ;LRS277=
ZU52 ;;
#endif  ;LRS277-
#if 0   ; CFL284+
 W !,?10,"DBREST ",$P("Open & read label,Start restoring,Scan for neg block,Close,Skip",",",B+1) 
#else   ; CFL284=
 W !,?10,"DBREST ",$P("Prepare for backup,Start restoring,Scan for label blk,Close,Skip,GFINCREST,Scan for label blk,Adjust DB size,GFNOBACKUP,,,,Open & read label",",",B+1+('B&$D(C)*10)) 
#endif  ; CFL284-
#ifdef STUB
 S RESULT=1 Q  ;Simulate success
#else
 S RESULT=$$ZUNORMAL Q
#endif
  
ZUASK() N RESULT
 READ !,"Result:",RESULT,!
 Q RESULT
  
#if 1   ; CFL284+
Trace(str,p1,p2,p3) ;
 N x
 S x=$f(str,"%1") I x S $e(str,x-2,x-1)=$g(p1)
 S x=$f(str,"%2") I x S $e(str,x-2,x-1)=$g(p2)
 S x=$f(str,"%3") I x S $e(str,x-2,x-1)=$g(p3)
 I $g(logfile)'="" U logfile W !,str U 0
 Q
#endif  ; CFL284-
#endif   ; INSTRUMENT
  
  
  