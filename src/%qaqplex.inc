ROUTINE %qaqplex [Type=INC]
	#;  %qaqplex.inc - SQL lexical analyzer (Aviel 12/2/98) V27
#INCLUDE %msql
#IF 0   ;-------------------------------------------------------------
	; Description:   SQL lexical analyzer + compiler service functions
	; Author:        Aviel Klausner
	; Date Started:  December 2, 1998
	;
	;  AK862   (04/02/2012) - "findname" for all tables and fields
	;  JLF275  (09/04/2009) - Create special lexer functions for double quoted XML tag names 
	;  PVA182  (05/19/2009) - Introduce $$checknr to replace all keyword uses of $$checkid
	;  PVA093  (07/21/2006) - Drop support for legacy not&, not! operators
	;  DPV2697 (07/12/2006) - Use $e(...,*) and $e(...,...,*) in SQL code
	;  DPV2694 (07/10/2006) - Allow SQL Empty String input value to be configurable per namespace
	;  DPV2689 (07/06/2006) - Support /* ... */ comments in SQL
	;  DPV2672 (06/23/2006) - Add support for statement level triggers
	;  BJB237  (08/27/2002) - Avoid <MAXNUMBER> error SQL constants
	;  DPV1504 (03/16/2001) - Support CREATE TRIGGER
	;  DPV1498 (02/22/2001) - Support -- simple comments
	;  AK457   (11/22/2000) - Imply space between query lines
	;  AK443   (05/17/2000) - Allow "_" to start an identifier
	;  PVA010  (04/28/2000) - Enable lower case 'e' in exponent notation in SQL
	;  DPV1284 (03/30/2000) - Use proper reserve word check in skip, implement any()
	;  AK412   (12/06/1999) - Reimplement LIKE, %PATTERN
	;  DPV1207 (12/06/1999) - Support != as NOT=
	;  DPV1167 (10/20/1999) - Fix :var("string") variable references when delimited
	;                         identifiers are on
	;  DPV1150 (09/30/1999) - Support @#$ in regualr identifiers (not first character)
	;  DPV1125 (09/23/1999) - Support Sybase orthogonal RIGHT OUTER JOIN operator: *=
	;  AK382   (07/20/1999) - EMIS: Delimited identifiers
	;  AK380   (07/08/1999) - CCS#37: OUTER JOIN with expression
	;  DPV1106 (07/15/1999) - CCS: Add skipidorres function psrsing utility
	;  DPV1098 (07/01/1999) - Support $c(9),$c(160) as whitespace in SQL
	;  AK362   (05/13/1999) - CCS: ODBC scalar functions
	;  DPV1007 (03/17/1999) - Preserve '_' in identifier names
	;  AK338   (12/02/1998) - Lexical analyzer moved to %qaqplex.INC
	;                         (routine created)
	;  AK326   (07/23/1998) - Replace ?<pat> with %PATTERN <const>
	;  AK325   (07/21/1998) - Korea: Allow spaces in $$ a ^ b ()
	;  AK277   (08/01/1995) - Fix Exponential notation in tag expo
	;-------------------------------------------------------------
	;   Parsing utilities:          putval
	;                               putlog
	;                               newval  ;  AK412
	;                               newlog  ;  AK412
	;                               check
	;                               checkid
	;                               chose
	;                               anyid
	;                               skip
	;                               skipid
	;                               error
	;   Lexical analyzer:           many
	;                               newln
	;                               first
	;                               lext (main)
	;                               alpha
	;                               digit
	;                               expo
	;                               strng
	;                               colon
	;                               cosex
	;
#ENDIF  ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
newval(val) d putval(val) QUIT val ;  $$: new ST entry (no side-effect of setting val)
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
newlog(val) d putlog(val) QUIT val ;  $$: new ST entry (no side-effect of setting val)
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  make v a new VALUE entry
putval(v) s (val,maxv)=maxv+1,mt("v",val)=v,logic=0 QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  make v a new LOGIC entry
putlog(v) s val=$o(mt("l",""),-1)+1,mt("l",val)=v,logic=1 QUIT
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  $$ - report whether t encountered, advance if so
check(t) i t=token { d lext QUIT 1 } QUIT 0
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  $$ - report whether ID t encountered, advance if so
	#;  (replaces $$check for reserved words and identifiers)
checkid(t) i t=$s(token="ID"&&(%delid'=2):value,1:token) { d lext QUIT 1 } QUIT 0
checkxmlid(t) i t=$s(token="ID":value,1:token) { d lext QUIT 1 } QUIT 0
	#;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  $$ - advance if a token in tlist encountered, return it in x
chose(tlist,x) i tlist[token { s x=token d lext QUIT 1 } QUIT 0
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#; $$ - advance if a token in tlist encountered, return it in x
	#;  (same as $$chose but with " " between tokens)
any(tlist,x) i tlist[(" "_token_" ") { s x=token d lext QUIT 1 } QUIT 0
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#; $$ - advance if any ID in tlist encountered, return it in x
	#;  (replaces $$chose for reserved words and identifiers)
anyid(tlist,x) s x=$s(token="ID"&&(%delid'=2):value,1:token) i tlist[(" "_x_" ") { d lext QUIT 1 } QUIT 0
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  advance after verifying that the token t was encountered
	#;  define skip(%t) error(1):'$$check(%t)
skip(t) i token'=t { if t="ID"&&$$$SQLReservedWordForParsing(token) {s token="reserved word "_token} d error(1)}	GOTO lext
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  advance after verifying that the identifier t was encountered
	#;  (replaces skip for reserved words and identifiers)
skipid(t) i token="ID"&&(%delid'=2),value=t { GOTO lext } d error(1):token'=t GOTO lext
skipxmlid(t) i token="ID",value=t { GOTO lext } d error(1):token'=t GOTO lext
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
error(e) GOTO ^%qaqperr  ; -- e is error# --
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  LEXICAL ANALYZER
	#;  skip any cc, continue on next line if needed
many(cc) f p=p:1 { d newln:p=more s c=$e(mask,p) QUIT:cc'[c } QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
newln	;
#IF 1   ; AK862+
	#;  original location of the first token in the new line, maybe
	s:callname="findname" mt("namaplex")=$lb(,line,f)
#ENDIF  ; AK862-
	s line=line+1  ;  Skip over whole-line SQL comments
	f  q:$e($zstrip($g(input(line)),"<W"),1,2)'="--"||(line=input)  s line=line+1
	#;  add space between the lines
	s sql=$e(sql,f,p)_$e(" ",line>1)_$g(input(line))
#IF 1   ; AK862+
	#;  offset to use for positions in the new line
	s:callname="findname" $li(mt("namaplex"))=$l(sql)-$l(input(line))
#ENDIF  ; AK862-
first	s mask=$$$MASK(sql)_$c(1),more=$s(input>line:$l(mask),1:0),p=p-f+1,f=1 QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
lext	s fsave=f,f=p d:p=more newln
lext1	s p=$l(mask)-$l($zstrip($e(mask,p,*),"<",$c(9,10,13,32,160)))+1 i more,p'<more { s p=more,c=" " d newln goto lext1 } else { s c=$e(mask,p) }
	if c="-",$e(mask,p+1)="-" { s token="--" if line<input { s f=fsave,p=p-1 d newln g lext } else { s p=$l(mask) g lext } } ;  -- comment, rest of line is a comment
	s:%delid=2 %delid=1 s f=p,token=c,p=p+1
	GOTO alpha:"%x_"[c,digit:c=9,strng:"""'"[c
		#; To avoid doing a lot of test check if this token is interesting first, this is also true if c=$c(1)
	QUIT:"$-=.:<>|!(*/"'[c  // DPV2689 ("/")
	i c="=",$e(mask,p)=">" s token="=>",p=p+1 QUIT     ; distinct arrow=>syntax JLF015=
	i c="." d many(9) QUIT:f+1=p  s token=9 GOTO expo  ;  dot or number
	i c="/",$e(mask,p)="*" s token="/*" f p=p:1 { d newln:p=more s c=$e(mask,p) If c=$c(1) { s t="*/",token=$c(1) d error(1) } If c="*"&&($e(mask,p+1)="/") { s p=p+2 q  }} g lext //DPV2689=
	i ":$-<>"[c,p=more d newln
	GOTO colon:c=":",cosex:$e(mask,p-1,p)="$$"&&($g(%DDLMode)'="Sybase")  ;  MRP129;AK234
		#;---------- general symbol ----------
	i c="-",$e(mask,p)=">" s token="->",p=p+1 QUIT     ;  arrow->syntax
	i "<>"[c,$e(mask,p)="=" s token=$s(c="<":"'>",1:"'<"),p=p+1 QUIT  ;  <=,>=
	i $e(mask,p-1,p)="<>" s token="'=",p=p+1 QUIT      ;  <>
	i $e(mask,p-1,p)="=*" s token="=*",p=p+1 QUIT      ;  outer join
	i $e(mask,p-1,p)="||" s token="_",p=p+1 QUIT       ;  || - Concatenation
	i $e(mask,p-1,p)="!=" s token="'=",p=p+1 QUIT      ;  != DPV1207=
	i $e(mask,p-1,p+1)="(+)" s token="(+)",p=p+2 QUIT  ;  Oracle outer-join  AK380=
	i $e(mask,p-1,p)="*=" s token="*=",p=p+1 QUIT      ;  RIGHT OUTER JOIN (Sybase compatibility)  DPV1125
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  reserved word or identifier
alpha	s p=$l(mask)-$l($zstrip($e(mask,p,*),"<","x9_@#$"))+1 i more,p'<more { s p=more,c=" " d newln } Else { s c=$e(mask,p) } s lower=$e(sql,f,p-1),value=$$$UPPER(lower)
	QUIT:lower="_"  ;  concatenate operator, no identifier
	#; PVA093: eliminate &! from following list
	i value="NOT","<[=]>"[c s token="'"_c,p=p+1,f=f+3 QUIT
	s token=$s($$$SQLReservedWordForParsing(value):value,1:"ID")
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
digit	d many(9) i c="." s p=p+1 d many(9)  ;---------- numerical constant
	#; Note the case of the "E/e" is not folded, relying on system build supporting either case.
expo	i $e(sql,p)="E"!($e(sql,p)="e") s p=p+1 d newln:p=more s:"+-"[$e(mask,p) p=p+1 d many(9),error(2):$e(mask,p-1)'=9  ;  PVA010
	d error(7):$Number($e(sql,f,p-1))="" 
	s value=+$e(sql,f,p-1)
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
strng	;  string constant
	s value=1  ;  value=(#quotes)#2, flags if inside quotes
	f p=p:1 d newln:p=more s c=$e(mask,p) QUIT:c=$c(1)  QUIT:c'=token&'value  s:c=token value='value
	d error(3):value s value=$e(sql,f,p-1)
	s:token="'" value=$TR(value,"""'","'""") x "s value="_value s:token="'" value=$TR(value,"""'","'""")
	#;  delimited identifier - don't strip any punctuation
	#;  (but if "", treat as empty string for backwards compatibility)
	#;  %delid is newed and initialized in %qaqqt
	#;  %delid is TRUE if delimited identifiers are turned on
	#;  %delid=2 if the token="ID" came from a delimited identifier.
	i %delid,token="""",value'="" s lower=value,value=$$$UPPER(lower) s token="ID",%delid=2 QUIT
	s token=9 s:value="" value=$$$SQLEmptyString  ;  internal representation for SQL empty-string	// DPV2694=
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
colon	;  host program variable  *** add globals?
	if $g(%mmmJSONOBJECT) { set token=":" QUIT  }	// ":" used as a separator in JSON_OBJECT(key:value)
	do error(28):"x%"'[$e(mask,p)&&('$g(%mmmNo28Check))
	set p=p+1
	do many("x9")
	set value=$e(sql,f+1,p-1)
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
cosex	;  COS extrinsic function call
	s p=$f(mask,"(",p) d error(41):'p  ;  Open "(" is required to be on the same line as the extrinsic function. "^routine" is optional  MRP129-
	s token="$$",value=$tr($e(sql,f+2,p-2)," ")  ;  remove spaces
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#INCLUDE %fcmask