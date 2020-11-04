ROUTINE ISCJRNUTIL [Type=INC]
#ifndef ISCJRNUTILINC
#define ISCJRNUTILINC
 
#include JRNINC
 
#if 0   /*=======================Maintenance========================*/
#;HYY194 08/20/98 Huayong Yang: create this file
#endif  /*=====================End Maintenance======================*/
 
curfile() S $zt="etcurfile" Q $p($$$JRNCUR,",",2)
etcurfile Q ""
 
loginfo(msg) ;must be called from within INT (JRNSTART, JRNSWTCH)
 i $d(glo) s @glo=$g(@glo)+1,@glo@(@glo)=msg
 i $d(io) u io w !,msg
 q
 
#endif ;ISCJRNUTILINC
 