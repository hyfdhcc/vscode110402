ROUTINE %syMirror [Type=INC]
 ;%syMirror.INC    Mirroring definitions file
 
 ;Macro definitions shared by various mirroring routines
 
#ifndef %syMirror
#define %syMirror
 /* Revision: $Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/inc/_syMirror.inc#1 $ ($Change: 4521965 $) */
 
#;		/*=======================Maintenance========================*/
#;SML2048  4/20/15 Simon Li, Support compression for mirror journal file transfer.
#;RFD1344  3/27/15 Rob Davis, enforce MirrorSubscribedToEMS
#;JO2739   3/28/14 Jeffrey Orlin, Remove unused MIRSYNCRULE values
#;JO2673   5/29/13 Jeffrey Orlin, arbiter support
#;SML1673  3/21/13 Simon Li, Support ignoring VIP for promoted DR member.
#;MXT1521  2/04/13 Remove check for EMS management of mirroring
#;JO2549  11/09/12 Jeffrye Orlin, add $$$Initializing as a value for the current Role
#;SML1593 10/24/12 Simon Li, Make promotion/demotion in ^MIRROR to be featured codes and disable it in 2012.2.
#;SML1586 10/10/12 Simon Li, Check only one mirror set is allowed for DR async member.
#;JO2562   7/30/12 Jeffrey Orlin, add MemberInfo() macro for calling MIRRORCTL routines
#;SML1501  5/14/12 Simon Li, Support mirror primary asking mirror members to retrieve mirror config when it was changed.
#;JO2531   3/26/12 Jeffrey Orlin add DefActivePrefetchStrategy and DefCatchupPrefetchStrategy
#;HYY1712  3/26/12 Jeffrey Orlin, add MaxPrefetch
#;SML1403 10/28/11 Simon Li, Support relay and async members to use Config.MapMirrors to configure mirroring.
#;JO2452   7/26/11 Jeffrey Orlin, [Mirrors]/[MapMirrors.*] support
#;JO2429   4/01/11 Jeffrey Orlin, relay mirror member support
#;SML1289  1/07/11 Simon Li, Support time latency for mirror.
#;YSD2380 06/28/10 Yan Drabek, added SSLDefined
#;YSD2386 06/25/10 Yan Drabek, added IsISCAgentEnabled
#;YSD2380 06/08/10 Yan Drabek, added items for UI
#;JO2141  10/07/09 Jeffrey Orlin, created this file
#;		/*=====================End Maintenance======================*/

		#; The public entry points which don't start off by invoking
		#; a $ZU() function or a $SYSTEM method that checks privs use
		#; $$$RequiredPrivs to make sure it is ok to let the user continue.
#define	RequiredPrivs $SYSTEM.Security.Check($$$AdminManageResourceName,$$$PermUseName)

#; Use $$$Primary/$$$Backup to avoid typos. These are for the
#; state stored in ^MIRROR("Role"). 
#; Primary, Reporting, Relay and Backup also match $SYSTEM.Mirror.GetInfo(). 
#; At startup ^MIRROR("Role") is reset to null.
#define Primary "PRIMARY"
#define Backup "BACKUP"
#define Reporting "SHADOW"
#;JO2429+
#define Async "ASYNC"
#define Relay "RELAY"
#;JO2429-
#;JO2594+
        /* Initializing is the state a member has at startup until it
           gets to wait^MIRRORMGR for the 1st time. At that point it has 
           either become the backup or primary or we set the role to null
           to indicate that it is up and running as opposed to still getting
           started */
#define Initializing "INITIALIZING"
#;JO2594-
#define Recovered "Recovered"

#define LOGMSG(%msg) do $ZU(9,"","Mirror: "_%msg)

#; The bit values for these debugging states are defined in mirror.h
#define DebugStartupMessages ($zb(+$SYSTEM.Mirror.DebugFlags(),2,1))
#;
#define DebugInfo(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),1,1) do $zu(9,"",%msg)
#define DebugStartup(%msg) if $$$DebugStartupMessages do $zu(9,"",%msg)
#define DebugConnect(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),4,1) do $zu(9,"",%msg)
#define DebugComm(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),8,1) do $zu(9,"",%msg)
#define DebugCatchup(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),+$ZH("40"),1) do $zu(9,"",%msg)
#define DebugDejrnInfo(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),+$ZH("80"),1) do $zu(9,"",%msg)
#define DebugJrnRecovery(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),+$ZH("400"),1) do $zu(9,"",%msg)
#define DebugArbiterMode(%msg) if $zb(+$SYSTEM.Mirror.DebugFlags(),+$ZH("800000"),1) do $zu(9,"",%msg)
#; The following are for the dejournaling routines to determine
#; whether they should log messages related to mirror journal recovery
#define MirrorDebugJrnRecovery $zb(+$SYSTEM.Mirror.DebugFlags(),+$ZH("400"),1)

#; Current mirror control version.
#; Version 2 exchanges the list of mirrored db's during startup
#; Version 3 exchange time(0) value.  SML1289
#; Version 4 Primary notifies all members to sync mirror configuration.  SML1501
#; Version 5 Check DR encryption key.  SML1586
#define	CurrentMirrorControlVersion	5

#; JO2739+
#; The only supported syncrule is Ack as of 2014.2. For
#; compatability with older versions we need to be able to
#; advertise that the syncrule is Ack so this definition
#; remains (for use with 
#; backup systems which are different levels of performance v. 
#; reliability tradeoffs based on what event, if any, the primary
#; waits for on the Backup after sending data. 
#; These are interpreted by $SYSTEM.Mirror.Config method and need to
#; match the corresponding MIRSYNCRULE_<xxx> values in mirror.h
#define MIRSYNCRULEAck 2
#;JO2739-

#; NumPrefetch is the # of journal prefetch jobs we start for 
#; mirror dejournaling. We may want different #'s for the active
#; backup jobs and catching up databases		
#define NumPrefetch $System.Util.NumberOfCPUs() 

    								#;HYY1712+
#; MaxPrefetch is the maximum # of journal prefetch jobs we
#; want to start regardless of the # of cpu's present 
#define MaxPrefetch 16 
    								#;HYY1712-

    								#;JO2531+
#; These are used in $ZU(78,90) calls to set the prefetch strategy
#; for mirror restores. "DefActive" is used for when we're an active
#; backup, DefCatchup is used in all other cases (eg. one is dejournaling
#; the current journal stream and the other is dejournaling a bounded file).
#define DefActivePrefetchStrategy -100
#define DefCatchupPrefetchStrategy -10000
    								#;JO2531-

#; These option bit values are used in the SendVerifyId message
#; when a client connects to a server to indicate what options
#; (if any) the client supports/wants to use. These should match
#; the definitions in mirror.h.
#;SML2048+ ; Change MIRRORUSEZIP from 1 to 4 so the old backup/async
#; won't receive compressed journal block.
#define MIRRORUSEZIP 4
#;SML2048-

#; This is the maximum length of the mirror system name field.
#; This is stored in various mirror config classes and loaded into
#; memory with .ServerAdd(). The MAXLEN of Config.MirrorMember.SystemName
#; should be kept in sync with this.
#; Will be $ZU(40,0,87)
#define MaxMirrorSYSNameLen 32

#; This is the max length of the mirror name
#; Will be $ZU(40,0,88)
#define MaxMirrorNameLen 15

#; The following entries are used by Mirror GUI
#define GetDefaultSystemName ##class(SYS.MirrorConfiguration).DefaultSystemName()
#define GetDefaultAgentAddress ##class(SYS.MirrorConfiguration).GetAgentAddress()
#define GetDefaultAgentPort ##class(SYS.MirrorConfiguration).GetAgentPort()
#define IsISCAgentEnabled ##class(SYS.Agent).VerifyConnection()
#define SSLDefined ##class(SYS.MirrorConfiguration).DoSSLConfigurationsExist()

#; The following are the values for the MemberType field in 
#; Config.MapMirrors which is also stored in the ^SYS("MIRRORSET")
#; mirror member list and loaded into memory with $SYSTEM.Mirror.ServerAdd(). 
#; These need to match the mirror types in mstruct.h.
#define FailoverMemberType 0
#define RelayMemberType 1
#define	AsyncMemberType	2

#;SML1403+,SML1501+
#; These manage the ^SYS("MIRRORSET",mirname,"Member",idx) node to indicate whether
#; the incoming mirror member is connected to the local system or not.
#define IsMemberConnected(%x)  (+$LG(%x,10))
#define SetMemberConnected(%x)    Set $list(%x,10)=1
#define SetMemberDisconnected(%x) Set $list(%x,10)=0
#;SML1403-,SML1501-
#; Check to see if the instance is subscribed to EMS to control Mirror configuration.
#; Mirroring not yet supported by EMS
#define MirrorSubscribedToEMS ##class(EMS.Instance).IsManaged("Config.Mirrors")

#;JO2562+
#; We changed the calling sequence for the entry points in MIRRROCTL which talk
#; with the remote agent from (mirname,agentip,basedir) to (mirname,index) where 
#; index is the member id # in ^SYS("MIRRORSET",mirname,"Member",<%index>) so that 
#; the entry points in MIRRORCTL can decide which address(es) to use to try to
#; contact the agent (eg. try all configured addresses if the agent address fails).
#; This is in a macro to preserve compatability with earlier versions which use:
#;      #define MemberInfo(%index,%info) $LG(%info,5),$LG(%info,6)
#; Where %info is ^SYS("MIRRORSET",mirname,"Member",<%index>)
#define MemberInfo(%index,%info) %index
#;JO2562-
#;SML1593 ; Define MIRPROMOTION would let ^MIRROR to display the promotion/demotion option.
#define	MIRPROMOTION
#;SML1673 ;
#define NoMatchedSubnet	"NoMatchedSubnet"

#;JO2673+
#; The following are arbiter message codes as defined by TRW1133
#define ArbiterConnectMsg 			0
#define ArbiterConfigureMsg			1
#define ArbiterKeepAliveMsg			2
#define ArbiterDisconnectMsg 		3
#define ArbiterSignalMsg		 	4
#define ArbiterStillAliveMsg	 	5
#define ArbiterPeerPresentMsg	 	6
#define ArbiterPeerConnectedMsg	 	7
#define ArbiterPeerSignalMsg 		8
#define ArbiterPeerDisconnectedMsg	9
#define ArbiterPeerLostMsg			10

#; The following are values for $SYSTEM.Mirror.FailoverRule
				    /* Arbiter failover rules are in effect */
#define	ArbiterControlledMirrorFailover	1
				    /* Agent contact is required */
#define AgentControlledMirrorFailover	2
					/* IsOtherNodeDown^ZMIRROR */
#define	UserControlledMirrorFailover	3   

#;bit values for $SYSTEM.Mirror.ArbiterState
				/* The client supports the arbiter */
#define	ArbiterSupported      1
			 	/* This system is connected to the arbiter */
#define ArbiterConnected      2
		  		/* The other failover member is connected to the arbiter */
#define ArbiterPeerConnected  4
		  		/* Either the QOSTimeout changed or the arbiter address changed.
		  		   we should look up the current values and use them */
#define ArbiterReloadParams   8
				/* Arbiter job shoud close the connection and exit. The
				   retry routine can restart the arbiter if conditions
				   warrent. Generally used with clearing ArbiterSupported
				   when the backup is removed or demoted. Cleared when
				   the arbiter exits (eg. its a one time flag). */
#define ArbiterExitRequested  16
#;JO2673-
#;SML2048+
#; The followings are compress mode, see mstruct.h.
#define MIRCMPSystemSelect    0
#define MIRCMPUncompressed    1
#define MIRCMPCompressed      2
#;SML2048-
#endif %syMirror
