ROUTINE ISCLJ [Type=INC]
;;left justify function
#ifndef ISCLJ
#define ISCLJ
 
LJ(x,n) Q ($E(x_$J("",n),1,n)_$E(x,n+1,$L(x))) ;left justify text to n chars
 
#endif ISCLJ