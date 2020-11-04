ROUTINE ISCzshell [Type=INC]
#;/*=======================Maintenance=============================*/
#;JLC2109 01/16/18 Jose' Cordeiro, remove duplicate audit records
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;STC1992 09/27/11 Steve Clay, Allow ! CD DIR to work correctly on windows
#;STC1878 12/21/10 Steve Clay, O/S access on windows using "!" and "$" is now tied to %System_CallOut resource 
#;RFD523   4/26/10 Rob Davis, Change prompt to current directory 
#;RJW1543 03/17/08 Ron Watt, Correct possible infinite loop in ! command command when $ZUTIL(68,40) = 1
#;RJW1520 02/11/08 Ron Watt, Cache Terminal infinite loop on '!2' or '$2' command
#;RJW1384 11/21/06 Ron Watt, Interactive shell invocation for Windows causes hung session
#;/*=====================End Maintenance============================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef ISCshell
#define ISCshell
#include %syAudit
#;include %sySecurity 
#;include %syDatabase
#; ZSHELL (!) command
 
#;RJW1384+
ZSHELL(cmd) public {
 s true=$t
 s zeof=$zu(68,40,0)
 s zu168=$zu(168)
 i '$SYSTEM.Security.Check($$$SystemCallOutResourceName,$$$PermUseName) g PROTECTERROR
ZshellLoop	;
 s $zt="ZshellErr"
 #;Execute input shell command
 i $g(cmd)'="" s p=cmd
 #;Read shell command
 e  u 0 w !,$zu(168),"> " r p i p="" g ZshellLoop
#;Strip leading and trailing whitespace
 s p=$zstrip(p,"<>",$c(32,9))
 #;Exit on "exit" or "quit"
 i $zcvt(p,"l")="exit"!($zcvt(p,"l")="quit") {
	d $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeSystem,$$$NameOSCommand,"Execute O/S command"_$c(13,10)_"Directory: "_$zu(168)_$c(13,10)_"Command:   "_p,"Execute O/S command")
	g ZshellExit
 }
 #;handle cd special here by calling $zu(168)
 Try {i $zcvt($e(p,1,3),"l")="cd " d $zu(168,$zstrip($zstrip($e(p,4,*),"<",$c(32,9)),"*","""")) g ZshellExit:$g(cmd)'="" g ZshellLoop } catch {w !,"The system cannot find the path specified." g ZshellExit:$g(cmd)'="" g ZshellLoop} 
 #;Prevent !2 from opening "2" and reading and writing forever in the read loop
 i p?1n.n w !,"command (",p,") failed" g ZshellLoop:$g(cmd)="" g ZshellExit
 #;Open command through a pipe
 o p:("QR"):1 e  w !,"command failed" g ZshellLoop:$g(cmd)="" g ZshellExit
 #;Read output from command, display on terminal
 f  u p r x u 0 w !,x
ZshellErr ;
 s $zt="" u 0 i $g(p)'="" c p
 i $ze["<ENDOFFILE>" g ZshellLoop:$g(cmd)=""
ZshellExit ;
 i zeof d $zu(68,40,1)
 d $zu(168,zu168)
 if true
 q
PROTECTERROR
 i zeof d $zu(68,40,1)
 if true
 ztrap $$$APPERROR($$$ERPROT)
}
#;RJW1384-
#endif