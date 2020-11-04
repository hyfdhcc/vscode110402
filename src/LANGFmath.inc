ROUTINE LANGFmath [Type=INC]
#if 0   /*=======================Maintenance========================*/
SJ1280 12/20/00	Scott Jones, directly put new math functions here
JO1042  6/12/98 Jeffrey Orlin, change %math to %MATH
JO1041  6/12/98 Jeffrey Orlin, renamed %msql* to %LANG*
JMB006  3/03/97 John Basile: Moved functions from %msqlF02 to here. 
MEB008 11/17/95 marty belliveau: add support for DTM math functions
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ;
 ; DTM Function Routines
 ;
 ; ZABS(x)               $ZABS function 
 ; ZARCCOS(x)            $ZARCCOS function
 ; ZARCSIN(x)            $ZARCSIN function
 ; ZARCTAN(x)            $ZARCTAN function
 ; ZCOS(x)               $ZCOS function
 ; ZCOT(x)               $ZCOT function
 ; ZCSC(x)               $ZCSC function
 ; ZEXP(x)               $ZEXP function
 ; ZLN(x)                $ZLN function
 ; ZLOG(x)               $ZLOG function
 ; ZPOWER(x,y)           $ZPOWER function
 ; ZSEC(x)               $ZSEC function
 ; ZSIN(x)               $ZSIN function
 ; ZSQR(x)               $ZSQR function
 ; ZTAN(x)               $ZTAN function
 ;-
#endif  /*====================End Documentation=====================*/
 
#ifndef %LANGFmath
#define %LANGFmath
 
#include GLUEDEF
 
#define SYNERR $$$APPERROR($$$ERSYNTX)
 
#; $ZABS function emulation
ZABS(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZABS(x) }
#; $ZARCCOS function emulation
ZARCCOS(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZARCCOS(x) }
#; $ZARCSIN function emulation
ZARCSIN(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZARCSIN(x) }
#; $ZARCTAN function emulation
ZARCTAN(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZARCTAN(x) }
#; $ZCOS function emulation
ZCOS(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZCOS(x) }
#; $ZCOT function emulation
ZCOT(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZCOT(x) }
#; $ZCSC function emulation
ZCSC(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZCSC(x) }
#; $ZEXP function emulation
ZEXP(x) public { Quit:'$d(x) 2.718281828459045236 Quit $ZEXP(x) }
#; $ZLN function emulation
ZLN(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZLOG(x)*2.30258509299404568402 }
#; $ZLOG function emulation
ZLOG(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZLOG(x) }
#; $ZPOWER function emulation
ZPOWER(x,y) public { Ztrap:'$d(x) $$$SYNERR Quit x**$g(y) }
#; $ZSEC function emulation
ZSEC(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZSEC(x) }
#; $ZSIN function emulation
ZSIN(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZSIN(x) }
#; $ZSQR function emulation
ZSQR(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZSQR(x) }
#; $ZTAN function emulation
ZTAN(x) public { Ztrap:'$d(x) $$$SYNERR Quit $ZTAN(x) }
#endif /* %LANGFmath */