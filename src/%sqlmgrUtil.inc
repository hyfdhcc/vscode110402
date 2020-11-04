ROUTINE %sqlmgrUtil [Type=INC]
%sqlmgrUtil	; SQL Manager Utilities

#define MaxLocalLength $zutil(96,39)

#; Parse CSV string into array - Used by SQLManager Import
#;	strea
parseString(in,del,quote,return,continue,stream=0,term="") public {
	set keepchar=$case(del,$c(9):$c(9),$c(32):$c(32),$c(160):$c(160),:"")	// DPV3021 Don't strip Space, Tab, or $c(160) if they are used as delimiters
	set quote=$get(quote,""""),out="",lquote=$length(quote),ldel=$length(del)
	if $get(continue)'="" {
		if continue=$c(0) set out="" goto afterkill	// special case where last read ended with the del and not whole line was read
		if continue=$c(1) set out="" goto hquote	// special case where last read ended with the quote char from the next record and not whole line was read
		set out=continue
		if quote=""||($extract(out,1,lquote)'=quote) goto afterkill	// the previously read recordpart was not quoted
		set out=$e(out,1+lquote,*),in=quote_in goto hquote	// previously read record was quoted, remove quote from beginning of out, add one to beginning on in, process
	}
	kill return
afterkill	//
	if quote=""||(in'[quote) {
		set ofind=1
		for  {
			set find=$find(in,del,ofind) quit:find=0
			set value=out_$extract(in,ofind,find-ldel-1)
			set:$zstrip(value,"<>W",,keepchar)'="" value=$zstrip(value,"<>W",,keepchar)	// only strip leading/trailing whitespace of the value is something other than just whitespace
			set return($increment(return))=value,ofind=find,continue="",out=""
		}
		if term="",$l(in)=32767 { set continue=out_$extract(in,ofind,*) QUIT 0 }	// we are at the end of the read, but not the end of the line
		set value=out_$extract(in,ofind,*)
		set:$zstrip(value,"<>W",,keepchar)'="" value=$zstrip(value,"<>W",,keepchar)	// only strip leading/trailing whitespace of the value is something other than just whitespace
		set return($increment(return))=value,continue="",out=""	// Last record for this line in the file
		QUIT 1
	}
	set in=$zstrip(in,"<W",,keepchar)
hloop	goto:$extract(in,1,ldel)=del hdel
	if in="" {
		if term="" { set continue=$s(recordquoted:quote,1:"")_out QUIT 0 }	// we are at the end of the read, but not the end of the line
		else { goto hexit }
	}
	if $extract(in,1,lquote)=quote set recordquoted=1 goto hquote
	set recordquoted=0
hdefault	
	set stuff=$piece(in,del)
	if stream { do out.Write($zstrip(stuff,">W",,keepchar)) } else { set out=out_$s(in[del:$zstrip(stuff,">W",,keepchar),1:stuff) }
	set in=$extract(in,$length(stuff)+1,*)
	Goto hloop
	
hquote	set stuff=$find(in,quote,lquote+1) 
	if stuff=0 {
		if stream {
			do out.Write(in_term)
			set continue=out
			QUIT 0
		}
		if in=quote,out="",term="" set continue=$c(1) QUIT 0 	// not all of line read in and we happened to read the quote char from the next string
		if $e(in,1,lquote)=quote { set continue=quote_out_$e(in,1+lquote,*) }
		else { set continue=out_in }
		if $length(continue)>($$$MaxLocalLength*.9) {
			set tmpstream = ##class(%Stream.GlobalBinary).%New()
			set stream=1
			do tmpstream.Write(continue_term)
			set continue=tmpstream
		}
		QUIT 0
	}
	if stream { do out.Write($extract(in,lquote+1,stuff-lquote-1)) } 
	else      { set out=out_$extract(in,lquote+1,stuff-lquote-1) }
	set in=$extract(in,stuff,*),continue="",recordquoted=0
	if $extract(in,1,lquote)=quote { 
		if stream { do out.Write(quote) } else { set out=out_quote } 
		set recordquoted=1
		Goto hquote
	} 
	else { Goto hdefault }
hdel	set return($increment(return))=out,out="",stream=0,in=$zstrip($extract(in,ldel+1,*),"<W",,keepchar) 
	if in="",term="" set continue=$c(0) QUIT 0	// special case - last char read was del and this was not the end of the line in the file
	Goto hloop
hexit	set return($increment(return))=out,continue="",stream=0 QUIT 1
}