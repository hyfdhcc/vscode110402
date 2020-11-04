ROUTINE SWITCH [Type=INC]
; %switch.inc  -- macro definitions for switch setting functions
  
#if 0   /*======================Documentation=======================*/
         ;04/08/93, Dan Smith  Current usage suggestion.  Older code
         ;can be revised to the new style when convenient.
  
         ;NOW RECOMMENDED       OLDER, style 1       OLDER, style 2
  
         #include SWITCHDEF    #include SWITCH
                ...
         ... SWSTAT(12) ...     ... SWSTAT(12)...    ...$$%swstat(12) ...
                ...
         #include SWITCH                            #include SWITCH
         #include ZYESNO, etc.                       #include ZYESNO, etc. 
#endif  /*====================End Documentation=====================*/
  
#if 0   /*=======================Maintenance========================*/
#;STC708 11/29/04 Steve Clay, cleaned
#;LRS232 07/15/98 Lee Smith, remove usage of ##vendor
#;BEB549 04/08/93 Dan Smith  %switchdef.inc creation, ifndef exclusion
#;DPB101 03/26/93 Dan Smith.  Fix word-length error.
#;BEB530 03/18/93 Ben Bishop.  Fix $ZT setting error
#;MRP301 03/01/93 Michael Pantaleo. New .INC file for SWITCH functions
#endif  /*=====================End Maintenance======================*/
  
  
#include ST
#include SWITCHDEF
#include SWITCHGET
#include SWITCHSET 
 