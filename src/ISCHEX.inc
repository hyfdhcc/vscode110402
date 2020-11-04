ROUTINE ISCHEX [Type=INC]
;ISCHEX.inc  --  hex to decimal, decimal to hex functions
 
#ifndef ISCHEX
#define ISCHEX
 
Hex(x) ;return hex value of 'x'
 I (x="")!(x'?1.N) Q "" ;not a valid decimal
 N b,z S b=x,z="" F  S z=$E("0123456789ABCDEF",b#16+1)_z,b=b\16 Q:'b
 Q z
Dec(x) ;return the decimal value of hex 'x'
 S x=$TR(x,"abcdef","ABCDEF") ;make sure it is uppercase hex digits
#if 0    ;HYY050+
 I (x="")!($TR(x,"ABCDEF")'?1.N) Q "" ;not a valid hex
#else    ;HYY050=
 I (x="")!($TR(x,"ABCDEF")'?.N) Q "" ;not a valid hex
#endif   ;HYY050-
 N b,z,f,c S z="",b=x F  S c=$E(b),b=$E(b,2,$L(b)) Q:c=""  DO  Q:'f
 . S f=$F("0123456789ABCDEF",c) I f S z=z*16+(f-2#16)
 Q z
 
#endif ISCHEX