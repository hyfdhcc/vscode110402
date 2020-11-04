ROUTINE %syNLS [Type=INC]
 ;%syNLS.INC   --  National language support include file
 
#;============================Maintenance=============================
#;JLC1824 09/01/14 Jose' Cordeiro, LOCALEPATH points to mgr/Locale
#;JLC1552 02/02/12 Jose' Cordeiro, implement ALPHAUP translation
#;JLC1549 10/20/11 Jose' Cordeiro, add NLSProcessGbl
#;JLC1527 08/30/11 Jose' Cordeiro, fix loading of U2 pattern match table
#;JLC1396 06/29/10 Jose' Cordeiro, add IO and Table property names
#;JLC1392 06/18/10 Jose' Cordeiro, add NLSConfigGbl.
#;JLC1282 04/08/09 Jose' Cordeiro, add currency to LCB.
#;JLC1276 03/16/09 Jose' Cordeiro, definitions for U2.
#;JLC1191 08/27/08 Jose' Cordeiro, add definitions for %SYS.Date.SlidindWindow
#;JLC1138 03/04/08 Jose' Cordeiro, standardize I/O names.
#;JLC1131 02/26/08 Jose' Cordeiro, define LanguageAbbr, CountryAbbr
#;JLC1100 11/27/07 Jose' Cordeiro, define PhysicalCursor.
#;JLC1018 05/28/07 Jose' Cordeiro, load locale from objects.
#;JLC998 04/08/07 Jose' Cordeiro, incorporate formats into Locales.
#;JLC983 03/16/07 Jose' Cordeiro, definitions for NLS classes.
#;JLC918 09/26/06 Jose' Cordeiro, preserve Latin1 built-in tables.
#;JLC860 05/27/06 Jose' Cordeiro, support for GB18030.
#;JLC672 12/10/04 Jose' Cordeiro, define SetEuro().
#;JLC579 02/20/04 Jose' Cordeiro, define SetUniPtrs().
#;JLC568 12/19/03 Jose' Cordeiro, define MakeSAME().
#;STC471 09/19/03 Steve Clay, Rename and merge with NLS2
#;STC467 08/13/03 Steve Clay, add collation abreviations
#;JLC389 03/22/02 Jose' Cordeiro, define NLSSUNITABLE
#;JLC238 07/18/00 Jose' Cordeiro, define NLSChs
#;CFL202 12/16/99 Carlos Lopes, added Printer default IO translation
#;JMB030 11/29/99 John Basile, Rename nls.INC to NLS2.INC
#;CLN032 08/23/99 Jose' Cordeiro, cleaned out old code.
#;CFL096 05/11/99 Carlos Lopes, renamed NLS temporary globals.
#;JLC097 04/30/99 Jose' Cordeiro, remove NLSLocName, NLSLocLoad
#;JLC093 04/16/99 Jose' Cordeiro, define collation names
#;JLC081 03/23/99 Jose' Cordeiro, update TableNames
#;JLC083 03/25/99 Jose' Cordeiro, define LocaleResource.
#;CFL074 03/25/99 Carlos Lopes, fix Validate bug.
#;JLC081 03/23/99 Jose' Cordeiro, separate Case from XLT tables
#;CFL068 03/11/99 Carlos Lopes, new NLS GUI utility
#;JLC062 12/08/98 Jose' Cordeiro, ^%nls unification
#;JLC061 11/20/98 Jose' Cordeiro, define ColTabMax, GetTabnum
#;CFL062 11/20/98 Carlos Lopes, add edit flag
#;CFL047  8/31/98 Jose' Cordeiro, add IOSysCall
#;LRS230 07/14/98 Lee Smith, cleaned, rewritten for FULLNLS
#;JLC043  6/30/98 Jose' Cordeiro, define BuiltinMax, fix SlotMax
#;JLC040  5/15/98 Jose' Cordeiro, collation related macros
#;JLC035  3/30/98 Jose' Cordeiro, support for collation tables
#;LRS189 09/11/97 Lee Smith, modify pattern match codes for sj1123
#;SJ1150  5/10/97 Scott Jones, substantially rewrote this file
#;EAV021  3/03/97 Edward Valenti, Created include file as %nls.inc
#;LRS084 08/15/95 Lee Smith, add test for valid collation sequence
#;LRS077 07/21/95 Lee Smith, fix $$$COLmaxtab to get max collations tabs
#;LRS069 06/01/95 Lee Smith, Modified TranStat, TranOn, and TranOff
#;                macros to yield results as described in manual
#;LRS043 12/01/94 Lee Smith, more stuff & fixes for new NLS (6.0 impl.)
#;VGG150 07/20/94 Vadim Goldin, add more stuff for the new NLS (6.0 impl.)
#;DKA212 02/14/94 Keith Avery, Changes to support foreign collation
#;==========================End Maintenance===========================
 
#ifndef %syNLS
#define %syNLS
 
#include %sySystem
#include %sySecurity

#define LOCALENAME @("^|""^^"_$zu(203,1)_"""|"_$zu(203,5))@("LOCALE","CURRENT")
#define LOCALEPATH $$ComputeFullDBDir^%SYS.API("Locale")
 
#define IOsetpitch(%dir,%val)            $zu(96,17,%dir,%val)
#define IOgetpitch(%dir)                 $zu(96,17,%dir)
#define IOsetname(%dir,%nam)             $zu(96,18,%dir,%nam)
#define IOgetname(%dir)                  $zu(96,18,%dir)
#define XYsetname(%dir,%nam)             $zu(96,19,%dir,%nam)
#define XYgetname(%dir)                  $zu(96,19,%dir)
#define PRsetoffset(%idx,%off)           $zu(96,20,%idx,%off)
#define PRgetoffset(%idx)                $zu(96,20,%idx)
#define IOsetcursor(%val)                $zu(96,22,%val)
#define IOgetcursor                      $zu(96,22)
 
#define IOvalid(%dir)                    ($$$IOgetname(%dir)]"")
  
#; Manipulation of device and process translation pairs via handle
 
#define SetProcXlt(%han)                 $zu(125,0,%han)
#define GetProcXlt                       $zu(125,0)
#define FindXlt(%nam)                    $zu(125,1,%nam)
#define MakeXlt(%nam)                    $zu(125,2,%nam)
#define CreateXlt(%nam)                  $zu(125,3,%nam)
#define DeleteXlt(%han)                  $zu(125,4,%han)
#define GetXltName(%han)                 $zu(125,5,%han)
#define SetReplType(%han,%dir,%val)      $zu(125,6,%han,%dir,0,%val)
#define GetReplType(%han,%dir)           $zu(125,6,%han,%dir,0)
#define SetReplVal(%han,%dir,%val)       $zu(125,6,%han,%dir,1,%val)
#define GetReplVal(%han,%dir)            $zu(125,6,%han,%dir,1)
#define SetMode(%han,%dir,%idx)          $zu(125,6,%han,%dir,2,%idx)
#define GetMode(%han,%dir)               $zu(125,6,%han,%dir,2)
#define SetIOStat(%han,%dir,%val)        $zu(125,6,%han,%dir,3,%val)
#define GetIOStat(%han,%dir)             $zu(125,6,%han,%dir,3)
#define SetReplStat(%han,%dir,%val)      $zu(125,6,%han,%dir,6,%val)
#define GetReplStat(%han,%dir)           $zu(125,6,%han,%dir,6)
#define SetModeStr(%han,%dir,%idx,%val)  $zu(125,7,%han,%dir,%idx,%val)
#define GetModeStr(%han,%dir,%idx)       $zu(125,7,%han,%dir,%idx)
 
#; Collation Sequence Tables
 
#define COLsetdef(%col)         $zu(23,0,%col)
#define COLgetdef               $zu(23,0)
#define COLswitch(%col)         $zu(23,1,%col)
#define COLcurrent              $zu(23,1)
#define COLtabnum(%col)         $p($zu(23,2,%col),"^",3)
#define COLundef(%col)          ($p($zu(23,2,%col),"^",1,2)="255^255")
#define COLencoff(%nbr)         $p($zu(83,%nbr),",")
#define COLdecoff(%nbr)         $p($zu(83,%nbr),",",2)
 
 
#; STC471 - everything below this is from NLS2.INC
 
#define ident   "Ident"
#define mode    "Mode"
#define patcode "Patcode"
#define pattern "Pattern"
#define sub     "SUB"
#define trans   "XLT"
#define xy      "XY"
#define case    "Case"
#define ucase    "UpperCase"
#define lcase    "LowerCase"
#define tcase    "TitleCase"
 
#define multiuser       0
 
#if     $$$multiuser
#define tmpglb  ^NlStEmP("NLSGUI")
#else
#define tmpglb  ^mnls
#endif
 
#define cmpglb  ^NlStEmP("NLSCOMP",$j)
  
#define col     "COL"
#define XLTtypnam(%t) $s(%t=$$$trans:"Translation",%t=$$$xy:"$X/$Y Behaviour",%t=$$$ident:"Identifier",%t=$$$pattern:"Pattern Match",%t=$$$ucase:"Upper case",%t=$$$lcase:"Lower case",%t=$$$tcase:"Title case",1:"Collation")
  
#define NLSDEBUG $d(^%nlsmisc("DEBUG"))
  
#define LocaleCharSet  0
#define LocaleTables   1
#define LocaleDefaults 2
#define LocaleLanguage 3
#define LocaleCountry  4
#define LocaleResource 5
 
#; JLC998 - Locale currency symbol
#define	LocaleCurrency	6
 
#; JLC998 - Date, time and number formats  
#define	SetFormat(%idx,%val)	$ZU(174,%idx,%val)
#define	LocaleFormats	7
  #define FMTDateFormat				1
  #define FMTYearOption				2
  #define FMTTimeFormat				3
  #define FMTTimePrecision			4
  #define FMTNumericGroupSize		5
  #define FMTDecimalSeparator		6
  #define FMTNumericGroupSeparator	7
  #define FMTDateSeparator			8
  #define FMTTimeSeparator			9
  #define FMTPlusSign				10
  #define FMTMinusSign				11
  #define FMTAM						12
  #define FMTPM						13
  #define FMTNoon					14
  #define FMTMidnight				15
  #define FMTMonthAbbr				16
  #define FMTMonthName				17
  #define FMTWeekdayAbbr			18
  #define FMTWeekdayName			19
  #define FMTDateMinimum			20
  #define FMTDateMaximum			21
  #define FMTCurrency				22

#define	LocalePhysicalCursor	8 
#define LocaleCountryAbbr		9
#define	LocaleLanguageAbbr		10

#define LocaleInp      0
#define LocaleOut      1
  
#define LocaleFrom  0
#define LocaleTo    1
  
#define SizeOff $ZU(40,0,25)
#define GetGenOff(%b,%i,%m)    $V((%i)*$$$SizeOff+(%b),%m,$$$SizeOff)
#define SetGenOff(%b,%i,%m,%v)  V (%i)*$$$SizeOff+(%b):%m:$$$SizeOff:%v
  
#define GetPartOff(%b,%i)   $$$GetGenOff(%b,%i,-1)
#define SetPartOff(%b,%i,%v) $$$SetGenOff(%b,%i,-1,%v)
#define GetShmOff(%b,%i)    $$$GetGenOff(%b,%i,-2)
#define SetShmOff(%b,%i,%v) $$$SetGenOff(%b,%i,-2,%v)
#define	GetLatin1Off(%i)    $$$GetGenOff($ZU(40,2,166),%i,-2)
  
#define GetNamEle(%tab,%nam,%ele) $ZU(127,1,%tab,%nam,%ele)
#define SetNamEle(%tab,%nam,%ele,%val) $ZU(127,1,%tab,%nam,%ele,%val)
#define GetNextNam(%tab,%nam) $ZU(127,2,%tab,%nam)
#define NamOff2Str(%nam) $ZU(126,5,%nam)
  
#define DefaultTable    0
#define DefaultTableOff $ZU(40,2,104)
#define ProcessTableOff $ZU(40,1,26)
#define TableNames      "Pattern match,Identifier,Uppercase,Lowercase,Titlecase,U2 pattern match,Alphaup"
#define TableTypes      "Pattern,Ident,UpperCase,LowerCase,TitleCase,Pattern,UpperCase"
#define	TableProps      "PatternMatch,Identifier,Uppercase,Lowercase,Titlecase,PatternMatch,Uppercase"
  #define TablePattern  0
  #define TableIdent    1
  #define TableUpper    2
  #define TableLower    3
  #define TableTitle    4
  #; For U2 systems only
  #define TableU2Pattern 5
  #define TableAlphaup	6
  #define TableMax      6
  
#define DefaultIO       1
#define DefaultIOOff    $ZU(40,2,105)
#define ProcessIOOff    $ZU(40,1,27)
#define	RawIOOff        $V($ZU(40,2,168),-2,$$$SizeOff)
#define IONames         "Process,Cache Terminal,Other terminal,File,Magtape,TCP/IP,DSM-DDP,DTM-DCP,System call,Printer"
#define	IOProps         "Process,CacheTerminal,OtherTerminal,File,Magtape,TCPIP,DSMDDP,DTMDCP,SystemCall,Printer"
#define IONameTable     $$$GetShmOff($ZU(40,2,103),0)
  #define IOProcess     0
  #define IOMTerm       1
  #define IOTerminal    2
  #define IOFile        3
  #define IOMagtape     4
  #define IONetwork     5
  #define IONetDSM      6
  #define IONetDTM      7
  #define IOSysCall     8
#if 0   ; CFL202+
  #define IOMax         8
#else   ; CFL202=
  #define IOPrinter     9
  #define IOMax         9
#endif  ; CFL202-
 
#define DefaultXY       2
#define DefaultXYOff    $ZU(40,2,106)
#define ProcessXYOff    $ZU(40,1,28)
#define	Latin1XYOff     $V($ZU(40,2,167),-2,$$$SizeOff)
#define XYNames         "Process"
#define XYNameTable     $$$GetShmOff($ZU(40,2,103),1)
  #define XYProcess     0
  #define XYMax         0
  
#define IOSlotOff       $ZU(40,2,107)
#define XYSlotOff       $ZU(40,2,108)
  
#define SlotMax         9
  
#define DefaultCOL      3
#define COLNames        "Process"
 #define COLProcess      0
 #define COLMax          0
  
#define BuiltinMax      9
  
#define ColTabMax                $zu(83)
#define GetTabnum(%c)            $p($zu(23,2,%c),"^",3)
#define GetTables(%t)            $zu(83,%t)
#define SetDefCol(%v)            $zu(23,0,%v)
#define SetTables(%e,%d,%i)      $zu(83,%i,%e,%d)
#define SetRules(%c,%l,%g,%i)    $zu(23,2,%c,%l,%g,%i)
  
#;      Defines for object manipulation and NLS table building
  
#;      Translation types 
  
#define XLTUNI2RAW      0
#define XLTRAW2UNI      1
#define XLTUNI2UTF      2
#define XLTUTF2UNI      3
#define XLTUNI2LIT      4
#define XLTLIT2UNI      5
#define XLTUNI2BIG      6
#define XLTBIG2UNI      7
#define XLTUNI2BIT      8
#define XLTBYT2BIT      9
#define XLTUNI2VAL      10
#define XLTBYT2VAL      11
#define XLTUNI2STR      12
#define XLTBYT2STR      13
#define XLTPAK2STR      14
#define XLTMOD2STR      15
#define XLTUNI2MOD      16
#define XLTBYT2MOD      17
 
#define	XLTUNI2GB1		26
#define	XLTGB12UNI		27
 
#;      $X/$Y Action values
  
#define DXYNOR          0
#define DXYFUL          1
#define DXYNP           2
#define DXYBS           3
#define DXYLF           4
#define DXYFF           5
#define DXYCR           6
#define DXYESC          7
  
#;      Default replacement flags
  
#define XLTError        0
#define XLTReplace      1
#define XLTIgnore       2
  
#;      Translation tables
  
#define XLTNormal       0
#define XLTToModal      1
#define XLTFromModal    2
  
#define XLTAmbiguous    0
#define XLTReversible   1
#define XLTGenerated    2
  
#define SUBSingle       0
#define SUBToMulti      1
#define SUBFromMulti    2
#define SUBMulti        3
#define SUBLeadByte     4
#define SUBToCol        5
#define SUBFromCol      6
  
#define XLTType         0
#define XLTReverse      1
#define XLTAction       2
#define XLTValue        3
#define XLTTable        4
#define XLTMode         5
 
#define NLSSrc          "Src"
#define NLSLoc          "Loc"
#define NLSRules        "Rules"
#define NLSLock         "Lock"
#if 1   ; JLC238+
#define NLSChs          "Chs"
#endif  ; JLC238-
 
#; Subtypes for Multi-multi and Collation tables
  
#define XLTSTENCODE     0
#define XLTSTDECODE     1
#define XLTSTMANY2MANY  2
#define XLTSTDECOPT     3   
 
#; Names of built-in collations
 
#define Name0   "ISM Pre-6.2"
#define Name1   "ISM 6.2->6.4"
#define Name2   "Ipsum/Cobra"
#define Name3   "DTM-compatible"
#define Name4   "Ipsum/Cobra-2"
#define Name5   "Cache standard"
#define Name128 "ISM Pre-6.2 string"
#define Name129 "ISM 6.2->6.4 string"
#define Name133 "Cache standard string"
 
#if 1 ;STC467+
#define Abrev0 "OANS"
#define Abrev1 "ANSI"
#define Abrev2 "COBR"
#define Abrev3 "DTMC"
#define Abrev4 "CBR2"
#define Abrev5 "UNIC"
#define Abrev128 "OSTR"
#define Abrev129 "NSTR"
#define Abrev133 "USTR"
#endif ;STC467-
#; Hybrid string collation rule (nls.h) - JLC389
#define	NLSSUNITABLE	7
 
#; Create a synonym for the SAME translation - JLC568
#define	MakeSAME(%name)	$zu(191,1,%name)
 
#; Set system pointers to Unicode translation tables - JLC579
#define	SetUniPtrs(%inp,%out)	$zu(191,2,%inp,%out)
 
#; Set the character code of the Euro sign - JLC672
#define	SetEuro(%code)	$zu(191,3,%code)
 
#; Set the locale name in shared memory
#define	SetLocaleName(%name)	$zu(191,5,%name)

#; Set PhysicalCursor
#define	SetPhysicalCursor(%m)	$zu(69,37,%m)
 
#; Import/export globals for NLS classes - JLC983
#define NLSImp  ^%nls
#define NLSExp  ^||SYS.NLS
 
#;=========================================================
#;MACROS FOR DIRECT ACCESS TO NLS GLOBALS
#;=========================================================
#if 0
#define NLSLocalesGbl	^|$$$SecurityMapGroup|SYS("NLS","LocalesD")
#define NLSTablesGbl	^|$$$SecurityMapGroup|SYS("NLS","TablesD")
#define NLSSubTablesGbl	^|$$$SecurityMapGroup|SYS("NLS","SubTablesD")
#define NLSConfigGbl	^|$$$SecurityMapGroup|SYS("NLS","Config")
#else
#define NLSLocalesGbl	@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","LocalesD")
#define NLSTablesGbl	@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","TablesD")
#define NLSSubTablesGbl	@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","SubTablesD")
#define NLSConfigGbl	@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","Config")
#endif

#define NLSProcessGbl	^||SYS("NLS")
 
#; Definitions for Locales
#define LocaleCharacterSetOff			2
#define	LocaleCollationTableOff			3
#define	LocaleCollationTablesOff		4
#define	LocaleCountryOff				5
#define	LocaleDescriptionOff			6
#define	LocaleIdentifierTableOff		7
#define	LocaleIdentifierTablesOff		8
#define	LocaleLanguageOff				9
#define	LocaleLowerCaseTableOff			10
#define	LocaleLowerCaseTablesOff		11
#define	LocalePatternTableOff			12
#define	LocalePatternTablesOff			13
 
#define	LocaleResourceOff				15
#define	LocaleTitleCaseTableOff			16
#define	LocaleTitleCaseTablesOff		17
#define	LocaleTranDDPOff				18
#define	LocaleTranDTMDCPOff				19
#define	LocaleTranMagTapeOff			20
#define	LocaleTranPrinterOff			21
#define	LocaleTranTCPOff				22
#define	LocaleTranProgrammerOff			23
#define	LocaleTranSequentialOff			24
#define	LocaleTranSystemCallOff			25
#define	LocaleTranTerminalOff			26
#define	LocaleTranZCVTOff				27
#define	LocaleUpperCaseTableOff			28
#define	LocaleUpperCaseTablesOff		29
#define	LocaleXYTableOff				30
#define	LocaleXYTablesOff				31
#define	LocaleAMOff						32
#define	LocaleDateFormatOff				33
#define	LocaleDateMaximumOff			34
#define	LocaleDateMinimumOff			35
#define	LocaleDateSeparatorOff			36
#define	LocaleDecimalSeparatorOff		37
#define	LocaleMidnightOff				38
#define	LocaleMinusSignOff				39
#define	LocaleMonthAbbrOff				40
#define	LocaleMonthNameOff				41
#define	LocaleNoonOff					42
#define	LocaleNumericGroupSeparatorOff	43
#define	LocaleNumericGroupSizeOff		44
#define	LocalePMOff						45
#define	LocalePlusSignOff				46
#define	LocaleTimeFormatOff				47
#define	LocaleTimePrecisionOff			48
#define	LocaleTimeSeparatorOff			49
#define	LocaleWeekdayAbbrOff			50
#define	LocaleWeekdayNameOff			51
#define	LocaleYearOptionOff				52
#define	LocaleCurrencyOff				53
#define	LocalePhysicalCursorOff			54
#define	LocaleCountryAbbrOff			55
#define	LocaleLanguageAbbrOff			56
 
#define GetLocaleCharacterSet(%Record)			$LG(%Record,$$$LocaleCharacterSetOff)
#define	GetLocaleCollationTable(%Record)		$LG(%Record,$$$LocaleCollationTableOff)
#define	GetLocaleCollationTables(%Record)		$LG(%Record,$$$LocaleCollationTablesOff)
#define	GetLocaleCountry(%Record)				$LG(%Record,$$$LocaleCountryOff)
#define	GetLocaleDescription(%Record)			$LG(%Record,$$$LocaleDescriptionOff)
#define	GetLocaleIdentifierTable(%Record)		$LG(%Record,$$$LocaleIdentifierTableOff)
#define	GetLocaleIdentifierTables(%Record)		$LG(%Record,$$$LocaleIdentifierTablesOff)
#define	GetLocaleLanguage(%Record)				$LG(%Record,$$$LocaleLanguageOff)
#define	GetLocaleLowerCaseTable(%Record)		$LG(%Record,$$$LocaleLowerCaseTableOff)
#define	GetLocaleLowerCaseTables(%Record)		$LG(%Record,$$$LocaleLowerCaseTablesOff)
#define	GetLocalePatternTable(%Record)			$LG(%Record,$$$LocalePatternTableOff)
#define	GetLocalePatternTables(%Record)			$LG(%Record,$$$LocalePatternTablesOff)
 
#define	GetLocaleResource(%Record)				$LG(%Record,$$$LocaleResourceOff)
#define	GetLocaleTitleCaseTable(%Record)		$LG(%Record,$$$LocaleTitleCaseTableOff)
#define	GetLocaleTitleCaseTables(%Record)		$LG(%Record,$$$LocaleTitleCaseTablesOff)
#define	GetLocaleTranDDP(%Record)				$LG(%Record,$$$LocaleTranDDPOff)
#define	GetLocaleTranDTMDCP(%Record)			$LG(%Record,$$$LocaleTranDTMDCPOff)
#define	GetLocaleTranMagTape(%Record)			$LG(%Record,$$$LocaleTranMagTapeOff)
#define	GetLocaleTranPrinter(%Record)			$LG(%Record,$$$LocaleTranPrinterOff)
#define	GetLocaleTranTCP(%Record)				$LG(%Record,$$$LocaleTranTCPOff)
#define	GetLocaleTranProgrammer(%Record)		$LG(%Record,$$$LocaleTranProgrammerOff)
#define	GetLocaleTranSequential(%Record)		$LG(%Record,$$$LocaleTranSequentialOff)
#define	GetLocaleTranSystemCall(%Record)		$LG(%Record,$$$LocaleTranSystemCallOff)
#define	GetLocaleTranTerminal(%Record)			$LG(%Record,$$$LocaleTranTerminalOff)
#define	GetLocaleTranZCVT(%Record)				$LG(%Record,$$$LocaleTranZCVTOff)
#define	GetLocaleUpperCaseTable(%Record)		$LG(%Record,$$$LocaleUpperCaseTableOff)
#define	GetLocaleUpperCaseTables(%Record)		$LG(%Record,$$$LocaleUpperCaseTablesOff)
#define	GetLocaleXYTable(%Record)				$LG(%Record,$$$LocaleXYTableOff)
#define	GetLocaleXYTables(%Record)				$LG(%Record,$$$LocaleXYTablesOff)
#define	GetLocaleAM(%Record)					$LG(%Record,$$$LocaleAMOff)
#define	GetLocaleDateFormat(%Record)			$LG(%Record,$$$LocaleDateFormatOff)
#define	GetLocaleDateMaximum(%Record)			$LG(%Record,$$$LocaleDateMaximumOff)
#define	GetLocaleDateMinimum(%Record)			$LG(%Record,$$$LocaleDateMinimumOff)
#define	GetLocaleDateSeparator(%Record)			$LG(%Record,$$$LocaleDateSeparatorOff)
#define	GetLocaleDecimalSeparator(%Record)		$LG(%Record,$$$LocaleDecimalSeparatorOff)
#define	GetLocaleMidnight(%Record)				$LG(%Record,$$$LocaleMidnightOff)
#define	GetLocaleMinusSign(%Record)				$LG(%Record,$$$LocaleMinusSignOff)
#define	GetLocaleMonthAbbr(%Record)				$LG(%Record,$$$LocaleMonthAbbrOff)
#define	GetLocaleMonthName(%Record)				$LG(%Record,$$$LocaleMonthNameOff)
#define	GetLocaleNoon(%Record)					$LG(%Record,$$$LocaleNoonOff)
#define	GetLocaleNumericGroupSeparator(%Record) $LG(%Record,$$$LocaleNumericGroupSeparatorOff)
#define	GetLocaleNumericGroupSize(%Record)		$LG(%Record,$$$LocaleNumericGroupSizeOff)
#define	GetLocalePM(%Record)					$LG(%Record,$$$LocalePMOff)
#define	GetLocalePlusSign(%Record)				$LG(%Record,$$$LocalePlusSignOff)
#define	GetLocaleTimeFormat(%Record)			$LG(%Record,$$$LocaleTimeFormatOff)
#define	GetLocaleTimePrecision(%Record)			$LG(%Record,$$$LocaleTimePrecisionOff)
#define	GetLocaleTimeSeparator(%Record)			$LG(%Record,$$$LocaleTimeSeparatorOff)
#define	GetLocaleWeekdayAbbr(%Record)			$LG(%Record,$$$LocaleWeekdayAbbrOff)
#define	GetLocaleWeekdayName(%Record)			$LG(%Record,$$$LocaleWeekdayNameOff)
#define	GetLocaleYearOption(%Record)			$LG(%Record,$$$LocaleYearOptionOff)
#define	GetLocaleCurrency(%Record)				$LG(%Record,$$$LocaleCurrencyOff)
#define	GetLocalePhysicalCursor(%Record)		$LG(%Record,$$$LocalePhysicalCursorOff)
#define	GetLocaleCountryAbbr(%Record)			$LG(%Record,$$$LocaleCountryAbbrOff)
#define	GetLocaleLanguageAbbr(%Record)			$LG(%Record,$$$LocaleLanguageAbbrOff)
 
#; Definitions for Tables
#define	TableDescriptionOff				2
#define	TableIdentifiersOff				3
#define	TableSubTableNameOff			4
#define	TableTypeOff					5
#define	TableXLTDefaultActionOff		6
#define	TableXLTModeTableNameOff		7
#define	TableXLTReplacementValueOff		8
#define	TableXLTReversibilityOff		9
#define	TableXLTTypeOff					10
#define	TablePatAliasesOff				12
#define	TablePatCodesOff				13
#define	TableCOLRulesOff				14
 
#define	GetTableDescription(%Record)			$LG(%Record,$$$TableDecriptionOff)
#define	GetTableIdentifiers(%Record)			$LG(%Record,$$$TableIdentifiersOff)
#define	GetTableSubTableName(%Record)			$LG(%Record,$$$TableSubTableNameOff)
#define	GetTableType(%Record)					$LG(%Record,$$$TableTypeOff)
#define	GetTableXLTDefaultAction(%Record)		$LG(%Record,$$$TableXLTDefaultActionOff)
#define	GetTableXLTModeTableName(%Record)		$LG(%Record,$$$TableXLTModeTableNameOff)
#define	GetTableXLTReplacementValue(%Record)	$LG(%Record,$$$TableXLTReplacementValueOff)
#define	GetTableXLTReversibility(%Record)		$LG(%Record,$$$TableXLTReversibilityOff)
#define	GetTableXLTType(%Record)				$LG(%Record,$$$TableXLTTypeOff)
#define	GetTablePatAliases(%Record)				$LG(%Record,$$$TablePatAliasesOff)
#define	GetTablePatCodes(%Record)				$LG(%Record,$$$TablePatCodesOff)
#define	GetTableCOLRules(%Record)				$LG(%Record,$$$TableCOLRulesOff)
 
#; Used by class %SYS.Date.SlidingWindow
#define CvtAbsStart(%year)		$ZDH(%year_"-01-01",3)
#define CvtAbsEnd(%year)		$ZDH(%year_"-12-31",3)
#define CvtRelStart(%relyear)	$ZDH($ZD($H,3)-%relyear_"-01-01",3)
#define CvtRelEnd(%relyear)		$ZDH($ZD($H,3)+%relyear-1_"-12-31",3)

#endif %syNLS