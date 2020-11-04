ROUTINE ISCzconvert [Type=INC]
#;/*=======================Maintenance=============================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;SJ1280 12/30/00, Scott Jones: zconvert.INC creation
#;/*=====================End Maintenance============================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef ISCzconvert
#define ISCzconvert
#define SYNERR $$$APPERROR($$$ERSYNTX)
 
#; $ZCONVERT function (DTM support)
ZCONVERT(s,m) public { Ztrap:'$D(s)!'$D(m) $$$SYNERR Quit $ZCVT(s,m) }
ZCVT(s,m) public { Ztrap:'$D(s)!'$D(m) $$$SYNERR Quit $ZCVT(s,m) }
#endif