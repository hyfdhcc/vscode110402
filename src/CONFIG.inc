ROUTINE CONFIG [Type=INC]
#ifndef CONFIGINC
#define CONFIGINC
#if 0    ;Maintenance History
#;SML994  5/01/08 Simon Li, IPV6 support.
#;CFL769 07/30/02 Carlos Lopes, better message for unreachable servers.
#;LRS489 01/04/01 Lee Smith, remove config file version, now handled by cvtcfg
#;                which is called from startup scripts
#;CFL373 12/19/00 Carlos Lopes, change utility version for USEBIGDB
#;CFL358 10/13/00 Carlos Lopes, add line # to ERPARSEKEYW
#;APJ850 01/11/00 Phil Johnson, increase config version to 4.0
#;LRS379 10/18/99 Lee Smith, increase config version to 3.3
#;LRS365 08/26/99 Lee Smith, increase config version to 3.14
#;DAS285 07/07/99 Diane Steidler, change DEFETHDEV to return the first
#;                valid ethernet device
#;STC200 02/26/99 Steve Clay, Remove Site is macro
#;JO1116  2/17/99 Jeffrey Orlin, increase config version to 3.13
#;HYY222 11/13/98 Huayong Yang, make NWDS activation more solid against
#;        user error.
#;HYY208 10/20/98 Huayong Yang, more changes to new config format
#;HYY204 10/02/98 Huayong Yang, create this file
#endif
 
#include SYSTEM
#include SITE
#;SML994 Include INET header.
#include %syINET
 
#define TEMPGLO $name(^mtemp($$%msub()))
#define CONFGLO ^CONFIG
#define CONFGLONAM "^CONFIG"
 
#define MERGCONF(%s) q:'$d(^Config(%s))  i '$d(Config(%s)) n Config m Config(%s)=^ConfigGlo(%s)
#define GETNETCONF(%n) $zcvt($p($$$GETFILENAME(%n),"."),"U")
 
#if 0   ;HYY208+
#define DEFUDPADDR $p($zu(54,13,""),",")
#define DEFUDPPORT 42502
#else   ;HYY208= 
#; returns IP address no matter whether %h is a host name or an IP address
#; $$$DEFPORT is a variable set at the beginning of startup
#define ISCDEFPORT 1972
#define DEFPORT DefaultPort
#define DEFUDPPORT $$$DEFPORT
#endif  ;HYY208-
#define DEFETHADDR $zu(114,0)
#;STC200+
#if 0   ;DAS285+
#define DEFETHDEV $s($$$ISWINDOWS:"ie1",1:$p($zu(114,2),","))
#else   ;DAS285=
#define DEFETHDEV $s($$$ISWINDOWS:"ie1",1:$p($zu(114,1),$c(1)))
#endif  ;DAS285-
#;STC200-
 ; left and right (relative to "=") delimiters in a config entry
#define CONFLDELIM "_"
#define CONFRDELIM ","
 
#define MAXCHARALINE 32767
#if 0   ;LRS489+
#if '$$$USEBIGDB        ; CFL373+
#define CACHECFGVER 4.0
#else                           ; CFL373=
#define CACHECFGVER 4.1
#endif                          ; CFL373-
#define CVTCFGUPD(%f) "cvtcfg update "_filename 
#endif  ;LRS489-
#define ERPARSE(%f,%e) "Error parsing config file "_%f_": "_$e(%e,3,256) 
#define ERPARSEFILE "1,file not available"
#define ERPARSEOPEN "2,fatal error opening file"
#define ERPARSEZE(%z) "3,received "_$p(%z,">")_"> error"
#define ERPARSESECT(%l) "4,invalid section in """_%l_""""
#if 0   ; CFL358+
#define ERPARSEKEYW(%w) "5,invalid keyword "_%w
#else   ; CFL358=
#define ERPARSEKEYW(%w,%l) "5,invalid keyword """_%w_""" at line #"_%l
#endif  ; CFL358-
#define ERPARSECFGVER "6,incorrect file version"
 
#define ERCONFKEYW(%w) "unknown keyword: "_%w
#;CFL769+
#define ERCONFDSET(%d) "undefined or unreachable dataset: "_%d
#;CFL769-
#define ERCONFGSLM(%g) "non-SLM global: "_%g
 #;HYY222+
#define ERCONFADDR(%s) "unable to deduce remote address from "_%s
 #;HYY222-
 
#endif ;CONFIGINC
 