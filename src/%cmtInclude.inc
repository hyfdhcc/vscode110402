ROUTINE %cmtInclude [Type=INC]
#; %cmtInclude.inc standard include file for %cmtP* routines
 
#; Error codes first
#define LicenseLimitExceeded  10000
#define CacheScriptError      10001
#define NoSuchCMTProtocol     10002
#define NoSuchCMTFunction     10003
#define NoSuchNamespace       10004
#define NoSuchRoutine         10005
#define CannotCompileRoutine  10006
#define InvalidName           10007
#define FailedToAcquireLock   10008
#define NoSuchProcess         10009
#define PreHookError          10010
#define PostHookError         10011
#define CannotSaveRoutine     10012
 
#; Now the main macros
#define LOCALHOST                 "127.0.0.1"
#define LA(%t,%w)                 $s($l(%t)'<%w:$e(%t,1,%w),1:%t_$$NBSP(%w-$l(%t)))
#define J(%t,%w)                  $$NBSP($l($j(%t,%w))-$l(%t))_%t
#if 0  ;SML219+
#define PASSTCP(%n,%d)  (%n:24)
#else  ;SML219=
#define PASSTCP(%n,%d)  (%n:65560)
#define	IsJNETDMNOn		$zb($v(0,-1,4),4096,1)
#define	TurnOnJNETDMN	V 0:-1:4:$v(0,-1,4)+4096
#define	TurnOffJNETDMN	V 0:-1:4:$v(0,-1,4)-4096
#define	IsMBLKUSEROn	$v($zu(40,2,93),-2,1)
#define	NOJOBZSTART		$zb($v($zu(40,2,115),-2,1),2,1)
#endif ;SML219-
#define ZLC(%s)        $zlc(%s)
#define ZLA(%s)        $ZLA(%s)
#define ZLA2(%s,%p)    $ZLA(%s,%p)
#define IP2BIN(%i)     $C(+%i,$P(%i,".",2),$P(%i,".",3),$P(%i,".",4))
#define BIN2IP(%i)     $a(%i,1)_"."_$a(%i,2)_"."_$a(%i,3)_"."_$a(%i,4)
#define NOROUTINEERR   "<NOROUTINE>"
#define NOLINEERR      "<NOLINE>"
#define SOFTERR        "<ZZEX>"
#define READERR        "<READ>"
#define WRITEERR       "<WRITE>"
#define CLEARSLAVE     $ZU(112,2,6)
#define ZCVTU(%s)      $ZCVT(%s,"U")
#define LI(%s,%d)      $LI(%s,%d)
#define LL(%s)         $LL(%s)
#define LD(%s,%d)      $LD(%s,%d)
#define GETNS          $ZU(5)
#define RTNEXIST(%s)   $D(^rOBJ(%s))
#def1arg SETSEARCHPATH I $ZU(39,"^^"_$ZU(12),"^^"_$S($ZV["OpenVMS":$E($ZU(12),1,$L($ZU(12))-1)_".CACHELIB]",1:$ZU(12)_"cachelib/"))
#define CRC32(%s)      $ZCRC(%s,7)
#def1arg LB(%s)      $LB(%s)
#define UCAWARE        $ZBITGET($ZVERSION(0),1)
#define ISWIDE(%s)     $ZISWIDE(%s)
#define A2W(%s)        $ZWPACK(%s)
#define W2A(%s)        $ZWUNPACK(%s)
#define ISVALIDNAME(%n) $ZNAME(%n,1)
#define MKSTR(%s)      $S($$$ISWIDE(%s):$$$ZLC(2*$L(%s)+1)_$C(128)_$$$W2A(%s),1:$$$ZLC($L(%s)+1)_$C(0)_%s)
#define EXSTR(%s)      $S(($A(%s,5)\128)#2:$$$A2W($E(%s,6,4+$$$ZLA(%s))),1:$E(%s,6,4+$$$ZLA(%s)))
#define ENABLECAPTURE  D $ZU(82,12,1)
#define DISABLECAPTURE D $ZU(82,12,0)
#define SETNS(%s)      D $ZU(5,%s)
#define GETEXSTR(%s,%t) S %s=$$$EXSTR(%t),%t=$E(%t,$$$ZLA(%t)+5,$L(%t))
#define GETLANGMODE    $ZU(55)
#define SETLANGMODE(%m)     d $ZUTIL(55,%m)
#define MKEX(%c)        $$$ZLC(%c)_$$$ZLC(0)_$$$ZLC(0)_$$$ZLC(0)
#define MKEX2(%c,%m)    $$$ZLC(%c)_$$$MKSTR(%m)_$$$ZLC(0)_$$$ZLC(0)
#define MKEX3(%c,%m,%x) $$$ZLC(%c)_$$$MKSTR(%m)_$$$MKSTR(%x)_$$$ZLC(0)
#define SAVEINF(%n,%s)   D $ZU(67,%n,%s,$J)
#define GETINF(%n)       $ZU(67,%n,$J)
#define IO               $S($ZU(53)'="":$ZU(53),1:$I)
#define GETLICFOR(%i,%p) D $ZU(67,15,%i,$J) s %p=$$ISCCSLic^%SYS.LICENSE()
#define SINGLEUSER       $ZU(112,4,8)
#define DEVTYPE                   ""
#define MKHDR(%l,%p,%f,%1,%2,%id) $$$ZLC(%l)_$c(%p,%f,%1,%2)_$$$ZLC(%id)
#define CMTID                     4294967295
#define REPLY(%f)                 ((%f+128)#256)
#define HEADERSIZE                12
#define WAIT                      4
#define MAXBUFFER                 32700
#define MAXLONG                   4294967296
#define MKRECORD(%d)              ($$$ZLC($L(%d))_%d)
#define LASTRECORD                4294967295
#define MKLASTRECORD              $$$ZLC($$$LASTRECORD)
#define FLAG(%f)                  ($A(%Hdr,8)\%f#2)
#define FLAGrecordmode            1
#define FLAGstreammode            2
#define NEWVARLIST                %Dev,%Function,%Hdr,%Id,%Length,%Protocol,%Shutdown,%Namespace,%Tmp,%ErrorNum
#define CRLF                      $C(13,10)
#define FF                        $C(12)
#define READLN(%MSG)              R %MSG
#define READ(%MSG,%LEN)           R:%LEN>0 %MSG#%LEN S:%LEN=0 %MSG=""
#define READX(%MSG,%LEN,%TIMEOUT) R:%LEN>0 %MSG#%LEN:%TIMEOUT S:%LEN=0 %MSG=""
#define WRITE(%MSG)               W %MSG
#define WRITEX(%MSG)              W %MSG,!
#define FLUSH                     W !
#;SML994 moved to %syINET.inc #define GETPEERINFO               $A($ZU(111,0),1)_"."_$A($ZU(111,0),2)_"."_$A($ZU(111,0),3)_"."_$A($ZU(111,0),4)_":"_($A($ZU(111,0),5)*256+$A($ZU(111,0),6))
#define INITCAPTURE               U $$$IO::("^"_$ZNAME)
#define HALT        Q
#define DEBUG       0
#define LOGERROR      D BACK^%ETN
#define LN(%s)                    $$$WRITEX(%s_$C(13,10))
 
 