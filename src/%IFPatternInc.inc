ROUTINE %IFPatternInc [Type=INC]
#define RegExChrRangeStart		"["
#define RegExChrRangeEnd		"]"
#define RegExChrRangeSep		"-"
#define RegExChrRepNumStart		"{"
#define RegExChrRepNumEnd		"}"
#define RegExChrRepNumSep		","
#define RegExChrGroupStart		"("
#define RegExChrGroupEnd		")"
#define RegExChrStar			"*"
#define RegExChrPlus			"+"
#define RegExChrQuestion		"?"
#define RegExChrOr				"|"
#define RegExChrEscape			"\"
#define RegExChrAny				"."

#define RegExChrAnyCode			-2

/// These are interpretted as a class if they have been preceded by an escape
/// These classes are being replaced by their corresponding syntax in the input string
#define RegExClassWhiteSpace		"s"
#define RegExClassWhiteSpaceChars	" "
#define RegExClassDigit				"d"
#define RegExClassDigitChars		"[0-9]"
#define RegExClassWord				"w"
#define RegExClassWordChars			"[a-zA-Z0-9_]"
/// The hex char is followed by 2 hex digits or two or more between { }
#define RegExClassHexChar			"x"

/// POSIX character classes
/// These classes should appear in a range block (as the sole element) e.g. [:upper:]
/// These classes are being replaced by their corresponding syntax in the input string
#define RegExPosixUpper			":upper:"
#define RegExPosixUpperChars	"A-Z"
#define RegExPosixLower			":lower:"
#define RegExPosixLowerChars	"a-z"
#define RegExPosixAlpha			":alpha:"
#define RegExPosixAlphaChars	$$$RegExPosixUpperChars_$$$RegExPosixLowerChars
#define RegExPosixDigit			":digit:"
#define RegExPosixDigitChars	"0-9"
#define RegExPosixAlNum			":alnum:"
#define RegExPosixAlNumChars	$$$RegExPosixAlphaChars_$$$RegExPosixDigitChars
#define RegExPosixBlank			":blank:"
#define RegExPosixSpace			":space:"
#define RegExPosixSpaceChars	" "
#define RegExPosixPunct			":punct:"
#define RegExPosixPunctChars	"!""#$%&'\(\)\*\+,\-\./:;<=>\?@\[\\\]^_`\{\|\}~"
#define RegExPosixWord			":word:"
#define RegExPosixWordChars		$$$RegExPosixAlNumChars_"_"


#define RegExTokSep					$c(0)
#define RegExAddTokSep(%str)		set %str=%str_$$$RegExTokSep
#define RegExAddChr(%str,%chr)		set %str=%str_%chr

#define RegExToggleParseState(%chr,%var,%start,%end)			if (%chr=%start) { set %var=1 } elseif (%chr=%end) { set %var=0 }
#define RegExToggleParseStateEx(%chr,%var,%start,%end,%reset)	if (%chr=%start) { set %var=1, %reset="" } elseif (%chr=%end) { set %var = 0 }

#define RegExOpSet					"[]{}()*+?|."
#define RegExCheckOpSet(%chr)		$FIND($$$RegExOpSet,%chr)
#define RegExEndSet					"]})"
#define RegExCheckEndSet(%chr)		$FIND($$$RegExEndSet,%chr)
#define RegExQuantSet				"*+?"
#define RegExCheckQuantSet(%chr)	$FIND($$$RegExQuantSet,%chr)




#define RegExPTCHR			1
#define RegExPTSTAR			2
#define RegExPTQUESTION		3
#define RegExPTALTER		4
#define RegExPTCONCAT		5
#define RegExPTRANGE		6
#define RegExPTPLUS			7
#define RegExPTCONCATNUM	8
#define RegExPTANY			9


#define RegExPTPeek(%str,%ptr)			$e(%str,%ptr+1)
#define RegExPTPop(%ptr)				set %ptr=%ptr+1
#define RegExPTPopNbr(%str,%ptr,%nbr)	while($isvalidnum($e(%str,%ptr+1))) { set %ptr=%ptr+1  set %nbr=%nbr_$e(%str,%ptr) }

#define RegExPTParseNodeType		1
#define RegExPTParseNodeData		2
#define RegExPTParseNodeLeft		3
#define RegExPTParseNodeRight		4
#define RegExPTParseNodeMin			5
#define RegExPTParseNodeMax			6
#define RegExPTParseNode(%tree,%type,%data,%left,%right,%mincount,%maxcount)	set %tree($i(%tree))=$lb(%type,%data,%left,%right,%mincount,%maxcount)
#define RegExPTParseNodeField(%node,%fld)		$list(%node,%fld)

#define RegExPTGetNode(%tree,%nodePtr,%node)	set %node=%tree(%nodePtr)


#define NFANone	0
#define NFAEps	-1

#define NFASize		1
#define NFAInitial	2
#define NFAFinal	3
#define NFAField(%nfa,%fld)		$list(%nfa,%fld)
#define NFAState(%nfa,%r,%c)	%nfa(%r,%c)
#define NFAStateSet(%nfa,%r,%c,%s)	if (%s=$$$NFANone) { k %nfa(%r,%c) } else { set %nfa(%r,%c)=%s }
#define NFAStateGet(%nfa,%r,%c,%s)	set %s=$g(%nfa(%r,%c),$$$NFANone)
#define NFAInputs(%nfa)			%nfa(0)
#define NFAInputsSet(%nfa,%v)	set %nfa(0)=%v
#define NFAInputsGet(%nfa,%v)	set %v=%nfa(0)
#define NFAInputsAdd(%nfa,%v)	if ('$LISTFIND(%nfa(0),%v)) { set %nfa(0)=%nfa(0)_$lb(%v) }
#define NFAInputsAddList(%nfa,%l,%i)	for %i=1:1:$listlength(%l) { $$$NFAInputsAdd(%nfa,$list(%l,%i)) }

#define DFAStackFromSet(%stack,%set,%v)	set %v=$o(%set(""))  while(%v'="") { set %stack($i(%stack))=%v  set %v=$o(%set(%v)) }	
#define DFAStackPop(%stack,%v)			set %v=%stack(%stack)  kill %stack(%stack)  set %stack=%stack-1
#define DFAStackPush(%stack,%v)			set %stack($i(%stack))=%v


#define DFAStart(%dfa)	$list(%dfa,1)
#define DFAFinal(%dfa)	$list(%dfa,2)
#define DFAFinalAdd(%dfa,%s)	set $list(%dfa,2)=$list(%dfa,2)_$lb(%s)

///#define DFASetHash(%s,%i,%h)	set %h=0, %i=$o(%s(""))  while (%i'="") { set %h=$zcrc(%i,7,0)  set %i=$o(%s(%i)) }
///#define DFASetHash(%s,%i,%h)	set %h=0, %i=$o(%s(""))  while (%i'="") { set %h=$System.Encryption.SHAHash(512,%i)  set %i=$o(%s(%i)) }
///#define DFASetHash(%s,%i,%h)	set %i=$o(%s(""),-1)  set %h=$System.Encryption.SHAHash(512,%i)
///#define DFASetHash(%s,%i,%h)	set %i=$o(%s(""))  set %h=$System.Encryption.SHAHash(512,%i)
#define DFASetHash(%s,%i,%h) set %i=$o(%s(""),-1) set %h=%i


#define DFASetAdd(%s,%v)		set %s(%v)=""
#define DFASetContains(%s,%v)	$data(%s(%v))

#define DFASetSetAdd(%s,%v,%x)		set %x=$i(%s) merge %s(%x)=%v

#define DFAHashSetAdd(%s,%h,%v)	set %s(%h)=%v
#define DFAHashSetGet(%s,%h,%v) set %v=%s(%h)
