ROUTINE FILEINC [Type=INC]
 ;FILEINC.INC   -- some site-specific constants related to file/dir
#ifndef FILEINC
#define FILEINC
 /* Revision: $Id: //adhocs/2016.2.3.904.11/DHC_SOFTWARE_CO_001/databases/sys/inc/FILEINC.inc#1 $ ($Change: 4521965 $) */
#if 0    ;Maintenance History
#;SML2129  9/04/15 Simon Li, When rebuild mirror journal log file, make sure the current existed file stay in log.
#;HYY2013 5/18/15 Huayong Yang, fix a typo in JrnNamePrefix
#;HYY1999 4/05/15 Huayong Yang, eliminate daily limit of 999 journal files
#;JO2397  2/20/11 Jeffrey Orlin, USEDSONLY support
#;HYY831 11/18/03 Huayong Yang, add DELFILE macro
#;JLC253 08/09/00 Jose' Cordeiro, define $$$FILEEXISTS().
#;STC200 02/26/99 Steve Clay, Remove Site is macro, changed DIRLOOK* macros
#;HYY204 09/30/98 Huayong Yang, add a macro for use in STU*
#;JAO979 10/17/97 Jeffrey Orlin, fix JRNSHORTNAME for VMS to correctly
#;                trim the version info
#;JAO974 09/29/97 Jeffrey Orlin, add DIRLOOK<xxx>() functions to perform
#;                filename based searches. This may not work for Unix yet
#;                as I'm not sure that Unix supports $ZSE()
#;JAO970 08/26/97 Jeffrey Orlin. Change JRNSHORTNAME for VMS to use
#;                $P(x,"]",2) rather than assuming the filename is the last
#;                11 bytes. VMS journal file names often include a trailing
#;                semicolon...
#endif
  
#include SITE         
 ; directory delimiter. Alternatively one can use 
 ; the last char of $zu(12) as the delimiter.
#if 1   ;STC200+
#define DIRSLASH $s($$$ISUNIX:"/",$$$ISVMS:"]",$$$ISWINDOWS:"\",1:"")
#endif  ;STC200-
 
 #;HYY204+
 ; given a full path %p, return the file name (not including directory)
#define GETFILENAME(%p) $p(%p,$$$DIRSLASH,$l(%p,$$$DIRSLASH))
 #;HYY204-
          
 #;SML2129+
 ; given a full path %p, return the directory path including the trailing delimiter.
#define GETDIRPATH(%p) $p(%p,$$$DIRSLASH,1,$l(%p,$$$DIRSLASH)-1)_$$$DIRSLASH
 #;#;SML2129-
          
 ; root directory. For default purpose, one can use $zu(12) instead.
#if 1   ;STC200+ Remove ROOTDIR definition
 ;#define ROOTDIR ""
#endif  ;STC200-         
 ; 1024*1024
#define ONEMEGA 1048576
  
								#;HYY1999+
 ; short name of a journal file, in yyyymmdd.seq form (001 <= seq < 2**31)
#define JrnShortNamePat 8N1"."3.10N
#define JrnShortNamePatStr "8N1"".""3.10N"
 ; Suffix "J" was meant to avoid mixing numerics like 20150101.001 with
 ; strings like 20150101.100 in subscripts, but it is no longer necessary.
#define JrnShortNamePatJ 8N1"."3.10N1"J"
 ; Be sure to keep it in sync with the one in journal.h
#define JrnShortNameMaxLen 19
#define MaxNumJrnFilePerDay (2**31-1)
 ; Pad a journal short name YYYYMMDD.X (001 <= X < 2**31) to a fixed-length 
 ; string YYYYMMDD.%010d (%010d as in printf() format)
#define PadJrnShortName(%a) $s($l(%a)<$$$JrnShortNameMaxLen:$p(%a,".")_$e(10000000000+$p(%a,".",2),2,11),1:%a)
 ; the full name of a journal file has form: path + prefix + name
 ; [JAO970] On VMS systems the journal file name often ends in a
 ; semicolon so don't assume the filename is the last 11 bytes.
 ; [JO2397] for USEDSONLY, there is no shortname
#define JRNSHORTNAME(%a) $case($$$USEDSONLY,0:$case($f(%a,";"),0:$e(%a,*-8-$l($p(%a,".",$l(%a,"."))),*),:$e(%a,*-8-$l($p(%a,".",$l(%a,"."))),$f(%a,";")-2)),:%a)
 ; Given a name %a in the form of yyyymmdd.*, retrieve yyyymmdd
 ; #define JrnShortNameDate(%a) $e(%a,1,*-$l($p(%a,".",$l(%a,"."))))
#define JrnShortNameDate(%a) $p(%a,".")
 ; Given a journal file name %a (no path), retrieve its prefix if any,
 ; assuming format <prefix>YYYYMMDD.N*N and "." is not allowed in prefix
								#;HYY2013+
#define JrnNamePrefix(%a) $e(%a,1,$l($p(%a,"."))-8)
								#;HYY2013-
 ; Increment the sequence # of a journal file name by one and pad it up to 
 ; 3 digits with leading '0's if it is less than 100.
#define IncJrnNameSeq(%i) $s((%i)<99:$e((%i)+1001,2,4),1:(%i)+1)
 ; Decrement the sequence # of a journal file name by one and pad it up to 
 ; 3 digits with leading '0's if it is less than 100.
#define DecJrnNameSeq(%i) $s((%i)<101:$e((%i)-1+1000,2,4),1:(%i)-1)
 ; Test whether journal short name A is later/greater (] or >) than name B.
 ; Both names are in the form of 8N1"."3.10N.
#define JrnNameAgtB(%A,%B) (($p(%A,".")>$p(%B,"."))||(($p(%A,".")=$p(%B,"."))&&($p(%A,".",2)>$p(%B,".",2))))
								#;HYY1999-
#define CONSOLELOG(%a) $ZU(9,"",%a_$C(13)_$C(10),1)
  
  
 ; $$$DIRLOOKINIT(dir) and $$$DIRLOOKNEXT(dir) are used to preform wildcard
 ; directory lookups. The call to $$$DIRLOOKINIT() primes the search and
 ; then calls to $$$DIRLOOKNEXT() return subsequent results or "" if none
 ; can be found.
 
#if 1   ;STC200+ For VMS, This used to use $ZU(15). Now it uses $ZSE which is on all platforms
#define  DIRLOOKINIT(%path) $ZSE(%path)
#define  DIRLOOKNEXT(%path) $ZSE("")
#endif  ;STC200-
 
#if 1   ; JLC253+
        ; Checks whether a file exists (1/0)
#define FILEEXISTS(%file)    '$ZU(140,4,%file)
#endif  ; JLC253-
#;HYY831+
#define DELFILE(%file) $ZU(140,5,%file)
#;HYY831-
#endif FILEINC