ROUTINE ISCSTOP [Type=INC]
;;check for stop text function
#ifndef ISCSTOP
#define ISCSTOP
 
STOP(x) S x=$$UC($E(x,1,4)) Q (x["EXIT")!(x["STOP")!(x["QUIT")!(x["HALT")!($E(x)="^")
 
#include ISCUC
 
#endif ISCSTOP