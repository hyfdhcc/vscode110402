ROUTINE ISCDC [Type=INC]
;;ZDC.INC  -- duplicate character function
 
#ifndef ISCDC
#define ISCDC
 
DC(c,n) Q $TR($J("",n)," ",$E(c_" "))
 
#endif ISCDC