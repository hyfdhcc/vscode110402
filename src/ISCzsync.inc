ROUTINE ISCzsync [Type=INC]
#;/*=======================Maintenance=============================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;SML1183 12/25/09 Simon Li, Remove Legacy Network codes.
#;PWC676  9/23/02, Peter Cudhea-Pierce, gluecode-style error trapping
#;SJ1280 12/30/00, Scott Jones: zsync.INC creation
#;/*=====================End Maintenance===========================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef ISCzsync
#define ISCzsync
#if 0   ;PWC676+
ZSYNC(arg) public { Ztrap:$D(arg) $$$APPERROR($$$ERSYNTX) Do $ZU(87,12) Quit }
#else   ;PWC676=
ZSYNC(arg) public {
    Ztrap:$D(arg) $$$APPERROR($$$ERSYNTX) 
    Quit
zsyncer
    Set $ZT="" Ztrap $$$APPERROR($$$LASTERROR)
 }
#endif ; PWC676-
#endif