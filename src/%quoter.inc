ROUTINE %quoter [Type=INC]
 ;%quoter.INC
#; $$ Func to wrap quotes around x, x may already contain quotes
quoter(x,QuoteNumbers) PUBLIC { Quit $select(('$get(QuoteNumbers))||(x'=+x):$select(x=$char(0):"$c(0)",1:$zu(144,1,x)),1:""""_x_"""") }
#; $$ Function.  Same as quoter, but don't wrap quotes around it if x can be
#;                 a regular identifier.  Used for code generating SQL statements
#;                 for delimited identifier support.  
#;  A regular identifier must begin with a letter, '_', or '%', and be followed by letters, numbers, '_', '@', '#', or '$'
#; No quotes needed for regular identifier
#;  If extraquote is true, we are using the results inside a larger string.
#;  We need to double again
#;  For example:  
#;    Set %Line="Set %msg=""blah blah '"_$$quoter2($$$Tschema(tab))_"."_$$quoter2($$$Tbasetabname(tab))_"' blah blah blah"""
#;  We want to tun something like SELECT into ""SELECT""
#;  and something like SEL" "ECT into ""SEL"""" """"ECT""
quoter2(x,extraquote) PUBLIC { Quit $select(($zname($e(x))||($e(x)="_"))&&($zname($tr("%"_$e(x,2,*),"_@#$")))&&('$$$SQLReservedWordForParsing($zcvt(x,"U"))):x,x=$c(0):"$c(0)",x=+x:""""_x_"""",$g(extraquote):$$quoter3($zu(144,1,x)),1:$zu(144,1,x)) }
quoter3(x) { Quit """"_$zu(144,1,$extract(x,2,*-1))_"""" }