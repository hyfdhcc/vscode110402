ROUTINE ISCQUIEDEF [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;SML739 07/17/06 Simon Li, Alert the system and Log the reasons when Quiesce failed.
HYY808   ; 09/22/03, Huayong Yang, add CHKCLUMASTER & CHKCLUSLAVES (chg HYY798)
HYY798   ; 08/29/03, Huayong Yang, add CLUSLAVEBIT
JAO930   ; 06/30/97, Jeffrey Orlin, added $$$NOCLUACT
LRS067   ; 05/26/95, Lee Smith: initial creation
#endif  /*=====================End Maintenance======================*/
  
#ifndef ISCQUIEDEFINC
#define ISCQUIEDEFINC
#include SYSTEM  ;JAO930
  
#if 0   /*======================Documentation=======================*/
         ; #defines for $ZU(51) system activity test calls
  
         ; ** PLEASE **  These same defines are found in edzu.c, so
         ; *** NOTE ***  modify both sets together.
  
         ; WDBUSYBIT     Write Daemon busy or work queued
         ; GCBUSYBIT     Garbage Collector busy or work queued
         ; DBEXPANDBIT   Database expansion
         ; GLBREFBIT     Global module reference of any kind
         ; GLBUPDBIT     Global update only (Set/Kill/ZSave/etc)
         ; NETBUSYBIT    Network activity pending
         ; CLUSTERBIT    Check state of other cluster members
#endif  /*====================End Documentation=====================*/
  
         ; Bit masks
  
#define  WDBUSYBIT       1
#define  GCBUSYBIT       2
#define  DBEXPANDBIT     4
#define  GLBREFBIT       8
#define  GLBUPDBIT       16
#define  NETBUSYBIT      32
#;SML739
#define  NETSRVBIT       64
#define  CLUSTERBIT      128
#if 0   ;HYY808+
#define  CLUSLAVEBIT     256
#else   ;HYY808=
#define  CHKCLUSLAVES     256
#define  CHKCLUMASTER     512
#endif  ;HYY808-
#;SML739
#define CLUSTERWIDEBITS ($$$CHKCLUSLAVES+$$$CHKCLUMASTER)
  
         ; Commonly used references
  
#define  DISKBITS        $$$WDBUSYBIT+$$$GCBUSYBIT
  
#define  WDIDLE          $ZU(51,$$$WDBUSYBIT)
#define  GCIDLE          $ZU(51,$$$GCBUSYBIT)
#define  DBXIDLE         $ZU(51,$$$DBEXPANDBIT)
#define  GUPDIDLE        $ZU(51,$$$GLBUPDBIT)
#define  GLOBIDLE        $ZU(51,$$$GLBREFBIT)
#define  NETIDLE         $ZU(51,$$$NETBUSYBIT)
#define  DISKIDLE        $ZU(51,$$$DISKBITS)
#define  NOUPDACT        $ZU(51,$$$DISKBITS+$$$DBEXPANDBIT+$$$GLBUPDBIT)
#define  NOSYSACT        $ZU(51,$$$DISKBITS+$$$DBEXPANDBIT+$$$GLBREFBIT)
#if $$$USECLUSTER ;JAO930+
#define  NOCLUACT        $ZU(51,$$$DISKBITS+$$$DBEXPANDBIT+$$$GLBREFBIT+$$$CLUSTERBIT)
#else
#define  NOCLUACT $$$NOSYSACT
#endif            ;JAO930-        
 
#endif  ;ifndef ISCUIETDEFINC
  