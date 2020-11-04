ROUTINE ISCMORE [Type=INC]
;ISCMORE.inc  provides a standard 'more' line (returns POP=1 if quit)
 
#ifndef ISCMORE
#define ISCMORE
 
MORE R !,"--more--",*C I C'=10,C'=13,C'=27,C'=32,C'=63 S POP=1 Q
 I C=63 W "  Return to continue, ^ to stop" G MORE ;handle '?'
 W $C(13)_$J("",10)_$C(13) Q
 
#endif ISCMORE