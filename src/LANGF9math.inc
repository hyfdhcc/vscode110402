ROUTINE LANGF9math [Type=INC]
 ;LANGF9math.INC - CacheBasic math function routines.
 
#if 0   /*=======================Maintenance========================*/
SJ1450 11/18/03 Scott Jones, rewrote from scratch
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; CacheBasic Function Routines
 ;
 ; ABS(x)	$ZABS function 
 ; ACOS(x)	$ZARCCOS function
 ; ASIN(x)	$ZARCSIN function
 ; ATAN(x)	$ZARCTAN function
 ; ATN(x)	$ZARCTAN function
 ; COS(x)	$ZCOS function
 ; EXP(x)	$ZEXP function
 ; LOG(x)	$ZLN function
 ; SIN(x)	$ZSIN function
 ; SQR(x)	$ZSQR function
 ; TAN(x)	$ZTAN function
 ;-
#endif  /*====================End Documentation=====================*/
 
#ifndef %LANGFmath
#define %LANGFmath
 
#include GLUEDEF
 
ABS(x) public { Quit $ZABS(x) }
ACOS(x) public { Quit $ZARCCOS(x) }
ASIN(x) public { Quit $ZARCSIN(x) }
ATAN(x) public { Quit $ZARCTAN(x) }
ATN(x) public { Quit $ZARCTAN(x) }
COS(x) public { Quit $ZCOS(x) }
EXP(x) public { Quit $ZEXP(x) }
LOG(x) public { Quit $ZLOG(x)*2.30258509299404568402 }
SIN(x) public { Quit $ZSIN(x) }
SQR(x) public { Quit $ZSQR(x) }
TAN(x) public { Quit $ZTAN(x) }
#; Synonyms for old programs
ZABS(x) public { Quit $ZABS(x) }
ZARCTAN(x) public { Quit $ZARCTAN(x) }
ZCOS(x) public { Quit $ZCOS(x) }
ZEXP(x) public { Quit $ZEXP(x) }
ZLN(x) public { Quit $ZLOG(x)*2.30258509299404568402 }
ZSIN(x) public { Quit $ZSIN(x) }
ZSQR(x) public { Quit $ZSQR(x) }
ZTAN(x) public { Quit $ZTAN(x) }
#endif /* %LANGFmath */