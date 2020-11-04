ROUTINE SWITCHDEF [Type=INC]
;macro defines for use with %switch
 
#if 0   /*=======================Maintenance========================*/
BEB549   ;04/08/93, Ben Bishop: separate macro defines from %switch.inc
#endif  /*=====================End Maintenance======================*/
 
 
 
#define  SETSW(%sw,%val,%detail)   $$%swset(%sw,%val,%detail)
#define  SWSTAT(%sw,%detail)       $$%swstat(%sw,%detail)
#define  SET10                     $$%swset(10,1,0)
#define  CLEAR10                   $$%swset(10,0,0)
 
 