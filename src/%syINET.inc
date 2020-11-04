ROUTINE %syINET [Type=INC]
#ifndef syinetinc
#define syinetinc
#if 0   /*=======================Maintenance========================
SML1293 1/26/11 Fix <NULL VALUE> error on SuperServer master job.
SML944 5/17/08 IPV6 support.
 =====================End Maintenance======================*/
#endif
#define USEIPV6 $zbitget($zversion(0)_$c(0,0,0,0),42)
#define IPTextToBinary(%ip)      $s($$$USEIPV6:$SYSTEM.INetInfo.TextAddrToBinary(%ip),1:$ZU(54,1,%ip))
#define IPBinaryToText(%ip)      $s($$$USEIPV6:$SYSTEM.INetInfo.BinaryAddrToText(%ip),1:$ZU(54,2,%ip))
#define IPBinaryToHostName(%ip)  $s($$$USEIPV6:$SYSTEM.INetInfo.AddrToHostName(%ip),1:$p($ZU(54,14,%ip),",",2))
#define IPTextToHostName(%ip)    $$$IPBinaryToHostName($$$IPTextToBinary(%ip))
#define HostNameToIPText(%h,%f)  $s($$$USEIPV6:$SYSTEM.INetInfo.HostNameToAddr(%h,%f),1:$p($ZU(54,13,%h),",",1))
#define GetLocalIPText(%f)       $$$HostNameToIPText($zu(54,0),%f)
#define GetTCPLocalIP(%f)        $s($$$USEIPV6:$SYSTEM.TCPDevice.LocalAddr(%f),1:$zu(54,26))
#define GetTCPPeerIPBinary       $s($$$USEIPV6:$SYSTEM.TCPDevice.PeerAddr(1),1:$zu(111,0))
#define GetTCPPeerIPText         $s($$$USEIPV6:$SYSTEM.TCPDevice.PeerAddr(0),1:$zu(54,2,$zu(111,0)))
#define ISIPV4(%a) (%a?1.3N1"."1.3N1"."1.3N1"."1.3N)
#define ISIP(%a) $S($$$USEIPV6:$SYSTEM.INetInfo.TextAddrToBinary(%a)'="",1:$$$ISIPV4(%a))
#define HOST2IP(%h) $s($$$USEIPV6:$SYSTEM.INetInfo.HostNameToAddr(%h),1:$p($zu(54,13,%h),","))
#; HOST2IPV2() always return IPV4 address.
#define HOST2IPV4(%h) $s($$$USEIPV6:$SYSTEM.INetInfo.HostNameToAddr(%h,1),1:$p($zu(54,13,%h),","))
#define LOCALHOST $zu(54,0)
#; DEFUDPADDR always return IPV4 address for DCP.
#define DEFUDPADDR $$$HOST2IPV4($$$LOCALHOST)
#; DEFTCPADDR returns either IPV6 or IPV4 depends on $zu(68,71).
#define DEFTCPADDR $$$HOST2IP($$$LOCALHOST)
#define GETPEERINFO $s($$$USEIPV6:$lg($SYSTEM.TCPDevice.PeerAddrPort())_"|"_$lg($SYSTEM.TCPDevice.PeerAddrPort(),2),1:$A($ZU(111,0),1)_"."_$A($ZU(111,0),2)_"."_$A($ZU(111,0),3)_"."_$A($ZU(111,0),4)_":"_($A($ZU(111,0),5)*256+$A($ZU(111,0),6)))
#endif
