ROUTINE %syLock [Type=INC]
#;%syLock.INC  new locktab definitions  SML552 04/20/05
           
#if 0   /*=======================Maintenance========================*/
#;SML1455 03/14/12 Simon Li, Lock escalation support.
SML552 ;04/20/05 Simon Li, Remove obsolete SF2NEWLOCK,PSW2NEWLOCK and SFNETNOTIFY switches.
SML457 ;04/01/04 Simon Li, Add LockOwnerRemPID.
SML425 ;12/29/03 Simon Li, Changes to be used by $SYSTEM.Lock class.
SML322 ;01/16/03 Simon Li, Display lock entry in pending state.
SML200 ;04/16/02 Simon Li, Change definition of LockLOCALSFN from 255 to 65535 for DDM.
SML155 ;01/11/02 Simon Li, allow lock sys # greater than 255 in lock entry.
SML126 ;06/28/01 Simon Li, Add waiter's waiting type (Parent,Exact,Child).
SML103 ;03/21/01 Simon Li, Add LockMaskOffDmn to mask off dmn field in nnsfn.
SML099 ;03/14/01 Simon Li, Add checking for Delayed unlock.
SML098 ;03/13/01 Simon Li, Add waiter's waiting mode.
SML047 ;07/21/00, Simon Li, support USENEWLOCK. Use %LM API for lock.
LFT673 ;01/19/99, Laura Tillem, Fix LockREF so it doesn't truncate at
       ;          "!" (LockP2) in the data itself.
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 #; LockLocal determines if the copy of the lock table data should
 #; be kept in a local variable, or stored in a temp global
#endif  /*====================End Documentation=====================*/
  
#define LockLocal 1
  
#if 0   /*======================Documentation=======================*/
 #; $ZU(89,0,ticket) has been created to walk through the lock
 #; table.  It starts at null, and ends at null; the first '~'
 #; piece returned is the seed value for the getting the next
 #; lock entry.
  
 #; The information returned is:
 #; ticket~system#~PID~remotesys#~lock count~ZA flag~reference
  
 #; 'reference' is a string that begins with a charavter count
 #; followed by the string values.  first is the directory,
 #; second is the global name, third + on are the subscripts.
  
#endif  /*====================End Documentation=====================*/
  
#define LockP        "~"
#define LockP2        "!"
  
#define LockTicket(%d)   $P(%d,$$$LockP,1)
#define LockPID(%d)      $P(%d,$$$LockP,2)
#define LockSYS(%d)      $P(%d,$$$LockP,3)
#define LockREM(%d)      $P(%d,$$$LockP,4)
#define LockCNT(%d)      $P(%d,$$$LockP,5)
#define LockZAF(%d)      $P(%d,$$$LockP,6)
#define LockLOST(%d)     $P(%d,$$$LockP,7)
#define LockREF(%d)      $e(%d,$f(%d,$$$LockP2),$l(%d))
  
#define LockInfo(%d) $ZU(89,0,$$$LockTicket(%d))
  
#if 1   ;SML047+
#if 0  ;SML552+
#define NEWLOCKON             $ZU(68,50)
#endif ;SML552-
#define LockOrder(%d,%j,%w)   $ZU(156,1,%d,$s(%w:2,1:0),%j)
#define LockLHBaddr(%d)       $LI($LI(%d,1),1)
#define LockLHBgen(%d)        $LI($LI(%d,1),2)
#define LockLost(%d)          $ZB(+$LI($LI(%d,1),4),8,1)
#;SML322+
#define LockNeed(%d)          $ZB(+$LI($LI(%d,1),4),64,1)
#define DelockPending(%d)     $ZB(+$LI($LI(%d,1),4),32,1)
#define LockPending(%d)       $ZB(+$LI($LI(%d,1),4),512,1)
#;SML322-
#define LockNNSFN(%d)         $LI($LI(%d,2),1)
#define LockString(%d)        $LI($LI(%d,2),2)
 
#define LockTotalOwner(%d)    $LISTLENGTH($LI(%d,3))
#define LockRemOwner(%d,%e)   $LI(%d,1,2)_$LB($LI($LI(%d,3),1,%e-1)_$LI($LI(%d,3),%e+1,$LISTLENGTH($LI(%d,3))))
#define LockNewOwner(%d,%e)   $LB($LI(%d,1,2),$LB($S(%e=1:$LI($LI(%d,3),2,$LISTLENGTH($LI(%d,3)))$LI($LI(%d,3),1,%e-1)
#define LockOwner(%d,%e)      $LI($LI(%d,3),%e)
#define LockOwnerTID(%d)      $LI(%d,1)
#;SML155+
#define LockOwnerSYSID(%d)    ($LI(%d,1)\65536)
#;SML155-
#define LockOwnerPID(%d)      $S($$$LockOwnerSYSID(%d):0,1:$ZU(156,4,$LI(%d,1)#65536))
#;SML457+
#define LockOwnerRemPID(%d)    +$P($LI(%d,1),",",2)
#;SML457-
#define LockOwnerScnt(%d)     $LI(%d,2)
#define LockOwnerXcnt(%d)     $LI(%d,3)
#define LockOwnerZAXcnt(%d)   $LI(%d,4)
#if 1   ;SML099+
#define LockOwnerFlag(%d)     $LI(%d,5)
#define LockSDelayed(%f)      $ZB(+%f,16,1)
#define LockXDelayed(%f)      $ZB(+%f,32,1)
#endif  ;SML099-
 
#define LockTotalWaiters(%d)  $s($LISTLENGTH(%d)>3:$LISTLENGTH($LI(%d,4)),1:0)
#define LockWaiter(%d,%e)     $LI($LI(%d,4),%e)
#;SML155+
#define LockWaiterSYSID(%d)   ($LI(%d,1)\65536)
#;SML155-
#define LockWaiterPID(%d)     $S($$$LockWaiterSYSID(%d):0,1:$ZU(156,4,$LI(%d,1)#65536))
#if 1   ;SML098+
#define LockWaiterMode(%d)    $LI(%d,3)
#endif  ;SML098-
#;SML126+
#define	LockWaiterType(%d)    $C($LI(%d,4))
#;SML126-
 
#;SML103+
#define GetSysMgrDir          $ZU(12)
#define LockMaskOffDmn(%n)    (%n#16777216)
#;SML103-
#define Locknnsfn2dir(%d)     $ZU(156,3,%d)
#define LockPID2TID(%d)       $ZU(156,5,%d)
#define LockGetSys(%d)        (%d\65536#256)
#;SML200+
#define LockLOCALSFN          $S($ZBitget($ZVersion(0)_$C(0,0,0,0),26):65535,1:255)
#;SML200-
 
#define FormatCnt(%d)         $s(%d=0:"",1:%d)
#endif  ;SML047-
#;SML1455+ ; definition for escalate lock counters and flags.
#define LockOwnerFlag2(%d)                 $LG(%d,7)
#define LockOwnerEscalatableScnt(%d)       $LG(%d,8)
#define LockOwnerEscalatableXcnt(%d)       $LG(%d,9)
#define LockOwnerEscalatedScnt(%d)         $LG(%d,10)
#define LockOwnerEscalatedXcnt(%d)         $LG(%d,11)
#define LockOwnerDelayEscalatableScnt(%d)  $LG(%d,12)
#define LockOwnerDelayEscalatableXcnt(%d)  $LG(%d,13)
#define LockOwnerDelayEscalatedScnt(%d)    $LG(%d,14)
#define LockOwnerDelayEscalatedXcnt(%d)    $LG(%d,15)

#define LockSEscalatable(%f)    $ZB(+%f,1,1)
#define LockXEscalatable(%f)    $ZB(+%f,2,1)
#define LockSEscalated(%f)      $ZB(+%f,4,1)
#define LockXEscalated(%f)      $ZB(+%f,8,1)

#;SML1455-
 