ROUTINE ISCLC [Type=INC]
;;lowercase function
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#; LRS227 05/19/98 Lee Smith, substitute use of $TR() for case conversion
#ifndef ISCLC
#define ISCLC
 
#if 0   ; LRS227+
LC(x) Q $TR(x,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
#else   ; LRS227=
LC(x) q $zcvt(x,"l")
#endif  ; LRS227-
 
#endif ISCLC