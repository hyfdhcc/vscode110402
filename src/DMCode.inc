ROUTINE DMCode [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SJ2548 11/20/08 Scott Jones, make into procedures
#;SML714  6/20/06 Simon Li, Support message to cconsole.log.
#;JO1919   5/03/05 Jeffrey Orlin, add new i to ShowMessage
#;LFT1320 11/01/4 Laura Tillem, %DM -> %SYS.DATABASE
#;LFT1177 12/29/3 Laura Tillem, include %occErrors instead of MESSAGES
#;STC273 04/29/01 Steve Clay, Fix spacing, add GetMessage
#;CFL445 02/02/01 GUI support
#;LFT863 11/14/00 Laura Tillem, include file of code
#;                for database management api %DM
#endif  /*=====================End Maintenance======================*/
#ifndef  DMCodeINC
#define DMCodeINC
  
#include DM
 
ShowMessage(sc,device) [] PRIVATE {
    Do DecomposeStatus^%SYS.DATABASE(sc,.msglist,0,"")
    Do wrtmsg($C(13,10),device)
    For i=1:1:msglist {	Do wrtmsg(msglist(i)_$C(13,10),device) }
}
wrtmsg(msg,device) [] PRIVATE {
    Quit:'$L(msg)  ; Avoid argumentless writes...
    If device=-1 { Do $zu(9,"",msg,0,0) Quit }
    If $g(%UI,"CHUI")="CHUI" { Use device Write msg Quit }
    Do:$$IjcMsg^%Wprima("DI"_msg)="CANCEL"  ; Return value could be cancel message 
    . i $$IjcMsg^%Wprima("DI"_$C(13,10)_"Abort received!"_$C(13,10))
    . zt "Abort"
}
#endif ; #ifndef DMCodeINC