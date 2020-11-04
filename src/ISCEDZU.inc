ROUTINE ISCEDZU [Type=INC]
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
 ; VGG195 - 06/2/0/95 Vadim Goldin, replace ZCHANGDIR with ZCHANGNSP
 ;          (we don't conditionalize it since ZCHANGDIR is not used
 ;     anywhere; do it just in case)  
 ; EDZU - MDA 04/12/93
 ; inlude files for $ZU functions
 
#if 0   /*=======================Maintenance========================*/ 
DXU001   ;08/16/95,David Xu: Changed MUMPS to M or Open M and M/SQL to Open M
#endif  /*=====================End Maintenance======================*/  
 
#ifndef ISCEDZU
#define ISCEDZU
         
#if 0    ;VGG195+
  #define ZCHANGDIR(%a) $ZU(5,%a)
#else    ;VGG195=
  #define ZCHANGNSP(%a) $ZU(5,%a)
#endif   ;VGG195-
 ; This one also flushes your Open M processes global vectors
  #define ZGVECFLSH $ZU(5,"")
  #define ZFULLPATH(%a) $ZU(12,%a)
  #define ZMOUNSTAT(%a) $ZU(49,%a)
  #define ZDSSTATE(%a) $ZU(63,0,%a)         
#endif   ; ISCEDZU