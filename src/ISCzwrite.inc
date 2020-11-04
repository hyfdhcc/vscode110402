ROUTINE ISCzwrite [Type=INC]
#;/*=======================Maintenance=============================*/
#;CDS2384 5/07/14, Chuck Sorenson, ZWRITE expression
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
#;CDS2011 9/08/11, Chuck Sorenson, dump object attributes
#;CDS957  1/30/07, Chuck Sorenson, keep extended references
#;STC1048 8/16/06, Steve Clay, Fix display of global data 
#;STC1002 6/27/06, Steve Clay: Format data using %r style formatting
#;HYY1163 9/30/05, Huayong Yang: fix parsing of global ref containing '('
#;PWC807  2/05/04, Peter Cudhea: Lose privileges before looking at user's
#;                 request. 
#;SJ1360  5/02/02, Scott Jones: updated
#;SJ1280 12/10/00, Scott Jones: zwrite.INC creation
#;/*=====================End Maintenance============================*/
  
#if 0   /*======================Documentation=======================*/
 ;+
 ; IMPORTANT:    Routines that handle commands must preserve
 ;               $TEST if the command being emulated does not
 ;               update $TEST!
 ;-
#endif  /*====================End Documentation=====================*/
  
#ifndef ISCzwrite
#define ISCzwrite
 ; ZWRALL command
 ; this glue code is called for argumentless WRITE when i/o redirection is active via $ZU(82,12,1)
ZWRALL() public {
 Try {
  Set nam="",nam=$o(@nam)
  Set fmtflag=$case($ZU(96,14),0:1,:3)
  While (nam'="") {
     Write:($Data(@nam,val)#2) $$FormatName^%qcr(nam,fmtflag)_"="_$$outval,!
     Set ref=nam
     For  {
       Set ref=$Query(@ref,1,val) Quit:ref'[nam
       Write $$FormatName^%qcr(ref,fmtflag)_"="_$$outval,!
     }
     Set nam=$o(@nam)
  }
 } catch { Do $$$APPERROR($$$LASTERROR) }
 Quit
outval() Quit $Select(val="":"""""",$isobject(val):"<OBJECT REFERENCE>["_val_"]",1:$$Format^%qcr(val,fmtflag))
}
 ; ZWRITE command
 ;
 ; Arguments
 ;
 ;   ref = ZWRITE variable reference
 ;   %   = when the variable to be displayed is a local variable
 ;         it is passed by reference through this parameter
 ;-
ZWRITE(ref,&%,flg) public {
 #; FormatName flag bit values: 1 - Format string, 2 - Highlight String
 #; don't highlight if output device is SEQ file or TCP/IP device
 Set fmtflag=$case($ZU(96,14),0:1,:3)
 If $io["|TCP|" Set fmtflag=1
 Try {
   If $Get(flg)=1 {
     #; Just display an expression
     Set val=$Get(ref) Write $$outval,!
     If $IsObject(val)>0 Do DumpObject^%occRun(val)
     Quit
   }
   If $D(%) {
     #; HYY1163: OK to use "(" here, as ref is a local variable
     Set nam=$Piece(ref,"("),$Extract(ref,1,$Length(nam))="%"
     Set d=$Data(@ref,val)
     If d#2 {
       Write $$Quote^%qcr(nam_$Extract(ref,2,*),1,,fmtflag)_"="_$$outval,!
       If $IsObject(val)>0 Do DumpObject^%occRun(val)
     }
     Set nxt=ref Set:$Length(ref)'=1 $Extract(ref,$Length(ref))=","
     For  {
       Set nxt=$Query(@nxt,1,val)
       Quit:nxt'[ref  
       Write $$Quote^%qcr(nam_$Extract(nxt,2,*),1,,fmtflag)_"="_$$outval,!
     }
   } Else {
     Set d=$Data(@ref,val)
     #; CDS957 make sure extended references are kept
     Set flag7=$ZU(68,7,0)
     Write:d#2 $$Quote^%qcr(ref,1,,fmtflag)_"="_$$outval,!
     #; To test whether ref contains subscripts, use $ql(ref) instead of ref["(",
     #; as the latter would return a false positive if ref contains a directory
     #; whose path contains '('.     HYY1163
     Set nxt=ref Set:$QLength(ref) $Extract(ref,$Length(ref))=","
     For  {
       Set nxt=$Query(@nxt,1,val)
       Quit:nxt'[ref  
       Write $$Quote^%qcr(nxt,1,,fmtflag)_"="_$$outval,!
     }
     Do $ZU(68,7,flag7)
   }
 } catch { Do:$D(flag7) $ZU(68,7,flag7) Do $$$APPERROR($$$LASTERROR) }
 Quit
outval() Quit $Select(val="":"""""",$isobject(val):"<OBJECT REFERENCE>["_val_"]",1:$$Quote^%qcr(val,,,fmtflag))
}
ZZWRITE(%val) public {
	ZW %val
}
#endif