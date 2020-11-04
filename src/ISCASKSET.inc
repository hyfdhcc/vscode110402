ROUTINE ISCASKSET [Type=INC]
 ; prompt the user for a value, with default provided HYY1028 12/30/04
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;HYY1028 12/30/4 Huayong Yang, allow pattern matching on input validation
#;TCS004 07/02/03 Jeffrey Orlin: Support for ^ to indicate backup to the
#;                prior prompt and ? to display optional help text. Also
#;                change the display of the default so that if after displaying
#;                the prompt there isn't enough space for the default we
#;                display the default on the new line. After displaying the
#;                default if there isn't enough space for an answer, the same
#;                length as the default, left then we display the prompt
#;                on a new line and wait for input there.
#;HYY021 01/03/97 Huayong Yang: creation
#endif  /*=====================End Maintenance======================*/
  
#ifndef ISCASKSET
#define ISCASKSET
  
#if     0       ;TCS004+
 ; prompt:
 ; val: default value in, new value out (if passed by reference)
 ; return:
 ;       user's input if not null
ASKSET(prompt,val) ;procedure
 N x
 W !,$G(prompt)," ",$G(val)," =>" R x,!
 S:x'="" val=x
 Q
#if 0   ;HYY073+
askset(prompt,val) ;function
 N x
 W !,$G(prompt)," ",$G(val)," =>" R x,!
 Q $S(x="":val,1:x)
#endif  ;HYY073-
#else   ;TCS004=
#if 0   ;HYY1028+
ASKSET(prompt,val,backup,help) ;procedure
#else   ;HYY1028=
ASKSET(prompt,val,backup,help,pattern) ;procedure
#endif  ;HYY1028-
 ; parameters
 ; prompt - string to be displayed as the prompt
 ; val - passed by reference. The response is returned here. If val is
 ;       not null on input it provides the default value when the user
 ;       presses return for an answer.
 ; backup - optional - omitted is the same as 0
 ;      -1 = don't treat "^" as a special character, POP is not zeroed or set
 ;       0 = backup not enabled, display a message and repeat the prompt
 ;      >0 = ^ means back up to the prior prompt. 
 ;       When backup=-1, POP is not touched
 ;       When backup is not -1 entering "^" (including the quotes) returns
 ;          ^ as the value of the response.
 ;       When backup is >0 entering ^ returns the original "val" as the
 ;           result with POP set to 1
 ; help text - optional - omitted is the same as null
 ;           if help is "*" then ? is accepted as a value and returned. When
 ;           help is not "*" then if $D(help) is 1 its a single line message
 ;           or if its >1 then its a multiline message. If $D(help)=1 and
 ;           $G(help)="" then a [No help is available] message is displayed
 ;           and the prompt is repeated. Entering "?" (with the quotes) will
 ;           return ? as the answer.
 								#;HYY1028+
 ; pattern - (optional) input text must match a certain pattern (e.g. 8N)
 								#;HYY1028-
 N x,done,def,enahelp,helpavail,backupavail
 s done=0
 s def=$G(val)
 s backup=$G(backup,0) 
 s enabackup=$S(backup=-1:0,1:1)
 s backupavail=$S(backup=1:1,1:0)
 s help=$G(help)
 s enahelp=$S(help="*":0,1:1) ;there might not be any help though
 s helpavail=$s(enahelp&($L(help)!($D(help)>1)):1,1:0)
 if 'enabackup n POP
 s POP=0
 f  d  q:done!POP
 . W !,$G(prompt)
 . w:($X+$L(def))>65 !,?5
 . w:$L(def) " <",def,">"
 . if helpavail!backupavail do
 . . w " [" w:helpavail "?" w:backupavail "^" w "]"
 . w:(($X+$L(def))>75) !,?5
 . W " => " 
 . R x,!
 . if x="^" d  q
 . . if 'enabackup s done=1 q
 . . if backupavail s POP=1 q
 . . w "...backup not available here"
 . if enabackup,x="""^""" s x="^",done=1 q
 . ;
 . if x="?" d  q
 . . if 'enahelp s done=1 q
 . . if 'helpavail w "...help not available here" q
 . . if $D(help)=1 w !?5,help q
 . . s x="" f  s x=$O(help(x)) q:x=""  w !,?5,help(x)
 . . w !
 . if enahelp,x="""?""" s x="?",done=1 q
 								#;HYY1028+
 . i x]"",$g(pattern)]"",x'?@pattern w !?5,$s(helpavail:help,1:"[bad format]") q
 								#;HYY1028-
 . s:'$L(x) x=val 
 . s done=1
 s:'POP val=x
 q
#endif  ;TCS004-         
#endif