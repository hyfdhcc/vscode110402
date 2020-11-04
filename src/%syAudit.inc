ROUTINE %syAudit [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;STC2396  3/26/15 Steve Clay, Add DatabaseChange Event to auditing 
#;STC2260 11/21/13 Steve Clay, Remove routine location for system audit data
#;STC1927 03/30/11 Steve Clay, Log audit Description properly when auditing a Terminate event
#;WDS363 07/22/10 David Shambroom, Audit database encryption events
#;SAP1291 04/13/10 Steve Pettibone, suppress login auditing for jobs option
#;STC1698 11/10/09 Steve Clay, Let user log in if system is hung
#;STC1206 04/20/07 Steve Clay, Fix FUNCTION error in routine audit  
#;STC1117 11/17/06 Steve Clay, Truncate audit description if too long for routinechange events
#;STC1094 10/28/06 Steve Clay, Add RoutineChange and Terminate events
#;STC1006 06/01/06 Steve Clay, Security.SSLConfig audit event
#;RJW1295 5/04/06 Ron Watt, Audit Journal setting modifications.
#;STC960 01/18/06 Steve Clay, Allow numeric audit event name
#;STC945 11/09/05 Steve Clay, Set WDSTOP on Audit failure
#;STC700 11/21/04 Steve Clay, Changes for emergency access
#;RJW950 10/07/04 Ron Watt, Export/Import functions for security database objects
#;STC639 09/27/04 Steve Clay, Fix configuration change name
#;STC633 09/17/04 Steve Clay, add new audit $zu definitions
#;STC617 08/28/04 Steve Clay, Don't audit both a login failure and logout
#;STC616 08/26/04 Steve Clay, Map audit globals
#;STC610 08/18/04 Steve Clay, Update security classes to meet spec
#;STC561 03/23/04 Steve Clay, Add API's.
#;STC552 03/15/04 Steve Clay, Remove ^%NOSECURITY
#;PWC804 01/28/04 Peter Cudhea-Pierce, Audit Protection Failures
#;STC511 01/27/04 Steve Clay, Add AUDITLOGINFAILBYPASS
#;STC471 08/19/03  Steve Clay, Renamed
#endif  /*=====================End Maintenance======================*/
#; Defines for the fields in the audit record. These are the offsets
#; in the $list record.
#define AudID		1
#define AudEvent	2
#define AudEventSource	3
#define AudEventType	4
#define AudEventData	5
#define AudSystemSpec	6
#define AudProcessID	7
#define AudUsername	8
#define AudRoles	9
#define AudRoutineSpec	10
#define AudClientIP	11
#define AudClientEXE	12
#define AudTimestamp	13
#define AudDescription	14
 
#; The following are the valid AuditFlags
#define AuditFlagEffective	"EFFECTIVE"
#define AuditFlagProcess	"PROCESS"
#define AuditFlagSystem		"SYSTEM"
 
#; The following are the valid Login event codes
#define	AUDITLOGIN		1
#define	AUDITLOGINFAIL		2
#define	AUDITLOGOUT		3
 
#;$zu(179 functions)
#;These must match the defines in AUDIT.H
#define AUDITEFFECTIVE	0
#define AUDITPROCESS	1
#define AUDITSYSTEM 3
#define AUDITINITIALIZE 5
#define AUDITSYNCEVENTS 6
#define AUDITSYNCEVENTSCHECK 7
#define AUDITMINEVENTNUMBER 8
#define AUDITMAXEVENTNUMBER 9
#define AUDITNAMETONUMBER 12
#define AUDITNUMBERTONAME 13
#define AUDITSECURITYFLAGS	14
#define	AUDITGETDATABASE	15
#define	AUDITSETDATABASE	16
#define AUDITGETCOUNT		17
#define AUDITCLEARCOUNT     18
#define AUDITGETSTATE       19
#define AUDITFLAGS       	20
#define AUDITINCCOUNT		21
#define		AUDITTOTALCOUNT 	1
#define		AUDITWRITTENCOUNT	2
#define		AUDITFAILURESCOUNT	3
#;Maximum size of audit event description and data. Must be same as
#;that in audit.h 
#define MAXEVENTDESCLEN 128
#define MAXEVENTDATALEN 16384
 
#;System Sources for events
#define SourceSystem       "%System"
#;System Types for events
#define TypeDirectMode     "%DirectMode"
#define TypeLogin          "%Login"
#define TypeSecurity       "%Security"
#define TypeSystem         "%System"
#define TypeSMPExplorer    "%SMPExplorer"
#define TypeEMS            "%EMS"
#;System Names for events
#define NameDirectMode        "DirectMode"
#define NameLogin             "Login"
#define NameLoginFail         "LoginFailure"
#define NameLogout            "Logout"
#define NameApplicationChange "ApplicationChange"
#define NameAuditChange       "AuditChange"
#define NameAuditReport       "AuditReport"
#define NameDomainChange      "DomainChange"
#define NameEventChange       "EventChange"
#define NameLoginRuleChange   "LoginRuleChange"
#define NameProtect           "Protect"
#define NameResourceChange    "ResourceChange"
#define NameRoleChange        "RoleChange"
#define NameServiceChange     "ServiceChange"
#define NameSystemChange      "SystemChange"
#define NameUserChange        "UserChange"
#define NameSSLConfigChange   "SSLConfigChange"
#define NameAuditRecordLost   "AuditRecordLost"
#define NameConfigChange      "ConfigurationChange"
#define NameStart             "Start"
#define NameStop              "Stop"
#define NameUserEventOverflow "UserEventOverflow"
#define NameJournalChange	  "JournalChange"
#define NameTerminate	      "Terminate"
#define NameRoutineChange	  "RoutineChange"
#define NameDBEncChange       "DBEncChange"
#define NamePhoneProvidersChange "PhoneProvidersChange"
#define NameX509CredentialsChange "PhoneX509CredentialsChange"
#define NameOpenAMIdentityServicesChange "OpenAMIdentityServicesChange"
#define	NameSusRes				"SuspendResume"
#define	NameChange				"Change"
#define	NameViewContents		"ViewContents"
#define	NameExport				"Export"
#define	NameImport				"Import"
#define	NameExecuteQuery		"ExecuteQuery"
#define NameEMSChange           "EMSChange"
#define NameEMSError            "EMSError"
#define NameDatabaseChange		"DatabaseChange"
#define NameOSCommand			"OSCommand"
#;Flags for Events 
#define EventFlagSystem     1
#define EventFlagMandatory  2
 
#; Macros to simplify the $ZU(179) calls
 
#;The following Macros needs to change if the audit numbers get rearranged
#define RoutineAuditIsOn $zu(179,0,21)
#define SetRoutineAudit(%val) Do $zu(179,0,21,%val)
#define LoginAuditIsOn $zu(179,0,1)
#define LoginFailAuditIsOn $zu(179,0,2)
#define LogoutAuditIsOn $zu(179,0,3)
#define TerminateAuditIsOn $zu(179,0,22)

#define EventAuditIsOn(%Source,%Type,%Name) $zu(179,0,$$$NameToNumber(%Source_"/"_%Type_"/"_%Name))
 
#define AuditingIsOn ('($zu(179,$$$AUDITGETDATABASE)=""))
#define FlagToNum(%flag) $case(%flag,"EFFECTIVE":$$$AUDITEFFECTIVE,"PROCESS":$$$AUDITPROCESS,"SYSTEM":$$$AUDITSYSTEM,1:-1)
#define EventFlagGet(%flag,%event) $zu(179,$$$FlagToNum(%flag),$s(+(%event)=%event:%event,1:$$$NameToNumber(%event)))
#define EventFlagSet(%flag,%event,%value) $zu(179,$$$FlagToNum(%flag),$s(+(%event)=%event:%event,1:$$$NameToNumber(%event)),%value)
#define Initialize $zu(179,$$$AUDITINITIALIZE)
#define SyncEvents $zu(179,$$$AUDITSYNCEVENTS)
#define MinEventNumber $zu(179,$$$AUDITMINEVENTNUMBER)
#define MaxEventNumber $zu(179,$$$AUDITMAXEVENTNUMBER)
#define MinOptionNumber $zu(179,$$$AUDITMINOPTIONNUMBER)
#define MaxOptionNumber $zu(179,$$$AUDITMAXOPTIONNUMBER)
#define SyncEventsCheck $zu(179,$$$AUDITSYNCEVENTSCHECK)
#define NameToNumber(%x) $zu(179,$$$AUDITNAMETONUMBER,%x)
#define NumberToName(%x) $zu(179,$$$AUDITNUMBERTONAME,%x)
#define	GetAuditDatabase $ZU(179,$$$AUDITGETDATABASE)
#define	SwitchAuditDatabase(%x) $ZU(179,$$$AUDITSETDATABASE,%x)
#define	StopAuditing $ZU(179,$$$AUDITSETDATABASE,"")
#define	StartAuditing(%x) $ZU(179,$$$AUDITSETDATABASE,%x)
#define GetAuditCount(%x) $ZU(179,$$$AUDITGETCOUNT,%x)
#define ClearAuditCount(%x) $ZU(179,$$$AUDITCLEARCOUNT,%x)
#define IncAuditCount(%x,%num) Try {d $zu(179,$$$AUDITINCCOUNT,%x,%num)} catch {}
#define IncAuditTotalCount(%name) $$$IncAuditCount($$$NameToNumber(%name),$$$AUDITTOTALCOUNT)
#define IncAuditWrittenCount(%name) $$$IncAuditCount($$$NameToNumber(%name),$$$AUDITWRITTENCOUNT) 
#define IncAuditFailuresCount(%name) $$$IncAuditCount($$$NameToNumber(%name),$$$AUDITFAILURESCOUNT) 
#define GetAuditState $ZU(179,$$$AUDITGETSTATE)
#define GetAuditFlags $ZU(179,$$$AUDITFLAGS)
#define SetAuditFlags(%x) $ZU(179,$$$AUDITFLAGS,%x)
#define SetAllProcessAuditFlags  f i000=$zu(179,$$$AUDITMINEVENTNUMBER):1:$zu(179,$$$AUDITMAXEVENTNUMBER) i $zu(179,$$$AUDITNUMBERTONAME,i000)'="" d $zu(179,$$$AUDITPROCESS,i000,1),$zu(179,$$$AUDITEFFECTIVE,i000,1)
#define ClearAllProcessAuditFlags  f i000=$zu(179,$$$AUDITMINEVENTNUMBER):1:$zu(179,$$$AUDITMAXEVENTNUMBER) i $zu(179,$$$AUDITNUMBERTONAME,i000)'="" d $zu(179,$$$AUDITPROCESS,i000,0),$zu(179,$$$AUDITEFFECTIVE,i000,0)
#define ClearLoginProcessAuditFlags  d $zu(179,$$$AUDITEFFECTIVE,$$$AUDITLOGIN,0),$zu(179,$$$AUDITEFFECTIVE,$$$AUDITLOGINFAIL,0),$zu(179,$$$AUDITEFFECTIVE,$$$AUDITLOGOUT,0)
#define SetJournalProcessAuditFlag(%Value) $zu(179,$$$AUDITEFFECTIVE,$$$NameToNumber("%System/%System/JournalChange"),%Value)
#;Used where we want to audit routine changes. For current ns, pass ""
#;We test this event explicitly here since the call to get the routine
#;location is expensive
#define AuditRtnChange(%ns,%rtn) d $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeSystem,$$$NameRoutineChange,"",$case($$$RoutineAuditIsOn,0:"",:$e("^|^"_##Class(%SYS.Namespace).GetRoutineDest(%ns,%rtn,"OBJ")_"|"_%rtn,*-($$$MAXEVENTDESCLEN-1),*)))
#define AuditRtnDelete(%ns,%rtn) d $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeSystem,$$$NameRoutineChange,$case($$$RoutineAuditIsOn,0:"",:$$$GetMsg($$$AuditMsg,"Deleted")),$case($$$RoutineAuditIsOn,0:"",:$e("^|^"_##Class(%SYS.Namespace).GetRoutineDest(%ns,%rtn,"OBJ")_"|"_%rtn_" "_$$$GetMsg($$$AuditMsg,"Deleted"),*-($$$MAXEVENTDESCLEN-1),*)))
#define AuditRtnPurge(%ns,%rtn) d $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeSystem,$$$NameRoutineChange,$case($$$RoutineAuditIsOn,0:"",:$$$GetMsg($$$AuditMsg,"Deleted")),$case($$$RoutineAuditIsOn,0:"",:$e("^|^"_##Class(%SYS.Namespace).GetRoutineDest(%ns,%rtn,"OBJ")_"|"_%rtn_" "_$$$GetMsg($$$AuditMsg,"Purged"),*-($$$MAXEVENTDESCLEN-1),*)))
 
#; This is the global where the audit record gets stored
#define AuditHeaderSize 32500
#define CacheAuditMapping "CacheAudit*"
#define AuditDataName CacheAuditD
#define AuditHeaderName CacheAuditHeader
#define AuditDataNameStr "CacheAuditD"
#define AuditHeaderNameStr "CacheAuditHeader"
#define CacheAuditGbl ^|"^^"_$$$GetAuditDatabase|$$$AuditDataName
#define CacheAuditHeader ^|"^^"_$$$GetAuditDatabase|$$$AuditHeaderName
 
#;Definitions of the audit offset
#define AuditIndexOff           1
#define ClientExecutableNameOff 2
#define ClientIPAddressOff      3
#define DescriptionOff          4
#define EventOff                5
#define EventDataOff            6
#define EventSourceOff          7
#define EventTypeOff            8
#define NamespaceOff            9
#define PidOff                 10
#define RolesOff               11
#define RoutineSpecOff         12
#define SystemIDOff            13
#define UsernameOff            14
#define UTCTimeStampOff        15
 