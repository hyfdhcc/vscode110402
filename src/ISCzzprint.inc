ROUTINE ISCzzprint [Type=INC]
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef zzprint
#define zzprint
 ;+
 ; ZZPRINT command
 ;-
ZZPRINT(x,y,z) public { Ztrap:'$D(x) $$$APPERROR($$$ERSYNTX) Set $ZT="zzderr"
	Set ref=$zstrip($piece(x,":"),"<>W"),before=$zstrip($piece(x,":",2),"<>W"),after=$zstrip($piece(x,":",3),"<>W"),type=$length(x,":")
	If $data(y) Set before=y,type=2
	If $data(z) Set after=z,type=3
	If $extract(ref)="*" {
		Set stack=$piece(ref,"*-",2)
		If stack="" Set stack=0
		Set ref=$piece($zu(41,$zu(41)-3-stack),"^",2,3)
	} ElseIf $zconvert($extract(ref,1,3),"l")="$ze" {
		Set ref=$piece($piece($zerror,">",2)," ")
	} ElseIf $extract(ref)="<",ref[">" {
		Set ref=$piece($piece(ref,">",2)," ")
	}
	If ref'["^" {
		Set rtn=ref,lbl=""
		If type=1 {
			Set type=3
		}
	} Else {
		Set rtn=$piece(ref,"^",2),lbl=$piece(ref,"^")
	}
	Set offset=$piece(lbl,"+",2),lbl=$piece(lbl,"+"),ns=""
	If rtn["|" Set ns=$piece(rtn,"|",2),rtn=$piece(rtn,"|",3),ns=$zstrip(ns,"<>","""")
	If rtn=""||('$data(^|ns|ROUTINE(rtn,0))) Write "<NOROUTINE>"_$select(rtn'="":" *"_rtn,1:""),! Quit
	Set pos=0
	If lbl'="" {
		For lineno=1:1:$get(^|ns|ROUTINE(rtn,0,0)) {
			Set line=$get(^(lineno))
			Set line=$piece($piece($piece(line,"(")," "),$char(9))
			If line=lbl Set pos=lineno Quit
		}
		If pos=0 Write "<NOLABEL> *"_lbl,! Quit
	}
	Set pos=pos+offset,start=pos,end=pos
	If type>1 Set start=$select(before="":1,1:pos-before)
	If type>2 Set end=$select(after="":$get(^|ns|ROUTINE(rtn,0,0)),1:pos+after)
	If start<1 Set start=1
	If end>$get(^|ns|ROUTINE(rtn,0,0)) Set end=$get(^|ns|ROUTINE(rtn,0,0))
	For lineno=start:1:end {
		Set line=$get(^|ns|ROUTINE(rtn,0,lineno))
		Write line,!
	}
	Quit
zzderr Set $ZT="" Ztrap $$$APPERROR($$$LASTERROR)
}
#endif