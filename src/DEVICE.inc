ROUTINE DEVICE [Type=INC]
;device class definitions for device alias utility
 
#if 0   /*=======================Maintenance========================*/
#endif  /*=====================End Maintenance======================*/
 
#if 0   /*======================Documentation=======================*/
         
  ^*("DEVMAP", device# , "N") = device name (/dev/ttyp1)
                         "C") = device class ( 0-9 )
                         "O") = relative order
                         "I") = class-related ID index (only in STU)
         
             , "C", dev-class, device#)   - class index
             , "N", dev-names, device#)   - name index
         
  '*' is SYS for the version being EDITED
  '*' is STU for the version loaded into memory using $ZU(99,)
 
#endif  /*====================End Documentation=====================*/
 
#ifndef DEVICE
#define DEVICE
 
         ; the zu function number to use
#define ZUDEVMAP        91
 
         ;empty slot in table
#define DevClasNone     0
#define DevNameNone     "None"
 
         ; principle device
#define DevClasPrin     1
#define DevNamePrin     "Principal"
 
         ; system console
#define DevClasCons     2
#define DevNameCons     "Console"
 
         ; spooler
#define DevClasSplr     3
#define DevNameSplr     "Spooler"
 
         ; view buffer
#define DevClasView     4
#define DevNameView     "View Buffer"
 
         ; interjob communication
#define DevClasIjob     5
#define DevNameIjob     "Interjob"
 
         ; pseudo-device
#define DevClasPseu     6
#define DevNamePseu     "Pseudo-dev"
 
         ; magnetic tape
#define DevClasMagt     7
#define DevNameMagt     "Magtape"
 
         ; null device
#define DevClasNull     8
#define DevNameNull     "Null"
 
         ; others (tty, seq, etc)
#define DevClasOthr     9
#define DevNameOthr     "Other"
 
#endif DEVICE