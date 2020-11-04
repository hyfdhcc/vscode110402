ROUTINE %fcupper [Type=INC]
#IF 0    ;---------------------------------------------------------------------
 ; Routine:       %fcupper.INC
 ; Description:   ALPHAUP fuction...
 ; Author:        Michael Pantaleo
 ; Date Started:  
 ; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
 ;
 ;    DPV849 (07/09/98) - Use new system functions
 ;
#ENDIF   ;---------------------------------------------------------------------
UPPER(val) q $zcvt(val,"U")
  