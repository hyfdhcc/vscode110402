ROUTINE %syDataCheck [Type=INC]
#; %syDataCheck.INC
#;
#; Include file for the DataCheck class api
#;
#;/*=======================Maintenance========================*/
#;RJF197 09/30/15 Ray Fucillo, granular debug macros
#;RJF168 08/05/14 Ray Fucillo, macros for updated RangeList implementation
#;RJF128 09/19/09 Ray Fucillo, new rangelist storage
#;RJF126 09/09/09 Ray Fucillo, add state reason code
#;RJF120 07/04/09 Ray Fucillo, remove user-created queries
#;RJF119 07/01/09 Ray Fucillo, update for dynamic SQL changes
#;RJF111 03/11/09 Ray Fucillo, include and exclude selections
#;RJF102 01/07/09 Ray Fucillo, rename to %syDataCheck and cleanup
#;RJF101 10/25/08 Ray Fucillo, add access denied message
#;RJF100 10/20/08 Ray Fucillo, initial implementation
#;/*====================End Maintenance======================*/

#; Constants for SYS.DataCheck package
#; =========================================================================
#; The following constants define values for properties, method
#; arguments, and method returns for the SYS.DataCheck.* classes.
#; They are provided here for convenience in using the class api. 
#; The values of these constants should not be changed because
#; the literal value may be used in various locations.
#;
#; State* constants are the possible running states for the DataCheck system
#define StateStarting "Starting"
#define StateStopping "Stopping"
#define StateStopped "Stopped"
#define StateConnecting "Connecting"
#define StateRunning "Running"
#define StateWaiting "Waiting"
#;
#; StateReason* constants are the logic values for the StateReason datatype
#define StateReasonUnknown 0
#define StateReasonUserStop 1
#define StateReasonWorkflowStop 2
#define StateReasonError 3
#define StateReasonSourceError 4
#define StateReasonConnectionError 5
#define StateReasonNeverStarted 6
#define StateReasonShutdown 7
#define StateReasonDisconnect 8
#define StateReasonBecamePrimary 9
#define StateReasonSourcePrimary 10
#define StateReasonSourceNotPrimary 11
#define StateReasonBackupNotActive 12

#;
#; LogType* constants are the severity of log messages
#define LogTypeWarning "WARNING"
#define LogTypeFatal "FATAL"
#define LogTypeInfo "INFO"
#define LogTypeDetail "DETAIL"
#define LogTypeDebug "DEBUG"
#;
#; JobType* constants are the different types of jobs used by the datacheck system
#define JobTypeManager "Manager"
#define JobTypeWorker "Worker"
#define JobTypeReceiver "Receiver"
#define JobTypeSender "Sender"
#define JobTypeUser "User"
#define JobTypeUtility "Utility"
#;
#; RangeState* constants are the values of the State property in a RangeListEle object
#define RangeStateColDis -2
#define RangeStateUnmatched -1
#define RangeStateUnknown 0
#define RangeStateMatched 1
#define RangeStateExcluded 2
#define RangeStateIncluded 3
#;
#; The system only supports one query queue per system at present.
#define QueryQueueNormal 0
#;
#; Special constants for the ListSet property of RangeList objects
#define RangeListSetGlobalSelection "%GS"


#; The following macros are used internally throughout DataCheck package
#; NOT INTENDED FOR EXTERNAL USE
#; =====================================================================
#; $$$CollatesAfter evaluates true if %g1 collates after %g2 in collation %c
#; %g1 and %g2 must be normalized global references
#; 
#; IMPORTANT: do not use this macro if arguments are not already normalized
#define CollatesAfter(%g1,%g2,%c) ##class(GlobalReference).CollatesAfter(%g1,%g2,%c,1)

#; Macros to get mirror membership by name
#define IsFailoverMember(%mirname) ($system.Mirror.MirrorName()=%mirname)
#define IsAsyncMember(%mirname) (+$g(^SYS("MIRRORSET")) && $$$IsMember(%mirname))
#define IsMember(%mirname) (","_$p($g(^SYS("MIRRORSET")),"^",2)[(","_%mirname))
 
#; Multiplier for the number of nodes to query next after a query comes
#; back matched.  Fractional values are allowed and the results of the
#; calculation based on a fractional QueryGrowthFactor are rounded up.
#define QueryGrowthFactor 2

#; Divisor for the number of nodes to query next after a mismatched query.
#; This is essentially the number of "chunks" that a discrepant section
#; is recursively split into for the purposes of isolating the discrepancy.
#define QueryShrinkFactor 4

#; The maximum number of nodes that the system will query at a time
#define QueryMaxNodes 32768

#; ErrorRetries is the number of times the system will reconnect if it
#; fails due to an error.  If it fails due to an error that is different
#; than the previous failure, the count will get reset.
#define ErrorRetries 2

#; UserInterval is the number of seconds that a user must wait for 
#; new information about the state of the system to become visible
#; and for dynamic changes to be picked up by the system.
#define UserInterval 5

#; Buffer size used for TCP device
#define TCPBufferSize 16384

#; Queue name for the main event queue
#define MainQ 0

#; Queue name for the worker's event queue
#define WorkQ 1

#; QueryHashStrength is the number of bits of hash to use for hashing 
#; global key/value pairs.  A value of 32 implies $zcrc() hashing,
#; otherwise it uses $system.Encryption.SHAHash*() functions
#define QueryHashStrength 32

/// Throws an sqlcode/message pair as an exception
#define ThrowSQLCODE(%sqlcode,%message) $$$ThrowStatus($$$ERROR($$$SQLError,%sqlcode,%message))

/// Throws an exception if a result object (%SQL.StatementResult or result set) has an error code
#define THROWONRESULTERROR(%result) if (%result.%SQLCODE)<0 { $$$ThrowSQLCODE(%result.%SQLCODE,%result.%Message) }
#define QUITONRESULTERROR(%result) quit:(%result.%SQLCODE)<0 $$$ERROR($$$SQLError,%result.%SQLCODE,%result.%Message)

#define PhaseSuperClass "SYS.DataCheck.Phase"
#define PhaseIsBuiltIn(%classname) ($e(%classname,1,$l($$$PhaseSuperClass))=$$$PhaseSuperClass)
#define PhaseName(%classname) $s($$$PhaseIsBuiltIn(%classname):$e(%classname,$l($$$PhaseSuperClass)+1,*),1:%classname)
#define PhaseNameToClassName(%phasename) $s(%phasename[".":%phasename,1:$$$PhaseSuperClass_%phasename)

#if 1
#define DEBUGLOG(%t) i ..Debug { d ..Log($$$LogTypeDebug,%t) }
#define DEBUGLOGQUERIES(%t) i ..Debug && $zb(..Debug,2,1) { d ..Log($$$LogTypeDebug,%t) }
#define DEBUGLOGANSWERS(%t) i ..Debug && $zb(..Debug,4,1) { d ..Log($$$LogTypeDebug,%t) }
#else
#define DEBUGLOG(%t)
#define DEBUGLOGQUERIES(%t)
#define DEBUGLOGANSWERS(%t)
#endif

#;
#; Macros for internal implementation of RangeList class
#;
#; GetEle gets a list element by element number. 
#; It's critical that this looks for them in Modified array before the ..Cached array
#; and especially before the global. The data in the global may be out of date and 
#; modified elements to not have their data stored in the cached array. 
#define GetEle(%elenum) $s('%elenum:"",$d(..Modified(%elenum)):..Modified(%elenum),$d(..Cached(%elenum,"e")):..Cached(%elenum,"e"),1:^SYS.DataCheck.RangeListEleD(..%Id(),%elenum)_$lb(%elenum))
#; BuildEle constructs the data format for a new element
#define BuildEle(%gloref,%state,%next,%prev,%num) $lb("",%gloref,%state,%next,%prev,%num)
#; Ele* macros fetch element properties from the element data
#define EleGloref(%ele) $li(%ele,2)
#define EleState(%ele) $li(%ele,3)
#define EleNext(%ele) $li(%ele,4)
#define ElePrev(%ele) $li(%ele,5)
#define EleNum(%ele) $li(%ele,6)
#; Element properties with number higher than $$$LastStoredEleProperty are carried
#; around in memory only. Only list elements from #1 up to this value are SET in
#; the global.
#define LastStoredEleProperty 5
