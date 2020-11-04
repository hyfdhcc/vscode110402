ROUTINE ISCZ [Type=INC]
;;right-justify numbers with leading zero's
#ifndef ISCZ
#define ISCZ
 
Z(x,n) Q $TR($J(x\1,n)," ",0) ;leading zeros for integers
 
#endif ISCZ