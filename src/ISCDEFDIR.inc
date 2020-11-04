ROUTINE ISCDEFDIR [Type=INC]
 ;;ISCDEFDIR.INC  -- returns the current (default) directory
 
#if 0   /*=======================Maintenance========================*/ 
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;LFT1011 7/29/02 Laura Tillem, this seems to never have been finished.
#;LRS232 07/15/98 Lee Smith, remove usage of ##vendor
#;DXU001 08/16/95 David Xu: Changed MUMPS to M or Open M and M/SQL to Open M
#endif  /*=====================End Maintenance======================*/ 
 
 
#ifndef ISCDEFDIR
  #define ISCDEFDIR
  
  
DEFDIR() ;return the default (current) directory name
#if 0   ;LFT1011+
 Q "" ;Cache site -- can't do it yet
#else   ;LFT1011=
 Quit $Zutil(12,"")  
#endif  ;LFT1011-
  
#endif ISCDEFDIR