ROUTINE ROLLBAC [Type=INC]
 ;ROLLBACK ;Rollback utility - PTR; JO2068, 8/17/06
#ifndef ROLLBACKINC
#define ROLLBACKINC
 
#if 0   /*=======================Maintenance========================*/
#;JO2068  8/17/06 Jeffrey Orlin, Changed ROLLBACKREQUIRED to
#;		  LOCALROLLBACKREQUIRED for clarity
#;JO2029 04/11/06 Jeffrey Orln, add $$$ROLLBACKREQUIRED and 
#;                $$$ROLLBACKREQUIREDP(<transindex value>)
#;CFL1332 06/01/05 Carlos & Steve, replace %UTIL and %SYS.UTIL with LOGMSG
#;HYY1039 01/28/5 Huayong Yang, put back GETBEGTRAN
#;SML378 10/30/03 Simon Li, Support 'Nested' transaction with USENESTEDTRANS.
#;HYY348 09/09/99 Huayong Yang, replace ^%LOGROLLBACK with zu68 switch
#;HYY166 04/10/98 Huayong Yang, create this file
#endif  /*=====================End Maintenance======================*/
#include JRNINC
 
#;HYY348+
#define LOGROLLBACK(%msg) i $zu(68,49) d $$$LOGMSG("ROLLBACK:"_%msg,1,0)
#;HYY348-
#define ERJRN "journaling not enabled during rollback"     
 
#if 0   ;SML378+
 ;%a: journal offset of TSTART, %b: journal counter of TSTART
#define GETBEGTRANS(%a,%b) s %a=$zu(34),%b=$p(%a,",",2),%a=+%a
#else   ;SML378=
								#;HYY1039+
 ;Note that $zu(34,16,0), the essence of $$$GETBEGTRANSLEVEL with newlevel=0,
 ;doesn't return correct location of TSTART when $TLEVEL=1 and when NOT called
 ;from within ^ROLLBACK.
 ;%a: journal offset of TSTART, %b: journal counter of TSTART
#define GETBEGTRANS(%a,%b) s %a=$zu(34),%b=$p(%a,",",2),%a=+%a
								#;HYY1039-
 ;%a: journal offset of TSTART of the new level, %b: journal counter of TSTART of th enew level
 ;%c: The new transaction level will be after rollback.
#define GETBEGTRANSLEVEL(%a,%b,%c) ##continue
 s %c=$zu(34,15),%a=$zu(34,16,%c),%b=$p(%a,",",2),%a=+%a
#endif  ;SML378-
 ;having successfully flushed journal buffers, we have (of current journal):
 ;%c: counter, %f: file name, %o: offset (all synchronized)
 ;the offset preceding %o is guaranteed to be real (i.e., on disk) 
 ;$$$JRNFLUSHBUF may hang if journaling is not enabled
#define GETREALADR(%c,%f,%o) ##continue
 i '$$$JRNSTATUS s %o=0,%f="",%c=$zu(9,"",$$$ERJRN),%c=-1 i 1 ##continue
 e  f  s %c=$$$JRNCURFILECNT d  s %f=$$$JRNCURNAM q:%c=$$$JRNCURFILECNT ##continue
 . f  s %o=$$$JRNFLUSHBUF q:%o  H 1  ;flush buffers until success
#; ;JO2029+, JO2068+
 ; $$$LOCALROLLBACKREQUIRED is true if we have an open transaction which has
 ; been recorded in the journal file so we have data we can use to unwind
 ; the transaction. Even when rollback isn't required if $ZU(34) is not
 ; zero, we still have to close the transaction and release the locks.
 ;
 ; $$$LOCALROLLBACKREQUIREDP(<transindex value>) returns true/false based on
 ; any ptransindex value.
 ;
 ; These only report on local rollback, rollback on remote systems may
 ; still be required.
 ;
#define LOCALROLLBACKREQUIRED +$ZU(34,21)
#define LOCALROLLBACKREQUIREDP(%p) +$ZU(34,21,%p)
#; ;JO2029-, JO2068-
 
#endif /* ROLLBACKINC */