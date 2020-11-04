ROUTINE ISCQT [Type=INC]
;;ISCQT.INC   double all quotes in a string
#ifndef ISCQT
#define ISCQT
 
QT(x) Q $S(x'[$C(34):x,1:$P(x,$C(34))_$C(34,34)_$$QT($P(x,$C(34),2,$L(x)+1)))
 
#endif ISCQT
 