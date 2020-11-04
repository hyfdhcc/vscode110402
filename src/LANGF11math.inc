ROUTINE LANGF11math [Type=INC]
 ;LANGF11math.INC - CacheMVBasic math function routines.
 
#if 0   /*=======================Maintenance========================*/
SJ1530  6/13/04	Scott Jones, remove old entry points
SJ1462 11/21/03	Scott Jones, add Hyperbolic math functions
SJ1450 11/18/03	Scott Jones, implemented CacheMVBasic math functions
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; CacheMVBasic Function Routines
 ;
 ; COSH(x)	Hyperbolic Cosine
 ; SINH(x)	Hyperbolic Sine
 ; TANH(x)	Hyperbolic Tangent
 ;-
#endif  /*====================End Documentation=====================*/
 
#ifndef %LANGFmath
#define %LANGFmath
 
SINH(x) public { Quit ($ZEXP(x) - $ZEXP(-x))/2 }
COSH(x) public { QUIT ($ZEXP(x) + $ZEXP(-x))/2 }
TANH(x) public { Set y=$ZEXP(-x),x=$ZEXP(x) QUIT (x-y)/(x+y) }
#endif /* %LANGFmath */