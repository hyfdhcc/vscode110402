ROUTINE LANGFdtm [Type=INC]
 ;%LANGFdtm.INC - DTM function routines. meb(belliveau) ; JO1041 06/12/98
  
#if 0   /*=======================Maintenance========================*/
JO1041   ;06/12/98, Jeffrey Orlin, renamed %msql* to %LANG*
MEB049 ;07/08/97, Marty Belliveau: %msqlFdtm.INC creation
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; DTM Function Routines
 ;
 ; ZZDEC(arg)                   $ZZDEC function 
 ; ZZHEX(arg)                   $ZZHEX function 
 ;
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef %LANGFdtm
#define %LANGFdtm
  
#include GLUEDEF
 
 ;+
 ; $ZZDEC function
 ;-
ZZDEC(arg,xtra...) ZT:$G(xtra,0) $$$APPERROR($$$ERFUNCT)
 S arg=arg_"" Q:$L(arg)<16 $ZHEX(arg)
 ;
 ; derived from dec function in the DTM %hex utility
 ;
 N i,x,d S arg=$ZCVT(arg,"U"),d=0
 F i=1:1:$L(arg) S x=$F("0123456789ABCDEF",$E(arg,i)) Q:'x  S d=d*16+x-2
 Q d
 ;+
 ; $ZZHEX function
 ;-
ZZHEX(arg,xtra...) ZT:$G(xtra,0) $$$APPERROR($$$ERFUNCT)
 I arg<256 Q:arg'<0 $TR($J($ZHEX(arg\1),2)," ","0")_"h" Q $$ZZHEXneg(arg)
 I arg<65536 Q $TR($J($ZHEX(arg\1),4)," ","0")_"h"
 Q $TR($J($ZHEX(arg\1#4294967296),8)," ","0")_"h"
 ;
 ; derived from hexb function in the DTM %hex utility
 ;
ZZHEXneg(arg) Q $E("0123456789ABCDEF",arg\16#16+1)_$E("0123456789ABCDEF",arg#16+1)_"h"
#endif /* %LANGFdtm */