ROUTINE RHEADER [Type=INC]
 ;insert header comment and compile exclusion for utilities
  
#if 0   /*=======================Maintenance========================*/
STC200   ;02/27/99, Steve Clay: Removed $$$Site macro
LRS280   ;11/12/98, Lee Smith: removed VENDOR tests
LRS218   ;03/19/98, Lee Smith: reversed order of inclusion of VENDOR
   ;          and SITE to handle ThreeOne installation changes,
   ;          ^%sys -> $$$%sys, clean up
DPB122   ;06/16/93, Dan Smith: use standard copyright notice
BEB526   ;03/17/93, Ben Bishop: clean up compile check
#endif  /*=====================End Maintenance======================*/
  
#ifndef RHEADER
#define RHEADER
#include SITE
#include COPYRIGH
  
  
#endif RHEADER