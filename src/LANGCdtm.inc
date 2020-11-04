ROUTINE LANGCdtm [Type=INC]
 ;%LANGCdtm.INC - DTM command routines. meb(belliveau) ; LFT1320 12/03/04
  
#if 0   /*=======================Maintenance========================*/
LFT1320 12/03/04 Laura Tillem, %LANG -> LANG
SJ1360  5/02/02 Scott Jones, removed ZWRITE from here
JO1041  6/12/98 Jeffrey Orlin, renamed %msql* to %LANG*
MEB034  5/02/97 Marty Belliveau: %msqlCdtm.INC creation
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve 
 ;               $TEST if the command being emulated does not 
 ;               update $TEST!
 ;
 ; DTM Command Routines
 ;
 ; ZDELETE(rou,opt)              ZDELETE command
 ;
 ; ZQhandler                     ZQUIT handler when no $ZTRAP
 ;                               handlers left on call stack
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef %LANGCdtm
#define %LANGCdtm
  
#include GLUEDEF
  
 ;+
 ; ZDELETE command
 ;-
ZDELETE(rou,opt) ZT:$G(opt)'?.1(1"O",1"o",1"S",1"s") $$$APPERROR($$$ERVALUE)
 S $ZT="ZDELerr" N ask D:$G(opt)=""  Q:$G(ask)="N"
 .F  D  Q:ask?1(1"Y",1"YE",1"YES",1"N",1"NO")
 ..W !,"Ok to del '",rou,"'? [YES NO] " R ask
 ..S ask=$TR(ask,"yesno","YESNO")
 S $ZT="" D ZDELETE^|"%SYS"|LANGC05(.rou,.opt)
 Q
ZDELerr S $ZT="" ZT $$$APPERROR($$$LASTERROR)
 ;+
 ; ZQUIT handler when no $ZTRAP handlers left on call stack
 ;-
ZQhandler U $P W !,$ZE Q
#endif  ; %LANGCdtm