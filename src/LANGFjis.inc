ROUTINE LANGFjis [Type=INC]
 ;%LANGFjis.INC - JIS-M function routines. meb(belliveau) ; JO1041 06/12/98
 
#if 0   /*=======================Maintenance========================*/
JO1041   ;06/12/98, Jeffrey Orlin, renamed %msql* to %LANG*
MEB021 ;01/24/97, Marty Belliveau: %msqlFjis.INC creation
#endif  /*=====================End Maintenance======================*/
 
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; JIS-M Function Routines
 ;
 ; ZPOSITION(s,f,p)             $ZPOSITION function
 ; ZPOSITIO(s,f,p)              $ZPOSITION function ($ZPOSITIO abbreviation)
 ; ZP(s,f,p)                    $ZPOSITION function ($ZP abbreviation)
 ;
 ;-
#endif  /*====================End Documentation=====================*/
 
#ifndef %LANGFjis
#define %LANGFjis
 
#include GLUEDEF
 
 ; +
 ; $ZPOSITION function (JIS-M support)
 ; -
#ifdef USEJISABBREV
ZPOSITION(s,f,p) G ZPOS
ZPOSITIO(s,f,p) G ZPOS
ZP(s,f,p) ;
#else
ZPOSITION(s,f,p) ;
#endif
ZPOS N i,cc,inc,rem,wid ZT:'$D(s)!'$D(f) $$$APPERROR($$$ERSYNTX)
 ; for efficiency express character width units in terms of fourths
 S:f<0 f=0 S f=f\1*4
 S p=$S('$D(p):8,p=1:4,p=1.25:5,p=1.5:6,p=2:8,1:$$$APPERROR($$$ERFUNCT))
 S (cc,wid,rem)=0
 F i=1:1:$L(s) Q:wid=f  D  Q:rem  S cc=i
 .S inc=$S($E(s,i)?1ZFWCHARZ:p,1:4)
 .I (wid+inc)>f S rem=(f-wid)/inc
 .E  S wid=wid+inc
#if $$$GLUEDEBUG
 zw
#endif
 Q cc+rem
#endif %LANGFjis