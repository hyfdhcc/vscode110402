ROUTINE LANGF11ovr [Type=INC]
#;
#include LANG11
#; 
#;===============================Maintenance==========================
#;
#; SOH296 12/03/11 Steven Hobbs, Change IFS() when Bool has no subcomponents
#; SOH295 12/03/11 Steven Hobbs, Fix IFS() typo: replace bad nv1 with ns1
#; SOH228  6/17/11 Steven Hobbs, Fix IFS(), especially with REUSE() parameters
#; SOH271  5/18/11 Steven Hobbs, Add MODSZ(), dyn array modulo no zero error
#; SOH269  5/10/11 Steven Hobbs, Fix PWRS() when 2nd operand contains 0
#; SOH266  4/29/11 Steven Hobbs, Add DIVSZ(), dyn array divide no zero error
#; SOH249  1/07/11 Steven Hobbs, Default PWRS() 2nd parameter values to 1.
#; SOH248  1/07/11 Steven Hobbs, Add PWRS() implemented by P0,P1,P2&P3 
#; SOH232 10/25/10 Steven Hobbs, Fix MVB DIVS() divide-by-0 error
#; CDS1672 2/23/10 Chuck Sorenson, messages to mv.log instead of terminal
#; SJ2101  8/24/06 Scott Jones, added support for more REUSE codes
#; SJ2100  8/24/06 Scott Jones, added support for IFS
#; SJ2073  8/14/06 Scott Jones, implement more REUSE codes
#; SJ1972  5/29/06 Scott Jones, removed old code
#; DAS792  6/09/05 Diane Steidler, don't kill VOC entry before updating
#; DAS787  6/02/05 Diane Steidler, fix another <undefined>
#; DAS785  5/26/05 Diane Steidler, fix <undefined> in routine compile
#; DAS782  5/13/05 Diane Steidler, use VOC macros to access VOC
#; SJ1726  5/09/05 Scott Jones, remove LoadFiles (specific to Dave's exporter)
#; SJ1706  3/26/05 Scott Jones, change compilation behavior, save MVI always
#; SJ1669  1/16/05 Scott Jones, use new MVC[RT] command
#; SJ1663  1/13/05 Scott Jones, use new optimizations
#; SJ1640 12/06/04 Scott Jones, clean up calls to set up classes
#; DAS709 12/04/04 Diane Steidler, fix <UNDEFINED> errors
#; DAS699 12/01/04 Diane Steidler, changes to importer
#; SJ1626 12/01/04 Scott Jones, fix class/table name handling
#; DAS693 11/28/04 Diane Steidler, fix import
#; SJ1610 11/12/04 Scott Jones, generate child classes
#; SJ1609 11/10/04 Scott Jones, fix problems with I-type expression parsing
#; SJ1608 11/06/04 Scott Jones, fix bugs in LFT1320
#;LFT1320 11/04/04 Laura Tillem, %LANG -> LANG
#; SJ1607 11/02/04 Scott Jones, reorganize for more space in %MVCMD
#; LRS834 10/06/04 Lee Smith, correct DIVS, rewrite dynamic array math
#;                 functions and include warning messages for invalid
#;                 number and divide by zero. Commonized REUSE function
#;                 code to save space in glue code routine, at some cost
#;                 to performance.
#; SJ1530  6/10/04 Scott Jones, use new token calls to gluecode
#; SJ1476 04/01/04 Scott Jones, moved code back to %LANGF11
#; DAS550 03/25/04 Diane Steidler, FIELDSTORE
#; DAS549 03/25/04 Diane Steidler, move some code from %LANGF11
#; LRS765 03/23/04 Lee Smith, created this module, with REUSE options
#;                 for various functions
#;=============================End Maintenance========================
#;
#;	Macros for Dynamic Array handling functions
#;
#; RES  - For setting the current element of the result
#define	RES	$MV(res,f,v,s)
#;
#; SUB1 - For current element of 1st array in a double array function
#define	SUB1	$MV(val1,1,1,s)
#;
#; SUB2 - For current element of 2nd array in a double array function
#define	SUB2	$MV(val2,1,1,s)
#;
#; FUNLP2(nam,val) - Declare double array function and initialize result
#define	FUNLP2(%nam,%val)					##continue
%nam(arr1,arr2) [] PUBLIC { Set res=%val
#;
#; INILP2(val) - This initializes the result to val and starts a double array
#;		 loop
#define	INILP2(%val)						##continue
 Set res=%val,nf1=$L(arr1,$$$MVam),nf2=$L(arr2,$$$MVam)		##continue
 For f=1:1:$S(nf1>nf2:nf1,1:nf2) {				##continue
    Set fld1=$MV(arr1,f),fld2=$MV(arr2,f)			##continue
    Set nv1=$L(fld1,$$$MVvm),nv2=$L(fld2,$$$MVvm)		##continue
    For v=1:1:$S(nv1>nv2:nv1,1:nv2) {				##continue
       Set val1=$MV(fld1,1,v),val2=$MV(fld2,1,v)		##continue
       Set ns1=$L(val1,$$$MVsm),ns2=$L(val2,$$$MVsm)		##continue
       For s=1:1:$S(ns1>ns2:ns1,1:ns2) {
#;
#; BEGLP2(nam) - This declares a double array function
#define	BEGLP2(%nam)						##continue
%nam(arr1,arr2) [] PUBLIC { $$$INILP2("")
#;
#; ENDLP - Declares the end of the loops and of the function
#define	ENDLP	}}} Quit res }
#;
#; Macros that control double array and REUSE function loops.
#;	<func>0(array1,array2)
#;	<func>1(REUSE(array1),array2)
#;	<func>2(array1,REUSE(array2))
#;	<func>3(REUSE(array1),REUSE(array2))
#;
#; FUNLP2R  - Declare double array function and initialize result
#; FUNLP2RC  - Declare double array function that has a conversion
#;	argument and initialize result
#;
#; INILP2R  - Start of the primary work loop
#;			For defined items at each level
#;
#; SUBLP2RA - End of the primary loop, start of the subvalue loop
#;			For number of defined subvalues in arg1 < arg2
#;
#; SUBLP2RB - End of the primary loop, start of the subvalue loop
#;			For number of defined subvalues in arg1 > arg2
#;
#; VALLP2RA - End of the subvalue loop, start of the value loop
#;			For number of defined values in arg1 < arg2
#;
#; VALLP2RB - End of the subvalue loop, start of the value loop
#;			For number of defined values in arg1 > arg2
#;
#; FLDLP2RA - End of the value loop, start of the field loop
#;			For number of defined fields in arg1 < arg2
#;
#; FLDLP2RB - End of the value loop, start of the field loop
#;			For number of defined fields in arg1 > arg2
#;
#; ENDLP2R  - End of all work loops
#;
#define	FUNLP2R(%nm0,%nm1,%nm2,%nm3,%nam,%x1,%x2,%val)		##continue
%nm0(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,0,0) }	##continue
%nm1(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,1,0) }	##continue
%nm2(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,0,1) }	##continue
%nm3(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,1,1) }	##continue
%nam(arr1,arr2,%x1,%x2) [] PUBLIC { Set res=%val
#;
#define	FUNLP2RC(%nm0,%nm1,%nm2,%nm3,%nam,%x1,%x2,%val)		##continue
%nm0(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,0,0,0) }	##continue
%nm1(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,1,0,0) }	##continue
%nm2(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,0,1,0) }	##continue
%nm3(arr1,arr2) [] PUBLIC { Quit $$%nam(arr1,arr2,1,1,0) }	##continue
%nam(arr1,arr2,%x1,%x2,cvt) [] PUBLIC { Set res=%val
#;
#define	INILP2R							##continue
 Set nf1=$L(arr1,$$$MVam),nf2=$L(arr2,$$$MVam)			##continue
 For f=1:1:$S(nf1<nf2:nf1,1:nf2) {				##continue
    Set fld1=$MV(arr1,f),fld2=$MV(arr2,f)			##continue
    Set nv1=$L(fld1,$$$MVvm),nv2=$L(fld2,$$$MVvm)		##continue
    For v=1:1:$S(nv1<nv2:nv1,1:nv2) {				##continue
       Set val1=$MV(fld1,1,v),val2=$MV(fld2,1,v)		##continue
       Set ns1=$L(val1,$$$MVsm),ns2=$L(val2,$$$MVsm)		##continue
       For s=1:1:$S(ns1<ns2:ns1,1:ns2) {
#;
#define	SUBLP2RA						##continue
       }							##continue
       If ns1<ns2 {						##continue
          For s=s+1:1:ns2 {
#;
#define	SUBLP2RB						##continue
          }							##continue
       } ElseIf ns1>ns2 {					##continue
          For s=s+1:1:ns1 {
#;
#define	VALLP2RA						##continue
    }  }  }							##continue
    If nv1<nv2 {						##continue
       For v=v+1:1:nv2 {					##continue
          Set val2=$MV(fld2,1,v)				##continue
          For s=1:1:$L(val2,$$$MVsm) {
#;
#define	VALLP2RB						##continue
       }  }							##continue
    } ElseIf nv1>nv2 {						##continue
       For v=v+1:1:nv1 {					##continue
          Set val1=$MV(fld1,1,v)				##continue
          For s=1:1:$L(val1,$$$MVsm) {
#;
#define	FLDLP2RA						##continue
 }  }  }  }							##continue
 If nf1<nf2 {							##continue
    For f=f+1:1:nf2 {						##continue
       Set fld2=$MV(arr2,f)					##continue
       For v=1:1:$L(fld2,$$$MVvm) {				##continue
          Set val2=$MV(fld2,1,v)				##continue
          For s=1:1:$L(val2,$$$MVsm) {
#;
#define	FLDLP2RB						##continue
    }  }  }							##continue
 } ElseIf nf1>nf2 {						##continue
    For f=f+1:1:nf1 {						##continue
       Set fld1=$MV(arr1,f)					##continue
       For v=1:1:$L(fld1,$$$MVvm) {				##continue
          Set val1=$MV(fld1,1,v)				##continue
          For s=1:1:$L(val1,$$$MVsm) {
#;
#define	ENDLP2R							##continue
 } $$$ENDLP
#;
#define	GETOPER(%x,%y)	Set %x=%y Do:'$Isvalidnum(%x) invn(.%x)
#define	GETOPER1(%x,%y)	Set %x=%y Do:'$Isvalidnum(%x) invn1(.%x)
#define	GETOPERC(%x,%y)	If cvt { Set %x=$MVCVTNUM(%y,cvt) } else { Set %x=%y Do:'$Isvalidnum(%x) invn(.%x) }
#;
#;--------------------------------------------------------------------
#; Routine:  a0 - ANDS(array1,array2)
#;           a1 - ANDS(REUSE(array1),array2)
#;           a2 - ANDS(array1,REUSE(array2))
#;           a3 - ANDS(REUSE(array1),REUSE(array2))
#; Purpose:  AND two dynamic arrays
#; Return:   The resultant dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(a0,a1,a2,a3,ands,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=sub1&sub2
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1&sub2,1:0)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1&sub2,1:0)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1&sub2,1:0)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1&sub2,1:0)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1&sub2,1:0)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1&sub2,1:0)
$$$ENDLP2R
#;--------------------------------------------------------------------
#; Routine:  o0 - ORS(array1,array2)
#;           o1 - ORS(REUSE(array1),array2)
#;           o2 - ORS(array1,REUSE(array2))
#;           o3 - ORS(REUSE(array1),REUSE(array2))
#; Purpose:  OR two dynamic arrays
#; Return:   The resultant dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(o0,o1,o2,o3,ors,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=sub1!sub2
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1!sub2,1:''sub2)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1!sub2,1:''sub1)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1!sub2,1:''sub2)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1!sub2,1:''sub1)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1!sub2,1:''sub2)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1!sub2,1:''sub1)
$$$ENDLP2R
#;--------------------------------------------------------------------
#; General routine for numeric comparison
#; The flag argument has several fields with these masks:
#; 0x03 = operation:
#;        0 = EQS - Equal
#;        1 = LTS - Less than
#;        2 = GTS - Greater than
#; 0x04 = negate the operation:
#;        1 changes operation to NES, GES, LES
#; 0x18 = REUSE
#;        1 = REUSE(array1)
#;        2 = REUSE(array2)
#; 0x60 = conversion mode
#;        1 = MV_CONVERT
#;        2 = UNIV_CONVERT
#;--------------------------------------------------------------------
N9(arr1,arr2,f) [] PUBLIC {
	Set r1=$ZBOOLEAN(f,8,1),r2=$ZBOOLEAN(f,16,1),cvt=$ZBOOLEAN(f,96,1)
	Set:cvt cvt=$S($ZBOOLEAN(cvt,64,1):$$$MVCVTNullIsZero+$$$MVCVTNonNumMsg+$$$MVCVTUvWhitespace,1:$$$MVCVTNullIsZero+$$$MVCVTNonNumMsg)
	Quit $Case($ZBOOLEAN(f,7,1),
		0:$$eqs(arr1,arr2,r1,r2,cvt),
		1:$$lts(arr1,arr2,r1,r2,cvt),
		2:$$gts(arr1,arr2,r1,r2,cvt),
		3:0,  // can't happen
		4:$$nes(arr1,arr2,r1,r2,cvt),
		5:$$ges(arr1,arr2,r1,r2,cvt),
		6:$$les(arr1,arr2,r1,r2,cvt),
		7:0)  // can't happen
}
#;--------------------------------------------------------------------
#; Routine:  EQS
#; Syntax:   EQS(array1,array2)
#; Purpose:  Generate dynamic array with the result of comparing
#;           the corresponding values of the dynamic arrays
#; Return:   Dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2RC(E0,E1,E2,E3,eqs,x1,x2,"")
$$$INILP2R
        $$$GETOPERC(sub1,$$$SUB1) $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=(sub1=sub2)
$$$SUBLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1=sub2,1:sub2="")
$$$SUBLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1=sub2,1:sub1="")
$$$VALLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1=sub2,1:sub2="")
$$$VALLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1=sub2,1:sub1="")
$$$FLDLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1=sub2,1:sub2="")
$$$FLDLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1=sub2,1:sub1="")
$$$ENDLP2R
#;--------------------------------------------------------------------
#; Routine:  NES
#; Syntax:   NES(array1,array2)
#; Purpose:  Generate dynamic array with the result of comparing
#;           the corresponding values of the dynamic arrays
#; Return:   Dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2RC(N0,N1,N2,N3,nes,x1,x2,"")
$$$INILP2R
        $$$GETOPERC(sub1,$$$SUB1) $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=(sub1'=sub2)
$$$SUBLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'=sub2,1:sub2'="")
$$$SUBLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'=sub2,1:sub1'="")
$$$VALLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'=sub2,1:sub2'="")
$$$VALLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'=sub2,1:sub1'="")
$$$FLDLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'=sub2,1:sub2'="")
$$$FLDLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'=sub2,1:sub1'="")
$$$ENDLP2R
#;--------------------------------------------------------------------
#; Routine:  GES
#; Syntax:   GES(array1,array2)
#; Purpose:  Generate dynamic array with the result of comparing
#;           the corresponding values of the dynamic arrays
#; Return:   Dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2RC(g0,g1,g2,g3,ges,x1,x2,"")
$$$INILP2R
        $$$GETOPERC(sub1,$$$SUB1) $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=(sub1'<sub2)
$$$SUBLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'<sub2,1:sub2'<"")
$$$SUBLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'<sub2,1:sub1'<"")
$$$VALLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'<sub2,1:sub2'<"")
$$$VALLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'<sub2,1:sub1'<"")
$$$FLDLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'<sub2,1:sub2'<"")
$$$FLDLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'<sub2,1:sub1'<"")
$$$ENDLP2R
#;--------------------------------------------------------------------
#; Routine:  GTS
#; Syntax:   GTS(array1,array2)
#; Purpose:  Generate dynamic array with the result of comparing
#;           the corresponding values of the dynamic arrays
#; Return:   Dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2RC(G0,G1,G2,G3,gts,x1,x2,"")
$$$INILP2R
        $$$GETOPERC(sub1,$$$SUB1) $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=(sub1>sub2)
$$$SUBLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1>sub2,1:sub2>"")
$$$SUBLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1>sub2,1:sub1>"")
$$$VALLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1>sub2,1:sub2>"")
$$$VALLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1>sub2,1:sub1>"")
$$$FLDLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1>sub2,1:sub2>"")
$$$FLDLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1>sub2,1:sub1>"")
$$$ENDLP2R
#;--------------------------------------------------------------------
#; Routine:  LES
#; Syntax:   LES(array1,array2)
#; Purpose:  Generate dynamic array with the result of comparing
#;           the corresponding values of the dynamic arrays
#; Return:   Dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2RC(l0,l1,l2,l3,les,x1,x2,"")
$$$INILP2R
        $$$GETOPERC(sub1,$$$SUB1) $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=(sub1'>sub2)
$$$SUBLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'>sub2,1:sub2'>"")
$$$SUBLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'>sub2,1:sub1'>"")
$$$VALLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'>sub2,1:sub2'>"")
$$$VALLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'>sub2,1:sub1'>"")
$$$FLDLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1'>sub2,1:sub2'>"")
$$$FLDLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1'>sub2,1:sub1'>"")
$$$ENDLP2R
#;--------------------------------------------------------------------
#; Routine:  LTS
#; Syntax:   LTS(array1,array2)
#; Purpose:  Generate dynamic array with the result of comparing
#;           the corresponding values of the dynamic arrays
#; Return:   Dynamic array containing boolean values
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2RC(L0,L1,L2,L3,lts,x1,x2,"")
$$$INILP2R
        $$$GETOPERC(sub1,$$$SUB1) $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=(sub1<sub2)
$$$SUBLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1<sub2,1:sub2<"")
$$$SUBLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1<sub2,1:sub1<"")
$$$VALLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1<sub2,1:sub2<"")
$$$VALLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1<sub2,1:sub1<"")
$$$FLDLP2RA
        $$$GETOPERC(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1<sub2,1:sub2<"")
$$$FLDLP2RB
        $$$GETOPERC(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1<sub2,1:sub1<"")
$$$ENDLP2R
#;								#; SOH228+
#;--------------------------------------------------------------------
#; Routine:  i0 - IFS(ifarray,array1,array2)
#;           i1 - IFS(ifarray,REUSE(array1),array2)
#;           i2 - IFS(ifarray,array1,REUSE(array2))
#;           i3 - IFS(ifarray,REUSE(array1),REUSE(array2))
#; Purpose:  Select between two dynamic arrays (array1 and array2)
#; Return:   The resultant dynamic array (same shape as ifarray)
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#; Be careful:  This is a maze of twisty little For loops, all
#;	     slightly different.  Note that each "Set $$$RES="
#;	     must be inside an s loop, inside a v loop, and
#;	     inside an f loop.  In place of "Set $$$RES=" the
#;	     f-loop bypass contains "Set res="; the v-loop
#;	     bypasses contain "Set $MV(res,f)="; and the
#;	     s-loop bypasses contain "Set $MV(res,f,v)=".
#;
#;	     There is 1 bypass of all the f-loops.
#;
#;	     There are 4 f-loops;  1 f-loop contains 4 v-loops
#;				     This loop contains a bypass
#;				     of all 4 v-loops.
#;				   2 f-loops contain 2 v-loops
#;				     These loops contain a bypass
#;				     of both v-loops
#;				   1 f-loop contains 1 v-loop
#;
#;	     There are 9 v-loops;  1 v-loop contains 4 - loops
#;				     This loop contains a bypass
#;				     of all 4 s-loops
#;				   4 v-loops contain 2 s-loops
#;				     These loops contain a bypass
#;				     of both s-loops
#;				   4 v-loops contain 1 s-loop
#;
#;	     There are 16 s-loops; Each s-loop contains 1 Set $$$RES=
#;
#;	     Think how many more twisty little loops there would be
#;	     if MV BASIC dynamic arrays could have more than three
#;	     dimensions. :-)
#;
#;	     If there were 4 dimensions then how many f-loops, v-loops
#;	     s-loops and ss-loops would there be?  How would these four
#;	     kinds of loops be nested?  Where would the bypasses be?
#;--------------------------------------------------------------------
i0(ifarr,arr1,arr2) [] PUBLIC { Quit $$ifs(ifarr,arr1,arr2,0,0) }
i1(ifarr,arr1,arr2) [] PUBLIC { Quit $$ifs(ifarr,arr1,arr2,1,0) }
i2(ifarr,arr1,arr2) [] PUBLIC { Quit $$ifs(ifarr,arr1,arr2,0,1) }
i3(ifarr,arr1,arr2) [] PUBLIC { Quit $$ifs(ifarr,arr1,arr2,1,1) }
ifs(ifarr,arr1,arr2,x1,x2) [] PUBLIC { Set res=""
  Set nfif=$L(ifarr,$$$MVam)
#; Special case Boolean with no field, value or subvalue marks  #; SOH296
  if nfif=1 && ($L(ifarr,$$$MVvm)=1 && ($L(ifarr,$$$MVsm)=1)) {
    Quit $S(ifarr:arr1,1:arr2)
  }  
  Set nf1=$L(arr1,$$$MVam),nf2=$L(arr2,$$$MVam)
  For f=1:1:$S(nfif<nf1:$S(nfif<nf2:nfif,1:nf2),nf1<nf2:nf1,1:nf2) {
    Set iffld=$MV(ifarr,f),fld1=$MV(arr1,f),fld2=$MV(arr2,f)
    Set nvif=$L(iffld,$$$MVvm),nv1=$L(fld1,$$$MVvm),nv2=$L(fld2,$$$MVvm)
#; Special case Boolean field with no value or subvalue marks	#; SOH296
    if nvif=1 && ($L(iffld,$$$MVsm)=1) {
      Set $MV(res,f)=$S(iffld:fld1,1:fld2)
      Set:x1 val1=$MV(fld1,1,nv1),s=$L(val1,$$$MVsm),sub1=$$$SUB1
      Set:x2 val2=$MV(fld2,1,nv2),s=$L(val2,$$$MVsm),sub2=$$$SUB2
      goto nextfld
    }
    For v=1:1:$S(nvif<nv1:$S(nvif<nv2:nvif,1:nv2),nv1<nv2:nv1,1:nv2) {
      Set ifval=$MV(iffld,1,v),val1=$MV(fld1,1,v),val2=$MV(fld2,1,v)
      Set nsif=$L(ifval,$$$MVsm),ns1=$L(val1,$$$MVsm),ns2=$L(val2,$$$MVsm)
#; Special case Boolean value with no subvalue marks		#; SOH296
      if nsif = 1 {
        Set $MV(res,f,v) = $S(ifval:val1,1:val2)
        Set:x1 sub1=$MV(val1,1,1,ns1)
	Set:x2 sub2=$MV(val2,1,1,ns2)
        goto nextval
      }
      For s=1:1:$S(nsif<ns1:$S(nsif<ns2:nsif,1:ns2),ns1<ns2:ns1,1:ns2) {
	Set sub1=$$$SUB1,sub2=$$$SUB2,$$$RES=$S($MV(ifval,1,1,s):sub1,1:sub2)
      }
      If ns1<ns2 {
	For s=s+1:1:$S(nsif<ns2:nsif,1:ns2) {
	  Set sub2=$$$SUB2,$$$RES=$S('$MV(ifval,1,1,s):sub2,x1:sub1,1:"")
	}
      } ElseIf ns1>ns2 {
	For s=s+1:1:$S(nsif<ns1:nsif,1:ns1)  {
	  Set sub1=$$$SUB1,$$$RES=$S($MV(ifval,1,1,s):sub1,x2:sub2,1:"")
	}
      }
      For s=s+1:1:nsif {
       Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
      }
nextval
    }
    If nv1<nv2 {
      For v=v+1:1:$S(nvif<nv2:nvif,1:nv2) {
        Set val2=$MV(fld2,1,v),ifval=$MV(iffld,1,v)
	Set ns2=$L(val2,$$$MVsm),nsif=$L(ifval,$$$MVsm)
#; Special case Boolean value with no subvalue marks		#; SOH296
        if nsif = 1 {
          Set $MV(res,f,v) = $S('ifval:val2,x1:sub1,1:"")
          Set:x2 sub2=$MV(val2,1,1,ns2)
          goto nextval1
        }
	For s=1:1:$S(nsif<ns2:nsif,1:ns2) {
	  Set sub2=$$$SUB2,$$$RES=$S('$MV(ifval,1,1,s):sub2,x1:sub1,1:"")
        }
        For s=s+1:1:nsif {
          Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
	}
nextval1
      }
    } ElseIf nv1>nv2 {
      For v=v+1:1:$S(nvif<nv1:nvif,1:nv1) {
	Set val1=$MV(fld1,1,v),ifval=$MV(iffld,1,v)
        Set ns1=$L(val1,$$$MVsm),nsif=$L(ifval,$$$MVsm)
#; Special case Boolean value with no subvalue marks		#; SOH296
        if nsif = 1 {
          Set $MV(res,f,v) = $S(ifval:val1,x2:sub2,1:"")
          Set:x1 sub1=$MV(val1,1,1,ns1)
          goto nextval2
        }
	For s=1:1:$S(nsif<ns1:nsif,1:ns1) {
	  Set sub1=$$$SUB1,$$$RES=$S($MV(ifval,1,1,s):sub1,x2:sub2,1:"")
	}
        For s=s+1:1:nsif {
          Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
	}
nextval2
      }
    }
    For v=v+1:1:nvif {
      Set ifval=$MV(iffld,1,v)
      For s=1:1:$L(ifval,$$$MVsm) {
        Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
      }
    }
nextfld
  }
  If nf1<nf2 {
    For f=f+1:1:$S(nfif<nf2:nfif,1:nf2) {
      Set iffld=$MV(ifarr,f),fld2=$MV(arr2,f)
      Set nvif=$L(iffld,$$$MVvm),nv2=$L(fld2,$$$MVvm)
#; Special case Boolean field with no value or subvalue marks	#; SOH296
      if nvif=1 && ($L(iffld,$$$MVsm)=1) {
        Set $MV(res,f)=$S('iffld:fld2,x1:sub1,1:"")
        Set:x2 val2=$MV(fld2,1,nv2),s=$L(val2,$$$MVsm),sub2=$$$SUB2
        goto nextfld1
      }
      For v=1:1:$S(nvif<nv2:nvif,1:nv2) {
        Set val2=$MV(fld2,1,v),ifval=$MV(iffld,1,v)
	Set ns2=$L(val2,$$$MVsm),nsif=$L(ifval,$$$MVsm)
#; Special case Boolean value with no subvalue marks		#; SOH296
        if nsif = 1 {
          Set $MV(res,f,v) = $S('ifval:val2,x1:sub1,1:"")
          Set:x2 sub2=$MV(val2,1,1,ns2)
          goto nextval3
        }
	For s=1:1:$S(nsif<ns2:nsif,1:ns2) {
	  Set sub2=$$$SUB2,$$$RES=$S('$MV(ifval,1,1,s):sub2,x1:sub1,1:"")
        }
        For s=s+1:1:nsif {
          Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
	}
nextval3
      }
      For v=v+1:1:nvif {
	Set ifval=$MV(iffld,1,v)
	For s=1:1:$L(ifval,$$$MVsm) {
	  Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
	}
      }
nextfld1
    }
  } ElseIf nf1>nf2 {
    For f=f+1:1:$S(nfif<nf1:nfif,1:nf1) {
      Set iffld=$MV(ifarr,f),fld1=$MV(arr1,f)
      Set nvif=$L(iffld,$$$MVvm),nv1=$L(fld1,$$$MVvm)
#; Special case Boolean field with no value or subvalue marks	#; SOH296
      if nvif=1 && ($L(iffld,$$$MVsm)=1) {
        Set $MV(res,f)=$S(iffld:fld1,x2:sub2,1:"")
        Set:x1 val1=$MV(fld1,1,nv1),s=$L(val1,$$$MVsm),sub1=$$$SUB1
        goto nextfld2
      }
      For v=1:1:$S(nvif<nv1:nvif,1:nv1) {
	Set val1=$MV(fld1,1,v),ifval=$MV(iffld,1,v)
        Set ns1=$L(val1,$$$MVsm),nsif=$L(ifval,$$$MVsm)
#; Special case Boolean value with no subvalue marks		#; SOH296
        if nsif = 1 {
          Set $MV(res,f,v) = $S(ifval:val1,x2:sub2,1:"")
          Set:x1 sub1=$MV(val1,1,1,ns1)
          goto nextval4
        }
	For s=1:1:$S(nsif<ns1:nsif,1:ns1) {
	  Set sub1=$$$SUB1,$$$RES=$S($MV(ifval,1,1,s):sub1,x2:sub2,1:"")
	}
        For s=s+1:1:nsif {
          Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
	}
nextval4
      }
      For v=v+1:1:nvif {
	Set ifval=$MV(iffld,1,v)
	For s=1:1:$L(ifval,$$$MVsm) {
	  Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
	}
      }
nextfld2
    }
  }
  For f=f+1:1:nfif {
    Set iffld=$MV(ifarr,f)			    
    For v=1:1:$L(iffld,$$$MVvm) {
      Set ifval=$MV(iffld,1,v)
      For s=1:1:$L(ifval,$$$MVsm) {
        Set $$$RES=$S($MV(ifval,1,1,s):$S(x1:sub1,1:""),1:$S(x2:sub2,1:""))
      }
    }
  }
  Quit res
}
#;								#; SOH228-
#;
#;--------------------------------------------------------------------
#; Routine:  p0 - SPLICE(array1,expr,array2)
#;           p1 - SPLICE(REUSE(array1),expr,array2)
#;           p2 - SPLICE(array1,expr,REUSE(array2))
#;           p3 - SPLICE(REUSE(array1),expr,REUSE(array2))
#; Purpose:  Concatenate two dynamic arrays, with a string in between
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
p0(arr1,exp,arr2) [] PUBLIC { Quit $$splice(arr1,exp,arr2,0,0) }
p1(arr1,exp,arr2) [] PUBLIC { Quit $$splice(arr1,exp,arr2,1,0) }
p2(arr1,exp,arr2) [] PUBLIC { Quit $$splice(arr1,exp,arr2,0,1) }
p3(arr1,exp,arr2) [] PUBLIC { Quit $$splice(arr1,exp,arr2,1,1) }
splice(arr1,exp,arr2,x1,x2) [] PUBLIC { Set res=""
$$$INILP2R
        Set sub1=$$$SUB1,sub2=$$$SUB2,$$$RES=sub1_exp_sub2
$$$SUBLP2RA
        Set sub2=$$$SUB2,$$$RES=$S(x1:sub1_exp_sub2,1:exp_sub2)
$$$SUBLP2RB
        Set sub1=$$$SUB1,$$$RES=$S(x2:sub1_exp_sub2,1:sub1_exp)
$$$VALLP2RA
        Set sub2=$$$SUB2,$$$RES=$S(x1:sub1_exp_sub2,1:exp_sub2)
$$$VALLP2RB
        Set sub1=$$$SUB1,$$$RES=$S(x2:sub1_exp_sub2,1:sub1_exp)
$$$FLDLP2RA
        Set sub2=$$$SUB2,$$$RES=$S(x1:sub1_exp_sub2,1:exp_sub2)
$$$FLDLP2RB
        Set sub1=$$$SUB1,$$$RES=$S(x2:sub1_exp_sub2,1:sub1_exp)
$$$ENDLP2R
#;
invn(num) [] PUBLIC {
 If num'?." " Do mvmsg("Non-numeric used as number")
 Set num=0
}
invn1(num) [] PUBLIC {
 If num'?." " Do mvmsg("Non-numeric used as number")
 If num="" Set num=1 Else  Set num=0
}
#;
#; divz() [] PUBLIC { Do mvmsg("Division by zero") Quit 0 }
divz() [] PUBLIC {Do $$$APPERROR($$$ERDIVER)  Quit 0 }
#;
#; Write message to mv.log file
mvmsg(msg) [] PUBLIC {
   For i=$ZU(41)-5:-1:1 Set x=$ZU(41,i),rn=$P(x,"^",3),typ=$P(x,"^",1) If typ="e"||(typ="d") Quit:rn'=$ZN
   If i=1 Set rn="Unknown"
   Set:$E(rn,*-3,*)=".mvi" rn=$E(rn,1,*-4)
   Set msg=msg_" at "_$S(i=1:rn,1:$P(x,"^",2)_rn)
   If i=1 Goto wrmsg
   If $E(rn)="|" Set nsp=$P(rn,"""",2),rn=$P(rn,"|",3)
   Else  Set nsp=""
   Set rc=##class(%Studio.Debugger).MappedFromLine(rn,$E($P(x,"^",2),2,*),nsp,.map)
   If rc {
      Set src=$P(map,",",1) Set:$E(src,*-3,*)=".mvb" src=$E(src,1,*-4) Set:src'["~" src="BP~"_src
      Set msg=msg_" Source: "_$TR(src,"~"," ")_" Line: "_$P(map,",",3)
      Set acct=$P(map,",",4)
      If acct]"",acct'=nsp Set msg=msg_" Account: "_acct
   }
wrmsg ;
   Do $ZU(9,"",msg,$$$MVMSG,$$$MINFO)
}
#;
#;
#;--------------------------------------------------------------------
#; Routine:  A0 - ADDS(array1,array2)
#;           A1 - ADDS(REUSE(array1),array2)
#;           A2 - ADDS(array1,REUSE(array2))
#;           A3 - ADDS(REUSE(array1),REUSE(array2))
#; Purpose:  Add two dynamic arrays
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(A0,A1,A2,A3,adds,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=sub1+sub2
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1+sub2,1:sub2)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1+sub2,1:sub1)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1+sub2,1:sub2)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1+sub2,1:sub1)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1+sub2,1:sub2)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1+sub2,1:sub1)
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  S0 - SUBS(array1,array2)
#;           S1 - SUBS(REUSE(array1),array2)
#;           S2 - SUBS(array1,REUSE(array2))
#;           S3 - SUBS(REUSE(array1),REUSE(array2))
#; Purpose:  Subtract two dynamic arrays
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(S0,S1,S2,S3,subs,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=sub1-sub2
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1-sub2,1:-sub2)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1-sub2,1:sub1)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1-sub2,1:-sub2)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1-sub2,1:sub1)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1-sub2,1:-sub2)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1-sub2,1:sub1)
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  M0 - MULS(array1,array2)
#;           M1 - MULS(REUSE(array1),array2)
#;           M2 - MULS(array1,REUSE(array2))
#;           M3 - MULS(REUSE(array1),REUSE(array2))
#; Purpose:  Multiply two dynamic arrays
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(M0,M1,M2,M3,muls,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=sub1*sub2
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1*sub2,1:0)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1*sub2,1:0)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1*sub2,1:0)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1*sub2,1:0)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S(x1:sub1*sub2,1:0)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S(x2:sub1*sub2,1:0)
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  D0 - DIVS(array1,array2)
#;           D1 - DIVS(REUSE(array1),array2)
#;           D2 - DIVS(array1,REUSE(array2))
#;           D3 - DIVS(REUSE(array1),REUSE(array2))
#; Purpose:  Divide two dynamic arrays
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(D0,D1,D2,D3,divs,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,1:sub1/sub2)
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,'x1:0,1:sub1/sub2)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:sub1,'sub2:$$divz,1:sub1/sub2)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,'x1:0,1:sub1/sub2)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:sub1,'sub2:$$divz,1:sub1/sub2)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,'x1:0,1:sub1/sub2)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:sub1,'sub2:$$divz,1:sub1/sub2)
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  d0 - DIVSZ(array1,array2)
#;           d1 - DIVSZ(REUSE(array1),array2)
#;           d2 - DIVSZ(array1,REUSE(array2))
#;           d3 - DIVSZ(REUSE(array1),REUSE(array2))
#; Purpose:  Divide two dynamic arrays (ignore divide by zero)
#; Return:   The resultant dynamic array (zeroes for divide by zero)
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(d0,d1,d2,d3,divsz,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,1:sub1/sub2)
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,'x1:0,1:sub1/sub2)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:sub1,'sub2:0,1:sub1/sub2)
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,'x1:0,1:sub1/sub2)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:sub1,'sub2:0,1:sub1/sub2)
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,'x1:0,1:sub1/sub2)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:sub1,'sub2:0,1:sub1/sub2)
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  R0 - MODS(array1,array2)
#;           R1 - MODS(REUSE(array1),array2)
#;           R2 - MODS(array1,REUSE(array2))
#;           R3 - MODS(REUSE(array1),REUSE(array2))
#; Purpose:  Calculate the remainder from two dynamic arrays
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(R0,R1,R2,R3,mods,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,1:sub1-((sub1\sub2)*sub2))
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,'x1:0,1:sub1-((sub1\sub2)*sub2))
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:$$divz,'sub2:$$divz,1:sub1-((sub1\sub2)*sub2))
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,'x1:0,1:sub1-((sub1\sub2)*sub2))
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:$$divz,'sub2:$$divz,1:sub1-((sub1\sub2)*sub2))
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:$$divz,'x1:0,1:sub1-((sub1\sub2)*sub2))
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:$$divz,'sub2:$$divz,1:sub1-((sub1\sub2)*sub2))
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  r0 - MODSZ(array1,array2)
#;           r1 - MODSZ(REUSE(array1),array2)
#;           r2 - MODSZ(array1,REUSE(array2))
#;           r3 - MODSZ(REUSE(array1),REUSE(array2))
#; Purpose:  Calculate the remainder from two dynamic arrays
#;		(ignore divide-by-zero)
#; Return:   The resultant dynamic array (0 for x MOD 0)
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(r0,r1,r2,r3,modsz,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,1:sub1-((sub1\sub2)*sub2))
$$$SUBLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,'x1:0,1:sub1-((sub1\sub2)*sub2))
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:0,'sub2:0,1:sub1-((sub1\sub2)*sub2))
$$$VALLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,'x1:0,1:sub1-((sub1\sub2)*sub2))
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:0,'sub2:0,1:sub1-((sub1\sub2)*sub2))
$$$FLDLP2RA
        $$$GETOPER(sub2,$$$SUB2) Set $$$RES=$S('sub2:0,'x1:0,1:sub1-((sub1\sub2)*sub2))
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1) Set $$$RES=$S('x2:0,'sub2:0,1:sub1-((sub1\sub2)*sub2))
$$$ENDLP2R
#;
#;--------------------------------------------------------------------
#; Routine:  P0 - PWRS(array1,array2)				#; SOH248+
#;           P1 - PWRS(REUSE(array1),array2)
#;           P2 - PWRS(array1,REUSE(array2))
#;           P3 - PWRS(REUSE(array1),REUSE(array2))
#; Purpose:  Raise one dynamic array to the power of a 2nd dynamic array
#;	     Missing components in the 1st dynamic array default to 0
#;	     Missing components or components containing the	#; SOH249
#;	     empty string in the 2nd dynamic array default to 1	#; SOH249
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(P0,P1,P2,P3,pwrs,x1,x2,"")
$$$INILP2R
        $$$GETOPER(sub1,$$$SUB1) $$$GETOPER1(sub2,$$$SUB2) 
	Set $$$RES=sub1**sub2
$$$SUBLP2RA
        $$$GETOPER1(sub2,$$$SUB2)
	Set $$$RES=$S(x1:sub1**sub2,1:0)
$$$SUBLP2RB
        $$$GETOPER(sub1,$$$SUB1)
	Set $$$RES=$S(x2:sub1**sub2,1:sub1)
$$$VALLP2RA
        $$$GETOPER1(sub2,$$$SUB2)
	Set $$$RES=$S(x1:sub1**sub2,1:0)
$$$VALLP2RB
        $$$GETOPER(sub1,$$$SUB1)
	Set $$$RES=$S(x2:sub1**sub2,1:sub1)
$$$FLDLP2RA
        $$$GETOPER1(sub2,$$$SUB2)
	Set $$$RES=$S(x1:sub1**sub2,1:0)
$$$FLDLP2RB
        $$$GETOPER(sub1,$$$SUB1)
	Set $$$RES=$S(x2:sub1**sub2,1:sub1)
$$$ENDLP2R
#;								#; SOH248-
#;
#;--------------------------------------------------------------------
#; Routine:  c0 - CATS(array1,array2)
#;           c1 - CATS(REUSE(array1),array2)
#;           c2 - CATS(array1,REUSE(array2))
#;           c3 - CATS(REUSE(array1),REUSE(array2))
#; Purpose:  Concatenate two dynamic arrays
#; Return:   The resultant dynamic array
#; Comments: This function currently does not handle @NULL and
#;           @NULL.STR values
#;--------------------------------------------------------------------
$$$FUNLP2R(c0,c1,c2,c3,cats,x1,x2,"")
$$$INILP2R
        Set sub1=$$$SUB1,sub2=$$$SUB2,$$$RES=sub1_sub2
$$$SUBLP2RA
        Set sub2=$$$SUB2,$$$RES=$S(x1:sub1_sub2,1:sub2)
$$$SUBLP2RB
        Set sub1=$$$SUB1,$$$RES=$S(x2:sub1_sub2,1:sub1)
$$$VALLP2RA
        Set sub2=$$$SUB2,$$$RES=$S(x1:sub1_sub2,1:sub2)
$$$VALLP2RB
        Set sub1=$$$SUB1,$$$RES=$S(x2:sub1_sub2,1:sub1)
$$$FLDLP2RA
        Set $$$RES=$S(x1:sub1_$$$SUB2,1:$$$SUB2)
$$$FLDLP2RB
        Set $$$RES=$S(x2:$$$SUB1_sub2,1:$$$SUB1)
$$$ENDLP2R