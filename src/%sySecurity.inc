ROUTINE %sySecurity [Type=INC]
#include %occSystemMessages
#include %syDatabase
#if 0   /*=======================Maintenance========================*/
#;STC2425   6/9/15 Steve Clay, Reduce TOTP password window size
#;STC2423   6/9/15 Steve Clay, Use $LG rather than $LI when referencing AutheEnabled in user record
#;STC2415  5/24/15 Steve Clay, Better TOTP handling if Java not present
#;STC2414  5/20/15 Steve Clay, TOTP password may only be used once
#;STC2406 04/14/15 Steve Clay, Add some DeepSee resources
#;WDS559   3/12/15 David Shambroom, New startup default and journal database encryption key management
#;WDS552   1/31/15 David Shambroom, Configuration support for TLSv1.1 and TLSv1.2
#;STC2346 09/30/14 Steve Clay, Disabling Two Factor authentication for unconfigured users now works
#;STC2329 09/04/14 Steve Clay, Add Authentication method to audit record
#;STC2310 08/02/14 Steve Clay, Update display filters for Users, Resources, Audit Events, Domains
#;ALE2560 06/04/14 Alexander Enis, prompt for a separate password for CSPSystem user at installation
#;STC2262 12/12/13 Steve Clay, LDAP Group authorization implementation
#;JO2663  05/02/13 Jeffrey Orlin, adjust CheckName() and CheckRoles() macros
#;                 so they can be used in ProcedureBlock code (they contained
#;                 new commands of "private" variables).
#;STC2192 03/10/13 Steve Clay, Add %DeepSee_ReportBuilder resource
#;CDS2215 02/13/13 Chuck Sorenson, secure shell
#;STC2175 01/30/13 Steve Clay, Improve performance of $$$AddAllRoleTemporary macro
#;STC2171 01/24/13 Steve Clay, Replace some $zu(49,dir) with $zu(49,sfn) for performance
#;STC2155 12/13/12 Steve Clay, Add PasswordNeverExpires and AccountNeverExpires to Users security record
#;STC2148 11/20/12 Steve Clay, Do not disable _Ensemble username if inactive limit exceeded
#;STC2030 12/23/11 Steve Clay, Remove %All role escalation for SMP Operator menu
#;STC2018 11/30/11 Steve Clay, Remove Security.System.BypassSecurity property
#;KJK104  10/24/11 Kurt Klinzing,Add PermittedClasses field to Application: allows limited set of classes to run in CSP Server
#;WDS415  08/18/11 David Shambroom, Add property Security.SSLConfigs.CRLFile
#;KJK096  08/12/11 Kurt Klinzing, Infrastructure for X509 login
#;KJK087  07/12/11 Kurt Klinzing, Added IsNameSpaceDefault property for the Applications object
#;KJK086  07/06/11 Kurt Klinzing, Added constants which allow sharing of return codes between security layer and cspServer layer
#;KJK040  11/17/10 Kurt Klinzing, Replace GroupByBrowser with GroupById
#;KJK020  11/17/10 Kurt Klinzing, Add GroupByBrowser Global Enable setting for CSP Applications, Application GroupByBrowser flag
#;DDP141  11/15/10 Dale du Preez, Allow for creation of %EnsRole_* roles for Ensemble installs
#;KJK013  11/04/10 Kurt Klinzing, Added HttpOnlyCookies field for CSP Service
#;KJK005  09/01/10 Kurt Klinzing, Enabling/Disabling Web Service access or CSP/Zen access 
#;KJK003  08/12/10 Kurt Klinzing, Added Two Factor Enabled field to Application
#;KJK004  08/01/10 Kurt Klinzing, Updates erroneous numbering caused by duplicate values in list of fields
#;WDS363 07/22/10 David Shambroom, Audit database encryption events
#;RJW1795 03/12/10 Ron Watt, Cache Centralized Configuration.
#;STC1719 12/09/09 Steve Clay, New CACHE database 
#;STC1698 11/10/09 Steve Clay, Let user log in if system is hung
#;STC1624 06/24/09 Steve Clay, Add %Service_Mirror 
#;STC1587 04/28/09 Steve Clay, _PUBLIC user no longer displays incorrect user profile 
#;STC1548 02/20/09 Steve Clay, Validate authentication options set for CSP applications 
#;STC1532 01/30/09 Steve Clay, Add Delegated Authorization For Kerberos and O/S authentication 
#;RJF101  10/25/08 Ray Fucillo, Add DataCheck service
#;STC1401 06/05/08 Steve Clay, $System.Security.Login() requires a resource to run
#;TRW563  05/02/08 Remove CACHESUPPORT database resource
#;STC1369 04/22/08 Steve Clay, Allows owner of CACHESYS resource to run %SS 
#;STC1350 03/17/08 Steve Clay, Allow CSP sessions to accept sessions from other CSP sessions 
#;TRW522  12/13/07 Tom Woodfin, Add CACHESUPPORT database resource
#;STC1270 10/10/07 Steve Clay, Allow %HS* roles to be created for HealthShare installs 
#;STC1255 08/10/07 Steve Clay, Add Security.System.SSLSuperServer property
#;STC1249 07/26/07 Steve Clay, Add ServeFilesTimeout property to CSP applications
#;STC1218 04/27/07 Steve Clat, Display Welcome message when logging in via terminal
#;STC1148 01/11/07 Steve Clay, retrieve security record correctly if no %SYS namespace
#;STC1119 12/01/06 Steve Clay, Add InvalidLoginAction
#;STC1114 11/29/06 Steve Clay, Added callin error status codes
#;STC1087 10/04/06 Steve Clay, Add ChangePasswordPage property to CSP applications
#;STC1079 09/29/07 Steve Clay, Add Password Expiration Days
#;STC1077 09/27/06 Steve Clay, Allow password validation routine to be specified
#;STC1035 07/26/06 Steve Clay, Fix upgrade issue with journal encryption
#;STC1018 07/10/06 Steve Clay, Support LDAP and Delegated authentication in 
#;                             $SYSTEM.Security.Login
#;STC1007 06/09/06 Steve Clay, Expose import/export security API's 
#;STC1006 06/01/06 Steve Clay, Created Security.SSLConfig class
#;STC1003 05/31/06 Steve Clay, Set system default authentications to allow 
#;                             unauthenticated so docbook works.
#;STC998 05/11/06 Steve Clay, Allow user to disable bypassing security 
#;                            by administrator 
#;STC997 05/10/06 Steve Clay, Allow audit file to be encrypted 
#;STC995 05/08/06 Steve Clay, Move RolesCreate and RolesDelete functions to %SYS.SQLSEC 
#;STC983 05/01/06 Steve Clay, LDAP SSL authentication
#;STC977 03/19/06 Steve Clay, LDAP and User-Defined Authentication 
#;STC965 02/04/06 Steve Clay, DBReadAllowed macro now supports remote databases
#;STC945 11/09/05 Steve Clay, Set WDSTOP on Audit failure
#;STC940 11/01/05 Steve Clay, Change Cache Password Hash
#;STC899 08/10/05 Steve Clay, Localize kerberos service names
#;STC885 07/20/05 Steve Clay, Create CSPSystem user for CSP Gateway
#;STC868 06/22/05 Steve Clay, Better Audit messages
#;STC854 06/01/05 Steve Clay, Speed up security global access
#;STC850 05/25/05 Steve Clay, Correct useage of $ZB
#;STC836 05/11/05 Steve Clay, Audit Super Server login failures
#;STC794  4/12/05 Steve Clay, Add comment field to user record 
#;STC790  4/12/05 Steve Clay, Fix upgrade install 
#;STC771 3/17/05 Steve Clay, Add new DB encryption info to Security Classes 
#;STC770 3/16/05 Steve Clay, Rename Kerberos prompts
#;LFT1386 2/22/05 Laura Tillem, add permission prefix names
#;STC759 2/20/05, Steve Clay, Fix null passwords
#;STC757 02/16/05, Steve Clay, Combine CSP application definition and Security definition
#;PWC965  02/07/05 Peter Cudhea, CalledFromCachelib needs to use canonical directory names
#;RJW1039 01/31/05 Ron Watt, Some Edit Menus in ^SECURITY Case-Sensitive 
#;STC755 01/31/05, Steve Clay, Add CalledFromCachelib macro
#;RJW1034 01/27/05, Ron Watt, Remove ServicePrincipalName property from Services.System class.
#;RJW1036 01/26/05, Ron Watt, UnknownUser should have no roles when first created and defined roles on 5.0 upgrade.
#;STC749 01/18/05 Steve Clay, New $ET in $$$AddAllRoleTemporary macro
#;STC743 01/03/05 Steve Clay, Rename Kerberos options  
#;STC737 12/28/04 Steve Clay, Add $$$DBReadAllowed macro
#;STC720 10/16/04 Steve Clay, Convert to multiple domains correctly
#;STC718 12/13/04 Steve Clay, Remove ClientApplications property from Service class 
#;STC716 12/11/04 Steve Clay, Convert legacy users to new security database 
#;STC714 12/08/04 Steve Clay, Change to use resource instead of privilege
#;STC700 11/21/04 Steve Clay, Changes for emergency access
#;STC687 11/15/04 Steve Clay, Move some methods to %SYS.SECURITY
#;STC666 11/04/04 Steve Clay, Change to use SECURTY.*
#;DPV2310 10/20/2004 Dabid Van De Griek, SQL Security:  Pass namespace to GetSecuritySQLSysPrivData macro
#;PWC920 10/15/04 Peter Cudhea, Use ^qCacheObjectSys("debug") to debug Security methods
#;STC658 10/07/04 Steve Clay, Straighten out %All useage 
#;STC656 10/06/04 Steve Clay, Add %System/CallOut Resource 
#;STC655 10/06/04 Steve Clay, Support for LockedDown/Normal/None security defaults 
#;PWC915 10/05/04 Peter Cudhea, %Service_CallIn support for Security
#;STC653 10/04/04 Steve Clay, Add Encryption keys
#;STC652 10/04/04 Steve Clay, Add PasswordChangedDateTime property 
#;STC644 09/29/04 Steve Clay, Create _PUBLIC and _SYSTEM usernames on install 
#;STC641 09/27/04 Steve Clay, Add domain and application global definitions.
#;STC638 09/27/04 Steve Clay, Domain names are case-insensitive
#;STC636 09/23/04 Steve Clay, Improve queries
#;STC630 09/15/04 Steve Clay, Add password expired switch
#;STC629 09/14/04 Steve Clay, Add some new services
#;STC627 09/13/04 Steve Clay, Support for Client system security
#;STC616 08/26/04 Steve Clay, Map audit globals
#;STC615 08/24/04 Steve Clay, Add more field definitions
#;DPV2272 08/24/04 David Van De Griek, Fix: Define SQL Privileges per-namespace, which was broken by STC610.
#;STC612 08/19/04 Steve Clay, Update Application properties
#;STC610 08/18/04 Steve Clay, Update security classes to meet spec
#;DPV2264 08/13/04 David Van De Griek, Move SQL System Privileges to per-namespace definitions
#;DPV2259 08/09/04 David Van De Griek, Move SQL privileges to $$$SecurityGlobal,"SQL","priv",<namespace>,...)
#;DPV2256 08/04/04 David Van De Griek, Move SQL privileges to $$$SecurityGlobal,"SQL","priv",<database>,...)
#;PWC886 07/15/04 Peter Cudhea, Remove DEVELOP permission, and USE for databases
#;LFT1283 7/13/04 Laura Tillem, change null to %None for NullResourceName
#;PWC883  7/02/04 Peter Cudhea, $ROLES is comma-delimited not a $LIST
#;STC600 06/25/04 $username only contains domain when necessary 
#;PWC870 06/04/04 Peter Cudhea, Initialize security database from COS code
#;STC595 06/02/04 Steve Clay, Added IsTerminal, better initial defaults for terminals
#;PWC868  6/01/04 Peter Cudhea, CSP Security: Cannot be disabled
#;STC589 05/27/04 Steve Clay, Change name of CSP services
#;STC579 05/20/04 Steve Clay, Better handling of services
#;STC569 04/28/04 Steve Clay, Rewrite
#;PWC845 04/07/04 Peter Cudhea, ECP access control now done as a Service
#;STC563 03/24/03 Steve Clay, New resources for SQL 
#;STC561 03/23/04 Steve Clay, Add API's.
#;STC559 03/20/04 Steve Clay, Better handling of User and role class 
#;STC552 03/15/04 Steve Clay, Remove ^%NOSECURITY
#;STC537 03/04/04 Steve Clay, Added %Service_Job
#;STC536 03/03/04 Steve Clay, Add %Service_WebService
#;STC535 02/03/04 Steve Clay, Add %LegacySQL role definition
#;STC532 02/28/04 Steve Clay, add resource definitions
#;STC531 02/27/04 Steve Clay, Add CSPGateWay Service
#;STC529 02/25/04 Steve Clay, add PRCPROTECT error code
#;STC526 02/24/04 Steve Clay, Add legacy CacheDirect and Terminal role
#;STC522 02/11/04 Steve Clay, Add Unknown Service
#;STC518 02/06/04 Steve Clay, Modify $$$AccessCheck macros 
#;PWC807 02/04/04  Peter Cudhea, Add $$$AccessCheck macros
#;STC516 02/05/04 Steve Clay, Add AddAllRole and RemoveAllRole
#;STC513 02/02/04 Steve Clay, Add Stop/Start service
#;STC510 01/22/04 Steve Clay, change defines
#;STC501 01/05/04 Steve Clay, More security changes
#;PWC773 09/16/03 Peter Cudhea-Pierce, added AppStatus values.
#;STC471 08/19/03 Steve Clay, Renamed
#endif  /*=====================End Maintenance======================*/

#define SystemSuperUser "_SYSTEM"
 
#;=========================================================
#;DEFINITIONS FOR %SYS.SECURITY calls
#;=========================================================
 
#def1arg PermissionLogicalToDisplay(%Args) $$PermissionInternalToExternal^%SYS.SECURITY(%Args)
#def1arg IsASuperUser(%Args) $$IsASuperUser^%SYS.SECURITY(%Args)
#def1arg Login(%Args) $$Login^%SYS.SECURITY(%Args)
#def1arg UsersAuditLoginFailure(%Args) $$AuditLoginFailure^%SYS.SECURITY(%Args)
#def1arg AuditLoginFailure(%Args) $$AuditLoginFailure^%SYS.SECURITY(%Args)
#def1arg UsersAuditLoginSuccess(%Args) $$AuditLoginSuccess^%SYS.SECURITY(%Args)
#def1arg AuditLoginSuccess(%Args) $$AuditLoginSuccess^%SYS.SECURITY(%Args)
#def1arg UsersCSPLogin(%Args) $$UsersCSPLogin^%SYS.SECURITY(%Args)
#def1arg CSPTrustedLogin(%Args) $$CSPTrustedLogin^%SYS.SECURITY(%Args)
#def1arg UsersGetLoginRoutineName(%Args) $$UsersGetLoginRoutineName^%SYS.SECURITY(%Args)
#def1arg UsersLoginError(%Args) LoginError^%SYS.SECURITY(%Args)
#def1arg LoginError(%Args) LoginError^%SYS.SECURITY(%Args)
#def1arg InitializeUserSecurity(%Args) $$InitializeUserSecurity^%SYS.SECURITY(%Args)
#def1arg UsersParseUsername(%Args) $$ParseUsername^%SYS.SECURITY(%Args)
#def1arg ParseUsername(%Args) $$ParseUsername^%SYS.SECURITY(%Args)
#def1arg RunZSTART(%Args) $$RunZSTART^%SYS.SECURITY(%Args)
#def1arg SecurityAddRoles(%Args) $$SecurityAddRoles^%SYS.SECURITY(%Args)
#def1arg SecurityChangePassword(%Args) $$SecurityChangePassword^%SYS.SECURITY(%Args)
#def1arg SecurityLogin(%Args) $$SecurityLogin^%SYS.SECURITY(%Args)
#def1arg Status(%Args) $$Status^%SYS.SECURITY(%Args)
#;=========================================================
#;DEFINITIONS FOR RESOURCES
#;=========================================================
#;Resource prefixes
#define DBResourcePrefix "%DB_"
#define ServiceResourcePrefix "%Service_"
#define ApplicationResourcePrefix "%Application_"
#define AdminResourcePrefix "%Admin_"
#define SystemResourcePrefix "%System_"
#define DeepSeeResourcePrefix "%DeepSee_"
#define DeveloperResourcePrefix "%Development"
#;Used to construct database resource names
#define DEFAULT "%DEFAULT"
#define CACHEAUDIT "CACHEAUDIT"
#define CACHELIB "CACHELIB"
#define CACHE "CACHE"
#define CACHESYS "CACHESYS"
#define CACHETEMP "CACHETEMP"
#define DOCBOOK "DOCBOOK"
#define SAMPLES "SAMPLES"
#define USER "USER"
#;Admin Resource names 
#define	AdminManageResourceName        "%Admin_Manage"
#define	AdminOperateResourceName       "%Admin_Operate"
#define	AdminSecureResourceName	       "%Admin_Secure"
#define	AdminJournalResourceName       "%Admin_Journal"
#define	AdminTaskResourceName          "%Admin_Task"
#define DevelopmentResourceName        "%Development"
#define SecureBreakResourceName        "%Secure_Break"
#define SQLTuneTableResourceName       "%SQLTuneTable"
#;Database resource names 
#define DBCACHEAUDITResourceName       "%DB_CACHEAUDIT"
#define DBCACHELIBResourceName         "%DB_CACHELIB"
#define DBCACHEResourceName            "%DB_CACHE"
#define DBCACHESYSResourceName         "%DB_CACHESYS"
#define DBCACHETEMPResourceName        "%DB_CACHETEMP"
#define DBDOCBOOKResourceName          "%DB_DOCBOOK"
#define DBSAMPLESResourceName          "%DB_SAMPLES"
#define DBUSERResourceName             "%DB_USER"
#define DBDEFAULTResourceName          "%DB_%DEFAULT"
#define SystemDBResourceNames (","_$$$DBCACHEAUDITResourceName_","_$$$DBCACHELIBResourceName_","_$$$DBCACHEResourceName","_$$$DBCACHESYSResourceName_","_$$$DBCACHETEMPResourceName_",")
#;Service resource names
#define ServiceCacheDirectResourceName "%Service_CacheDirect"
#define ServiceCallInResourceName      "%Service_CallIn"
#define ServiceComPortResourceName     "%Service_ComPort"
#define ServiceConsoleResourceName     "%Service_Console"
#define ServiceCSPResourceName         "%Service_CSP"
#define ServiceLATResourceName         "%Service_LAT"
#define ServiceLoginResourceName       "%Service_Login"
#define ServiceObjectResourceName      "%Service_Object"
#define ServiceSQLResourceName         "%Service_SQL"
#define ServiceTelnetResourceName      "%Service_Telnet"
#define ServiceTerminalResourceName    "%Service_Terminal"
#define SystemCallOutResourceName      "%System_CallOut"
#;DeepSee resource names
#define DeepSeeAdminResourceName       "%DeepSee_Admin"
#define DeepSeeArchitectResourceName   "%DeepSee_Architect"
#define DeepSeeArchitectEditResourceName "%DeepSee_ArchitectEdit"
#define DeepSeeAnalyzerResourceName    "%DeepSee_Analyzer"
#define DeepSeeAnalyzerEditResourceName "%DeepSee_AnalyzerEdit"
#define DeepSeePortalResourceName      "%DeepSee_Portal"
#define DeepSeePortalEditResourceName  "%DeepSee_PortalEdit"
#define DeepSeeReportBuilderResourceName "%DeepSee_ReportBuilder"
#define DeepSeeListingGroupResourceName "%DeepSee_ListingGroup"
#define DeepSeeListingGroupEditResourceName "%DeepSee_ListingGroupEdit"
#define DeepSeeListingGroupSQLResourceName "%DeepSee_ListingGroupSQL"

#;Type of Resource
#define SystemResourceType		1
#define DBResourceType			2
#define ServiceResourceType		4
#define ApplicationResourceType	8
#define DeepSeeResourceType  	16
#define UserResourceType		(2**31)
#;Type of Application
#define AppTypeSystem      1
#define AppTypeCSP         2
#define AppTypePrivRoutine 4
#define AppTypeExecutable  8
#;XML Export Flags
#define SystemExport         1
#define EventsExport         2
#define ServicesExport       4
#define DomainsExport        8
#define ResourcesExport     16
#define RolesExport         32
#define UsersExport         64
#define ApplicationsExport 128
#define SSLConfigsExport   256
#define PhoneProvidersExport 512
#define X509CredentialsExport 1024
#define OpenAMIdentityServicesExport 2048
#define SQLPrivileges     4096
#define X509UsersExport		8192
#;=========================================================
#;Cache password definitions
#;=========================================================
#define CachePWIterations 1024
#define CachePWSaltLength 8
#define CachePWHashLength 20
#define Unchangeable "Unchangeable"
#;=========================================================
#;Defines for User Flags
#;=========================================================
#define NormalUser       1
#define LDAPUser         2
#define DelegatedUser    4
#define KerberosUser     8
#define OSUser          16
#;=========================================================
#;DEFINITIONS FOR ROLES
#;=========================================================
 
#;Define the default role names here. Note that %Public is only used internally
#define PublicRoleName                "%Public"
#define AllRoleName                   "%All"
#define DeveloperRoleName             "%Developer"
#define ManagerRoleName               "%Manager"
#define SecureBreakRoleName           "%SecureBreak"
#define SQLTuneTableRoleName          "%SQLTuneTable"
#define OperatorRoleName              "%Operator"
#define SQLRoleName                   "%SQL"
#;Define the legacy system defined roles here for upgrading pre-5.1 systems
#define LegacyTerminalRole            "%LegacyTerminal"
#define LegacyCacheDirectRole         "%LegacyCacheDirect" 
#define LegacySQLRole                 "%LegacySQL"
#define	LegacyUnknownUserRole         "%LegacyUnknownUser"
 
#;Internal permission bit masks
#define PermReadMask        1
#define PermWriteMask       2
#define PermUseMask         4
#define PermInvalidMask     32768
 
#define PermReadName        "READ"
#define PermWriteName       "WRITE"
#define PermUseName         "USE"
 
#define PermReadAbrev       "R"
#define PermWriteAbrev      "W"
#define PermUseAbrev        "U"
#;=========================================================
#;DEFINITIONS FOR SERVICES
#;=========================================================
#;Define the service names here 
#define ServiceBindings        "%Service_Bindings"
#define ServiceCacheDirect     "%Service_CacheDirect"
#define ServiceCallIn          "%Service_CallIn"
#define ServiceComPort         "%Service_ComPort"
#define ServiceConsole         "%Service_Console"
#define ServiceCSP             "%Service_CSP"
#define ServiceDataCheck       "%Service_DataCheck"
#define ServiceDCP             "%Service_DCP"
#define ServiceDDP             "%Service_DDP"
#define ServiceECP             "%Service_ECP"
#define ServiceGetInfo         "%Service_GetInfo"
#define ServiceHTTP            "%Service_HTTP"
#define ServiceJob             "Job Command"
#define ServiceJournal         "%Service_Journal"
#define ServiceLAT             "%Service_LAT"
#define ServiceLogin           "%Service_Login"
#define ServiceMirror          "%Service_Mirror"
#define ServiceMonitor         "%Service_Monitor"
#define ServiceMSMActivate     "%Service_MSMActivate"
#define ServiceShadow          "%Service_Shadow"
#define ServiceStart           "%Service_Start"
#define ServiceStop            "%Service_Stop"
#define ServiceSuperServer     "%Service_SuperServer"
#define ServiceTaskMgr         "%Service_TaskMgr"
#define ServiceTelnet          "%Service_Telnet"
#define ServiceTerminal        "%Service_Terminal"
#define ServiceUnAuthenticated "%Service_UnAuthenticated"
#define ServiceUnKnown         "%Service_UnKnown"
#define ServiceWeblink         "%Service_Weblink"
 
#;Defines for the service class to determine
#;what is valid for each type of service
#define AutheK5CCache		1
#define AutheK5Prompt		2
#define AutheK5API			4
#define AutheK5KeyTab		8
#define AutheOS				16
#define AutheCache			32
#define AutheUnauthenticated 64
#define AutheKB				 128
#define AutheKBEncryption	 256
#define AutheKBIntegrity	 512
#define AutheSystem			1024
#define AutheLDAP			2048
#define AutheLDAPCache		4096
#define AutheDelegated 		8192
#define AutheLoginToken		16384
#define AutheKerberosDelegated 32768
#define AutheOSDelegated    65536
#define AutheWebService    131072      /* Remove this */
#define AutheX509          262144		/* used??*/
#define AutheTLS		   524288		/* used??*/
#define AutheTwoFactorSMS	1048576
#define AutheTwoFactorPW	2097152
#define AutheKBAll  $$$AutheK5CCache+$$$AutheK5Prompt+$$$AutheK5API+$$$AutheK5KeyTab+$$$AutheKB+$$$AutheKBEncryption+$$$AutheKBIntegrity
#;Valid authentication options for CSP applications.
#define CSPApplicationValidAuthe $$$AutheK5API+$$$AutheCache+$$$AutheUnauthenticated+$$$AutheLDAP+$$$AutheLDAPCache+$$$AutheDelegated+$$$AutheLoginToken+$$$AutheX509+$$$AutheTLS+$$$AutheTwoFactorSMS+$$$AutheTwoFactorPW
#;AutheMax is the number of all the Authe bits set, used for validation
#define AutheMax			4194303
#define AutheUpgrade $$$AutheK5CCache+$$$AutheK5Prompt+$$$AutheK5API+$$$AutheK5KeyTab+$$$AutheOS+$$$AutheCache+$$$AutheUnauthenticated+$$$AutheKB+$$$AutheKBEncryption+$$$AutheKBIntegrity+$$$AutheSystem
#define AutheMinimal $$$AutheOS+$$$AutheCache+$$$AutheUnauthenticated+$$$AutheSystem
#define AutheNormal     $$$AutheK5CCache+$$$AutheK5Prompt+$$$AutheK5API+$$$AutheCache+$$$AutheUnauthenticated+$$$AutheKB+$$$AutheKBEncryption+$$$AutheKBIntegrity+$$$AutheSystem
#define AutheLockedDown $$$AutheK5CCache+$$$AutheK5Prompt+$$$AutheK5API+$$$AutheCache+$$$AutheUnauthenticated+$$$AutheKB+$$$AutheKBEncryption+$$$AutheKBIntegrity+$$$AutheSystem
#;These are authentication methods which the user is prompted for username/pw
#define AutheUsernamePassword $$$AutheDelegated+$$$AutheK5API+$$$AutheCache+$$$AutheLDAP+$$$AutheLDAPCache
#;One of the following must also be on if two factor is to be enabled for a service, application, or system
#define AutheTwoFactorRequired $$$AutheUsernamePassword
 
#define GetAutheEnabledService(%AutheEnabled,%SystemRecord,%ServiceRecord,%UserRecord) s %AutheEnabled=$zb($$$GetSecuritySystemAutheEnabled(%SystemRecord),$$$GetSecurityServicesAutheEnabled(%ServiceRecord),1) s %AutheEnabled=$zb(%AutheEnabled,$$$AutheTwoFactorSMS+$$$AutheTwoFactorPW,1) s %AutheEnabled=$zb(%AutheEnabled,$$$GetSecurityUsersAutheEnabled(%UserRecord),1)
#define GetAutheEnabledApplication(%AutheEnabled,%SystemRecord,%ApplicationRecord,%UserRecord) s %AutheEnabled=$zb($$$GetSecuritySystemAutheEnabled(%SystemRecord),$$$GetSecurityApplicationsAutheEnabled(%ApplicationRecord),1) s %AutheEnabled=$zb(%AutheEnabled,$$$AutheTwoFactorSMS+$$$AutheTwoFactorPW,1) s %AutheEnabled=$zb(%AutheEnabled,$$$GetSecurityUsersAutheEnabled(%UserRecord),1)

#;Used for TOTP authentication when the user does not specify the limit
#define TOTPDefaultTimeStepLimit 2 
#define TOTPDefaultTimeStep 30
 
#;String displays for the above authentications
#define AutheK5CCacheStr	$$$GetMsg($$$ServicesMsg,"AutheK5CCacheStr")
#define AutheK5PromptStr	$$$GetMsg($$$ServicesMsg,"AutheK5PromptStr")
#define AutheK5APIStr		$$$GetMsg($$$ServicesMsg,"AutheK5APIStr")
#define AutheK5KeyTabStr	$$$GetMsg($$$ServicesMsg,"AutheK5KeyTabStr")
#define AutheOSStr			$$$GetMsg($$$ServicesMsg,"AutheOSStr")
#define AutheCacheStr		$$$GetMsg($$$ServicesMsg,"AutheCacheStr")
#define AutheUnauthenticatedStr $$$GetMsg($$$ServicesMsg,"AutheUnauthenticatedStr")
#define AutheKBStr			$$$GetMsg($$$ServicesMsg,"AutheKBStr")
#define AutheKBEncryptionStr $$$GetMsg($$$ServicesMsg,"AutheKBEncryptionStr")
#define AutheKBIntegrityStr	$$$GetMsg($$$ServicesMsg,"AutheKBIntegrityStr")
#define AutheLDAPStr		$$$GetMsg($$$ServicesMsg,"AutheLDAPStr")
#define AutheLDAPCacheStr	$$$GetMsg($$$ServicesMsg,"AutheLDAPCacheStr")
#define AutheDelegatedStr	$$$GetMsg($$$ServicesMsg,"AutheDelegatedStr")
#define AutheUnknown		$$$GetMsg($$$ServicesMsg,"AutheUnknown")
#define AutheLoginTokenStr	$$$GetMsg($$$ServicesMsg,"AutheLoginTokenStr")
#define AutheKerberosDelegatedStr	$$$GetMsg($$$ServicesMsg,"AutheKerberosDelegatedStr")
#define AutheOSDelegatedStr	$$$GetMsg($$$ServicesMsg,"AutheOSDelegatedStr")
#define AutheOSWebServiceStr	$$$GetMsg($$$ServicesMsg,"AutheWebServiceStr")
#define AutheX509Str		$$$GetMsg($$$ServicesMsg,"AutheX509Str")
#define AutheTLSStr			$$$GetMsg($$$ServicesMsg,"AutheTLSStr")
#define AutheTwoFactorSMSStr	$$$GetMsg($$$ServicesMsg,"AutheTwoFactorSMSStr")
#define AutheTwoFactorPWStr	$$$GetMsg($$$ServicesMsg,"AutheTwoFactorPWStr")
 
#;Defines for service capabilities
#define EnableNone                       0
#define EnableEnabled                    1
#define EnableUsePrivilege				 2
#define EnablePrivilegeBasedSecurity     4
#define EnableClientSystemSecurity       8
#define EnableClientSystemSecurityRoles 16
#define EnableClientApplicationSecurity 32
#define EnableInternalService           64
#define EnableWindows                  128
#define EnableUnix                     256
#define EnableVMS                      512
#define EnableAllPlatforms             $$$EnableWindows+$$$EnableUnix+$$$EnableVMS

#;=========================================================
#;DEFINITIONS FOR USERS
#;=========================================================
 
#;Define the default usernames here
#define SuperUserUsername		"SuperUser"
#define AdminUsername			"Admin"
#define UnknownUserUsername     "UnknownUser"
#define pSystemUsername			"%System"
#define CSPSystemUsername		"CSPSystem"
#define SYSTEMUsername			"_SYSTEM"
#define PUBLICUsername			"_PUBLIC"
#define EnsembleUsername 		"_Ensemble"
#define DefaultPassword			"SYS"
#define DefaultODBCPassword		"SYS"
#;Delimiter between username and domain
#define DomainDelim			"@" 
 
#;=========================================================
#;LOCALIZATION DOMAINS
#;=========================================================
 
#;Domains for security messages
#define ResourcesMsg    "%SECURITY.Resources"
#define RolesMsg        "%SECURITY.Roles"
#define AuditMsg        "%SECURITY.Audit"
#define EventsMsg       "%SECURITY.Events"
#define DomainsMsg      "%SECURITY.Domains"
#define ServicesMsg     "%SECURITY.Services"
#define SystemMsg       "%SECURITY.System"
#define LoginRulesMsg   "%SECURITY.LoginRules"
#define SystemLocalMsg  "%SECURITY.SystemLocal"
#define ApplicationsMsg "%SECURITY.Applications"
#define SecurityMsg     "%SECURITY.Security" 
#define UsersMsg        "%SECURITY.Users" 
#define X509UsersMsg        "%SECURITY.X509Users" 
#define LDAPMsg         "%SECURITY.LDAP" 
#define SSLConfigsMsg   "%SECURITY.SSLConfigs"
#define DBEncMsg        "%SECURITY.DBEnc"
#define PhoneProvidersMsg "%SECURITY.PhoneProviders"
#define X509CredentialsMsg "%SECURITY.X509Credentials"
#define OpenAMIdentityServicesMsg "%SECURITY.OpenAMIdentityServices"
#define	NLSMsg			"%SECURITY.NLS"
#;=========================================================
#;USEFULL MACROS
#;=========================================================
  
#; We cannot delete these system defined roles.
#define IsSystemRole(%role) ((%role=$$$AllRoleName)||(%role=$$$DeveloperRoleName)||(%role=$$$ManagerRoleName)||(%role=$$$SecureBreakRoleName)||(%role=$$$SQLTuneTableRoleName)||(%role=$$$OperatorRoleName)||(%role=$$$SQLRoleName)||(($e(%role,1,3)="%HS")&&##class(%Library.EnsembleMgr).IsHealthShareInstalled())||(($e(%role,1,9)="%EnsRole_")&&##class(%Library.EnsembleMgr).IsEnsembleInstalled()))
#define IsSystemLegacyRole(%role) ((%role=$$$LegacyTerminalRole)||(%role=$$$LegacyCacheDirectRole)||(%role=$$$LegacySQLRole))
#define IsLegacyUnknownUserRole(%role) (%role=$$$LegacyUnknownUserRole)
#define IsTerminalService(%ServiceName) 	(%ServiceName=$$$ServiceTerminal)||(%ServiceName=$$$ServiceConsole)||(%ServiceName=$$$ServiceTelnet)||(%ServiceName=$$$ServiceLAT)||(%ServiceName=$$$ServiceComPort)||(%ServiceName=$$$ServiceStart)||(%ServiceName=$$$ServiceStop)||(%ServiceName=$$$ServiceCallIn)
 
#; Macros to check Security, for use in System methods (will not add roles in user code)
#define AddAllRole 						s $roles=$roles_","_$$$AllRoleName
#define ResetToLoginRoles				s $roles=""
#define AddAllRoleTemporary				i '$$$IOwnAllRole { n $ET,$roles s $ET="",$roles=$roles_","_$$$AllRoleName}
#define AddAllRoleTemporaryInTry		i '$$$IOwnAllRole { n $roles set $roles=$roles_","_$$$AllRoleName }
#; AddAllRoleTemporaryInTryCatch is here because it was used in HealthShare 2014.1 and earlier which needs to run on current versions.
#; It should NOT be used in new code. It is not appropriate in a Catch. See CDS2375.
#define AddAllRoleTemporaryInTryCatch	i '$$$IOwnAllRole { n $roles set $roles=$roles_","_$$$AllRoleName }
#define IOwnRole(%Role)                 (","_$zcvt($roles,"u")_","[(","_$zcvt(%Role,"u")_","))
#define IAmSuperUser					($e($roles,1,$l($$$AllRoleName))=$$$AllRoleName)
#define IOwnAllRole                     $$$IAmSuperUser
#define EmergencyStartup                $ZU(194,1) 
#define DBReadAllowed					$s($e($namespace)'="^":$$Access^%SYS.NAMESPACE($namespace,3,1,1),1:$$AccessImplied^%SYS.NAMESPACE($namespace,3,1,1))
#define CalledFromCachelib				If $zu(96,10)'=$ZU(12,##Class(%Library.File).SubDirectoryName($zu(12),"cachelib"))  Do $ZU(96,3,32) 
#define ConvIP2L(%i)                        (((((($a(%i,1)*256)+$a(%i,2))*256)+$a(%i,3))*256)+$a(%i,4))
#define BypassSecurity	($zb(+$zu(179,14),1,1)&&$SYSTEM.Security.Users.IsAdministrator()) 
#define BypassSecuritySystemTroubled	($zb(+$zu(179,14),1,1)&&$SYSTEM.Security.Users.IsAdministrator())
#;Only display the node and instance if there is not a routine passed in on the command line (programmer mode)
#define WelcomeMessage i $d(^rOBJ("ZWELCOME")) {d ^ZWELCOME} else {w:$v($zu(40,1,41),-1,$zu(40,0,70))=0 !,$$$FormatMsg($$$UsersMsg,"Welcome",$zu(110),$p($zu(86),"*",2)),!}
#define WelcomeMessageSystemTroubled w:$v($zu(40,1,41),-1,$zu(40,0,70))=0 !,"Node: "_$zu(110)_", Instance: "_$p($zu(86),"*",2),!
#define IOwnCACHESYSRead  $System.Security.Check($p($zu(49,0,3),"^",3),"R")
#define IOwnCACHESYSWrite $System.Security.Check($p($zu(49,0,3),"^",3),"W")

#;These are the defines for the file of usernames created during install
#define InstallInfoFile              "INSTALLINFO.TXT"
#define InstallDomainName            "InstallDomainName" 
#define InstallDomainNameFQ          "InstallDomainNameFQ"
#define InstallUsername              "InstallUsername"
#define InstallCSPSystemPassword     "InstallCSPSystemPassword"
#define InstallUsernamePassword      "InstallUsernamePassword"
#define InitialSecuritySettings      "InitialSecuritySettings"
#define SecuritySettingsNone         "None"
#define SecuritySettingsNormal       "Normal"
#define SecuritySettingsLockedDown   "Locked Down"
#define SecuritySettingsUnknown      "Unknown"
#;Status codes returned by $zu(4) for Callin Apps
#define CacheAccessDenied -15
#define CacheChangePassword -16
#;
#;==============================================
#define ECP $$$ServiceECP
#define DDP $$$ServiceDDP
#define DCP $$$ServiceDCP
#define pAllRoleName $$$AllRoleName
#define pAllResourceName "%All"
#define pAllResource "%All"
#define	RolesDelim ","
#define	RolesAsString(%roles) %roles
#define	RolesBuild1(%role1) (%role1)
#define	RolesAppend(%roles1,%roles2) ((%roles1)_$$$RolesDelim_(%roles2))
#define	RolesAddRole(%roles,%role) $$$RolesAppend(%roles,$$$RolesBuild1(%role))
#define	RolesInsertRole(%role) Set $ROLES=$$$RolesAddRole($Roles,%role)
#define SYSRSPDB "%DB_"
#;=========================================================
#;DEFINITIONS FOR APPLICATIONS
#;=========================================================
#;Application definitions
#define AppStatusDisabled 	0
#define AppStatusPublic 	1
#define AppStatusRestricted 2
#define AppStatusLocked 	3
 
#;=========================================================
#;DEFINITIONS FOR SSL configurations
#;=========================================================
 
#;Protocols
#define SSLv2	1
#define SSLv3	2
#define TLSv1	4
#define TLSv11	8
#define TLSv12	16
#define MAXPROTOCOL 16
 
#;File formats
#define PEM	1
#define ASN1	2
 
#;Peer authentication verification
#define NONE		0
#define REQUEST	1
#define REQUIRE	2
 
#;System Security config name
#define SystemSecurityName "SYSTEM"
#define SystemLocalSecurityName "SYSTEMLOCAL"
 
#;Assume passing in "" means "*" 
#;JO2663: Change local variables Field, Found, i, j, and Role to 
#;        % names so they are treated as public when ProcedureBlock=1
#define CheckName(%x) CheckName%x(Select,Data) q:(Select="*") 1  q:(","_$zcvt(Select,"L")_",")[(","_$zcvt(Data,"L")_",") 1  q:Select'["*" 0  n %Found,%Field s %Found=0 f i=1:1:$l(Select,",") { s %Field=$p(Select,",",i) Continue:$e(%Field,$l(%Field))'="*"  s %Field=$zcvt($p(%Field,"*",1),"L") i %Field=$e($zcvt(Data,"L"),1,$l(%Field)) s %Found=1 q} q %Found
#define CheckNameContains(%x) CheckNameContains%x(Select,Data) q:(Select="*") 1  q:(","_$zcvt(Select,"L")_",")[(","_$zcvt(Data,"L")_",") 1  q:(Select'["*")&&(($zcvt(Data,"L"))[($zcvt(Select,"L"))) 1  q:Select'["*" 0  n %Found,%Field s %Found=0 f i=1:1:$l(Select,",") { s %Field=$p(Select,",",i) Continue:$e(%Field,$l(%Field))'="*"  s %Field=$zcvt($p(%Field,"*",1),"L") i %Field=$e($zcvt(Data,"L"),1,$l(%Field)) s %Found=1 q} q %Found
#define CheckRole(%x) CheckRole%x(Select,Data) q:(Select="*") 1  n %i,%j,%Found,%Role s %Found=0 f %i=1:1:$ll(Data) {s %Role=$li(Data,%i) i $zcvt(","_Select_",","L")[$zcvt(","_%Role_",","L") s %Found=1 q} q:%Found %Found  q:Select'["*" 0  f %i=1:1:$l(Select,",") { s %Field=$p(Select,",",%i) Continue:$e(%Field,$l(%Field))'="*"  s %Field=$zcvt($p(%Field,"*",1),"L")   f %j=1:1:$ll(Data) {s %Role=$zcvt($li(Data,%j),"L") i %Field=$e(Role,1,$l(%Field)) s %Found=1 q} q:%Found} q %Found
#define CheckAuthentication(%x) CheckAuthentication%x(Select,Data) q:(Select="*") 1  i $zb(+Select,+Data,1) {q 1} else {q 0}
 

#;=========================================================
#;MACROS FOR DIRECT ACCESS TO SECURITY GLOBALS
#;=========================================================
#; Initial version of EMS re-defined  these with $zu(203), changed back to %SYS for now
#define SecurityMapGlobal ^|"^^"_$zu(12)|SYS
#define SecurityMapUsers ^|"^^"_$zu(12)|SYS
#define SecurityMapGroup "^^"_$zu(12)

#define SecurityGlobalApplications(%Application) $$$SecurityMapGlobal("Security","ApplicationsD",$zcvt(%Application,"L"))
#define SecurityGlobalDomains(%Domain) $$$SecurityMapGlobal("Security","DomainsD",$zcvt(%Domain,"L"))
#define SecurityGlobalEvents(%Source,%Type,%Name) $$$SecurityMapGlobal("Security","EventsD",$zcvt(%Source,"L"),$zcvt(%Type,"L"),$zcvt(%Name,"L"))
#define SecurityGlobalPhoneProviders(%PhoneProviders) $$$SecurityMapGlobal("Security","PhoneProvidersD",%PhoneProviders)
#define SecurityGlobalOpenAMIdentityServices(%OpenAMIdentityServices) $$$SecurityMapGlobal("Security","OpenAMIdentityServicesD",%OpenAMIdentityServices)
#define SecurityGlobalResources(%Resource) $$$SecurityMapGlobal("Security","ResourcesD",$zcvt(%Resource,"L"))
#define SecurityGlobalRoles(%Role) $$$SecurityMapGlobal("Security","RolesD",$zcvt(%Role,"L"))
#;The "1" node contains SQL Data
#define SecurityGlobalRolesExt(%Role) $$$SecurityMapGlobal("Security","RolesD",$zcvt(%Role,"L"),1)
#define SecurityGlobalServices(%Service) $$$SecurityMapGlobal("Security","ServicesD",$zcvt(%Service,"L"))
#define SecurityGlobalSSLConfigs(%SSLConfig) $$$SecurityMapGlobal("Security","SSLConfigsD",$zcvt(%SSLConfig,"L"))
#define SecurityGlobalSystem(%System) $$$SecurityMapGlobal("Security","SystemD",$$$SystemSecurityName)
#define SecurityGlobalSystemLocal(%SystemLocal) $$$SecurityMapGlobal("Security","SystemLocalD",$$$SystemLocalSecurityName)
#define SecurityGlobalX509Credentials(%X509) $$$SecurityMapGlobal("Security","X509CredentialsD",%X509)
#;Security users database is stored differently than the others.
#define SecurityGlobalUsers(%User) $$$SecurityMapGlobal("Security","UsersD",$zcvt(%User,"L"))
#define SecurityGlobalX509Users(%LookupKey) $$$SecurityMapGlobal("Security","X509UsersD",%LookupKey)
#define SecurityGlobalLoginRules(%LoginRules) $$$SecurityMapGlobal("Security","LoginRulesD",$$$SystemSecurityName)
#define SecurityGlobalUsersLoginToken(%LoginToken) $$$SecurityMapGlobal("Security","UsersI","LoginTokenIndex",%LoginToken)

#define SecurityGlobalVersion $$$SecurityMapGlobal("Security","Version")
#; Replaced all occurrances of $$$SecurityGlobal with $$$EMSSecurityGlobal.
#; Leave $$$SecurityGlobal() defined for potential external usage.
#def1arg SecurityGlobal(%Args) $$$SecurityMapGlobal("Security",%Args)
#def1arg SecurityGlobalServicesClientSystems(%Args) $$$SecurityMapGlobal("Security","ClientSystems",%Args)
#define SecurityGlobalSQL(%Args) $$$SecurityMapGlobal("Security","SQL",%Args)
#def1arg SecurityGlobalSQLPriv(%Args) $$$SecurityMapGlobal("Security","SQL","priv",%Args)
#def1arg SecurityGlobalSQLSysPriv(%Args) $$$SecurityMapGlobal("Security","SQL","syspriv",%Args)
#define GetSecuritySQLSysPrivData(%Name,%Record,%Namespace) s %Record=$g($$$SecurityGlobalSQLSysPriv(%Namespace,$zcvt(%Name,"L")))
#define SetSecuritySQLSysPrivData(%Name,%Record,%Namespace) s $$$SecurityGlobalSQLSysPriv(%Namespace,$zcvt(%Name,"L"))=%Record
#define KillSecuritySQLSysPrivData(%Name,%Namespace) k $$$SecurityGlobalSQLSysPriv(%Namespace,$zcvt(%Name,"L"))
#; Update the SQLCounter.  Perhaps update by namespace at some point.  Temporarily set $$$EMSActGroupGlobalSIRef("Security","SQLCounterUpdate") to reveal errors.
#define USENSFORSQLUPDATE 0
#if $$$USENSFORSQLUPDATE
#define SetSecuritySQLUpdate(%Namespace) try { $$$AddAllRoleTemporaryInTry new $namespace d $zu(5,"%SYS"),##class(EMS.Groups).RecordChange($$$EMSSQLSecurityBit) } catch { D $ZU(9,"","Error updating SQL Security bit"_$ZE_" Group DB="_$zu(203,1)_" Group Name="_$zu(203,2)) }
#else
#;#define SetSecuritySQLUpdate(%Namespace) try {  $$$AddAllRoleTemporaryInTry new $namespace d $zu(5,"%SYS"),##class(EMS.Groups).RecordChange($$$EMSSQLSecurityBit) } catch { D $ZU(9,"","Error updating SQL Security bit"_$ZE_" Group DB="_$zu(203,1)_" Group Name="_$zu(203,2)) }
#define SetSecuritySQLUpdate(%Namespace)
#endif 
#define SecurityGlobalSQLRoleUser0 $$$SecurityMapUsers("Security","SQL","role-user")
#def1arg SecurityGlobalSQLRoleUser(%Args) $$$SecurityMapUsers("Security","SQL","role-user",%Args)
 
#define SecurityGlobalSQLUserRole0 $$$SecurityMapUsers("Security","SQL","user-role")
#def1arg SecurityGlobalSQLUserRole(%Args) $$$SecurityMapUsers("Security","SQL","user-role",%Args)

#if 1
#def1arg SecurityAdvisorGlobal(%Args) $$$SecurityMapGlobal("SecurityAdvisor",%Args)
#else 
#def1arg SecurityAdvisorGlobal(%Args) ^|$$$SecurityMapGroup|SYS("SecurityAdvisor",%Args)
#endif
 
#;Defines for LDAPFlags
#define LDAPActiveDirectory 1
#define LDAPTLSConnection 2
#define LDAPUseProxyServer 4
#define LDAPUseGroups 8
#define LDAPUseNestedGroups 16

#;Prefix used for detecting LDAP groups
#define GroupRoleId      "INTERSYSTEMS-ROLE-"
#define GroupNamespaceId "INTERSYSTEMS-NAMESPACE-"
#define GroupRoutineId   "INTERSYSTEMS-ROUTINE-"
#define NestedGroupsAttribute "NESTEDGROUPS"

#define GroupObjectClassName(%Flags,%UniqueDN) $s($d(^|"%SYS"|SYS("LDAP","GroupObjectClassName")):^|"%SYS"|SYS("LDAP","GroupObjectClassName"),1:$S($zb(%Flags,$$$LDAPActiveDirectory,1):"group",$zcvt(%UniqueDN,"U")="SAMACCOUNTNAME":"group",1:"groupOfNames"))
#define LDAPDefaultClientTimeout 10
#define LDAPDefaultServerTimeout 5
 
#define LDAPAuthenticateFunction 1
#define LDAPTimeTestFunction 2

#;The following are definitions for the Security.System Class global structure
#define SecuritySystemExists(%System,%Record) ($d($$$SecurityGlobalSystem(%System),%Record)#10=1)
#define SecuritySystemAuditEnabledOff 2
#define SecuritySystemConfigurationSecurityEnabledOff 3
#define SecuritySystemDBEncAlgorithmOff 4
#define SecuritySystemDBEncCacheTempOff 5
#define SecuritySystemDBEncKeyLengthOff 6
#define SecuritySystemDBEncStartConfigFileOff 7
#define SecuritySystemDBEncStartKeyFileOff 8
#define SecuritySystemDBEncStartModeOff 9
#define SecuritySystemDBEncStartPassphraseOff 10
#define SecuritySystemDBEncStartRequiredOff 11
#define SecuritySystemDBEncStartUsernameOff 12
#define SecuritySystemDefaultSecurityDomainOff 13
#define SecuritySystemDescriptionOff 14
#define SecuritySystemInactiveLimitOff 15
#define SecuritySystemInvalidLoginLimitOff 16
#define SecuritySystemKeyEncKeyIterationsOff 17
#define SecuritySystemKeyEncKeyLengthOff 18
#define SecuritySystemKeyEncKeySaltLengthOff 19
#define SecuritySystemPasswordPatternOff 20
#define SecuritySystemPercentGlobalWriteOff 21
#define SecuritySystemSecurityDomainsOff 22
#define SecuritySystemAuditFlagsOff 23
#define SecuritySystemDBEncJournalOff 24
#define SecuritySystemAutheEnabledOff 25
#define SecuritySystemLDAPBaseDNOff 26
#define SecuritySystemLDAPDomainNameOff 27
#define SecuritySystemLDAPFlagsOff 28
#define SecuritySystemLDAPHostNamesOff 29
#define SecuritySystemLDAPSearchPasswordOff 30
#define SecuritySystemLDAPSearchUsernameOff 31
#define SecuritySystemLDAPUniqueDNIdentifierOff 32
#define SecuritySystemLDAPAttributeCommentOff 33
#define SecuritySystemLDAPAttributeFullNameOff 34
#define SecuritySystemLDAPAttributeNameSpaceOff 35
#define SecuritySystemLDAPAttributeRolesOff 36
#define SecuritySystemLDAPAttributeRoutineOff 37
#define SecuritySystemLDAPClientTimeoutOff 38
#define SecuritySystemLDAPServerTimeoutOff 39
#define SecuritySystemLDAPCACertFileOff 40
#define SecuritySystemRequiredRoleOff 41
#define SecuritySystemLDAPAttributesOff 42
#define SecuritySystemAuditEncryptOff 43
#define SecuritySystemUnused 44
#define SecuritySystemPasswordValidationRoutineOff 45
#define SecuritySystemPasswordExpirationDaysOff 46
#define SecuritySystemInvalidLoginActionOff 47
#define SecuritySystemSSLSuperServerOff 48
#define SecuritySystemSMTPPasswordOff 49
#define SecuritySystemSMTPServerOff 50
#define SecuritySystemSMTPUsernameOff 51
#define SecuritySystemTwoFactorTimeoutOff 52
#define SecuritySystemTwoFactorFromOff 53
#define SecuritySystemTwoFactorEnabledOff 54
#define SecuritySystemLoginCookieTimeoutOff 55
#define SecuritySystemDefaultSignatureHashOff 56
#define SecuritySystemTwoFactorPWIssuerOff 57
#define SecuritySystemDBEncDefaultKeyIDOff 58
#define SecuritySystemDBEncJournalKeyIDOff 59
#define GetSecuritySystemAuditEnabled(%Record) +$li(%Record,$$$SecuritySystemAuditEnabledOff)
#define GetSecuritySystemAuditEncrypt(%Record) +$lg(%Record,$$$SecuritySystemAuditEncryptOff)
#define GetSecuritySystemAuditFlags(%Record) +$lg(%Record,$$$SecuritySystemAuditFlagsOff)
#define GetSecuritySystemAutheEnabled(%Record) +$lg(%Record,$$$SecuritySystemAutheEnabledOff)
#define GetSecuritySystemConfigurationSecurityEnabled(%Record) +$li(%Record,$$$SecuritySystemConfigurationSecurityEnabledOff)
#define GetSecuritySystemDBEncAlgorithm(%Record) $li(%Record,$$$SecuritySystemDBEncAlgorithmOff)
#define GetSecuritySystemDBEncCacheTemp(%Record) $li(%Record,$$$SecuritySystemDBEncCacheTempOff)
#define GetSecuritySystemDBEncDefaultKeyID(%Record) $lg(%Record,$$$SecuritySystemDBEncDefaultKeyIDOff)
#define GetSecuritySystemDBEncJournalKeyID(%Record) $lg(%Record,$$$SecuritySystemDBEncJournalKeyIDOff)
#define GetSecuritySystemDBEncJournal(%Record) $lg(%Record,$$$SecuritySystemDBEncJournalOff)
#define GetSecuritySystemDBEncKeyLength(%Record) $li(%Record,$$$SecuritySystemDBEncKeyLengthOff)
#define GetSecuritySystemDBEncStartConfigFile(%Record) $li(%Record,$$$SecuritySystemDBEncStartConfigFileOff)
#define GetSecuritySystemDBEncStartKeyFile(%Record) $li(%Record,$$$SecuritySystemDBEncStartKeyFileOff)
#define GetSecuritySystemDBEncStartMode(%Record) $li(%Record,$$$SecuritySystemDBEncStartModeOff)
#define GetSecuritySystemDBEncStartPassphrase(%Record) $li(%Record,$$$SecuritySystemDBEncStartPassphraseOff)
#define GetSecuritySystemDBEncStartRequired(%Record) $li(%Record,$$$SecuritySystemDBEncStartRequiredOff)
#define GetSecuritySystemDBEncStartUsername(%Record) $li(%Record,$$$SecuritySystemDBEncStartUsernameOff)
#define GetSecuritySystemDefaultSecurityDomain(%Record) $li(%Record,$$$SecuritySystemDefaultSecurityDomainOff)
#define GetSecuritySystemDefaultSignatureHash(%Record) $li(%Record,$$$SecuritySystemDefaultSignatureHashOff)
#define GetSecuritySystemDescription(%Record) $li(%Record,$$$SecuritySystemDescriptionOff)
#define GetSecuritySystemInactiveLimit(%Record) $li(%Record,$$$SecuritySystemInactiveLimitOff)
#define GetSecuritySystemInvalidLoginLimit(%Record) $li(%Record,$$$SecuritySystemInvalidLoginLimitOff)
#define GetSecuritySystemInvalidLoginAction(%Record) +$lg(%Record,$$$SecuritySystemInvalidLoginActionOff)
#define GetSecuritySystemKeyEncKeyIterations(%Record) $li(%Record,$$$SecuritySystemKeyEncKeyIterationsOff)
#define GetSecuritySystemKeyEncKeyLength(%Record) $li(%Record,$$$SecuritySystemKeyEncKeyLengthOff)
#define GetSecuritySystemKeyEncKeySaltLength(%Record) $li(%Record,$$$SecuritySystemKeyEncKeySaltLengthOff)
#define GetSecuritySystemLDAPAttributes(%Record) $lg(%Record,$$$SecuritySystemLDAPAttributesOff)
#define GetSecuritySystemLDAPAttributeComment(%Record) $lg(%Record,$$$SecuritySystemLDAPAttributeCommentOff)
#define GetSecuritySystemLDAPAttributeFullName(%Record) $lg(%Record,$$$SecuritySystemLDAPAttributeFullNameOff)
#define GetSecuritySystemLDAPAttributeNameSpace(%Record) $lg(%Record,$$$SecuritySystemLDAPAttributeNameSpaceOff)
#define GetSecuritySystemLDAPAttributeRoutine(%Record) $lg(%Record,$$$SecuritySystemLDAPAttributeRoutineOff)
#define GetSecuritySystemLDAPAttributeRoles(%Record) $lg(%Record,$$$SecuritySystemLDAPAttributeRolesOff)
#define GetSecuritySystemLDAPBaseDN(%Record) $lg(%Record,$$$SecuritySystemLDAPBaseDNOff)
#define GetSecuritySystemLDAPClientTimeout(%Record) $lg(%Record,$$$SecuritySystemLDAPClientTimeoutOff)
#define GetSecuritySystemLDAPDomainName(%Record) $lg(%Record,$$$SecuritySystemLDAPDomainNameOff)
#define GetSecuritySystemLDAPFlags(%Record) +$lg(%Record,$$$SecuritySystemLDAPFlagsOff)
#define GetSecuritySystemLDAPHostNames(%Record) $lg(%Record,$$$SecuritySystemLDAPHostNamesOff)
#define GetSecuritySystemLDAPSearchPassword(%Record) $lg(%Record,$$$SecuritySystemLDAPSearchPasswordOff)
#define GetSecuritySystemLDAPSearchUsername(%Record) $lg(%Record,$$$SecuritySystemLDAPSearchUsernameOff)
#define GetSecuritySystemLDAPServerTimeout(%Record) $lg(%Record,$$$SecuritySystemLDAPServerTimeoutOff)
#define GetSecuritySystemLDAPUniqueDNIdentifier(%Record) $lg(%Record,$$$SecuritySystemLDAPUniqueDNIdentifierOff)
#define GetSecuritySystemLDAPCACertFile(%Record) $lg(%Record,$$$SecuritySystemLDAPCACertFileOff)
#define GetSecuritySystemLoginCookieTimeout(%Record) +$lg(%Record,$$$SecuritySystemLoginCookieTimeoutOff)
#define GetSecuritySystemPasswordExpirationDays(%Record) +$lg(%Record,$$$SecuritySystemPasswordExpirationDaysOff)
#define GetSecuritySystemPasswordPattern(%Record) $li(%Record,$$$SecuritySystemPasswordPatternOff)
#define GetSecuritySystemPasswordValidationRoutine(%Record) $lg(%Record,$$$SecuritySystemPasswordValidationRoutineOff)
#define GetSecuritySystemPercentGlobalWrite(%Record) $li(%Record,$$$SecuritySystemPercentGlobalWriteOff)
#define GetSecuritySystemRequiredRole(%Record) $lg(%Record,$$$SecuritySystemRequiredRoleOff)
#define GetSecuritySystemSecurityDomains(%Record) $li(%Record,$$$SecuritySystemSecurityDomainsOff)
#define GetSecuritySystemSSLSuperServer(%Record) +$lg(%Record,$$$SecuritySystemSSLSuperServerOff)
#define GetSecuritySystemSMTPPassword(%Record) $lg(%Record,$$$SecuritySystemSMTPPasswordOff)
#define GetSecuritySystemSMTPServer(%Record) $lg(%Record,$$$SecuritySystemSMTPServerOff)
#define GetSecuritySystemSMTPUsername(%Record) $lg(%Record,$$$SecuritySystemSMTPUsernameOff)
#define GetSecuritySystemTwoFactorEnabled(%Record) +$lg(%Record,$$$SecuritySystemTwoFactorEnabledOff)
#define GetSecuritySystemTwoFactorFrom(%Record) $lg(%Record,$$$SecuritySystemTwoFactorFromOff)
#define GetSecuritySystemTwoFactorPWIssuer(%Record) $lg(%Record,$$$SecuritySystemTwoFactorPWIssuerOff)
#define GetSecuritySystemTwoFactorTimeout(%Record) +$lg(%Record,$$$SecuritySystemTwoFactorTimeoutOff)
 
#define SaveSecuritySystemRecord(%System,%Record) s $$$SecurityGlobalSystem(%System)=%Record
#;Login rules definitions 
#define SecurityLoginRulesExists(%System,%Record) ($d($$$SecurityGlobalLoginRules(%System),%Record)#10=1)
#define SecurityLoginRulesDefaultSecurityDomainOff 2
#define SecurityLoginRulesDescriptionOff 3
#define SecurityLoginRulesInactiveLimitOff 4
#define SecurityLoginRulesInvalidLoginActionOff 5
#define SecurityLoginRulesInvalidLoginLimitOff 6
#define SecurityLoginRulesLDAPAttributeCommentOff 7
#define SecurityLoginRulesLDAPAttributeFullNameOff 8
#define SecurityLoginRulesLDAPAttributeNameSpaceOff 9
#define SecurityLoginRulesLDAPAttributeRolesOff 10
#define SecurityLoginRulesLDAPAttributeRoutineOff 11
#define SecurityLoginRulesLDAPAttributesOff 12
#define SecurityLoginRulesLDAPBaseDNOff 13
#define SecurityLoginRulesLDAPCACertFileOff 14
#define SecurityLoginRulesLDAPClientTimeoutOff 15
#define SecurityLoginRulesLDAPDomainNameOff 16
#define SecurityLoginRulesLDAPFlagsOff 17
#define SecurityLoginRulesLDAPHostNamesOff 18
#define SecurityLoginRulesLDAPSearchPasswordOff 19
#define SecurityLoginRulesLDAPSearchUsernameOff 20
#define SecurityLoginRulesLDAPServerTimeoutOff 21
#define SecurityLoginRulesLDAPUniqueDNIdentifierOff 22
#define SecurityLoginRulesPasswordExpirationDaysOff 23
#define SecurityLoginRulesPasswordPatternOff 24
#define SecurityLoginRulesPasswordValidationRoutineOff 25
#define SecurityLoginRulesSecurityDomainsOff 26
#define GetSecurityLoginRulesDefaultSecurityDomain(%Record) $li(%Record,$$$SecurityLoginRulesDefaultSecurityDomainOff)
#define GetSecurityLoginRulesDescription(%Record) $li(%Record,$$$SecurityLoginRulesDescriptionOff)
#define GetSecurityLoginRulesInactiveLimit(%Record) $li(%Record,$$$SecurityLoginRulesInactiveLimitOff)
#define GetSecurityLoginRulesInvalidLoginAction(%Record) +$lg(%Record,$$$SecurityLoginRulesInvalidLoginActionOff)
#define GetSecurityLoginRulesInvalidLoginLimit(%Record) $li(%Record,$$$SecurityLoginRulesInvalidLoginLimitOff)
#define GetSecurityLoginRulesLDAPAttributeComment(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPAttributeCommentOff)
#define GetSecurityLoginRulesLDAPAttributeFullName(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPAttributeFullNameOff)
#define GetSecurityLoginRulesLDAPAttributeNameSpace(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPAttributeNameSpaceOff)
#define GetSecurityLoginRulesLDAPAttributeRoutine(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPAttributeRoutineOff)
#define GetSecurityLoginRulesLDAPAttributeRoles(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPAttributeRolesOff)
#define GetSecurityLoginRulesLDAPAttributes(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPAttributesOff)
#define GetSecurityLoginRulesLDAPBaseDN(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPBaseDNOff)
#define GetSecurityLoginRulesLDAPCACertFile(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPCACertFileOff)
#define GetSecurityLoginRulesLDAPClientTimeout(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPClientTimeoutOff)
#define GetSecurityLoginRulesLDAPDomainName(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPDomainNameOff)
#define GetSecurityLoginRulesLDAPFlags(%Record) +$lg(%Record,$$$SecurityLoginRulesLDAPFlagsOff)
#define GetSecurityLoginRulesLDAPHostNames(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPHostNamesOff)
#define GetSecurityLoginRulesLDAPSearchPassword(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPSearchPasswordOff)
#define GetSecurityLoginRulesLDAPSearchUsername(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPSearchUsernameOff)
#define GetSecurityLoginRulesLDAPServerTimeout(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPServerTimeoutOff)
#define GetSecurityLoginRulesLDAPUniqueDNIdentifier(%Record) $lg(%Record,$$$SecurityLoginRulesLDAPUniqueDNIdentifierOff)
#define GetSecurityLoginRulesPasswordExpirationDays(%Record) +$lg(%Record,$$$SecurityLoginRulesPasswordExpirationDaysOff)
#define GetSecurityLoginRulesPasswordPattern(%Record) $li(%Record,$$$SecurityLoginRulesPasswordPatternOff)
#define GetSecurityLoginRulesPasswordValidationRoutine(%Record) $lg(%Record,$$$SecurityLoginRulesPasswordValidationRoutineOff)
#define GetSecurityLoginRulesSecurityDomains(%Record) $li(%Record,$$$SecurityLoginRulesSecurityDomainsOff)

#;The following are definitions for the Security.SystemLocal Class global structure
#define SecuritySystemLocalExists(%System,%Record) ($d($$$SecurityGlobalSystemLocal(%System),%Record)#10=1)
#define SecuritySystemLocalIsSecurityDBServerOff 2
#define SecuritySystemLocalSecurityDBLocationOff 3
 
#define GetSecuritySystemLocalSecurityDBLocation(%Record) $li(%Record,$$$SecuritySystemLocalSecurityDBLocationOff)
#define GetSecuritySystemLocalIsSecurityDBServer(%Record) $li(%Record,$$$SecuritySystemLocalIsSecurityDBServerOff)
 
#;The following are definitions for the Security.Domains Class global structure
#define SecurityDomainsExists(%Domain,%Record) ($d($$$SecurityGlobalDomains(%Domain),%Record)#10=1)
#define SecurityDomainsDescriptionOff 2
#define SecurityDomainsNameOff 3
#define GetSecurityDomainsDescription(%Record) $li(%Record,$$$SecurityDomainsDescriptionOff)
#define GetSecurityDomainsName(%Record) $li(%Record,$$$SecurityDomainsNameOff)
 
#;The following are definitions for the Security.Resources Class global structure
#define SecurityResourcesExists(%Resource,%Record) ($d($$$SecurityGlobalResources(%Resource),%Record)#10=1)
#define SecurityResourcesDescriptionOff 2
#define SecurityResourcesNameOff 3
#define SecurityResourcesPublicPermissionOff 4
#define SecurityResourcesTypeOff 5
#define GetSecurityResourcesDescription(%Record) $li(%Record,$$$SecurityResourcesDescriptionOff)
#define GetSecurityResourcesName(%Record) $li(%Record,$$$SecurityResourcesNameOff)
#define GetSecurityResourcesPublicPermission(%Record) +$li(%Record,$$$SecurityResourcesPublicPermissionOff)
#define GetSecurityResourcesType(%Record) $li(%Record,$$$SecurityResourcesTypeOff)
 
#;The following are definitions for the Security.Events Class global structure
#define SecurityEventsExists(%Source,%Type,%Name,%Record) ($d($$$SecurityGlobalEvents(%Source,%Type,%Name),%Record)#10=1)
#define SecurityEventsDescriptionOff 2
#define SecurityEventsEnabledOff 3
#define SecurityEventsFlagsOff 4
#define SecurityEventsNameOff 5
#define SecurityEventsSourceOff 6
#define SecurityEventsTypeOff 7
#define GetSecurityEventsDescription(%Record) $li(%Record,$$$SecurityEventsDescriptionOff)
#define GetSecurityEventsEnabled(%Record) $li(%Record,$$$SecurityEventsEnabledOff)
#define GetSecurityEventsName(%Record) $li(%Record,$$$SecurityEventsNameOff)
#define GetSecurityEventsSource(%Record) $li(%Record,$$$SecurityEventsSourceOff)
#define GetSecurityEventsType(%Record) $li(%Record,$$$SecurityEventsTypeOff)
#define GetSecurityEventsFlags(%Record) +$li(%Record,$$$SecurityEventsFlagsOff)
 
#;The following are definitions for the Security.Roles Class global structure
#define SecurityRolesExists(%Role,%Record) ($$RoleExists^%SYS.SECURITY(%Role,.%Record))
#define SecurityRolesExistsDeprecated(%Role,%Record) ($d($$$SecurityGlobalRoles(%Role),%Record)#10=1)
#define SecurityRolesDescriptionOff 2
#define SecurityRolesGrantedRolesOff 3
#define SecurityRolesNameOff 4
#define GetSecurityRolesDescription(%Record) $li(%Record,$$$SecurityRolesDescriptionOff)
#define GetSecurityRolesGrantedRoles(%Record) $li(%Record,$$$SecurityRolesGrantedRolesOff)
#define GetSecurityRolesName(%Record) $li(%Record,$$$SecurityRolesNameOff)
#;macro to get list of role resources
#define SecurityRolesResourcesOff 2
#define SecurityRolesResourcesPermissionOff 3
#;define GetNextSecurityRolesResource(%Role,%Key,%Record) $o(^|$$$SecurityMapGroup|SYS("Security","RolesD",$zcvt(%Role,"L"),"Resources",%Key),1,%Record)
#define GetNextSecurityRolesResource(%Role,%Key,%Record) $o($$$SecurityMapGlobal("Security","RolesD",$zcvt(%Role,"L"),"Resources",%Key),1,%Record)
#define GetSecurityRolesResourcesName(%Record) $li(%Record,$$$SecurityRolesResourcesOff)
#define GetSecurityRolesResourcesPermission(%Record) $li(%Record,$$$SecurityRolesResourcesPermissionOff)
 
#;The following are definitions for the Security.Roles SQL Class global structure
#define SecurityRolesSQLOwnerOff 2
#define SecurityRolesOwnerDirect(%Role) $lg($g($$$SecurityGlobalRolesExt(%Role)),2)
#define GetSecurityRolesSQLOwner(%Record) $lg(%Record,$$$SecurityRolesSQLOwnerOff)
 
#;define SetSecurityRolesSQLData(%Role,%Record) s $$$SecurityRolesSQLGlobal(%Role)=%Record
#; The following macros for Roles take a role name and returns the information from the global, not a record
#;define SecurityRolesSQLGlobal(%Role) $$$SecurityGlobalRoles,$zcvt(%Role,"L"),1)
#;define SecurityRolesSQLExists(%Role) ($d($$$SecurityRolesGlobal(%Role))#10=1)
#;define GetSecurityRolesSQLData(%Role,%Record) s %Record=$g($$$SecurityRolesSQLGlobal(%Role))
 
 
#;The following are two macros used to create a new user for LDAP and Delegated authentication
#;Roles should be a comma delimited list of roles.
#define UpdateUserRecord(%UserRecord,%Properties) s Status=##Class(Security.Users).Modify($Username,%Properties) i $$$SecurityUsersExists($Username,%UserRecord)
#define CreateUserRecord(%UserRecord,%Properties) s Status=##Class(Security.Users).Create($Username,%Properties) i $$$SecurityUsersExists($Username,%UserRecord)
 
#;The following are definitions for the Security.Users Class global structure
#define SecurityUsersExists(%Username,%Record) ($d($$$SecurityGlobalUsers(%Username),%Record)#10=1)
#define SecurityUsersChangePasswordOff 2
#define SecurityUsersCommentOff 3
#define SecurityUsersEnabledOff 4
#define SecurityUsersEventFlagsOff 5
#define SecurityUsersExpirationDateOff 6
#define SecurityUsersFullNameOff 7
#define SecurityUsersInvalidLoginAttemptsOff 8
#define SecurityUsersInvalidLoginDateTimeOff 9
#define SecurityUsersInvalidLoginDeviceOff 10
#define SecurityUsersInvalidLoginServiceOff 11
#define SecurityUsersInvalidLoginStatusOff 12
#define SecurityUsersLegacyPasswordOff 13
#define SecurityUsersLoginDateTimeOff 14
#define SecurityUsersLoginDeviceOff 15
#define SecurityUsersLoginServiceOff 16
#define SecurityUsersNameOff 17
#define SecurityUsersNameSpaceOff 18
#define SecurityUsersPasswordOff 19
#define SecurityUsersPasswordChangedDateTimeOff 20
#define SecurityUsersRolesOff 21
#define SecurityUsersRoutineOff 22
#define SecurityUsersSuperUserOff 23
#define SecurityUsersSaltOff 24
#define SecurityUsersFlagsOff 25
#define SecurityUsersAttributesOff 26
#define SecurityUsersPhoneNumberOff 27
#define SecurityUsersPhoneProviderOff 28
#define SecurityUsersAccountNeverExpiresOff 29
#define SecurityUsersPasswordNeverExpiresOff 30
#define SecurityUsersEMSGroupEnabledOff 31
#define SecurityUsersAutheEnabledOff 32
#define SecurityUsersCreateDateTimeOff 33
#define SecurityUsersCreateUsernameOff 34
#define SecurityUsersLastModifiedDateTimeOff 35
#define SecurityUsersLastModifiedInfoOff 36
#define SecurityUsersLastModifiedUsernameOff 37
#define SecurityUsersHOTPKeyOff 38
#define SecurityUsersHOTPKeyDisplayOff 39
#define SecurityUsersEmailAddressOff 40
#define SecurityUsersTOTPLastValidPasswordsOff 41

#define GetSecurityUsersAttributes(%Record) $li(%Record,$$$SecurityUsersAttributesOff)
#define GetSecurityUsersAccountNeverExpires(%Record) +$lg(%Record,$$$SecurityUsersAccountNeverExpiresOff)
#define GetSecurityUsersAutheEnabled(%Record) +$lg(%Record,$$$SecurityUsersAutheEnabledOff)
#define GetSecurityUsersChangePassword(%Record) $li(%Record,$$$SecurityUsersChangePasswordOff)
#define GetSecurityUsersComment(%Record) $li(%Record,$$$SecurityUsersCommentOff)
#define GetSecurityUsersCreateDateTime(%Record) $li(%Record,$$$SecurityUsersCreateDateTimeOff)
#define GetSecurityUsersCreateUsername(%Record) $li(%Record,$$$SecurityUsersCreateUsernameOff)
#define GetSecurityUsersEmailAddress(%Record) $lg(%Record,$$$SecurityUsersEmailAddressOff)
#define GetSecurityUsersEMSGroupEnabled(%Record) $li(%Record,$$$SecurityUsersEMSGroupEnabledOff)
#define GetSecurityUsersEnabled(%Record) $li(%Record,$$$SecurityUsersEnabledOff)
#define GetSecurityUsersEventFlags(%Record) $li(%Record,$$$SecurityUsersEventFlagsOff)
#define GetSecurityUsersExpirationDate(%Record) $li(%Record,$$$SecurityUsersExpirationDateOff)
#define GetSecurityUsersFlags(%Record) $li(%Record,$$$SecurityUsersFlagsOff)
#define GetSecurityUsersFullName(%Record) $li(%Record,$$$SecurityUsersFullNameOff)
#define GetSecurityUsersHOTPKey(%Record) $li(%Record,$$$SecurityUsersHOTPKeyOff)
#define GetSecurityUsersHOTPKeyDisplay(%Record) +$lg(%Record,$$$SecurityUsersHOTPKeyDisplayOff)
#define GetSecurityUsersInvalidLoginAttempts(%Record) $li(%Record,$$$SecurityUsersInvalidLoginAttemptsOff)
#define GetSecurityUsersInvalidLoginDateTime(%Record) $li(%Record,$$$SecurityUsersInvalidLoginDateTimeOff)
#define GetSecurityUsersInvalidLoginDevice(%Record) $li(%Record,$$$SecurityUsersInvalidLoginDeviceOff)
#define GetSecurityUsersInvalidLoginService(%Record) $li(%Record,$$$SecurityUsersInvalidLoginServiceOff)
#define GetSecurityUsersInvalidLoginStatus(%Record) $li(%Record,$$$SecurityUsersInvalidLoginStatusOff)
#define GetSecurityUsersLastModifiedDateTime(%Record) $li(%Record,$$$SecurityUsersLastModifiedDateTimeOff)
#define GetSecurityUsersLastModifiedUsername(%Record) $li(%Record,$$$SecurityUsersLastModifiedUsernameOff)
#define GetSecurityUsersLastModifiedInfo(%Record) $li(%Record,$$$SecurityUsersLastModifiedInfoOff)
#define GetSecurityUsersLegacyPassword(%Record) $li(%Record,$$$SecurityUsersLegacyPasswordOff)
#define GetSecurityUsersLoginDateTime(%Record) $li(%Record,$$$SecurityUsersLoginDateTimeOff)
#define GetSecurityUsersLoginDevice(%Record) $li(%Record,$$$SecurityUsersLoginDeviceOff)
#define GetSecurityUsersLoginService(%Record) $li(%Record,$$$SecurityUsersLoginServiceOff)
#define GetSecurityUsersName(%Record) $li(%Record,$$$SecurityUsersNameOff)
#define GetSecurityUsersNameSpace(%Record) $li(%Record,$$$SecurityUsersNameSpaceOff)
#define GetSecurityUsersPassword(%Record) $li(%Record,$$$SecurityUsersPasswordOff)
#define GetSecurityUsersPasswordChangedDateTime(%Record) $li(%Record,$$$SecurityUsersPasswordChangedDateTimeOff)
#define GetSecurityUsersPasswordNeverExpires(%Record) +$lg(%Record,$$$SecurityUsersPasswordNeverExpiresOff)
#define GetSecurityUsersPhoneNumber(%Record) $lg(%Record,$$$SecurityUsersPhoneNumberOff)
#define GetSecurityUsersPhoneProvider(%Record) $lg(%Record,$$$SecurityUsersPhoneProviderOff)
#define GetSecurityUsersRoles(%Record) $li(%Record,$$$SecurityUsersRolesOff)
#define GetSecurityUsersRoutine(%Record) $li(%Record,$$$SecurityUsersRoutineOff)
#define GetSecurityUsersSalt(%Record) $li(%Record,$$$SecurityUsersSaltOff)
#define GetSecurityUsersSuperUser(%Record) $lg(%Record,$$$SecurityUsersSuperUserOff)
#define GetSecurityUsersTOTPLastValidPasswords(%Record) $lg(%Record,$$$SecurityUsersTOTPLastValidPasswordsOff)
#;Set fields into the user record
#define SetSecurityUsersAccountNeverExpires(%Record,%Val) s $li(%Record,$$$SecurityUsersAccountNeverExpiresOff)=%Val
#define SetSecurityUsersAutheEnabled(%Record,%Val) s $li(%Record,$$$SecurityUsersAutheEnabledOff)=%Val
#define SetSecurityUsersAttributes(%Record,%Val) s $li(%Record,$$$SecurityUsersAttributesOff)=%Val
#define SetSecurityUsersChangePassword(%Record,%Val) s $li(%Record,$$$SecurityUsersChangePasswordOff)=%Val
#define SetSecurityUsersComment(%Record,%Val) s $li(%Record,$$$SecurityUsersCommentOff)=%Val
#define SetSecurityUsersCreateDateTime(%Record,%Val) s $li(%Record,$$$SecurityUsersCreateDateTimeOff)=%Val
#define SetSecurityUsersCreateUsername(%Record,%Val) s $li(%Record,$$$SecurityUsersCreateUsernameOff)=%Val
#define SetSecurityUsersEmailAddress(%Record,%Val) s $li(%Record,$$$SecurityUsersEmailAddressOff)=%Val
#define SetSecurityUsersEMSGroupEnabled(%Record,%Val) s $li(%Record,$$$SecurityUsersEMSGroupEnabledOff)=%Val
#define SetSecurityUsersEnabled(%Record,%Val) s $li(%Record,$$$SecurityUsersEnabledOff)=%Val
#define SetSecurityUsersExpirationDate(%Record,%Val) s $li(%Record,$$$SecurityUsersExpirationDateOff)=%Val
#define SetSecurityUsersFlags(%Record,%Val) s $li(%Record,$$$SecurityUsersFlagsOff)=%Val
#define SetSecurityUsersFullName(%Record,%Val) s $li(%Record,$$$SecurityUsersFullNameOff)=%Val
#define SetSecurityUsersHOTPKey(%Record,%Val) s $li(%Record,$$$SecurityUsersHOTPKeyOff)=%Val
#define SetSecurityUsersHOTPKeyDisplay(%Record,%Val) s $li(%Record,$$$SecurityUsersHOTPKeyDisplayOff)=%Val
#define SetSecurityUsersInvalidLoginAttempts(%Record,%Val) s $li(%Record,$$$SecurityUsersInvalidLoginAttemptsOff)=%Val
#define SetSecurityUsersInvalidLoginDateTime(%Record,%Val) s $li(%Record,$$$SecurityUsersInvalidLoginDateTimeOff)=%Val
#define SetSecurityUsersInvalidLoginDevice(%Record,%Val) s $li(%Record,$$$SecurityUsersInvalidLoginDeviceOff)=%Val
#define SetSecurityUsersInvalidLoginService(%Record,%Val) s $li(%Record,$$$SecurityUsersInvalidLoginServiceOff)=%Val
#define SetSecurityUsersInvalidLoginStatus(%Record,%Val) s $li(%Record,$$$SecurityUsersInvalidLoginStatusOff)=%Val
#define SetSecurityUsersLastModifiedDateTime(%Record,%Val) s $li(%Record,$$$SecurityUsersLastModifiedDateTimeOff)=%Val
#define SetSecurityUsersLastModifiedInfo(%Record,%Val) s $li(%Record,$$$SecurityUsersLastModifiedInfoOff)=%Val
#define SetSecurityUsersLastModifiedUsername(%Record,%Val) s $li(%Record,$$$SecurityUsersLastModifiedUsernameOff)=%Val
#define SetSecurityUsersLegacyPassword(%Record,%Val) s $li(%Record,$$$SecurityUsersLegacyPasswordOff)=%Val
#define SetSecurityUsersLoginDateTime(%Record,%Val) s $li(%Record,$$$SecurityUsersLoginDateTimeOff)=%Val
#define SetSecurityUsersLoginDevice(%Record,%Val) s $li(%Record,$$$SecurityUsersLoginDeviceOff)=%Val
#define SetSecurityUsersLoginService(%Record,%Val) s $li(%Record,$$$SecurityUsersLoginServiceOff)=%Val
#define SetSecurityUsersName(%Record,%Val) s $li(%Record,$$$SecurityUsersNameOff)=%Val
#define SetSecurityUsersRoles(%Record,%Val) s $li(%Record,$$$SecurityUsersRolesOff)=%Val
#define SetSecurityUsersNameSpace(%Record,%Val) s $li(%Record,$$$SecurityUsersNameSpaceOff)=%Val
#define SetSecurityUsersPassword(%Record,%Val) s $li(%Record,$$$SecurityUsersPasswordOff)=%Val
#define SetSecurityUsersPasswordChangedDateTime(%Record,%Val) s $li(%Record,$$$SecurityUsersPasswordChangedDateTimeOff)=%Val
#define SetSecurityUsersPasswordNeverExpires(%Record,%Val) s $li(%Record,$$$SecurityUsersPasswordNeverExpiresOff)=%Val
#define SetSecurityUsersPhoneNumber(%Record,%Val) s $li(%Record,$$$SecurityUsersPhoneNumberOff)=%Val
#define SetSecurityUsersPhoneProvider(%Record,%Val) s $li(%Record,$$$SecurityUsersPhoneProviderOff)=%Val
#define SetSecurityUsersSalt(%Record,%Val) s $li(%Record,$$$SecurityUsersSaltOff)=%Val
#define SetSecurityUsersRoles(%Record,%Val) s $li(%Record,$$$SecurityUsersRolesOff)=%Val
#define SetSecurityUsersRoutine(%Record,%Val) s $li(%Record,$$$SecurityUsersRoutineOff)=%Val
#define SetSecurityUsersSuperUser(%Record,%Val) s $li(%Record,$$$SecurityUsersSuperUserOff)=%Val
#define SetSecurityUsersTOTPLastValidPasswords(%Record,%Val) s $li(%Record,$$$SecurityUsersTOTPLastValidPasswordsOff)=%Val

#;Save the user record directly to the global 
#define SaveSecurityUsersRecord(%Username,%Record) s $$$SecurityGlobalUsers(%Username)=%Record
#define KillSecurityUsersRecord(%Username) k $$$SecurityGlobalUsers(%Username)
 
#;The following are definitions for the Security.Services Class global structure
#define SecurityServicesExists(%Service,%Record) ($d($$$SecurityGlobalServices(%Service),%Record)#10=1)
#define SecurityServicesAutheEnabledOff 2
#define SecurityServicesAutheEnabledCapabilitiesOff 3
#define SecurityServicesAuthenticationRequiredOff 4
#define SecurityServicesCapabilitiesOff 5
#define SecurityServicesClientSystemsOff 6
#define SecurityServicesDescriptionOff 7
#define SecurityServicesEnabledOff 8
#define SecurityServicesTwoFactorEnabledOff 10
#define SecurityServicesHttpOnlyCookiesOff 11
#define GetSecurityServicesAutheEnabled(%Record) +$li(%Record,$$$SecurityServicesAutheEnabledOff)
#define GetSecurityServicesAutheEnabledCapabilities(%Record) +$li(%Record,$$$SecurityServicesAutheEnabledCapabilitiesOff)
#define GetSecurityServicesAuthenticationRequired(%Record) $li(%Record,$$$SecurityServicesAuthenticationRequiredOff)
#define GetSecurityServicesCapabilities(%Record) +$li(%Record,$$$SecurityServicesCapabilitiesOff)
#define GetSecurityServicesClientSystems(%Record) $li(%Record,$$$SecurityServicesClientSystemsOff)
#define GetSecurityServicesDescription(%Record) $li(%Record,$$$SecurityServicesDescriptionOff)
#define GetSecurityServicesEnabled(%Record) $li(%Record,$$$SecurityServicesEnabledOff)
#define GetSecurityServicesHttpOnlyCookies(%Record) +$lg(%Record,$$$SecurityServicesHttpOnlyCookiesOff)
#define GetSecurityServicesTwoFactorEnabled(%Record) +$lg(%Record,$$$SecurityServicesTwoFactorEnabledOff)

#;The following are definitions for the Security.X509Users Class global structure
#;EMSSecurityX509UsersExists should be used for editing EMS data
#;SecurityX509UsersExists should be used for checking permissions
#define SecurityX509UsersExists(%LookupKey,%Record) ($d($$$SecurityGlobalX509Users(%LookupKey),%Record)#10=1)
#define SecurityX509UsersCommentOff 2
#define SecurityX509UsersEnabledOff 3
#define SecurityX509UsersLookupKeyOff 4
#define SecurityX509UsersUsernameOff 5
#define GetSecurityX509UsersComment(%Record) $lg(%Record,$$$SecurityX509UsersCommentOff)
#define GetSecurityX509UsersEnabled(%Record) +$lg(%Record,$$$SecurityX509UsersEnabledOff)
#define GetSecurityX509UsersLookupKeyPage(%Record) $lg(%Record,$$$SecurityX509UsersLookupKeyOff)
#define GetSecurityX509UsersUsernameKeys(%Record) $lg(%Record,$$$SecurityX509UsersUsernameOff)

#;The following are definitions for the Security.Applications Class global structure
#;EMSSecurityApplicationsExists should be used for editing EMS data
#;SecurityApplicationsExists should be used for checking permissions
#define SecurityApplicationsExists(%Application,%Record) ($d($$$SecurityGlobalApplications(%Application),%Record)#10=1)
#define SecurityApplicationsAutheEnabledOff 2
#define SecurityApplicationsAutoCompileOff 3
#define SecurityApplicationsClientApplicationsOff 4
#define SecurityApplicationsCookiePathOff 5
#define SecurityApplicationsDescriptionOff 6
#define SecurityApplicationsEnabledOff 7
#define SecurityApplicationsErrorPageOff 8
#define SecurityApplicationsEventClassOff 9
#define SecurityApplicationsHyperEventOff 10
#define SecurityApplicationsLockCSPNameOff 11
#define SecurityApplicationsLoginPageOff 12
#define SecurityApplicationsMatchRolesOff 13
#define SecurityApplicationsNameOff 14
#define SecurityApplicationsNameSpaceOff 15
#define SecurityApplicationsPackageOff 16
#define SecurityApplicationsPathOff 17
#define SecurityApplicationsRecurseOff 18
#define SecurityApplicationsResourceOff 19
#define SecurityApplicationsRoutinesOff 20
#define SecurityApplicationsServeFilesOff 21
#define SecurityApplicationsSuperClassOff 22
#define SecurityApplicationsTimeoutOff 23
#define SecurityApplicationsTypeOff 24
#define SecurityApplicationsUseCookiesOff 25
#define SecurityApplicationsChangePasswordPageOff 26
#define SecurityApplicationsServeFilesTimeoutOff 27
#define SecurityApplicationsTwoFactorEnabledOff 28
#define SecurityApplicationsCSPZENEnabledOff 29
#define SecurityApplicationsInbndWebServicesEnabledOff 30
#define SecurityApplicationsGroupByIdOff 31
#define SecurityApplicationsIsNameSpaceDefaultOff 32
#define SecurityApplicationsPermittedClassesOff 33
#define SecurityApplicationsDispatchClassOff 34
#define SecurityApplicationsDeepSeeEnabledOff 35
#define SecurityApplicationsiKnowEnabledOff 36
#define SecurityApplicationsCSRFTokenOff 37
#define GetSecurityApplicationsAutheEnabled(%Record) +$lg(%Record,$$$SecurityApplicationsAutheEnabledOff)
#define GetSecurityApplicationsAutoCompile(%Record) $lg(%Record,$$$SecurityApplicationsAutoCompileOff)
#define GetSecurityApplicationsChangePasswordPage(%Record) $lg(%Record,$$$SecurityApplicationsChangePasswordPageOff)
#define GetSecurityApplicationsClientApplications(%Record) $lg(%Record,$$$SecurityApplicationsClientApplicationsOff)
#define GetSecurityApplicationsCookiePath(%Record) $lg(%Record,$$$SecurityApplicationsCookiePathOff)
#define GetSecurityApplicationsCSPZENEnabled(%Record) $lg(%Record,$$$SecurityApplicationsCSPZENEnabledOff)
#define GetSecurityApplicationsCSRFToken(%Record) +$lg(%Record,$$$SecurityApplicationsCSRFTokenOff)
#define GetSecurityApplicationsDeepSeeEnabled(%Record) $lg(%Record,$$$SecurityApplicationsDeepSeeEnabledOff)
#define GetSecurityApplicationsDescription(%Record) $lg(%Record,$$$SecurityApplicationsDescriptionOff)
#define GetSecurityApplicationsEnabled(%Record) $lg(%Record,$$$SecurityApplicationsEnabledOff)
#define GetSecurityApplicationsErrorPage(%Record) $lg(%Record,$$$SecurityApplicationsErrorPageOff)
#define GetSecurityApplicationsEventClass(%Record) $lg(%Record,$$$SecurityApplicationsEventClassOff)
#define GetSecurityApplicationsGroupById(%Record) $lg(%Record,$$$SecurityApplicationsGroupByIdOff)
#define GetSecurityApplicationsHyperEvent(%Record) $lg(%Record,$$$SecurityApplicationsHyperEventOff)
#define GetSecurityApplicationsiKnowEnabled(%Record) $lg(%Record,$$$SecurityApplicationsiKnowEnabledOff)
#define GetSecurityApplicationsInbndWebServicesEnabled(%Record) $lg(%Record,$$$SecurityApplicationsInbndWebServicesEnabledOff)
#define GetSecurityApplicationsIsNameSpaceDefault(%Record) $lg(%Record,$$$SecurityApplicationsIsNameSpaceDefaultOff)
#define GetSecurityApplicationsLockCSPName(%Record) $lg(%Record,$$$SecurityApplicationsLockCSPNameOff)
#define GetSecurityApplicationsLoginPage(%Record) $lg(%Record,$$$SecurityApplicationsLoginPageOff)
#define GetSecurityApplicationsMatchRoles(%Record) $lg(%Record,$$$SecurityApplicationsMatchRolesOff)
#define GetSecurityApplicationsName(%Record) $lg(%Record,$$$SecurityApplicationsNameOff)
#define GetSecurityApplicationsNameSpace(%Record) $lg(%Record,$$$SecurityApplicationsNameSpaceOff)
#define GetSecurityApplicationsPackage(%Record) $lg(%Record,$$$SecurityApplicationsPackageOff)
#define GetSecurityApplicationsPath(%Record) $lg(%Record,$$$SecurityApplicationsPathOff)
#define GetSecurityApplicationsPermittedClasses(%Record) $lg(%Record,$$$SecurityApplicationsPermittedClassesOff)
#define GetSecurityApplicationsRecurse(%Record) $lg(%Record,$$$SecurityApplicationsRecurseOff)
#define GetSecurityApplicationsResource(%Record) $lg(%Record,$$$SecurityApplicationsResourceOff)
#define GetSecurityApplicationsRoutines(%Record) $lg(%Record,$$$SecurityApplicationsRoutinesOff)
#define GetSecurityApplicationsServeFiles(%Record) $lg(%Record,$$$SecurityApplicationsServeFilesOff)
#define GetSecurityApplicationsServeFilesTimeout(%Record) $lg(%Record,$$$SecurityApplicationsServeFilesTimeoutOff)
#define GetSecurityApplicationsSuperClass(%Record) $lg(%Record,$$$SecurityApplicationsSuperClassOff)
#define GetSecurityApplicationsTimeout(%Record) $lg(%Record,$$$SecurityApplicationsTimeoutOff)
#define GetSecurityApplicationsTwoFactorEnabled(%Record) $lg(%Record,$$$SecurityApplicationsTwoFactorEnabledOff)
#define GetSecurityApplicationsType(%Record) +$lg(%Record,$$$SecurityApplicationsTypeOff)
#define GetSecurityApplicationsUseCookies(%Record) $lg(%Record,$$$SecurityApplicationsUseCookiesOff)
#define GetSecurityApplicationsDispatchClass(%Record) $lg(%Record,$$$SecurityApplicationsDispatchClassOff)
#;macro to get list of role resources
#define SecurityApplicationsMatchRoleNameOff 2
#define SecurityApplicationsMatchRoleTargetRolesOff 3
#define GetNextSecurityApplicationsMatchRole(%Application,%Key,%Record) $o($$$SecurityGlobalApplications,$zcvt(%Application,"L"),"MatchRoles",%Key),1,%Record)
#define GetSecurityApplicationsMatchRoleName(%Record) $li(%Record,$$$SecurityApplicationsMatchRoleNameOff)
#define GetSecurityApplicationsMatchRoleTargetRoles(%Record) $li(%Record,$$$SecurityApplicationsMatchRoleTargetRolesOff)
#;macro to get list of Routines
#define SecurityApplicationsRoutineDatabaseOff 2
#define SecurityApplicationsRoutineNameOff 3
#define GetNextSecurityApplicationsRoutine(%Application,%Key,%Record) $o($$$SecurityGlobalApplications,$zcvt(%Application,"L"),"Routines",%Key),1,%Record)
#define GetSecurityApplicationsRoutineDatabase(%Record) $li(%Record,$$$SecurityApplicationsRoutineDatabaseOff)
#define GetSecurityApplicationsRoutineName(%Record) $li(%Record,$$$SecurityApplicationsRoutineNameOff)
 
#;The following are definitions for the Security.SSLConfigs Class global structure
#define SecuritySSLConfigsExists(%SSLConfig,%Record) ($d($$$SecurityGlobalSSLConfigs(%SSLConfig),%Record)#10=1)
#define SecuritySSLConfigsCAFileOff 2
#define SecuritySSLConfigsCAPathOff 3
#define SecuritySSLConfigsCertificateFileOff 4
#define SecuritySSLConfigsCipherListOff 5
#define SecuritySSLConfigsDescriptionOff 6
#define SecuritySSLConfigsEnabledOff 7
#define SecuritySSLConfigsNameOff 8
#define SecuritySSLConfigsPrivateKeyFileOff 9
#define SecuritySSLConfigsPrivateKeyPasswordOff 10
#define SecuritySSLConfigsPrivateKeyTypeOff 11
#define SecuritySSLConfigsProtocolsOff 12
#define SecuritySSLConfigsTypeOff 13
#define SecuritySSLConfigsVerifyDepthOff 14
#define SecuritySSLConfigsVerifyPeerOff 15
#define SecuritySSLConfigsCRLFileOff 16
#define GetSecuritySSLConfigsCAFile(%Record) $li(%Record,$$$SecuritySSLConfigsCAFileOff)
#define GetSecuritySSLConfigsCAPath(%Record) $li(%Record,$$$SecuritySSLConfigsCAPathOff)
#define GetSecuritySSLConfigsCertificateFile(%Record) $li(%Record,$$$SecuritySSLConfigsCertificateFileOff)
#define GetSecuritySSLConfigsCipherList(%Record) $li(%Record,$$$SecuritySSLConfigsCipherListOff)
#define GetSecuritySSLConfigsDescription(%Record) $li(%Record,$$$SecuritySSLConfigsDescriptionOff)
#define GetSecuritySSLConfigsEnabled(%Record) $li(%Record,$$$SecuritySSLConfigsEnabledOff)
#define GetSecuritySSLConfigsName(%Record) $li(%Record,$$$SecuritySSLConfigsNameOff)
#define GetSecuritySSLConfigsPrivateKeyFile(%Record) $li(%Record,$$$SecuritySSLConfigsPrivateKeyFileOff)
#define GetSecuritySSLConfigsPrivateKeyPassword(%Record) $li(%Record,$$$SecuritySSLConfigsPrivateKeyPasswordOff)
#define GetSecuritySSLConfigsPrivateKeyType(%Record) $li(%Record,$$$SecuritySSLConfigsPrivateKeyTypeOff)
#define GetSecuritySSLConfigsProtocols(%Record) +$li(%Record,$$$SecuritySSLConfigsProtocolsOff)
#define GetSecuritySSLConfigsType(%Record) $li(%Record,$$$SecuritySSLConfigsTypeOff)
#define GetSecuritySSLConfigsVerifyDepth(%Record) $li(%Record,$$$SecuritySSLConfigsVerifyDepthOff)
#define GetSecuritySSLConfigsVerifyPeer(%Record) $li(%Record,$$$SecuritySSLConfigsVerifyPeerOff)
#define GetSecuritySSLConfigsCRLFile(%Record) $li(%Record,$$$SecuritySSLConfigsCRLFileOff)
 
#;The following are definitions for the Security Advisor csp page
#define AdvisorAuditing "Auditing"
#define AdvisorServices "Services"
#define AdvisorUsersAndRoles "UsersAndRoles"
#define AdvisorApplications "Applications"
#define AdvisorMsg "%SECURITY.Advisor" 


#; InitialConnect Types for $UsersCSPLogin^%SYS.SECURITY
#; Called from %Session.Login() username/pw is passed in
#define ApiLogin	 						3
#; CSP Token login
#define CSPTokenLogin						2 
#; Trying connection without username screen [initial connect]
#define NoUsernameLogin						1 
#; connect with username/password  [username passed in or after login screen]
#define UsernameLogin						0 

#define IscMgtPortalId "%ISCMgtPortal"

#define bldRunGroupId(%appGroupId,%browserId) ($zconvert(%appGroupId,"l")_":"_%browserId)
#define BrowserIdCookieName	"CacheBrowserId"
#define caNoAccessToRes  4
#define caNoAccessToApp  3
#define caUnknownTarget  2
#define caCanAccessRes   1
#define caNotCSPLink     0
#; internal codes are negative
#define caCheckAll	-1
#define caCheckResourcesOnly -2
#define gSecurityContextUsername(%securitycontext) $lg(%securitycontext,1)
