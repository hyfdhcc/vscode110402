ROUTINE RUTILITY [Type=INC]
 ;;RUTILITY.INC
  
 ;this file contains system-wide bits of information specific to
 ;the current operating system
  
#if 0   /*=======================Maintenance========================*/
SJ3033	 ;07/31/14 Scott Jones, replaced $ZU(99,0,time) with $ZDTH(time,-2)
STC200   ;02/26/99 Steve Clay: Removed Site is macros
LRS280   ;11/12/98 Lee Smith, removed include of VENDOR
LRS181   ;09/19/97 Lee Smith, Cache' nomenclature changes
HYY101   ;06/24/97 Huayong Yang, routine name change (2nd ver)
HYY097   ;06/12/97 Huayong Yang, routine name change
VVS000   ;06/13/96 Vlad Skaletsky, define OBJCODEGBL
EAV000   ;05/15/96 Edward Valenti, routine object code in globals
DXU001   ;08/16/95,David Xu: Changed M/SQL to OPENM 
VGG195   ;06/19/95 Vadim Goldin: cleaned up old features, provided namespace syntax 
SPJ927   ; 9/10/93 Scott Jones, changes for long names
DKA187   ;06/29/93, Keith Avery: Commonized for AlphaVMS
BB364    ;05/28/91 added including %system.inc to get new ZU55 definition
BB119    ;11/19/89 changed routine size macros for %RI fix
BB022    ;08/17/89  changed V* macros to always use byte order, and changed
         ;          various native mode views to use pure numbers.
#endif  /*=====================End Maintenance======================*/
  
 ;SITE.INC provides the Site macros for determining target site
#include SITE
#include VIEW
#include SYSTEM
  
  
 ;default maximum number of versions to keep for MAC/INC files
#define MAXVERDEF 4
  
 ;there seems to be a difference between COS-code size and COS-code
 ;image size
#define RBUFOFF   64
#define RDATE     $$$GETAWRD(40)
#define RTIME     (2*$$$GETAWRD(42))
#define ROUIMSIZE $$$GETADBL(56)
#define RSIZE     $$$GETADBL(60)
  
  #define OPEN(%DIR)     O 63:"^^"_%DIR
  #define CLOSE          C 63
  #define NUMMAPS        $$$GETAWRD(1026)
  #define MAPSIZE        $$$GETADBL(1060)
  
#ifndef ZU55
  
 #define ZU55        0
  
#endif ZU55 undef
  
  #define ROUOBJ(%a) ^$$$OBJNAMB(%a)
  #define OBJTIMESTAMP(%a) $ZDTH($ZLA($$$ROUOBJ(%a),5),-2)
  #define ROUOBJTIME(%a) $P($$$OBJTIMESTAMP(%a),",",2)
  #define ROUOBJDATE(%a) $P($$$OBJTIMESTAMP(%a),",")
  #define OBJCODEGBL $$$OBJNAME
 