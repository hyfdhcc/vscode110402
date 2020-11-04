ROUTINE LANG11 [Type=INC]
#; LANG11.INC - MVBasic defines
#; 
#; ===============================Maintenance==========================
#; SOH449  9/29/14 Steven Hobbs, Reorder BREAK/SETs in $$$SpoolerProtectStart 
#; JPL1644 5/22/14 John Lambert, correct defn of MVBusedefterminal
#; SOH409 12/19/13 Steven Hobbs, SpoolerProtect??? disables but does not
#;				  dismiss control-C signals
#; SOH361 10/11/12 Steven Hobbs, Add FileVarTriggerOperations
#; SOH270  5/16/12 Steven HOBBS, Add MVBTransactionStart
#; SOH264  4/25/11 Steven Hobbs, add *MVREMLCK* macros
#; SOH235 11/09/10 Steven Hobbs, add MVEmuSYSTEMPHANTOMNAME
#; SJ2624  7/27/10 Scott Jones, move flags for jBASE
#; SJ2620  7/23/10 Scott Jones, add flags for P command
#; JPL1233 4/25/10 john Lambert, add emulation flags 143,144 and 145
#; SJ2614  4/25/10 Scott Jones, add flag for not expanding ;
#; SJ2604  1/24/10 Scott Jones, add flag for PROCWRITE handling
#; SJ2569  5/22/09 Scott Jones, use oref.property instead of slots to reference
#;		   file and select variable members
#; CDS1538 4/06/09 Chuck Sorenson, adjust slot numbers up by one
#; SJ2554  1/26/09 Scott Jones, added definitions for chained procs
#; SJ2552  1/24/09 Scott Jones, add flag for select list retention in procs
#; CDS1464 11/13/08 Chuck Sorenson, add Universe SYSTEM(11)
#; SJ2539 10/15/08 Scott Jones, fix D3 H < RETURN handling
#; GGC218  8/07/08 Greg Cooper, Make MV spooler conduct emulation dependent
#; CDS1327 3/06/08 Chuck Sorenson, support reselect of dynamic arrays
#; CDS1297 2/08/08 Chuck Sorenson, support FSELECT
#; CDS1293 2/06/08 Chuck Sorenson, support NO.RESELECT
#; SJ2412 10/25/07 Scott Jones, updated macros
#; GGC159 10/11/07 Greg Cooper, Move MV routines for security reasons
#; CDS1191 9/25/07 Chuck Sorenson, support ATKEY record id
#; GGC149  9/04/07 Greg Cooper, Add the TANDEM command
#; GGC146  8/22/07 Greg Cooper, Correct use of PROMPT string
#; GGC145  8/15/08 Greg Cooper, Add runtime support for INPUTERR
#; CDS1132 8/08/07 Chuck Sorenson, add STACKCOMMON
#; GGC142  8/02/07 Greg Cooper, Default MV spooler table
#; GGC138  7/30/07 Greg Cooper, Add new terminal independence codes
#; GGC137  7/27/07 Greg Cooper, Re-engineer multi value terminal output 
#; GGC133  7/05/07 Greg Cooper, add more MVEmuFLAGxxx values for BREAK key emulation
#; CDS1107 7/02/07 Chuck Sorenson, COMMON fixes
#; CDS1106 6/27/07 Chuck Sorenson, D3 SYSTEM(33) is call stack
#; CDS1069 6/15/07 Chuck Sorenson, remap Unidata SYSTEM(33)
#; GGC120  6/06/07 Greg Cooper, Add new SYSTEM() functions for D3
#; GGC114  5/25/07 Greg Cooper, Add auxilliary printing to MV spooler 
#; CDS1056 5/11/07 Chuck Sorenson, apply update for GGC105
#; GGC102  4/27/07 Greg Cooper, Make terminfo definitions the defacto way of
#;		   controlling terminals
#; SJ2393  4/26/07 Scott Jones, add $$$MVBexitcode
#; GGC100  4/20/07 Greg Cooper, Add SYSTEM(1054) and SYSTEM(1055) 
#; GGC099  4/20/07 Greg Cooper, Add and move SYSTEM() functions
#; GGC091  4/11/07 Greg Cooper, General multi value terminal independence
#;		   enhancements
#; GGC088  3/22/07 Greg Cooper, Add terminal independence to the Multi Value
#;		   product 
#; SJ2367  3/16/07 Scott Jones, flag for jBASE A not moving to next param
#; SJ2363  3/15/07 Scott Jones, flags for jBASE buffer extension in F command
#; GGC083  3/15/07 Greg Cooper, Move mvv variables for better use of resourcs 
#; SJ2362  3/15/07 Scott Jones, flags for handling capture differences
#; SJ2357  3/14/07 Scott Jones, flags for leading/trailing delimiters
#; SJ2356  3/09/07 Scott Jones, add more flags
#; SJ2350  3/07/07 Scott Jones, file buffer support
#; SJ2321  2/28/07 Scott Jones, add PROC MARK
#; SJ2310  2/25/07 Scott Jones, more quoting enhancements
#; SJ2308  2/24/07 Scott Jones, new flags for PROC handling
#; SJ2302  2/22/07 Scott Jones, add new PROC emulation flags here
#; SJ2301  2/19/07 Scott Jones, add slots for case preserved name, and
#;		   IO translation table name
#; SJ2287  2/12/07 Scott Jones, PROC changes
#;  JI427 01/31/07 Jim Idle,    Add new MVFIO flags for trigger processing.
#; GGC034 11/05/06 Greg Cooper, more various spooler and pagination fixes
#; GGC033 11/02/06 Greg Cooper, various spooler/printing/pagination fixes
#; SJ2130 10/30/06 Scott Jones, changes for I-type TOTAL()
#; SJ2262 10/30/06 Scott Jones, add flags for SELECT
#; SJ2259 10/21/06 Scott Jones, split PICK mode from R83 mode
#; SJ2256 10/20/06 Scott Jones, reorganize and simplify ^MV.SYS global
#; SJ2217 10/07/06 Scott Jones, add macros to get new options on F pointers
#; SJ2215 10/06/06 Scott Jones, bring emulation definitions up-to-date
#; SJ2172  9/21/06 Scott Jones, add macro for ProcessMVerrs
#; SJ2162  9/18/06 Scott Jones, add counters and prefix for PROCs,
#;				don't recompile PROCS every single time used
#; SJ2152  9/15/06 Scott Jones, restore LANG11.inc, overwritten by JI266
#; SJ2139  9/11/06 Scott Jones, DEFAULT emulation is now CACHE
#; SJ2129  9/03/06 Scott Jones, change |"%SYS"|SYSSP to %SYS.MVSP
#; SJ2128  9/02/06 Scott Jones, fix bug in QSO(), add macros for QS*
#; SJ2122  9/01/06 Scott Jones, handle new format for multivalue indices
#; SJ2074  8/15/06 Scott Jones, changes to pack I-types into routines
#; SJ2060  8/03/06 Scott Jones, name I-type routines separately from MVB ones
#; SJ2051  7/27/06 Scott Jones, check for object code in correct namespace
#; SJ2047  7/25/06 Scott Jones, add run-time support for argument parsing
#; SJ2032  7/16/06 Scott Jones, further BSCAN changes (better code generation)
#; SJ2030  7/13/06 Scott Jones, changes for BSCAN rewrite
#; SJ2023  6/28/06 Scott Jones, adjust MVREADPREV macro
#; SJ2019  6/25/06 Scott Jones, break level counter
#; SJ1996  6/09/06 Scott Jones, new flag for account deletion
#; SJ1995  6/09/06 Scott Jones, add MVBsqlerrmsg and MVBsqlcode
#; SJ1981  6/02/06 Scott Jones, account enhancements to map to namespace
#; SJ1972  5/29/06 Scott Jones, changes for accounts/cataloging
#; DAS988  5/26/06 Diane Steidler, DELETE-ACCOUNT changes
#; SJ1968  5/23/06 Scott Jones, further changes for accounts
#; SJ1966  5/16/06 Scott Jones, initial changes for accounts
#; SJ1964  5/09/06 Scott Jones, added more macros for FileVar access
#; SJ1963  5/09/06 Scott Jones, added MVBmaxcom
#; DAS966  5/02/06 Diane Steidler, changes for ASSIGN
#; SJ1961  4/12/06 Scott Jones, change macro for internal input calls
#; SJ1957  4/06/06 Scott Jones, fix input
#; SJ1953  4/05/06 Scott Jones, change to use new macros
#; SJ1951  4/03/06 Scott Jones, change clause handling
#; SJ1946  3/23/06 Scott Jones, fix bug introduced by LRS844
#; SJ1924  3/06/06 Scott Jones, add missing ULTIMATE emulation flavor
#; LRS1033 3/01/06 Lee Smith, add tests for principal device is a terminal
#; SJ1912  3/01/06 Scott Jones, add $$$MVBinitialized
#; SJ1870  2/28/06 Scott Jones, fix emulations
#; SJ1892  2/21/06 Scott Jones, add macros for handling FileVariables
#;		   and SelectLists
#; SJ1885  2/20/06 Scott Jones, put back some macros erroneously removed
#;		   with MVFIO changes
#; SJ1884  2/19/06 Scott Jones, use new $mvv expression syntax
#; SJ1866  2/13/06 Scott Jones, change inconsistent use of 4-space tabs to
#;		   standard 8-space tabs to make file readable again
#; DAS918  2/06/06 Diane Steidler, add list variable property info
#;LRS1016  1/13/06 Lee Smith, terminal control flags for command recall and to
#;		   inhibit access to DATA stack
#; DAS881 12/14/05 Diane Steidler, add INPUT flags HASINPUTIF and HASINPUTTE
#;LRS1000 12/08/05 Lee Smith, implement MVBasic terminal read in system code
#; DAS849 10/12/05 Diane Steidler, change routine handling in ^S.SYSTEM
#; SJ1777 10/03/05 Scott Jones, added PARASENTENCE
#; SJ1771  9/30/05 Scott Jones, save lock name in file variable
#; DAS818  8/11/05 Diane Steidler, Studio integration
#; DAS817  7/19/05 Diane Steidler, add EditFileRoutine for &ROUTINES& file
#; DAS816  7/18/05 Diane Steidler, add GetVOCProgFile
#; DAS811  6/30/05 Diane Steidler, Split the ^S.SYSTEM file, add ^S.ACCOUNT
#; DAS807  6/24/05 Diane Steidler, File IO API
#; DAS790  6/22/05 Diane Steidler, get data section
#; DAS802  6/20/05 Diane Steidler, add macros for multi data sections
#; DAS789  6/06/05 Diane Steidler, add MakeClassName
#; DAS787  6/02/05 Diane Steidler, add DTypeRoutinePrefix,GetFileRoutine,
#;                 SetFileRoutine
#; DAS772  5/22/05 Diane Steidler, support multiple accounts
#; SJ1730  5/15/05 Scott Jones, add new $MVV variable for account name
#; DAS782  5/13/05 Diane Steidler, add VOC access macros and new $mvv 
#;                 variable for VOC name.
#; JL005   5/10/05 John Lambert, correctMV Error handling defs
#; JL002   5/09/05 John Lambert, add variables for MV Error handling
#; SJ1717  5/05/05 Scott Jones, expand and reorganize $MVV allocations
#; SJ1716  5/03/05 Scott Jones, fix problems with FileVariable
#; KMK239  4/21/05 Keith Knowles.  Implement breakValue in the heading.
#; SJ1714  4/06/05 Scott Jones, fixes to %MV.FileVariable class
#; DAS771  4/04/05 Diane Steidler, change file variable macros to
#;                 use the %MV.FileVariable class
#; SJ1700  2/16/05 Scott Jones, added MVBitypecache
#; LRS900  2/01/05 Lee Smith, add MVBcrtwidth and MVBcrtlines
#; SJ1662  1/13/05 Scott Jones, fix @SYSTEM.RETURN.CODE problem
#; SJ1661  1/12/05 Scott Jones, change MVBdebug format
#; SJ1652  1/07/05 Scott Jones, fix MVB variable names
#; LRS882 01/06/05 Lee Smith, clean, add MVBcrtiomsk for I/O optimization
#; SJ1646 12/24/04 Scott Jones, add MVBcurid and MVBcurrec
#; LRS865 11/29/04 Lee Smith, terminal characteristics (case, CR mode)
#; SJ1617 11/20/04 Scott Jones, reorganize MV support code
#; LRS851 11/08/04 Lee Smith, ^%MVCMD -> ^%SYS.MVCMD
#; LRS848 11/06/04 Lee Smith, fix LFT1320 oversight with SetVOCFile^LANGF09
#; LRS844 11/05/04 Lee Smith, change &HOLD& and &PH& files to use globals,
#;                 enhance capture handling
#; SJ1607 11/02/04 Scott Jones, reorganize to create more room in %MVCMD
#; LRS841 10/21/04 Lee Smith, command line recall definitions
#; LRS833 10/01/04 Lee Smith, implement PHANTOM processes and macros for
#;                 MVBasic process administration
#; DAS657 09/29/04 Diane Steidler, add @ANS
#; LRS825 09/20/04 Lee Smith, add printer controls for SETPTR
#; LRS822 09/20/04 Lee Smith, add MVBassigned
#; SJ1578  9/16/04 Scott Jones, change macros
#; DAS646  9/15/04 Diane Steidler, support OPENPATH and file.variables
#; DAS647  9/09/04 Diane Steidler, macros for VOC access
#; SJ1564  8/13/04 Scott Jones, add new temp variables
#; SJ1542  7/02/04 Scott Jones, add boolean variables, reorder integer
#; LRS789 07/01/04 Lee Smith, add MVBdontask for disabling automatic
#;                 screen pagination when @(row,column) is referenced
#; LRS784 06/28/04 Lee Smith, change default terminal contination prompting
#;                 to OFF (AskCont) in DEFTERMINAL
#; LRS776 05/25/04 Lee Smith, remove MVBwho macro
#; LRS768 04/16/04 Lee Smith, add MVBselected
#; DAS562  4/15/04 Diane Steidler, ECHO ON/OFF
#; SJ1475 03/24/04 Scott Jones, renumber general $mvv variables
#; LRS765 03/23/04 Lee Smith, add MVBautologout, MVBtimeout
#; LRS764 03/19/04 Lee Smith, add MVBstartdate and MVBstarttime, COMO
#;                 command variables, MVBdatefmt
#; DAS534 03/10/04 Diane Stteidler, add MVBSystemReturnCode
#; CDS527 03/08/04 Chuck Sorenson, assign @STDFIL as $mvv function
#; LRS759 03/04/04 Lee Smith, add MVBcapture and MVBcapstr
#; CDS525 03/05/04 Chuck Sorenson, INMAT()
#; DAS418 02/12/04 Diane Steidler, STDFIL,USER0,USER1,USER2,USER3,USER4
#; LRS742 02/05/04 Lee Smith, add more variables for I/O support
#; LRS738 12/04/03 Lee Smith, add MVBfilename macro
#; LRS737 12/02/03 Lee Smith, add MVBselect and MVBwho macros
#; SJ1461 11/20/03 Scott Jones, changed macros, added new macros
#; SJ1443 11/03/03 Scott Jones, changes to macros
#; SJ1440 10/16/03 Scott Jones, added @RM,@AM,@VM,@SM,@TM macros
#; LRS725 10/14/03 Lee Smith, initial implementation
#; =============================End Maintenance========================
#; 
#; Standard MV Error message numbers
#;
#include MVERRNO
#include mvfioflags
#;
#; Single character @ variables (0..7, 8..15)
#define	MVrm			$mvv(0)
#define	MVam			$mvam
#define	MVvm			$mvvm
#define	MVsm			$mvsm
#define	MVtm			$mvtm
#; 
#define	MVBselchr		$mvv(14)
#; 
#; String or arbitrary type @ variables (16..127)
#; 
#define	MVVID			16
#define	MVVITYPECACHE		49
#; 
#define	MVBid			$mvid
#define	MVBrecord		$mvrecord
#define	MVBdata			$mvv(18)
#define	MVBdevice		$mvv(19)
#; String with tab stop settings enforced by the TABS command or TB command in ED
#define	MVBtabs			$mvv(20)
#define	MVBtermname		$mvv(21)
#define	MVBfilename		$mvv(22)
#define	MVBsentence		$mvsentence
#define	MVBheader		$mvv(24)
#define	MVBfooter		$mvfooter
#define	MVBunused2 		$mvv(26)
#define	MVBtemp			$mvv(27)
#define	MVBtemp2		$mvv(28)
#define	MVBtemp3		$mvv(29)
#define MVBUser0		$mvv(30)
#define MVBUser1		$mvv(31)
#define MVBUser2		$mvv(32)
#define MVBUser3		$mvv(33)
#define MVBUser4		$mvv(34)
#define MVBstdfil		$mvstdfil
#define	MVBsysretcode		$mvsysretcode
#define MVBiostatus		$mviostatus
#define MVBioerror		$mvioerror
#define	MVBuserretcode		$mvuserretcode
#define	MVBday			$mvday
#define	MVBmonth		$mvmonth
#define	MVByear			$mvyear
#define	MVByear4		$mvv(41)
#define	MVBtty			$mvtty
#define	MVBassigned		$mvv(43)
#define MVBans			$mvans
#define	MVBComoName		$mvv(45)
#define	MVBsqlerrmsg		$mvv(46)
#define	MVBselglo		$mvv(47)
#define	MVBselnxt		$mvv(48)
#define	MVBitypecache		$mvv(49)
#define	MVBchainTo		$mvv(50)
#;
#; MBVspooler keeps details for all the print jobs currently spooling.
#; MVBspoolerdefault keeps default details on a system wide process
#;     and is used by SETPTR.DEFAULT
#; MVBspoolerglobal is the name of the global for the spooler print jobs
#define	MVBspooler		$mvv(51)
#define	MVBspoolerdefault	$mvv(52)
#define	MVBspoolerglobal	$mvv(53)
#;
#; MVBtermcompiled is the compiled terminal information
#define	MVBtermcompiled		$mvv(54)
#;
#; MVBphantomname is the global name for phantom output
#define	MVBPhantomName		$mvv(55)
#;
#define	MVBtemp4		$mvv(56)
#;
#; PROC emulation flags (now can be 63 bits)
#define	MVPFlags 		$mvv(57)
#;
#define	MVBlanguage		$mvv(58)
#;
#; $mvv(59) is now free (listinfo)
#;
#; used inside generate code for Tfile translates
#define	MVBscratch1		$mvv(60)
#;
#define	MVBresultlastconv	$mvv(61)
#;
#; PROC Primary input buffer
#define MVPPIB			$mvprocpib
#; 
#; PROC Secondary input buffer
#define MVPSIB                  $mvprocsib
#; 
#; PROC Primary output buffer
#define MVPPOB                  $mvprocpob
#; 
#; PROC Secondary Output buffer
#define MVPSOB                  $mvprocsob
#; 
#; Main error message accumulation string
#define MVBerrorstr		$mverrors
#;
#; Error message accumulation string used to return the messages to PROC 
#define MVBprocerrorstr		$mvprocerrors
#;
#define	MVBarglist		$mvv(68)
#;
#; Error message accumulation string used to return the messages to caller
#define MVBreturningErrorStr	$mvv(69)
#; 
#; The name of the PROC we are currently compiling/running
#; 
#define	MVPProcName		$mvprocname
#; 
#; The list of OPTIONS on the command line.
#; I.E. :COMMAND FILE ITEM (OIG
#; Causes this to be set to OIG
#define	MVBoptions		$mvoptions
#; 
#; The default select list variable is 0, but there are a further
#; 10 numbered select list 1-10 in some emulations. These are kept across
#; CALL/SUBROUTINE boundaries and therefore we keep them as special variables
#; here. The list variables are actually Orefs, and so can be MVALUEPs
#; within our 'special variables'.
#;
#define MVBListFile             "&SAVEDLISTS&"
#define MVBselectBase           72
#define	MVBselectList0		$mvv(72)
#define	MVBselectList1		$mvv(73)
#define	MVBselectList2		$mvv(74)
#define	MVBselectList3		$mvv(75)
#define	MVBselectList4		$mvv(76)
#define	MVBselectList5		$mvv(77)
#define	MVBselectList6		$mvv(78)
#define	MVBselectList7		$mvv(79)
#define	MVBselectList8		$mvv(80)
#define	MVBselectList9		$mvv(81)
#define	MVBselectList10		$mvv(82)
#define MVBSelectList(%listNo)	$mvv(72+%listNo)
#;
#define	MVBlocklist		$mvv(83)
#define	MVBparasentence		$mvv(84)
#define	MVBpromptchr		$mvv(85)
#; $mvv(86) is now free
#define MVBdataobj		$mvv(87)
#define MVBdictobj		$mvdict
#define MVBcommand		$mvcommand
#define MVBRecur0		$mvv(90)
#define MVBRecur1		$mvv(91)
#define MVBRecur2		$mvv(92)
#define MVBRecur3		$mvv(93)
#define MVBRecur4		$mvv(94)
#define MVBConv			$mvconv
#define MVBFormat		$mvformat
#define MVBAtHeader		$mvheader
#; Name of last logon proc/para/program run.
#define	MVBlastLogonProc	$mvv(98)
#define	MVBQWho			$mvv(99)
#;
#; Any type-ahead accidentally read in by the routine TIKEYS^%SYS.MVF
#; and will later be re-used by the INPUT statements.
#;
#define	MVBInputTypeahead	$mvv(100)
#; The internal select list
#define MVBselectListInt	$mvv(101)
#;
#; Integer @ variables (128..193)
#define	MVBstatus		$mvv(128)
#define	MVBcol1			$mvv(129)
#define	MVBcol2			$mvv(130)
#;
#; Note that the MVBtabstop is not implemented now.
#; It was half implemented, and is now removed.
#; We do have another implemented tab which is
#; MVBtabs , which allows more than one tab setting.
#;
#define	MVBtabstop		$mvv(131)
#define	MVBselect		$mvv(132)
#define	MVBlevel 		$mvlevel
#define MVBinmat		$mvv(134)
#define	MVBunused3 		$mvv(135)
#define	MVBstartdate 		$mvdate
#define	MVBstarttime 		$mvtime
#define MVBrecoveryLevel $mvv(138)
#define	MVBautologout 		$mvv(139)
#define	MVBtimeout 		$mvv(140)
#define	MVBlasterrcode		$mvv(141)
#define	MVBinttmp1		$mvv(142)
#define	MVBinttmp2		$mvv(143)
#define	MVBinttmp3		$mvv(144)
#define	MVBselected		$mvselected
#define	MVBprecision		$mvv(146)
#define	MVBrecallcnt		$mvv(147)
#define	MVBComoIdx		$mvv(148)
#define	MVBcurid		$mvv(149)
#define	MVBselcnt		$mvv(150)
#define	MVBcrtmask		$mvv(151)
#define	MVBcrtiomsk		$mvv(152)
#define MVBcrtmaxlin		$mvv(153)
#define MVBcrtwidth		$mvv(154)
#define MVBcrtlines		$mvv(155)
#define MVBbreaklevel		$mvnb
#define MVBdetaillines		$mvnd
#define MVBitemcount		$mvni
#define MVBvaluecount		$mvnv
#define MVBsubvalcount		$mvns
#; 
#; Current parameter offset in PROC PIB (attr in PQN)
#define MVPPIBPtr		$mvprocpiboff
#; 
#; Current parameter offset in PROC SIB (attr in PQN)
#define MVPSIBPtr		$mvprocsiboff
#;
#; Current attribute # for ACCESS() function in BASIC/CMQL
#define	MVBattrno		$mvv(163)
#;
#; Current M Mark in this PROC
#define	MVPMark			$mvv(164)
#;
#; Current locking level, whicih is slightly different from the EXECUTE level.
#; See C source code in MVFIO module for more deatils.
#;
#define MVBlocklevel            $mvv(165)
#;
#; This is the current printer channel + 1 (0 means use CRT)
#;
#define	MVBprinter		$mvv(166)
#;
#define	MVBmaxcom		$mvv(167)
#;
#define	MVBexitcode		$mvv(168)
#;
#define	MVBsqlcode		$mvv(169)
#;
#define	MVBbreakkeycnt		$mvv(170)
#;
#define	MVBargpos		$mvv(171)
#; The last job number created
#define	MVBspoolerlastjob	$mvv(172)
#; The form queue number last assigned with SP-ASSIGN
#define	MVBspoolerlastassign	$mvv(173)
#; A unique id for COMMON chaining
#define	MVBcomid		$mvv(174)
#; MVBPhantomIdx - relative line number for COMO output
#define	MVBPhantomIdx		$mvv(175)
#; The job that was holding the requested lock
#define MVBlockport		$mvv(176)
#; Timeout applied to 'read' statements once "TANDEM ON" initiated
#define	MVBTandemTimeout	$mvv(177)
#; Integer to show if running a CMQL command and if LPTR used.
#; A value of 1 means the LPTR keyword was seen
#; A value > 1 means the "LPTR n" keywords where seen and MVBcmql = n + 2
#define	MVBcmql			$mvv(178)
#; Define how the spooler and pagination works
#define	MVBspoolerconduct	$mvv(179)
#; Define if to filter control characters from INPUT statements
#; MVBInputControlFilter is the current one for the execution level only
#; MVBInputControlFilterDefault is the default for new EXECUTE levels
#define	MVBInputControlFilter	$mvv(180)
#define	MVBInputControlFilterDefault	$mvv(181)
#; MVBTransactionStart is MVBlocklevel where nested transactions start
#define MVBTransactionStart	$mvv(182)
#;
#; GGC532 Reserve some numbers for other code I'm working on at the moment.
#; MVBInputNull     Value for the INPUTNULL statement
#define MVBInputNull		$mvv(188)
#define	MVBusedefterminal	$mvv(189)
#;
#; Before adding new fields, check mvdefs.h for availability
#;
#define	MVBflags1		$mvv(192)
#define	MVBflags2		$mvv(193)
#; 
#define	DEFTABSTOP		10
#; 
#; Boolean @ variables (194..255)
#define	MVBpagePrompt		$mvv(194)
#define	MVBhush			$mvv(195)
#define	MVBecho			$mvv(196)
#define	MVBdontask		$mvv(197)
#define	MVBinitialized		$mvv(198)
#;
#; Set if the principal input device is a terminal
#define MVBisterm		$mvv(199)
#;
#define	MVBcomo			$mvv(200)
#define	MVBcomohush		$mvv(201)
#define	MVBcapture 		$mvv(202)
#; See a page later for this definition 
#; Added here as it functionality goes here
#; #define	MVBoutput		$mvv(219)
#; 
#; TRUE if in PQ proc, FALSE if PQN proc
#define MVPPQMode		$mvv(203)
#; 
#; TRUE if Secondary Input Buffer is active, FALSE if primary
#define MVPInputSecondary	$mvv(204)
#; 
#; TRUE is Secondary Output Buffer is active, FALSE if primary
#define MVPOutputSecondary	$mvv(205)
#;
#; Set if the F/A correlative processor detects more values to process
#define MVBmorevalues		$mvmorevalues
#;
#; Set if the F/A correlative processor detects more subvalues to process
#define MVBmoresubvalues	$mvmoresubvalues
#;
#; Set if the conversion processor finds a non numeric value at runtime
#define MVBnotnumeric		$mvv(208)
#;
#; Set to prevent the release of a select list after verb execution
#define MVBkeepSelectList	$mvv(209)
#;
#; Set to show that the next command can be taken from the data stack
#define MVBexecDataStack	$mvv(210)
#;
#; Set to cause the conv compiler to always report OK to the COS compiler
#; error messages will still be placed in the error message buffer
#define MVBhushConvErrors	$mvv(211)
#; MVBtraceflag: Shows if the TCL trace is on or off
#define	MVBTclTrace		$mvv(212)
#; Set to prevent passing unnamed COMMON on PERFORM
#define MVBStackCommon		$mvv(213)
#; Set if we have a status message displayed with INPUTERR
#define	MVBInputerrMessage	$mvv(214)
#;
#; 
#define	MVBPagePrompt		$mvv(215)
#;
#; Last command executed in OneCmd was an external (Basic) program
#define	MVBBasicProgram		$mvv(216)
#;
#; Trap exceptions
#define	MVBTrapExceptions	$mvv(217)
#;
#; INPUT reads stacked DATA only
#define MVBInputDataOnly	$mvv(218)
#;
#; Set if EXECUTE has an OUTPUT clause, set this to non-zero
#define	MVBoutput		$mvv(219)
#;
#define	MVBstatuserror		$mvv(253)
#define	MVBstatuslocked		$mvv(254)
#define	MVBstatusflg		$mvv(255)
#; 
#define MVBSystemReturnCode	$$$MVBsysretcode
#;
#; Type of command executed in OneCmd
#;
#define	CMDNONE		0
#define	CMDQUERY	1
#define	CMDBASIC	2
#define	CMDPARAGRAPH	3
#define	CMDPROC		4
#define	CMDVERB		5
#;
#; Flag values for $MVCVTNUM()
#define MVCVTNullIsZero		1
#define MVCVTNonNumUnchanged	2
#define MVCVTNonNumMsg		4
#define MVCVTUvWhitespace	8
#define	MVCVTBoolean		16
#;
#; Print control information for terminals and printers
#; (Fields in MVBdevice). Alternate ones added so we can test
#; for unassigned values.
#; 
#;
#; DevName: Name of device we are printing to. This variable is
#; 			currently indeterminate as we no longer support
#;			Mode 2 printing, direct to a device
#define	GetName(%dev)		$ListGet(%dev,1)
#define	DevName(%dev)		$List(%dev,1)
#define	DevNameGet(%dev)	$ListGet(%dev,1)
#;
#; PageLines: Total number of lines on a page which is absolute page
#;			size and doesn't include any margins or footers or headers.
#define	PageLines(%dev)		$List(%dev,2)
#define	PageLinesGet(%dev)	$ListGet(%dev,2)
#;
#; PageWidth: Width of a page in characters
#define	PageWidth(%dev)		$List(%dev,3)
#define	PageWidthGet(%dev)	$ListGet(%dev,3)
#;
#; TopMargin: Number of lines to keep blank at the top of
#;			a page and is set by SETPTR (?)
#define	TopMargin(%dev)		$List(%dev,4)
#define	TopMarginGet(%dev)	$ListGet(%dev,4)
#;
#; BotMargin: Number of lines to keep blank at the bottom of
#;			a page and is set by SETPTR (?)
#define	BotMargin(%dev)		$List(%dev,5)
#define	BotMarginGet(%dev)	$ListGet(%dev,5)
#;
#; HeadLines: Number of lines used by the HEADING statement
#define	HeadLines(%dev)		$List(%dev,6)
#define	HeadLinesGet(%dev)	$ListGet(%dev,6)
#;
#; FootLines: Number of lines used by the FOOTING statement
#define	FootLines(%dev)		$List(%dev,7)
#define	FootLinesGet(%dev)	$ListGet(%dev,7)
#;
#; PageNumber: The current page number. Used by the spooler and by
#;			the 'P' option in HEADING and FOOTING
#define	PageNumber(%dev)	$List(%dev,8)
#define	PageNumberGet(%dev)	$ListGet(%dev,8)
#;
#; PageEject: Set to 1 if we need some form of page eject every
#;			time we go over a page boundary
#define	PageEject(%dev)		$List(%dev,9)
#define	PageEjectGet(%dev)	$ListGet(%dev,9)
#;
#; GGC347 No long used: AskCont: Not sure, is it set
#; GGC347 #define	AskCont(%dev)		$List(%dev,10)
#; GGC347 #define	AskContGet(%dev)	$ListGet(%dev,10)
#;
#; LinCnt: Number of lines written on this page. Should be a value
#;			between 0 and PageLines
#define	LinCnt(%dev)		$List(%dev,11)
#define	LinCntGet(%dev)		$ListGet(%dev,11)
#;
#; RecIdx: Used as the index into the spooler global when writing
#;			to a spooler or &HOLD& file, a bit like the total number
#;			of lines written.
#define	RecIdx(%dev)		$List(%dev,12)
#define	RecIdxGet(%dev)		$ListGet(%dev,12)
#;
#;
#; PtrOpen: Obsolete, previous showed if a direct device was open or not.
#define	PtrOpen(%dev)		$List(%dev,13)
#define	PtrOpenGet(%dev)	$ListGet(%dev,13)
#;
#; PtrMode: Set to 1 for outputting to the spooler global (usually ^%MV.SPOOL)
#;			or 3 to the &HOLD& file. Mode 2, direct printing, not supported.
#define	PtrMode(%dev)		$List(%dev,14)
#define	PtrModeGet(%dev)	$ListGet(%dev,14)
#;
#; PtrBannerName: For mode 1 (spooled output) the banner to print at start of print job
#;                For mode 3 (output to &HOLD&) the name of the hold file
#define	PtrBannerName(%dev)		$List(%dev,15)
#define	PtrBannerNameGet(%dev)	$ListGet(%dev,15)
#;
#; PtrBannerNext:	If set, for mode 3 (output to &HOLD&) we suffix an incrementing number
#define	PtrBannerNext(%dev)		$List(%dev,16)
#define	PtrBannerNextGet(%dev)	$ListGet(%dev,16)
#;
#; PtrNext: Not sure.
#define	PtrNext(%dev)		$List(%dev,17)
#define	PtrNextGet(%dev)	$ListGet(%dev,17)
#;
#; PtrKeep: Set if to keep job open between jobs
#define	PtrKeep(%dev)		$List(%dev,18)
#define	PtrKeepGet(%dev)	$ListGet(%dev,18)
#;
#; PtrJobEject: Eject a page after a print job has finished
#define	PtrJobEject(%dev)		$List(%dev,19)
#define	PtrJobEjectGet(%dev)	$ListGet(%dev,19)
#;
#; PtrCopies: Number of copies to print, might be redundant
#define	PtrCopies(%dev)		$List(%dev,20)
#define	PtrCopiesGet(%dev)	$ListGet(%dev,20)
#;
#; PtrHold: Hold job after printing
#define	PtrHold(%dev)		$List(%dev,21)
#define	PtrHoldGet(%dev)	$ListGet(%dev,21)
#;
#; PtrInform: Set if to display the job number to the screen when a new job is created.
#define	PtrInform(%dev)		$List(%dev,22)
#define	PtrInformGet(%dev)	$ListGet(%dev,22)
#;
#; CrtCRmode: Not sure why is CRT stuff here?
#define	CrtCRmode(%dev)		$List(%dev,23)
#define	CrtCRmodeGet(%dev)	$ListGet(%dev,23)
#;
#; CrtCase: Is this set to 1 when case inversion performed? If so,
#;			why is it one of these values?
#define	CrtCase(%dev)		$List(%dev,24)
#define	CrtCaseGet(%dev)	$ListGet(%dev,24)
#;
#; PtrSkip: Set if job is to skip automatic printing.
#define	PtrJobSkip(%dev)	$List(%dev,25)
#define	PtrJobSkipGet(%dev)	$ListGet(%dev,25)
#;
#; PtrFormQueue: Name of the form queue we're assigned to in format "FQnnnnnnnn"
#define	PtrFormQueue(%dev)		$List(%dev , 26 )
#define	PtrFormQueueGet(%dev)	$ListGet(%dev , 26 )
#;
#; PtrUnprotect: Remove spooler security
#define	PtrUnprotect(%dev)		$List(%dev,27)
#define	PtrUnprotectGet(%dev)	$ListGet(%dev,27)
#;
#; PtrAux: Print to auxilliary printer when job closes
#define	PtrAux(%dev)		$List(%dev,28)
#define	PtrAuxGet(%dev)		$ListGet(%dev,28)
#;
#; FormFeedDelay: Used historically to decide if to use CR/LF or FF to paginate.
#define	FormFeedDelay(%dev)	$List(%dev,29)
#define	FormFeedDelayGet(%dev)	$ListGet(%dev,29)
#;
#; PageFirst: Shows if the very first HEADING has been initiated or not
#define	PageFirst(%dev)		$List(%dev,30)
#define	PageFirstGet(%dev)	$ListGet(%dev,30)
#;
#; pagebreak is the break value that should be used in header and footers
#define	PageBreak(%dev)		$List(%dev,31)
#define	PageBreakGet(%dev)	$ListGet(%dev,31)
#;
#; nextpagebreak is the break value that should be copied to pagebreak after
#; a footer has been printed so that the value in footers and headers refer
#; to the data on the respective page
#define	NextPageBreak(%dev)	$List(%dev,32)
#define	NextPageBreakGet(%dev)	$ListGet(%dev,32)
#;
#; NextPageNumber is used when ASSIGN TO SYSTEM(n) has been used,
#; in which case at the next page break then instead of simply
#; incrementing the value, we use this value.
#;
#define	AssignPageNumber(%dev)	$List(%dev,33)
#define	AssignPageNumberGet(%dev)	$ListGet(%dev,33)
#;
#; LineExists. Flag to show if the line at LinCnt contains any data yet.
#define	LineExists(%dev)	$List(%dev , 34 )
#define	LineExistsGet(%dev)	$ListGet(%dev , 34 )
#;
#; PtrBannerSuppress: Temporarily suppress the output of the banner.
#define	PtrBannerSuppress(%dev)		$List(%dev,35)
#define	PtrBannerSuppressGet(%dev)	$ListGet(%dev,35)
#;
#; PtrRemovePagination: Whatever the value of $$$MVBspoolerconduct,
#;  don't enforce any pagination, leave it up to the application.
#define	PtrRemovePagination(%dev)	$List(%dev,36)
#define	PtrRemovePaginationGet(%dev)	$ListGet(%dev,36)
#;
#; Variables for the spooler print jobs. The structures in the $$$MVBdevice
#; mainly refer to form queues and configurations, these in the $$$MVBspooler
#; mainly refer to individual print jobs.
#;
#; We have two SPOOLERbegin[12] macros, one is used before we call
#; OneCmd() and the other inside OneCmd(). It has to be split like this
#; for timing issues and detection of ztraps.
#;
#define	SPOOLERbegin1		set spTmp=$G(%MVSPOOLERLEVEL,1)  
#define	SPOOLERbegin2(%jobType) 	do PtrJobStart^%SYS.MVSP2(%jobType)
#;
#; Macro SPOOLERend:  Called after OneCmd and also after ProcessMVerrs to close
#; all the print jobs and restore spool job information to what it was before.
#define	SPOOLERend do PtrJobEnd^%SYS.MVSP2(.spTmp) kill spTmp
#define	SPOOLERendCHAIN do PtrJobEnd^%SYS.MVSP2(,1) 
#;
#; Macro SPOOLERget(%chan):	Extracts the data for a print job for a channel
#;
#define	SPOOLERget(%chan) Set spoolt = $ListGet($$$MVBspooler,%chan+2,"") , spooltsav=spoolt
#;
#; Macro SPOOLERput(%chan):	Optionally puts back any modified data for a channel
#;
#define	SPOOLERput(%chan)	Set:(spoolt'=spooltsav) $$$MVBspooler = $LU($$$MVBspooler , %chan+2 , spoolt)
#;
#; SpoolerJobNumber:			The job number in the spooler global
#define	SpoolerJobNumber		$List(spoolt , 1)
#define	SpoolerJobNumberGet		$ListGet(spoolt , 1)
#;
#; SpoolerGlobal:			The name of the global that contains this job
#define	SpoolerGlobal			$List(spoolt , 2 )
#define	SpoolerGlobalGet		$ListGet(spoolt , 2 )
#;
#; SpoolerRecIdx: Used as the index into the spooler global when writing
#; to a spooler or &HOLD& file, a bit like the total number of lines written.
#define	SpoolerRecIdx			$List(spoolt,3)
#define	SpoolerRecIdxGet		$ListGet(spoolt,3)
#;
#; PageQty: The number of pages in the current output
#define	SpoolerPageQty			$List(spoolt,4)
#define	SpoolerPageQtyGet		$ListGet(spoolt,4)
#;
#; ExecuteLevel: The execute level the print job was opened with.
#;
#define	SpoolerExecuteLevel		$List(spoolt,5)
#define	SpoolerExecuteLevelGet		$ListGet(spoolt,5)
#;
#; GGC323 SpoolerJobNumberPrev:	Retain the output device even when the
#; job is closed for access later by the GETPUT function.
#define	SpoolerJobNumberPrev		$List(spoolt,6)
#define	SpoolerJobNumberPrevGet		$ListGet(spoolt,6)
#;
#; SpoolerJobNumberNext:	Create a new job name to use.
#define	SpoolerJobNumberNext		$List(spoolt,7)
#define	SpoolerJobNumberNextGet		$ListGet(spoolt,7)
#;
#; PtrDefaultGlobal:	The default name for the spooler global
#define	PtrDefaultGlobal		$$MvspoolDefaultGlobal^%SYS.MVSP()
#define	PtrSpoolerGlobal		$S($l($$$MVBspoolerglobal):$$$MVBspoolerglobal,1:$$$PtrDefaultGlobal)
#;
#;
#; The following definitions, self explanatory, describe the status of the
#; form queues and the status of the jobs.
#;
#define	PtrJobStatusOpen			1
#define	PtrJobStatusClosed			2
#define	PtrJobStatusPrinting		3
#define PtrJobStatusCorrupt			4
#;
#define	PtrFQStatusInactive			1
#define	PtrFQStatusPrinting			2
#define	PtrFQStatusSleeping			3
#define	PtrFQStatusSuspended		4
#define	PtrFQStatusIOError			5
#define	PtrFQStatusNoDevice			6
#;
#define	PtrFQRequestStop			1
#define	PtrFQRequestKill			2
#define	PtrFQRequestSuspend			3
#define	PtrFQRequestResume			4
#;
#; Define the bit map that goes to make up the values for MVBspoolerconduct
#;
#; SpoolerConductFlagCMQLClose - Close the spooler job when a CMQL program terminates
#define	SpoolerConductFlagCMQLClose			1
#;
#; SpoolerConductFlagInternalClose - Close the spooler job when an internal program terminates
#define	SpoolerConductFlagInternalClose			2
#;
#; SpoolerConductFlagProcClose - Close the spooler job when a PROC/PA terminates
#define	SpoolerConductFlagProcClose			4
#;
#; SpoolerConductFlagUserProgramClose - Close the spooler job when a user written program terminates
#define	SpoolerConductFlagUserProgramClose		8
#;
#; SpoolerConductFlagUniqueJob - Each program will get its own unique print spooler job
#define	SpoolerConductFlagUniqueJob			16
#;
#; SpoolerConductFlagNoInheritPrintStatus - Each program does NOT inherit the printer status of its child program
#define	SpoolerConductFlagNoInheritPrintStatus		32
#;
#; SpoolerConductFlagCMQLUniqueJob - CMQL will get its own unique print spooler job
#define	SpoolerConductFlagCMQLUniqueJob			64
#;
#; SpoolerConductDefaultPagination -- If set then we will paginate regardless of header or footer
#define	SpoolerConductDefaultPagination			128
#;
#; SpoolerConductFirstHeadingImmediate -- If set then the first HEADING statement gets executed immediately
#define SpoolerConductFirstHeadingImmediate 		256
#;
#; SpoolerConductSubsequentHeadingImmediate -- If set then subsequent HEADING statement gets executed immediately
#define SpoolerConductSubsequentHeadingImmediate 	512
#;
#; SpoolerConductPageLastLine -- If set then the HEADING is executed when last line
#;     of an existing page is executed. This is West Coast (Reality, Pick) mentality.
#;     If not set, then the heading is only executed when the first line of
#;     a new page is executed which is Easy Coast mentality (Universe, Unidata, Cache).
#define SpoolerConductPageLastLine 			1024
#;
#; SpoolerConductFirstHeadingNoFF - If set, then if we are the first heading
#; AND there has been no data output, we don't issue a leading form feed.
#define	SpoolerConductFirstHeadingNoFF			2048
#;
#; SpoolerConductCloseAll - If set, then "PRINTER CLOSE" will close
#; ALL print channels. Without this, we only close channel 0.
#;
#define	SpoolerConductCloseAll				4096
#;
#; SpoolerConductAutoCreateFQ - If set, then during an SP-ASSIGN
#; if the form queue doesn't exist, we auto-create a form queue.
#;
#define	SpoolerConductAutoCreateFQ			8192
#;
#; SpoolerConductFFCapturingInhibit - If set, ignore the form feed
#; when CAPTURING is in effect.
#;
#define	SpoolerConductFFCapturingInhibit		16384
#;
#; SpoolerConductAssignDefault - When SP-ASSIGN is run, if the printer size
#; isn't defined with SP-PAGESIZE then restore the printer size to defaults.
#;
#define	SpoolerConductAssignDefault			32768
#;
#; SpoolerConductShareHeading - The heading for terminal and printer are shared
#;
#define	SpoolerConductShareHeading			65536
#;
#; SpoolerConductSubsequentHeadingTerminalImmediate - a subsequent HEADING statement
#; when output is to a terminal will be immediate.
#;
#define	SpoolerConductSubsequentHeadingTerminalImmediate		131072
#;
#; Macros to protect the spooler. When we start spooler output
#; we disable transaction support and disable the break key, so that
#; the user can't corrupt the spooler tables either by CTRL<C> or
#; by using transaction rollback. At the end of spooler output,
#; we restore the transaction and break status to what it was before.
#;
#define	SpoolerProtectStart(%ztlabel)  break 4  set protTransSave=$zu(139,1),protZE=$ze,$ze="",$ZT=%ztlabel
#define	SpoolerProtectEnd(%ztlabel)    %ztlabel  set $zt=""  do:$l($ze) spoolerError^%SYS.MVSP2  set $ze=protZE  do $zu(139,protTransSave)   break:'$$$MVBbreakkeycnt 5
#;
#; Macro to decide if we are doing pagination or not.
#;
#define	SPOOLERPAGINATE(%devt) ( $zb($$$MVBspoolerconduct,$$$SpoolerConductDefaultPagination,1) && '$$$PtrRemovePaginationGet(%devt))
#; 
#; Default printer settings
#; 
#define	DEFPTRLINES		66
#define	DEFPTRWIDTH		132
#define	DEFPTRTOPMRGN		3
#define	DEFPTRBOTMRGN		3
#; 
#; Default terminal does NOT do case inversion like UniVerse as this is as mad as a fish
#; It is easilly turned on using the PTERM command for those few people
#; that actually like it. For the rest of the world, let's act sensibly.
#; 
#define	DEFTERMINAL	$ListBuild(0,25,79,0,0,0,0,0,0,0,0,0,0,0,"",0,0,0,0,0,0,0,0,0,0,0,0,0)
#; 
#; Device and pseudo device types for I/O control (e.g. $$$MVBcrtmask)
#define	DEVTYPE			1
#define	HOLDTYPE		2
#define	PHANTYPE		4
#define	COMOTYPE		8
#define	CAPTYPE			16
#define	HEADFOOTTYPE		32
#define	PHANTYPESPOOLER		64
#define	TANDEMREADY		128
#define	TANDEMSLAVE		256
#define	OUTPUTTYPE		512
#; 
#; Flags for INPUT call to $$ReadKbd^|"%SYS"|LANGC11
#; See docs there...
#;
#define	MVINPUTLENGTH	        1
#define	MVINPUTAT	        2
#define	MVINPUTFORMAT           4
#define	MVINPUTNONL             8
#define	MVINPUTNEEDRETURN      16
#define MVINPUTTAM1            32
#define MVINPUTFMTMSK          64
#define	MVINPUTIF	      128
#define	MVINPUTTE	      256
#define	MVINPUTFOR            512
#define	MVINPUTWITH          1024
#define MVINPUTSINGLECHAR    4096
#define	MVINPUTSTRIP         8192
#define MVINPUTUPARROW      16384
#define MVINPUTNOBREAK      32768
#define	MVINPUTINVERTCASE   65536
#define	MVINPUTHUSH	   131072
#define MVINPUTNODATASTK   262144
#define MVINPUTFROMSHELL   524288
#;
#define	HASINPUTLENGTH(%flag)		$ZB(%flag,$$$MVINPUTLENGTH,1)
#define	HASINPUTAT(%flag)		$ZB(%flag,$$$MVINPUTAT,1)
#define	HASINPUTFORMAT(%flag)		$ZB(%flag,$$$MVINPUTFORMAT,1)
#define	HASINPUTNONL(%flag)		$ZB(%flag,$$$MVINPUTNONL,1)
#define	HASINPUTNEEDRETURN(%flag)	$ZB(%flag,$$$MVINPUTNEEDRETURN,1)
#define HASINPUTTAM1(%flag)             $ZB(%flag,$$$MVINPUTTAM1,1)
#define HASINPUTFMTMSK(%flag)           $ZB(%flag,$$$MVINPUTFMTMSK,1)
#define HASINPUTIF(%flag)		$ZB(%flag,$$$MVINPUTIF,1)
#define HASINPUTTE(%flag)		$ZB(%flag,$$$MVINPUTTE,1)
#define	HASINPUTFOR(%flag)		$ZB(%flag,$$$MVINPUTFOR,1)
#define	HASINPUTWITH(%flag)		$ZB(%flag,$$$MVINPUTWITH,1)
#define HASINPUTSTRIP(%flag)		$ZB(%flag,$$$MVINPUTSTRIP,1)
#define HASINPUTUPARROW(%flag)		$ZB(%flag,$$$MVINPUTUPARROW,1)
#define HASINPUTNOBREAK(%flag)		$ZB(%flag,$$$MVINPUTNOBREAK,1)
#define HASINPUTSINGLECHAR(%flag)	$ZB(%flag,$$$MVINPUTSINGLECHAR,1)
#define HASINPUTFROMSHELL(%flag)	$ZB(%flag,$$$MVINPUTFROMSHELL,1)
#;
#define	HASINPUTINVERTCASE(%flag)	$ZB(%flag,$$$MVINPUTINVERTCASE,1)
#define HASINPUTHUSH(%flag)		$ZB(%flag,$$$MVINPUTHUSH,1)
#define HASINPUTNODATASTK(%flag)	$ZB(%flag,$$$MVINPUTNODATASTK,1)
#;
#define	MVBSCANDIRD		1	/* Descending direction */
#define	MVBSCANSEQ		2	/* Has SEQ parameter */
#define	MVBSCANFROM		4	/* Has FROM filevar, start clause */
#define	MVBSCANSTART		8	/* Has FROM [filevar,] start */
#define	MVBSCANUSING		16	/* Has USING indexname clause */
#define	MVBSCANRECORD		32	/* Return record or list of record id's */
#define	MVBSCANRESET		64	/* RESET flag passed */
#;
#; Has ON ERROR clause
#define	MVTOKONERROR		1	/* Has ON ERROR clause */
#;
#define	MVSELECTSORTED		2	/* SSELECT */
#define	MVSELECTTO		4	/* SELECT has TO clause */
#define	MVSELECTVARIABLE	8	/* SELECTV vs. SELECTN */
#define	MVSELECTFROM		16	/* Has FROM clause */
#define	MVSELECTATKEY		32	/* Has ATKEY clause */
#define	MVSELECTATKEYREC	64	/* Has ATKEY,recordId */
#define	MVSELECTPICK		128	/* PICK semantics */
#define	MVSELECTNORESELECT	256	/* NO.RESELECT */
#define	MVSELECTCOUNT		512	/* FSELECT */
#define MVSELECTARRAYRESELECT	1024	/* ARRAY.RESELECT */
#define MVSELECTJBASE		2048	/* JBASE behavior */
#;
	/* clean up stack to the Execute or Shell and start chained prog */
#define	MVCHAIN		0
	/* clean up stack to the Execute or Shell and resume caller shell */
#define	MVSTOP		1
	/* like stop but invoke ON.ABORT */
#define	MVABORT		2
	/* clean up stack and exit MV shell  */
#define	MVEXIT		3
	/* clean up stack and halt cache process */
#define	MVHALT		4
#define	MVMAXTRAP	4
#;
#define	trapCHAIN		Do $ZU(24,16,$$$MVCHAIN)
#define	trapSTOP		Do $ZU(24,16,$$$MVSTOP)
#define	trapABORT		Do $ZU(24,16,$$$MVABORT)
#define	trapEXIT		Do $ZU(24,16,$$$MVEXIT)
#define	trapHALT		Do $ZU(24,16,$$$MVHALT)
#; Set $TEST to be returned to glue code caller
#define glueSetDTest(%t)	Do $ZU(24,14,%t)
#;
#define	glueCHAIN		Set $$$MVBexitcode=$$$MVCHAIN Do $ZU(96,3,213)
#define	glueSTOP		Set $$$MVBexitcode=$$$MVSTOP Do $ZU(96,3,213)
#define	glueABORT		Set $$$MVBexitcode=$$$MVABORT Do $ZU(96,3,213)
#define	glueEXIT		Set $$$MVBexitcode=$$$MVEXIT Do $ZU(96,3,213)
#define	glueHALT		Set $$$MVBexitcode=$$$MVHALT Do $ZU(96,3,213)
#;
#define SaveCommon		Do $ZU(195,1)
#define RestoreCommon(%id)	Do $ZU(195,2,%id)
#;
#define	ISPHANTOM		$Get($$$MVpParent($J))
#; A phantom process is not allowed to read the terminal ==> HALT
#define	trapPHANTOM		Do:$$$ISPHANTOM $ZU(24,16,$$$MVHALT)
#; 
#; Macros for file.variables
#; 
#; These macros reference the %MV.File class.
#;
#define	NewFileVariable		$zu(24,0)
#define	IsFileVariable(%fv)	$zu(24,2,%fv)
#;
#; The following bits indicate the trigger operations currently 
#; in force. They are set in TriggerOperations to indicate
#; which of the base IO operations have triggers in force.
#; 
#define	OpenTrigger	 1
#define	ReadTrigger	 2
#define WriteTrigger	 4
#define DeleteTrigger	 8
#define ClearTrigger	16
#;
#; The following indicators are to be kept in sync with the
#; MVBASIC include file CACHE.INC that is shipped in the 
#; MV.SYS.INCLUDE 'file' - they are given to the trigger
#; routine to indicate what it is being called for.
#;
#define	TRIGGERTYPEPOSTOPEN	  1
#define TRIGGERTYPEPREREAD	  2
#define TRIGGERTYPEPOSTREAD	  3
#define TRIGGERTYPEPREDELETE	  4
#define TRIGGERTYPEPOSTDELETE	  5
#define TRIGGERTYPEPRECLEAR	  6
#define TRIGGERTYPEPOSTCLEAR	  7
#define TRIGGERTYPEPREWRITE	  8
#define TRIGGERTYPEPOSTWRITE	  9
#define TRIGGERTYPEPREINSERT	 10
#define TRIGGERTYPEPOSTINSERT	 11
#define TRIGGERTYPEPREUPDATE	 12
#define TRIGGERTYPEPOSTUPDATE	 13
#;
#; If FireTriggers is TRUE then the MVFIO C routines will fire the
#; generated COS trigger handling routine (see CREATE-TRIGGER verb).
#; 
#define FileVarStorageType(%fv)		(%fv).%StorageType
#define FileVarFileName(%fv)		(%fv).%FileName
#define FileVarNamespace(%fv)		(%fv).%Namespace
#define FileVarDictFlag(%fv)		(%fv).%DictFlag
#define FileVarGlobal(%fv)		(%fv).%Global
#define FileVarAccount(%fv)		(%fv).%Account
#define FileVarTargetAccount(%fv)	(%fv).%TargetAccount
#define FileVarTargetFileName(%fv)	(%fv).%TargetFileName
#define FileVarCOSName(%fv)		(%fv).%COSName
#define FileVarLockName(%fv)		(%fv).%LockName
#define FileVarClassName(%fv)		(%fv).%ClassName
#define FileVarIndexName(%fv)		(%fv).%IndexName
#define FileVarIndexCollation(%fv)	(%fv).%IndexCollation
#define FileVarBSCAN(%fv)		(%fv).%BSCAN
#define FileVarBSCANid(%fv,%id)		(%fv).%BSCAN(%id)
#define FileVarIndFlag(%fv)		(%fv).%IndFlag
#define FileVarIndNames(%fv)		(%fv).%IndNames
#define FileVarIndColl(%fv)		(%fv).%IndColl
#define FileVarIndMV(%fv)		(%fv).%IndMV
#define FileVarOptions(%fv)		(%fv).%Options
#define FileVarFireTriggers(%fv)	(%fv).%FireTriggers
#define FileVarCasePreserveName(%fv)	(%fv).%CasePreserveName
#define FileVarClassNamespace(%fv)	(%fv).%ClassNamespace
#define FileVarSectionName(%fv)		(%fv).%SectionName
#define FileVarTriggerOperations(%fv)	(%fv).%TriggerOperations
#;
#if	0
#define FileVarIsBinary(%fv)		(%fv).%IsBinary
#define FileVarIsTranslated(%fv)	(%fv).%IsTranslated
#define FileVarIOTable(%fv)		(%fv).%IOTable
#endif
#define	FileVarIsSequential(%fv) ($$$FileVarStorageType(%fv)=$$$MVFIOTypeSeq)
#define	IsSequentialFile(%fv)	($zu(24,2,%fv)&&$$$FileVarIsSequential(%fv))
#define	FileVarIsGlobal(%fv) $CASE($$$FileVarStorageType(%fv),$$$MVFIOTypeInode:1,$$$MVFIOTypeAnode:1,$$$MVFIOTypeCnode:1,:0)
#;
#define	MVOPEN(%rc,%fv,%acc,%nam,%flg) Set %fv=$$$NewFileVariable,%rc=$zu(24,4,%fv,%acc,%nam,%flg)
#define	MVOPENGLOBAL(%fv,%glo) Set %fv=$$$NewFileVariable,$$$FileVarCOSName(%fv)=%glo,$$$FileVarLockName(%fv)=%glo,$$$FileVarNamespace(%fv)=$qs(%glo,-1),$$$FileVarGlobal(%fv)=$e($qs(%glo,0),2,*),$$$FileVarStorageType(%fv)=$$$MVFIOTypeInode
#define	MVOPENDIR(%fv,%dir) Set %fv=$$$NewFileVariable,$$$FileVarCOSName(%fv)=$zu(12,%dir),$$$FileVarLockName(%fv)=$name(%mvLock(%dir)),$$$FileVarGlobal(%fv)=%dir,$$$FileVarStorageType(%fv)=$$$MVFIOTypeDir
#define	MVIOPEN(%rc,%fv,%acc,%nam,%flg) Set %rc=$zu(24,4,%fv,%acc,%nam,%flg)
#define	MVREAD(%rc,%var,%fv,%id,%f1,%f2) Set %var=$zu(24,5,%fv,%id,%f1,%f2),%rc=$zu(24)
#define	MVWRITE(%rc,%fv,%recid,%val,%f1,%f2) Set %rc=$zu(24,6,%fv,%recid,%val,%f1,%f2)
#define	MVREADNEXT(%rc,%id,%sl) Set %id=$zu(24,7,%sl,0),%rc=$zu(24)
#define	MVREADPREV(%rc,%id,%sl) Set %id=$zu(24,7,%sl,1),%rc=$zu(24)
#define	MVDELETE(%rc,%fv,%id,%flg) Set %rc=$zu(24,11,%fv,%id,%flg)
#define	MVGETLIST(%rc,%sl,%fv,%ln) Set %sl=$$$NewSelectList,%rc=$zu(24,9,%sl,%fv,%ln)
#define	MVPUTLIST(%rc,%sl,%ln,%fv,%flg) Set %rc=$zu(24,10,%sl,%ln,%fv,%flg)
#define	MVCLEARFILE(%rc,%fv) Set %rc=$zu(24,13,%fv)
#define	MVUNLOCKALL(%rc) Set %rc=$zu(24,12)
#define	MVUNLOCKFILE(%rc,%fv) Set %rc=$zu(24,12,%fv,"")
#define	DOMVUNLOCKFILE(%fv) $zu(24,12,%fv,"")
#define	MVUNLOCKITEM(%rc,%fv,%it) Set %rc=$zu(24,12,%fv,%it)
#define	DOMVUNLOCKITEM(%fv,%it) $zu(24,12,%fv,%it)
#define	MVREMLCKFILE(%rc,%fv,%state) Set %rc=$zu(24,24,%fv,"",%state)
#define	DOMVREMLCKFILE(%fv,%state) $zu(24,24,%fv,"",%state)
#define	MVREMLCKITEM(%rc,%fv,%it,%state) Set %rc=$zu(24,24,%fv,%it,%state)
#define	DOMVREMLCKITEM(%fv,%it,%state) $zu(24,24,%fv,%it,%state)
#define	MVCHECKEXISTS(%rc,%fv,%id) Set %rc=$zu(24,25,%fv,%id)
#define	MVIOCTL(%rc,%fv,%op,%flg) Set %rc=$zu(24,26,%fv,%op,%flg)

#;
#; GGC500 These macros are added for security reasons
#;   as some utilities run as % routines and so the global
#;   security is trashed.
#;
#define	MVSECWRITE(%rc,%fv,%recid,%val,%f1,%f2) if (%fv.%StorageType >= 0 && '($system.Security.GetGlobalPermission(%fv.%Namespace,%fv.%Global,%f1)["WRITE")) { s %rc=$$$MVFIOProtect} else { Set %rc=$zu(24,6,%fv,%recid,%val,%f1,%f2)  }
#define	MVSECREAD(%rc,%var,%fv,%id,%f1,%f2) if (%fv.%StorageType >= 0 && '($system.Security.GetGlobalPermission(%fv.%Namespace,%fv.%Global,"("""_%id_""")")["READ")) { s %rc=$$$MVFIOProtect} else { Set %var=$zu(24,5,%fv,%id,%f1,%f2),%rc=$zu(24) }
#define	MVSECDELETE(%rc,%fv,%id,%flg) if (%fv.%StorageType >= 0 && '($system.Security.GetGlobalPermission(%fv.%Namespace,%fv.%Global)["WRITE")) { s %rc=$$$MVFIOProtect} else { Set %rc=$zu(24,11,%fv,%id,%flg) }
#define	MVSECCLEARFILE(%rc,%fv) if (%fv.%StorageType >= 0 && '($system.Security.GetGlobalPermission(%fv.%Namespace,%fv.%Global)["WRITE")) { s %rc=$$$MVFIOProtect} else { Set %rc=$zu(24,13,%fv) }
#;
#; These macros reference the %MV.SelectList class
#; 
#define	NewSelectList		$zu(24,1)
#define	IsSelectList(%lv)	$zu(24,3,%lv)
#;
#; Flag says treat this index as a SELECTINDEX() without a key
#define	SelectFlagIsSi		8
#; Flag says treat this index as a SELECTINDEX with a specific key
#define SelectFlagIsSiKey	16
#; Flag says return the Item ID rather than the key when READNEXT/READPREV is called
#define SelectFlagRetItemID	32
#; This is an external select list for JBASE.SELECT
#define SelectFlagExtern	16384
#; The select list can be for an array, a file, or an index
#define SelectTypeArray		0
#define SelectTypeFile		1
#define SelectTypeIndex		2
#;
#define SelectListType(%lv)		(%lv).%Type
#define SelectListLastID(%lv)		(%lv).%LastReturnedId
#define SelectListNextOffset(%lv)	(%lv).%NextOffset
#define SelectListGlobal(%lv)		(%lv).%GlobalName
#define SelectListNamespace(%lv)	(%lv).%Namespace
#define SelectListValues(%lv)		(%lv).%Values
#define SelectListCount(%lv)		(%lv).%Count
#define SelectListIndexName(%lv)	(%lv).%IndexName
#define SelectListIndexFlags(%lv)	(%lv).%IndexFlags
#define SelectListIndexColl(%lv)	(%lv).%IndexColl
#define SelectListInReverse(%lv)	(%lv).%InReverse
#define SelectListLastMVPos(%lv)	(%lv).%LastReturnedMVPos
#define SelectListLastKey(%lv)		(%lv).%LastReturnedKey
#define SelectListCurSub(%lv)		(%lv).%CurSub
#define SelectListMaxSub(%lv)		(%lv).%MaxSub
#define SelectListExplodeFlag(%lv)	(%lv).%ExplodeFlag
#;
#define	MVSELECT(%rc,%from,%lv)	Set %lv=$$$NewSelectList,%rc=$zu(24,8,%from,%lv,0,"")
#define	MVSELECTF(%rc,%from,%lv,%f)	Set %lv=$$$NewSelectList,%rc=$zu(24,8,%from,%lv,%f,"")
#define	MVISELECT(%rc,%from,%lv,%atExpr) Set %rc=$zu(24,8,%from,%lv,0,%atExpr)
#define	MVISELECTF(%rc,%from,%lv,%atExpr,%f) Set %rc=$zu(24,8,%from,%lv,%f,%atExpr)
#define	MVISELECTAT(%rc,%from,%lv,%atExpr,%atRec,%atCnt) Set %rc=$zu(24,8,%from,%lv,0,%atExpr,%atRec,%atCnt)
#define	MVISELECTATF(%rc,%from,%lv,%atExpr,%atRec,%atCnt,%f) Set %rc=$zu(24,8,%from,%lv,%f,%atExpr,%atRec,%atCnt)
#;
#define	FileLockName(%fn)	$S($e(%fn)="^":%fn,1:$name(%mvLock(%fn)))
#; 
#; =====================================================================
#; VOC API
#; 
#; Use the following macros to document and reserve attributes/elements
#; of F pointers stored in the VOC. 
#; 
#; See also: http://turbo.iscinternal.com/twiki/bin/view/ISC/MVAccountMapping#FTypes_in_VOC_MD_files
#; 
#define	FTypeF              1
#define	FTypeDefDataGlo	    2
#define FTypeDictGlo        3
#define	FTypeMultiFlag      4
#define	FTypeDefClass       5
#define	FTypeTranslateID    6
#define	FTypeDataSections   7
#define	FTypeDataGlos       8
#define FTypeDataClasses    9
#;
#; ==============================================================
#; Triggers
#; --------
#; Trigger information $list is stored in $list(FGlobal,4)
#;
#define TrgInfoListGet(%fdsc)	$Listget(@$$$FileVarCOSName(%fdsc),4)
#define TrgInfoListSet(%fdsc)	$List(@$$$FileVarCOSName(%fdsc),4)
#;
#; Set TrgFlags to indicate the type of triggers in force
#; for this file section.
#;
#define TrgFlagsPos			1
#define	TrgFlgs(%tlist)		$List(%tlist,$$$TrgFlagsPos)
#; Set FTypeTrigerRtn to COS trigger handler if triggers are 
#; avaiable on this file. Blank means never had a trigger handler
#; See: CREATE-TRIGGER and releated verbs.
#; 
#define TrgRtnPos			2
#define	TrgRtn(%tlist) 		$List(%tlist,$$$TrgRtnPos)
#;
#; Routine lists are themselves $Lists. The first entry is
#; the subroutine to call, the second is the trigger type
#; UniVerse or jBASE (but could be extended). This paring
#; could be repeated if we want to support multiple trigger subroutines.
#; 
#; The types are:
#;
#;   0 - jBASE
#;   1 - Universe
#;
#define	TrgTypejBASE	0
#define	TrgTypeUV		1
#;
#; List of trigger subroutines called on OPEN
#; 
#define	TrgOpenPos				3
#define TrgOpen(%tlist)			$List(%tlist,$$$TrgOpenPos)
#define TrgRtnsStart				$$$TrgOpenPos			
#;
#; List of trigger subroutines called on pre-read
#;
#define TrgPreReadPos			4
#define TrgPreRead(%tlist)		$List(%tlist,$$$TrgPreReadPos)
#;
#; MV List of trigger subroutines called on post-read
#;
#define TrgPostReadPos			5
#define TrgPostRead(%tlist)		$List(%tlist,$$$TrgPostReadPos)
#;
#; MV List of trigger subroutines called on pre-write
 
#define	TrgPreWritePos			6
#define	TrgPreWrite(%tlist)		$List(%tlist,$$$TrgPreWritePos)
#;
#; MV List of trigger subroutines called on post-write
#; 
#define TrgPostWritePos			7
#define TrgPostWrite(%tlist)	$List(%tlist,$$$TrgPostWritePos)
#;
#; MV List of trigger subroutines called on pre-delete
#; 
#define TrgPreDeletePos			8
#define TrgPreDelete(%tlist)	$List(%tlist,$$$TrgPreDeletePos)
#;
#; MV List of trigger subroutines called on post-delete
#; 
#define TrgPostDeletePos		9
#define TrgPostDelete(%tlist)	$List(%tlist,$$$TrgPostDeletePos)
#;
#; MV List of trigger subroutines called pre-clear
#; 
#define TrgPreClearPos			10
#define TrgPreClear(%tlist)		$List(%tlist,$$$TrgPreClearPos)
#;
#; MV List of trigger subroutines called post-clear
#; 
#define	TrgPostClearPos			11
#define	TrgPostClear(%tlist)	$List(%tlist,$$$TrgPostClearPos)
#;
#;
#; MV List of trigger subroutines called pre-insert
#; 
#define TrgPreInsertPos			12
#define TrgPreInsert(%tlist)	$List(%tlist,$$$TrgPreInsertPos)
#;
#; MV List of trigger subroutines called pre-clear
#; 
#define TrgPostInsertPos		13
#define TrgPostInsert(%tlist)	$List(%tlist,$$$TrgPostInsertPos)
#;
#; MV List of trigger subroutines called pre-clear
#; 
#define TrgPreUpdatePos			14
#define TrgPreUpdate(%tlist)	$List(%tlist,$$$TrgPreUpdatePos)
#;
#; MV List of trigger subroutines called pre-clear
#; 
#define TrgPostUpdatePos		15
#define TrgPostUpdate(%tlist)	$List(%tlist,$$$TrgPostUpdatePos)
#;
#define TrgRtnsStop				$$$TrgPostUpdatePos
#;
#;
#; ----------------------------------------------------------
#; VOC Types
#define VOCTypeFile		"F"
#define VOCTypeVerb		"V"
#define VOCTypeKeyword          "K"
#define VOCTypeDictionary       "D"
#define VOCTypeParagraph   	"PA"
#define VOCTypePhrase 		"PH"
#define VOCTypeMenu		"M"
#define VOCTypeQPointer		"Q"
#; 
#; ----------------------------------------------------------
#; VOC SubTypes
#define VOCSubTypeBP		"B"
#define VOCSubTypeQuery 	"Q"
#define VOCSubTypeCmd		"I"
#; 
#; ===============================================================
#; Process management information for processes logged into the
#; MVBasic environment. Entries are indexed by the process pid #.
#; 
#; Temporary global name
#define MVpidtab		^CacheTempMV.Pidtab
#; Port number
#define MVpPortNo(%p)		$$$MVpidtab(%p,1)
#; domain\user names (Windows) or terminal name pts/n (Unix)
#define MVpUser(%p)		$$$MVpidtab(%p,2)
#; Terminal identification
#define MVpTerm(%p)		$$$MVpidtab(%p,3)
#; Session start time
#define MVpStart(%p)		$$$MVpidtab(%p,4)
#; Parent pid if this is a phantom process
#define MVpParent(%p)		$$$MVpidtab(%p,5)
#; Message receive mode (0-enabled, 1-disabled)
#define MVpMsgMode(%p)		$$$MVpidtab(%p,6)
#; Running command if this is a phantom process
#define MVpCmd(%p)		$$$MVpidtab(%p,7)
#; Terminal is TANDEM READY to become a slave 
#define	MVpTandemReady(%p)	$$$MVpidtab(%p,8)
#; Terminal is TANDEM SLAVE and the value is the master pid
#define	MVpTandemSlave(%p)	$$$MVpidtab(%p,9)
#; Keep a list of the last 'nn' commands if in TANDEM ON mode
#define MVpTandemHistory(%p)	$$$MVpidtab(%p,10)
#; 
#; Attribute numbers for SYSTEM file D-type record
#define	DTypeNameSpace		 3
#define ACCOUNTEmulation	12
#define	DTypeDesc		17
#define	DTypeDataPrefix		18
#define	DTypeIndexPrefix	19
#define	DTypeClassPrefix	20
#define DTypeCatalogPrefix	21
#define DTypeRoutinePrefix	22
#define DTypeITypePrefix	23
#define DTypePQPrefix		24
#;
#; Debugging flags
#; 
#define	MVDBGKEEPSRC	$zboolean($G(^MVBdebug),1,1)
#define	MVDBGLOG	$zboolean($G(^MVBdebug),2,1)
#define	MVDBGBRKERR	$zboolean($G(^MVBdebug),4,1)
#define	MVDBGBRKSQL	$zboolean($G(^MVBdebug),8,1)
#define	MVDBGSILENT	$zboolean($G(^MVBdebug),16,1)
#define	MVDBGSQLONLY	$zboolean($G(^MVBdebug),32,1)
#; 
#; 
#; Convenience macros
#; 
#define LISTACTIVE	$$defaultListCount^|"%SYS"|LANGF11
#define TERM		$$tt^|"%SYS"|LANGF11()
#define MVInput		$$IN^%SYS.MVGC
#; Character filter for input display purposes
#define SHOW(%s)	$TR(%s,$C(9)," ")
#define UC(%s)		$ZCvt(%s,"U")
#define LC(%s)		$ZCvt(%s,"L")
#define addMVerr	addMVerr^%SYS.MV
#define ProcessMVerrs	ProcessMVerrs^%SYS.MV
#define getPrimaryMVClass $$getPrimaryMVClass^%SYS.MVI
#define	GUESSWHO	$$GuessWho^%SYS.MVC
#define DEFAULTPROGRAMFILE "BP"
#define	MvspoolCloseJob	MvspoolCloseJob^%SYS.MVSP2
#define	GetDevice(%ch)	$$GetDevice^%SYS.MVGC(%ch)	
#define	SetEcho		SetEcho^%SYS.MVGC
#define	AutoLogout	AutoLogout^%SYS.MVGC
#define	GetCRT		$$GetCRT^%SYS.MVGC
#define	LoadTermType	$$LoadTermType^%SYS.MVF
#define	InitTermType	InitTermType^%SYS.MVF
#; 
#; Definitions of all flags concerned with emulations. See the C header
#; file mvemulations.h for much more detail on this. We need to keep the
#; definitions here and in that file, in sequence.
#;
#; Utility number for MV Emulations
#;
#define	MVEmuUtil	199
#;
#; Initialize the emulation system
#;
#define	MVEmuInit			$ZU($$$MVEmuUtil,0)
#;
#; Set the current account table to a specific table
#;
#define MVEmuSetAccountEmu(%Emu)	$ZU($$$MVEmuUtil,1,%Emu)
#;
#; Set the current compiler emulation table to a specified table
#;
#define	MVEmuSetCompilerContext(%Emu)	$ZU($$$MVEmuUtil,2,%Emu)
#;
#; Return the value of a flag in a specific emulation table
#;
#define MVEmuGetValue(%Emu,%Flag)	$ZU($$$MVEmuUtil,3,%Emu,%Flag)
#;
#; Return the value of a flag for the current account emulation
#;
#define	MVEmuGetAccountValue(%Flag)	$ZU($$$MVEmuUtil,3,42,%Flag)
#;
#; Return the value of a flag for the current account emulation
#;
#define	MVEmuGetCompilerValue(%Flag)	$ZU($$$MVEmuUtil,3,43,%Flag)
#; 
#; -----------------------------------------------------------------------
#; There are currently one bajillion emulations which cover the main gamut of
#; the various systems out there. It is possible that we may wish to add
#; things such as UNIVERSE in R83 mode, but I doubt it. Setting R83 mode
#; should work close enough to UniVerse in R83 mode anyway.
#; 
#define	MVEmuCACHE		0
#define	MVEmuJBASE		1
#define	MVEmuREALITY		2
#define	MVEmuUV			3
#define	MVEmuUNIDATA		4
#define	MVEmuPICK		5
#define	MVEmuULTIMATE		6
#define	MVEmuINFORMATION	7
#define	MVEmuPIOPEN		8
#define	MVEmuPOWER95		9
#define	MVEmuMVBASE		10
#define	MVEmuD3			11
#define	MVEmuIN2		12
#define	MVEmuR83		13
#define	MVEmuUDPICK		14
#define	MVEmuMAX		14
#;
#define	MVEmuLit $LB("CACHE","JBASE","REALITY",			##continue
		     "UNIVERSE","UNIDATA","PICK",		##continue
		     "ULTIMATE","INFORMATION","PIOPEN",		##continue
		     "POWER95","MVBASE","D3","IN2",			##continue
		     "R83","UDPICK","PRIME","DEFAULT")
#;
#define	MVEmuVal $C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,7,0)
#;
#; ======================================================================================================
#; SYSTEM file Access Macros
#;
#; "A" Account info copy
#; "B" Basic routine info
#; "C" Catalog info
#; "F" File (Data) info
#; "I" I-Type info
#; "N" Namespace info
#; "P" Proc info
#; "Q" Query info
#; "X" Index info
#;
#; ^MV.SYS("A",1) - account name
#; 	      ,2) - copy of %MV.ACCOUNTS entry for this account
#; ^MV.SYS("B",0) - counter
#;            ,0,file,item)=$LB(rtnname)
#; ^MV.SYS("F",0) - counter
#;            ,0,globalname)=$LB()
#; ^MV.SYS("I",0) - routine counter
#;            ,1) - function counter
#;            ,2,itypeid)=itypecode
#;            ,3,crc,itypeid)=""
#; ^MV.SYS("P",0) - proc counter
#;            ,0,file,item)=$LB(rtnname,procflags_@AM_proccode)
#; ^MV.SYS("X",0) - index counter
#;
#; ^MV.RTN(name)=$LB(type,file,itemid,...)
#;
#; ^%MV.SYS("C",0) - counter
#;              0,name) - deletion list
#; ^%MV.SYS("N",0) - counter
#;              0,ns)= ?
#;
#;
#define	MVSYSACCOUNT		"SYSPROG"
#define	VOCFileName		^MV.VOC
#define	MVDefaultSpoolGlobal	"^%MV.SPOOL"
#;
#define LOCALAcctNameCopy    	^MV.SYS("A",1)
#define LOCALAcctRecordCopy	^MV.SYS("A",2)
#define	SYSCONFIGFileName	^MV.SYS
#define	MVNAMESPACEFLAG		^MV.SYS("N")
#define	DataCounter		^MV.SYS("F",0)
#define FILESFileName(%a)	^MV.SYS("F",0,%a)
#define	IndexCounter		^MV.SYS("X",0)
#define	RoutineCounter		^MV.SYS("B",0)
#define OBJFileName(%f,%p)	^MV.SYS("B",0,%f,%p)
#define OBJFileNameEnv(%e,%f,%p) ^|%e|MV.SYS("B",0,%f,%p)
#define	CatalogCounter		^MV.SYS("C",0)
#define	CATALOGDelete(%a)	^MV.SYS("C",0,%a)
#define	ITypeLock		^MV.SYS("I")
#define	ITypeLockEnv(%e)	^|%e|MV.SYS("I")
#define	ITypeRtnCnt		^MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),0)
#define	ITypeRtnCntEnv(%e)	^|%e|MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),0)
#define	ITypeFunCnt		^MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),1)
#define	ITypeFunCntEnv(%e)	^|%e|MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),1)
#define	ITypeCode(%id)		^MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),2,%id)
#define	ITypeCodeEnv(%e,%id)	^|%e|MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),2,%id)
#define	ITypeHash(%crc,%id)	^MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),3,%crc,%id)
#define	ITypeHashEnv(%e,%crc,%id)	^|%e|MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),3,%crc,%id)
#define	ITypeTotals(%id)	^MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),4,%id)
#define	ITypeTotalsEnv(%e,%id)	^|%e|MV.SYS("I",$$$MVEmuGetAccountValue($$$MVEmuTABLENUM),4,%id)
#define	ProcCounter		^MV.SYS("P",0)
#define ProcFileName(%f,%p)	^MV.SYS("P",0,%f,%p)
#;
#define ROUTINEFileName(%a)	^MV.RTN(%a)
#define ROUTINEFileNameEnv(%e,%a)	^|%e|MV.RTN(%a)
#;
#define	SYSTEMFileName        ^%MV.ACCOUNTS
#define GLCATALOGFileName     ^%MV.CATALOG
#define GLCATRTNFileName(%a)  ^%MV.RTN(%a)
#define	ERRMSGFileName        ^%MV.ERRMSG
#define	NEWACCFileName        ^%MV.NEWACC
#define	DICTVOCFileName       ^%MV.DICTVOC
#define	MVIMPORTFileName      ^%MV.IMPORT
#define	MVIMPORTACCTSFileName ^%MV.IMPORTACCTS
#define	GLCATALOGCounter      ^%MV.SYS("C")
#define	GLCATALOGPrefix       ^%MV.SYS("C",0)
#define	GLCATALOGDelete(%a)   ^%MV.SYS("C",1,%a)
#define	NAMESPACECounter      ^%MV.SYS("N")
#define	NAMESPACENames(%a)    ^%MV.SYS("N",%a)
#define	IsValidAccount(%a)    $D($$$SYSTEMFileName(%a))
#define GetACCOUNTEmulation   (+$MV($G($$$SYSTEMFileName($G($$$NAMESPACENames($zu(5))))),$$$ACCOUNTEmulation))
#; 
#; ========================================================================
#; Entries in the emulation table
#; 
#; The first entry in the table is the Emulation type defined above.
#; 
#define	MVEmuTABLENUM		0
#; 
#; Base offset of @(-) codes
#;
#define MVEmuAtCodeBase		0
#; 
#; Indicates that an AT code is not defined for an emulation
#; 
#define MVEmuAtNONE		0
#; 
#; Indicates that @(nnn) means clear the screen
#; 
#define	MVEmuAtCLEARSCREEN	1
#; 
#; Indicates that @(nnn) means HOME the cursor
#; 
#define	MVEmuAtHOME		2
#; 
#; Indicates that @(nnn) means Clear to end of screen
#; 
#define	MVEmuAtCLEAREOS		3
#; 
#; Indicates that @(nnn) means Clear to end of line
#; 
#define	MVEmuAtCLEAREOL		4
#; 
#; Indicates that @(nnn) means blink the cursor
#; 
#define	MVEmuAtBLINKON		5
#; 
#; Indicates that @(nnn) means stop blinking the cursor
#; 
#define	MVEmuAtBLINKOFF		6
#; 
#; Indicates that @(nnn) means turn on protected fields
#; 
#define	MVEmuAtPROTON		7
#; 
#; Indicates that @(nnn) means turn off protected field
#; 
#define	MVEmuAtPROTOFF		8
#; 
#; Indicates that @(nnn) means move cursor left
#; 
#define	MVEmuAtCURSORLEFT	9
#; 
#; Indicates that @(nnn) means move cursor up
#; 
#define	MVEmuAtCURSORUP		10
#; 
#; Indicates that @(nnn) means turn half intensity on
#;
#define	MVEmuAtHALFION		11
#; 
#; Indicates that @(nnn) means turn half intensity off
#;
#define	MVEmuAtHALFIOFF		12
#; 
#; Indicates that @(nnn) means reverse video on
#; 
#define	MVEmuAtREVERSEON	13
#; 
#; Indicates that @(nnn) means reverse video off
#; 
#define	MVEmuAtREVERSEOFF	14
#; 
#; Indicates that @(nnn) means underline on
#; 
#define	MVEmuAtUNDERLINEON	15
#; 
#; Indicates that @(nnn) means underline on
#; 
#define	MVEmuAtUNDERLINEOFF	16
#; 
#; Indicates that @(nnn) means insert line at cursor
#; 
#define	MVEmuAtINSERTLINE	17
#; 
#; Indicates that @(nnn) means delete cursor line
#; 
#define	MVEmuAtDELETELINE	18
#; 
#; Indicates that @(nnn) means insert char at cursor
#; 
#define	MVEmuAtINSERTCHAR	19
#; 
#; Indicates that @(nnn) means turn on insert mode
#; 
#define	MVEmuAtINSERTON		20
#; 
#; Indicates that @(nnn) means turn off insert mode
#; 
#define	MVEmuAtINSERTOFF	21
#; 
#; Indicates that @(nnn) means delete cursor char
#; 
#define	MVEmuAtDELETECHAR	22
#; 
#; Indicates that @(nnn) means turn printer on
#; 
#define	MVEmuAtPRINTERON	23
#; 
#; Indicates that @(nnn) means turn printer off
#; 
#define	MVEmuAtPRINTEROFF	24
#; 
#; Indicates that @(nnn) means turn printer on silently
#; 
#define	MVEmuAtSIPRINTERON	25
#; 
#; Indicates that @(nnn) means turn printer off silently
#; 
#define	MVEmuAtSIPRINTEROFF	26
#;
#; Indicates that @(nnn) means return aux port delay
#; 
#define	MVEmuAtAUXDELAY		27
#; 
#; Indicates that @(nnn) means print the screen
#; 
#define	MVEmuAtPRINTSCREEN	28
#; 
#; Indicates that @(nnn) means enter 80 col mode
#; 
#define	MVEmuAt80Col		29
#; 
#; Indicates that @(nnn) means enter 132 col mode
#; 
#define	MVEmuAt132Col		30
#;
#; Indicates that @(nnn) means turn cursor on
#;
#define	MVEmuAtCURSORON		31
#; 
#; Indicates that @(nnn) means turn cursor off
#; 
#define	MVEmuAtCURSOROFF	32
#; 
#; Indicates that @(nnn) means move cursor down
#; 
#define	MVEmuAtCURSORDOWN	33
#; 
#; Indicates that @(nnn) means move cursor right/forward
#; 
#define	MVEmuAtCURSORRIGHT	34
#; 
#; Indicates that @(nnn) means set video attributes
#; 
#define	MVEmuAtVIDEO		35
#; 
#; Indicates that @(nnn) means set color pair
#; 
#define	MVEmuAtCOLOPR   	36
#; 
#; Indicates that @(nnn) means set forground color
#; 
#define	MVEmuAtFCOLOR		37
#; 
#; Indicates that @(nnn) means set background color
#; 
#define	MVEmuAtBCOLOR		38
#; 
#; Indicates that @(nnn) means turn on graphics mode
#; 
#define	MVEmuAtGRAPHICSON	39
#; 
#; Indicates that @(nnn) means turn off graphics mode
#; 
#define	MVEmuAtGRAPHICSOFF	40
#; 
#; Indicates that @(nnn) means print graphics char
#; 
#define	MVEmuAtLINEGRFXCH	41
#; 
#; Indicates that @(nnn) means turn off keyboard
#; 
#define	MVEmuAtDMI		42
#; 
#; Indicates that @(nnn) means turn on keyboard
#; 
#define	MVEmuAtEMI		43
#; 
#; Indicates that @(nnn) means blank the screen
#; 
#define	MVEmuAtBSCN		44
#; 
#; Indicates that @(nnn) means unblank the screen
#; 
#define	MVEmuAtUBS		45
#; 
#; Indicates that @(nnn) means scroll screen back/up
#; 
#define	MVEmuAtSCROLLUP		48
#; 
#; Indicates that @(nnn) means scroll screen forward/down
#; 
#define	MVEmuAtSCROLLDN		49
#; 
#; Indicates that @(nnn) means scroll screen right
#; 
#define	MVEmuAtSCROLLRIGHT	50
#; 
#; Indicates that @(nnn) means scroll screen forward
#; 
#define	MVEmuAtSCROLLLEFT	51
#; 
#; Indicates that @(nnn) means truncate at screen edge
#; 
#define	MVEmuAtSLT		54
#; 
#; Indicates that @(nnn) means wrap at screen edge
#; 
#define	MVEmuAtRLT		55
#; 
#; Indicates that @(nnn) means set numeric pad on
#; 
#define	MVEmuAtSNK		56
#; 
#; Indicates that @(nnn) means set numeric pad off
#; 
#define	MVEmuAtRNK		57
#; 
#; Indicates that @(nnn) means turn on BOLD mode
#; 
#define	MVEmuAtBOLDON		58
#; 
#; Indicates that @(nnn) means turn off BOLD mode
#; 
#define	MVEmuAtBOLDOFF		59
#; 
#; Indicates that @(nnn) means turn on secure mode
#; 
#define	MVEmuAtSSECUR		60
#; 
#; Indicates that @(nnn) means turn off secure mode
#; 
#define	MVEmuAtESECUR		61
#; 
#; Indicates that @(nnn) means turn on protected mode
#; 
#define	MVEmuAtSSCRPROT		62
#; 
#; Indicates that @(nnn) means turn on protected mode
#; 
#define	MVEmuAtESCRPROT		63
#; 
#; Indicates that @(nnn) means turn status line on
#; 
#define	MVEmuAtSTATUSLINEON	64
#; 
#; Indicates that @(nnn) means reset status line
#; 
#define	MVEmuAtSTATUSLINEOFF	65
#; 
#; Indicates that @(nnn) means set status line
#; 
#define	MVEmuAtSTATUSLINESET	66
#; 
#; Indicates that @(nnn) means move char horizontal absolute
#; 
#define	MVEmuAtCHA		70
#; 
#; Indicates that @(nnn) means erase n chars at cursor
#; 
#define	MVEmuAtECH		71
#; 
#; Indicates that @(nnn) set unprintable char character
#; 
#define	MVEmuAtNPC		74
#; 
#; Indicates that @(nnn) means EDFS main display attributes
#; 
#define	MVEmuAtDISPLAY		75
#; 
#; Indicates that @(nnn) means EDFS mini-buffer display attributes
#; 
#define	MVEmuAtMINIBUF		76
#; 
#; Indicates that @(nnn) means lock line nnn
#; 
#define	MVEmuAtLOKL		77
#; 
#; Indicates that @(nnn) means unlock line nnn
#; 
#define	MVEmuAtUNLL		78
#; 
#; Indicates that @(nnn) means display marks (tab, nl etc)
#; 
#define	MVEmuAtMARKSUBS		79
#; 
#; Indicates that @(nnn) means vertical bar char 
#; 
#define	MVEmuAtGRAPHICSVERTICAL		80
#; 
#; Indicates that @(nnn) means horizontal bar char
#; 
#define	MVEmuAtGRAPHICSHORIZONTAL	81
#; 
#; Indicates that @(nnn) means upper left graphics char
#; 
#define	MVEmuAtGRAPHICSUPPERLEFT	82
#; 
#; Indicates that @(nnn) means upper right graphics character
#; 
#define	MVEmuAtGRAPHICSUPPERRIGHT	83
#; 
#; Indicates that @(nnn) means bottom left graphics character
#; 
#define	MVEmuAtGRAPHICSBOTTOMLEFT	84
#; 
#; Indicates that @(nnn) means bottom right graphics character
#; 
#define	MVEmuAtGRAPHICSBOTTOMRIGHT	85
#; 
#; Indicates that @(nnn) means the intersection graphics character
#; 
#define	MVEmuAtGRAPHICSINTERSECTION	86
#; 
#; Indicates that @(nnn) means set background white
#; 
#define	MVEmuAtBACKGROUNDWHITE		87
#; 
#; Indicates that @(nnn) means set background yellow
#; 
#define	MVEmuAtBACKGROUNDYELLOW		88
#; 
#; Indicates that @(nnn) means set background magenta
#; 
#define	MVEmuAtBACKGROUNDMAGENTA	89
#; 
#; Indicates that @(nnn) means set background red
#; 
#define	MVEmuAtBACKGROUNDRED		90
#; 
#; Indicates that @(nnn) means set background cyan
#; 
#define	MVEmuAtBACKGROUNDCYAN		91
#; 
#; Indicates that @(nnn) means set background green
#; 
#define	MVEmuAtBACKGROUNDGREEN		92
#; 
#; Indicates that @(nnn) means set background blue
#; 
#define	MVEmuAtBACKGROUNDBLUE		93
#; 
#; Indicates that @(nnn) means set background black
#; 
#define	MVEmuAtBACKGROUNDBLACK		94
#; 
#; Indicates that @(nnn) means set forground white
#; 
#define	MVEmuAtFOREGROUNDWHITE		95
#; 
#; Indicates that @(nnn) means set forground yellow
#; 
#define	MVEmuAtFOREGROUNDYELLOW		96
#; 
#; Indicates that @(nnn) means set forground magenta
#; 
#define	MVEmuAtFOREGROUNDMAGENTA	97
#; 
#; Indicates that @(nnn) means set forground red, or @(-98) in 
#;  Cache Ideal flavor.
#; 
#define	MVEmuAtFOREGROUNDRED		98
#; 
#; Indicates that @(nnn) means set forground cyan
#; 
#define	MVEmuAtFOREGROUNDCYAN		99
#; 
#; Indicates that @(nnn) means set forground green
#; 
#define	MVEmuAtFOREGROUNDGREEN		100
#; 
#; Indicates that @(nnn) means set forground blue
#; 
#define	MVEmuAtFOREGROUNDBLUE		101
#; 
#; Indicates that @(nnn) means set forground black
#; 
#define	MVEmuAtFOREGROUNDBLACK		102
#; 
#; Indicates that @(nnn) means turn all screen effects off 
#; 
#define	MVEmuAtEFFECTSOFF		103
#; 
#; Indicates that @(nnn) means graPhics left tee char
#; 
#define	MVEmuAtGRAPHICSLEFTTEE		104
#; 
#; Indicates that @(nnn) means graphics right tee char
#; 
#define	MVEmuAtGRAPHICSRIGHTTEE		105
#; 
#; Indicates that @(nnn) means graphics up tee
#; 
#define	MVEmuAtGRAPHICSUPTEE		106
#; 
#; Indicates that @(nnn) means grpahics down tee
#; 
#define	MVEmuAtGRAPHICSDOWNTEE		107
#;
#; Note -128 to -196 are interpreted as video attributes as per Reality
#; Operating System, in all emulations
#;
#; Base of the SYSTEM numbers in the settings array.
#; This allows the code that processes SYSTEM(nnn) to find out what the SYSTEM
#; number is in Cache Ideal flavor and then just process that.
#; So: $$$MVEmuGetValue(table, val + $$$MVEmuSYSTEMBASE) gives the actual
#; system code in Cache ideal flavor, the number of which is of course
#; irrelevant internally. That value is then compared against the ones here to
#; see what we should actually do.  So the value 11 is on the stack, which
#; means give me the value of SYSTEM(11) as per the current emulation. You find
#; out the Cache code via: $$$MVEmuGetValue(table, 11 + $$$MVEMUSYSTEMBASE)
#; and it is one of the values below which we compare for.
#; 
#define	MVEmuSYSTEMBASE			117
#; 
#; Indicates that this SYSTEM() function has not meaning
#; 
#define	MVEmuSYSTEMNONE			0
#; 
#; Indicates that SYSTEM(nnn) means last return code, or SYSTEM(0)
#; in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMZERO			($$$MVEmuSYSTEMBASE + 0)
#; 
#; Indicates that SYSTEM(nnn) means return 1 if the printer output is on,
#; or SYSTEM(1) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPTRON		($$$MVEmuSYSTEMBASE + 1)
#; 
#; Indicates that SYSTEM(nnn) means return page width of terminal/printer,
#; or SYSTEM(2) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPGWIDTH		($$$MVEmuSYSTEMBASE + 2)
#; 
#; Indicates that SYSTEM(nnn) means return page depth,
#; or SYSTEM(3) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPGDEPTH		($$$MVEmuSYSTEMBASE + 3)
#; 
#; Indicates that SYSTEM(nnn) means return # of lines in current page
#; (see HEADING), or SYSTEM(4) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPGLINES		($$$MVEmuSYSTEMBASE + 4)
#; 
#; Indicates that SYSTEM(nnn) means return the current page #,
#; or SYSTEM(5) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMCURPGNO		($$$MVEmuSYSTEMBASE + 5)
#; 
#; Indicates that SYSTEM(nnn) means return current line # (see HEADING),
#; or SYSTEM(6) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMCURLIN		($$$MVEmuSYSTEMBASE + 6)
#; 
#; Indicates that SYSTEM(nnn) means return terminal Type,
#; or SYSTEM(7) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMTTYPE		($$$MVEmuSYSTEMBASE + 7)
#; 
#; Indicates that SYSTEM(nnn) means return chan#0 tape record length,
#; or SYSTEM(8) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMTAPERLEN		($$$MVEmuSYSTEMBASE + 8)
#; 
#; Indicates that SYSTEM(nnn) means return CPU msec used,
#; or SYSTEM(9) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMCPUMSECS		($$$MVEmuSYSTEMBASE + 9)
#; 
#; Indicates that SYSTEM(nnn) means return 1 if stacked input available,
#; or SYSTEM(10) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMISSTKED		($$$MVEmuSYSTEMBASE + 10)
#; 
#; Indicates that SYSTEM(nnn) means return item count in active list
#; or 0 if no list, or SYSTEM(11) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMLISTCNT		($$$MVEmuSYSTEMBASE + 11)
#; 
#; Indicates that SYSTEM(nnn) means 1/10 or 1/1000 of secs past midnight,
#; according to the emulation setting MVEmuFTIME10100,
#; or SYSTEM(12) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMTIME			($$$MVEmuSYSTEMBASE + 12)
#; 
#; Indicates that SYSTEM(nnn) means release timeslice,
#; or SYSTEM(13) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMRQM			($$$MVEmuSYSTEMBASE + 13)
#; 
#; Indicates that SYSTEM(nnn) means return typeahead count,
#; or SYSTEM(14) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMTACOUNT		($$$MVEmuSYSTEMBASE + 14)
#; 
#; Indicates that SYSTEM(nnn) means return option string invoking the command,
#; IE: If a program was stated with: RUN BP FRED (JIM then this call returns
#; "JIM". This is SYSTEM(15) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMOPTSTR		($$$MVEmuSYSTEMBASE + 15)
#; 
#; Indicates that SYSTEM(nnn) means return 1 if a PROC called the program,
#; or SYSTEM(16) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMIFPROC		($$$MVEmuSYSTEMBASE + 16)
#; 
#; Indicates that SYSTEM(nnn) means return STOP code fo child process,
#; or SYSTEM(17) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMCHILDSCODE		($$$MVEmuSYSTEMBASE + 17)
#; 
#; Indicates that SYSTEM(nnn) means return the PORT number of the login,
#; or SYSTEM(18) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPORTNO		($$$MVEmuSYSTEMBASE + 18)
#; 
#; Indicates that SYSTEM(nnn) means return the login NAME,
#; or SYSTEM(19) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMLOGNAME		($$$MVEmuSYSTEMBASE + 19)
#; 
#; Indicates that SYSTEM(nnn) means return last spooler file no created,
#; or SYSTEM(20) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMSPLJNUM		($$$MVEmuSYSTEMBASE + 20)
#; 
#; Indicates that SYSTEM(nnn) means return PERFORM/EXECUTE level,
#; or SYSTEM(22) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMEXECLEVEL		($$$MVEmuSYSTEMBASE + 22)
#; 
#; Indicates that SYSTEM(nnn) means return break key status,
#; or SYSTEM(23) in Cache Ideal flavor.
#; 
#; - 0: Enabled
#; - 1: Disabled by BASIC
#; - 2: Disabled by command line VERB
#; - 3: Disabled by Command line AND BASIC
#; 
#define	MVEmuSYSTEMBRKSTATUS		($$$MVEmuSYSTEMBASE + 23)
#; 
#; Indicates that SYSTEM(nnn) means return ECHO status,
#; or SYSTEM(24) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMECHOSTATUS		($$$MVEmuSYSTEMBASE + 24)
#; 
#; Indicates that SYSTEM(nnn) means return 1 if this is a background JOB,
#; or SYSTEM(25) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMISBACKGROUND		($$$MVEmuSYSTEMBASE + 25)
#; 
#; Indicates that SYSTEM(nnn) means return the prompt character,
#; or SYSTEM(26) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPROMPTC		($$$MVEmuSYSTEMBASE + 26)
#;
#; Returns the USER ID of the person using the routine,
#; or SYSTEM(27) in Cache Ideal flavor.
#define MVEmeSYSTEMRTNUID		($$$MVEmuSYSTEMBASE + 27)
#;
#; Returns the effeective user ID of the person using the routine,
#; or SYSTEM(28) in Cache Ideal flavor.
#define	MVEmuSYSTEMRNEUID		($$$MVEmuSYSTEMBASE + 28)
#;
#; Returns the GROUP ID of the person using the routine,
#; or SYSTEM(29) in Cache Ideal flavor.
#define MVEmeSYSTEMRTNGID		($$$MVEmuSYSTEMBASE + 29)
#;
#; Returns the effeective user ID of the person using the routine
#; or SYSTEM(30) in Cache Ideal flavor. ???
#define	MVEmuSYSTEMRNEGID		($$$MVEmuSYSTEMBASE + 30)
#; 
#; GGC347 Was previous MVEmuSYSTEMISPAGING.
#; 
#; GGC347 NO LONGER NEED #define	MVEmuSYSTEMISPAGING		($$$MVEmuSYSTEMBASE + 31)
#;
#; Indicates that SYSTEM(nnn) means return account base dir,
#; or SYSTEM(32) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMBASEDIR		($$$MVEmuSYSTEMBASE + 32)
#;
#; Indicates the list of commands in the MV command recall stack
#; or SYSTEM(33) in Cache Ideal flavor
#;
#define	MVEmuSYSTEMRECALL		($$$MVEmuSYSTEMBASE + 33)
#;
#; Indicates that SYSTEM(nnn) means return any data pending on the input stack,
#; or SYSTEM(34) in CAHCE ideal mode
#;
#define	MVEmuSYSTEMPENDATA		($$$MVEmuSYSTEMBASE + 34)
#; 
#; Indicates that SYSTEM(nnn) means return language (locale) in use,
#; or SYSTEM(35) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMLOCALE		($$$MVEmuSYSTEMBASE + 35)
#; 
#; Indicates that SYSTEM(nnn) means return licensed user count,
#; or SYSTEM(36) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMLICCNT		($$$MVEmuSYSTEMBASE + 36)
#; 
#; Indicates that SYSTEM(nnn) means return the thouseands separator char,
#; or SYSTEM(37) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMTHOUSEP		($$$MVEmuSYSTEMBASE + 37)
#; 
#; Indicates that SYSTEM(nnn) means return the decimal separation character,
#; or SYSTEM(38) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMDECSEP		($$$MVEmuSYSTEMBASE + 38)
#; 
#; Indicates that SYSTEM(nnn) means return the money symbol,
#; or SYSTEM(39) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMMONEYCHRS		($$$MVEmuSYSTEMBASE + 39)
#; 
#; Indicates that SYSTEM(nnn) means return the running porgram name,
#; or SYSTEM(40) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMPROGNAME		($$$MVEmuSYSTEMBASE + 40)
#; 
#; Indicates that SYSTEM(nnn) means return the release number of Cache,
#; or SYSTEM(41) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMRELNO		($$$MVEmuSYSTEMBASE + 41)
#; 
#; Indicates that SYSTEM(nnn) means return the process/port number of the
#; process holding the last item lock that the program ran into,
#; or SYSTEM(43) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMLOCKPORT		($$$MVEmuSYSTEMBASE + 43)
#; 
#; Indicates that SYSTEM(nnn) means return 42, indicating CACHE MV system,
#; or SYSTEM(44) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMSYSTYPE		($$$MVEmuSYSTEMBASE + 44)
#;
#; Indicates the spooler form queue number most recently
#; assigned with an SP-ASSIGN, or SYSTEM(45) in Cache Ideal Flavour.
#;
#define	MVEmuSYSTEMSPLLASTFQ		($$$MVEmuSYSTEMBASE + 45 )
#; 
#; Indicates that SYSTEM(nnn) means return 1 if within a transaction,
#; or SYSTEM(47) in Cache Ideal flavor.
#; 
#define	MVEmuSYSTEMINTRANS		($$$MVEmuSYSTEMBASE + 47)
#;
#; Returns name of Phantom output file				#; SOH235
#define MVEmuSYSTEMPHANTOMNAME		($$$MVEmuSYSTEMBASE + 48)
#;
#; Returns the current call stack
#;
#define MVEmuCALLSTACK			($$$MVEmuSYSTEMBASE + 49)
#; 
#; Field number of the last READNEXT statement when READNEXT is from an
#; exploded Select list.
#;
#define MVEmuSYSTEMRNFLD		($$$MVEmuSYSTEMBASE + 50)
#;
#; Returns details of the computer name
#define	MVEmuSYSTEMCOMPUTERNAME		($$$MVEmuSYSTEMBASE + 52)
#;
#; Returns a unique record ID
#define	MVEmuSYSTEMUNIQUEID		($$$MVEmuSYSTEMBASE + 53)
#;
#; Returns a unique ID for this Cache instance
#define	MVEmuSYSTEMINSTANCEID		($$$MVEmuSYSTEMBASE + 54)
#;
#; Highest possible value of SYSTEM for which we translate using the table,
#; higher than this and there will be no clashes anyway.
#;
#define	MVEmuSYSTEMMAXCODE		54
#;
#; Last element of the SYSTEM() table for use by susbsequent sets of
#; of #defines for flags.
#; 
#define	MVEmuSYSTEMMAX			($$$MVEmuSYSTEMBASE + $$$MVEmuSYSTEMMAXCODE + 1)
#;
#; Miscellaneous, non clashing SYSTEM() codes
#; 
#; GGC099 : Initially we added some details at 1000 upwards,
#; but these clash with jBASE values. Hence I've retained the
#; existing ones we allocated at 1001 and 1002 , but also copied
#; them to 1051 and 1052 which I hope will be used in the future.
#; We should add new non-clashing ones from 1050 upwards (well, actually
#; from 1054 upwards) and keep 1000 through 1049 for jBASE use, which as
#; it happens as it is non-emulated will be available for every emulation.
#;
#; Is this Windows?
#;
#define	MVEmuSYSTEMISWIN		91
#;
#; Seconds since midnight GMT
#;
#define	MVEmuSYSTEMSECSGMT		99
#;
#; System ID, comprising system name, release, etc., normally for D3 users.
#define	MVEmuSYSTEMSYSTEMID		100
#;
#; Simple call stack for D3 SYSTEM(33)
#define MVEmuSYSTEMD3STACK		101
#; 
#; D3 SYSTEM(11) returns list count only if list is unused
#; It returns 0 if the list has been read or does not exist
#; 
#define	MVEmuSYSTEMUNUSEDLISTCNT	102
#;
#; jBASE SYSTEM(11) returns list count only for file/index
#; lists that are unused
#define MVEmuSYSTEMJBLISTCNT		103
#;
#; Universe SYSTEM(35) is number of users (MV users)
#define MVEmuSYSTEMMVUSERS		104
#;
#; Universe SYSTEM(11) returns 1 if list exists, else 0
#define MVEmuSYSTEMLISTEXISTS		105
#;
#; Synonym for STATUS() - D3 SYSTEM(0)
#; 
#define MVEmuSYSTEMSTATUS		254
#;
#; Remapped UNIDATA SYSTEM(33)
#; 
#define MVEmuSYSTEMUNID33		255
#;
#; PAGING ON/OFF
#define MVEmuSYSTEMPAGING		1005
#;
#; Return details of OS , jBASE emulation mainly 
#define	MVEmuSYSTEMOSDETAILS		1017
#;
#; Emulation table number
#; The current value avoids clashes with jBASE.
#; The OLD value was coded some time ago, we should avoid using it
#;
#define	MVEmuSYSTEMEMULATIONOLD		1001
#define	MVEmuSYSTEMEMULATION		1051
#;
#; CACHE Namespace
#; The current value avoids clashes with jBASE.
#; The OLD value was coded some time ago, we should avoid using it
#;
#define	MVEmuSYSTEMNAMESPACEOLD		1002
#define	MVEmuSYSTEMNAMESPACE		1052
#;
#; Returns IP address of caller.
#define	MVEmuSYSTEMIPADDRESS		1053
#;
#; System manager's directory pathname e.g. "C:\Program Files\Cache227\Mgr"
#define	MVEmuSYSTEMMANAGER		1054
#;
#; Current namespace pathname  e.g. "C:\Program Files\Cache227\Mgr\User"
#define	MVEmuSYSTEMNAMESPACEPATH	1055
#;
#; GGC487 Emulations as a multi-attribute string
#define MVEmuSYSTEMFULLEMULATION	1056
#;
#; ------------------------------------------------------------------------
#; Individual flag definitions for each possible emulation setting.
#; 
#; 
#; Use this symbol to check for a boolean setting ON
#; 
#define	MVEmuOPTIONON	1
#; 
#; Use this symbol to check for a boolean emulation setting OFF
#; 
#define	MVEmuOPTIONOFF	0
#; 
#; ------------------------------------------------------------------------
#; The following #defines are the offsets into the emulation tables
#; where a particular option setting should be looked for
#;
#; BASE offset into the table for the emulation flags.
#;
#define	MVEmuFLAGBASE		$$$MVEmuSYSTEMMAX
#;
#; Indicate whether the COPY command should list the keys it is copying or not.
#; 
#define	MVEmuFLAGLISTKEYS	$$$MVEmuFLAGBASE + 0
#; 
#; Indicate whether the @(-) function should support Reality video mode
#;  or not (whereby the codes -128 thru -191 are indicative of effects such
#;  as BOLD or REVERSE and so on.
#; 
#define	MVEmuFLAGROSVIDEO	$$$MVEmuFLAGBASE + 1
#; 
#; Support printer @(-) codes: @(-27 thru -33, -47 thru -55, -59 thru -126,
#;				 -220 thru -239)
#; 
#define	MVEmuFLAGATPTR		$$$MVEmuFLAGBASE + 2
#; 
#; Indicates the style of output for WHO and related user exits.
#; 
#; - MVEmuFLAGWHO1		PID/PORT ACCOUNT
#; - MVEmuFLAGWHO2		PID/PORT ACCOUNT From systemloginname
#; - MVEmuFLAGWHO3		PID/PORT ACCOUNT (systemloginname)
#; 
#define	MVEmuFLAGWHOTYPE	$$$MVEmuFLAGBASE + 3
#; 
#; WHO returns PID/PORT ACCOUNT#; 
#define	MVEmuFLAGWHO1	1
#; 
#; WHO returns PID/PORT ACCOUNT From systemloginname #; 
#define	MVEmuFLAGWHO2	2
#; 
#; WHO returns PID/PORT ACCOUNT (systemloginname)#; 
#define	MVEmuFLAGWHO3	3
#; 
#; Indicate whether subroutines called from DICT entries pass a parameter
#; which contains the current item being processed, or not.
#; 
#define	MVEmuFLAGBTYPEPRM	$$$MVEmuFLAGBASE + 4
#; 
#; Indicates whether ENTER "PROG (I" keeps the global common in tact
#; or not.
#; 
#define	MVEmuFLAGKEEPECOMMON	$$$MVEmuFLAGBASE + 5
#; 
#; Indicates whether date conversions force the output text to upper
#; case or not: July 14 1964 will be JULY 14 1964 if set to ON.
#; 
#define	MVEmuFLAGUCASEDATE	$$$MVEmuFLAGBASE + 6
#; 
#; Indicate whether REFORMAT overwrites existing attributes or not.
#; 
#define	MVEmuFLAGREFORMATOVR	$$$MVEmuFLAGBASE + 7
#; 
#; Indicate whether T Conversions replace system delimiters or not
#; 
#define	MVEmuFLAGTCONVREPSYS	$$$MVEmuFLAGBASE + 8
#; 
#; Indicate whether TRANS() function in ITYPES replaces delimiters with
#; spaces or not.
#; 
#define	MVEmuFLAGTRANSREPSYS	$$$MVEmuFLAGBASE + 9
#; 
#; Indicate whether F correlatives are true reverse polish or not (as in
#; Realiy where they operate the wrong way around really). On means to
#; operate as per reality.
#; 
#define	MVEmuFLAGFCORREVERSE	$$$MVEmuFLAGBASE + 10
#; 
#; Indicate whether right justified data should wrap in query output. Set
#; to ON it will operate like Pime/Universe, OFF like everthing else.
#; 
#define	MVEmuFLAGRJUSTWRAP	$$$MVEmuFLAGBASE + 11
#; 
#; Indicate whether ICONV MTS returns hours or minutes when
#; ambiguous. If ON then ICONV(1, "MTS") returns 3600 assuming 1 hour, and
#; OFF returns 60 assuming 1 minute.
#; 
#define	MVEmuFLAGIMTSHOURS	$$$MVEmuFLAGBASE + 12
#; 
#; Indicate whether HEADINGs in queries suppress "nnn Records Listed." message.
#; Set to ON to cause them to be printed.
#; 
#define	MVEmuFLAGHEADPRNNN	$$$MVEmuFLAGBASE + 13
#; 
#; Indicate whether Empty String "" sorts equally to Zero. This is 
#; primarily for UniVerse/Prime.
#; 
#define	MVEmuFLAGNULLSORTZERO	$$$MVEmuFLAGBASE + 14
#; 
#; Indicate whether functions like INDEX and FIELD will use the whole
#; string supplied as the delimiter, or just the first character.
#; 
#define MVEmuFLAGFULLDELIM	$$$MVEmuFLAGBASE + 15
#; 
#; Indicate whether "PAGE 0" clears any existing HEADINGS or FOOTINGS or not.
#; 
#define MVEmuFLAGPAGE0CHDR	$$$MVEmuFLAGBASE + 16
#; 
#; Indicate capturing mode
#; 
#define MVEmuFLAGCAPTURE	$$$MVEmuFLAGBASE + 17
#;
#define MVEmuFLAGCAPTNL		0
#define MVEmuFLAGCAPTNONL	1
#define MVEmuFLAGCAPTNONLVM	2
#;
#; Indicate whether negative rounding is up or down (stupid possibility, but
#; some programs rely on this behavior. If turned on, then a number such as
#; -0.5 will round to 0 rather than -1 (which is waht it should do).
#; 
#define	MVEmuFLAGROUNDUPNEG	$$$MVEmuFLAGBASE + 19
#; 
#; Indicate how named common should be initialized when first loaded by a
#; program.
#; Options are to Undefined, Enpty string, and numeric zero.
#; 
#define	MVEmuFLAGNCOMINIT	$$$MVEmuFLAGBASE + 20
#; 
#; Indicate how unamed commons should be initialized at program startup.
#; Options are to Undefined, Enpty string, and numeric zero.
#; 
#define MVEmuFLAGCOMINIT	$$$MVEmuFLAGBASE + 21
#; 
#; Indicate common initialized to Unassigned.#; 
#define MVEmuFLAGCOMUNASSIGNED	0
#; 
#; Indicate common initialized to "" string
#define	MVEmuFLAGCOMEMPTYSTR	1
#; 
#; Indicate common initialized to numeric zero
#define	MVEmuFLAGCOMZERO	2
#; 
#; Indicate whether a BASIC subroutine called from a DICT shodl be called
#; for each value and subvalue, or just once.
#; 
#define	MVEmuFLAGQRYMSUBCALL	$$$MVEmuFLAGBASE + 22
#; 
#; Indicate the behavior of division by zero in conversions. If set to
#; ON then division by zero returns zero. If OFF, then return the
#; numerator unchanged (Mathematicians groan and scream now...)
#; 
#define	MVEmuFLAGCONVDIV0IS0	$$$MVEmuFLAGBASE + 23
#; 
#; Indicate if unquoted numbers in A correlatives are treated as numeric
#; values or as references to attributes. ON means they are numeric literals.
#; 
#define MVEmuFLAGACORNUMLIT	$$$MVEmuFLAGBASE + 24
#; 
#; Indicate if output processor should pause at the end of a page of output
#; if the HEADING statement in BASIC was set to "". ON to pause the output 
#; regardless.
#; 
#define	MVEmuFLAGOPPAUSENULL	$$$MVEmuFLAGBASE + 25
#; 
#; Indicate whether OPENSEQ should create the target file if it does not
#; already exist.
#; 
#define	MVEmuFLAGOSEQCREATE	$$$MVEmuFLAGBASE + 26
#; 
#; Indicate whether a RETURNING clause wants the return codes in attribute 
#; delimited form or not.
#; 
#define	MVEmuFLAGRETURNINGAM	$$$MVEmuFLAGBASE + 27
#; 
#; Indicate whether SP-ASSIGN assigns to all channels when no specific
#; channel number is indicated.
#; 
#define	MVEmuFLAGSPASSALL	$$$MVEmuFLAGBASE + 28
#; 
#; Indicate whether conversions involving an empty string "" will
#; treat the string as numeric 0 or an invalid input. For instance
#; Sequoia based systems will take "" string as being 0.
#; 
#define	MVEmuFLAGCONVESZERO	$$$MVEmuFLAGBASE + 29
#; 
#; Indicate whether commands assume that not specifying a list of IDs
#; or a '*' for all, assume '*' rather than prompt for a list of IDs.
#; 
#define	MVEmuFLAGPROMPT4IDS	$$$MVEmuFLAGBASE + 30
#; 
#; Indicate whether A correlative arithmetic is Integer only or not.
#; 
#define	MVEmuFLAGACORINTSUMS	$$$MVEmuFLAGBASE + 31
#; 
#; Indicate whether REDIM of arrays at runtime is supported or not.
#; 
#define	MVEmuFLAGREDIMALLOWED	$$$MVEmuFLAGBASE + 32
#; 
#; Indicate whether the numeric symbols . + and - are treated as
#; non numeric values if they are the only thing in a string.
#; Set to ON to reject these 
#; 
#define	MVEmuFLAGNUMSYMS	$$$MVEmuFLAGBASE + 33
#; 
#; Indicate whether to use Prime/Universe enhanced pattern matching 
#; or not. Note that the MATCHFIELD function comes from UniVerse/Prime
#; and always uses this type of pattern matching.
#; 
#define	MVEmuFLAGENHANCEDMATCH	$$$MVEmuFLAGBASE + 34
#; 
#; Indicate whether additional delimters are added to  delimited
#; arrays if the last element is already a traling delimiter. This
#; affects the behavior of functions and statements that extend arrays
#; such as X<-1> = "Attval" and so on. Set to ON to add delims anyway.
#; 
#define	MVEmuFLAGADDDELIMS	$$$MVEmuFLAGBASE + 35
#; 
#; Indicate the beahvior of READV of attribute 0. This can have one
#; of the following behaviors as chosen from the flags below.
#; 
#; - Return the key of the record (not sure what use that is!!)
#; - Return the DCOUNT() of the record
#; - Return 0 if the record is not there, 1 if it exists.
#; 
#define	MVEmuFLAGREADV0		$$$MVEmuFLAGBASE + 36
#; 
#; Cause READV0 to return the Record ID
#;
#define	MVEmuFLAGRV0KEY		0
#; 
#; Cause READV0 to return the DCOUNT(AM) of the record
#;
#define	MVEmuFLAGRV0DCOUNT	1
#; 
#; Cause READV0 to return 0 if the record does not exist and 1 if it does.
#; 
#define	MVEmuFLAGRV0EXISTS	2
#; 
#; Cause spaces and TABS to be ignored when converting string to numerics.
#; Set to ON if leading whitespace should cause a string to remain a string and
#; not be convertible to numeric.
#; 
#define	MVEmuFLAGARITHNOWS	$$$MVEmuFLAGBASE + 37
#; 
#; Indicate that dynamic arrays passed to EXECUTE/PERFORM will execute each
#; attribute in the array in turn, rather than just the first attribute.
#; 
#define	MVEmuFLAGEXECAM		$$$MVEmuFLAGBASE + 38
#; 
#; Indicate that ICONV should return the empty string and not the original
#; value if the input string was invalid.
#; 
#define	MVEmuFLAGICONVRETES	$$$MVEmuFLAGBASE + 39 
#; 
#; Indicate if the OCONV code should run against empty strings or not.
#;  [Do we need this?]
#; 
#define	MVEmuFLAGOCONVES	$$$MVEmuFLAGBASE + 40
#; 
#; Indicate whether a READ that fails should set the target variable
#; to the empty string or leave it untouched.
#; 
#define	MVEmuFLAGREADFAILES	$$$MVEmuFLAGBASE + 41
#; 
#; Indicate whether the format codes are predeeded with a length field or not
#; [do we need this?]
#; 
#define	MVEmuFLAGFMTHASLEN	$$$MVEmuFLAGBASE + 42
#; 
#; Indicate whether OCONV formatting uses the scale factor or not
#; by default. ON means yes it does.
#; 
#define	MVEmuFLAGOCONVSCALE	$$$MVEmuFLAGBASE + 43
#; 
#; Indicate whether OCONV mask formatting is applied to emtpy strings
#; or non-numeric values. ON means it is.
#; 
#define	MVEmuFLAGCONVMASKES	$$$MVEmuFLAGBASE + 44
#; 
#; Indicates whether arithmetic is delimiter aware or not. I.E
#; \code
#; Addition = "41":@AM:"3"
#; \endcode
#;  Will return "42":@AM:"3" if arithmetic is delimiter aware (ON). If
#;  not delimiter aware, then a Non-Numeric Zero Used would ensue.
#; 
#define	MVEmuFLAGARITHDELIM	$$$MVEmuFLAGBASE + 45
#; 
#; Indicates whether output formatting masks should descale or not.
#; When this flag is ON, for say Reality, then a format such
#; as FMT("987654", "R26") yields 0.98 but when this
#; flag is OFF it will yield 9876.54
#; 
#define	MVEmuFLAGMASKDESCALE	$$$MVEmuFLAGBASE + 46
#; 
#; Indicates compatibility with a bug that is used in code a fiar
#; but. Namely whether a trailing delimiter on a MATCH will match the
#; source or not. Ie "T]R]Y]" will match with "Y]" if this option
#; is turned ON.
#; 
#define	MVEmuFLAGDELIMMATCH	$$$MVEmuFLAGBASE + 47
#; 
#; Indicates whether zero is treated as 1 within substring specifications.
#; When this option is ON, then X[0,6] = "string" means the same things
#; as X[1,6] = "string". When OFF then X[0,6] = "string" means that the
#; "string" is inserted before the first character of X.
#; 
#define	MVEmuFLAGSS0IS1		$$$MVEmuFLAGBASE + 48
#; 
#; Indicates whether the HUSH command operates on both Input and Output
#; (ON) or just INPUT echoing (OFF).
#; 
#define	MVEmuFLAGHUSHIO		$$$MVEmuFLAGBASE + 49
#; 
#; Indicates whether INPUT X,-1 checks for type ahead (ON) or NOT (OFF)
#; 
#define	MVEmuFLAGIM1TA		$$$MVEmuFLAGBASE + 50
#; 
#; Indicate whether values supplied to the INSERT function (not the INS
#; BEFORE...) should treat a parmeter that is 0 as if it were 1. This is quite
#; a subtle difference as it is only the INSERT function and only on Prime and
#; UniVerse. We might need to investigate what UNiVerse does in R83 mode vs
#; Ideal mode. We need our R83 emulation to act like R83, not like R83
#; emulation in UniVerse; we can always create another mode for that one.
#; We might have to do that for VARs porting from UniVerse in a particular
#; emulation, though I was hoping not to have to do that.
#; 
#define	MVEmuFLAGINSERT0IS1	$$$MVEmuFLAGBASE + 51
#; 
#; Indicate whether a default heading, being the command typed in should be
#; used by the output processor in this emulation mode. IE. LIST MD  will be
#; displayed in the heading of the output for that command.
#; 
#define	MVEmuFLAGCMDINHDR	$$$MVEmuFLAGBASE + 52
#; 
#; Indicate whether queries of the form:
#; \code
#; SELECT FILE WITH <clause> WITH <clause> 
#; \endcode
#;  are assumed to be AND WITH (ON setting) or OR WITH (OFF setting).
#; 
#define	MVEmuFLAGQRYANDWITH	$$$MVEmuFLAGBASE + 53
#; 
#; Indicate whether SYSTEM(11) [cache Ideal index 11] returns a binary 1 or 0
#; (ON setting) indicating a select list active or not, or returns the number
#; of elements selected to the active list or 0 (OFF setting).
#; 
#define	MVEmuFLAGSYS11BOOL	$$$MVEmuFLAGBASE + 54
#; 
#; Indicate if this system only returns a result separated by a single space
#; character (OFF setting), or uses the more common 2 spaces (ON setting)
#; I know, it sounds stupid but this is the kind of stuff we run in to all the
#; time.
#; 
#define	MVEmuFLAGTD2SPC		$$$MVEmuFLAGBASE + 55
#; 
#; Indicate if the BASIC SSELECT statement should install the results as the
#; active select list or not (for return from a BASIC program). You basically
#; have the BASIC default select list and the system active select list. They
#; can be the same on some systems and this flag indicates whether BASIC
#; SSELECT affects the active select list or not. Whoever thought to put
#; SSELECT in to BASIC wants a bloody good kicking as processing files in
#; SSELECT ID form is really slow. Having said that, it probably won't be so
#; bad on Cache' ;-)
#; 
#define	MVEmuFLAGSSEL2ALIST	$$$MVEmuFLAGBASE + 56
#; 
#; Indicate whether the conversion processor should try to make some sense
#; of stupid dates such as 31 FEB nnnn or should treat them as invalid input.
#; 
#define	MVEmuFLAGICONVBDATE	$$$MVEmuFLAGBASE + 57
#; 
#; Indicate whether the 'L' option in a BREAK ON clause means that a blank line
#; before the data line is skipped (ON setting) or it means to skip the break
#; line.
#; 
#define	MVEmuFLAGOPLSUP		$$$MVEmuFLAGBASE + 58
#; 
#; Indicate the general style of query output. If set to ON then the
#; Olde Worlde Pick/ROS style output is sent out, otherwise (OFF) the 
#; output is like the U2 style.
#; 
#define	MVEmuFLAGOPPICKSTYLE	$$$MVEmuFLAGBASE + 59
#; 
#; Indicate whether a format mask that does not specify decimal places
#; will output decimal places anyway just for the hell of it (ON setting).
#; 
#define	MVEmuFLAGFMDECOUTPUT	$$$MVEmuFLAGBASE + 60
#; 
#; Indicate whether the BY 'DR' clause of the LOCATE command should
#; act the same as BY 'DN' (ON setting) or not (OFF setting).
#; 
#define	MVEmuFLAGBYDRISDN	$$$MVEmuFLAGBASE + 61
#; 
#; Indicate that a newly installed HEADER from BASIC is not printed
#; immediately, but is just installed ready for the next page break
#; that happens to come along down the road.
#; 
#define	MVEmuFLAGDEFERHEADING	$$$MVEmuFLAGBASE + 63
#; 
#; Indicate that DATA stacked for a paragraph is only used by the
#; paragraph and not passed on to any program that the paragraph 
#; subsequently executes (setting ON).
#; 
#define	MVEmuFLAGPARADATA	$$$MVEmuFLAGBASE + 64
#; 
#; Indicates that stacked data acts aas per Universe and Prime and is
#; global to everything (ON setting). If set to OFF, then the DATA stack
#; acts like Pick/Reality.
#; 
#define	MVEmuFLAGSTACKGLOBAL	$$$MVEmuFLAGBASE + 65
#; 
#; Indicates that the assignment of a variable to another does NOT
#; cause an error if the source variable is Unassigned (ON setting). If
#; set to off, then the assignment of an unassigned variable to anything
#; else causes a runtime error.
#; 
#define	MVEmuFLAGASSUNASSOK	$$$MVEmuFLAGBASE + 66
#;
#; Indicates that a string that is specified as a format mask
#; in an input: INPUT A,len {,} Fmt is really a format mask with which
#; to format input for display and validate input as it goes rather than a
#; 3 character sequence as per ROS/jBASE.
#;
#define MVEmuFLAGINFMTMASK      $$$MVEmuFLAGBASE + 67
#;
#; Indicates that the MVBASIC compiler should treat identifiers
#; (variable names) in a case insensitive fashion. THis means
#; That a variable Abc is considered to be the same variable
#; as ABC and abc. This is sumb as  apost but is the default mode
#; for D3 so we need to deal with it.
#;
#define	MVEmuFLAGNOCASE	$$$MVEmuFLAGBASE + 68
#;
#; Indicates that this emualtion rquries WRITE to wait on a lock
#; held by someone else. This is particularly dumb for what should be
#; obvious reasons but I am sick of arguing with dumb users about it so
#; we have added it for UniVerse mode only. On means to wait for the lock.
#;
#define	MVEmuFLAGRESPECTLOCK	$$$MVEmuFLAGBASE + 69
#;
#; Indicates that an ELSE clause is allowed on WRITE
#;  This is also a dumb idea because WRITE never had an ELSE clause
#;  so if you suddenly add one what does:
#;  \code
#;  IF AA THEN WRITE X ON Y ELSE CRT "errrr"
#;  \endcode
#;  mean? So we allow it in UniVerse mode wher we presume that
#;  users have dealt with it, but not in any other mode without
#;  a $OPTIONS to set it on.
#;
#define	MVEmuFLAGUNIVERSEELSE	$$$MVEmuFLAGBASE  + 70
#;
#; Indicates that COUNT and INDEX should use overlapped counting
#;  when multiple chracters are allowed for delimiters. So a
#;  a string CCCC when counted for "CC" returns 3 and not 2.
#;
#define	MVEmuFLAGCOUNTOVLP	$$$MVEmuFLAGBASE + 71
#;
#; Indicates that the FOR loop shoudl increment/decrement the
#;  index BEFORE instead of AFTER the bound checking.
#;
#define	MVEmuFLAGFORINCBEF	$$$MVEmuFLAGBASE + 72
#;
#; Indicates that FMT is allowed to process out conversion codes 
#; as format masks. This is here for compiler compatibility, we always allow
#; this.
#;
#define	MVEmuFLAGFORMATOCONV	$$$MVEmuFLAGBASE + 73
#; 
#; Indicates that the the BASIC SELECT statement should set the
#; @SELECTED variable whatever it selects from. This is a performance
#; doozy if the lists are big, but we have no choice on some emulations
#; 
#define	MVEmuFLAGFSELECT	$$$MVEmuFLAGBASE + 74
#; 
#; Indicates that the PIOPEN flavor of 'I' and 'P' options for HEADING
#; statments is in use, if set to ON.
#;
#define	MVEmuFLAGHEADERBRK	$$$MVEmuFLAGBASE + 75
#; 
#; Indicate that dates and times in headers or fotters are in D2- (fixed length)
#; format rather than varible (D) format.
#;
#define	MVEmuFLAGHEADERDATE	$$$MVEmuFLAGBASE + 76
#; 
#; Indicate that a single parameter substring extract [nn] assumes a length
#; of 1 character rather than that postion to the end of the string.
#; 
#define	MVEmuFLAGSTRONEISONE	$$$MVEmuFLAGBASE + 77
#define	MVEmuFLAGIN2SUBSTR	$$$MVEmuFLAGBASE + 77
#; 
#; Indicate that RAISE and LOWER use a limited range of delimiters in the
#; same way as PI/Open does. When set to on this flag restricts raise and
#; lower characters to CHAR(252) to CHAR(255). When OFF, the character range
#; translated is CHAR(248) to CHAR(255)
#; 
#define	MVEmuFLAGSMALLRAISE	$$$MVEmuFLAGBASE + 78
#define	MVEmuFLAGINFOMARKS	$$$MVEmuFLAGBASE + 78
#; 
#; Indicates (ON) that if select list 0 (default select list) is already
#; active (has values) then a subsequent SELECT is not performed and 
#; select list 0 remains active. I think that htis is a bg in PICK that the
#; UniVerse guys are not emulating correctly anyway. It is here but not
#; acted upon for the moment.
#;
#define	MVEmuFLAGNORESELECT	$$$MVEmuFLAGBASE + 79
#; 
#; Indicates (ON) that ON GOTO and ON GOSUB statments that receive values that
#; are out of range for the control variable just ignore the GOSUB or GOTO and
#; move on to the next line. If this is set to OFF then if the value is too
#; small the first brnach is taken and if too big then the last branch is taken.
#; 
#define	MVEmuFLAGONGORANGE	$$$MVEmuFLAGBASE + 80
#; 
#; Indicates (ON) that the PRINTER close statement closes ALL print channels
#; and not just channel 1.
#; 
#define	MVEmuFLAGPCLOSEALL	$$$MVEmuFLAGBASE + 81
#; 
#; Indicates (ON) that the MATREAD statement will first set all values of the
#; target array to empty strings "" before reading the data values. In actual
#; fact we jsut set any values that are not touched by the MATREAD to "" or
#; this would be nuts.
#;
#define	MVEmuFLAGMATREADEMPTY	$$$MVEmuFLAGBASE + 82
#define MVEmuFLAGPIOPENMATREAD	$$$MVEmuFLAGBASE + 82
#;
#; Indicates (ON) that terminal output is not automatically translated into
#; printable characters which happens in some emulations.
#; 
#define	MVEmuFLAGRAWOUTPUT	$$$MVEmuFLAGBASE + 83
#;
#; Indicates (ON) that the emulations supports negative subscripts in string
#; extractions, as per Reality/ROS.
#;
#define	MVEmuFLAGREALSUBSTR	$$$MVEmuFLAGBASE + 84
#; 
#; Indicates (ON) that a SEQ("") [empty string] shoudl return 255 and not
#; a 0.
#; 
#define	MVEmuFLAGSEQ255		$$$MVEmuFLAGBASE + 85
#;
#; Indicates (ON) that STOP and ABORT statements use the ERRMSG file rather
#; than just print the string they are given.
#; 
#define	MVEmuFLAGSTOPMSG	$$$MVEmuFLAGBASE + 86
#;
#; Indicates (ON) that the PRINTERR statement should consult the ERRMSG
#; file to print messages ratehr than just using literal strings
#; 
#define	MVEmuFLAGUSEERRMSG	$$$MVEmuFLAGBASE + 87
#;
#; Indicates (ON) that the INPUT statement does not echo data that comes from a
#; DATA statement.
#; 
#define	MVEmuFLAGSUPPDATAECHO	$$$MVEmuFLAGBASE + 88
#;
#; Indicate that SYSTEM(12) and other related functions such as TIME()
#; work as per Reality/Pick an return values in milliseconds rather than
#; the strange way that UniVerse does it.
#; 
#define	MVEmuFLAGTIME10100		$$$MVEmuFLAGBASE + 89
#define	MVEmuFLAGTIMEMILLISECOND	$$$MVEmuFLAGBASE + 89
#;
#; Indicates 0 that the SELECT statement behaves as SELECTN
#;	     1 that the SELECT statement behaves as SELECTV
#;	     2 that the SELECT statement tries to disambiguate, like UD does
#;
#define	MVEmuFLAGVARSELECT		$$$MVEmuFLAGBASE + 90
#;
#; Indicates (ON) that name(expr) is treated as FMT(name,expr) if name is
#; not a DIM'ed array
#;
#define	MVEmuFLAGARRAYISFMT		$$$MVEmuFLAGBASE + 91
#;
#; Indicates (ON) that the length comversion with a single parameter
#; should treat that as a max lenght rather that a length to equal.
#;
#define	MVEmuFLAGLENCNVONEMAX		$$$MVEmuFLAGBASE + 92
#;
#; Indicates (ON) that the returning clause on execute returns the 
#; value of SYSTEM.RETURN.CODE (universe) rather than the error string.
#; and since I invented the returning clause - Universe got it wrong.
#;
#define	MVEmuFLAGRETURNINGCODE		$$$MVEmuFLAGBASE + 93
#;
#; Indicates (ON) that the terminal output from the PHANTOM command, or
#; similar commands (ZH, PH-START) goes to the spooler. If
#; set OFF, then the terminal output goes to the &PH& file.
#;
#define	MVEmuFLAGPHANTOMTOSPOOLER	$$$MVEmuFLAGBASE + 94
#;
#; Indicates (ON) that MX conversions should be treated as MCDX rather than
#; an ASCII HEX conversion. Another Universe error :(
#;
#define	MVEmuFLAGMXISMCDX		$$$MVEmuFLAGBASE + 95
#;
#; Indicates (ON) that READNEXT returns exploded values in the ID
#;
#define	MVEmuFLAGRNEXTEXPL		$$$MVEmuFLAGBASE + 96
#;
#; Indicates (ON) that ENTER is a synonym for CALL
#;
#define	MVEmuFLAGPIOPENENTER		$$$MVEmuFLAGBASE + 97
#;
#; Indicates (ON) that we are compiling I-types
#;
#define	MVEmuFLAGITYPE			$$$MVEmuFLAGBASE + 98
#;
#; Indicates (ON) that we are * / + - should be compiled as vector arithmetic
#;
#define	MVEmuFLAGVECMATH		$$$MVEmuFLAGBASE + 99
#;
#; Indicates (ON) that LOCATE uses the PRIME / INFORMATION style syntax instead
#; of the REALITY syntax
#;
#define	MVEmuFLAGINFOLOCATE		$$$MVEmuFLAGBASE + 100
#;
#; Indicates (ON) that conversions from string to numeric, integer, or boolean
#; use the slower, inconsistent MV/Pick rules like UniVerse and UniData
#; instead of the standard, fast and consistent COS rules.
#;
#define	MVEmuFLAGPICKCONVERT		$$$MVEmuFLAGBASE + 101
#;
#; Indicates (ON) that implicit FMT operator is not allowed
#; (i.e. expr1 expr2 will give an error, not act like FMT(expr1,expr2)
#;
#define	MVEmuFLAGNOIMPLICITFMT		$$$MVEmuFLAGBASE + 102
#;
#; Indicates (ON) that single quoted strings are always assumed to be item IDs
#; and are not allowed in expressions like: WITH A = '99'
#;
#define	MVEmuFLAGSINGLEQUOTEIDONLY	$$$MVEmuFLAGBASE + 103
#;
#; Indicates (ON) that Pick style print limiters are not allowed, i.e.
#; LIST FILE F1="K" is not allowed.
#;
#define	MVEmuFLAGNOPRINTLIMITERS	$$$MVEmuFLAGBASE + 104
#;
#; Indicates (ON) that unquoted operands are not allowed.  Otherwise, unquoted
#; operands are allowed when they are not ambiguous:
#; LIST FILE WITH F1 = A
#; rather than:
#; LIST FILE WITH F1 = "A"
#;
#define	MVEmuFLAGNOUNQUOTEDOPERANDS	$$$MVEmuFLAGBASE + 105
#;
#; 0 indicates that we use UniVerse(Prime?) style pattern matching in queries,
#; 1 indicates that we use Pick style pattern matching in queries,
#; 2 indicates that we can't decide, so we try to accept both...
#;
#define	MVEmuFLAGPATTERNMATCH		$$$MVEmuFLAGBASE + 106
#;
#; Indicates (ON) that trigonometric functions are in radians instead of degrees.
#;
#define	MVEmuFLAGRADIANS		$$$MVEmuFLAGBASE + 107
#;
#; 0 indicates no WITH default allowed
#; 1 indicates OR is the WITH default
#; 2 indicates AND is the WITH default
#define	MVEmuFLAGWITHDEFAULT		$$$MVEmuFLAGBASE + 108
#;
#; Indicates that the default (internal) list is list # 10, not # 0
#;
#define	MVEmuFLAGPICKSELECT		$$$MVEmuFLAGBASE + 110
#;
#; Indicates REMOVE statement behavior
#;
#define	MVEmuFLAGREMOVE			$$$MVEmuFLAGBASE + 111
#;
#; Indicates that we default to Normal Catalog rather than local
#;
#define	MVEmuFLAGCATDFLTNORMAL		$$$MVEmuFLAGBASE + 112
#;
#; Indicates that we default to Normal Catalog rather than local
#;
#define	MVEmuFLAGPARASENTPARAPROCONLY		$$$MVEmuFLAGBASE + 113
#;
#; Indicates that we don't stack @COMMAND and @SENTENCE 
#;
#define	MVEmuFLAGNOSTACKCMDSENT		$$$MVEmuFLAGBASE + 114
#;
#; Indicates BREAK with no argument is a synonym for EXIT
#;
#define	MVEmuFLAGBREAKISEXIT		$$$MVEmuFLAGBASE + 115
#;
#; Indicates EXIT n sets return code to n and STOPs
#;
#define	MVEmuFLAGARGEXITISSTOP		$$$MVEmuFLAGBASE + 116
#;
#; Indicates what length to use when FOLD length is less than 1
#;
#; 0 means treat as an error and return "" (the default behavior)
#; 1 is the JBASE behavior (use length=1)
#; 2 is the D3 behavior
#;
#define	MVEmuFLAGFOLDLEN		$$$MVEmuFLAGBASE + 117
#;
#; Indicates the FOLD delimiter should be @VM instead of @AM
#;
#define	MVEmuFLAGFOLDDELIMVM		$$$MVEmuFLAGBASE + 118
#;
#; Indicates of the range @(-128) through @(-191) are valid codes
#; for terminal emulation. Because it is a large range, we do it like
#; this instead of adding huge numbers to the MV_EMU_AT_xxx values.
#;
#define	MVEmuFLAGFLATAT128TO191		$$$MVEmuFLAGBASE + 119
#;
#; Indicates that CHAIN does not pass unnamed COMMON unless
#; the (I) option is given.  Otherwise it always passes it.
#;
#define	MVEmuFLAGCHAINI		$$$MVEmuFLAGBASE + 120
#;
#; Indicates the the use of CTRL<C> with the BREAK ON and
#; BREAK OFF statements (and TCL commands) is stacked/incremented
#; so if you BREAK OFF 3 times, you need BREAK ON 3 times to restore it.
#;
#define	MVEmuFLAGBREAKSTACK		$$$MVEmuFLAGBASE + 121
#;
#; Indicates that the StringToChange argument of the CONVERT function
#; is first instead of last.
#;
#define	MVEmuFLAGCONVERTSTR1		$$$MVEmuFLAGBASE + 122
#;
#; Indicates that attribute # <= 0 is treated as 1 (i.e. Unidata) 
#;
#define	MVEmuFLAGATTR0IS1		$$$MVEmuFLAGBASE + 123
#;
#; Indicates that the SETPTR command keeps some of the characteristics
#; of the terminal/printer if not explicitly specified (i.e. Unidata)
#;
#define	MVEmuFLAGSETPTRKEEP		$$$MVEmuFLAGBASE + 124
#;
#; Indicates that the when a Basic program exits that select list 0 should be
#; preserved. This in effect forces a K option on every basic program
#;
#define	MVEmuFLAGKEEPLIST0		$$$MVEmuFLAGBASE + 125
#;
#; Indicates that when SAVE-LIST is performed without an active list then
#; any pre-existing list of that name should be deleted
#;
#define	MVEmuFLAGEMPTYSAVELISTDELETES		$$$MVEmuFLAGBASE + 126
#;
#; Indicates that dynamic arrays should be reselected even if
#; no reselect is active
#define MVEmuFLAGARRAYRESELECT	$$$MVEmuFLAGBASE + 127
#;
#; Indicates that jBASE rules should be used for select lists
#;
#define	MVEmuFLAGJBASESELECT   	$$$MVEmuFLAGBASE + 128
#;
#; Shows the behaviour of the spooler when jobs are
#; created and destroyed.
#;
#define MVEmuFLAGSPOOLERCONDUCT1    $$$MVEmuFLAGBASE + 129
#;
#; Set to allow unquoted item IDs in CMQL
#;
#define MVEmuFLAGUNQUOTEDITEMDS    $$$MVEmuFLAGBASE + 130
#;
#; Value to control the style of CMQL listings
#;
#define MVEmuFLAGSCMQLSTYLE    $$$MVEmuFLAGBASE + 131
#;
#; Shows the behaviour of the spooler when jobs are
#; created and destroyed. Overflow from SPOOLERCONDUCT
#; as we only have 8 bits.
#;
#define MVEmuFLAGSPOOLERCONDUCT2    $$$MVEmuFLAGBASE + 132
#;
#; set to make right justified fields in CMQL wrap rather than overwrite to the left
#;
#define MVEmuFLAGSRIGHTJUSTWRAP    $$$MVEmuFLAGBASE + 133
#;
#; Binary values to determine the behaviour of INPUT AT
#;
#define	MVEmuFLAGINPUTAT		$$$MVEmuFLAGBASE + 134
#define	InputAtInitialDisplay		1
#define	InputAtRespectEcho		2
#define	InputAtEndRedisplayAlways	4
#define	InputAtEndRedisplayPad		8
#;
#; Set if we echo data using the KEYIN() function.
#;
#define	MVEmuFLAGECHOKEYIN	$$$MVEmuFLAGBASE + 135
#;
#; Set if we display the "Press any key to continue" prompt
#;
#define	MVEmuFLAGPAGEPROMPT	$$$MVEmuFLAGBASE + 136
#;
#; Define the behaviour of the 'P' token in the HEADING statement
#;
#define	MVEmuFLAGPHEADING	$$$MVEmuFLAGBASE + 137
#;
#; Define if the INPUTERR statement should clear any type ahead
#;
#define	MVEmuFLAGINPUTERRCLEAR	$$$MVEmuFLAGBASE + 138
#;
#; Define if the ITYPE compiler should use UNIDATA rules for TRANS.
#;
#define	MVEmuFLAGUDITYPE	$$$MVEmuFLAGBASE + 139
#;
#; Define if the "BANNER UNIQUE" tokens for SETPTR should be the same as "BANNER NEXT".
#;
#define	MVEmuFLAGUDBANNERUNIQUE $$$MVEmuFLAGBASE + 140

#;
#; Define (inuse)
#;
#;define	MVEmuFLAG??	$$$MVEmuFLAGBASE + 141
#;
#; Define 
#;
#;define	MVEmuFLAG?? $$$MVEmuFLAGBASE + 142

#;
#; Indicates that ICONV should treat a six digit date as one with null separators
#; ie MMDDYY rather than a YYMMDD standard date. A UNIDATA 'feature'
#;
#define	MVEmuFLAGICONVSIXDIGITDATE	$$$MVEmuFLAGBASE + 143
#;
#; Indicates that MD and MR and R mask should convert null to zero
#;
#define	MVEmuFLAGMASKNULLTOZERO $$$MVEmuFLAGBASE + 144
#;
#; Indicates that MD and MR and R mask should convert null to zero
#;
#define	MVEmuFLAGCONVNULLTOZERO $$$MVEmuFLAGBASE + 145
#;
#; Shows the filtering options for the INPUT statement when control
#; character filtering is enabled (INPUTCTRL ON or CONTROL.CHARS (F))
#;
#define	MVEmuFLAGINPUTCTRL	$$$MVEmuFLAGBASE + 146
#;
#; Indicates that READNEXT should decrement the list count
#;
#define MVEmuFLAGREADNEXTDECCNT            	$$$MVEmuFLAGBASE + 147
#;
#; Indicates that MATBUILD should give an error on unassigned nodes
#;
#define MVEmuFLAGMATBLDUNASSERR             	$$$MVEmuFLAGBASE + 148
#;
#; Indicates that vertical bar, | , is source continuation     // SOH229+
#;
#define MVEmuFLAGCONTINUEVBAR               	$$$MVEmuFLAGBASE + 149
#;
#; Indicates that backslash, \, is source continuation
#;
#define MVEmuFLAGCONTINUEBSLASH             	$$$MVEmuFLAGBASE + 150
#;
#; GGC458 Indicates if we allow single level files.
#; For example 'CREATE.FILE DICT GREG', on some systems creates
#;   a 'single level file' meaning the DICT and DATA are the same. */
#;
#define MVEmuFLAGSINGLELEVELFILE           	$$$MVEmuFLAGBASE + 151
#;
#; GGC460 Shows the behaviour of the spooler when jobs are
#; created and destroyed. Overflow from SPOOLERCONDUCT
#; as we only have 8 bits.
#;
#define MVEmuFLAGSPOOLERCONDUCT3    		$$$MVEmuFLAGBASE + 152
#;
#; GGC472 Indicates if a "PRINT ON channel EXPRESSION" statement
#; needs to have the printer turned on before output to the spooler.
#;
#define	MVEmuFLAGPRINTONNEEDSPRINTER		$$$MVEmuFLAGBASE + 153
#;
#; Indicates if a leading * should be removed before looking for a 
#; global catalog entry.
#;
#define	MVEmuFLAGSTRIPLEADINGASTK			$$$MVEmuFLAGBASE + 154
#;
#; ===================================================================
#; Definitions used by BUILD.CLASS to provide additional information
#; about a DICTIONARY entry, such as the data type and so on. These are
#; sub nodes of the rutime variable dictionary in BUILDCLASS^%SYS.MVI
#;
#; How to produce a valid class or property name from an MV name.
#;
#define VALIDCPNAME(%name) $zu(198,6,%name)
#;
#;Alternate way to produce a valid class or property name from an MV name using CamelCase.
#;
#define CAMELCPNAME(%name) $zu(198,7,%name)
#;
#; Where to store the finally derived data type after analysis. If the
#; type is set in stone in the dictionary, then this will be just the
#; type as indicated in the dictionary itself.
#;
#define MVDICTDATATYPE			1
#;
#; Where to store the property name after converting to a valid
#; property name.
#;
#define MVDICTPROPNAME			2
#;
#; ===================================================================
#;
#; PROC file buffer support (first pass)
#;
#define	MVPFileIdGet(%buf)	$G(%MVPFileBuffer(0,%buf))
#define	MVPFileBufferGet(%buf)	$G(%MVPFileBuffer(1,%buf))
#define	MVPFileOrefGet(%buf)	$G(%MVPFileBuffer(2,%buf))
#define	MVPFileId(%buf)		%MVPFileBuffer(0,%buf)
#define	MVPFileBuffer(%buf)	%MVPFileBuffer(1,%buf)
#define	MVPFileOref(%buf)	%MVPFileBuffer(2,%buf)
#;
#; PROC flags (or'ed together, use $ZB[oolean] to access
#;
#; Use @FM (field mark) between parameters instead of space
#define	PQUSESFM	1
#;
#; Parse single quotes
#define	PQSINGLEQ	2
#;
#; Parse all quotes (and backslashes)
#define	PQALLQUOTES	4
#;
#; Check quotes (either single or all)
#define	PQQUOTES	6
#;
#; PQN proc (run-time only flag)
#define	PQPQN		8
#;
#; Indicate whether PQ procs will extend buffers that are reference beyond
#; the last parameter currently in the buffer. If buffers are extended they
#; are padded with / delimiters.
#; 
#define	PQBUFEXTEND	16
#; 
#; Indicate whether the PQ Proc PIB is left unchanged (ON setting)
#; if the user enters the empty string in an IP command.
#; 
#define	PQPRSRVPIB	32
#;
#; IH in PIB clears SIB
#;
#define	PQIHCLRSIB	64
#;
#; Ignore embedded quotes (only handle initial quotes)
#define	PQEMBEDQ	128
#;
#; Strip leading spaces on D0
#define	PQD0STRIP	256
#;
#; Strip quotes on Dn
#define	PQDNSTRIPQ	512
#;
#; H text << has special meaning
#;
#define	PQHLESSLESS	1024
#;
#; P resets input buffers
#define	PQPRESETIB	2048
#;
#; A strips blanks
#define	PQASTRIPB	4096
#;
#; A,p means , is the delimiter and p position
#define	PQACOMMASEP	8192
#;
#; S+n is read as Sn
#define	PQPLUSN		16384
#;
#; Single blanks delimit fields
#define	PQSINGLEB	32768
#;
#; D converts system delimiters
#define	PQDCVT		65536
#;
#; Trailing delimiter always
#define	PQTRAILINGD	131072
#;
#; Leading delimiter always
#define	PQLEADINGD	262144
#;
#; LF is converted to @AM
#define	PQLFISAM	524288
#;
#; A with blank treated same as A with no delimiter
#define	PQBLANKDEF	8388608
#;
#; F extends buffer
#define	PQFEXTEND	16777216
#;
#; An doesn't move to next parameter
#define	PQANOMOVE	33554432
#;
#; RETURN (< on H) is @AM
#define	PQRETISAM	67108864
#;
#; Retain select list with P command
#define	PQRETAINLIST	134217728
#;
#; Convert @AM to space in PROCWRITE
#define	PQPWAMTOSPC	268435456
#;
#; Don't expand ;
#define	PQNOEXPSEMI	536870912
#;
#; Abort on N in P command response
#define	PQPABORTONN	1073741824
#;
#; PW needs a newline for input (jBASE compatibility)
#define PQPNEEDNL	2147483648
#;
#; PQX is really PQN
#define	PROCFlgPQXISPQN		1
#;
#; Ignore N, treat PQN as PQ
#;
#define	PROCFlgIGNOREPQN	2
#;
#; Does this proc use @FM (either UV style PROC or PQN)?
#define	PROCUSESFM	$ZB($$$MVPFlags,$$$PQUSESFM,1)
#;
#; Terminal Independence Definitions.
#; ----------------------------------
#;
#; TIBooLen     Length of each boolean segment in a compiled Terminal string
#define     TIBooLen            1
#; TINumLen     Length of each numeric segment in a compiled Terminal string
#define     TINumLen            6
#; TIStrLen     Length of each string segment in a compiled Terminal string
#define	TIStrName				1
#;
#; The layout of the compiled terminal string is as follows ...
#; TERNAME       1 entry        Length $$$TIStrLen			The name of the terminal definition
#; REVISION		 1 entry		Length 2 bytes				Revision of layout of compiled defs
#; HEADER		 1 entry		Length 94 bytes				General header information
#; BOOLS		64 enties		Each length $$$TIBooLen		Boolean values
#; NUMS			64 entries		Each length $$$TINumLen		Numeric values
#; STRS			512 entries		Each length 3				Header defining the string
#; DATA			???				???							The actual strings
#;
#; TIRevisionOffset	Offset of the start of the 2 character revision header
#define		TIRevisionOffset	33
#;
#; TITermTypeCharOffset		Offset of the single character short name for a terminal type
#define	TITermTypeCharOffset	35
#;
#; TIDescriptionOffset		Offset of the description of the terminal for 32 characters
#define	TIDescriptionOffset		36
#;
#; TIHeaderOffset	Offset of the start of the rest of the header
#define		TIHeaderOffset		68
#;
#; TIBooleanOffset	Offset of the start of the 64 boolean values each one character
#define		TIBooleanOffset		129
#;
#; TINumericOffset	Offset of the start of the 64 numeric values each 6 characters
#define		TINumericOffset		193
#;
#; TIStringOffset	Offset of the start of the 512 headers each of 3 characters
#define		TIStringOffset		577
#;
#; TIBooleanQty		Maximum number of boolean values
#define		TIBooleanQty		64
#;
#; TIIntegerQty		Maximum number of integer values
#define		TIIntegerQty		64
#;
#; TIStringQty		Maximum number of strings
#define		TIStringQty			512
#;
#; Boolean values
#; --------------
#; TIBooAM			terminal has automatic margins
#define	TIBooAM			1
#; TIBooBCE			screen erased with background colour
#define	TIBooBCE		2
#; TIBooBW			cub1 wraps from column 0 to last column
#define	TIBooBW			3
#; TIBooCCC			terminal can redefine existing colours
#define	TIBooCCC		4
#; TIBooCHTS		colour is hard to see
#define	TIBooCHTS		5
#; TIBooCPIX		changing character pitch changes resolution
#define	TIBooCPIX		6
#; TIBooCRXM		using cr turns off micro mode
#define	TIBooCRXM		7
#; TIBooDA			display may be retained above the screen
#define	TIBooDA			8
#; TIBooDAISY		printer needs operator to change character set
#define	TIBooDAISY		9
#; TIBooDB			display may be retained below the screen
#define	TIBooDB			10
#; TIBooEO			can erase overstrikes with a blank
#define	TIBooEO			11
#; TIBooESLOK		escape can be used on the status line
#define	TIBooESLOK		12
#; TIBooGN			generic line type
#define	TIBooGN			13
#; TIBooHC			hardcopy terminal
#define	TIBooHC			14
#; TIBooHLS			terminal uses only HLS color notation (Tektronix)
#define	TIBooHLS		15
#; TIBooHS			has extra status line
#define	TIBooHS			16
#; TIBooHZ			cannot print special characters (hazeltine)
#define	TIBooHZ			17
#; TIBooIN			inset mode distinguishes nulls
#define	TIBooIN			18
#; TIBooKM			has a meta-key (i.e., sets 8th-bit)
#define	TIBooKM			19
#; TIBooLPIX		changing line pitch changes resolution
#define	TIBooLPIX		20
#; TIBooMC5I		printer will not echo on screen
#define	TIBooMC5I		21
#; TIBooMIR			safe to move while in insert mode
#define	TIBooMIR		22
#; TIBooMSGR		safe to move while in standout mode
#define	TIBooMSGR		23
#; TIBooNDSCR		scrolling region is non destructive
#define	TIBooNDSCR		24
#; TIBooNPC			pad character does not exist
#define	TIBooNPC		25
#; TIBooNRRCM		smcup does not reverse rmcup
#define	TIBooNRRCM		26
#; TIBooNXON		padding will not work, xon-xoff required
#define	TIBooNXON		27
#; TIBooOS			terminal can overstrike
#define	TIBooOS			28
#; TIBooSAM			printing in last column causes cr
#define	TIBooSAM		29
#; TIBooUL			underline character causes overstrikes
#define	TIBooUL			30
#; TIBooXENL		newline ignored after 80 columns
#define	TIBooXENL		31
#; TIBooXHP			standout not erased by overwriting (hp)
#define	TIBooXHP		32
#; TIBooXHPA		only positive motion for hpa/mhpa caps
#define	TIBooXHPA		33
#; TIBooXON			terminal uses xon-xoff 
#define	TIBooXON		34
#; TIBooXSB			beehive (f1=escape,f2=ctrl C)
#define	TIBooXSB		35
#; TIBooXT			tabs destructive
#define	TIBooXT			36
#; TIBooXVPA		only positive motion for vpa/mvpa caps
#define	TIBooXVPA		37
#; TIBooXPickColors	If using Pick color code sequences
#define	TIBooXPickColors	38
#;
#; Numeric values
#; --------------
#;
#; TINumBitwin       number of passes for each bit-image row
#define	TINumBitwin		1
#; TINumBitype       type of bit-image device
#define	TINumBitype		2
#; TINumBtns         number of buttons on mouse
#define	TINumBtns		3
#; TINumBufsz        numbers of bytes buffered before printing
#define	TINumBufsz		4
#; TINumColors       maximum number of colors on screen
#define	TINumColors		5
#; TINumCols         number of columns in a line
#define	TINumCols		6
#; TINumCps          print rate in char-acters per second
#define	TINumCps		7
#; TINumIt           tabs initially every # spaces
#define	TINumIt			8
#; TINumLh           rows in each label
#define	TINumLh			9
#; TINumLines        number of lines on screen or page
#define	TINumLines		10
#; TINumLm           lines of memory if > line. 0 means varies
#define	TINumLm			11
#; TINumLw           columns in each label
#define	TINumLw			12
#; TINumMa           maximum combined attributes terminal can handle
#define	TINumMa			13
#; TINumMaddr        maximum value in micro_..._address
#define	TINumMaddr		14
#; TINumMcs          character step size when in micro mode
#define	TINumMcs		15
#; TINumMjump        maximum value in parm_..._micro
#define	TINumMjump		16
#; TINumMls          line step size when in micro mode
#define	TINumMls		17
#; TINumNcv          video attributes that cannot be used with colors
#define	TINumNcv		18
#; TINumNlab         number of labels on screen
#define	TINumNlab		19
#; TINumNpins        numbers of pins in print-head
#define	TINumNpins		20
#; TINumOrc          horizontal resolu-tion in units per line
#define	TINumOrc		21
#; TINumOrhi         horizontal resolu-tion in units per inch
#define	TINumOrhi		22
#; TINumOrl          vertical resolution in units per line
#define	TINumOrl		23
#; TINumOrvi         vertical resolution in units per inch
#define	TINumOrvi		24
#; TINumPairs        maximum number of color-pairs on the screen
#define	TINumPairs		25
#; TINumPb           lowest baud rate where padding needed
#define	TINumPb			26
#; TINumSpinh        spacing of dots hor-izontally in dots per inch
#define	TINumSpinh		27
#; TINumSpinv        spacing of pins ver-tically in pins per inch
#define	TINumSpinv		28
#; TINumVt           virtual terminal number (CB/unix)
#define	TINumVt			29
#; TINumWidcs        character step size when in double wide mode
#define	TINumWidcs		30
#; TINumWnum         maximum number of defineable windows
#define	TINumWnum		31
#; TINumWsl          number of columns in status line
#define	TINumWsl		32
#; TINumXmc          number of blank characters left by smso or rmso
#define	TINumXmc		33
#;
#; String values
#; -------------
#; The TIStrXXX values are the relative entry in the compiled Terminal string.
#;
#; TIStrAcsc         graphics charset pairs, based on vt100
#define	TIStrAcsc		1
#; TIStrBel          audible signal (bell) (P)
#define	TIStrBel		2
#; TIStrBicr         Move to beginning of same row
#define	TIStrBicr		3
#; TIStrBinel        Move to next row of the bit image
#define	TIStrBinel		4
#; TIStrBirep        Repeat bit image cell #1 #2 times
#define	TIStrBirep		5
#; TIStrBlink        turn on blinking
#define	TIStrBlink		6
#; TIStrBold         turn on bold (extra bright) mode
#define	TIStrBold		7
#; TIStrCbt          back tab (P)
#define	TIStrCbt		8
#; TIStrChr          Change horizontal resolution to #1
#define	TIStrChr		9
#; TIStrCivis        make cursor invisi-ble
#define	TIStrCivis		10
#; TIStrClear        clear screen and home cursor (P*)
#define	TIStrClear		11
#; TIStrCmdch        terminal settable cmd character in prototype !?
#define	TIStrCmdch		12
#; TIStrCnorm        make cursor appear normal (undo civis/cvvis)
#define	TIStrCnorm		13
#; TIStrColornm      Give name for color #1
#define	TIStrColornm		14
#; TIStrCpi          Change number of characters per inch to #1
#define	TIStrCpi		15
#; TIStrCr           carriage return (P*) (P*)
#define	TIStrCr		16
#; TIStrCsin         Init sequence for multiple codesets
#define	TIStrCsin		17
#; TIStrCsnm         Produce #1'th item from list of char-acter set names
#define	TIStrCsnm		18
#; TIStrCsr          change region to line #1 to line #2 (P)
#define	TIStrCsr		19
#; TIStrCub          move #1 characters to the left (P)
#define	TIStrCub		20
#; TIStrCub1         move left one space
#define	TIStrCub1		21
#; TIStrCud          down #1 lines (P*)
#define	TIStrCud		22
#; TIStrCud1         down one line
#define	TIStrCud1		23
#; TIStrCuf          move #1 characters to the right (P*)
#define	TIStrCuf		24
#; TIStrCuf1         non-destructive space (move right one space)
#define	TIStrCuf1		25
#; TIStrCup          move to row #1 columns #2
#define	TIStrCup		26
#; TIStrCuu          up #1 lines (P*)
#define	TIStrCuu		27
#; TIStrCuu1         up one line
#define	TIStrCuu1		28
#; TIStrCvr          Change vertical res-olution to #1
#define	TIStrCvr		29
#; TIStrCvvis        make cursor very visible
#define	TIStrCvvis		30
#; TIStrCwin         define a window #1 from #2,#3 to #4,#5
#define	TIStrCwin		31
#; TIStrDch          delete #1 characters (P*)
#define	TIStrDch		32
#; TIStrDch1         delete character (P*)
#define	TIStrDch1		33
#; TIStrDclk         display clock
#define	TIStrDclk		34
#; TIStrDefbi        Define rectan-gualar bit image region
#define	TIStrDefbi		35
#; TIStrDefc         Define a character #1, #2 dots wide, descender #3
#define	TIStrDefc		36
#; TIStrDevt         Indicate lan-guage/codeset sup-port
#define	TIStrDevt		37
#; TIStrDial         dial number #1
#define	TIStrDial		38
#; TIStrDim          turn on half-bright mode
#define	TIStrDim		39
#; TIStrDispc        Display PC charac-ter #1
#define	TIStrDispc		40
#; TIStrDl           delete #1 lines (P*)
#define	TIStrDl		41
#; TIStrDl1          delete line (P*)
#define	TIStrDl1		42
#; TIStrDocr         Printing any of these characters causes CR
#define	TIStrDocr		43
#; TIStrDsl          disable status line
#define	TIStrDsl		44
#; TIStrEch          erase #1 characters (P)
#define	TIStrEch		45
#; TIStrEd           clear to end of screen (P*)
#define	TIStrEd		46
#; TIStrEhhlm        Enter horizontal highlight mode
#define	TIStrEhhlm		47
#; TIStrEl           clear to end of line (P)
#define	TIStrEl		48
#; TIStrEl1          Clear to beginning of line
#define	TIStrEl1		49
#; TIStrElhlm        Enter left highlight mode
#define	TIStrElhlm		50
#; TIStrElohlm       Enter low highlight mode
#define	TIStrElohlm		51
#; TIStrEnacs        enable alternate char set
#define	TIStrEnacs		52
#; TIStrEndbi        End a bit-image region
#define	TIStrEndbi		53
#; TIStrErhlm        Enter right high-light mode
#define	TIStrErhlm		54
#; TIStrEthlm        Enter top highlight mode
#define	TIStrEthlm		55
#; TIStrEvhlm        Enter vertical high-light mode
#define	TIStrEvhlm		56
#; TIStrFf           hardcopy terminal page eject (P*)
#define	TIStrFf		57
#; TIStrFlash        visible bell (may not move cursor)
#define	TIStrFlash		58
#; TIStrFln          label format
#define	TIStrFln		59
#; TIStrFsl          return from status line
#define	TIStrFsl		60
#; TIStrGetm         Curses should get button events, parameter #1 not documented.
#define	TIStrGetm		61
#; TIStrHd           half a line down
#define	TIStrHd		62
#; TIStrHome         home cursor (if no cup)
#define	TIStrHome		63
#; TIStrHook         flash switch hook
#define	TIStrHook		64
#; TIStrHpa          horizontal position #1, absolute (P)
#define	TIStrHpa		65
#; TIStrHt           tab to next 8-space hardware tab stop
#define	TIStrHt		66
#; TIStrHts          set a tab in every row, current columns
#define	TIStrHts		67
#; TIStrHu           half a line up
#define	TIStrHu		68
#; TIStrHup          hang-up phone
#define	TIStrHup		69
#; TIStrIch          insert #1 characters (P*)
#define	TIStrIch		70
#; TIStrIch1         insert character (P)
#define	TIStrIch1		71
#; TIStrIf           name of initializa-tion file
#define	TIStrIf		72
#; TIStrIl           insert #1 lines (P*)
#define	TIStrIl		73
#; TIStrIl1          insert line (P*)
#define	TIStrIl1		74
#; TIStrInd          scroll text up (P)
#define	TIStrInd		75
#; TIStrIndn         scroll forward #1 lines (P)
#define	TIStrIndn		76
#; TIStrInitc        initialize color #1 to (#2,#3,#4)
#define	TIStrInitc		77
#; TIStrInitp        Initialize color pair #1 to fg=(#2,#3,#4), bg=(#5,#6,#7)
#define	TIStrInitp		78
#; TIStrInvis        turn on blank mode (characters invisi-ble)
#define	TIStrInvis		79
#; TIStrIp           insert padding after inserted character
#define	TIStrIp		80
#; TIStrIprog        path name of program for initialization
#define	TIStrIprog		81
#; TIStrIs1          initialization string
#define	TIStrIs1		82
#; TIStrIs2          initialization string
#define	TIStrIs2		83
#; TIStrIs3          initialization string
#define	TIStrIs3		84
#; TIStrKa1          upper left of keypad
#define	TIStrKa1		85
#; TIStrKa3          upper right of key-pad
#define	TIStrKa3		86
#; TIStrKb2          center of keypad
#define	TIStrKb2		87
#; TIStrKbeg         begin key
#define	TIStrKbeg		88
#; TIStrKbeg         shifted begin key
#define	TIStrKSbeg		89
#; TIStrKbs          backspace key
#define	TIStrKbs		90
#; TIStrKc1          lower left of keypad
#define	TIStrKc1		91
#; TIStrKc3          lower right of key-pad
#define	TIStrKc3		92
#; TIStrKcan         cancel key
#define	TIStrKcan		93
#; TIStrKcan         shifted cancel key
#define	TIStrKScan		94
#; TIStrKcbt         back-tab key
#define	TIStrKcbt		95
#; TIStrKclo         close key
#define	TIStrKclo		96
#; TIStrKclr         clear-screen or erase key
#define	TIStrKclr		97
#; TIStrKcmd         command key
#define	TIStrKcmd		98
#; TIStrKcmd         shifted command key
#define	TIStrKScmd		99
#; TIStrKcpy         copy key
#define	TIStrKcpy		100
#; TIStrKcpy         shifted copy key
#define	TIStrKScpy		101
#; TIStrKcrt         create key
#define	TIStrKcrt		102
#; TIStrKcrt         shifted create key
#define	TIStrKScrt		103
#; TIStrKctab        clear-tab key
#define	TIStrKctab		104
#; TIStrKcub1        left-arrow key
#define	TIStrKcub1		105
#; TIStrKcud1        down-arrow key
#define	TIStrKcud1		106
#; TIStrKcuf1        right-arrow key
#define	TIStrKcuf1		107
#; TIStrKcuu1        up-arrow key
#define	TIStrKcuu1		108
#; TIStrKdc          shifted delete-char-acter key
#define	TIStrKSdc		109
#; TIStrKdch1        delete-character key
#define	TIStrKdch1		110
#; TIStrKSdl          shifted delete-line key
#define	TIStrKSdl		111
#; TIStrKdl1         delete-line key
#define	TIStrKdl1		112
#; TIStrKed          clear-to-end-of-screen key
#define	TIStrKed		113
#; TIStrKel          clear-to-end-of-line key
#define	TIStrKel		114
#; TIStrKend         end key
#define	TIStrKend		115
#; TIStrKend         shifted end key
#define	TIStrKSend		116
#; TIStrKent         enter/send key
#define	TIStrKent		117
#; TIStrKeol         shifted clear-to-end-of-line key
#define	TIStrKSeol		118
#; TIStrKext         exit key
#define	TIStrKext		119
#; TIStrKext         shifted exit key
#define	TIStrKSext		120
#; TIStrKf0          F0 function key
#define	TIStrKf0		121
#; TIStrKf1          F1 function key
#define	TIStrKf1		122
#; TIStrKf10         F10 function key
#define	TIStrKf10		123
#; TIStrKf11         F11 function key
#define	TIStrKf11		124
#; TIStrKf12         F12 function key
#define	TIStrKf12		125
#; TIStrKf13         F13 function key
#define	TIStrKf13		126
#; TIStrKf14         F14 function key
#define	TIStrKf14		127
#; TIStrKf15         F15 function key
#define	TIStrKf15		128
#; TIStrKf16         F16 function key
#define	TIStrKf16		129
#; TIStrKf17         F17 function key
#define	TIStrKf17		130
#; TIStrKf18         F18 function key
#define	TIStrKf18		131
#; TIStrKf19         F19 function key
#define	TIStrKf19		132
#; TIStrKf2          F2 function key
#define	TIStrKf2		133
#; TIStrKf20         F20 function key
#define	TIStrKf20		134
#; TIStrKf21         F21 function key
#define	TIStrKf21		135
#; TIStrKf22         F22 function key
#define	TIStrKf22		136
#; TIStrKf23         F23 function key
#define	TIStrKf23		137
#; TIStrKf24         F24 function key
#define	TIStrKf24		138
#; TIStrKf25         F25 function key
#define	TIStrKf25		139
#; TIStrKf26         F26 function key
#define	TIStrKf26		140
#; TIStrKf27         F27 function key
#define	TIStrKf27		141
#; TIStrKf28         F28 function key
#define	TIStrKf28		142
#; TIStrKf29         F29 function key
#define	TIStrKf29		143
#; TIStrKf3          F3 function key
#define	TIStrKf3		144
#; TIStrKf30         F30 function key
#define	TIStrKf30		145
#; TIStrKf31         F31 function key
#define	TIStrKf31		146
#; TIStrKf32         F32 function key
#define	TIStrKf32		147
#; TIStrKf33         F33 function key
#define	TIStrKf33		148
#; TIStrKf34         F34 function key
#define	TIStrKf34		149
#; TIStrKf35         F35 function key
#define	TIStrKf35		150
#; TIStrKf36         F36 function key
#define	TIStrKf36		151
#; TIStrKf37         F37 function key
#define	TIStrKf37		152
#; TIStrKf38         F38 function key
#define	TIStrKf38		153
#; TIStrKf39         F39 function key
#define	TIStrKf39		154
#; TIStrKf4          F4 function key
#define	TIStrKf4		155
#; TIStrKf40         F40 function key
#define	TIStrKf40		156
#; TIStrKf41         F41 function key
#define	TIStrKf41		157
#; TIStrKf42         F42 function key
#define	TIStrKf42		158
#; TIStrKf43         F43 function key
#define	TIStrKf43		159
#; TIStrKf44         F44 function key
#define	TIStrKf44		160
#; TIStrKf45         F45 function key
#define	TIStrKf45		161
#; TIStrKf46         F46 function key
#define	TIStrKf46		162
#; TIStrKf47         F47 function key
#define	TIStrKf47		163
#; TIStrKf48         F48 function key
#define	TIStrKf48		164
#; TIStrKf49         F49 function key
#define	TIStrKf49		165
#; TIStrKf5          F5 function key
#define	TIStrKf5		166
#; TIStrKf50         F50 function key
#define	TIStrKf50		167
#; TIStrKf51         F51 function key
#define	TIStrKf51		168
#; TIStrKf52         F52 function key
#define	TIStrKf52		169
#; TIStrKf53         F53 function key
#define	TIStrKf53		170
#; TIStrKf54         F54 function key
#define	TIStrKf54		171
#; TIStrKf55         F55 function key
#define	TIStrKf55		172
#; TIStrKf56         F56 function key
#define	TIStrKf56		173
#; TIStrKf57         F57 function key
#define	TIStrKf57		174
#; TIStrKf58         F58 function key
#define	TIStrKf58		175
#; TIStrKf59         F59 function key
#define	TIStrKf59		176
#; TIStrKf6          F6 function key
#define	TIStrKf6		177
#; TIStrKf60         F60 function key
#define	TIStrKf60		178
#; TIStrKf61         F61 function key
#define	TIStrKf61		179
#; TIStrKf62         F62 function key
#define	TIStrKf62		180
#; TIStrKf63         F63 function key
#define	TIStrKf63		181
#; TIStrKf7          F7 function key
#define	TIStrKf7		182
#; TIStrKf8          F8 function key
#define	TIStrKf8		183
#; TIStrKf9          F9 function key
#define	TIStrKf9		184
#; TIStrKfnd         find key
#define	TIStrKfnd		185
#; TIStrKfnd         shifted find key
#define	TIStrKSfnd		186
#; TIStrKhlp         help key
#define	TIStrKhlp		187
#; TIStrKhlp         shifted help key
#define	TIStrKShlp		188
#; TIStrKhom         shifted home key
#define	TIStrKShom		189
#; TIStrKhome        home key
#define	TIStrKhome		190
#; TIStrKhts         set-tab key
#define	TIStrKhts		191
#; TIStrKic          shifted insert-char-acter key
#define	TIStrKSic		192
#; TIStrKich1        insert-character key
#define	TIStrKich1		193
#; TIStrKil1         insert-line key
#define	TIStrKil1		194
#; TIStrKind         scroll-forward key
#define	TIStrKind		195
#; TIStrKlft         shifted left-arrow key
#define	TIStrKSlft		196
#; TIStrKll          lower-left key (home down)
#define	TIStrKll		197
#; TIStrKmous        Mouse event has occurred
#define	TIStrKmous		198
#; TIStrKmov         move key
#define	TIStrKmov		199
#; TIStrKmov         shifted move key
#define	TIStrKSmov		200
#; TIStrKmrk         mark key
#define	TIStrKmrk		201
#; TIStrKmsg         message key
#define	TIStrKmsg		202
#; TIStrKmsg         shifted message key
#define	TIStrKSmsg		203
#; TIStrKnp          next-page key
#define	TIStrKnp		204
#; TIStrKnxt         next key
#define	TIStrKnxt		205
#; TIStrKnxt         shifted next key
#define	TIStrKSnxt		206
#; TIStrKopn         open key
#define	TIStrKopn		207
#; TIStrKopt         options key
#define	TIStrKopt		208
#; TIStrKopt         shifted options key
#define	TIStrKSopt		209
#; TIStrKpp          previous-page key
#define	TIStrKpp		210
#; TIStrKprt         print key
#define	TIStrKprt		211
#; TIStrKprt         shifted print key
#define	TIStrKSprt		212
#; TIStrKprv         previous key
#define	TIStrKprv		213
#; TIStrKprv         shifted previous key
#define	TIStrKSprv		214
#; TIStrKrdo         redo key
#define	TIStrKrdo		215
#; TIStrKrdo         shifted redo key
#define	TIStrKSrdo		216
#; TIStrKref         reference key
#define	TIStrKref		217
#; TIStrKres         resume key
#define	TIStrKres		218
#; TIStrKres         shifted resume key
#define	TIStrKSres		219
#; TIStrKrfr         refresh key
#define	TIStrKrfr		220
#; TIStrKri          scroll-backward key
#define	TIStrKri		221
#; TIStrKrit         shifted right-arrow key
#define	TIStrKSrit		222
#; TIStrKrmir        sent by rmir or smir in insert mode
#define	TIStrKrmir		223
#; TIStrKrpl         replace key
#define	TIStrKrpl		224
#; TIStrKrpl         shifted replace key
#define	TIStrKSrpl		225
#; TIStrKrst         restart key
#define	TIStrKrst		226
#; TIStrKsav         save key
#define	TIStrKsav		227
#; TIStrKsav         shifted save key
#define	TIStrKSsav		228
#; TIStrKslt         select key
#define	TIStrKslt		229
#; TIStrKspd         shifted suspend key
#define	TIStrKSspd		230
#; TIStrKspd         suspend key
#define	TIStrKspd		231
#; TIStrKtbc         clear-all-tabs key
#define	TIStrKtbc		232
#; TIStrKund         shifted undo key
#define	TIStrKSund		233
#; TIStrKund         undo key
#define	TIStrKund		234
#; TIStrLf0          label on function key f0 if not f0
#define	TIStrLf0		235
#; TIStrLf1          label on function key f1 if not f1
#define	TIStrLf1		236
#; TIStrLf10         label on function key f10 if not f10
#define	TIStrLf10		237
#; TIStrLf2          label on function key f2 if not f2
#define	TIStrLf2		238
#; TIStrLf3          label on function key f3 if not f3
#define	TIStrLf3		239
#; TIStrLf4          label on function key f4 if not f4
#define	TIStrLf4		240
#; TIStrLf5          label on function key f5 if not f5
#define	TIStrLf5		241
#; TIStrLf6          label on function key f6 if not f6
#define	TIStrLf6		242
#; TIStrLf7          label on function key f7 if not f7
#define	TIStrLf7		243
#; TIStrLf8          label on function key f8 if not f8
#define	TIStrLf8		244
#; TIStrLf9          label on function key f9 if not f9
#define	TIStrLf9		245
#; TIStrLl           last line, first column (if no cup)
#define	TIStrLl		246
#; TIStrLpi          Change number of lines per inch to #1
#define	TIStrLpi		247
#; TIStrMc0          print contents of screen
#define	TIStrMc0		248
#; TIStrMc4          turn off printer
#define	TIStrMc4		249
#; TIStrMc5          turn on printer
#define	TIStrMc5		250
#; TIStrMc5p         turn on printer for #1 bytes
#define	TIStrMc5p		251
#; TIStrMcub         Like parm_left_cur-sor in micro mode
#define	TIStrMcub		252
#; TIStrMcub1        Like cursor_left in micro mode
#define	TIStrMcub1		253
#; TIStrMcud         Like parm_down_cur-sor in micro mode
#define	TIStrMcud		254
#; TIStrMcud1        Like cursor_down in micro mode
#define	TIStrMcud1		255
#; TIStrMcuf         Like parm_right_cur-sor in micro mode
#define	TIStrMcuf		256
#; TIStrMcuf1        Like cursor_right in micro mode
#define	TIStrMcuf1		257
#; TIStrMcuu         Like parm_up_cursor in micro mode
#define	TIStrMcuu		258
#; TIStrMcuu1        Like cursor_up in micro mode
#define	TIStrMcuu1		259
#; TIStrMgc          clear right and left soft margins
#define	TIStrMgc		260
#; TIStrMhpa         Like column_address in micro mode
#define	TIStrMhpa		261
#; TIStrMinfo        Mouse status information
#define	TIStrMinfo		262
#; TIStrMrcup        memory relative cur-sor addressing, move to row #1 columns #2
#define	TIStrMrcup		263
#; TIStrMvpa         Like row_address #1 in micro mode
#define	TIStrMvpa		264
#; TIStrNel          newline (behave like cr followed by lf)
#define	TIStrNel		265
#; TIStrOc           Set all color pairs to the original ones
#define	TIStrOc		266
#; TIStrOp           Set default pair to its original value
#define	TIStrOp		267
#; TIStrPad          padding char (instead of null)
#define	TIStrPad		268
#; TIStrPause        pause for 2-3 sec-onds
#define	TIStrPause		269
#; TIStrPctrm        PC terminal options
#define	TIStrPctrm		270
#; TIStrPfkey        program function key #1 to type string #2
#define	TIStrPfkey		271
#; TIStrPfloc        program function key #1 to execute string #2
#define	TIStrPfloc		272
#; TIStrPfx          program function key #1 to transmit string #2
#define	TIStrPfx		273
#; TIStrPfxl         Program function key #1 to type string #2 and show string #3
#define	TIStrPfxl		274
#; TIStrPln          program label #1 to show string #2
#define	TIStrPln		275
#; TIStrPorder       Match software bits to print-head pins
#define	TIStrPorder		276
#; TIStrProt         turn on protected mode
#define	TIStrProt		277
#; TIStrPulse        select pulse dialing
#define	TIStrPulse		278
#; TIStrQdial        dial number #1 with-out checking
#define	TIStrQdial		279
#; TIStrRbim         Stop printing bit image graphics
#define	TIStrRbim		280
#; TIStrRc           restore cursor to position of last save_cursor
#define	TIStrRc		281
#; TIStrRcsd         End definition of character set #1
#define	TIStrRcsd		282
#; TIStrRep          repeat char #1 #2 times (P*)
#define	TIStrRep		283
#; TIStrReqmp        Request mouse position
#define	TIStrReqmp		284
#; TIStrRev          turn on reverse video mode
#define	TIStrRev		285
#; TIStrRf           name of reset file
#define	TIStrRf		286
#; TIStrRfi          send next input char (for ptys)
#define	TIStrRfi		287
#; TIStrRi           scroll text down (P)
#define	TIStrRi		288
#; TIStrRin          scroll back #1 lines (P)
#define	TIStrRin		289
#; TIStrRitm         End italic mode
#define	TIStrRitm		290
#; TIStrRlm          End left-motion mode
#define	TIStrRlm		291
#; TIStrRmacs        end alternate char-acter set (P)
#define	TIStrRmacs		292
#; TIStrRmam         turn off automatic margins
#define	TIStrRmam		293
#; TIStrRmclk        remove clock
#define	TIStrRmclk		294
#; TIStrRmcup        strings to end pro-grams using cup
#define	TIStrRmcup		295
#; TIStrRmdc         end delete mode
#define	TIStrRmdc		296
#; TIStrRmicm        End micro-motion mode
#define	TIStrRmicm		297
#; TIStrRmir         exit insert mode
#define	TIStrRmir		298
#; TIStrRmkx         leave key-board_transmit mode
#define	TIStrRmkx		299
#; TIStrRmln         turn off soft labels
#define	TIStrRmln		300
#; TIStrRmm          turn off meta mode
#define	TIStrRmm		301
#; TIStrRmp          like ip but when in insert mode
#define	TIStrRmp		302
#; TIStrRmpch        Exit PC character display mode
#define	TIStrRmpch		303
#; TIStrRmsc         Exit PC scancode mode
#define	TIStrRmsc		304
#; TIStrRmso         exit standout mode
#define	TIStrRmso		305
#; TIStrRmul         exit underline mode
#define	TIStrRmul		306
#; TIStrRmxon        turn off xon/xoff handshaking
#define	TIStrRmxon		307
#; TIStrRs1          reset string
#define	TIStrRs1		308
#; TIStrRs2          reset string
#define	TIStrRs2		309
#; TIStrRs3          reset string
#define	TIStrRs3		310
#; TIStrRshm         End shadow-print mode
#define	TIStrRshm		311
#; TIStrRsubm        End subscript mode
#define	TIStrRsubm		312
#; TIStrRsupm        End superscript mode
#define	TIStrRsupm		313
#; TIStrRum          End reverse charac-ter motion
#define	TIStrRum		314
#; TIStrRwidm        End double-wide mode
#define	TIStrRwidm		315
#; TIStrS0ds         Shift to codeset 0 (EUC set 0, ASCII)
#define	TIStrS0ds		316
#; TIStrS1ds         Shift to codeset 1
#define	TIStrS1ds		317
#; TIStrS2ds         Shift to codeset 2
#define	TIStrS2ds		318
#; TIStrS3ds         Shift to codeset 3
#define	TIStrS3ds		319
#; TIStrSbim         Start printing bit image graphics
#define	TIStrSbim		320
#; TIStrSc           save current cursor position (P)
#define	TIStrSc		321
#; TIStrScesa        Alternate escape for scancode emu-lation
#define	TIStrScesa		322
#; TIStrScesc        Escape for scan-code emulation
#define	TIStrScesc		323
#; TIStrSclk         set clock, #1 hrs #2 mins #3 secs
#define	TIStrSclk		324
#; TIStrScp          Set current color pair to #1
#define	TIStrScp		325
#; TIStrScs          Select character set, #1
#define	TIStrScs		326
#; TIStrScsd         Start character set definition #1, with #2 characters in the set
#define	TIStrScsd		327
#; TIStrSdrfq        Enter draft-quality mode
#define	TIStrSdrfq		328
#; TIStrSetab        Set background color to #1, using ANSI escape
#define	TIStrSetab		329
#; TIStrSetaf        Set foreground color to #1, using ANSI escape
#define	TIStrSetaf		330
#; TIStrSetb         Set background color #1
#define	TIStrSetb		331
#; TIStrSetcolor     Change to ribbon color #1
#define	TIStrSetcolor		332
#; TIStrSetf         Set foreground color #1
#define	TIStrSetf		333
#; TIStrSgr          define video attributes #1-#9 (PG9)
#define	TIStrSgr		334
#; TIStrSgr0         turn off all attributes
#define	TIStrSgr0		335
#; TIStrSgr1         Define second set of video attributes #1-#6
#define	TIStrSgr1		336
#; TIStrSitm         Enter italic mode
#define	TIStrSitm		337
#; TIStrSlength      YI Set page length to #1 hundredth of an inch
#define	TIStrSlength		338
#; TIStrSlines       Set page length to #1 lines
#define	TIStrSlines		339
#; TIStrSlm          Start leftward car-riage motion
#define	TIStrSlm		340
#; TIStrSmacs        start alternate character set (P)
#define	TIStrSmacs		341
#; TIStrSmam         turn on automatic margins
#define	TIStrSmam		342
#; TIStrSmcup        string to start pro-grams using cup
#define	TIStrSmcup		343
#; TIStrSmdc         enter delete mode
#define	TIStrSmdc		344
#; TIStrSmgb         Set bottom margin at current line
#define	TIStrSmgb		345
#; TIStrSmgbp        Set bottom margin at line #1 or (if smgtp is not given) #2 lines from bottom
#define	TIStrSmgbp		346
#; TIStrSmgl         set left soft margin at current col-umn. See smgl. (ML is not in BSD termcap).
#define	TIStrSmgl		347
#; TIStrSmglp        Set left (right) margin at column #1
#define	TIStrSmglp		348
#; TIStrSmglr        Set both left and right margins to #1, #2. (ML is not in BSD term-cap).
#define	TIStrSmglr		349
#; TIStrSmgr         set right soft mar-gin at current col-umn
#define	TIStrSmgr		350
#; TIStrSmgrp        Set right margin at column #1
#define	TIStrSmgrp		351
#; TIStrSmgt         Set top margin at current line
#define	TIStrSmgt		352
#; TIStrSmgtb        Sets both top and bottom margins to #1, #2
#define	TIStrSmgtb		353
#; TIStrSmgtp        Set top (bottom) margin at row #1
#define	TIStrSmgtp		354
#; TIStrSmicm        Start micro-motion mode
#define	TIStrSmicm		355
#; TIStrSmir         enter insert mode
#define	TIStrSmir		356
#; TIStrSmkx         enter key-board_transmit mode
#define	TIStrSmkx		357
#; TIStrSmln         turn on soft labels
#define	TIStrSmln		358
#; TIStrSmm          turn on meta mode (8th-bit on)
#define	TIStrSmm		359
#; TIStrSmpch        Enter PC character display mode
#define	TIStrSmpch		360
#; TIStrSmsc         Enter PC scancode mode
#define	TIStrSmsc		361
#; TIStrSmso         begin standout mode
#define	TIStrSmso		362
#; TIStrSmul         begin underline mode
#define	TIStrSmul		363
#; TIStrSmxon        turn on xon/xoff handshaking
#define	TIStrSmxon		364
#; TIStrSnlq         Enter NLQ mode
#define	TIStrSnlq		365
#; TIStrSnrmq        Enter normal-quality mode
#define	TIStrSnrmq		366
#; TIStrSshm         Enter shadow-print mode
#define	TIStrSshm		367
#; TIStrSsubm        Enter subscript mode
#define	TIStrSsubm		368
#; TIStrSsupm        Enter superscript mode
#define	TIStrSsupm		369
#; TIStrSubcs        List of subscript-able characters
#define	TIStrSubcs		370
#; TIStrSum          Start upward car-riage motion
#define	TIStrSum		371
#; TIStrSupcs        List of superscript-able characters
#define	TIStrSupcs		372
#; TIStrSwidm        Enter double-wide mode
#define	TIStrSwidm		373
#; TIStrTbc          clear all tab stops (P)
#define	TIStrTbc		374
#; TIStrTone         select touch tone dialing
#define	TIStrTone		375
#; TIStrTsl          move to status line, column #1
#define	TIStrTsl		376
#; TIStrU0           User string #0
#define	TIStrU0		377
#; TIStrU1           User string #1
#define	TIStrU1		378
#; TIStrU2           User string #2
#define	TIStrU2		379
#; TIStrU3           User string #3
#define	TIStrU3		380
#; TIStrU4           User string #4
#define	TIStrU4		381
#; TIStrU5           User string #5
#define	TIStrU5		382
#; TIStrU6           User string #6
#define	TIStrU6		383
#; TIStrU7           User string #7
#define	TIStrU7		384
#; TIStrU8           User string #8
#define	TIStrU8		385
#; TIStrU9           User string #9
#define	TIStrU9		386
#; TIStrUc           underline char and move past it
#define	TIStrUc		387
#; TIStrVpa          vertical position #1 absolute (P)
#define	TIStrVpa		388
#; TIStrWait         wait for dial-tone
#define	TIStrWait		389
#; TIStrWind         current window is lines #1-#2 cols #3-#4
#define	TIStrWind		390
#; TIStrWingo        go to window #1
#define	TIStrWingo		391
#; TIStrXoffc        XOFF character
#define	TIStrXoffc		392
#; TIStrXonc         XON character
#define	TIStrXonc		393
#; TIStrZerom        No motion for subse-quent character
#define	TIStrZerom		394
#;
#; Cache alternates to existing terminfo definitions.
#;
#; TIStrAkcub1        Alternative left-arrow key
#define	TIStrAkcub1		400
#; TIStrAkcud1        Alternative down-arrow key
#define	TIStrAkcud1		401
#; TIStrAkcuf1        Alternative right-arrow key
#define	TIStrAkcuf1		402
#; TIStrAkcuu1        Alternative up-arrow key
#define	TIStrAkcuu1		403
#; TIStrAkbs          Alternative backspace key
#define	TIStrAkbs		404
#; TIStrAkdch1		GGC699 Alternative delete key
#define	TIStrAkdch1		405
#;
#; Remaining values up to 449 spare for missing genuine terminfo definitions
#;
#;
#; Cache extensions to terminfo definitions
#;
#; TIStrXmc5i          No longer used, 450 free
#; TIStrXmc4i          No longer used, 451 free
#; TIStrXblink		Exit blink video mode
#define	TIStrXblink		452
#; TIStrXdim		Exit dimmed video mode
#define	TIStrXdim		453
#; TIStrXrev		Exit reverse video mode
#define	TIStrXrev		454
#; TIStrXsmul		Exit underscore video mode , a terminfo definition rmul exists for this
#define	TIStrXsmul		$$$TIStrRmul
#; TIStrXbold		Exit bold video mode
#define	TIStrXbold		455
#; TIStrXinvis		Exit invisible video mode
#define	TIStrXinvis		456
#; TIStrXprot		Exit protected field mode
#define	TIStrXprot		457
#; TIStrXenter80	Enter 80 column mode
#define	TIStrXenter80	458
#; TIStrXenter132	Enter 132 column mode
#define	TIStrXenter132	459
#; TIStrXdmi		Disable manual input
#define	TIStrXdmi		460
#; TIStrXemi		Enable manual input
#define	TIStrXemi		461
#; TIStrXscr1	     Scroll screen right 1 position
#define	 TIStrXscr1	462
#; TIStrXscr	     Scroll screen right (P) times
#define	 TIStrXscr	463
#; TIStrXscl1	     Scroll screen left 1 position
#define	 TIStrXscl1	464
#; TIStrXscl	     Scroll screen left (P) times
#define	 TIStrXscl	465
#; TIStrXstrunc	     Set line truncate
#define	 TIStrXstrunc	466
#; TIStrXrtrunc	     Reset line truncate
#define	 TIStrXrtrunc	467
#; TIStrXsnumeric    Set numeric keypad
#define	 TIStrXsnumeric	468
#; TIStrXrnumeric    Reset numeric keypad
#define	 TIStrXrnumeric	469
#; TIStrXhpa1	     Horizontal Position Absolute to column 0
#define	 TIStrXhpa1	470
#; TIStrXsetafdim	Set foreground colour to a dim colour
#define	TIStrXsetafdim	471
#; TIStrXEnableProtect	Enable protected fields
#define	TIStrXEnableProtect	472
#; TIStrXDisableProtect	Disable protected fields
#define	TIStrXDisableProtect	473
#; TIStrXhpa          horizontal position #1, absolute (P), used when hpa doesn't work
#; Sometimes the hpa string causes problems, so we can't use regular Unix
#; terminfo definitions by default. However some terminals don't support
#; our alternative to hpa and DO need hpa. Hence xhpa for those terminals.
#define	TIStrXhpa		474
#;
#; The following values are for keyboard independence.
#; They define what sort of character strings are returned
#; key a user following a call to TIKeys^%SYS.MVF()
#;
#; The values are chosen to mirror those returned from jBASE
#; to make porting easy.
#;
#define	TIKeysError				100
#define	TIKeysAlphaNumeric		101
#define	TIKeysTimeout			102
#define	TIKeysWinsize			103
#;
#define TIKeysInsertSpace       1
#define TIKeysStartLine         2
#define TIKeysChangeCase        3
#define TIKeysEndLine           4
#define TIKeysMarkLine          5
#define TIKeysForwardTab        6
#define TIKeysClearEndLine      7
#define TIKeysInsertLine        8
#define TIKeysCarriageReturn    9
#define TIKeysNextLocate        10
#define TIKeysPrevLocate        11
#define TIKeysToggleInsert      12
#define TIKeysRepaint           13
#define TIKeysCopyCharacter     14
#define TIKeysIndentScreen      15
#define TIKeysDeleteWord        16
#define TIKeysExitRecord        17
#define TIKeysBackTab           18
#define TIKeysEscape            19
#define TIKeysInsertSubValue    20
#define TIKeysInsertValue       21
#define TIKeysCursorUp          22
#define TIKeysCursorDown        23
#define TIKeysCursorRight       24
#define TIKeysCursorLeft        25
#define TIKeysScrollUpLine      26
#define TIKeysScrollDownLine    27
#define TIKeysScrollUpHalf      28
#define TIKeysScrollDownHalf    29
#define TIKeysScrollUpPage      30
#define TIKeysScrollDownPage    31
#define TIKeysScrollTop         32
#define TIKeysScrollBottom      33
#define TIKeysNextIndent        34
#define TIKeysPrevIndent        35
#define TIKeysBackspace         36
#define TIKeysDeleteChar        37
#define TIKeysDeleteLine        38
#;
#define	TIKeysF1				41
#define	TIKeysF2				42
#define	TIKeysF3				43
#define	TIKeysF4				44
#define	TIKeysF5				45
#define	TIKeysF6				46
#define	TIKeysF7				47
#define	TIKeysF8				48
#define	TIKeysF9				49
#define	TIKeysF10				50
#define	TIKeysF11				51
#define	TIKeysF12				52
#define	TIKeysF13				53
#define	TIKeysF14				54
#define	TIKeysF15				55
#define	TIKeysF16				56
#define	TIKeysF17				57
#define	TIKeysF18				58
#define	TIKeysF19				59
#define	TIKeysF20				60
#define	TIKeysF21				61
#define	TIKeysF22				62
#define	TIKeysF23				63
#define	TIKeysF24				64
#define	TIKeysF25				65
#define	TIKeysF26				66
#define	TIKeysF27				67
#define	TIKeysF28				68
#define	TIKeysF29				69
#define	TIKeysF30				70
#define	TIKeysF31				71
#define	TIKeysF32				72