ROUTINE LANGVdsm [Type=INC]
 ;%LANGVdsm.INC - DSM special variable routines. (meb) ; JO1041 06/12/98
  
#if 0   /*=======================Maintenance========================*/
JO1041   ;06/12/98, Jeffrey Orlin, renamed %msql* to %LANG*
MEB021 ;01/24/97, Marty Belliveau: %msqlVdsm.INC creation
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; DSM Special Variable Routines
 ;
 ; ZCONTROLC            $ZCONTROLC special variable
 ; ZCONTROL             $ZCONTROLC special variable ($ZCONTROL abbrev)
 ; ZC                   $ZCONTROLC special variable ($ZC abbrev)
 ; ZDEVTYPE             $ZDEVTYPE special variable
 ; ZREFERENC            $ZREFERENCE special variable ($ZREFERENC abbre)
 ; ZREFEREN             $ZREFERENCE special variable ($ZREFEREN abbrev)
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef %LANGVdsm
#define %LANGVdsm
  
#include GLUEDEF
  
 ;+
 ; $ZCONTROLC special variable
 ;-
ZCONTROLC ;
ZCONTROL ;
ZC N zt,st,zc S zt=0
ZCretry S $ZT="ZCerr^"_$T(+0),st=$ZU(96,15),zc=$ZBOOLEAN(st,1,1)
 Q:$ZU(96,14)'=1 0 S:zc st=$ZU(96,15,$ZBOOLEAN(st,1,2)) Q zc
ZCerr S $ZT="" Q:zt 0 S zt=1 U $P G ZCretry
 ;+
 ; $ZDEVTYPE special variable
 ;-
ZDEVTYPE N len S len=$A($E($ZU(96,7))) Q:len<1 "" Q $E($ZU(96,7),2,1+len)
 ;+
 ; $ZREFERENCE special variable handling
 ;-
ZREFERENC ;
ZREFEREN Q $ZR
#endif %LANGVdsm