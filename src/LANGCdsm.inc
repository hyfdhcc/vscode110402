ROUTINE LANGCdsm [Type=INC]
 ;LANGCdsm.INC - DSM command routines. meb(belliveau) ; JLC537 08/26/03
  
#;/*=======================Maintenance=============================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;JLC537 08/26/03, Jose' Cordeiro, fix problem in OPEN file:(READONLY)
#;SJ1360 05/03/02, Scott Jones, removed ZWRITE
#;CDS239 02/24/02, Chuck Sorenson, add class name to ZWRITE for oref
#;CDS188 12/31/01, Chuck Sorenson, display orefs in ZWRITE
#;CDS227 12/28/01, Chuck Sorenson, use $NUMBER instead of +val
#;CFL471 03/14/01, Carlos Lopes, restore $ZR in Open command
#;JLC277 09/26/00, Jose' Cordeiro, fix opening file with READONLY.
#;APJ889 03/10/00, Phil Johnson, Convert all utilities to use %R api
#;CFL220 02/28/00, Carlos Lopes, fix Close file:(RENAME=newfile)
#;CFL185 10/19/99, Carlos Lopes, fix opening file using alias
#;MEB077 03/06/99, Marty Belliveau, use SET $ZR to restore $ZR
#;STC200 02/26/99, Steve Clay, Cleaned
#;LFT623 11/03/98, Laura Tillem, use new $ZU(5) behavior
#;MEB073 10/23/98, Marty Belliveau, fix $ZREFERENCE restore problem
#;LRS251 08/14/98, Lee Smith, change ^mtemp global usage per AK327
#;JO1041 06/12/98, Jeffrey Orlin, name change from %msql* to %LANG*
#;MEB035 05/14/97, Marty Belliveau: add support for sequential I/O
#;MEB034 05/02/97, Marty Belliveau: add support for ZDELETE and ZWRITE
#;MEB021 01/23/97, Marty Belliveau: %msqlCdsm.INC creation
#;/*=====================End Maintenance============================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;
 ; DSM Command Routines
 ;
 ; C(dev,kwn,kwv)                       CLOSE command
 ; J(lab,off,rou,ppv,kwn,kwv,tmo)       JOB command
 ; O(dev,kwn,kwv,tmo,msn)               OPEN command
 ; U(dev,kwn,kwv,msn)                   USE command
 ; ZDELETE(rou,opt)                     ZDELETE command
 ; ZU(dev,kwn,kwv)                      ZUSE command
 ; ZQhandler                            ZQUIT handler when no $ZTRAP
 ;                                      handlers left on call stack
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef %LANGCdsm
#define %LANGCdsm
  
#include GLUEDEF
  
 ;+
 ; CLOSE command
 ;-
C(dev,kwn,kwv) ;
 N arg,par,typ,io S io=$I,$ZT="Cuserr^"_$T(+0)
 U dev S typ=$ZU(96,14) U io S $ZT=""
 D:$D(kwn) ioparms("C",typ)
 S arg="dev"
 S:$D(par(1)) par="par(1)"
#;      CFL220+
 S:$D(par(2)) par=par_":par(2)"
#;      CFL220-
 S:$D(par) $P(arg,":",2)="("_par_")"
#if $$$GLUEDEBUG
 zw
#endif
 S $ZT="lasterr^"_$T(+0) C @arg
 Q
Cuserr S $ZT="" U io G:$ZE'["<NOTOPEN>" lasterr Q
 ;+
 ; JOB command
 ;-
J(lab,off,rou,ppv,kwn,kwv,tmo) ;
 N arg,ref,par,%,i
 S:lab=""&(off=1) off=0 ZT:off&$D(ppv) $$$APPERROR($$$ERSYNTX)
 D:$D(kwn) ioparms("J","")
 S:$D(tmo) $P(arg,":",3)=+tmo
 S:$D(par(4)) $P(par,":",4)=$S($D(%):$$indvalu(par(4)),1:"par(4)")
 S:$D(par(3)) $P(par,":",3)=$S($D(%):$$indvalu(par(3)),1:"par(3)")
 S:$D(par(2)) $P(par,":",2)=$S($D(%):$$indvalu(par(2)),1:"par(2)")
 S:$D(par(1)) $P(par,":",1)=$S($D(%):$$indvalu(par(1)),1:"par(1)")
 S:$D(par) $P(arg,":",2)="("_par_")"
 S ref=lab_$S(off:"+"_off,1:"")_$S(rou'="":"^"_rou,1:"")
 D:$D(ppv)  
 .S ref=ref_"(" D:ppv  S ref=ref_")"
 ..F i=1:1:ppv D  S:i'=ppv ref=ref_","
 ...S:'$D(%) ref=ref_"ppv("_i_")" S:$D(%) ref=ref_$$indvalu(ppv(i)) Q  
 S $P(arg,":",1)=ref
#if $$$GLUEDEBUG
 zw
#endif
 G:$D(%) Jdata S $ZT="lasterr^"_$T(+0) J @arg
 Q
 ; JOB command with DATA parameter (% value is passed to jobbed process)
Jdata N zesav S zesav=$ZE,$ZE=arg
 X "N (%) S $ZT=""lasterr^""_$T(+0) J @$ZE" S $ZE=zesav
 Q
 ;+
 ; OPEN command
 ;-
O(dev,kwn,kwv,tmo,msn) ;
 N arg,par,kxr,rws,crs,sio
 D:$D(kwn) ioparms("O","",.kxr)
 I $$$ISWINDOWS d
#if 0   ; CFL185+
 . D:$ZSE(dev)[dev
#else   ; CFL185=
#if 0   ;CFL471+
 . N d S d=$G(^|"%SYS"|SYS("DEVMAP",dev,"N"))
#else   ;CFL471=
 . N d,zr S zr=$ZR,d=$G(^|"%SYS"|SYS("DEVMAP",dev,"N")),$ZT="lasterr",$ZR=zr
#endif  ;CFL471-
 . D:$ZSE(dev)[dev!(+dev=dev&($ZSE(d)[d))
#endif  ; CFL185-
 ..; OPEN of existing sequential file
 ..I '$D(kwn) S sio=$IO Q
 ..I '$D(kxr("NE"))!$D(kxr("REA")) Q
 ..; Generate a backup
 ..N bak S bak=dev_".bak"
 ..I $ZSE(bak)[bak D
 ...; Backup file already exists, therefore make sure we open the
 ...; current file before deleting the backup, then delete the
 ...; backup and rename the current file to the backup name
 ...S $ZT="Odeverr^"_$T(+0) O dev C dev
 ...S $ZT="Obakerr^"_$T(+0) O bak C bak:"D"
 ..S $ZT="Odeverr^"_$T(+0) O dev C dev:("R":bak) Q
 S arg="dev"
 S:$E($G(msn,"^"))'="^" msn="^%Z"_msn
 S:$D(msn) $P(arg,":",4)="msn"
 S:$D(tmo) $P(arg,":",3)=+tmo
 S:$D(par(3)) $P(par,":",3)="par(3)"
 S:$D(par(2)) $P(par,":",2)="par(2)"
 S:$D(par(1)) $P(par,":",1)="par(1)"
 S:$D(par) $P(arg,":",2)="("_par_")"
#if $$$GLUEDEBUG
 zw
#endif
 S $ZT="Oerr^"_$T(+0) S rws=$ZU(68,2,1),crs=$ZU(68,3,1)
 O @arg U:$D(sio) dev:(0:"A") U:$D(sio) sio
 D $ZU(68,2,rws),$ZU(68,3,crs) Q
Oerr D:$D(rws) $ZU(68,2,rws) D:$D(crs) $ZU(68,3,crs)
 S $ZT="lasterr^"_$T(+0) U:$D(sio) sio G lasterr
Obakerr S $ZT="lasterr^"_$T(+0) C bak G lasterr
Odeverr S $ZT="lasterr^"_$T(+0) C dev G lasterr
 ;+
 ; USE command
 ;-
U(dev,kwn,kwv,msn) ;
 N arg,par U dev
 D:$D(kwn) ioparms("U",$ZU(96,14))
 S arg="dev"
 S:$E($G(msn,"^"))'="^" msn="^%Z"_msn
 S:$D(msn) $P(arg,":",3)="msn"
 S:$D(par(3)) $P(par,":",3)="par(3)"
 S:$D(par(2)) $P(par,":",2)="par(2)"
 S:$D(par(1)) $P(par,":",1)="par(1)"
 S:$D(par) $P(arg,":",2)="("_par_")"
#if $$$GLUEDEBUG
 zw
#endif
 S $ZT="lasterr^"_$T(+0) U @arg
 Q
 ;+
 ; ZDELETE command
 ;-
ZDELETE(rou,opt) S opt=$TR($G(opt),"so","SO")
 ZT:opt'?.1(1"O",1"S") $$$APPERROR($$$ERVALUE)
 G ZDELsrc:opt="S",ZDELobj:opt="O"
 ; Delete source and object
 S $ZT="lasterr^"_$T(+0) X "ZR  ZS "_rou
 Q
 ; Delete the source
ZDELsrc N gref S gref=$ZR
#if 0   ;APJ889+
 S $ZT="ZDELerr^"_$T(+0) K ^ROUTINE(rou,0)
#else   ;APJ889=
 D DEL^%R(rou_".INT")
#endif  ;APJ889-
 S $ZR=gref
 Q
 ; Delete the object
#if 0   ;APJ889+
 ; (must delete both then restore the source)
ZDELobj N rec,gref,msub
 S rec=0,gref=$ZR S $ZT="ZDELerr^"_$T(+0)
 S msub=$$%msub() ; Get scratch file index
 K ^mtemp(msub) M ^mtemp(msub)=^ROUTINE(rou,0)
 S $ZT="ZDELrec^"_$T(+0)
 X "S rec=1 ZR  ZS "_rou_" M ^ROUTINE(rou,0)=^mtemp(msub) S rec=0"
 K ^mtemp(msub) S $ZR=gref
 Q
ZDELrec S $ZT="ZDELerr^"_$T(+0) M:rec=1 ^ROUTINE(rou,0)=^mtemp(msub)
ZDELerr S $ZT="" K:$G(msub)'="" ^mtemp(msub)
 S $ZR=gref ; restore naked reference
 G lasterr
#include ISCmsub
#else   ;APJ889=
ZDELobj N gref S gref=$ZR D DEL^%R(rou_".OBJ") S $ZR=gref
 Q
#endif  ;APJ889-
 ;+
 ; ZUSE command
 ;-
ZU(dev,kwn,kwv) ;
#if $$$GLUEDEBUG
 zw
#endif
 Q
 ;+
 ; ZQUIT handler when no $ZTRAP handlers left on call stack
 ;-
ZQhandler U $P W !,$ZE Q
 ;+
 ; Generate an ERUNIMP error at the application level
 ;-
erunimp ZT $$$APPERROR($$$ERUNIMP)
 ;+
 ; Generate value suitable for indirection
 ;
 ;    Quote it if it's a string, doubling any quotes that 
 ;    may be a part of its string value
 ;-
#if 0   ; CDS227+
indvalu(val) Q:val=+val val
#else   ; CDS227=
indvalu(val) Q:val=$NUM(val)&(val'="") val
#endif  ; CDS227-
 N i,ch F i=1:1 S ch=$E(val,i) Q:ch=""  I ch="""" S $E(val,i)="""""" S i=i+1
 Q """"_val_""""
 ;+
 ; Parse DSM I/O keyword parameters
 ;
 ;    explicit input:
 ;
 ;       com     command code of command being processed
 ;       typ     device type number of device (see keyword table)
 ;
 ;    implicit input:
 ;
 ;       dev     device specification
 ;       kwn     keyword name array
 ;       kwv     keyword value array
 ;
 ;    implicit output (set by action strings):
 ;
 ;       par(n)  ISM positional parameter n
 ;       %       JOB command DATA keyword value
 ;
 ;    temporary variable usage:
 ;
 ;       t0      keyword table record
 ;
 ;       Notes.  MUST preserve $TEST! 
 ;
 ;               action routines will use t0 !!!
 ;-
ioparms(com,typ,kxr) N act,i,j,t0
 F i=1:1:kwn S act=0 D  ZT:'act $$$APPERROR($$$ERUNIMP)
 .S t0=$T(@(com_kwn(i))) Q:t0=""  Q:$P(t0,";",3)'[typ
 .S act($P(t0,";",4)*100+i)=$P(t0,";",5),(act,kxr(kwn(i)))=i Q
#if $$$GLUEDEBUG
 zw
#endif
 S j="" F  S j=$O(act(j)) Q:j=""  S i=j#100 X act(j)
 Q
 ;+
 ; Report last error as an application error
 ;-
lasterr S $ZT="" ZT $$$APPERROR($$$LASTERROR)
 ;+
 ; Action routines (in alphabetical order with lowercase labels corresponding
 ;                  to uppercase keyword table labels with a % prefix)
 ;
 ;    implicit input:
 ;
 ;       dev     device specification
 ;       kwv(i)  keyword value
 ;       kxr     keyword cross reference array indexed by a full keyword name;
 ;               contains entries for all keywords specified for the command;
 ;               node values are cross reference indexes into the kwn and kwv
 ;               arrays
 ;       typ     device type number of device (available for USE command
 ;               keyword processing)
 ;       t0      temporary (scratch) variable
 ;
 ;       Notes.  MUST preserve $TEST!
 ;
 ;               USE keyword action routines may assume pertinent device is 
 ;               the current device
 ;
 ;-
%crename i $$$ISWINDOWS Q:$D(kxr("DE"))  S par(1)=$G(par(1))_"R" S par(2)=kwv(i)
#if 0   ; CFL220+
 i $$$ISWINDOWS Q:$ZSE(kwv(i))[kwv(i)
 i $$$ISWINDOWS S $ZT="%crenerr^"_$T(+0) O kwv(i):"R" C kwv(i):"D" Q
 i '$$$ISWINDOWS ZT $$$APPERROR($$$ERUNIMP)
#else   ; CFL220=
 Q:$$$ISWINDOWS  ZT $$$APPERROR($$$ERUNIMP)
#endif  ; CFL220-
 
%crenerr S $ZT="lasterr^"_$T(+0) C kwv(i) G lasterr
 ;
#if 0   ; JLC537+
%oread i $$$ISWINDOWS ZT:$ZSE(dev)'[$ZCVT(dev,"L") $$$APPERROR($$$ERNOPEN)
#else   ; JLC537=
%oread i $$$ISWINDOWS ZT:$ZCVT($ZSE(dev),"L")'[$ZCVT(dev,"L") $$$APPERROR($$$ERNOPEN)
#endif  ; JLC537-
 i $$$ISWINDOWS S par(1)=$G(par(1))_"R"
 i '$$$ISWINDOWS ZT $$$APPERROR($$$ERUNIMP)
 Q
 ;
%uclearscr W $C(27)_"[J" Q
 ;
%udevtype N ps,len S len=$L(kwv(i)) ZT:len>255 $$$APPERROR($$$ERVALUE)
 S ps=$ZU(96,6,1+len) ZT:'ps $$$APPERROR($$$ERSTORE)
 V ps:-3:-1-len:$C(len)_kwv(i) Q  
 ;
%udownscro W $C(27)_"M" S:$Y>0 $Y=$Y-1 Q
 ;
%ueraselin W $C(27)_"[K" Q
 ;
%unotype Q:'$ZBOOLEAN($ZU(96,15),8,1)  
 S par(2)=$G(par(2))_"+F" Q:$ZU(96,15,$ZBOOLEAN($ZU(96,15),4,7))  Q
 ;
%utype Q:'$ZBOOLEAN($ZU(96,15),8,1)  
 S par(2)=$G(par(2))_"-F" Q:$ZU(96,15,$ZBOOLEAN($ZU(96,15),4,2))  Q
 ;
%uupscroll W $C(27)_"D" S $Y=$Y+1 Q
 ;
%ux S t0=kwv(i) ZT:t0<0!(t0>255) $$$APPERROR($$$ERVALUE) S $X=t0
 W:'$ZBOOLEAN($ZU(96,15),2,1) $C(27)_"["_($Y+1)_";"_(t0+1)_"H" Q
 ;
%uy S t0=kwv(i) ZT:t0<0!(t0>255) $$$APPERROR($$$ERVALUE) S $Y=t0
 W:'$ZBOOLEAN($ZU(96,15),2,1) $C(27)_"["_(t0+1)_";"_($X+1)_"H" Q
 ;+
 ; Keyword table record format: 
 ;
 ;   <label>;;<devtypes>;<exeorder>;<action>
 ;
 ;    where  label    = command abbreviation concatenated with keyword 
 ;                      abbreviation
 ;                      egs. 
 ;                        UDO is U for USE concatenated with DO for DOWNSCROLL
 ;                        OSH is O for OPEN concatenated with SH for SHARED
 ;                      possible command abbreviations:
 ;                        C  = CLOSE
 ;                        J  = JOB
 ;                        O  = OPEN
 ;                        U  = USE
 ;                        ZU = ZUSE
 ;           devtypes = device type numbers of pertinent devices delimited by
 ;                      dots (.):
 ;                         0 (DTSQ)    = sequential file
 ;                         1 (DTTT)    = terminal
 ;                         2 (DTSPOOL) = spool
 ;                         3 (DTMT)    = magtape
 ;                         etc... (see iod.h for others)
 ;           exeorder = execution precedence order of the action string
 ;           action   = actions to be taken to handle the keyword
 ;-
CDE ;;0;2;S par(1)="D" K par(2)
CNODELETE ;;0;3;S:$G(par(1))'="R" par(1)="-D"
CPR ;;0;1;G erunimp
CQU ;;0;1;G erunimp
CSP ;;0;1;G erunimp
CSU ;;0;1;G erunimp
CUI ;;0;1;G erunimp
CREN ;;0;1;G %crename
JI ;;;1;S par(3)=kwv(i)
JOU ;;;1;S par(4)=kwv(i)
JE ;;;1;Q  G erunimp
JDE ;;;1;Q
JP ;;;1;Q  G erunimp
JN ;;;1;Q  G erunimp
JDA ;;;1;S %=kwv(i),par(2)=1
JOP ;;;1;Q  G erunimp
OAL ;;0;1;Q
OBL ;;0.1;1;Q
OCON ;;0;1;Q
ODE ;;0;1;S par(1)=$G(par(1))_"D"
OEX ;;0;1;Q
ONE ;;0;1;S par(1)=$G(par(1))_"N"
ONOSE ;;0;1;G erunimp
OPHYSDEV ;;0.1.2.3.4.5.6.7.8.9.10.11.12;1;G erunimp
OPR ;;0;1;G erunimp
OREA ;;0;1;G %oread
OREC ;;0.2.3;1;S par(2)=kwv(i)
OSH ;;0.1;1;G erunimp
ONOSH ;;0;2;G erunimp
OSP ;;0;1;G erunimp
OSU ;;0;1;G erunimp
OUI ;;0;1;G erunimp
UCA ;;1;1;G erunimp
UNOCA ;;1;1;Q
UCE ;;1;1;S par(2)=$G(par(2))_"+B"
UNOCE ;;1;2;S par(2)=$G(par(2))_"-B"
UCL ;;1;4;G:i=kxr("CL") %uclearscr Q
UCO ;;1;1;S par(2)=$G(par(2))_"+U"
UNOCO ;;1;2;S par(2)=$G(par(2))_"-U"
UCT ;;1;1;G erunimp
UCU ;;1;1;Q:$ZU(96,15,$ZBOOLEAN($ZU(96,15),2,2))  
UNOCU ;;1;2;Q:$ZU(96,15,$ZBOOLEAN($ZU(96,15),2,7))  
UDEVTYPE ;;0.1.2.3.4.5.6.7.8.9.10.11.12;1;D %udevtype
UDI ;;0.1;1;G:typ=1 erunimp S par(1)=0,par(2)="A"
UDO ;;1;7;G:i=kxr("DO") %udownscro Q
UDT ;;1;1;G erunimp
UNODT ;;1;1;G erunimp
UEC ;;1;2;S par(2)=$G(par(2))_"-S"
UNOEC ;;1;1;S par(2)=$G(par(2))_"+S"
UER ;;1;5;G:i=kxr("ER") %ueraselin Q
UES ;;1;2;Q
UNOES ;;1;1;G erunimp
UFI ;;1;1;G erunimp
UFL ;;1;1;Q
UFO ;;1;1;G erunimp
UNOFO ;;1;2;G erunimp
ULINE ;;1;1;S par(2)=$G(par(2))_"+R"
UNOLINE ;;1;2;S par(2)=$G(par(2))_"+N"
ULO ;;1;2;G erunimp
UNOLO ;;1;1;G erunimp
UPA ;;1;1;Q
UNOPA ;;1;2;Q
UPASTHRU ;;1;1;S par(2)=$G(par(2))_"+I"
UNOPASTHR ;;1;2;S par(2)=$G(par(2))_"-I"
UREADPF ;;1;1;S t0=$ZU(96,15,$ZBOOLEAN($ZU(96,15),8,2)) G %utype
UNOREADPF ;;1;1;Q:$ZU(96,15,$ZBOOLEAN($ZU(96,15),8,7))  
URF ;;0;1;G erunimp
USP ;;0;1;G erunimp
UTE ;;1;2;S par(3)=kwv(i) S:'$D(par(2)) par(2)="+"
UNOTERM ;;1;1;G erunimp
UTRAP ;;0;2;G erunimp
UNOTRAP ;;0;1;G erunimp
UTRUNCATE ;;0;1;G erunimp
UTY ;;1;2;G %utype
UNOTY ;;1;3;G %unotype
UUP ;;1;6;G:i=kxr("UP") %uupscroll Q
UWI ;;1;1;S par(1)=+kwv(i)
UX ;;1;3;G:i=kxr("X") %ux Q
UY ;;1;3;G:i=kxr("Y") %uy Q
ZUSC ;;1.4;1;G erunimp
ZUBO ;;1.4;1;G erunimp
ZUTRAP ;;1.4;1;G erunimp
ZUNOTRAP ;;1.4;1;Q
#endif %LANGCdsm