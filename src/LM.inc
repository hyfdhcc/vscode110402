ROUTINE LM [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML1455 03/14/12 Simon Li, Lock escalation support.
#;TCS015 05/05/05 Simon Li, Give warning message for deletin lock with remote owner.
#;SML425 12/29/03 Simon Li, Changes to be used by $SYSTEM.Lock class.
#;SML126 06/28/01 Simon Li, Add waiter's waiting type (Parent,Exact,Child).
#;SML098 03/13/01 Simon Li, Add waiter's waiting mode.
#;SML047 7/21/00 Simon Li, include file for lock management api %LM
#endif  /*=====================End Maintenance======================*/
 ;
#ifndef LMINC
#define LMINC
 
 ; These macros handle the $LIST format data returned from $$LIST^%LM()
 ; See %LM.MAC for detail description.
#define LockCntPidDelimiter     ","
#if 0   ;SML425+
#define LockEntryCount(%d)      $LISTLENGTH(%d)
#define GetLockEntry(%d,%n)     $LIST(%d,%n)
#define GetLockContext(%e)      $LIST(%e,1)
#define GetLockInfo(%e)         $LIST(%e,2)
#define GetLockReference(%i)    $LIST(%i,1)
#define GetLockOwners(%i)       $LIST(%i,2)
#define GetTotalLockOwners(%o)  $LISTLENGTH(%o)
#define GetLockOwnerPID(%o,%n)  $LIST($LIST(%o,%n),1)
#define GetLockOwnerCntX(%o,%n) $LIST($LIST(%o,%n),2)
#define GetLockOwnerCntS(%o,%n) $LIST($LIST(%o,%n),3)
#define GetLockFlags(%i)        $LIST(%i,3)
#define GetLockWaiters(%i)      $s($LISTLENGTH(%i)>3:$LIST(%i,4),1:"")
#define GetTotalLockWaiters(%w) $LISTLENGTH(%w)
#if 0   ;SML098+
#define GetLockWaiterPID(%w,%n) $LIST(%w,%n)
#else   ;SML098=
#define GetLockWaiterPID(%w,%n) $LIST($LIST(%w,%n),1)
#define GetLockWaiterMode(%w,%n) $LIST($LIST(%w,%n),2)
#endif  ;SML098-
#;SML126+
#define GetLockWaiterType(%w,%n) $LIST($LIST(%w,%n),3)
#;SML126-
#else  ;SML425=
#define GetLockContext(%e)      %e("LockEntryNum")
#define GetLockReference(%i)    %i("FullReference")
#;SML1455
#define GetLockOwners(%i)       $LB(%i("Owner"),%i("Counts"),$G(%i("EscalateInfo")))
#define GetTotalLockOwners(%o)  $L($LIST(%o,1),",")
#define GetLockOwnerPID(%o,%n)  $P($LIST(%o,1),",",%n)
#define GetLockOwnerCnt(%o,%n)  $P($LIST(%o,2),",",%n)
#;SML1455
#define GetLockOwnerEscaInfo(%o,%n)  $P($LIST(%o,3),",",%n)
#define GetLockMode(%o)         %o("Mode")
#define GetLockFlags(%i)        %i("Flags")
#define GetLockSfn(%i)          %i("Sfn")
#define GetLockShortRef(%i)     %i("LockString")
#define GetLockWaiters(%i)      $s($d(%i("WaiterPID")):$LB(%i("WaiterPID"),%i("WaiterMode"),%i("WaiterType")),1:$LB("","",""))
#define GetTotalLockWaiters(%w) $S($LIST(%w,1)="":0,1:$L($LIST(%w,1),","))
#;SML098+
#define GetLockWaiterPID(%w,%n) $P($LIST(%w,1),",",%n)
#define GetLockWaiterMode(%w,%n) $P($LIST(%w,2),",",%n)
#;SML098-
#;SML126+
#define GetLockWaiterType(%w,%n) $P($LIST(%w,3),",",%n)
#;SML126-
#define GetLockDelKey(%o)       %o("DelKey")
#define SetUpLockData(%d,%e)    k %d m %d=@LockTmp@(%e) s %d("LockEntryNum")=%e
#endif ;SML425-
#;TCS015+
#define GetRemoteOwned(%o)       %o("RemoteOwner")
#;TCS015-
 
#endif LMINC