ROUTINE SPL [Type=INC]
;%SPL.INC  -- include file for SPOOL file utilities
 
#ifndef %SPOOL
#define %SPOOL
 
;        magic spool end number
#define SpoolEnd        2147483647
 
;        document name
#define SpoolDoc(%a)    $P(%a,"{")
 
;        date,time file created
#define SpoolMade(%a)   $P(%a,"{",2)
 
;        Principle device
#define SpoolDev(%a)    $P(%a,"{",3)
 
;        program to use for formatting
#define SpoolForm(%a)   $P(%a,"{",4)
 
;        date,time printed
#define SpoolPrint(%a)  $P(%a,"{",5)
 
;        date,time completed printing
#define SpoolDone(%a)   $P(%a,"{",6)
 
;        first^last page range printed
#define SpoolPage(%a)   $P(%a,"{",7)
;        first page #
#define SpoolPagef(%a)  $P($$$SpoolPage(%a),"^")
;        last page #
#define SpoolPagel(%a)  $P($$$SpoolPage(%a),"^",2)
 
;        spool file description
#define SpoolDesc(%a)   $P(%a,"{",8,$L(%a))
 
#endif %SPOOL