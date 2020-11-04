ROUTINE LANG12 [Type=INC]
#; LANG12.INC - MV PQ/PQN PROC defines
#;
#; ===============================Maintenance==========================
#; SJ2686  2/29/12 Scott Jones, changed version #
#; SJ2659  2/14/11 Scott Jones, changed version #
#; SJ2620  7/23/10 Scott Jones, changed version #
#; SJ2608  4/14/10 Scott Jones, changed version #
#; SJ2537 10/13/08 Scott Jones, changed version #
#; SJ2529  9/10/08 Scott Jones, changed version #
#; SJ2525  9/03/08 Scott Jones, changed version #
#; SJ2504  6/12/07 Scott Jones, changed version #
#; SJ2367  3/09/07 Scott Jones, changed version #
#; SJ2356  3/09/07 Scott Jones, changed version #
#; SJ2337  3/03/07 Scott Jones, another fix to A command
#; SJ2318  2/27/07 Scott Jones, increment version #
#; SJ2310  2/25/07 Scott Jones, even more quoting enhancements
#; SJ2309  2/25/07 Scott Jones, further quoting enhancements
#; SJ2308  2/24/07 Scott Jones, improvements in emulation flag handling
#; SJ2306  2/23/07 Scott Jones, more PROC fixes
#; SJ2302  2/22/07 Scott Jones, improvements in PROC emulation
#; SJ2299  2/19/07 Scott Jones, removed QSON macro
#; SJ2287  2/07/07 Scott Jones, moved macros here, added PQN macros
#; =============================End Maintenance========================
#;
#; PROC compiler version #
#; If this doesn't match, procs will be recompiled automatically
#;
#define	MVPROCVER 13
#;
#; ----------------------------------------------------------------------
#; Macros for access PROC Input and Output buffers
#;
#define	MVPInpBuf $S($$$MVPInputSecondary:$$$MVPSIB,1:$$$MVPPIB)
#define	MVPOutBuf $S($$$MVPOutputSecondary:$$$MVPSOB,1:$$$MVPPOB)
#;
#; ----------------------------------------------------------------------
#;
#; Definitions exclusive to PQN procs
#;
#; ----------------------------------------------------------------------
#; Stacks the value of the current active input buffer
#define QNS $P($S($$$MVPInputSecondary:$E($$$MVPSIB,$$$MVPSIBPtr,*),1:$E($$$MVPPIB,$$$MVPPIBPtr,*)),$MVV(1))
#;
#; ----------------------------------------------------------------------
#; Stacks specific parameter number of current active input buffer
#define QNSN(%n) $MV($$$MVPInpBuf,%n)
#;
#; ----------------------------------------------------------------------
#; Stacks specific parameter of the currently active output buffer
#;
#define	QNSON(%n) $MV($$$MVPOutBuf,%n)
#;
#; Proc detected at TCL
#define	PQCMDRUN	 1
#; Proc detected in BASIC EXECUTE
#define	PQEXECUTERUN	 2
#; Proc call from PQ proc
#define	PQPROCCALL	 4
#; Proc transfer from PQ proc
#define	PQPROCXFER	 8
#;
#; Definitions exclusive to PQN procs
#;
#; Proc detected at TCL
#define	PQNCMDRUN	 1
#; Proc detected in BASIC EXECUTE
#define	PQNEXECUTERUN	 2
#; Proc call from PQN proc
#define	PQNPROCCALL	 4
#; Proc transfer from PQN proc
#define	PQNPROCXFER	 8
#;
#; PROC Compiler entry point in runtime
#define	PQCOMPILE	$$QC^|"%SYS"|LANGF12
#;
#;
#; Find parameter n in blank delimited buffer
#;
getparm(buf,pos) [] PUBLIC { Set:pos<2 pos=1 Set loc=1
    Goto:'$ZB($$$MVPFlags,$$$PQQUOTES,1) noq
    Set quote=$S($ZB($$$MVPFlags,$$$PQSINGLEQ,1):"'",1:"'""\"),squote=" "_quote
    #; First, we need to skip to the first non-blank character to find start
lp  While $E(buf,loc)=" " { Set loc=loc+1 } Quit:loc>$L(buf) ""
    Set prv=loc,pos=pos-1
    If quote[$E(buf,loc) {
	#; Then, find terminating quote (or end of string)
	Set loc=$F(buf,$E(buf,loc),prv+1) Set:loc loc=loc+1
    } ElseIf $ZB($$$MVPFlags,$$$PQEMBEDQ,1) {
	#; Then, find terminating blank (or end of string)
	Set loc=$F(buf," ",prv)
    } Else {
	#; Scan until blank, end of string, or quote
	While loc'>$L(buf),squote'[$E(buf,loc) { Set loc=loc+1 }
	Set loc=$S(loc>$L(buf):0,1:loc+1)
    }
    Quit:'loc $S(pos:"",1:$E(buf,prv,*)) Goto:pos lp Quit $E(buf,prv,loc-2)
#; Simple case, ignore all quotes
noq While $E(buf,loc)=" " { Set loc=loc+1 } Quit:loc>$L(buf) ""
    Set prv=loc,pos=pos-1,loc=$F(buf," ",prv)
    Quit:'loc $S(pos:"",1:$E(buf,prv,*)) Goto:pos noq Quit $E(buf,prv,loc-2)
}
#; Return start and end columns in buffer given parameter #
getpos(buf,&param,&end,&loc) [] PUBLIC { Set:param<1 param=1
    Set quote=$S($ZB($$$MVPFlags,$$$PQSINGLEQ,1):"'",$ZB($$$MVPFlags,$$$PQALLQUOTES,1):"'""\",1:""),
	squote=" "_quote,loc=1
    #; First, we need to skip to the first non-blank character to find start
lp  While $E(buf,loc)=" " { Set loc=loc+1 }
    If loc>$L(buf) Set end=loc Quit loc
    Set prv=loc,param=param-1
    If quote="" {
	#; Then, find terminating blank (or end of string)
noq	Set loc=$F(buf," ",prv)
    } ElseIf quote[$E(buf,loc) {
	#; Then, find terminating quote (or end of string)
	Set loc=$F(buf,$E(buf,loc),prv+1) Set:loc loc=loc+1
    } Else {
        Goto:$ZB($$$MVPFlags,$$$PQEMBEDQ,1) noq
	#; Scan until blank, end of string, or quote
	While loc'>$L(buf),squote'[$E(buf,loc) { Set loc=loc+1 }
	Set loc=$S(loc>$L(buf):0,1:loc+1)
    }
    If loc { Goto:param lp Set end=loc-2 Quit prv }
    If param { Set end=$L(buf)+1 Quit $L(buf)+1 }
    Set end=$L(buf) Quit prv
}
#; Return start and end columns in buffer, given column #
getcurpos(buf,loc,&end) [] PUBLIC {
    Set quote=$S($ZB($$$MVPFlags,$$$PQSINGLEQ,1):"'",$ZB($$$MVPFlags,$$$PQALLQUOTES,1):"'""\",1:"")
    #; First, we need to skip to the first non-blank character to find start
    While $E(buf,loc)=" " { Set loc=loc+1 }
    If loc>$L(buf) Set end=loc Quit loc
    Set prv=loc
    If quote="" {
	#; Then, find terminating blank (or end of string)
noq	Set loc=$F(buf," ",prv),end=$S(loc:loc-2,1:$L(buf))
    } ElseIf quote[$E(buf,loc) {
	#; Then, find terminating quote (or end of string)
	Set loc=$F(buf,$E(buf,loc),prv+1),end=$S(loc:loc-1,1:$L(buf))
    } Else {
	Goto:$ZB($$$MVPFlags,$$$PQEMBEDQ,1) noq
	#; Scan until blank, end of string, or quote
	Set quote=" "_quote
	While loc'>$L(buf),quote'[$E(buf,loc) { Set loc=loc+1 }
	Set end=$S(loc>$L(buf):$L(buf),1:loc-1)
    }
    Quit prv
}
#; Unsupported PROC error
#define	ProcErrUNSUPP	274
#;
#; Proc User exit, entry points
#;
#define	PUE032LOGOFF	0
#define	PUE070MATCH	0
#define	PUE190REVPOL	0
#define	PUE191LOCK9	0
#define PUE191ULOCK9	1
#define PUE192OFMT	0
#define	PUE193MV	0 
#define	PUE195SAVEL	0
#define	PUE195READL	1
#define	PUE1A2CGOTO	0
#define PUE1A2PAD0      1
#define	PUE1A6CSR	0
#define	PUE1ADRETVAL	0
#;
#; ICONV/OCONV user exit, entry points
#;
#define CUE042STARME	0
#define CUE042CURNS	1
#define CUE042CURACC	2
#define CUE042HTODATE	3
#define CUE042USERCHK	4
#define CUE0BBWHO	5
#define	CUE0BBUSER	6
#define CUE004TERM	0
#define	CUE016SPROGS	0
#define	CUE060CRYPT	3
#define	CUE07ASLEEP	4
#define	CUE0E0OPTS	1
#define	CUE0E0CPRMS	2
#define	CUE0E0LSTACTV	3
#define	CUE0E0ECHOON	7
#define	CUE0E0ECHOOFF	8
#define CUE1A4TRIMPAD	3
#define CUE1A9ZAPSPC	0
#define CUE1A9ZAPCHR	1
#define CUE1A9ZAPCTRL	2
#define CUE1A9CNVCHR	3
#define	CUE1AAREVS	5
#define	CUE1ACZAPDUP	3
#define	CUE2DFZAPNASC	1
#define	CUE2E7ZAPCTRL	0
#define CUE47FPADSPC	0
#define CUE47FPUSER	2
#define CUE47FBKOFF	4
#define CUE47FBKON	5
#define CUEDBFCRPT	0