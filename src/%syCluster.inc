ROUTINE %syCluster [Type=INC]
#ifndef %syCluster
#define %syCluster
 
#if 0   /*=======================Maintenance========================*/
#;JO2721   1/17/14 Jeffrey Orlin, ensure $$$IsCluSys resolves to a boolean value
#;HYY1265 09/19/06 Huayong Yang, macros for handling cluster node info
#;HYY798 08/29/03 Huayong Yang, cluster related macros
#;GK300  07/06/04 Garen Kotikian, Added cluster common DB
#endif  /*=====================End Maintenance======================*/
 
#; same as ISCLUSYS, defined in %syJrninc.inc
#; JO2721: Add '' to $ZU(59,0) to convert to a boolean value
#define IsCluSys $s($$$SYSUSECLUSTER:''$zu(59,0),1:0)
 
#; These macros are for $$$SYSUSECLUSTER platforms only.
#define EnqDmnInfo $zu(59,0)
#define EnqDmnPid (+$$$EnqDmnInfo)
#define EnqCSN $p($$$EnqDmnInfo,",",2)
#define EnqWDMaster $p($$$EnqDmnInfo,",",3)
#define EnqIsMaster ($$$EnqWDMaster=$zu(40,0,73))
#define EnqNotInClu ($$$EnqWDMaster=$zu(40,0,75))
#define EnqInRecovery $p($$$EnqDmnInfo,",",4)
#define EnqDLMpresent $p($$$EnqDmnInfo,",",5)
#define EnqMasterCSN $p($$$EnqDmnInfo,",",6)
#define EnqLckIdSz $p($$$EnqDmnInfo,",",7)
#define EnqCIN $p($$$EnqDmnInfo,",",8)
#define EnqNetType $p($$$EnqDmnInfo,",",9)
#define EnqNetIsECP ($$$EnqNetType=$zu(40,0,72))
#define EnqNetNode $p($$$EnqDmnInfo,",",10)
#define EnqMasterWDIP $p($$$EnqDmnInfo,",",11)
#define EnqMasterWDPort $p($$$EnqDmnInfo,",",12)
 
#; setting/clearing switches cluster wide
#define CluSwSet(%sw) $zu(95,%sw,1)
#define CluSwClr(%sw) $zu(95,%sw,0)
 
#; setting/clearing switches on slave members only
#define CluSwSetSlave(%sw) $zu(95,%sw,1,1)
#define CluSwClrSlave(%sw) $zu(95,%sw,0,1)
 
#; GK300+
#;    CluCommonDBStat: return cluster common DB path from cluster 
#;    stat/$zu(59)
#define CluCommonDBStat(%s) $p(%s,",",13)
#;    CluCommonDB : return cluster common DB path ;; $p($zu(59),",",13)
#define CluCommonDB $$$CluCommonDBStat($zu(59)) 
#; GK300-
								#;HYY1265+
#define CluNodesInfo	$zu(172,4)
	#;the delimiter separating a node info string from another
#define	CluNodesInfoD	$c(0)
	#;the delimiter separating fields inside a node info string
#define	CluNodeInfoD	$c(1)
	#;(backward compatibility)
	#;the comma delimiter separating fields inside a node info string
#define	CluNodeInfoDc	","
	#;this is just to illustrate the usage of the CluNodesInfoD delimiter
	#;NB: %i is the $P index and does NOT necessarily correspond to csn
#define	CluNodeInfo(%s,%i)	$p(%s,$$$CluNodesInfoD,%i)
	#;# of nodes that are live at the moment (maybe different from max csn)
#define	CluNodesNumber(%s)	$l(%s,$$$CluNodesInfoD)
	#;local node is always the first piece of CluNodesInfo, however 
#define	LocNodeInfo	$p($$$CluNodesInfo,$$$CluNodesInfoD,1)
	#;the only field that is meaningful on both cluster & noncluster systems
#define	DefaultPort	+$$$CluNodesInfo
	#;field #'s of a node info string: Port#, IP address, csn, host name
#define	CluNodePortfn	1
#define	CluNodeIPfn	2
#define	CluNodeCSNfn	3
#define	CluNodeHostfn	4
	#;convert a node info string from new delimiter to old delimiter
#define	CluNodeInfoDCvt(%s)	$tr(%s,$$$CluNodeInfoD,$$$CluNodeInfoDc)
								#;HYY1265-
#endif ;%syCluster