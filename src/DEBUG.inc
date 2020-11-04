ROUTINE DEBUG [Type=INC]
#ifndef DEBUGINC
#define DEBUGINC
 
#if 0   /*=======================Maintenance========================*/
#;HYY228 12/14/98 Huayong Yang: create this file
#endif  /*=====================End Maintenance======================*/
  
#if 1
#define DEBUGMSG(%m,%v) ; %m
#else
#define DEBUGMSG(%m,%v) i $zu(9,"",%m_$s(%v="":"",1:":"_%v))
#endif
  
#endif  ;DEBUGINC