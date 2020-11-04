ROUTINE CPUS [Type=INC]
#show
 ;CPUS.INC RLL, JLC1756 02/26/14
#noshow
 
#if 0   /*======================Documentation=======================*/
         CPUS.INC - macros for Hardware Platforms
         Author:  Ray Lawrence  Date:  Dec. 22, 1992
 
         NOTE: 
 
         CPUS.INC     parallels the list in tdkey.c.
                      is currently #included only by MKEY.
         CMCPM.MAC    specifies which platforms allow and default
                      to multiple CPU's.  It does not #include CPUS
                      but is closely related and should be revised
                      at the same time.
#endif  /*====================End Documentation=====================*/
 
#if 0    ========================Maintenance===================================
JLC1756  ;02/26/14, Jose' Cordeiro, added Linux/PowerPC64 (62)
JLC1704  ;06/13/13, Jose' Cordeiro, added Linux/Debian/ARM (61)
RJW2015	 ;03/11/12, Ron Watt, Enterprise Management server will use special license
JLC1474  ;04/14/11, Jose' Cordeiro, increment maxplatform for androidarm
RJW1873  ;02/01/11, Ron Watt, Modify platform names in $system.License.KeyPlatform(number)
JLC1067  ;09/26/07, Jose' Cordeiro, rename AMD64 as x86-64.
JLC1035  ;07/06/07, Jose' Cordeiro, added Mac OS X/x86-64.
JLC796	 ;12/20/05, Jose' Cordeiro, added Solaris/AMD64.
JLC795	 ;12/07/05, Jose' Cordeiro, added Mac OS X/x86.
JLC719	 ;05/05/05, Jose' Cordeiro, added Win64/AMD64.
JLC616	 ;04/06/04, Jose' Cordeiro, added Mac OS X/32-bit.
JLC595	 ;04/06/04, Jose' Cordeiro, added VMS/Itanium.
JLC542	 ;09/19/03, Jose' Cordeiro, added Linux/AMD64.
JLC502	 ;05/02/03, Jose' Cordeiro, added Linux/Itanium.
JLC501	 ;05/02/03, Jose' Cordeiro, added Win64/Itanium.
RJW645	 ;08/30/02, Ron Watt, Change name of license pseudo platform 47.
JLC411   ;06/12/02, Jose' Cordeiro, change hp11 name to HP RISC/32-bit.
JLC402   ;05/15/02, Jose' Cordeiro, added HP-UX/Itanium platform.
JLC371   ;11/09/01, Jose' Cordeiro, added IBM PowerPC/64-bit platform.
RJW493   ;10/29/01, Ron Watt, Remove WebPerRequest from license for Cache 4.2.
JLC270   ;10/17/00, Jose' Cordeiro, added HP RISC/64-bit platform.
JLC134   ;08/17/99, Jose' Cordeiro, added Solaris/UltraSPARC platform.
RJW275   ;04/28/99, Ron Watt, Add Cache PC Demo License pseudoplatform.
JLC058   ;10/29/98, Jose' Cordeiro, added UnixWare platform.
RAM729   ;03/03/98, Rick Miller, added Solaris/Intel platform.
AHS181   ;10/11/95, Amir Shokrollahi, added DG/Intel platform
LRS094   ;10/11/95, Lee Smith, updated platform name table
LRS092   ;09/12/95, Lee Smith: added Intel/NT, Alpha/NT, MIPS/NT, PowerPC/NT
                    (SJ1003), Linux (SJ1015), and PowerPC/AIX (SJ1017)
AHS172   ;08/23/95, Amir Shokrollahi, added SGI Irix.
DXU001   ;08/15/95, David Xu: Changed MUMPS to M or Open M and M/SQL to Open M
AHS106   ;01/28/94, Amir Shokrollahi: Motorola M88K SVR4 port
RWF114   ;07/21/93, Robert Fogg: added Solaris platform
DPB148   ;07/19/93, Dan Smith: add new platforms; revised comments; added
         ;          visible comment line; replaced leading 9 spaces with
         ;          single spaces.
RLL      ;12/22/93, Ray Lawrence: initial creation.
#endif   ======================End Maintenance=================================
 
 try { f platname=0:1:62 s platname(platname)=$System.License.KeyPlatform(platname) } catch {}
 