ROUTINE ISCstripdef [Type=INC]
;;ISCstripdef.INC    macro definition for space stripping
 
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
BEB410   ;04/29/92, Ben Bishop. added to allow easier access to strip macros
#endif  /*=====================End Maintenance======================*/
 
#ifndef ISCstripdef
#define ISCstripdef
 
#define StrHead(%a) $E(%a,$F(%a,$E($TR(%a," ")))-1,$L(%a))
#define StrTail(%a) $P(%a_$J("",$L(%a)),$J("",$L(%a)))
 
#endif ISCstripdef