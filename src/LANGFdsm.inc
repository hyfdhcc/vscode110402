ROUTINE LANGFdsm [Type=INC]
 ;%LANGFdsm.INC - DSM function routines. meb(belliveau) ; STC242 04/13/00
 
#if 0   /*=======================Maintenance========================*/
LRS854 ;11/09/04, Lee Smith, ^%MATH -> ^|"%SYS"|MATH
RFD031 ;06/07/01, Rob Davis, fix date conversion error in $zc(%CDATNUM)
STC242 ;04/13/00, Steve Clay, fix NOLINE error
JO1042   ;06/12/98, Jeffrey Orlin, change %math to %MATH
JO1041   ;06/12/98, Jeffrey Orlin, renamed %msql* to %LANG*
LRS227 ;05/19/98, Lee Smith: substitute use of $TR() for case conversion
MEB028 ;03/13/97, Marty Belliveau: %BOOLEAN $ZCALL corrections
MEB021 ;01/24/97, Marty Belliveau: %msqlFdsm.INC creation
#endif  /*=====================End Maintenance======================*/
 
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; DSM Function Routines
 ;
 ; ZC(pkg,rou,par)              $ZCALL function 
 ;
 ;                              performs emulation of the following specific 
 ;                              $ZCALLs:
 ;
 ;                              %ARCCOS   %ARCSIN   %ARCTAN   %BOOLEAN
 ;                              %CDATASC  %CDATNUM  %COS      %CTIMASC
 ;                              %CTIMNUM  %EXP      %LOG      %LOG10
 ;                              %LPC      %MAX      %MIN      %POWER
 ;                              %SIN      %SQRT     %TAN      %TRANSLATE
 ;                              %UPCASE   %UPCASEQ
 ;
 ;-
#endif  /*====================End Documentation=====================*/
 
#ifndef %LANGFdsm
#define %LANGFdsm
 
#include GLUEDEF
 
 ;+
 ; $ZCALL function
 ;-
ZC(pkg,rou,par) ;
 N act,i,rec,def
 S:'$D(pkg) pkg=$S($E(rou)="%":"ZLIB",1:"ZDSM")
 S rec=$T(@(rou_pkg)) ZT:rec="" $$$APPERROR($$$ERUNIMP)
 ZT:(par<$P(rec,";",3))!(par>$P(rec,";",4)) $$$APPERROR($$$ERPARAM)
 F i=1:1:$P(rec,";",4) D:'$D(par(i))  ;check for default parameter value
 .S def=$P(rec,";",5+i) ZT:def="R" $$$APPERROR($$$ERPARAM)
 .S:def'="" par(i)=$TR(def,"<>") Q  
 S act=$P(rec,";",5)
#if $$$GLUEDEBUG
 zw
#endif
 ZT:'$D(act) $$$APPERROR($$$ERUNIMP) S $ZT="ZCerr^"_$T(+0) Q @act
 ;
ZCerr S $ZT="" ZT $$$APPERROR($$$ERVALUE)
 ;+
 ; Utility functions (in alphabetical order)
 ;-
 ;
 ; degrees to radians
 ;
deg2rad(d) Q:d'<0&(d'>360) d/180*$$pi^|"%SYS"|MATH
 Q:d<0&(d'<-360) (d+360)/180*$$pi^|"%SYS"|MATH
 Q:d>0 (d#360)/180*$$pi^|"%SYS"|MATH
 Q (-(-d#360)+360)/180*$$pi^|"%SYS"|MATH
 ;
 ; day/month/year to $HOROLOG days
 ;
dmy2hor(d,m,y) N xd S:y<100 y=y+1900
 ZT:y<1840!(y>9999)!'m!(m>12)!'d $$$APPERROR($$$ERVALUE)
 ZT:d>$P("31;29;31;30;31;30;31;31;30;31;30;31",";",m) $$$APPERROR($$$ERVALUE)
 S d=+d,m=+m,y=+y I y=1840 ZT:m'=12!(d'=31) $$$APPERROR($$$ERVALUE) Q 0
 I '(y#4)&((y#100)!'(y#400)) S xd=(m>2)
 E  ZT:m=2&(d=29) $$$APPERROR($$$ERVALUE) S xd=0
 S d=d+$P("0;31;59;90;120;151;181;212;243;273;304;334",";",m)
#if 0	; RFD031+
 I y<2000 S y=y-1841 Q d+(y*365)+(y\4)-(y\100)+xd
 S y=y-2000,d=d+58073 Q d+(y*365)+(y+3\4)-(y-1\100)+(y-1\400)+xd
#else	; RFD031=
 Q d+((y-1841)*365)+((y-1841)\4)-((y-1801)\100)+((y-1601)\400)+xd
#endif	; RFD031-
 ;
 ; radians to degrees
 ;
rad2deg(r) Q r/$$pi^|"%SYS"|MATH*180
#if 1   ; MEB028+
 ;
 ; $ZBOOLEAN variation for numeric arguments
 ;
 ; (normalizes result to a 32 bit unsigned integer)
 ;
zb0(a1,a2,op) N rv S rv=$ZBOOLEAN(a1,a2,op)
 I rv<0 Q rv+4294967296
 I rv<4294967295 Q rv
 Q $ZBOOLEAN(rv,4294967295,1)
#endif  ; MEB028-
 ;
 ; $ZDATE variation (0 returns a date)
 ;
zd0(h,f) Q:h $ZD(h,f) Q:f=1 "12/31/1840" Q "31 Dec 1840"
 ;
 ; $ZDATE variation (all uppercase month; 0 returns a date)
 ;
zd1(h) Q:h $ZD(h,2,"-JAN-FEB-MAR-APR-MAY-JUN-JUL-AUG-SEP-OCT-NOV-DEC-")
 Q "31 DEC 1840"
 ;+
 ; Action functions (lowercase labels corresponding to external call name)
 ;-
#if 0   ; MEB028+
%boolean(x,y,m) Q:x?.N&(y?.N) $ZBOOLEAN(+x,+y,m)
 Q:x'?.N&(y'?.N) $ZBOOLEAN(x,y,m)
#else   ; MEB028=
%boolean(x,y,m) S:m=9 m=6 Q:x?.N&(y?.N) $$zb0(+x,+y,m)
 Q:x'?.N&(y'?.N) $ZBOOLEAN(x_"",y_"",m)
#endif  ; MEB028-
 Q $C(0) ;type mismatch
%cdatasc(h,f) ZT:h<0!(h>94232) $$$APPERROR($$$ERVALUE)
 S h=h\1,f=f\1 Q:f=4!(f=5) $$zd0(h,f-3) N d
 I f=1 S d=$$zd0(h,1) S:$L(d)>8 $E(d,$L(d)-3,$L(d)-2)=""
 I  S:$E(d,4)="0" $E(d,4)="" Q:$E(d)'="0" d S $E(d)="" Q d
 I f=2 S d=$TR($$zd0(h,2)," ","-") S:$L(d)>9 $E(d,$L(d)-3,$L(d)-2)=""
 I  Q:$E(d)'="0" d S $E(d)="" Q d
 I f=3 S d=$TR($$zd1(h)," ","-") S:$L(d)<10 $E(d,7)="-19"
 I  S:$E(d)="0" $E(d)=" " Q d
 ZT $$$APPERROR($$$ERVALUE)
%cdatnum(fd) N d,m,y S fd=$$%upcase(fd)
 I fd?." "1.N1"/"1.N1"/"1.N.E S m=$P(fd,"/"),d=$P(fd,"/",2),y=$P(fd,"/",3)\1
 I  Q $$dmy2hor(d,m,y)
 I fd?." "1.N1"-"3U1"-"1.N.E S d=$P(fd,"-"),y=$P(fd,"-",3)\1
 I  S m=$F("JAN-FEB-MAR-APR-MAY-JUN-JUL-AUG-SEP-OCT-NOV-DEC",$P(fd,"-",2))\4
 I  Q $$dmy2hor(d,m,y)
 I fd?." "1.N1" "3U1" "1.N.E F  Q:$E(fd)'=" "  S fd=$E(fd,2,$L(fd))
 I  S d=$P(fd," "),y=$P(fd," ",3)\1
 I  S m=$F("JAN-FEB-MAR-APR-MAY-JUN-JUL-AUG-SEP-OCT-NOV-DEC",$P(fd," ",2))\4
 I  Q $$dmy2hor(d,m,y)
 ZT $$$APPERROR($$$ERVALUE)
#if 0   ;STC242+
%ctimasc(ht,f) G:ht<0 ERVALUE N h,m,s S ht=ht\1,s=ht#60,m=ht\60,h=m\60,m=m#60
#else   ;STC242=
%ctimasc(ht,f) ZT:ht<0 $$$APPERROR($$$ERVALUE)
 N h,m,s S ht=ht\1,s=ht#60,m=ht\60,h=m\60,m=m#60
#endif  ;STC242-
 ZT:h>23 $$$APPERROR($$$ERVALUE) S:m<10 m="0"_m S:s<10 s="0"_s S f=f\1
 I f=1 S s=s_$S(h>11:" PM",1:" AM"),h=h#12 S:'h h="12" Q h_":"_m_":"_s
 I f=2 Q h_":"_m_":"_s
 I f=3 S:h<10 h="0"_h Q h_":"_m_":"_s_".00"
 I f=4 S m=m_$S(h>11:" PM",1:" AM"),h=h#12 S:'h h="12" Q h_":"_m
 ZT $$$APPERROR($$$ERVALUE)
%ctimnum(ft) N h,m,s S ft=$$%upcase(ft)
 S h=$P(ft,":"),m=$P(ft,":",2),s=$P(ft,":",3)
 ZT:m>59!(s>59) $$$APPERROR($$$ERVALUE)
 I ft?1.2N1":"2N.1(1":"2N)1(1" AM",1" PM"),h<13 S:h=12 h=0 S:ft["PM" h=h+12
 I  Q (h*3600)+(m*60)+s
 I ft?1.2N1":"2N1":"2N.1(1".".2N),h<24 Q (h*3600)+(m*60)+(s\1)
 ZT $$$APPERROR($$$ERVALUE)
%max(par) N i,max
 S max=+par(1) F i=2:1:par I $D(par(i)) S:par(i)>max max=+par(i)
 Q max
%min(par) N i,min
 S min=+par(1) F i=2:1:par I $D(par(i)) S:par(i)<min min=+par(i)
 Q min
%translate(s,ms,ts) S:$L(ms)>$L(ts) ts=ts_$J("",$L(ms)-$L(ts)) Q $TR(s,ms,ts)
#if 0   ; LRS227+
%upcase(s) Q $TR(s,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
%upcaseq(s) N i F i=1:2:$L(s,"""") S $P(s,"""",i)=$$%upcase($P(s,"""",i))
#else   ; LRS227=
%upcase(s) Q $ZCVT(s,"u")
%upcaseq(s) N i F i=1:2:$L(s,"""") S $P(s,"""",i)=$ZCVT($P(s,"""",i),"u")
#endif  ; LRS227-
 Q s
 ;+
 ; Emulated $ZCALL table
 ;
 ; record format:
 ;
 ;    <label> ;;<minpars>;<maxpars>;<action>{;<pflags>{;...}}
 ;
 ;    where  label   = concatenation of external call routine name
 ;                     and external call package name
 ;           minpars = minimum number of parameters
 ;           maxpars = maximum number of parameters
 ;           action  = return value action string
 ;           pflags  = parameter flags where
 ;                     where    R   = required (no default)
 ;                            <val> = optional, default value is val
 ;                                  = optional, default is undefined
 ;
 ;                     Note: default value cannot include ';' or '<' or '>'
 ;-
%ARCCOSZLIB ;;1;1;$$rad2deg($$acos^|"%SYS"|MATH(+par(1)));R
%ARCSINZLIB ;;1;1;$$rad2deg($$asin^|"%SYS"|MATH(+par(1)));R
%ARCTANZLIB ;;1;1;$$rad2deg($$atan^|"%SYS"|MATH(+par(1)));R
%BOOLEANZLIB ;;3;3;$$%boolean(par(1),par(2),+par(3));R;R;R
%CDATASCZLIB ;;1;2;$$%cdatasc(par(1)\1,par(2)\1);R;<1>
%CDATNUMZLIB ;;1;1;$$%cdatnum(par(1));R
%COSZLIB ;;1;1;$$cos^|"%SYS"|MATH($$deg2rad(+par(1)));R
%CTIMASCZLIB ;;1;2;$$%ctimasc(par(1)\1,par(2)\1);R;<1>
%CTIMNUMZLIB ;;1;1;$$%ctimnum(par(1));R
%EXPZLIB ;;1;1;$$exp^|"%SYS"|MATH(+par(1));R
%LOGZLIB ;;1;1;$$ln^|"%SYS"|MATH(+par(1));R
%LOG10ZLIB ;;1;1;$$log^|"%SYS"|MATH(+par(1));R
%LPCZLIB ;;1;1;$ZCYC(par(1));R
%MAXZLIB ;;2;100;$$%max(.par);R;R
%MINZLIB ;;2;100;$$%min(.par);R;R
%POWERZLIB ;;2;2;$$pwr^|"%SYS"|MATH(+par(1),+par(2));R;R
%SINZLIB ;;1;1;$$sin^|"%SYS"|MATH($$deg2rad(+par(1)));R
%SQRTZLIB ;;1;1;$$sqr^|"%SYS"|MATH(+par(1));R
%TANZLIB ;;1;1;$$tan^|"%SYS"|MATH($$deg2rad(+par(1)));R
%TRANSLATEZLIB ;;3;3;$$%translate(par(1),par(2),par(3));R;R;R
%UPCASEZLIB ;;1;1;$$%upcase(par(1));R
%UPCASEQZLIB ;;1;1;$$%upcaseq(par(1));R
#endif /* %LANGFdsm */