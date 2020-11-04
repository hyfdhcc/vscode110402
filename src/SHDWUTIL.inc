ROUTINE SHDWUTIL [Type=INC]
#ifndef SHDWUTILINC
#define SHDWUTILINC
 
#if 0   /*=======================Maintenance========================*/
#;HYY228 12/14/98 Huayong Yang, enhancement to shadowing
#endif  /*=====================End Maintenance======================*/
  
#ifdef  USESHDWUTILRTN
#ifdef  SHDWSRV ;for server
#define RFtcCODE(%l) n x,len s msg="",len=%l u tcp f  r x#len:$$$READTIMEOUT s msg=msg_x,len=len-$l(x) q:$t!'len  $$$CHECKSRVSTOP(port)
#else   ;for client
#define RFtcCODE(%l) n x,len s msg="",len=%l u tcp f  r x#len:$$$READTIMEOUT s msg=msg_x,len=len-$l(x) q:$t!'len  $$$CHECKCLISTOP(cli)
#endif  ;SHDWSRV
#;msg: input/output
rftc(msg) ;
 $$$RFtcCODE($$$MSGLENG)
 q msg
rbtc(msg) ;
 $$$RFtcCODE($$$BLKSIZE)
 q msg
fxlnstr(msg) ;
 q msg_$$del2^%Wprim_$J("",$$$MSGLENG-$L(msg_$$del2^%Wprim))
#endif  ;USESHDWUTILRTN
  
#endif  ;SHDWUTILINC