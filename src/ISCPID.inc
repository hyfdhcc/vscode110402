ROUTINE ISCPID [Type=INC]
#if 0   /*======================Documentation=======================*/
         ;ISCPID.INC
         
         ;This contains macros used to convert PIDs (Process IDs)
         ;from Decimal to Hex and vice versa for systems (like VMS)
         ;that use Hex notation outside of Open M.
#endif  /*====================End Documentation=====================*/
 
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
STC200 02/26/99 Steve Clay: Removed Site is macro
DXU001   ; 08/15/95, changed MUMPS to M or Open M and M/SQL to Open M
DKA187   ; Created ZPID.INC
#endif  /*=====================End Maintenance======================*/
 
#ifndef  ISCPID
#define  ISCPID
#include SITE
 
#if 1   ;STC200+        
#define DEC2HEXPID(%pid) $s($$$ISVMS:$ZH(+%pid),1:%pid)
#define HEX2DECPID(%pid) $s($$$ISVMS:$ZH(""_%pid),1:%pid)
#define DEC2HEXPIDSET(%pid) S %pid=$$$DEC2HEXPID(%pid)
#define HEX2DECPIDSET(%pid) S %pid=$$$HEX2DECPID(%pid)
#endif  ;STC200-        
#define D2HPID(%pid) $$$DEC2HEXPID(%pid)
#define H2DPID(%pid) $$$HEX2DECPID(%pid)
#define D2HPIDSET(%pid) $$$DEC2HEXPIDSET(%pid)
#define H2DPIDSET(%pid) $$$HEX2DECPIDSET(%pid)
 
#endif   ISCPID