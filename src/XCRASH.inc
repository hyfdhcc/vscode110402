ROUTINE XCRASH [Type=INC]
#if 0   /*======================Documentation=======================*/
DPB158   ; 08/07/93, Dan Smith. User-friendlier replacement for the traditional
         ; "X CRASH".  Usage: insert #include XCRASH in flow of control from
         ; top entry point.
#endif  /*====================End Documentation=====================*/
 u 0 w !,"Illegal entry point: do not call ^",$ZN," directly."
 q:$zu(41)'>2  ZTRAP "EP"
 