ROUTINE ISCGetDev [Type=INC]
;;ISCGetDev.INC  function to prompt for and get a device name
 
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
SAP023  ;5/23/02, Steve Pettibone, if input error from file, exit
LFT435  ;2/19/97, Laura Tillem, fix typo: i $zm'["A" should have been i $zm'["R"
LFT375  ;6/25/96, Laura Tillem, work around $zb bug in read line recall
JFP059  ;6/20/95, John Paladino, Removed Unnecessary Lock
#endif
 
#ifndef ISCGetDev
#define ISCGetDev
 
GetDev(p,d) ;ask for a device, allow defaults
 S $ZT="GetFail"
 I '$D(devlist) N devlist DO  ;define device list default pointer
 . S devlist="^mtemp1(""dev"")" ;as good a place as any...
 . I $G(@devlist)<$H K @devlist S @devlist=$H_","_$J_","_$I
 ; JFP059=
 N Z DO  Q Z
 ; JFP059-
 . N N,R,OLD,MAX,TWO S (N,MAX)=$G(@devlist@(0))+1,TWO=0
GetDv . S OLD=$G(@devlist@(N)),$ZT="GetErr" I OLD="",N=MAX S OLD=$G(d)
 . W:'TWO ! I TWO W $C(13),$J("",70),$C(13) ;start on new line
 . W p_": "_$S(OLD]"":OLD_" => ",1:"") R R S Z=$ZB,TWO=0 S:R="" R=OLD
 . I $zm'["R",$A(Z)=27 S R="" DO  G GetDv:R="" ;handle special function keys!!
 . . I Z=$C(27,91,65) DO  Q  ;handle ANSI up-arrow
 . . . S TWO=1,N=$O(@devlist@(N),-1) I 'N S N=$G(@devlist@(0))+1 Q
 . . I Z=$C(27,91,66) DO  Q  ;handle ANSI down-arrow
 . . . S N=N+1,TWO=1 I N>MAX S N=1
 . . I Z=$C(27,91,67) S R="@" Q  ;handle ANSI right-arrow --> edit
 . . I Z=$C(27,91,68) S R="@" Q  ;handle ANSI left-arrow --> edit
 . ;
 . I R="@",OLD="" S R="" W *7 G GetDv ;nothing to edit
 . I R="@",OLD]"" S R=$$ED(OLD) ;use good-old replace/with editor
 . D:R["." Touchd(R) S Z=R Q  ;just pass on the value
GetErr . S $ZT="" Q:$ZE["<ENDOFFILE"  W !,"Error: "_$ZE S D="",TWO=0,N=$G(MAX) G GetDv ;clear default
GetFail S $ZT="" ;can't select a device
 N R W !,p_": " R R Q R
 
Touchd(D) ;add device 'D' to the list of devices 'touched' today
 Q:D=""  Q:D=-1  Q:D'["."  I '$D(devlist) N devlist DO  ;default
 . S devlist="^mtemp1(""dev"")" ;as good a place as any...
 . I $G(@devlist)<$H K @devlist S @devlist=$H_","_$J_","_$I
 ;I $D(@devlist@("*",D)) Q  ;already in list
 N O,N S O=$G(@devlist@("*",D)),N=$G(@devlist@(0)) I N,O=N Q  ;same
 K:O @devlist@(O) S N=N+1,@devlist@(0)=N,@devlist@(N)=D
 S @devlist@("*",D)=N Q  ;keep track of directories added
 
#include ISCED
 
#endif ISCGetDev