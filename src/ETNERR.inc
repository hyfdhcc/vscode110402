ROUTINE ETNERR [Type=INC]
#show
 ;ETNERR.INC CDS454 08/14/03, common to %ET and %ETN
#noshow
 
#if 0   /*=======================Maintenance========================*/
STC1661  ;09/01/09, Steve Clay Don't kill variables in ^%ETN when it errors 
CDS454   ; 08/14/03 Chuck Sorenson, add more detail
DPB114   ; 05/13/93, Dan Smith
#endif  /*=====================End Maintenance======================*/
#if 0   /*======================Documentation=======================*/
 
         ;This is part of the "safety net" for %ETN. If it executes,
         ;it makes an entry in ^ERRORS which, when displayed by %ERN,
         ;looks like this:
 
         ;17.   at 10:49 pm.   $I=|TRM|:|2084   ($X=  $Y=)
         ;     $J=1512  $ZA=   $ZB=   $ZS= ($S=)
         ;     Comment: <STORE>FORE+6^%ETN; log entry lost. (14 Aug 2003)
 
#endif  /*====================End Documentation=====================*/
         
ETNMINIM i $I(^ERRORS($P($H,",",1)))
 S ^ERRORS($P($H,",",1),^ERRORS($P($H,",",1)),"*COM")=$H_","_$ZE_"; log entry lost."
 S ^ERRORS($P($H,",",1),^ERRORS($P($H,",",1)),"*STACK",0,"V","$H")=$H,^("$I")=$I,^("$J")=$J
 Q
 