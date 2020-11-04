ROUTINE SHDW [Type=INC]
#ifndef SHDWINC
#define SHDWINC
 
#if 0   /*=======================Maintenance========================*/
#;HYY1930 06/04/14 Huayong Yang, add ShdwFeatureChallenge
#;HYY1875 10/03/13 Huayong Yang, add IRequestOnly
#;HYY1764 06/08/12 Huayong Yang, bump version while maintain compatibility
#;HYY1713 12/01/11 Huayong Yang, add ERSHDWSELFDB and macros for journal GUID
#;HYY1671 08/10/11 Huayong Yang, change JOB0TMOZT to pass symbol table to job
#;HYY1654 05/06/11 Huayong Yang, add ERSHDWGOTFEWERDATA
#;HYY1644 04/13/11 Huayong Yang, add ERSHDWCNI	
#;HYY1493 10/30/09 Huayong Yang, do not switch GZIP on and off
#;HYY1472 07/21/09 Huayong Yang, increase timeout for OPENJWB from 10 to 20 sec
#;HYY1444 02/24/09 Huayong Yang, Use 30-second KeepAlive for TCP
#;HYY1429 01/13/09 Huayong Yang, support stream compression on TCP RAW transfer
#;JPL719  02/19/08 John Lambert, Convert Shadowing Code from Legacy To Current COS 
#;HYY1354 10/30/07 Huayong Yang, increase timeout for OPENJWB from 3 to 10 sec
#;HYY1340 08/28/07 Huayong Yang, add macros related to shadow START/STOP
#;HYY1339 08/15/07 Huayong Yang, change INFOSHDWSTOP
#;HYY1328 06/19/07 Huayong Yang, add ERSHDWFEOF
#;HYY1078 11/15/06 Huayong Yang, add ShdwFeatureSrcJrnStat and ERSHDWSRCJRNOFF
#;HYY1278 11/04/06 Huayong Yang, support longer journal file path (new DIRLEN)
#;HYY1267 09/28/06 Huayong Yang, add ERSHDWPURGESYNC and some chkpnt macros
#;HYY1251 08/28/06 Huayong Yang, add ERSHDWDBMNT
#;HYY1254 08/26/06 Huayong Yang, add ERSHDWCHKPNTBAD
#;HYY1236 07/06/06 Huayong Yang, support SrcAckQEnd feature
#;HYY1148 09/06/05 Huayong Yang, macro for getting source cluster status
#;MXT748 08/26/05 Improve include performance for $$$ERROR
#;HYY1141 08/23/05 Huayong Yang, enable localization of error messages
#;HYY955 08/19/05 Huayong Yang, change CHECKSRVSTOP to ignore shutdown switch
#;HYY1124 07/28/05 Huayong Yang, shadow start/suspend/resume/stop
#;HYY1115 07/22/05 Huayong Yang, dynamically determine cluster shadow
#;HYY1133 07/21/05 Huayong Yang, report error opening file
#;HYY1119 06/28/5 Huayong Yang, define queries for shadowing
#;HYY1120 06/09/5 Huayong Yang, minor change to "access denied" message
#;RJW1143 06/09/5 Ron Watt, normalization of source directories in shadow database mapping
#;HYY1084 06/02/5 Huayong Yang, add INFOSHDWENDIAN
#;HYY1085 05/20/5 Huayong Yang, macros for purging shadow journal files (ver.2)
#;HYY1099 05/11/5 Huayong Yang, distinguish abort on error from stop on request
#;HYY1098 05/11/5 Huayong Yang, make network errors SEVERE
#;HYY1050 03/18/5 Huayong Yang, macros for source database status
#;HYY1035 01/14/5 Huayong Yang, macros for shadow types
#;HYY1025 12/28/4 Huayong Yang, use MSGOUT^SHDWUTIL instead of MSG^%UTIL
#;HYY995 12/18/04 Huayong Yang, add ERSHDWSYNC, ERSHDWCHKPNT*, ERSHDWDBMAPNUL
#;HYY1010 11/05/4 Huayong Yang, change TCP buffer size to 64k-1
#;LFT1320 11/02/4 Laura Tillem, %SYS.NLS
#;HYY989 09/29/04 Huayong Yang, add ERSHDWGMH
#;HYY927 05/27/04 Huayong Yang, add SHDWCLIMSGUTIL
#;HYY926 05/14/04 Huayong Yang, database server logging IP of shadow server
#;HYY866 02/05/04 Huayong Yang, new version of shadowing protocol
#;HYY851 12/24/03 Huayong Yang, check IP alias and detect none-read condition
#;RJF014 12/10/03 Ray Fucillo, fix use of 32KB buffer for shadowing
#;HYY603 03/25/03 Huayong Yang, maintaining transactional states
#;HYY757 03/20/03 Huayong Yang, fast dejournaling
#;HYY643 05/30/02 Huayong Yang, use 32KB TCP buffers for shadowing
#;CLN050 05/30/02 Huayong Yang, cleaned
#;HYY591 03/01/02 Huayong Yang, use database server cluster ID (PIJ dir)
#;HYY585 02/13/02 Huayong Yang, correct a typo ("reponding")
#;HYY573 01/15/02 Huayong Yang, server failover for cluster shadowing
#;HYY479 04/11/01 Huayong Yang, add BEGADDRTOBLK0 macro
#;HYY465 03/26/01 Huayong Yang, adapt to journal changes (big blocks)
#;HYY422 08/10/00 Huayong Yang, use correct JRNVERSION
#;HYY416 07/27/00 Huayong Yang, correct a typo involving stop flag checking
#;HYY378 11/03/99 Huayong Yang, enhance error messages and other fixes
#;HYY371 10/20/99 Huayong Yang, added ERSHDWADDR to indicate bad address
#;HYY361 10/01/99 Huayong Yang, added SHDWERSTOP macro
#;CFL178 09/29/99 Carlos Lopes, don't use up job servers with system jobs.
#;HYY294 04/01/99 Huayong Yang, change "LIT" to "UnicodeLittle"
#;HYY249 01/14/99 Huayong Yang, add 3 second timeout to OPENJRN
#;HYY228 12/14/98 Huayong Yang, enhancement to shadowing
#;HYY218 11/09/98 Huayong Yang: more SuperServer changes
#;LRS273 10/16/98 Lee Smith: change more "BIN" translation to "RAW"
#;HYY205 10/15/98 Huayong Yang: change "BIN" to "RAW"   
#;HYY158 01/21/98 Huayong Yang: add JBOPEN and make it applicable to 2.x as well as 3.x
#;HYY150 12/01/97 Huayong Yang: create this file
#endif  /*=====================End Maintenance======================*/
#include ST ;HYY422
#include %occInclude ;HYY1141
#include %occErrors  ;MXT748
  
#;HYY643+
#; TCP buffer size parameters for stream mode only
#if 0   ;RJF014+
#define TCPBUFSZ 32768
#else   ;RJF014=
#if 0   ;HYY1010+
#define TCPBUFSZ 32767
#else   ;HYY1010=
#define TCPBUFSZ 65535
#endif  ;HYY1010-
#endif  ;RJF014-
#define TCPBUFPARM ::$$$TCPBUFSZ:$$$TCPBUFSZ
								#;HYY1278+
	#; host:port:mode:terminator:inbuf:outbuf
#define TCPBUFPARMONLY (::::$$$TCPBUFSZ:$$$TCPBUFSZ)
								#;HYY1278-
								#;HYY1444+
#define SHDWTCPKeepAlive /KEEPALIVE=30
								#;HYY1444-
#;HYY643-
						#;HYY1429+,HYY1493+,HYY1764+
#define UNITCP(%a) u %a i $$SetIO^%SYS.NLS("UnicodeLittle") $$$SHDWDBGLOG("UniLit")
#define BINTCP(%a) u %a i $$SetIO^%SYS.NLS("RAW") $$$SHDWDBGLOG("Raw mode")
						#;HYY1429-,HYY1493-,HYY1764-
#;HYY643+
#define USEUNITCPS(%a) u %a:(::"s"$$$TCPBUFPARM) i $$SetIO^%SYS.NLS("UnicodeLittle")
#define USEBINTCPS(%a) u %a:(::"s"$$$TCPBUFPARM) i $$SetIO^%SYS.NLS("RAW")
#;HYY643-
    
       #;HYY465+ 
#;BLKSIZE is the size of each read/write from/to journal/shdw file in shadowing
#;It is not necessarily the size of blocks used by journal daemon in journaling
#define BLKSIZE 16384
#define JRNBLKSIZE 65536
#define NUMBLKPERJRNBLK ($$$JRNBLKSIZE/$$$BLKSIZE)
#; To be aligned, %b must be a multiple of NUMBLKPERJRNBLK 
#; if %b is 1-based endblk of a segment, the segment is end-aligned on JRNBLKSIZ
#; if %b is 0-based begblk of a segment, the segment is beg-aligned on JRNBLKSIZ
#define ISJRNBLKALIGNED(%b) ('(%b#$$$NUMBLKPERJRNBLK))
#; input %b (blknum) and return (in multiples of NUMBLKPERJRNBLK) are 1-based
#define JRNBLKALIGN(%b) (((%b+$$$NUMBLKPERJRNBLK-1)\$$$NUMBLKPERJRNBLK)*$$$NUMBLKPERJRNBLK)
#define ZEROBLK(%b) k %b s $p(%b,$c(0),$$$BLKSIZE)=$c(0)
#; similar to OPEN jrn:("rf":$$$BLKSIZE):0
#define OPENJRB(%a) $zu(78,32,%a,1,3,$$$BLKSIZE)
#; similar to OPEN jrn:("wf":$$$BLKSIZE):0
							#;HYY1354+,HYY1472+
#define OPENJWB(%a) $zu(78,32,%a,2,20,$$$BLKSIZE)
							#;HYY1354-,HYY1472-
 
#;misc. constants
       #;HYY465-
       								#;HYY1278+
	#; MsgLenVar can be either MsgLenOld or MsgLengDef
#define MSGLENG MsgLenVar
	#; length of fixed-length messages between 2007.1 and earlier version
	#; compatible with servers where LongMsg feature is not defined
#define	MsgLenOld	128
	#; default length of fixed-length messages between 2007.1's or later
	#; for servers that support LongMsg feature
#define	MsgLenDef	500
       								#;HYY1278-
#define OPENTIMEOUT 5
#define READTIMEOUT 10
#define JOBTIMEOUT 5
#define MAXERRLOGGLO 10
#define CRLF $c(13,10)
#;versions
#;better get journal version from system
       #;HYY422+
#define JRNVER $$$STjrnver
       #;HYY422-
#;HYY378+
#define JRNVER2X 6
#;HYY378-
								#;HYY1035+
#; If you make any changes, be sure to modify %Library.ShadowType accordingly.
	#; fast mode, applying changes
#define	SHDWTYPEFAST	1
	#; fast mode, not applying changes (i.e., copying files only)
#define	SHDWTYPECOPY	2
	#; compatible mode, applying changes
#define	SHDWTYPECMPT	3
	#; compatible mode, scanning changes
#define	SHDWTYPESCAN	4
	#; cluster shadow (dejournaling); a combination of 2=COPY & 1=FAST
#define	SHDWTYPECLUD	21
	#; cluster shadow (copying files)
	#; NOTE: it is not a standalone shadow type, but a component of
	#; cluster shadow, created on the fly by the dejournaler (the driver).
#define	SHDWTYPECLUc	12
								#;HYY1035-
								#;HYY1340+
	#; SHDWLOCVER is different from SHDWVER in that SHDWLOCVER is the
	#; version of the data structure of the shadow, whereas SHDWVER is
	#; the version of the shadowing protocol, affecting both source
	#; and shadow. A change to SHDWLOCVER affects only the shadow side.
	#; In other words, it is possible (although unlikely) for two shadows 
	#; with different SHDWVER #'s to have same SHDWLOCVER and vice versa.
	#; The initial value, 4.01, is just an arbitrary number (>0) with
	#; a hint that it is loosely based on SHDWVER 4.
#define	SHDWLOCVER	4.01
								#;HYY1340-
								#;HYY866+
								#;HYY1764+
#define SHDWVERNUM	5
#define SHDWVER		"SHADOW.5"
#define SHDWVERMINNUM	4
#define SHDWVERMIN	"SHADOW.4"
#define	IsVersionSendQueryRaw(%ver) ($p(%ver,".",2)>4)
								#;HYY1764-
								#;HYY866-
#define SHDWVER1 "NT.1"
#define VERNUM(%v) $p(%v,".",2,$l(%v))
								#;HYY1236+
	#; server issues an acknowledgement for the $$$QEnd message from client
#define	ShdwFeatureSrcAckQEnd	1
								#;HYY1278+
	#; fixed-length messages are longer to support increased DIRLEN
#define	ShdwFeatureLongMsg	2
								#;HYY1078+
	#; source sends journal state to shadow along with caughtup message
#define ShdwFeatureSrcJrnStat	4
								#;HYY1429+
	#; Transmit source journal files in compressed form (/GZIP)
#define ShdwFeatureUseGzip	8
								#;HYY1713+
	#; Transmit the GUID of a source journal file on request
#define ShdwFeatureGetJrnGUID	16
								#;HYY1930+
	#; Challenge the source for a random # set on the shadow side to
	#; identify whether source and shadow are in the same instance.
#define ShdwFeatureChallenge	32
	#; Features is a sum of bit values corresponding to defined features
#define	SHDWFeatures		$$$ShdwFeatureSrcAckQEnd+$$$ShdwFeatureLongMsg+$$$ShdwFeatureSrcJrnStat+$$$ShdwFeatureUseGzip+$$$ShdwFeatureGetJrnGUID+$$$ShdwFeatureChallenge
								#;HYY1930+
								#;HYY1713-
								#;HYY1429-
								#;HYY1078-
								#;HYY1278-
#define	IsBitSet(%num,%bitval)	((%num)\(%bitval)#2)
								#;HYY1236-
#;Given a 0-based byte position, returns the block # in 0-based.
#define BYTE0TOBLK0(%n) ((%n)\$$$BLKSIZE)
#;Both 1-based, i.e., 1...8192 -> 1, 8193...16384 -> 2, etc.
#define BYTETOBLK(%n) ($$$BYTE0TOBLK0(%n-1)+1)
#;HYY479+
#define BEGADDRTOBLK0(%n) $s(%n:$$$BYTE0TOBLK0(%n-1),1:0)
#;HYY479-
#;log something unusual
#define SHDWSRVLOG(%s) d ERRLOG^SHDWUTIL(%s)
#define SHDWCLILOG(%s,%c) d ERRLOG^SHDWUTIL(%s,%c)
								#;HYY1141+
#define SHDWMSGUTIL(%msg,%cli) $$$LOGMSG("[SHADOWING] "_$s(%cli="":"DATABASE SERVER",1:"SHADOW SERVER ("_%cli_")")_": "_%msg,1,0)
#define SHDWCLIMSGUTIL(%status,%cli)	MSGOUT^SHDWUTIL(%status,%cli)
#define SHDWSRCMSGUTIL(%status)		MSGOUT^SHDWUTIL(%status,"")
#;job off a routine w/o process argument
       							#; CFL178+,HYY1671+
#define JOB0TMOZT(%r) j %r:(:3):$$$JOBTIMEOUT e  s shdwzerr=$$$ERSHDWJOBRTN(%r) ztrap "JOBT"
       							#; CFL178-,HYY1671-
								#;HYY1141-
#;timeout read (packet mode)
#define READTMOZT(%d,%v) u %d r %v:$$$READTIMEOUT e  s shdwzerr=$$$ERSHDWREAD(%d,%v) ztrap "READ"
#;timeout read a fixed length string (stream mode)
#define RFT(%d,%v,%l,%t) u %d r %v#%l:%t
#;read a fixed length string until timeout (useful in handshake phase,e.g. at the beginning of SND and RCV)
#define RFtZ(%d,%v,%l) $$$RFT(%d,%v,%l,$$$READTIMEOUT) e  s shdwzerr=$$$ERSHDWRDFL(%d,%v,%l) ztrap "READ"
#;read $$$MSGLENG characters until timeout
#define RftZ(%d,%v) $$$RFtZ(%d,%v,$$$MSGLENG)
#;read a fixed length string until success or stopped (%X and %L are used as temps throughout)
#if 0   ;HYY851+
#define RFtC(%d,%v,%l,%c) s %v="",%L=%l u %d f  r %X#%L:$$$READTIMEOUT s %v=%v_%X,%L=%L-$l(%X) q:'%L  %c
#else   ;HYY851=
#define RFtC(%d,%v,%l,%c) s %v="",%L=%l u %d f  r %X#%L:$$$READTIMEOUT s %v=%v_%X,%L=%L-$l(%X) q:'%L  d:'$l(%X) ReadNone^SHDWUTIL(%d,$name(%v),%l) %c
#endif  ;HYY851-
#ifdef SHDWSRV ;for server ;HYY416: swap SRV and CLI in CHECKxxxSTOP macros
#define RFtc(%d,%v,%l) $$$RFtC(%d,%v,%l,$$$CHECKSRVSTOP(port))
#else ;for client
#define RFtc(%d,%v,%l) $$$RFtC(%d,%v,%l,$$$CHECKCLISTOP(cli))
#endif
#;read $$$MSGLENG characters until success or stopped
#define Rftc(%d,%v) $$$RFtc(%d,%v,$$$MSGLENG)
#;read $$$BLKSIZE characters until sucess or stopped
#define Rbtc(%d,%v) $$$RFtc(%d,%v,$$$BLKSIZE)
#;use tcp as %d
#ifndef USESHDWUTILRTN ;use macros instead
#define rftc(%v) $$$Rftc(tcp,%v)
#define rbtc(%v) $$$Rbtc(tcp,%v)
#;compose message %s into a fixed length string
#define FXLNMSG(%s) (%s)_$$del2^%Wprim_$J("",$$$MSGLENG-$L((%s)_$$del2^%Wprim))
#else   ;USESHDWUTILRTN
#define rftc(%v) s %v=$$rftc(%v)
#define rbtc(%v) s %v=$$rbtc(%v)
#define FXLNMSG(%s) $$fxlnmsg(%s)
#endif  ;USESHDWUTILRTN
#;timeout open TCP device
#define TCPOTMO(%d,%i,%p) o %d:(%i:%p):$$$OPENTIMEOUT
#;whether system is being shut down
#define SHUTDOWNSW  ($$%swstat^SWSET(16))
#;whether server should stop
       #;HYY378+
#define CHECKSRVSTOP(%p) i +$g(^SYS("shdwsrv",0,"stop")) s shdwzerr=$$$INFOSRCDOWN(%p) ztrap "STOP" 
								#;HYY1099+
#define CHECKCLISTOP(%c) i $g(^SYS("shdwcli",%c,"stop"))<0 { s shdwzerr=$$$ERSHDWCLIABORT ztrap "ABORT" } elseif $g(^SYS("shdwcli",%c,"stop"))>0 { s shdwzerr=$$$INFOSHDWSTOP(%c) ztrap "STOP" } elseif $$$SHUTDOWNSW { s shdwzerr=$$$INFOSHDWDOWN(%c) ztrap "STOP" }
								#;HYY1099-
       #;HYY378-
#;open journal file for various purposes (read/block, write/block, record mode)
								#;HYY1133+
#; %mode=2 (write) or 4 (read)
#define SHDWEROPENFILE(%f,%mode) $s($zu(140,12,%f)<0:"no file",$zu(140,12,%f,%mode)<0:"no access",1:"misc error")
#define OPENJRNRDBLK(%f)  i '$$$OPENJRB(%f) s shdwzerr=$$$ERSHDWOFIL(%f,$$$SHDWEROPENFILE(%f,4)) ztrap "FILE"
#define OPENJRNWTBLK(%f)  i '$$$OPENJWB(%f) s shdwzerr=$$$ERSHDWOFIL(%f,$$$SHDWEROPENFILE(%f,2)) ztrap "FILE"
								#;HYY1133-
#define OPENJRNBYREC(%f,%d) s %d=$$$JRNOPEN(%f,0) i %d<0 s shdwzerr=$$$ERSHDWOJRN(%f) ztrap "FILE"
#;HYY757+
#define OPENJRNBYRECSHR(%f,%d,%s) s %d=$$$JRNOPENSHR(%f,0,%s) i %d<0 s shdwzerr=$$$ERSHDWOJRN(%f) ztrap "FILE"
#;HYY757-
#;generic error log used in an error trapper (see TRAPERR and *ZT macros etc.)
#define ETRAPLOG(%c) d ERRLOG^SHDWUTIL($ze_";"_$g(shdwzerr),%c) k shdwzerr
#;generate an error to be trapped (NB: don't put ztrap in a routine as we want to know where the error actually occurs)
       #;HYY371+
#define TRAPERR(%e) s shdwzerr=%e ztrap $$traperr^SHDWUTIL(shdwzerr)
       #;HYY371-
#;error messages with error codes; built-in COS errors have code 0
#;errors in negotiation phase:
       #;HYY378+
#define SHDWENDIAN(%end) $s(%end:"big",1:"little")_" endian"
								#;HYY1141+
#define ERSHDWVM(%srv,%cli)	$$$ERROR($$$ShadowVersionMismatch,%srv,%cli)
#define ERSHDWJV(%srv,%cli)	$$$ERROR($$$ShadowJournalMismatch,%srv,%cli)
#define ERSHDWCD(%srv,%cli)	$$$ERROR($$$ShadowConnectionDenied,%srv)
#define ERSHDWBV(%ver)     	$$$ERROR($$$ShadowVersionInvalid,%ver) 
#define ERSHDWSHR(%err)    	$$$ERROR($$$ShadowGMHEAPAllocError,%err)
#define ERSHDWGMH           	$$$ERROR($$$ShadowGMHEAPInsufficient)
#define ERSHDWMSG(%msg)     	$$$ERROR($$$ShadowMessageInvalid,%msg)
                                                                #;HYY1644+
#define ERSHDWCNI(%clunodeinfo) $$$ERROR($$$UnexpectedError,%clunodeinfo)
                                                                #;HYY1644-
#define SHDWSRCIPPORT(%cli) $s(%cli="":"",1:^SYS("shdwcli",%cli,"ip")_"/"_^SYS("shdwcli",%cli,"port"))
#define ERSHDWCLU(%cli,%oid,%nid) $s(%nid="":$$$ERROR($$$ShadowSourceNoCluster,$$$SHDWSRCIPPORT(%cli)),1:$$$ERROR($$$ShadowSourceWrongCluster,$$$SHDWSRCIPPORT(%cli),%oid))
#define ERSHDWCLUSRV	$$$ERSHDWCLU("","","")
#;timeout (network) errors:
#define ERSHDWTCPO(%dev,%host,%port)	$$$ERROR($$$ShadowTCPOpenFailed,%host,%port)
#define ERSHDWRDFL(%dev,%var,%len)	$$$ERROR($$$ShadowTCPReadTimedOut)
#define ERSHDWREAD(%dev,%var)	$$$ERSHDWRDFL(%dev,%var,0)
#define ERSHDWCLIRW(%rw)	$$$ERROR($$$ShadowSourceDisconnect,$s(%rw["<READ>":"READ",1:"WRITE"))
#define ERSHDWSRVRW(%rw,%cli)	$$$ERROR($$$ShadowServerDisconnect,$s(%rw["<READ>":"READ",1:"WRITE"),%cli)
#define ERSHDWJOBRTN(%rou)	$$$ERROR($$$ShadowJobRoutineFail,"%rou")
#define ERSHDWJOBPURGE		$$$ERROR($$$ShadowJobRoutineFail,"PURGE")
#define ERSHDWJOB		$$$ERROR($$$ShadowJobFail)
#define ERSHDWOPADMIN		$$$ERROR($$$OperationRequires,$$$AdminManageResourceName_":"_$$$PermUseName)
#define ERSHDWOPERATE		$$$ERROR($$$OperationRequires,$$$AdminOperateResourceName_":"_$$$PermUseName)
#define ERSHDWSTOPPING(%cli)	$$$ERROR($$$ShadowStopping,%cli)
#;file errors:
#define ERSHDWNJRN(%f)    $$$ERROR($$$ShadowSourceJournalFileNotExist,%f)
#define ERSHDWOJRN(%f)    $$$ERROR($$$JournalFileOpenForRecordFailed,%f)
#define ERSHDWBADF(%f)    $$$ERROR($$$ShadowJournalFileCorrupt,%f)
#define ERSHDWNEXT(%f)    $$$ERROR($$$JournalFileNextNotExist,%f)
#define ERSHDWDIFF(%f,%j) $$$ERROR($$$ShadowFileAheadOfSource,%f,%j)
#define ERSHDWADDR(%a,%f) $$$ERROR($$$ShadowFileAddressInvalid,%a,%f)
								#;HYY1327+
#define ERSHDWFEOF(%a,%f) $$$ERROR($$$ShadowFileInvalidEOF,%a,%f)
								#;HYY1327-
#define ERSHDWRJRN	  $$$ERROR($$$ShadowStartFileUndefined)
#define ERSHDWSYNC	  $$$ERROR($$$ShadowSyncFailed)
#define ERSHDWCHKPNTNUL   $$$ERROR($$$ShadowClusterStartPointUndefined)
#define ERSHDWCHKPNTINC(%p)    $$$ERROR($$$ShadowClusterStartPointIncomplete,%p)
								#;HYY1254+
#define ERSHDWCHKPNTBAD(%q)    $$$ERROR($$$ShadowClusterCheckPointBad,%q)
								#;HYY1254-
								#;HYY1251+
#define	ERSHDWDBMNT(%shdwdb,%srcdb,%jrnf) $$$ERROR($$$ShadowDatabaseMountError,%shdwdb,%srcdb,%jrnf)
								#;HYY1251-
#define ERSHDWDBMAPNUL          $$$ERROR($$$ShadowDatabaseMappingUndefined)
#define	ERSHDWSRCDBNODB(%dir)   $$$ERROR($$$ShadowSourceDatabaseNotExist,%dir)
#define	ERSHDWSRCDBNOTMNT(%dir) $$$ERROR($$$ShadowSourceDatabaseNotMounted,%dir)
#define ERSHDWSRCDBBADDIR(%dir) $$$ERROR($$$ShadowSourceDatabaseInvalid,%dir)
#define ERSHDWOFIL(%f,%err)	$$$ERROR($$$ShadowFileOpenError,%f,%err) 
#define ERSHDWPURGEINPROG(%pid) $$$ERROR($$$ShadowPurgeInProgress,%pid)
#define ERSHDWPURGENOTAPPLY	$$$ERROR($$$ShadowPurgeNotAvailable) 
								#;HYY1267+
#define ERSHDWPURGESYNC		$$$ERROR($$$ShadowPurgeNoSync)
								#;HYY1267-
								#;HYY1078+
#define	ERSHDWSRCJRNOFF		$$$ERROR($$$ShadowSourceJournalDisabled)
								#;HYY1078-
#define ERSHDWANS(%ans)		$$$ERROR($$$ShadowAnswerError,%ans) 
#define ERSHDWCLIABORT		$$$ERROR($$$ShadowAbort)
#define ERSHDWDELFILE(%f,%err)	$$$ERROR($$$JournalFileDeleteError,%f,%err)
#define	ERSHDWLOCK(%cli)	$$$ERROR($$$ShadowLockFailed,%cli)
#define ERSHDWSUSPEND(%cli,%t)	$$$ERROR($$$ShadowSuspendTimedOut,%cli,%t)
#define ERSHDWKILLJOB(%pid,%rc)	$$$ERROR($$$ShadowKillJobError,%pid,%rc)
#define ERSHDWLICENSE		$$$ERROR($$$ShadowLicenseInsufficient)
								#;HYY1340+
#define ERSHDWNOTRESUMABLE	$$$ERROR($$$ShadowNotResumable)
#define ERSHDWNOTSTARTABLE	$$$ERROR($$$ShadowNotStartable)
								#;HYY1340-
#define ERSHDWSTARTPNT(%cli)	$$$ERROR($$$ShadowStartPointUndefined,%cli)
								#;HYY1654+
#define ERSHDWGOTFEWER(%got,%f)	$$$ERROR($$$ShadowGotFewerData,%got,%f)
								#;HYY1654-
								#;HYY1713+
#define ERSHDWSELFDB(%db) 	$$$ERROR($$$ShadowDatabaseSameAsSource,%db)
								#;HYY1713-
#;not really an error; server exit log
								#;HYY1339+
#define INFOSHDWSTOP(%p) "0;INFO: suspend shadowing"
								#;HYY1339-
#define INFOSHDWDOWN(%p) "0;INFO: shut down shadowing"
#define INFOSRCDOWN(%p)  "0;INFO: database server shutdown"
#define INFOSHDWRJRN     "0;INFO: the name of journal file to shadow is reset to null for being invalid"
#define	SHDWERRISFATAL(%e)	$s($g(%e)="":0,1:$$GetSeverity^SHDWUTIL(%e)=3)
  #; update localize/errors.xml accordingly
#define SHDWERRNUMFATALBEG	1000
#define SHDWERRNUMSEVEREBEG	1070
#define SHDWERRNUMWARNBEG	1090
#define SHDWERRNUMWARNEND	1099
								#;HYY1141-
#;exit on unrecoverable errors
#define SHDWERSTOP(%e) s shdwzerr=%e ztrap "EXIT"
       #;HYY378-
#;HYY603+ ;save current open transactions before working on next journal
								#;HYY1267+
#;HYY1085: invoke purging
#define SHDWUPDAT(%cli,%addr,%tran) d savechkpnt(%cli,%addr,,.%tran),RequestPurge(%cli)
	#; update checkpoint at the beginning of a new file
#define SHDWUPDFILE(%cli,%file,%tran) d savechkpnt(%cli,0,%file,.%tran),RequestPurge(%cli)
#define SHDWSTAJRNADDR(%cli)	$p($g(^SYS("shdwcli",%cli,"at")),",",1)
#define SHDWSTAJRNFile(%cli)	$p($g(^SYS("shdwcli",%cli,"at")),",",2)
#define SHDWSTACHKPNTNUM(%cli)	$p($g(^SYS("shdwcli",%cli,"at")),",",3)
#define SHDWCLUCHKPNTNUM(%cli)	$g(^SYS("shdwcli",%cli,"chkpnt"))
#define SHDWGETCHKPNTNUM(%cli)	$s($g(^SYS("shdwcli",%cli,"type"))=$$$SHDWTYPECLUD:$$$SHDWCLUCHKPNTNUM(%cli),1:$$$SHDWSTACHKPNTNUM(%cli))
								#;HYY1267-
#;HYY603- 
								#;HYY1050+
 #; Source server converts db status, +$zu(49,dir), to a digit (or character)
 #; as follows before sending it to shadow because the protocol limits status 
 #; of each db to 1 character. To differentiate between old source db status
 #; (without this change) and new source db status (with this change), we
 #; have to use different stats that are evaluated to the same boolean value
 #; on old shadow (without this change).
 #; 
 #; +$zu(49,dir) = -3: dir is invalid spec (name too long etc.)
#define	SHDWOLDSRCDBSTATBADDIR	0
#define	SHDWSRCDBSTATBADDIR	"?"
 #; +$zu(49,dir) = 0..SFNUNDEF-1: db exists and is mounted
#define	SHDWSRCDBSTATOK		1
 #; +$zu(49,dir) = SFNUNDEF: db exists but is not mounted (no sfn for db yet)
#define	SHDWSRCDBSTATUMNT	2
 #; +$zu(49,dir) = -1: db exists and was mounted, but has been dismounted
#define	SHDWSRCDBSTATDISM	3
 #; +$zu(49,dir) = -2: db doesn't exist or cannot be read
#define	SHDWSRCDBSTATNODB	4
 #; 							#;RJW1143+
 #; directory not canonic
#define SHDWSRCDBNOTCANON	5
 #; 							#;RJW1143-
 #; a catch-all status, not supposed to correspond to any $zu(49,dir) return
#define	SHDWSRCDBSTATUNKNOWN	9
 #; 
 #; Among these values, only -3 guarantees dir can be safely ignored without
 #; the risk of skipping updates in past or future journal files. Thus, in
 #; all other cases, shadow should retain the dir entry while warning user
 #; about the possibility of a user error in the cases of SFNUNDEF, -1 and -2.
 #; Of course, even in the case of 0..SFNUNDEF-1, it is possible user enters
 #; a valid db that is not intended, but we cannot read their minds.
 #; Our job is to convey to user as much info about dir as possible and let
 #; them decide.
 #; Prior to this change, shadows issue a warning if status is 0 and
 #; record-mode shadows also skip the db entry and updates associated with it. 
 #; By converting only -3 to 0, we minimize the risk of skipping updates for
 #; record-mode shadows. In addition, the 1-1 conversion allows shadows with
 #; this change to issue warnings with more details. The tradeoff is that a 
 #; block-mode shadow without this change would issue no warning except in
 #; the worst case (-3), thus increasing the chance of not alerting user about
 #; a possible user error.
 #; note that shadows without this change evaluates status to true or false.
 #; that is, all nonzero digits are evaluated to true whereas all other 
 #; characters are evaluated to false.
 #; we could use non-digit characters to differentiate conditions that cause
 #; shadows to skip updates.
 #;
 #; for source:
 #; 							#;RJW1143+
#define	SHDWCVTSFN(%sfn) $s(%sfn=$$$SFNUNDEF:$$$SHDWSRCDBSTATUMNT,%sfn'<0:$$$SHDWSRCDBSTATOK,%sfn=-3:$$$SHDWSRCDBSTATBADDIR,%sfn=-1:$$$SHDWSRCDBSTATDISM,%sfn=-2:$$$SHDWSRCDBSTATNODB,%sfn=-86:$$$SHDWSRCDBNOTCANON,1:$$$SHDWSRCDBSTATUNKNOWN)
 #; for block-mode shadow:
#define	SHDWBLKSRCDBERSTAT(%dir,%stat) $case(%stat,$$$SHDWSRCDBSTATBADDIR:$$$ERSHDWSRCDBBADDIR(%dir),$$$SHDWOLDSRCDBSTATBADDIR:$$$ERSHDWOLDSRCDBNODIR(%dir),$$$SHDWSRCDBSTATUMNT:$$$ERSHDWSRCDBNOTMNT(%dir),$$$SHDWSRCDBSTATDISM:$$$ERSHDWSRCDBNOTMNT(%dir),$$$SHDWSRCDBSTATNODB:$$$ERSHDWSRCDBNODB(%dir),$$$SHDWSRCDBNOTCANON:$$$ERSHDWNONCANONICSRCDBDIR(%dir),:$$$ERSHDWSRCDBSTATUNKNOWN(%dir,%stat))
								#;RJW1143-
 #; for record-mode shadow:
#define	SHDWRECSRCDBERSTAT(%dir,%stat) $case(%stat,$$$SHDWSRCDBSTATBADDIR:$$$ERSHDWSKIPSRCDBBADDIR(%dir),$$$SHDWOLDSRCDBSTATBADDIR:$$$ERSHDWSKIPDIR(%dir),$$$SHDWSRCDBSTATUMNT:$$$ERSHDWSRCDBNOTMNT(%dir),$$$SHDWSRCDBSTATDISM:$$$ERSHDWSRCDBNOTMNT(%dir),$$$SHDWSRCDBSTATNODB:$$$ERSHDWSRCDBNODB(%dir),:$$$ERSHDWSRCDBSTATUNKNOWN(%dir,%stat))
								#;HYY1050-
								#;HYY1119+
#; Types of queries for shadowing
  #; get a list of database directories in canonic form and their info
#define QDatabaseList			-1
  #; get a database directory in canonic form and its info
  #; required parameter: database directory
#define QDatabaseInfo			-2
  #; get a list of cluster journal markers and their info
#define QClusterJournalMarkerList	-3
  #; get a list of cluster journal files and their info
#define QClusterJournalFileList		-4
  #; get a list of local journal markers in a journal file and their info
  #; required parameter: journal file name
#define QJournalMarkerList		-5
  #; get a list of local journal files and their info
#define QJournalFileList		-6
  #; get source journal version
#define QJournalVersion			-7
  #; convert a journal location to cluster sequence
#define QJournalLocationToClusterSequence -8
								#;HYY1148+
  #; get whether source system is clustered
  #; and whether source system is an async member (if supported) ;HYY1724
#define QIsClusterSystem		-9
								#;HYY1148-
								#;HYY1236+
  #; get a feature list
#define QFeatures			-10
								#;HYY1236-
								#;HYY1713+
  #; get the GUID of a source journal file, followed by "," and file path
#define QJournalGUID			-11
								#;HYY1713-
								#;HYY1724+
								#;HYY1930+
  #; get the value of ^SYS("shdwcli",ShadowID,"challenge") from the source
  #; followed by "," and ShadowID
#define QChallenge			-12
								#;HYY1930-
  #; UNUSED				-13
  #; get a list of mirror journal files and their info
#define QMirrorJournalFileList		-14
  #; get the mirror name, db name and guid of a mirrored database
#define QMirrorDatabaseInfo		-15
								#;HYY1724-
								#;HYY1875+
  #; For shadow class queries to request information from server.
  #; Instruct server not to treat session disconnect as an error.
#define IRequestOnly			-16
								#;HYY1875-
  #; end of request; start copying or dejournaling
  #; cannot be 0, which is taken by SHDWVERERRCPT
#define QEnd				1
  #; SHDWVERERRCPT: shadow and source are not compatible
  #; sent from shadow to source as after receiving source version
#define SHDWVERERRCPT			0
								#;HYY1119-
#; possible error codes sent from source to shadow as 'version'
  #; SHDWVERERRACC: access denied (by source)
#define SHDWVERERRACC	0
  #; SHDWVERERRBAD: bad version (by source)
#define SHDWVERERRBAD	-1
  
  #; SHDWSTATISxxx macros define virtual state of a shadow, using "stat" and
  #; "stop" values:
  #; a shadow is considered running iff it is not idling
#define SHDWSTATISRUNNING(%cli)	(+$g(^SYS("shdwcli",%cli,"stat")))
  #; a shadow is being stopped when transactions are being rolled back etc.
#define SHDWSTATISSTOPPING(%cli) ($g(^SYS("shdwcli",%cli,"stat"))=$$$SHDWSTATSTOPPING)
  #; Once in stopped state, a shadow must be started rather than resumed
#define SHDWSTATISSTOPPED(%cli)	($g(^SYS("shdwcli",%cli,"stop"),$$$SHDWOPSTOP)=$$$SHDWOPSTOP)
#define SHDWSTATISSUSPENDED(%cli) ('$$$SHDWSTATISRUNNING(%cli)&&'$$$SHDWSTATISSTOPPED(%cli))
  #; should we resume shadowing on startup if it is suspended BEFORE shutdown??
#define SHDWSTATISTORESUMEONSTU(%cli) ('$$$SHDWSTATISSTOPPED(%cli))
   
  #; SHDWSTATxxx macros define "stat" values
#define SHDWSTATSTOPPING	-2
#define SHDWSTATTRYING		-1
#define SHDWSTATIDLING		0
#define SHDWSTATPROCESSING 	1
   
  #; SHDWOPxxx macros define "stop" values
  #; Undefined means the shadow globals ^SYS("SHDWCLI") exists, but does not exist in the CPF file
#define SHDWOPRUN	0
#define SHDWOPSUSPEND	1
#define SHDWOPSTOP	2
#define SHDWOPTORESUME	$$$SHDWOPRUN
#define SHDWOPABORT	-1
#define SHDWOPUNDEFINED -2

#define SHDWSETSTOPFLAG(%cli,%value) s ^SYS("shdwcli",%cli,"stop")=%value
								#;HYY1340+ 
  #; option values for START/RESUME/RESTART
  #; option value for START can be "" (default if unspecified) or startpoint
  #; The COPY option is for cluster shadow copier, which doesn't distinguish
  #; START/RESUME/RESTART, as it doesn't maintain a checkpoint like dejournaler
  #; The TEST option is not currently used, although implemented.
#define SHDWOPTTEST	1
#define SHDWOPTCOPY	2
#define SHDWOPTRESUME	4
#define	SHDWOPTRESTART	8
  #; options for STOP/SUSPEND
#define SHDWOPTFORCE	1
#define	SHDWOPTROLLBACK	2
 
#define	CheckAdminOperateUse i '$SYSTEM.Security.Check($$$AdminOperateResourceName,$$$PermUseName) q $$$ERROR($$$AccessDenied)
#define	CheckAdminManageUse i '$SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName) q $$$ERROR($$$AccessDenied)
								#;HYY1340-
								#;HYY1724+
#if 0   ;turn on debug logging
#define	SHDWDBGLOG(%msg)	d $zu(9,"",%msg)
#else
#define	SHDWDBGLOG(%msg)
#endif
								#;HYY1724-
#endif  ;SHDWINC