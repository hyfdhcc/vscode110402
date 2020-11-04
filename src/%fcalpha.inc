ROUTINE %fcalpha [Type=INC]
#IF 0    ;---------------------------------------------------------------------
 ; Routine:       %fcalpha.INC
 ; Description:   ALPHAUP fuction...
 ; Author:        Michael Pantaleo
 ; Date Started:  
 ; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
 ;
 ;    DPV849 (07/09/98) - Use new system functions
 ;    MRP507 (06/19/95) - Allow the removal of some characters before
 ;                        ALPHAUP translation...
 ;
#ENDIF   ;---------------------------------------------------------------------
ALPHAUP(val,remove) q $zcvt($zstrip(val,"*P",,",?"_$g(remove)),"U")
  