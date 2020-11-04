ROUTINE YESNO [Type=INC]
#;/*=======================Maintenance========================*/
#;LFT1385 1/18/05 Laura Tillem, use system messages instead
#;LFT1177 12/29/3 Laura Tillem, include %occErrors instead of MESSAGES
#;STC273 04/29/01 Steve Clay, Initial version
#;/*=====================End Maintenance======================*/
#;
#; This include file will prompt the user for a Yes or No answer
#; Parameters:
#; 	default - 0=Default of No
#; 			- 1=Default of Yes
#; Return Values
#; 			  0 - No entered
#; 			  1 - Yes Entered
#;
#;Example
#;
#; This example prints the prompt and a default of "No"
#; and then gets the response from the user
#;   u 0 w !,$$GetMessage($$$StopIntegrityCheck) i $$YESNO(0) q "Stop"
#;   
#ifndef YESNOINC
#define YESNOINC
#if 0  ;LFT1385+
YESNO(default)
 n a,b,x,v
 s x=$x
 s a=$s(default=0:$SYSTEM.Status.GetErrorText($$$ERROR($$$NO)),1:$SYSTEM.Status.GetErrorText($SYSTEM.Status.Error($$$YES))),a=$p($p(a,": ",2)," [")
 F  DO  Q:$D(v)
 . W *-1," "_a_" => " R b I b="" S b=a
 . S b=$zcvt($e(b),"U") 
 . i b=$p($p($SYSTEM.Status.GetErrorText($SYSTEM.Status.Error($$$NOAbreviated)),": ",2)," [") s v=0 q
 . i b=$p($p($SYSTEM.Status.GetErrorText($SYSTEM.Status.Error($$$YESAbreviated)),": ",2)," [") s v=1 q
 . W *7," "_$p($p($SYSTEM.Status.GetErrorText($SYSTEM.Status.Error($$$YESNOAnswer)),": ",2)," ["),!,?x
#else ;LFT1385=
#define CHUIMsg "%CHUI.YesNo"
YESNO(default)
 n a,b,x,v
 s x=$x
 s a=$s(default=0:$$$GetSimpleMessage($$$CHUIMsg,"NO"),1:$$$GetSimpleMessage($$$CHUIMsg,"YES"))
 F  DO  Q:$D(v)
 . W *-1," "_a_" => " R b I b="" S b=a
 . S b=$zcvt($e(b),"U") 
 . i b=$$$GetSimpleMessage($$$CHUIMsg,"NOAbbreviated") s v=0 q
 . i b=$$$GetSimpleMessage($$$CHUIMsg,"YESAbbreviated") s v=1 q
 . W *7," "_$$$GetSimpleMessage($$$CHUIMsg,"YESNOAnswer"),!,?x
#endif ;LFT1385-
 Q v
#endif