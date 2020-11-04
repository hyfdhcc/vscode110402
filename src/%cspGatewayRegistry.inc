ROUTINE %cspGatewayRegistry [Type=INC]
#include %sySecurity

#;*********** Gateway registry defs ****************************

#define HasData(%item)		(($Data(%item)#2)=1)
#define VarHasChildren(%var)($Data(%var)>=10)
#define FormatWebDate(%dt) $zdate(%dt,12)_", "_$translate($zdate(%dt,2)," ","-")_" "_$ztime($piece(%dt,",",2),1)_" GMT"
#define FormatCSPLogDate(%dt) $zdate(%dt,11)_", "_$zdate(%dt,2)_" "_$ztime($piece(%dt,",",2),1)_" GMT"
#define CRLF $Char(13,10)

#define GatewayActiveConnections  		^CacheTemp.cspServer
#def1arg HistoricConnections(%key) ^|"^^"_$zu(12)|SYS("CSP","HistoricConnections",%key)
#define NextHistoric(%key) $o($$$HistoricConnections(%key))
#define NextRegistry(%key) $o($$$GatewayActiveConnections(%key))
			
#define GatewayItemNew(%server,%port,%ver,%state,%connectDate,%pid,%ipaddr,%app) $lb(%server,%port,%ver,%state,%connectDate,%pid,%ipaddr,%app)
 
#def1arg GatewayItem(%job)		$$$GatewayActiveConnections(%job)
#define gtServerG(%item) 		$ListGet(%item,1)
#define gtPortG(%item)		 	$ListGet(%item,2)
#define gtVersionG(%item)		$ListGet(%item,3)
#define gtStateG(%item)		 	$ListGet(%item,4)
#define gtConnectDateG(%item)	$ListGet(%item,5)
#define gtCachePidG(%item)		$ListGet(%item,6)
#define gtIPAddressG(%item) 	$ListGet(%item,7)
#define gtAppMatchG(%item)		$ListGet(%item,8)
#define gtServerS(%item)		$List(%item,1)
#define gtPortS(%item)			$List(%item,2)
#define gtVersionS(%item)		$List(%item,3)
#define gtStateS(%item)			$List(%item,4)
#define gtConnectDateS(%item)	$List(%item,5)
#define gtCachePidS(%item)		$List(%item,6)
#define gtIPAddressS(%item)		$List(%item,7)
#define gtAppMatchS(%item)		$List(%item,8)

#; gateways this build and above have sufficient functionality to be added to gateway registry
#Define GatewayBuildThreshold 1213
#; using the Gateway version info
#define gvBuildNumG(%version) ($piece(%version,".",3))
#define gvCacheVersionG(%version) ($piece(%version,".",2))


#; Gateway States
#define gsActive "a"
#define gsInactive "i"

#;  Pending Gateway Requests 

#define HttpHdrCspId	 		"CSPID"
#define CmdTerminator			":"
#define MagicStackCt 			$zutil(41)
#define MagicStackData(%iii)	$zutil(41,%iii)

#define ClearPageCacheRequest	  "sys_clear_page_cache"
#define CloseConnectionsRequest	  "sys_close_connections"
#define	GetConfigRequest		  "sys_get_config"
#define	GetAppConfigRequest		  "sys_get_config:application"
#define GetApplicationListRequest "sys_get_config:application_index"
#define GetCSPIniRequest 		  "sys_get_CSP_ini"
#define ActivateCSPIniRequest     "sys_activate_CSP_ini"
#define GetCSPLogRequest		  "sys_get_CSP_log"
#define ClearCSPLogRequest		  "sys_clear_CSP_log"
#define	GetDefaultConfigRequest	  "sys_get_config:default"
#define GetServerConfigRequest	  "sys_get_config:server"
#define GetServerListRequest	  "sys_get_config:server_index"
#define GetInfoRequest			  "sys_get_info"
#define GetSystemStatusRequest	  "sys_get_system_status"
#define MarkCachesAsStaleRequest  "sys_mark_cache_stale"
#define SetConfigRequest		  "sys_set_config"
#define SetAppConfigRequest		  "sys_set_config:application"
#define	SetDefaultConfigRequest	  "sys_set_config:default"
#define SetServerConfigRequest	  "sys_set_config:server"
#define SetServerStatus  		  "sys_set_server_status"
#define GetServerStatus  		  "sys_get_server_status"
#define GetSystemMetricsRequest   "sys_get_system_metrics"
#define GetThisServerNameRequest  "sys_get_this_server_name"


#define GatewayPingServerUrl $Select($ClassName()="%CSP.Mgr.GatewayMgrImpl":i%AppMatch,1:"/csp/bin")_"/RunTime/Module.cxw?CSPSYS=sys_ping:"_$Select($ClassName()="%CSP.Mgr.GatewayMgrImpl":i%AppMatch,1:"/csp/sys/")_"null.cls"

#define CSPGatewayRespStream		^CacheTempGatewayRespStream
#define CSPGatewayRespStreamName	$name($$$CSPGatewayRespStream)

#; in seconds
#define CSPResponseTimeout (120) 

#def1arg CSPGatewayPendingRequest(%cspid)		 ^|"^^"_$zu(12)|SYS("CSP","PendingRequest",%cspid)
#define CSPGatewayPending(%cspid) 				$$$CSPGatewayPendingRequest(%cspid)
#define CSPGatewayPendingResponseStatus(%cspid)	$$$CSPGatewayPendingRequest(%cspid,"response","status")
#define CSPGatewayPendingStreamOid(%cspid)		$$$CSPGatewayPendingRequest(%cspid,"response","oid")

#define GatewayEventEndMsg (-1)
#define GatewayEventReadingMsg 1

#; cspid is used as a resource name so must begin with an alphabetic
#define CspidPrefix  "k" 
#; cspid format:  <prefix> <request timeout time> <prefix> <8-digit random number>
#; CSP Daemon uses the request timeout to purge any request zombies
#define CSPPendingIdNew(%requestcmd)	($$$CspidPrefix_(($piece(($$$TIMESTAMP($zts)+$$$CSPRequestTimeout),".")))_$$$CspidPrefix_$system.Encryption.GenCryptToken())
#define CSPTimeoutCheck(%now)	($$$CspidPrefix_(($piece(($$$TIMESTAMP(%now)+$$$CSPRequestTimeout),".")))_$$$CspidPrefix)

#; types to get for GatewayRegistry.GetGatewayMangers()

#define grtActive "a"
#define grtInactive "i"
#define grtBoth  "b"

#; clean-up information
#define SecsInDay               86400
#define TIMESTAMP(%t)           (($P(%t,",")*$$$SecsInDay)+$P(%t,",",2))
#; the amount of time a CSP Gateway historic connection is kept in the Gateway Registry before it is destroyed by the CSP Daemon
#define HistoricConnectTimeout	(($$$SecsInDay)*31) 
#; the amount of time a CSP Gateway request/response can exist before it is destroyed by the CSP Daemon
#define CSPRequestTimeout		($$$SecsInDay) 
#; the amount of time the client will wait for a request to the Gateway to begin to be fulfilled
#define GatewayResponseBufferTimeout 10
#define toUTF8(%s) $zcvt(%s,"O","UTF8")
#define CleanFilename(%fn) $zconvert($tr(%fn,"\","/"),"O","URL")
#; all the names in the configuration files are ASCII and none is longer than MaxConfigNameLen
#define MaxConfigNameLen  251

#; return formats
#define gfmtArray  "array"
#define gfmtObject "object"
#define gfmtStream "stream"

