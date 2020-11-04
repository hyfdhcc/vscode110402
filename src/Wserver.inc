ROUTINE Wserver [Type=INC]
#if 0    ;Maintenance History
#;KMK484 08/01/06 Keith Knowles.  Raise MAXSTRLEN.
#;SML736 07/11/06 Change $e(x,n,999) to $e(x,n,*).
#;CFL421 12/27/00 Carlos Lopes, add GETGBDB0OFF and BUFFAVAILABLE
#;LRS482 11/08/00 Laura Tillem, support for dots in routine names
#;APJ919 05/02/00 Phil Johnson, Disable .COS extension from %R wildcarding
#;APJ889 01/11/00 Phil Johnson, Convert all utilities to use %R api
#endif
 
#;LRS482+
#include SYSTEM
#;LRS482-
#include SITE
#ifndef %guiserver
 #define %guiserver
 #define guiWIN  "WIN"
 #define guiVMS  "VMS"
 #define guiUNIX "UNIX"
 #define guiServer $s($$$ISWINDOWS:$$$guiWIN,$$$ISUNIX:$$$guiUNIX,$$$ISVMS:$$$guiVMS)
#endif %guiserver definition
 
#define del1 $c(22,35,1)
#define del2 $c(19,94,1)
 
#define goDTM    1
#define goVAXDSM 3
#define goDSM11  4
#define goISM    5
#define goMSM    6
#define goISMBLK 7
#define goISMGEN 99
 
#define vbYES     6
#define vbNO      7
#define vbCANCEL  2
#define guiYESALL -1
 
#if 1	;CFL1113+
#ifdef	USELOST						; KMK484+
#define MAXSTRLEN 3641144
#else							; KMK484=
#define	MAXSTRLEN 32767
#endif							; KMK484-
#endif	;CFL1113-
 
#ifndef %guidirdel
 #define %guidirdel
         #define guiDirDel       $s($$$ISWINDOWS:"\",$$$ISVMS:".",$$$ISUNIX:"/",1:".")
#endif %guidirdel definition
#ifndef %guicvtcase
 #define %guicvtcase
 #define UC(%str) $ZCVT(%str,"U")
 #define LC(%str) $ZCVT(%str,"L")
#endif %guicvtcase definition
 
#if 1   ;CFL421+
#define GETGBDB0OFF(%a)                 $v(%a*$$$STILEN+$$$STgbdb0off,-2,$$$STILEN)
#define BUFFAVAILABLE(%a)               $case($$$GETGBDB0OFF(%a),4294967295:0,:1)
#endif  ;CFL421-
 
#if 1   ;APJ889+
#; Include an item in a selection set based on a mask.  This tends to get
#; called in from a tight loop, so include this function where it is needed.
#; 
#; Inputs:
#;       mask = selection mask, format: a:c.mac;f*;'b*
#;       item = item to be tested
#;       ext  = type of routine
#; Return:
#;       0 = don't include
#;       1 = include
maskincl(mask,item,ext) New e,i,include,m,m1,m2
 Set include=0,ext=$$$UC($g(ext,""))
 #; Handle inclusions
 For i=1:1 Set m=$p(mask,";",i),e="" Quit:m=""  Do:m'["'"  Quit:include
#if 0   ;APJ919+
 . Set:m["." e=$$$UC($p(m,".",2)),m=$p(m,"."),e=$s(e="*":"",e="SRC":".INC.MAC.INT.BAS",e="COS":".MAC.INT",e="":"",1:"."_e)
#else   ;APJ919=
#if '$$$ALLOWDOTS ;LRS482+
 . Set:m["." e=$$$UC($p(m,".",2)),m=$p(m,"."),e=$s(e="*":"",e="SRC":".INC.MAC.INT.BAS",e="":"",1:"."_e)
#else   ;LRS482=
 . Set:m["." m=$$ParseRoutineName^%R(m,.e),e=$s(e="*":"",e="SRC":".INC.MAC.INT.BAS",e="":"",1:"."_e)
#endif  ;LRS482-
#endif  ;APJ919-
 . If m["*" Do  Quit
 . . Set m=$p(m,"*")
 . . If m=$e(item,1,$l(m)),(e=""!(e[ext)) Set include=1 Quit
 . If m[":" Do  Quit
 . . Set m1=$p(m,":"),m2=$p(m,":",2)
 . . If m1=$e(item,1,$l(m1))!(item]m1) Do
 . . . If m2=$e(item,1,$l(m2))!(m2]item) Do
 . . . . Set:e=""!(e[ext) include=1
 . If m=item,(e=""!(e[ext)) Set include=1 Quit
 #; Handle exclusions
 If include,mask["'" For i=1:1 Set m=$p(mask,";",i),e="" Quit:m=""  Do:m["'"  Quit:'include
 . Set m=$e(m,2,*)
#if 0   ;APJ919+
 . If m["." Set e=$$$UC($p(m,".",2)),m=$p(m,".") Set e=$s(e="*":"",e="SRC":".INC.MAC.INT",e="COS":".MAC.INT",e="":"",1:"."_e)
#else   ;APJ919=
#if '$$$ALLOWDOTS ;LRS482+
 . If m["." Set e=$$$UC($p(m,".",2)),m=$p(m,".") Set e=$s(e="*":"",e="SRC":".INC.MAC.INT",e="":"",1:"."_e)
#else   ;LRS482=
 . Set:m["." m=$$ParseRoutineName^%R(m,.e),e=$s(e="*":"",e="SRC":".INC.MAC.INT.BAS",e="":"",1:"."_e)
#endif  ;LRS482-
#endif  ;APJ919-
 . If m["*" Do  Quit
 . . Set m=$p(m,"*")
 . . If m=$e(item,1,$l(m)),e=""!(e[ext) Set include=0
 . If m[":" Do  Quit
 . . Set m1=$p(m,":"),m2=$p(m,":",2)
 . . If m1=$e(item,1,$l(m1))!(item]m1) Do
 . . . If m2=$e(item,1,$l(m2))!(m2]item) Do
 . . . . Set:e=""!(e[ext) include=0 ; SJ bug fix
 . If m=item,(e=""!(e[ext)) Set include=0 Quit
 Quit include
#endif  ;APJ889-
 