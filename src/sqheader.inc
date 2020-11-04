ROUTINE sqheader [Type=INC]
 ;
 ; Header file for %ROMF,%RIMF,%GOF,%GIF
 ;
#if 0   /*=======================Maintenance========================*/
SJ2958	;4/02/14 Scott Jones, clean out obsolete code
SML1457 ;2/15/12 Simon Li, Fix COS codes to get global vector address.
LFT1320 ;10/28/04, Laura Tillem, %ST -> ST
LRS273  ;10/16/98, Lee Smith: rename "BIN" translation to "RAW"
LRS218  ;03/30/98, Lee Smith: change include %site to SITE
SJ1180  ;10/23/97, Scott Jones, cleaned up, added GETSYS
LFT444  ;03/17/97, Laura Tillem, fix $$$STPV
LRS086  ;08/22/95, Lee Smith. long routine name support in I/O file
VGG195  ;06/19/95, Vadim Goldin. Cleaned up old types
MJF013  ;11/05/93, Mike Franklin. More definitions for version 2
BEB464  ;09/24/92, Ben Bishop.  parameterize the block count for PDP11
#endif  /*=====================End Maintenance======================*/
  
  
#ifndef sqheader
  #define sqheader
  
  #include SYSTEM
  #include SITE
  #include RHEADER
  #include MAGTAPE
 ;
 ; Set defaults for all machines
 ;
  #define qVERSION  2
  #define ArgFor    1
  #define ArgDo     1
  #define MriStr    1
  #define NegView   0
  #define NegDView  0
  #define TAPE      1
  #define TAPEformW "AUF"
  #define TAPEformR "AUFR"
  #define TAPEopen(%IO)  O %IO
 ;CARTopen -> BB337 cartridge tape opening solution
  #define CARTopen(%IO)  O %IO
  #define TAPErec   256
  #define TAPEblk   2048
  #define TAPEDFW   "(""AUF"":256:2048)"
  #define TAPEDFR   "(""AUFR"":256:2048)"
  
  #define RMStype   "?"
  
    #define ArgFor    1
    #define ArgDo     1
    #define NegView   1
    #define NegDView  1
    #define RMS       "U"
    #define RMStype   "U"
    #define RMSDFW    "WNU"
    #define RMSDFR    "RU"
    #define TAPEopen(%IO)  O %IO:"R"
 ;CARTopen -> BB337 cartridge tape opening solution
    #define CARTopen(%IO)  O %IO:("RAUF":256:2048)
    #define ENDIAN    $ZU(40,0,0)
    #define GETSYS    S SYS=$S($$$ISVMS:"M/AV",$$$ISWINDOWS:"M/WNT",1:"M/UX")
  
  #if $$$ArgFor
    #define Ever
    #define Forever "F  "
  #else
    #define Ever    F=0:0
    #define Forever "F F=0:0 "
  #endif ArgFor
  
  #if $$$NegView
    #define VIEW(%loc,%len,%str)  V %loc:0:-%len:%str
  #else
    #define VIEW(%loc,%len,%str)  D VIEW(%loc,%len,%str)
  #endif NegView
  #if $$$NegDView
    #define View(%loc,%len)       $V(%loc,0,-%len)
  #else
    #define View(%loc,%len)       $$View(%loc,%len)
  #endif NegDView
  
  
  #define MAXCNT     256
  
#if 1    ; MJF013+
  
#ifndef FILETYPE
  #define FILETYPE "GOF"
#elseif $$$FILETYPE'="GOF"&($$$FILETYPE'="ROMF")
  #define FILETYPE "GOF"
#endif
  
#if $$$FILETYPE="GOF" 
  #define GOFmagic 0
  #define GOFfile 1
  #define GOFcomment 2
  #define GOFglonames 3
  #define GOFgloheader 4
  #define GOFblock 5
  #define GOFnode 6
  #define GOFvalue 7
  #define GOFcontinue 8
  #define GOFeof 9
#else
  #define ROMFmagic 0
  #define ROMFfile 1
  #define ROMFcomment 2
  #define ROMFrounames 3
  #define ROMFrouheader 4
  #define ROMFblock 5
  
  #define ROMFcontinue 8
  #define ROMFeof 9
  
  #if '$$$NOLONGNAMES ; LRS086+
    #define ROMFname    "%ROMF"
    #define MAXRTNNM    31
  #endif ; LRS086-
#endif
         
#define byte3(%x) %x#256,%x\256#256,%x\65536#256
#define byte2(%x) %x#256,%x\256
         
#;LRS273+
#;Set RAW translation mode for current device
#define SetXltRAW $ZU(96,18,2,"RAW")
#;LRS273-
         
#endif   ; MJF013
#if 0    ;=====================Documentation===========================/
         ;
         ; record types for new %GOF format
         ;
         ; Every record consists of:
         ;   2 byte length (little endian) [length]
         ;   1 byte type
         ;   1 byte counter
         ;
         ; Special header to distinguish this format from old format(s)
         ;
         ;   6 0 0 0 "~%GOF~"
         ;
         ; Real Header:
         ;   [len] 1 cnt <version byte> <volume> <endian byte> <LFCRLFCR>
         ;               <check byte> [date] [time] <system type>
         ;
         ; Comment Record:
         ;   [len] 2 cnt <comment>
         ;
         ; Record types:
         ;
         ;   Name header: list of all names (globals or routines)
         ;     [len] 3 cnt [namlen] <name> ...
         ;
         ;   Global header:
         ;     [len] 4 cnt [namlen] <name> [<collating sequence/encoding type>]
         ;
         ;   Block header:
         ;     [len] 5 cnt [data]
         ;
         ;   Node header:
         ;     [len] 6 cnt [node] (no null at end)
         ;
         ;   Value header:
         ;     [len] 7 cnt [up to 32K-1 of data]
         ;
         ;   Continuation marker:
         ;     0 0 8 cnt
         ;
         ;   End of file marker:
         ;     0 0 9 cnt
#endif   ;====================end documentation==========================
  
#endif sqheader