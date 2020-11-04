ROUTINE MAGTAPE [Type=INC]
#if 0   /*=======================Maintenance========================*/
STC200   ;02/26/99, Steve Clay: remove site is macro
DKA187   ;06/27/93, Keith Avery: Commonized for AlphVMS
#endif  /*=====================End Maintenance======================*/
#ifndef %magtape
#define %magtape
 
#include SITE
 
 ;define some magtape bit values:
 
#define MTlog      1
#define MTrew      2
#define MTwrt      4
#define MTerr      8
#define MThid     16
#define MTbot     32
#define MTonl     64
#define MTcon    128
#define MTbad    256
#define MTlen    512
#define MTeot   1024
#define MTcrc   4096
#define MTmrk  16384
#define MTrdy  32768
 
 ;write * arguments for controlling the tape drive
 
#define MTbspace  -1
#define MTfspace  -2
#define MTwrtmrk  -3
#define MTwblock  -4
#define MTrewind  -5
#define MTrblock  -6
#define MTrlabel  -7
#define MTwlabel  -8
#define MTwelabl  -9
#define MTunload -13
 
 ;maximum size of the mag tape buffer -- vax allows for giant ones
#define MTmaxbuf   $s($$$ISVMS:65536,1:16384)
 
 
#endif %magtape