ROUTINE %occFunctions [Type=INC]
#define ucase(%string)     $zconvert(%string,"u")
#define lcase(%string)     $zconvert(%string,"l")
#define ALPHAUP(%val)      $zconvert($zstrip(%val,"*P",,",?"),"U")
	#; This macro will place quotes around strings. Numbers remain unquoted
#define QUOTE(%string)			$select(%string=$char(0):"$c(0)",1:$zu(144,1,%string))
	#; This macro will place quotes around all strings, including simple numbers
#define QUOTENUMBER(%string)	$select((%string'=+%string):$select(%string=$char(0):"$c(0)",1:$zu(144,1,%string)),1:""""_%string_"""")
#define GENERATE(%line)    Set %code($increment(%code))=%line
#define DEFINECODEBLOCK(%name,%line) Set %codeblock(%name,$increment(%codeblock(%name)))=%line
#define ADDCODEBLOCK(%name,%data)    Set %codeblock(%name,0,$increment(%codeblock))=%data,%codeblock(%name,0)=$get(%codeblock(%name,0))+1
#define GENERATECODEBLOCKS(%cutoff) Do GenerateCodeBlocks^%occCode(.%codeblock,.%code,%cutoff)
#def1arg GENERATECODEBLOCK(%args) Do GenerateCodeBlock^%occCode(.%codeblock,.%code,%args)
#define TimeStamp          $zutil(188)
#define TimeToODBC(%val)	($zdt(%val,3)_$s(%val[".":"."_$p(%val,".",2),1:""))
 
#define FOREACHcommaelement(%list,%counter,%element)                For %counter=1:1:$length(%list,",") Set %element=$piece(%list,",",%counter) Quit:%element=""
#define FOREACHarrayelement(%array,%element)                        Set %element="" For  Set %element=$order(%array(%element)) Quit:%element=""
#define CACHEDSTATEMENT(%class) (%class[($$$CQPackage_"."))
#define UseEmbedCursorData $get(^%SYS("sql","sys","embedcursordata"),1)

#define StackObjectState(%oref)	new %iscstacker s %iscstacker=##class(%SYS.Stacker).%New(%oref) new %iscstacker

#; Generate a random integer in the range [0-n) using the $zu(165 seeded random number generator
#define PRand(%n) ($zu(165,1,%n))
 