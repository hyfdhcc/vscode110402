ROUTINE %syDataCheckMsg [Type=INC]
#; %syDataCheckMsg.INC
#;
#; Include file for messaging in DataCheck.System and subclasses
#; For internal use only

#;/*=======================Maintenance========================*/
#;RJF196 09/23/15 Ray Fucillo, report metrics from worker jobs
#;RJF141 03/08/11 Ray Fucillo, message additions for mirroring
#;RJF135 07/23/10 Ray Fucillo, correct $$$MsgGlobalQueryMask
#;RJF116 06/07/09 Ray Fucillo, add system info to the version message
#;RJF111 03/14/09 Ray Fucillo, add mask for global query
#;RJF106 02/10/09 Ray Fucillo, improve handshaking
#;RJF102 01/07/09 Ray Fucillo, split from %syDataCheck.inc
#;/*====================End Maintenance======================*/

#; Jobs in the datacheck system pass messages to each other via TCP (for jobs
#; communicating between different systems) and via Event queues (for jobs
#; running on the same system).  Each type of message is defined by one of
#; the MsgType* constants here.
#;
#; Acknowledgement
#define MsgTypeAck 0
#; Query
#define MsgTypeQuery 1
#; Query Answer
#define MsgTypeAns 2
#; Stop the system
#define MsgTypeStop 3
#; Dynamic runtime parameter change
#define MsgTypeRunParams 4
#; Database dst/src mappings
#define MsgTypeDBIdx 5
#; Global List Query
#define MsgTypeGlobalQuery 6
#; Peer disconnect notification
#define MsgTypeDisconnect 7
#; Peer error notification
#define MsgTypeError 8
#; Peer version 
#define MsgTypeVersion 9
#; Access denied
#define MsgTypeAccessDenied 10
#; Answer to a global list query
#define MsgTypeGlobal 11
#; Initiate a new connection
#define MsgTypeConnect 12
#; Static parameters
#define MsgTypeStaticParams 13
#; Ask for database list
#define MsgTypeDatabaseQuery 14
#; Answer to a database list query
#define MsgTypeDatabase 15
#; Exchange info about mirroring
#define MsgTypeMirrorInfo 16
#; Exchange worker metrics
#define MsgTypeWorkerMetrics 17
#;
#; The $$$MsgType() macro retrieves the type from a message
#define MsgType(%mess) $li(%mess,1)
#;
#; Some message types carry no payload and are just constants
#define MsgStop $lb($$$MsgTypeStop)
#define MsgAck $lb($$$MsgTypeAck)
#define MsgDisconnect $lb($$$MsgTypeDisconnect)
#define MsgDatabaseQuery $lb($$$MsgTypeDatabaseQuery)
#;
#; The other message types have a *Create() macro which builds the message
#; to carry the payload and retrieval macros to get the payload
#;
#; MsgTypeQuery
#define MsgQueryCreate(%id,%db,%key,%n) $lb($$$MsgTypeQuery,%db,%key,%n,%id)
#define MsgQueryID(%msg) $li(%msg,5)
#define MsgQueryNum(%msg) $li(%msg,4)
#define MsgQueryKey(%msg) $li(%msg,3)
#define MsgQueryDB(%msg) $li(%msg,2)
#; MsgTypeAns
#define MsgAnsCreate(%queryid,%remote,%ans) $lb($$$MsgTypeAns,%queryid,%remote,%ans)
#define MsgAnsAns(%msg) $li(%msg,4)
#define MsgAnsRemote(%msg) $li(%msg,3)
#define MsgAnsQueryID(%msg) $li(%msg,2)
#; MsgTypeRunParams
#define MsgRunParamsCreate(%n,%b) $lb($$$MsgTypeRunParams,%n,%b)
#define MsgRunParamsNumWorkers(%msg) $li(%msg,2)
#define MsgRunParamsBatch(%msg) $li(%msg,3)
#; MsgTypeDBIdx
#define MsgDBIdxCreate(%idx,%db) $lb($$$MsgTypeDBIdx,%idx,%db)
#define MsgDBIdxDB(%msg) $li(%msg,3)
#define MsgDBIdxIdx(%msg) $li(%msg,2)
#; MsgTypeError
#define MsgErrorCreate(%error) $lb($$$MsgTypeError,%error)
#define MsgErrorError(%msg) $li(%msg,2)
#; MsgTypeGlobalQuery
#define MsgGlobalQueryCreate(%db,%mask) $lb($$$MsgTypeGlobalQuery,%db,%mask)
#define MsgGlobalQueryDB(%msg) $li(%msg,2)
#define MsgGlobalQueryMask(%msg) $li(%msg,3)
#; MsgTypeGlobal is an answer to MsgTypeGlobalQuery
#define MsgGlobalCreate(%glo) $lb($$$MsgTypeGlobal,%glo)
#define MsgGlobalName(%msg) $li(%msg,2)
#; MsgTypeAccessDenied
#define MsgAccessDeniedCreate(%msg) $lb($$$MsgTypeAccessDenied,%msg)
#define MsgAccessDeniedMsg(%msg) $li(%msg,2)
#; MsgTypeVersion 
#define MsgVersionCreate(%version) $lb($$$MsgTypeVersion,%version,$system.Util.NumberOfCPUs())
#define MsgVersionVersion(%msg) $li(%msg,2)
#define MsgVersionCPUs(%msg) $li(%msg,3)
#; MsgTypeConnect
#define MsgConnectCreate(%jobtype,%guid,%version,%name,%type) $lb($$$MsgTypeConnect,%jobtype,%guid,%version,%name,%type)
#define MsgConnectJobType(%msg) $li(%msg,2)
#define MsgConnectGuid(%msg) $li(%msg,3)
#define MsgConnectVersion(%msg) $li(%msg,4)
#define MsgConnectName(%msg) $li(%msg,5)
#define MsgConnectType(%msg) $lg(%msg,6)
#; MsgTypeStaticParams
#define MsgStaticParamsCreate(%debug) $lb($$$MsgTypeStaticParams,%debug)
#define MsgStaticParamsDebug(%msg) $li(%msg,2)
#; MsgTypeGlobal is an answer to MsgTypeGlobalQuery
#define MsgDatabaseCreate(%dir) $lb($$$MsgTypeDatabase,%dir)
#define MsgDatabaseDirectory(%msg) $li(%msg,2)
#; MsgTypeMirrorInfo exchanges mirror information
#define MsgMirrorInfoCreate(%isfailovermember,%isasyncmember,%info) $lb($$$MsgTypeMirrorInfo,%isfailovermember,%isasyncmember,%info)
#define MsgMirrorInfoIsFailoverMember(%msg) $li(%msg,2)
#define MsgMirrorInfoIsAsyncMember(%msg) $li(%msg,3)
#define MsgMirrorInfoInfo(%msg) $li(%msg,4)
#; MsgTypeWorkerMetrics
#define MsgWorkerMetricsCreate(%metrics) $lb($$$MsgTypeWorkerMetrics,%metrics)
#define MsgWorkerMetricsMetrics(%msg) $li(%msg,2)
