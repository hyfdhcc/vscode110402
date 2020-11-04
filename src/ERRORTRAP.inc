ROUTINE ERRORTRAP [Type=INC]
#;ERRORTRAP.inc  CDS1867 03/02/11
 
#ifndef ERRORTRAP
#define ERRORTRAP
 
 
#define LEVEL          $ZU(41)
#define LEVOFF         1
#define STACK(%l)      $ZU(41,%l)
#define FIRST(%l,%v)   $ZU(41,%l,%v)
 
#define QUERY(%l,%v)   $ZU(42,%l,%v)
#define GETIT(%l,%v)   $ZU(43,%l,%v)
#define DDATA(%l,%v)   $ZU(44,%l,%v)
 
#define QINTERRUPT     "<INTERRUPT>"
 
 
 
 ;-=-=-=-=-  Stack-display information format -=-=-=-=-
 
#define  STYP(%i) $P(%i,"^")
#define  STAG(%i) $P(%i,"^",2)
#define  SROU(%i) $P(%i,"^",3)
#define  SOFF(%i) $P(%i,"^",4)
 
#define  SOURCE(%l) $P($$$STACK(%l),"^",5,999)
 
#define  FTsign     "S"
#define  FTbreak    "B"
#define  FTerror    "E"
 
#define  FTparam    "P"
#define  FTnew      "N"
#define  FTnewall   "n"
#define  FTnewdol   "$"
#define  FTfor      "f"
#define  FTztrap    "Z"
 
#define  FTdo       "d"
#define  FTextrin   "e"
#define  FTxecute   "x"
#define  FTdebugx   "X"
#define  FTdirect   "D"
#define  FTcallin   "C"
#define  FTetrap    "T"
 
 
#endif ERRORTRAP