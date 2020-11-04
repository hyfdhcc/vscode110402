ROUTINE PQLDEF [Type=INC]
#if 0   /*=======================Maintenance========================*/
LRS435   ;06/21/00, Lee Smith: Cleaned, get defaults from VIEWing the system
         ;          instead of using hardcoded values
LRS419   ;06/06/00, Lee Smith, raise default PGFLQUOTA from 10240 to 100000
JAO749   ;12/19/94, Jeffrey Orlin. Updated & corrected bugs
DKA187   ;08/23/93, Keith Avery: Created based on <pqldef.h> on AlphaVMS
#endif  /*=====================End Maintenance======================*/
 
         ;  PROCESS QUOTA LIST CODES
         ; LIST END CODE (MUST BE FIRST)
#define PQLLISTEND 0
         ; AST LIMIT
#define PQLASTLM 1
         ; BUFFERED I/O LIMIT
#define PQLBIOLM 2
         ; BYTE LIMIT FOR BUFFERED I/O
#define PQLBYTLM 3
         ; CPU TIME LIMIT
#define PQLCPULM 4
         ; DIRECT I/O LIMIT
#define PQLDIOLM 5
         ; OPEN FILE LIMIT
#define PQLFILLM 6
         ; PAGING FILE QUOTA
#define PQLPGFLQUOTA 7
         ; SUB-PROCESS LIMIT
#define PQLPRCLM 8
         ; TIMER QUEUE ENTRY LIMIT
#define PQLTQELM 9
         ; WORKING SET QUOTA
#define PQLWSQUOTA 10
         ; WORKING SET DEFAULT
#define PQLWSDEFAULT 11
         ; ENQUEUE LIMIT
#define PQLENQLM 12
         ; WORKING SET EXTENT LIMIT
#define PQLWSEXTENT 13
         ; JOB-WIDE LOGICAL NAME TABLE CREATION QUOTA
#define PQLJTQUOTA 14
         ; NUMBER OF QUOTAS (MUST BE LAST)
#define PQLLENGTH 15
 
#define QNAMES    "LISTEND^ASTLM^BIOLM^BYTLM^CPULM^DIOLM^FILLM^PGFLQUOTA^PRCLM^TQELM^WSQUOTA^WSDEFAULT^ENQLM^WSEXTENT^JTQUOTA"
#define QVALUES   "0^1^2^3^4^5^6^7^8^9^10^11^12^13^14"
#if 0   ;LRS435+
#define QDEFAULTS "^40^30^32768^0^10^50^100000^8^40^1400^100^40^1400^?"
#endif  ;LRS435-