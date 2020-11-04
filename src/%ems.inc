ROUTINE %ems [Type=INC]
#; Shared Enterprise Manager and Managed Instance include file
#;
#; This include file is used internally by Cach&eacute;. You should not make direct
#; use of it within your applications. There is no guarantee made about either
#; the behavior or future operation of this class."
 
#; EMS version number
#define CSVersion 3.0
 
#; Instance management states
#define EMSCStateInitial            ""  /* State after initially created -- registering */
#define EMSCStateAwaitingAccept		1  /* AwaitingAccept*/
#; awaiting accept after reapply
#define EMSCStateAwaitingReaccept	7  /* AwaitingReaccept*/
#define EMSCStateManaged			2  /* Managed */
#define EMSCStateSuspended			3  /* Suspended */
#define EMSCStateNotUpdated      	4  /* Managed but not updated */
#define EMSCStateRejected			5  /* Rejected */
#define EMSCStateRemoved			6  /* Removed */
 
#; Group/Instance management states
#define EMSInstanceStateInitial         ""  /* State after initially created -- registering */
#define EMSInstanceStateBeingAssigned	1  /* BeingAssigned */
#define EMSInstanceStateManaged			2  /* Managed */
 
#; ServiceController edit state
#define EMSEditStateAvailable			"" /* The group is not being edited and is available to start new edit */
#define EMSEditStateEdit				1 /* Services in group are being edited */
#define EMSEditStateAwaitingApproval    2 /* Edit is complete and awaiting approval */
#define EMSEditStateApproved            3 /* Edit is approved */
#define EMSEditStatePrepareInProgress   4 /* Prep for activate is in progress */
#define EMSEditStatePrepared            5 /* Changes are prepared for activation (e.g. DataMoves done) */
 
#; ServiceController update state
#define EMSUpdateStateAvailable			"" /* The Service is not being updated and is available to start new update */
#define EMSUpdateStateUpdate			1 /* The instances are being updated after approval */
#define EMSUpdateStateAddInstance       2 /* An instance is being updated for assign */
#define EMSUpdateStateResumeInstance    3 /* An instance is being updated for resume */
#define EMSUpdateStateMoveInstance      4 /* An instance is being updated for move */
 
#; Instance running/down status
#define EMSInstanceStatusUnknown        ""
#define EMSInstanceStatusRunning        1
#define EMSInstanceStatusStopped        2
 
#; Flags in EMS response
#define EMSResponseRemoved              1

#; Logging
#; Levels:
#;   1 - critical error
#;   2 - error
#;   3 - warning
#;   4 - information
#;   9 - verbose
#define EMSCheckLogging(%level)     ($get(^ISC.EMS("Log"))>=%level)
#define EMSLogText(%level,%line)    If $$$EMSCheckLogging(%level) Do ##class(EMS.Utils).LogText(%level,%line)
#define EMSLogDataStream(%level,%stream)    If $$$EMSCheckLogging(%level) Do ##class(EMS.Utils).LogStream(%level,%stream)
#define EMSLogObject(%level,%object)    If $$$EMSCheckLogging(%level) Do ##class(EMS.Utils).LogObject(%level,%object)
#define EMSLogArray(%level,%text,%array)    If $$$EMSCheckLogging(%level) Do ##class(EMS.Utils).LogArray(%text,%array)
#define EMSLogDisplay(%level,%class)    If $$$EMSCheckLogging(%level) Do ##class(EMS.Utils).LogDisplay(%level,%class)
#define EMSStartLogging(%level,%file) Set ^ISC.EMS("Log")=%level,^ISC.EMS("LogFile")=%file
#define EMSStopLogging              Kill ^ISC.EMS("Log"),^ISC.EMS("LogFile"),^ISC.EMS("LogMarker"),^ISC.EMS("LogFileMaxSize"),^ISC.EMS("LogFileDaysToKeep")
#define EMSLogFileLockName ^%SYS("EMSLogFileLockName")
#define EMSLogFileMax ^ISC.EMS("LogFileMaxSize")
#define EMSLogFileDaysToKeep ^ISC.EMS("LogFileDaysToKeep")

#; EMS Database
#define EMSSubDirectory		        "ems"
#define	EMSdbName                   "CACHEEMS"
#define EMSDataSubDirectory		    "emsdata"
#define	EMSDatadbName               "EMSDATA"
#define EMSNamespace	            "EMS"

#; Resources and roles
#define EMSDBCACHEEMSResourceName	"%DB_CACHEEMS"
#define EMSAdminResourceName		"EMSAdmin"
#define EMSApplicationResourceName	"EMSApplication"

#; Default Account used by EMS manager to log into instance
#define EMSManagerProxyUsername		"EMSManagerProxy"
#; Role and resource given to user EMSManagerProxy
#define EMSManagerProxyApplication	"EMSManagerProxyApplication"
#; Default Account used by EMS instance to log into manager
#define EMSInstanceProxyUsername	"EMSInstanceProxy"
#; Role and resource given to user EMSInstanceProxy
#define EMSInstanceProxyApplication	"EMSInstanceProxyApplication"
#;Role and resource given to user EMSRegistrar
#define EMSRegistrarApplication     "EMSRegistrarApplication"
#;Role and resource required for user to use distributed EMS SQL security API
#define EMSDistributedSQLSecurityAPI "EMSDistributedSQLSecurityAPI"

#; Users
#define EMSManagerUsername 			"Manager"
#define EMSRegistrarUsername 		"EMSRegistrar"
#define EMSRegistrarPassword 		"SYS"

#; CSP applications
#define EMSApp						"/csp/ems"
#define EMSWSConnectionApp			"/csp/ems/connection"
#define EMSWSManagerApp				"/csp/ems/manager"
#define EMSWSManagerAPIApp			"/csp/ems/api"
#define EMSWSInstanceApp			"/csp/ems/instance"
 
#; User group privileges
#define EMSUserNone					0
#define EMSUserEdit					1
#define EMSUserApprove				4
#define EMSUserActivate				2
 
#; Notification target types -- See EMS.Notification class TargetType property for details
#define EMSNoteAll                  0
#define EMSNoteAdmin                1
#define EMSNoteGroupActivate        2
#define EMSNoteGroupEdit            3
#define EMSNoteInstanceActivate     4
#define EMSNoteInstanceEdit         5
#define EMSNoteInstance             6
#define EMSNoteUser                 7
#define EMSNoteGroupApprove         8
#define EMSNoteInstanceApprove      9

#; Timeout types
#; Timeout for initial contact with instance
#define EMSContactTimeout           -1
#define EMSContactTimeoutDefault     1
#; Timeout for control message such as Suspend
#define EMSControlTimeout           -2
#define EMSControlTimeoutDefault     3
#; Timeout for data message such as RequestServiceData or UpdateServiceData
#define EMSDataTimeout              -3
#define EMSDataTimeoutDefault       15
#; Timeout for GetPatch
#define EMSPatchTimeout             -4
#define EMSPatchTimeoutDefault      30

#; Reason code for SOAP fault which returns EMS.Error for API
#define EMSAPIError         "Enterprise Manager API Error"
#define EMSAPICallerError   "Enterprise Manager API Caller Error"
 
#; Activation Sync type
#define EMSActSerial		0 /* Activation done serially, Instance finishes during Web Service */
#define EMSActJob			1 /* Activation JOBed, Instance reports status but no sync with other Instances */
#define EMSActSync			2 /* Activation JOBed, Instances must stay in-sync with other Instances */

#; Strings used to indicate failure/success of synchronized Activation (and DataMove)
#define EMSSyncFail			"Fail"
#define EMSSyncSuccess		"Success"
#define EMSSyncCancel		"Cancel"
#; Specific status codes for DataMoves
#define EMSSyncReceived		"Received"
#define EMSSyncInProgress	"InProgress"
#define EMSSyncComplete		"Complete"
#define EMSSyncNotManaged	"NotManaged"
#define EMSSyncError		"Error"

#;System Sources for EMS audit events
#define SourceEMS          "%EMS"
 
#;System Types for EMS audit events
#; Use TypeEMS, TypeSystem (Config) and TypeSecurity (Security and Users) already defined in %syAudit.inc
 
#;System Names for EMS audit events
#; EMSNameInstance and EMSNameGroup are used with TypeEMS for EMS change in instance or group management.
#;   They are used with TypeEMS, etc. for changes in service data.  
#;   EMSNameInstance for data sent to instance for update of instance and 
#;   EMSNameEdit is used when edited data is saved before approval.
#define EMSNameInstance         "InstanceChange"
#define EMSNameGroup            "GroupChange"
#define EMSNameChange           "EMSChange"
#define EMSNameEdit             "Edit"
 
#; License check macros
#define EMSManagerLicenseCheckFailed		($SYSTEM.License.GetUserLimit()<5)
#define EMSInstanceLicenseCheckFailed		($SYSTEM.License.GetUserLimit()<2)
#; Check for UI wrapper methods and queries. Ensure that stray settings of 'Group' don't go to EMS
#define EMSGroupCheck(%group) (($g(%group)="") || '##class(%SYS.EMS).IsEMSManager())

#; The following Macros are used to serialize/deserialize EMS objects to a BinaryStream.
#; $$$EMSBinWrite and $$$EMSBinRead write/read records to the Stream, and the Record
#; Types below imply a structure and method for encoding/decoding.
#;
#; This primarily uses $List() structures similar to those used in globals for Persistent
#; objects. It depends on a level of Class abstraction that uses the short ClassName and
#; a list of Property names and an IdKey. The Service code on either side (Manager - Instance)
#; must be able to correlate the short ClassNames with actual Persistent Classes.
#; 
#; We first send a Class definition which has a $List of any simple datatype or embedded
#; Property names. Then the Object (class instance) records have a $List of values (or
#; embedded $Lists) which match the $List position of the names in the class definition.
#; This may be followed by a series of records for any array or Child values. A new Class
#; definition signals the beginning of a new series of Class/Object records. 
#;
#; Each record is: 1-byte [TYPE], 4-byte[LENGTH], [$List(NAME, VALUES)]
#; %s=Stream, %r=RecordType, %d=Data as $List(Name, $List(Values)), %sc=%Status
#define EMSBinWrite(%s,%r,%d,%sc) s %sc=%s.Write($c(%r)_$zlc($l(%d))_%d)
#define EMSBinRead(%s,%r,%d,%sc) s %r=%s.Read(5,.%sc) s:%sc=1 %d=%s.Read($zla($e(%r,2,5)),.%sc),%r=$a($e(%r))
#;
#; Record Types for records in BinaryStream, description shows [Name],[Values] for each.
#;
#; $$$EMSBinClass defines a class as [ClassName],[$List(PropertyNames)].
#; This marks the beginning of a series of records enumerating the Class Instances.
#; A PropertyName for non-DataTypes will have a ":" delimited suffix:
#; "list"=ListOfDataType, "idkey"=Persistent IdKey, "olist"=ListOfObjects (i.e. $List of IdKeys)
#; "serial"=Serial (embedded) Object, "array"=Array in Serial (embedded) Object.
#; The 3rd ":" piece may be the short ClassName which defines the data.
#; **TBD** - only "list" is used right now, the rest are not-yet-implemeneted
#define EMSBinClass		1
#;
#; If the Class contains "child" or embedded Properties, we send a $$$EMSBinChild record
#; to define the Child Class. Note these may occur anywhere in the Stream, as the sender
#; finds it has Child or embedded properties. The receiver needs to maintain a copy of
#; of any recieved definitions for use with later instances.
#; Definf Parent Class as [ClassName],[$List(PropertyNames)]
#define EMSBinChild		2
#;
#; The $$$EMSBinClass is followed by a series of Add/Delete/Modify Object records for the
#; Class. The $List(DataTypeValues) is in the same order as the $List(PropertyNames)
#; in EMSBinClass.
#; The $List of data for Serial (or serial array) classes will be a $List(ClassName (or Key),$List(Values)).
#;
#; Add a class instance [InstanceID],[$List(DataTypeValues)]
#define EMSBinObjAdd	3
#; Modify an existing class instance [InstanceID],[$List(DataTypeValues)]
#define EMSBinObjMod	4
#; Delete a class instance [InstanceID],[null]
#define EMSBinObjDel	5
#; Any "array" data for Add/Mod is represented as a series of $$$EMSBinPropArr
#; records. The PropertyName will have a ":" delimited suffix to identify the type
#; of array: "array", "child", "oarray".
#; The 3rd ":" piece may be the short ClassName which defines the data.
#; Add an array Property entry [PropertyName],[$List(Key, ArrayValue or $list(ChildValues))]
#define EMSBinPropArr	6
#;
#; Mark end of records for an Array Property.
#; This allows for nested Child Properties. Finding a EMSBinPropArr with a different
#; PropertyName before an EMSBinPropArrEnd would mean a nested Child. The receiver would
#; need to remember (i.e. "push") the Child you were working on and start inserting new
#; Child instances. Then an EMSBinPropArrayEnd would signal you have to "pop" back to the
#; previous Child instance.
#; End of Array/Child instance [PropertyName], [null] 
#define EMSBinArrayEnd 8
#;
#; Mark end of Object, allows for saving or post-processing of an Object
#; End of class instance [InstanceId], [null]
#define EMSBinObjEnd	7
#;
#; Mark the end of the Stream [null] , [null]
#define EMSBinDataEnd	0

#; Text equivalent of commands for debugging
#define EMSBinText "ClassDef,ChildDef,ObjectAdd,ObjectMod,ObjectDel,ArrayAdd,ObjectEnd,ArrayEnd"

#; Lists of Packages and Routines which need to mapped for the EMS Namespace.
#; This probably needs to happen for ^build in EMS and the installation of an EMS Manager.
#define EMSMapPackages "EMS,Config,Security"
#define EMSMapInclude "ISCFILEDIR_INC,DEVICE_INC,BITWISE_INC,FILEINC_INC,ISCChkDir_INC,SHDW_INC,SITE_INC,ST_INC,USTART_INC,ISCQUIEDEF_INC,SYSTEM_INC"

#; Macro to instantiate an EMS.Error object with a Formatted $Text message with 1 argument
#; and a %Status code in the .Detail property. The %text argument must be a literal text string
#; and may contain the %1 formatted text argument. Good for handling %Status from lower level calls.
#define SCERR(%text,%arg1,%sc) ##class(EMS.Error).NewError($$$FormatText($$$Text(%text),%arg1),$System.Status.GetErrorText(%sc))

#; Flag which allows EMS Manager Downloads to bypass class validations/protections.
#; Generally set to "UPDATE" by MessageToData() in the Service code.
#; May also be "FULL UPDATE" which allows us to delete/replace the full extent of the class.
#; (note that this is only used for testing a full overwrite of Service data right now)
#; Set to "INSTALL" in ^INSTALL to just bypass restrictions on the Managed Instance (but validations still applied).
#; So some places may check $d($$$EMSManagerDownload), others may specifically check $g($$$EMSManagerDownload)["UPDATE"
#define EMSManagerDownload ^||ISC.EMS.DOWNLOAD

#; Replace "|" character in Config Overrides IdKey (primarily for Devices Name)
#define EMSbar	$c(1)

#; Name of DataMove object used by EM
#define EMDataMove "%EnterpriseManager"

#; macro to get localized/external name of Service
#define EMServiceName(%name) $s(%name="":"",1:$ClassMethod("Manager.Service."_%name,"GetLocalizedName"))