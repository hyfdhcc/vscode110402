ROUTINE LANGdtm [Type=INC]
 ;%LANGdtm.INC - DTM command routines. cfl(lopes) ; CFL154 08/24/99
  
#if 0   /*=======================Maintenance========================*/
EKP025  4/06/05 Eric Pape, fix file open append mode
CFL154  ;08/24/99, Carlos Lopes, added printer support via Alias
LRS277  ;10/28/98, Lee Smith, fix $TEXT usage to not require source code
JO1041  ;06/12/98, Jeffrey Orlin, renamed %msql* to %LANG*
CFL030  ;12/18/97, Carlos Lopes: %msqldtm.INC creation
#endif  /*=====================End Maintenance======================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve 
 ;               $TEST if the command being emulated does not 
 ;               update $TEST!
 ;
 ; DTM Auxiliary Routines
 ;
 ; GetCurParms - Gets current parameters
 ; SetCurParms - Sets current parameters
 ; GetDevList  - Gets device association list
 ; SetDevList  - Sets device association list
 ; finddev     - Returns device association
 ;
 ; Pieces are as follows:
 ; 1 - initialization flag
 ;       0 - Device not initialized
 ;       1 - Device initialized
 ;       2 - The mnemonicspace is not %XDTM2 so do not execute
 ; 2 - class
 ; 3 - type
 ; 4 - level
 ; 5 - page width
 ; 6 - page length
 ; 7 - frame width
 ; 8 - frame length
 ; 9 - top margin of frame
 ;10 - left margin of frame
 ;11 - wrap
 ;12 - trunc
 ;13 - vt emulation
 ;14 - mnemonicspace name
 ;15 - crlf
 ;16 - tab expansion
 ;17 - form feed expansion
 ;18 - edit mode
 ;19 - speed
 ;20 - stop bits
 ;21 - parity
 ;22 - charbits
 ;23 - xon response
 ;24 - generate xon
 ;25 - autobaud
 ;26 - modem
 ;27 - rts
 ;28 - cts
 ;29 - escape timeout
 ;30 - no login
 ;31 - read escape sequences
 ;32 - interpretation of message characters
 ;33 - input translation map
 ;34 - output translation map
 ;
 ; Defaults:
 ; Not initialized, Terminal, Cache' Terminal, level 3, page 80x24,
 ; frame 80x24, margins 0, 0, wrap, no trunc, no vt emulation,
 ; ^%XDTM2, no crlf translation, no tab or ff expansion, no edit,
 ; 9600,1,N,8, xon, xongen, no autobaud, no modem, no rts, no cts,
 ; timeout = 1, login allowed, don't read escape sequences
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef %LANGdtm
#define %LANGdtm
  
#include GLUEDEF
 ;
#define PNOPIECE 0
#define PINIT 1
#define PCLASS 2
#define PTYPE 3
#define PLEVEL 4
#define PPWID 5
#define PPLEN 6
#define PFWID 7
#define PFLEN 8
#define PTMAR 9
#define PLMAR 10
#define PWRAP 11
#define PTRUNC 12
#define PVT 13
#define PMSN 14
#define PWRCR 15
#define PXPNDTAB 16
#define PXPNDFORM 17
#define PEDITMODE 18
#define PSPEED 19
#define PSTOPBITS 20
#define PPARITY 21
#define PCHARBITS 22
#define PXON 23
#define PXONGEN 24
#define PAUTOBAUD 25
#define PMODEM 26
#define PRTS 27
#define PCTS 28
#define PESCAPETIMEOUT 29
#define PNOLOGIN 30
#define PESCAPE 31
#define PIXINTERP 32
#define PIXXLATE 33
#define POUTX 34
#define PBUFSIZE 35
#define POPENSTR 36
#define PCLOSESTR 37
#define PSHARE 38
#define PLFA 39
 ;
#if 0   ;LRS277+
def ;|1|2|3|80|24|80|24|0|0|0|0|0|^%XDTM2|0|0|0|0|9600|1|0|8|1|1|0|0|0|0|1|0|0|0|0|0|1024|||dn|0
#else   ;LRS277=
#if 0   ; EKP025+
def ;;|1|2|3|80|24|80|24|0|0|0|0|0|^%XDTM2|0|0|0|0|9600|1|0|8|1|1|0|0|0|0|1|0|0|0|0|0|1024|||dn|0
#else   ; EKP025=
def ;;|1|2|3|80|24|80|24|0|0|0|0|0|^%XDTM2|0|0|0|0|9600|1|0|8|1|1|0|0|0|0|1|0|0|0|0|0|1024|||dn|
#endif  ; EKP025-
#endif  ;LRS277-
 ;
 ;+
 ; Get current parameters
 ;-
GetCurParms(dev) N defpar,ps,str,di S di=$I S dev=$S('$D(dev):$I,dev=0:$I,1:dev)
#if 0   ;LRS277+
 S defpar=$P($T(def),";",2) I dev'=$I D  Q defpar
#else   ;LRS277=
 S defpar=$P($T(def),";",3) I dev'=$I D  Q defpar
#endif  ;LRS277-
 . ZT:cmd="U" $$$APPERROR($$$ERUNIMP) Q
 S ps=$ZU(96,6) Q:'ps defpar S str=$ZU(96,7) Q $E(str,2,1+$A(str))
 ;+
 ; Set current parameters
 ;-
SetCurParms(dev,par) ;
 N ps,len,di S dev=$S('$D(dev):$I,dev=0:$I,1:dev)
 S len=$L(par) ZT:len>255 $$$APPERROR($$$ERSTORE)
 I dev'=$I D
 . I cmd'="O" ZT $$$APPERROR($$$ERUNIMP)
 . S di=$I U dev Q
 S ps=$ZU(96,6,1+len) ZT:'ps $$$APPERROR($$$ERSTORE)
 V ps:-3:-1-len:$C(len)_par
 U:$D(di) di Q
 ;+
 ; Get device association list
 ;-
GetDevList()  N ps,str
 S ps=$ZU(96,23) Q:'ps ""  S str=$ZU(96,24) Q $E(str,2,1+$A(str))
 ;+
 ; Set device association list
 ;-
SetDevList(list) ;
 N ps,len S len=$L(list) ZT:len>255 $$$APPERROR($$$ERSTORE)
 S ps=$ZU(96,23,1+len) ZT:'ps $$$APPERROR($$$ERSTORE)
 V ps:-3:-1-len:$C(len)_list Q
 ;
finddev(dev) N i,dvl,val,p
 S dvl=$$GetDevList(),val=""
 F i=2:1:$L(dvl,"|") S p=$P(dvl,"|",i) I $P(p,";",1)=dev S val=$P(p,";",2) Q
#if 0   ; CFL154+
 Q val
#else   ; CFL154=
 Quit:val'="" val Quit dev
#endif  ; CFL154-
 ;
#endif  ; %LANGdtm