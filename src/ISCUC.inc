ROUTINE ISCUC [Type=INC]
;;uppercase function
#; LRS227 05/19/98 Lee Smith, substitute use of $TR() for case conversion
#ifndef ISCUC
#define ISCUC
 
#if 0   ; LRS227+
UC(x) Q $TR(x,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
#else   ; LRS227=
UC(x) q $zcvt(x,"u")
#endif  ; LRS227-
 
#endif ISCUC