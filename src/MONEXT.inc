ROUTINE MONEXT [Type=INC]
#ifndef MONEXTinc
#define MONEXTinc
 /* MONEXT.INC */
#if 0   /*=======================Maintenance========================*/
#;RFD693  12/02/11 Rob Davis, add Journal, Mirror, 'top' Process data
#;RFD581  10/28/10 Rob Davis, add newer GLOSTAT pieces
#;RFD460  06/15/09 Rob Davis, Eliminate $ZU(84) metrics use in SNMP and WMI
#;RFD453  05/06/09 Rob Davis, add ECP stats constants for $System.ECP.GetProperty() 
#;RFD393  07/24/08 Rob Davis, Add Shadow Journaling information
#;RFD353 02/06/08 Rob Davis, add SNMP/WMI alert for user applications
#;RFD350 01/25/08 Rob Davis, add SNMP traps for Ensemble
#;RFD341 12/07/07 Rob Davis, Add SNMP for Ensemble (create this file)
#endif  /*=====================End Maintenance======================*/
 
#;
#; This file contains definitions for APIs that provide accesss to
#; external system management and monitoring tools. Initially, this
#; is mostly SNMP and WMI, but could include other types of interfaces
#; and APIs that access the same type of data.
#;
#; Note that both SNMP and WMI use AgentX protocol to talk to our DLLs on 
#; Windows. And, they also share the same trap/notification/event codes.
#;
 
#; AgentX PDU codes
#define OpenPDU 1
#define ClosePDU 2
#define RegisterPDU 3
#define UnregisterPDU 4
#define GetPDU 5
#define GetNextPDU 6
#define GetBulkPDU 7
#define TestSetPDU 8
#define CommitSetPDU 9
#define UndoSetPDU 10
#define CleanupSetPDU 11
#define NotifyPDU 12
#define PingPDU 13
#define IndexAllocatePDU 14
#define IndexDeallocatePDU 15
#define AddAgentCapsPDU 16
#define RemoveAgentCapsPDU 17
#define ResponsePDU 18
#; Cache "custom" PDU codes
#define ObjectPDU 254
#define CacheStopPDU 255
#; VarBind data type codes
#define INTEGER 2
#define STRING 4
#define NULL 5
#define OID 6
#define IPADDRESS 64
#define COUNTER32 65
#define GAUGE32 66
#define TIMETICKS 67
#define OPAQUE 68
#define COUNTER64 70
#define NOSUCHOBJECT 128
#define NOSUCHINSTANCE 129
#define ENDOFMIBVIEW 130
#; Bit definitions for h.flags
#define INSTANCEREGISTRATION 0               
#define NEWINDEX 1
#define ANYINDEX 2
#define NONDEFAULTCONTEXT 3
#define NETWORKBYTEORDER 4
#; Error codes
#define noAgentXError 0
#define unsupportedContext 262
#define parseError 266
#define requestDenied 267
#define processingError 268
#; VarBind error codes (for Set errors)
#define noError 0
#define genErr 5
#define noAccess 6
#define wrongType 7
#define wrongLength 8
#define wrongEncoding 9
#define wrongValue 10
#define noCreation 11
#define inconsistentValue 12
#define resourceUnavailable 13
#define commitFailed 14
#define undoFailed 15
#define notWritable 17
#define inconsistentName 18
#; AgentX version number
#define AgentXver 1
 
#; Define Cache trap IDs
#define	TRAPstart		1
#define	TRAPstop		2
#define	TRAPdbexpand	3
#define	TRAPdbspace		4
#define	TRAPdbstatus	5
#define	TRAPdbfail		6
#define	TRAPwdstop		7
#define	TRAPwdpanic		8
#define	TRAPlocktab		9
#define	TRAPprocfail	10
#define	TRAPecpbadsvr	11
#define	TRAPecpbadcli	12
#define	TRAPauditlost	13
#define	TRAPdaemondied 	14
#define TRAPlogalert	15
#define TRAPlicense		16
#define TRAPdcpneterr	17
#define TRAPlast $$$TRAPdcpneterr
#define TRAPappalert	100

#; Define Ensemble trap IDs
#define ENSTRAPevent	1
#define ENSTRAPlast $$$ENSTRAPevent
 
#; MIB definitions used for Gets (next and fetch)
#; Define piece numbers for enterprise, application, table, row, column
#;  1   2   3      4       5          6      7   8   9  10  11  12   13
#;iso.org.dod.internet.private.enterprises.ent.app.obj.tab.row.col.index
#define MIBent 7
#define MIBapp 8
#define MIBobj 9
#define MIBtab 10
#define MIBrow 11
#define MIBcol 12
#; Define Cache table IDs
#define MIBtabCfg 1
#define MIBtabPerf 2
#define MIBtabDB 3
#define MIBtabNetCli 4
#define MIBtabNetSvr 5
#define MIBtabResSz 6
#define MIBtabBuff 7
#define MIBtabWD 8
#define MIBtabShadowSrc 9
#define MIBtabShadowDest 10
#define MIBtabJournal 11
#define MIBtabMirror 12
#define MIBtabProc 13
#define MIBtabProcG 14
#define MIBmaxtab $$$MIBtabProcG
#; RFD171
#; Define OID prefix for all private enterprise MIBs
#; "1.3.6.1.4.1" = iso.org.dod.internet.private.enterprises
#define  OIDent "1.3.6.1.4.1"
 
#; Macros for adding WMI instance values to a message
#define CIMINT(%v,%d)	s %d=%d_$zlc(%v)
#define CIMSTR(%v,%d)	s %d=%d_$zlc($l(%v))_%v
#;CIM date/time format is yyyymmddHHMMSS.mmmmmmsUUU where 'sUUU' is +/- seconds from GMT
#define CIMDATE(%v,%d)	s d=$zdt(%v,8,5),gmt=($e(d,19,20)*60)+$e(d,22,23),%d=%d_$zlc(25)_$e(d,1,8)_$e(d,10,11)_$e(d,13,14)_$e(d,16,17)_".000000"_$e(d,18)_$e("000",0,3-$l(gmt))_gmt
#define CIMNODATE(%d)   s %d=%d_$zlc(25)_"00000000000000.000000+000"
 ;
#define KB 1024 ; RFD200

#; define $P() values for $System.ECP.GetProperty()
#; "ServerStats" used for monitoring
#define ECPSGloRef			##expression($zu(40,37,0)+1)
#define ECPSGloUpdate		##expression($zu(40,37,1)+1)
#define ECPSReqRcvd			##expression($zu(40,37,2)+1)
#define ECPSReqBuff			##expression($zu(40,37,3)+1)
#define ECPSBlockSent		##expression($zu(40,37,4)+1)
#define ECPSLockGrant		##expression($zu(40,37,5)+1)
#define ECPSLockFail		##expression($zu(40,37,6)+1)
#define ECPSLockQue			##expression($zu(40,37,7)+1)
#define ECPSLockQueGrant	##expression($zu(40,37,8)+1)
#define ECPSLockQueFail		##expression($zu(40,37,9)+1)
#define ECPSByteSent		##expression($zu(40,37,10)+1)
#define ECPSByteRcvd		##expression($zu(40,37,11)+1)
#define ECPSSvrBlockPurge	##expression($zu(40,37,12)+1)
#define ECPSRoutinePurge	##expression($zu(40,37,13)+1)
#define ECPSBigKill			##expression($zu(40,37,14)+1)
#define ECPSBigString		##expression($zu(40,37,15)+1)
#; "ClientStats" used for monitoring
#define ECPCGloRef			##expression($zu(40,37,16)+1)
#define ECPCByteSent		##expression($zu(40,37,17)+1)
#define ECPCByteRcvd		##expression($zu(40,37,18)+1)
#define ECPCBlockAdd		##expression($zu(40,37,19)+1)
#define ECPCBlockBuffPurge	##expression($zu(40,37,20)+1)
#define ECPCBlockSvrPurge	##expression($zu(40,37,21)+1)	

#; piece definitions for $ZU(190,6,1)
#define	ROUREF		1
#define	ROUREFCLI	2
#define	GLOROU		3
#define	GLOROUCLI	4
#define	GLOREF		5
#define	GLOREFCLI	6
#define	LOGRD		7
#define	PHYRD		8
#define	PHYWT		9
#define	GLOSET		10
#define	GLOSETCLI	11
#define	ROULINE		12
#define WIJWRITE	13
#define	ROUMISS		14
#define	OBJHIT		15
#define	OBJMISS		16
#define	OBJLOAD		17
#define	OBJNEW		18
#define	OBJDEL		19


#; piece definitions for $ZU(190,4)
#define THROTCUR	1
#define THROTMAX	2
#define THROTCNT	3
#define UPLOCK		4
#define UPCNT		5
#define DEMONWAKE	6

#endif MONEXTinc
 