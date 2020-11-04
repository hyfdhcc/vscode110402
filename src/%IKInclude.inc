ROUTINE %IKInclude [Type=INC]
#include %IKPublic

#define MARKDATALOADED(%domainid)       Set ^ISC.IK.DataLoaded(%domainid)=$$$IKOK
#define ISDATAAPPEND(%domainid)         $Data(^ISC.IK.DataLoaded(%domainid))

#define CHECKLICENSE		quit:$$iKnow^%SYS.LICENSE()=0 $$$ERROR($$$IKLicenseError)
#define CHECKLICENSEX(%sc)	if '$$iKnow^%SYS.LICENSE() { set %sc = $$$ERROR($$$IKLicenseError)  quit }
#define CHECKLICENSER(%sc,%ret) if '$$iKnow^%SYS.LICENSE() { set %sc = $$$ERROR($$$IKLicenseError)  quit %ret }

#define IKCHECKPRIV(%a)		  	do GetNSInfo^%SYS.NAMESPACE($namespace,.i) ##continue
	quit:$System.Security.Check($g(i("Resource")),%a)=0 $$$ERROR($$$IKSecurityError) ##continue
	kill i
#define IKCHECKPRIVX(%a,%sc)	  	do GetNSInfo^%SYS.NAMESPACE($namespace,.i)  ##continue
	if ($System.Security.Check($g(i("Resource")),%a)=0) { set %sc = $$$ERROR($$$IKSecurityError) quit } ##continue
	kill i
#define IKCHECKPRIVR(%a,%sc,%ret) do GetNSInfo^%SYS.NAMESPACE($namespace,.i)  ##continue
	if ($System.Security.Check($g(i("Resource")),%a)=0) { set %sc = $$$ERROR($$$IKSecurityError) quit %ret } ##continue
	kill i

#define IKCHECKPRIVADMIN		  	$$$IKCHECKPRIV("W")
#define IKCHECKPRIVADMINX(%sc)	  	$$$IKCHECKPRIVX("W",%sc)
#define IKCHECKPRIVADMINR(%sc,%ret) $$$IKCHECKPRIVR("W",%sc,%ret)

#define IKCHECKPRIVWRITE		  	$$$IKCHECKPRIV("W")
#define IKCHECKPRIVWRITEX(%sc)	  	$$$IKCHECKPRIVX("W",%sc)
#define IKCHECKPRIVWRITER(%sc,%ret) $$$IKCHECKPRIVR("W",%sc,%ret)

#define IKCHECKPRIVREAD		  		//$$$CHECKPRIV("R")
#define IKCHECKPRIVREADX(%sc)	  	//$$$CHECKPRIVX("R",%sc)
#define IKCHECKPRIVREADR(%sc,%ret)  //$$$CHECKPRIVR("R",%sc,%ret)


/// -----------------------------------------
/// Feature codes
/// -----------------------------------------
#define USEPREFETCH
#define	COMPOSITESRCID

/// -----------------------------------------
/// Output Format modes
/// -----------------------------------------
#define IKFORMATTEXT    1
#define IKFORMATDO      2
#define IKFORMATDOTRACE 3
#define IKFORMATDOEXTRAENTITY	4
///iFind codes.
#define IKFORMATIFBASIC 5


/// -----------------------------------------
/// Status codes
/// -----------------------------------------
#define IKOK            1
#define IKFAIL          -1
#define IKUNPROCESSED   0

#define IKPROCRUNNING   1
#define IKPROCDONE      2

/// -----------------------------------------
/// Engine status format codes
/// -----------------------------------------

#DEFINE IKENGMESSAGEISEMPTY                     0
#DEFINE IKENGMESSAGEISCACHESTATUS       -1
#DEFINE IKENGMESSAGEISCACHEMESSAGE      -2
#DEFINE IKENGMESSAGEISGENERALERROR      -3

/// -----------------------------------------
/// Direct input keys
/// -----------------------------------------
#define CONCEPT         $$$ENTTYPECONCEPT
#define RELATION        $$$ENTTYPERELATION
#define NONREL          $$$ENTTYPENONREL
#define PATHREL			$$$ENTTYPEPATHREL

#define IKMAXTYPE       1

#define IKENGEXTID      99
#define IKENGSUMMARY    2
#define IKENGSENTENCE   3
#define IKENGCONCEPT    4
#define IKENGRELATION   5
#define IKENGCRC        8

#define IKDOCRC         0
#define IKDOPATH        1
#define IKDOSENTENCE    2
#define IKDOSENTTYPE    3
#define IKDOSOURCE      4
#define IKDOENTITIES    5
#define IKDOENTFREQ     6
#define IKDOLITERALS    7
#define IKDOLITENT      8
#define IKDOSRCCRCATTRIB        9
#define IKDOSRCPATHATTRIB       10
#define IKDOSENTENTATTRIB       11
#define IKDOCONTINUATION    12
#define	IKDOENTFREQDOM		13
#define	IKDOENTPROXIMITY	14
#define IKDOUNICRC			15
#define	IKDOPATHEXTRA		16
#define	IKDOSRCEXTRA		17
#define	IKDOCRCEXTRA		18
 // lists corresponding entity for each literal
#define IKDOSENTLIT 		21
 // emit stems separately 
#define IKDOSTEMS 			22
 // frequency information for stems
#define IKDOSTEMFREQ 		23
 // corresponding stem per sentence entity
#define IKDOSENTSTEMS 		24

/// -----------------------------------------
/// Tracing
/// -----------------------------------------
#define IKDOTRACE		70

/// -----------------------------------------
/// Configurations
/// -----------------------------------------
#define IKLANGUAGES             $LB("en","fr","de","nl","es","pt","ru","uk","ja","sv")

/// -----------------------------------------
/// System configuration macros
/// -----------------------------------------
#define SORTFIELDFREQ                   $$$SORTBYFREQUENCY
#define SORTFIELDSPREAD                 $$$SORTBYSPREAD

/// -----------------------------------------
/// Indexer variables
/// -----------------------------------------
#define IKQUERY         -4
#define IKEXECUTE       -5

#define IKLOADLIB       1
#define IKUNLOADLIB     2
#define IKLOADFUNC      3

#define IKENGINEWIN     "iKnowDirectBinding.dll"
#define IKENGINEUNIX    "libiknowdirectbinding."

#define FUNGETSTATUSCODE                        1
#define FUNGETSTATUSMESSAGE                     2
#define FUNGETSTATUSPARAMETERCOUNT              3
#define FUNGETSTATUSPARAMETER                   4
#define FUNCREATEINDEXER                        5
#define FUNDESTROYINDEXER                       6
#define FUNLOADKNOWLEDGEBASE                    7
#define FUNUNLOADKNOWLEDGEBASE                  8
#define FUNLOADLANGUAGEBASE                     9
#define FUNUNLOADLANGUAGEBASE                   10
#define FUNCLEARBUFFER                          11
#define FUNBUFFERSTRING                         12
#define FUNBUFFERSTRINGWITHTRANSLATION          13
#define FUNINDEXBUFFER                          14
#define FUNENABLESUMMARIZER                     15
#define FUNDISABLESUMMARIZER                    16
#define FUNISSUMMARIZERENABLED                  17
#define FUNSETSUMMARIZERMODE                    18
#define FUNGETSUMMARIZERMODE                    19
#define FUNSETSUMMARIZERSENTENCECOUNT           20
#define FUNGETSUMMARIZERSENTENCECOUNT           21
#define FUNSETSUMMARIZERDOCUMENTFRACTION        22
#define FUNGETSUMMARIZERDOCUMENTFRACTION        23
#define FUNENABLEMERGERELATIONS                 24
#define FUNDISABLEMERGERELATIONS                25
#define FUNISMERGERELATIONSENABLED              26
#define FUNSETUSERDICTIONARY                    27
#define FUNCLEARUSERDICTIONARY                  28
#define FUNSETMAXCONCEPTLENGTH					29
#define FUNGETMAXCONCEPTLENGTH					30

/// -----------------------------------------
/// Process variables
/// -----------------------------------------
#define IKHASHSIZE      150
#define MINSORTSIZE     4096

/// -----------------------------------------
/// Offsets in ^ISC.IK.SrcDetails
/// -----------------------------------------
/// $lb(sentBase,sentCnt,entOccBase,entOccCnt,crcOccBase,crcOccCnt,pathBase,pathCnt,
///	entCnt,litCnt,conCnt,relCnt,crcCnt,wordCnt,conSemDomTot,relSemDomTot,crcSemDomTot,pathSemDomTot)

#define IKSRCSENTBASE	1
#define	IKSRCSENTCNT	2
#define	IKSRCENTOCCBASE	3
#define	IKSRCENTOCCCNT	4
#define	IKSRCCRCOCCBASE	5
#define	IKSRCCRCOCCCNT	6
#define	IKSRCPATHBASE	7
#define	IKSRCPATHCNT	8
#define	IKSRCENTUNICNT	9
#define	IKSRCLITUNICNT	10
#define	IKSRCCONUNICNT	11
#define	IKSRCRELUNICNT	12
#define	IKSRCCRCUNICNT	13
#define	IKSRCWORDCNT	14
#define	IKSRCCONSEMDOM	15
#define	IKSRCRELSEMDOM	16
#define	IKSRCCRCSEMDOM	17
#define	IKSRCPATHSEMDOM	18

#define	IKSRCCNTOFF	$C($$$IKSRCCONUNICNT,$$$IKSRCRELUNICNT,$$$IKSRCCRCUNICNT,$$$IKSRCPATHCNT)
#define	IKSRCSEMDOMOFF	$C($$$IKSRCCONSEMDOM,$$$IKSRCRELSEMDOM,$$$IKSRCCRCSEMDOM,$$$IKSRCPATHSEMDOM)

#define	IKSRCCNT(%det,%typ) +$LG(%det,$A($$$IKSRCCNTOFF,(%typ)+1))
#define	IKSRCSEMDOM(%det,%typ) +$LG(%det,$A($$$IKSRCSEMDOMOFF,(%typ)+1))

/// -----------------------------------------
/// SysParam Macros
/// -----------------------------------------
#define GETPARAM(%domainId,%parm,%def) $s($get(^ISC.IK.Sys.Params(+%domainId,%parm))'="":^(%parm),$get(^ISC.IK.Sys.NSParams(%parm))'="":^(%parm),1:%def)
#define GETPARAMNODEF(%domainId,%parm) $s($get(^ISC.IK.Sys.Params(+%domainId,%parm))'="":^(%parm),1:$get(^ISC.IK.Sys.NSParams(%parm)))
#define GETMUL(%base,%parm) $g(^ISC.IK.Sys.NSParams(%base,%parm),1)
#define	GETJOBS(%domainId,%parm,%def) (($$$GETPARAM(%domainId,$$$IKPJOBS,%def)*$g(^ISC.IK.Sys.NSParams($$$IKPMULTIPLIER,%parm),1)*$g(^ISC.IK.Sys.Params(%domainId,$$$IKPMULTIPLIER,%parm),1)+.5)\1)
#define SETMAXJOBS(%var,%domainId,%parm,%def,%lim) Set %lim=$$$GETPARAMNODEF(%domainId,"MaxJobs") If %lim="" { Set %lim=$System.CPU.%New().nThreads Set:%lim>$$$IKPMAXJOBS %lim=$$$IKPMAXJOBS } Set %var=$$$GETJOBS(%domainId,%parm,%def),%var=$s(%var<1:1,%var>%lim:%lim,1:%var)

#define GETPARAMDEFAULT(%parm)		$case(%parm,$$$IKPSORTFIELD:$$$IKPDEFSORTFIELD,$$$IKPMETADATAAPI:$$$IKPDEFMETADATAAPI,$$$IKPMATCHSCOREMARGIN:$$$IKPDEFMATCHSCOREMARGIN,$$$IKPENABLEFILTERCACHE:$$$IKPDEFENABLEFILTERCACHE,$$$IKPMATSKIPRELATIONS:$$$IKPDEFMATSKIPRELATIONS,$$$IKPDEFAULTCONFIG:$$$DEFAULTCONFIG,$$$IKPMINTOPCONCEPTLENGTH:$$$IKPDEFMINTOPCONCEPTLENGTH,$$$IKPDISABLEJOURNALLING:$$$IKPDEFDISABLEJOURNALLING,:"")

/// Checks whether users should be allowed to change the value of the specified parameter through %iKnow.Domain.SetParameter()
#define IKALLOWUSERSET(%parm)		($lf($lb($$$IKPENABLEDEBUG,$$$IKPENABLENGRAMS,$$$IKPENABLEPREFETCH,$$$IKPENABLETIMINGS,$$$IKPENTITYLEVELMATCHONLY,$$$IKPFULLMATCHONLY,$$$IKPIGNOREDUPLICATEEXTIDS,$$$IKPIGNOREEMPTYBATCH,$$$IKPJOBS,$$$IKPLANGUAGEFIELDNAME,$$$IKPMETADATAAPI,$$$IKPMULTIPLIER,$$$IKPSIMPLEEXTIDS,$$$IKPSKIPEXTIDCHECK,$$$IKPSORTFIELD,$$$IKPSTATUS,$$$IKPMATSKIPRELATIONS,$$$IKPDEFAULTCONFIG,$$$IKPMATDEFAULTPROFILE,$$$IKPMINTOPCONCEPTLENGTH,$$$IKPDSBLACKLIST,$$$IKPMATSTANDARDIZEDFORM,$$$IKPSTEMMING,$$$IKPDISABLEJOURNALLING,$$$IKPMATCHNGRAMS),%parm)>0)

/// Checks whether the value of the specified parameter can be changed for non-empty domains
#define IKONLYCHANGEWHENEMPTY(%parm)	($lf($lb($$$IKPENABLENGRAMS,$$$IKPSIMPLEEXTIDS,$$$IKPMETADATAAPI,$$$IKPSORTFIELD,$$$IKPMATSTANDARDIZEDFORM,$$$IKPSTEMMING),%parm)>0)

#define ENABLEDEBUG(%domainId)      $$$GETPARAMNODEF(%domainId,$$$IKPENABLEDEBUG)
#define ENABLENGRAMS(%domainId)     $$$GETPARAMNODEF(%domainId,$$$IKPENABLENGRAMS)
#define ENABLETIMINGS(%domainId)    $$$GETPARAMNODEF(%domainId,$$$IKPENABLETIMINGS)
#define ENABLEPREFETCH(%domainId)   $$$GETPARAMNODEF(%domainId,$$$IKPENABLEPREFETCH)
#define SAVETEMPDATA(%domainId)     $$$GETPARAMNODEF(%domainId,$$$IKPSAVETEMP)
#define DEBUGWAIT(%domainId)        $$$GETPARAMNODEF(%domainId,$$$IKPDEBUGWAIT)

#define SKIPEXTIDCHECK(%domainId)   $$$GETPARAMNODEF(%domainId,$$$IKPSKIPEXTIDCHECK)
#define SIMPLEEXTIDS(%domainId)     $$$GETPARAMNODEF(%domainId,$$$IKPSIMPLEEXTIDS)
#define	SORTFIELD(%domainId)	    $$$GETPARAM(%domainId,$$$IKPSORTFIELD,$$$IKPDEFSORTFIELD)
#define	IKMETADATAAPI(%domainId)	$$$GETPARAM(%domainId,$$$IKPMETADATAAPI,$$$IKPDEFMETADATAAPI)
#define IKFULLMATCHONLY(%domainId)	$$$GETPARAMNODEF(%domainId,$$$IKPFULLMATCHONLY)
#define IKENTMATCHONLY(%domainId)   $$$GETPARAMNODEF(%domainId,$$$IKPENTITYLEVELMATCHONLY)

#define INDEXSORTSIZE(%domainId)        ($$$JOBSORTSIZE(%domainId)+1023\1024*1024)
#define INDEXHASHSORTSIZE(%domainId)    ($$$JOBSORTSIZE(%domainId)+1023\1024*1024/64)

#define	IKPDEFJOBBLOCKSIZE	1024

#define	IKPSORTSIZE "SortSize"
#define JOBSORTSIZE(%domainId)  $$$GETPARAM(%domainId,$$$IKPSORTSIZE,262144)

#define INITFLAGS                                               ##continue
    New %IKStatus,%IKSaveTemp,%IKDebug,%IKTimings,%IKPrefetch,%IKUpdate,%IKVersion,%IKStemming ##continue
    Set %IKStatus=$$$GETPARAMNODEF(%domainId,$$$IKPSTATUS)      ##continue
    Set %IKSaveTemp=$$$SAVETEMPDATA(%domainId)                  ##continue
    Set %IKDebug=$$$ENABLEDEBUG(%domainId)                      ##continue
    Set %IKTimings=$$$ENABLETIMINGS(%domainId)                  ##continue
    Set %IKPrefetch=$$$ENABLEPREFETCH(%domainId)                ##continue
    Set %IKVersion=$$$IKVERSION(%domainId)                	##continue
    Set %IKUpdate=$$$ISDATAAPPEND(%domainId)				##continue
    set %IKStemming=($$$GETPARAM(%domainId,$$$IKPSTEMMING,0)'=0)

#define IKSTAGE %iksCrc,%iksPath,%iksSent,%iksEnt,%iksType,%iksFreq,%iksLitE,%iksMeta,%iksCrcA,%iksPathA,%iksSentA,%iksSrc,%iksKey,%iksLit,%iksProx,%iksCrcUni,%iksStems,%iksStemFreq,%iksSentStems
#define	IKSTAGEGLO ^||%IKS.Key,^||%IKS.Freq,^||%IKS.Lit,^||%IKS.LitE,^||%IKS.Crc,^||%IKS.Path,^||%IKS.Sent,^||%IKS.Ent,^||%IKS.Type,^||%IKS.PathA,^||%IKS.Prox,^||%IKS.CrcUni

/// -----------------------------------------
/// Error macros
/// -----------------------------------------
#define IKERROR(%domainid,%sc,%loc) Set ^ISC.IKL.ErrorLog(%domainid,$i(^ISC.IKL.ErrorLog(%domainid)))=$lb(%sc,%loc,$h) Do BACK^%ETN

#define CATCHERROR      Set retval=$$$ERROR($$$IKCaughtError,##QUOTE($$$PHASE),$ZE) ##continue
						$$$IKERROR(%domainId,retval,##QUOTE($$$PHASE)) ##continue
                        Break:$$$ENABLEDEBUG(%domainId)

#define NOERROR         Set retval=$$$OK

#define RETURNRESULT    Quit retval


/// -----------------------------------------
/// Timing macros
/// -----------------------------------------
#define STARTTIMING(%domainid,%pid)     Set:%IKTimings ^ISC.IKL.Timings(%domainid,##QUOTE($$$PHASE),%pid)=$lb($zh)
#define ENDTIMING(%domainid,%pid)       Set:%IKTimings IKINCbeg=^ISC.IKL.Timings(%domainid,##QUOTE($$$PHASE),%pid),^(%pid)=IKINCbeg_$lb($zh-$li(IKINCbeg))
#define STARTTIMINGS(%domainid) Set:%IKTimings IKINCbeg=$zh
#define ENDTIMINGS(%domainid)   Set:%IKTimings IKINCbeg=$I(^ISC.IKL.Timings(%domainid,##QUOTE($$$PHASE)),$zh-IKINCbeg)

#define SETSORTSIZE(%size)              Set IKOLDsortsize=$zu(121,0,1,%size)

#define INITTEMPGLO(%glo)		Kill @%glo Set IKrc=$zu(178,"",$e(%glo,2,*),5) Set ^ISC.IKS.Globals(domainId,%glo)=""

#define INITJOBSORTSIZE(%domainid,%num)      Set IKINCsortsize=($$$JOBSORTSIZE(%domainid)/%num)+512\1024*1024 Set:IKINCsortsize<4096 IKINCsortsize=4096 Set:%IKTimings ^ISC.IKL.Log(%domainId,##QUOTE($$$PHASE))=IKINCsortsize $$$SETSORTSIZE(IKINCsortsize)

#define LOGSORTBEGIN(%globname,%pid)            ##continue
        Set IKINCsortstart=$zh                  ##continue
        Set IKINCbegres=$sortbegin(@%globname@(%domainId)) ##continue
        Set:%IKTimings ^ISC.IKL.SortTimings(%domainId,%globname,%pid)=$lb(IKINCsortstart,IKINCbegres)
        
#define LOGSORTBEGINV(%globname,%pid)            ##continue
        Set IKINCsortstart=$zh                  ##continue
        Set IKINCbegres=$sortbegin(@%globname@(%domainId,%srcId)) ##continue
        Set:%IKTimings ^ISC.IKL.SortTimings(%domainId,%globname,%pid)=$lb(IKINCsortstart,IKINCbegres)

#define LOGSORTEND(%globname,%pid)              ##continue
        Set IKINCsortset=$zh,IKINCendres=$sortend(@%globname@(%domainId)),IKINCsortend=$zh             ##continue
        Set:%IKTimings IKINCcur=^ISC.IKL.SortTimings(%domainId,%globname,%pid),           ##continue
                       ^(%pid)=IKINCcur_$lb(IKINCsortset-$li(IKINCcur),IKINCsortend-IKINCsortset,IKINCendres)
                       
#define LOGSORTENDV(%globname,%pid)              ##continue
        Set IKINCsortset=$zh,IKINCendres=$sortend(@%globname@(%domainId,%srcId)),IKINCsortend=$zh             ##continue
        Set:%IKTimings IKINCcur=^ISC.IKL.SortTimings(%domainId,%globname,%pid),           ##continue
                       ^(%pid)=IKINCcur_$lb(IKINCsortset-$li(IKINCcur),IKINCsortend-IKINCsortset,IKINCendres)

#define LOGSORTBEGNAM(%globname,%pid)           ##continue
        Set IKINCsortstart=$zh                  ##continue
        Set IKINCbegres=$sortbegin(@%globname)  ##continue
        Set:%IKTimings ^ISC.IKL.SortTimings(%domainId,%globname,%pid)=$lb(IKINCsortstart,IKINCbegres)

#define LOGSORTENDNAM(%globname,%pid)           ##continue
        Set IKINCsortset=$zh,IKINCendres=$sortend(@%globname),IKINCsortend=$zh             ##continue
        Set:%IKTimings IKINCcur=^ISC.IKL.SortTimings(%domainId,%globname,%pid),           ##continue
                       ^(%pid)=IKINCcur_$lb(IKINCsortset-$li(IKINCcur),IKINCsortend-IKINCsortset,IKINCendres)

/// -----------------------------------------
/// Initial load / data append macros
/// -----------------------------------------


#define IKKILLTMP(%glo) Kill:'%IKSaveTemp %glo

#define IKCURRENTCNT            0
#define IKFINALCNT              -1
#define IKMAXCNT                -2
#define IKPHASEINFO             -3
#define IKPHASEINIT             -4
#define IKPHASEEND              -5

#define IKISOPCODE(%x)          (%x'>0)
#define IKISCURRENTCNT(%x)      ('%x)
#define IKISCURFINALCNT(%x)     (%x>-2)
#define IKISMAXFINALCNT(%x)     (%x>-3)


/// -----------------------------------------
/// Building Flags    
/// -----------------------------------------

///				Global (^ISC.IK.xxx)	Depends on globals:

#define	IKBENTUNIDET	1	/* EntUniDetails */
#define	IKBENTUNISRC	2	/* EntUniToSrcBit */
#define	IKBENTUNIBIT	3	/* EntUniToOccBit,EntUniToPathBit,EntUniToSentBit */
#define	IKBENTUNIFREQ	4	/* EntUniIdFreq		(EntUniDetails) */
#define	IKBENTUNISPREAD	5	/* EntUniIdSpread		(EntUniDetails) */
#define	IKBPARTS	6	/* EntParts		(EntUniDetails) */
#define	IKBNGRAMS	7	/* EntNgrams		(EntUniDetails) */
#define	IKBCRCUNIDET	8	/* CrcUniDetails */
#define	IKBCRCUNISRC	9	/* CrcUniToSrcBit */
#define	IKBCRCUNIBIT	10	/* CrcUniToOccBit,CrcUniToSentBit */
#define	IKBCRCUNIMAP	11	/* EntUniMToCrcUniBit,EntUniRToCrcUniBit,EntUniSToCrcUniBit */
#define	IKBCRCUNIFREQ	12	/* CrcUniIdFreq		(CrcUniDetails) */
#define	IKBCRCUNISPREAD	13	/* CrcUniIdSpread		(CrcUniDetails) */
#define	IKBCRCENTFREQ	14	/* CrcEntUniFreq	(CrcUniDetails) */
#define	IKBCRCENTSPREAD	15	/* CrcEntUniSpread	(CrcUniDetails) */
#define	IKBCCUNIALL	16	/* CcUni,CcUniId,CcUniExistsBit,SrcToCcUniBit */
#define	IKBCCUNIDET	17	/* CcUniDet (CcUniAll) */
#define	IKBCCUNISRC	18	/* CcUniToSrcBit (CcUniAll) */
#define	IKBCCUNIBIT	19	/* CcUniToOccBit,CcUniToSentBit (CcUniAll) */
#define	IKBCCUNIMAP	20	/* EntUniMToCcUniBit,EntUniSToCcUniBit,EntUniMToEntUniSBit,EntUniSToEntUniMBit (CcUniAll) */
#define	IKBCCUNIFREQ	21	/* CcUniIdFreq		(CcUniDet) */
#define	IKBCCUNISPREAD	22	/* CcUniIdSpread		(CcUniDet) */
#define	IKBCCENTFREQ	23	/* CcEntCombiFreq	(CcUniDet) */
#define	IKBCCENTSPREAD	24	/* CcEntCombiSpread	(CcUniDet) */
#define	IKBPATH		25	/* PathId */
#define	IKBSPVALUE	26	/* SP.Value */
#define	IKBSDORD	27	/* SD.Profile */
#define	IKBDOMPROF	28	/* SD.DomProf		(EntUniDetails,CrcUniDetails) */
#define	IKBSRCENTUNI	29	/* SrcToEntUniBit */
#define	IKBSRCCRCUNI	30	/* SrcToCrcUniBit */

#define	IKBSTEMUNIDET	31	/* StemUniDetails */
#define	IKBSTEMUNISRC	32	/* StemUniToSrcBit */
#define	IKBSTEMUNIBIT	33	/* StemUniToOccBit,StemUniToPathBit,StemUniToSentBit */
#define	IKBSTEMUNIFREQ	34	/* StemUniIdFreq		(StemUniDetails) */
#define	IKBSTEMUNISPREAD	35	/* StemUniIdSpread		(StemUniDetails) */
#define	IKBSTEMPARTS	36	/* StemParts		(StemUniDetails) */
#define	IKBSTEMNGRAMS	37	/* StemNgrams		(StemUniDetails) */
#define IKBSRCSTEMUNI	38	/* SrcToStemUniBit */

#define	MINBUILDFLAGS $c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,0,0,0,0,0,0,0,255)
#define	ALLBUILDFLAGS $c(255,255,255,255,255,255,  0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255)

#define MINDSBUILDFLAGS $c(255,255,255,0,255,255,0,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,255,0,255,255,255,255,255,0,255,255,0,255)

#define IKBUILDFLAGSNAME(%f) $case(%f, $$$MINBUILDFLAGS:"MINIMAL", $$$ALLBUILDFLAGS:"ALL", $$$MINDSBUILDFLAGS:"DEEPSEEMINIMAL", :%f)
#define IKBUILDFLAGSFLAGS(%n) $case($$$UPPER(%n), "MINIMAL":$$$MINBUILDFLAGS, "ALL":$$$ALLBUILDFLAGS, "DEEPSEEMINIMAL":$$$MINDSBUILDFLAGS, :%n)

#define	OLDBUILDFLAGS $$$ALLBUILDFLAGS
#define	DEFBUILDFLAGS $$$ALLBUILDFLAGS

#define VERSIONBUILDFLAGS(%v) $s(%v<=$$$IKVERSIONOPTIONALGLOBALS:$$$ALLBUILDFLAGS, 1:$$$DEFBUILDFLAGS)

#define	IKBUILD(%x) $case($a(%IKBuildFlags,%x),-1:0,:$a(%IKBuildFlags,%x))

#define IKBFNEVER 0
#define IKBFINIT 1
#define IKBFBATCH 2
#define IKBFALWAYS 255


/// -----------------------------------------
/// Global structure management macros
/// -----------------------------------------
#define IKSETBIT(%glo,%domainid,%id1,%id2) Set $bit(%glo(%domainid,%id1,(%id2\64000)+1),(%id2#64000)+1)=1
#define IKSETBITLOCAL(%glo,%id,%b) Set $bit(%glo((%id\64000)+1),(%id#64000)+1)=%b
#define IKCLRBIT(%glo,%domainid,%id,%off,%pos) Set $bit(%glo(%domainid,%id,%off),%pos)=0 Kill:'$bitcount(^(%off),1) ^(%off)

#define IKMERGEBITS(%gloFrom,%gloTo,%mode) set mf = $order(@%gloFrom@(""),-1), mt = $order(@%gloTo@(""),-1), maxOff = $s(mf>mt:mf,1:mt)  for off = 1:1:maxOff { set @%gloTo@(off) = $s(%mode="AND":$bitlogic(@%gloFrom@(off) & @%gloTo@(off)), 1:$bitlogic(@%gloFrom@(off) | @%gloTo@(off))) }
#define IKMERGEBITSAND(%gloFrom,%gloTo) set mf = $order(@(%gloFrom)@(""),-1), mt = $order(@(%gloTo)@(""),-1), maxOff = $s(mf>mt:mf,1:mt)  for off = 1:1:maxOff { set @(%gloTo)@(off) = $bitlogic(@(%gloFrom)@(off) & @(%gloTo)@(off)) }
#define IKMERGEBITSOR(%gloFrom,%gloTo) set f = "" for { set f = $o(@(%gloFrom)@(f),1,b)  q:f=""  set @(%gloTo)@(f) = $bitlogic(b | @(%gloTo)@(f)) }

#define IKSETBITSEQ(%globName,%idFrom,%idTo,%bit) $$$IKBITOFFPOS(%idFrom,bitSeqOffFrom,bitSeqPosFrom) ##continue
		$$$IKBITOFFPOS(%idTo,bitSeqOffTo,bitSeqPosTo) ##continue
        for bitSeqOff = bitSeqOffFrom:1:bitSeqOffTo { ##continue
        	set bitSeqTemp = $g(@%globName@(bitSeqOff)) ##continue
            set from = $s(bitSeqOff=bitSeqOffFrom:bitSeqPosFrom, 1:1) ##continue
            set to = $s(bitSeqOff=bitSeqOffTo:bitSeqPosTo, 1:64000) ##continue
            for bitSeqPos = from:1:to { set $bit(bitSeqTemp, bitSeqPos) = %bit } ##continue
            set @%globName@(bitSeqOff) = bitSeqTemp ##continue
            kill bitSeqTemp, bitSeqPos, from, to ##continue
        } ##continue
		kill bitSeqOff, bitSeqOffFrom, bitSeqOffTo, bitSeqPosFrom, bitSeqPosTo
#define IKHASBIT(%bitstring) ($bitfind(%bitstring,1)>0)

#define IKBITOFFPOS(%id,%off,%pos)      Set %off=(%id\64000)+1,%pos=(%id#64000)+1
#define IKGETIDOFFPOS(%id,%off,%pos)    Set %id=((%off-1)*64000)+%pos-1
#define IKGETBITOFF(%id)                ((%id\64000)+1)

#define IKGETENTUNIID(%domid,%hash,%id,%val) If $l(%val)>$$$IKHASHSIZE { Set %hash=$zcrc(%val,7),%id="" Do { Set %id=$o(^ISC.IK.EntUniHash(%domid,%hash,%id)) } While %id'="",%val'=^ISC.IK.EntUniId(%domid,%id) Set %id=+%id } Else { Set %id=+$g(^ISC.IK.EntUni(%domid," "_%val)) }
#define IKGETLOCID(%hash,%tmp,%id,%val) If $l(%val)>$$$IKHASHSIZE { Set %hash=$zcrc(%val,7),%id="" Do { Set %id=$o(i%EntityCacheH(%hash,%id),1,%tmp) } While %id'="",%val'=%tmp Set %id=+%id } ElseIf %val="" { Set %id=0 } Else { Set %id=+$g(i%EntityCacheK(" "_%val)) }

#define	IKADDTEMPGLO(%glo)	Set ^ISC.IKT.Globals(%domainId,$name(%glo))=""
#define	IKADDTEMPNAM(%glo)	Set ^ISC.IKT.Globals(%domainId,%glo)=""

/// -----------------------------------------
/// ^ISC.IK.EntUniDetails macros
/// -----------------------------------------
#define IKGETFREQ(%det) ($lg(%det)+$lg(%det,2))
#define IKGETCONFREQ(%det) $lg(%det)
#define IKGETRELFREQ(%det) $lg(%det,2)
#define IKGETSPREAD(%det) $lg(%det,3)
#define IKGETCONSPREAD(%det) $lg(%det,4)
#define IKGETRELSPREAD(%det) $lg(%det,5)
#define	IKGETCONSEMDOM(%det) $lg(%det,6)
#define	IKGETRELSEMDOM(%det) $lg(%det,7)

#define IKMAKEDETAILSV1(%cfreq,%rfreq,%spread,%cspread,%rspread) $lb(%cfreq,%rfreq,%spread,%cspread,%rspread)
#define IKMAKEDETAILS(%cfreq,%rfreq,%spread,%cspread,%rspread,%cdom,%rdom) $lb(%cfreq,%rfreq,%spread,%cspread,%rspread,%cdom,%rdom)

/// -----------------------------------------
/// ^ISC.IK.CrcUniDetails macros
/// -----------------------------------------
#define IKGETCRCFREQ(%det) $lg(%det)
#define IKGETCRCSPREAD(%det) $lg(%det,2)
#define	IKGETCRCSEMDOM(%det) $lg(%det,3)

/// -----------------------------------------
/// Process management macros
/// -----------------------------------------
#define DEFAULTTIMEOUT                                  1
/// BDB: no longer used?
///#define WAITFORPROCBIT(%tempid,%name,%timeout,%count)  While '$d(^CacheTemp.ISC.IK.ProcessStatus(%tempid,%name)) { HANG %timeout } While $bitcount(^(%name),1)'=%count { Hang 1 }
///#define WAITFORPROC(%tempid,%name,%timeout) $$$WAITFORPROCBIT(%tempid,%name,%timeout,1)
#define IKSETPROCBIT(%name,%pi) Set $bit(^CacheTemp.ISC.IK.ProcessStatus(%tempId,%name),%pi)=1,^(%name,%pi)=$s($$$ISOK(retval):$$$IKOK,1:$$$IKFAIL)
#define IKSETPROCSTATUS $$$IKSETPROCBIT(##QUOTE($$$PHASE),1)
#define	IKPROCFINISHED(%count) ($bitcount(^CacheTemp.ISC.IK.ProcessStatus(%tempId,##QUOTE($$$PHASE)),1)=%count)

#define IKDISPBGR(%msg) set ^CacheTemp.ISC.IK.DomainBuild(+$j,"out",$i(^CacheTemp.ISC.IK.DomainBuild(+$j,"out"))) = %msg
#define IKDISPBGRN(%n,%msg) set ^CacheTemp.ISC.IK.DomainBuild(+$j,"out",%n) = %msg
#define IKDISPBGRI(%i,%msg) set:'$d(bgr(%i),bgrn) (bgr(%i),bgrn) = $i(^CacheTemp.ISC.IK.DomainBuild(+$j,"out")) $$$IKDISPBGRN(bgrn,%msg)
#define IKDISPSTART(%name,%out,%beg,%base) Set %beg=$zh if %out { if $g(%IKVerbose)<0 { $$$IKDISPBGRI(-2,$$ShowTime^%iKnow.BuildGlobals(%beg-%base)_"                 Starting "_%name) } else { write !,$$ShowTime^%iKnow.BuildGlobals(%beg-%base),"                 Starting ",%name,$c(13) } }
#define IKDISPFINISH(%name,%out,%beg) if %out { if ($g(%IKVerbose)<0) { $$$IKDISPBGRI(-2,$$ShowTime^%iKnow.BuildGlobals($zh-%beg)_$c(9,9,8,8,8,8,8,8,8)_"Finished "_%name) } else { w $c(13,9),$$ShowTime^%iKnow.BuildGlobals($zh-%beg),$c(9,9,8,8,8,8,8,8,8),"Finished ",%name,$c(13) } }
#define IKDISPFAILED(%name,%out,%beg) if %out { if ($g(%IKVerbose)<0) { $$$IKDISPBGRI(-2,$$ShowTime^%iKnow.BuildGlobals($zh-%beg)_$c(9,9,8,8,8,8,8,8,8)_"  Failed "_%name)} else { w $c(13,9),$$ShowTime^%iKnow.BuildGlobals($zh-%beg),$c(9,9,8,8,8,8,8,8,8),"  Failed ",%name,$c(13) } }

/// aaaa.aa 1234.xx 1234567x Starting <name>
/// aaaa.aa 1234.xx 1234567x  Running <name>
/// aaaa.aa 1234.xx 1234567x     per% <name>
/// aaaa.aa 1234.xx 1234567x Finished <name>
/// aaaa.aa 1234.xx 1234567x   Failed <name> (message)
/// 12345678abcdefgh12345678abcdefgh  <name>

#ifdef  USEPREFETCH
#define PREFETCHBEG(%glo,%pi) If %IKPrefetch { Set IKSprefres=$xecute("() Quit $prefetchon("_%glo_")") Set:%IKTimings ^ISC.IKL.Prefetch(%domainId,##QUOTE($$$PHASE),%pi,%glo,0)=IKSprefres }
#define PREFETCHEND(%glo,%pi) If %IKPrefetch { Set IKSprefres=$xecute("() Quit $prefetchoff("_%glo_")") Set:%IKTimings ^ISC.IKL.Prefetch(%domainId,##QUOTE($$$PHASE),%pi,%glo,1)=IKSprefres }
#define PREFETCHBEGN(%glo,%pi) If %IKPrefetch { Set IKSprefnam=$name(%glo) $$$PREFETCHBEG(IKSprefnam,%pi) }
#define PREFETCHENDN(%glo,%pi) If %IKPrefetch { Set IKSprefnam=$name(%glo) $$$PREFETCHEND(IKSprefnam,%pi) }
#else
#define PREFETCHBEG(%glo,%pi)
#define PREFETCHEND(%glo,%pi)
#define PREFETCHBEGN(%glo,%pi)
#define PREFETCHENDN(%glo,%pi)
#endif

#define	IKBUILT(%name) Set ^CacheTemp.ISC.IK.Built(%tempId,%name)=""

#define IKTEMPDOMID(%domId,%tempId) if '$d(^CacheTemp.ISC.IK.TempDomainId($zu(5),%domId),%tempId) { ##continue
		lock +^CacheTemp.ISC.IK.TempDomainId ##continue
		set:'$d(^CacheTemp.ISC.IK.TempDomainId($zu(5),%domId),%tempId) %tempId = $i(^CacheTemp.ISC.IK.TempDomainId), ^CacheTemp.ISC.IK.TempDomainId($zu(5),%domId) = %tempId ##continue
		lock -^CacheTemp.ISC.IK.TempDomainId ##continue
	}
#define IKGETTEMPDOMID(%domId) $g(^CacheTemp.ISC.IK.TempDomainId($zu(5),%domId))
	

/// -----------------------------------------
/// Query-related macros
/// -----------------------------------------

/// Utility macro's for "usefilter" parameter
#define CHECKFILTERFREQ(%filter,%usefilter) ($isobject(%filter)&&((%usefilter # 4) > 1))
#define CHECKFILTERSPREAD(%filter,%usefilter) ($isobject(%filter)&&((%usefilter # 8) > 3))
#define CHECKFILTERSORT(%filter,%usefilter)	($isobject(%filter)&&(%usefilter > 7))
#define CHECKFILTERONLY(%usefilter)	(%usefilter = 1)


/// Utility macro's for typical input parameter checking
#define IKCHECKSORTTYPEX(%domId,%sort,%allowed,%sc)	if (%sort=$$$SORTBYDOMAINDEFAULT)||(%sort="") { set xDefSort=$$$GETPARAM(%domId,$$$IKPSORTFIELD,"")  if (xDefSort="")||'$lf(%allowed,xDefSort) { set %sort = $$$IKPDEFSORTFIELD } else { set %sort = xDefSort } }  ##continue
	if '$lf(%allowed,%sort) { set %sc = $$$ERROR($$$InvalidArgument)  quit }

/// Utility macro's for query result handling
#define IKQCLEARPPGS(%ppgs)			if %ppgs'="" { for i=1:1:$l(%ppgs,",") { kill @($zstrip($p(%ppgs,",",i),"<>W")) } }
#define IKQBEGIN(%result,%ppgs)		if ($g(%result)="") { kill %result } ##continue
	elseif ($e(%result,1,6)="^||%IK") && ($e(%result,1,7)'="^||%IKQ") { quit $$$ERROR($$$IKReservedGlobalName,%result) } ##continue
	elseif ($e(%result)="^") { kill @%result } ##continue
	else { quit $$$ERROR($$$IKIllegalResultParam,%result) } ##continue
	kill ^||%IK.Cost ##continue
	$$$IKQCLEARPPGS(%ppgs) ##continue
	$$$CHECKLICENSE ##continue
	$$$IKCHECKPRIVREAD
#define IKQBEGINTRY(%result,%ppgs,%sc)	set %sc=$$$OK, $ztrap="errtrap" ##continue
	try { ##continue
	if ($g(%result)="") { kill %result } ##continue
	elseif ($e(%result,1,6)="^||%IK") && ($e(%result,1,7)'="^||%IKQ") { set %sc = $$$ERROR($$$IKReservedGlobalName,%result) quit } ##continue
	elseif ($e(%result)="^") { kill @%result } ##continue
	else { set %sc = $$$ERROR($$$IKIllegalResultParam,%result) quit } ##continue
	kill ^||%IK.Cost ##continue
	$$$IKQCLEARPPGS(%ppgs) ##continue
	$$$CHECKLICENSEX(%sc) ##continue
	$$$IKCHECKPRIVREADX(%sc)
#define IKQBEGINR(%ppgs,%sc,%ret)		set %sc = $$$OK ##continue
	kill ^||%IK.Cost ##continue
	$$$IKQCLEARPPGS(%ppgs) ##continue
	$$$CHECKLICENSER(%sc,%ret) ##continue
	$$$IKCHECKPRIVREADR(%sc,%ret)
#define IKQADDRESULT(%result,%i,%val)		if ($g(%result)="") { set %result(%i) = %val } else { set @%result@(%i) = %val }
#define IKQMERGERESULT(%result,%i,%val)		if ($g(%result)="") { merge %result(%i) = %val } else { merge @%result@(%i) = %val }
#define IKQADDRESULTSUB(%result,%i,%s,%val) if ($g(%result)="") { set %result(%i,%s) = %val } else { set @%result@(%i,%s) = %val }
#define IKQADDRESULTSUB2(%result,%i,%s1,%s2,%val) if ($g(%result)="") { set %result(%i,%s1,%s2) = %val } else { set @%result@(%i,%s1,%s2) = %val }
#define IKQADDRESULTSORT(%glo,%sort,%val)		set %glo(%sort,$i(%glo(%sort))) = %val
#define IKQRESORTRESULT(%flt,%fmode,%res,%glo,%up,%f,%l,%sc)	if ($$$CHECKFILTERSORT(%flt,%fmode)) { set %sc = ..CopyFromTempSortGlobal(.%res,%glo,%up,%f,%l)  quit:$$$ISERR(%sc) }
#define IKQEND(%ppgs,%ret)		$$$IKQCLEARPPGS(%ppgs) ##continue
	quit %ret
#define IKQENDCATCH(%result,%ppgs,%sc)	} catch (ex) { ##continue
		if ($isobject(ex) && (ex.Name="<STORE>") && ($g(%result)="")) { kill %result  set %sc = $$$ERROR($$$IKStoreErrorInResult) } ##continue
		else { set %sc = ex.AsStatus() } ##continue
	} ##continue
	goto end  ##continue
errtrap	##continue
	set $ztrap = "" ##continue
	if ($g(%result)="") { kill %result } else { kill @%result } ##continue
	if ($e($zerror,1,7)="<STORE>") && ($g(%result)="") { set %sc = $$$ERROR($$$IKStoreErrorInResult) } ##continue
	else { set %sc = $$$ERROR($$$IKCaughtError, "", $ze) } ##continue
end	$$$IKQEND(%ppgs,%sc)

/// Utility macro's for filters
#define IKQCONVFILTEROBJECT(%domId,%filter,%valid)  set %valid = 1 ##continue
	if '$isobject(%filter) && (%filter'="") { ##continue
		if ($zstrip(%filter,"*W") ? .(1.N1",")1.N) { set %filter = ##class(%iKnow.Filters.SourceIdFilter).%New(%domId,%filter) } ##continue
		elseif ($zstrip(%filter,"*W") ? 1.N1":"1.N) { set %filter = ##class(%iKnow.Filters.SourceIdRangeFilter).%New(%domId,$p(%filter,":",1),$p(%filter,":",2)) } ##continue
		else { set tFilterObj = ##class(%iKnow.Filters.Filter).RestoreFilterFromString(%filter)  if $isobject(tFilterObj) { set %filter = tFilterObj } else { set %valid = 0 } } ##continue
	}
#define IKQFILTEROBJECT(%domId,%filter)  			set s = ##class(%iKnow.Filters.Filter).FromString(%domId,%filter,.f) ##continue
		if $$$ISERR(s) { quit s } else { set %filter = f }
#define IKQFILTEROBJECTX(%domId,%filter,%sc)    	set %sc = ##class(%iKnow.Filters.Filter).FromString(%domId,%filter,.f) ##continue
		if $$$ISERR(%sc) { quit } else { set %filter = f }
#define IKQFILTEROBJECTR(%domId,%filter,%sc,%ret)   set %sc = ##class(%iKnow.Filters.Filter).FromString(%domId,%filter,.f) ##continue
		if $$$ISERR(%sc) { quit %ret } else { set %filter = f }
#define IKQNULLFILTER(%domId,%filter) set:'$isobject(%filter) %filter = ##class(%iKnow.Filters.BitmapFilter).%New(%domId, $name(^ISC.IK.SrcExistsBit(%domId)))


/// Utility macro's for paging
#define IKSETPAGINGVARS(%p,%ps,%up,%f,%l,%c)	if (%p>=0) { set %up=(%p*%ps)>0, %f=((%p-1)*%ps)+1, %l=%p*%ps, %c=0 } else { set %up=1, %f=-%p, %l=$zabs(%ps), %c=0 }
#define IKCHECKPAGING(%up,%f,%l,%c)		if (%up) { quit:(%c>%l)  continue:(%c<%f)  }
#define IKCHECKPAGINGSORT(%up,%f,%l,%c,%fl,%uf,%ewp)		if (%up) { if $$$CHECKFILTERSORT(%fl,%uf) { quit:(%ewp>%l)  } else { quit:(%c>%l)  continue:(%c<%f)  } }
#define IKQENTRIESWITHINPAGE(%glo,%max,%up,%l,%ewp)  if (%up) { ##continue
		set s="",%ewp=0  for { ##continue
			set s=$order(%glo(s),1,cnt)  quit:s=""  quit:s>=%max ##continue
			set %ewp = %ewp + cnt ##continue
		} ##continue
		quit:(%ewp>%l) ##continue
	}

/// Utility macro's for "positionstomatch" parameter
#define CHECKPOSM(%poscode) 	((%poscode # 2) = 1)
#define CHECKPOSR(%poscode) 	((%poscode # 4) > 1)
#define CHECKPOSS(%poscode) 	(%poscode > 3)

#define IKLIST2ARR(%list,%arr) 	k %arr  s p=0  while $listnext(%list,p,o) { s %arr(o)="" }

#define IKCHECKNOTNULL(%var)		Quit:$g(%var)="" $$$ERROR($$$InvalidArgument)
#define IKCHECKNOTNULLX(%var,%sc)	if ($g(%var)="") { set %sc=$$$ERROR($$$InvalidArgument) Quit }
#define IKCHECKNOTNULLR(%var,%sc,%ret)	if ($g(%var)="") { set %sc=$$$ERROR($$$InvalidArgument) Quit %ret }

#define IKCHECKSTRINGLENGTH(%str)           if ($l(%str)>$$$IKHASHSIZE) { quit $$$ERROR($$$IKStringTooLong,%str) }
#define IKCHECKSTRINGLENGTHX(%str,%sc)      if ($l(%str)>$$$IKHASHSIZE) { set %sc=$$$ERROR($$$IKStringTooLong,%str) Quit }
#define IKCHECKSTRINGLENGTHR(%str,%sc,%ret) if ($l(%str)>$$$IKHASHSIZE) { set %sc=$$$ERROR($$$IKStringTooLong,%str) Quit %ret }

#define IKCHECKIDEXISTS(%glo,%domId,%id,%details,%err)		quit:'$d(%glo(+%domId,%id),%details) $$$ERROR(%err,%id)
#define IKCHECKIDEXISTSX(%glo,%domId,%id,%details,%err,%sc) if '$d(%glo(+%domId,%id),%details) { set %sc = $$$ERROR(%err,%id) Quit }
#define IKCHECKIDEXISTSR(%glo,%domId,%id,%details,%err,%sc,%ret) if '$d(%glo(+%domId,%id),%details) { set %sc = $$$ERROR(%err,%id) Quit %ret }
#define IKCHECKIDNOTEXISTSR(%glo,%domId,%id,%err,%sc,%ret)	if $d(%glo(+%domId,%id)) { set %sc = $$$ERROR(%err,%id) Quit %ret }

#define CHECKDOMAINEXISTS(%domId)    	    quit:'$d(^ISC.IK.Sys.DomainD(+%domId)) $s(%domId=0:$$$ERROR($$$IKSysDomNotSupported), 1:$$$ERROR($$$IKNoDomainWithId,%domId))
#define CHECKDOMAINEXISTSX(%domId,%sc)      if ('$d(^ISC.IK.Sys.DomainD(+%domId))) { set %sc=$s(%domId=0:$$$ERROR($$$IKSysDomNotSupported), 1:$$$ERROR($$$IKNoDomainWithId,%domId)) quit }
#define CHECKDOMAINEXISTSR(%domId,%sc,%ret) if ('$d(^ISC.IK.Sys.DomainD(+%domId))) { set %sc=$s(%domId=0:$$$ERROR($$$IKSysDomNotSupported), 1:$$$ERROR($$$IKNoDomainWithId,%domId)) quit %ret }

#define	SRCEXISTS(%domId,%srcId) $bit(^ISC.IK.SrcExistsBit(%domId,(%srcId\64000)+1),(%srcId#64000)+1)
#define CHECKSRCIDEXISTS(%domId,%srcId)		  Quit:%srcId="" $$$ERROR($$$IKNoSourceSpecified) ##continue
						  Quit:'$$$SRCEXISTS(%domId,%srcId) $$$ERROR($$$IKSourceDoesNotExist,%srcId)
#define CHECKSRCIDEXISTSX(%domId,%srcId,%sc) if %srcId="" { set %sc=$$$ERROR($$$IKNoSourceSpecified) Quit } ##continue
						  If '$$$SRCEXISTS(%domId,%srcId) { set %sc=$$$ERROR($$$IKSourceDoesNotExist,%srcId) Quit }
#define CHECKSRCIDEXISTSR(%domId,%srcId,%sc,%ret) if %srcId="" { set %sc=$$$ERROR($$$IKNoSourceSpecified) Quit %ret } ##continue
						  If '$$$SRCEXISTS(%domId,%srcId) { set %sc=$$$ERROR($$$IKSourceDoesNotExist,%srcId) Quit %ret }

#define CHECKEXTIDEXISTS(%domId,%extId,%srcId)		 Quit:%extId="" $$$ERROR($$$IKNoSourceSpecified) set %srcId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(%domId,%extId)  quit:'%srcId $$$ERROR($$$IKSourceDoesNotExistE,%extId)
#define CHECKEXTIDEXISTSX(%domId,%extId,%srcId,%sc)      if (%extId="") { set %sc = $$$ERROR($$$IKNoSourceSpecified) Quit } else { set %srcId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(%domId,%extId)  if '%srcId { set %sc = $$$ERROR($$$IKSourceDoesNotExistE,%extId) Quit } }
#define CHECKEXTIDEXISTSR(%domId,%extId,%srcId,%sc,%ret) if (%extId="") { set %sc = $$$ERROR($$$IKNoSourceSpecified) Quit %ret } else { set %srcId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(%domId,%extId)  if '%srcId { set %sc = $$$ERROR($$$IKSourceDoesNotExistE,%extId) Quit %ret } }

#define CHECKVSRCIDEXISTS(%domId,%vSrcId)	    set %vSrcId=$zabs(%vSrcId) Quit:'$d(^ISC.IKV.SrcDetails(%domId,%vSrcId)) $$$ERROR($$$IKVirtualSourceNotFound,%vSrcId)
#define CHECKVSRCIDEXISTSX(%domId,%vSrcId,%sc)      set %vSrcId=$zabs(%vSrcId) If '$d(^ISC.IKV.SrcDetails(%domId,%vSrcId)) { Set %sc=$$$ERROR($$$IKVirtualSourceNotFound,%vSrcId) Quit }
#define CHECKVSRCIDEXISTSR(%domId,%vSrcId,%sc,%ret) set %vSrcId=$zabs(%vSrcId) If '$d(^ISC.IKV.SrcDetails(%domId,%vSrcId)) { Set %sc=$$$ERROR($$$IKVirtualSourceNotFound,%vSrcId) Quit %ret }

#define CHECKASRCIDEXISTS(%domId,%srcId,%srcDet,%vSrcId) ##continue
	if (%srcId<0) {					##continue
	    set %vSrcId = -%srcId			##continue
	    Quit:'$d(^ISC.IKV.SrcDetails(%domId,%vSrcId),%srcDet) $$$ERROR($$$IKVirtualSourceNotFound,%vSrcId) ##continue
	} else {					##continue
	    set %vSrcId=0				##continue
	    $$$CHECKSRCIDEXISTS(%domId,%srcId)		##continue
	    Set %srcDet=$g(^ISC.IK.SrcDetails(%domId,%srcId)) ##continue
	}
#define CHECKASRCIDEXISTSX(%domId,%srcId,%srcDet,%vSrcId,%sc) ##continue
	if (%srcId<0) {					##continue
	    set %vSrcId = -%srcId			##continue
	    If '$d(^ISC.IKV.SrcDetails(%domId,%vSrcId),%srcDet) { Set %sc=$$$ERROR($$$IKVirtualSourceNotFound,%vSrcId) Quit } ##continue
	} else {					##continue
	    set %vSrcId=0				##continue
	    $$$CHECKSRCIDEXISTSX(%domId,%srcId,%sc)	##continue
	    Set %srcDet=$g(^ISC.IK.SrcDetails(%domId,%srcId)) ##continue
	}
#define CHECKASRCIDEXISTSR(%domId,%srcId,%srcDet,%vSrcId,%sc,%ret) ##continue
	if (%srcId<0) {					##continue
	    set %vSrcId = -%srcId			##continue
	    If '$d(^ISC.IKV.SrcDetails(%domId,%vSrcId),%srcDet) { Set %sc=$$$ERROR($$$IKVirtualSourceNotFound,%vSrcId) Quit %ret } ##continue
	} else {					##continue
	    set %vSrcId=0				##continue
	    $$$CHECKSRCIDEXISTSR(%domId,%srcId,%sc,%ret)      ##continue
	    Set %srcDet=$g(^ISC.IK.SrcDetails(%domId,%srcId)) ##continue
	}

#define CHECKSTEMMING(%dom) 		quit:($$$GETPARAM(%dom,$$$IKPSTEMMING,0)=0) $$$ERROR($$$IKStemmingNotEnabled)
#define CHECKSTEMMINGX(%dom,%sc) 	if ($$$GETPARAM(%dom,$$$IKPSTEMMING,0)=0) { set %sc = $$$ERROR($$$IKStemmingNotEnabled) quit  }
#define CHECKSTEMMINGR(%dom,%sc,%r)	if ($$$GETPARAM(%dom,$$$IKPSTEMMING,0)=0) { set %sc = $$$ERROR($$$IKStemmingNotEnabled) quit %r  }
		

#define IKGLOBNAME(%domId,%glob,%srcId) $s(+%srcId<0:"^ISC.IKV."_%glob_"("_%domId_","_$zabs(%srcId)_")", 1:"^ISC.IK."_%glob_"("_%domId_")")
#define IKVGLOBNAME(%domId,%glob,%vSrcId) $s(+%vSrcId:"^ISC.IKV."_%glob_"("_%domId_","_$zabs(%vSrcId)_")", 1:"^ISC.IK."_%glob_"("_%domId_")")

#define IKENSURELISTNUM(%var) set:'$listvalid(%var)&&$isvalidnum(%var) %var = $lb(%var)
#define IKENSURELISTSTR(%var) set:'$listvalid(%var)&&$l(%var) %var = $lb(%var)
#define IKENSURELISTABS(%var) $$$IKENSURELISTNUM(%var) set ptr=0,l=""  while $listnext(%var,ptr,li) { s l=l_$lb($zabs(li)) } s %var=l

#define IKENSUREISMATCHED(%domId,%srcId,%dicts) 		if '..IsFullyMatched(%domId,%srcId,%dicts) { set tSC = ..MatchSource(%domId,%srcId,%dicts)  quit:$$$ISERR(tSC) tSC }
#define IKENSUREISMATCHEDX(%domId,%srcId,%dicts,%sc) 	if '..IsFullyMatched(%domId,%srcId,%dicts) { set %sc = ..MatchSource(%domId,%srcId,%dicts)  quit:$$$ISERR(%sc) }

#define IKSORTABLEDATE(%h) +$p(%h,",",1)+($p(%h,",",2)/100000)

#define IKDOMAINCHANGED(%domId) set xxx=$i(^ISC.IK.Sys.DomainU(%domId))
#define IKDOMAINU(%domId) +$g(^ISC.IK.Sys.DomainU(%domId))

#define IKISQUOTED(%s) ($find("""'",$e($zstrip(%s,"<>WC"),1,1))>0)
#define IKSTRIPQUOTES(%s,%all)	set %s = $s(%all:$translate($e(%s,2,*-1),"""'"), 1:$e(%s,2,*-1))

///#define IKCONVERTMATCHINGCASE(%domId,%v) set caseType=$$$IKMATCHINGCASE(%domId), %v=$case(caseType, $$$IKMATCHINGCASENONE:%v, :$zconvert(%v,caseType))
///#define IKCONVERTMATCHINGCASE2(%ct,%v) set %v=$case(%ct, $$$IKMATCHINGCASENONE:%v, :$zconvert(%v,%ct))

#define IKBUILDBLACKLIST(%domId,%ids,%vSrcId) do ##class(%iKnow.Utils.MaintenanceAPI).BuildBlackList(%domId,%ids,%vSrcId)
#define IKBUILDBLACKLISTBIT(%domId,%ids) $$$IKBUILDBLACKLIST(%domId,%ids,0) ##continue
		set e="",po=0,b=""  for { set e=$o(^||%IK.BlackLists(e),1,d) q:e=""  $$$IKBITOFFPOS(e,o,p)  set:(p'=po) ^||%IK.BlackListsBit(po)=$bitlogic(b),b="" set $bit(b,p)=1,po=o } set ^||%IK.BlackListsBit(po) = $bitlogic(b)
#define IKISBLACKLISTED(%entUniId) (^||%IK.BlackLists&&$d(^||%IK.BlackLists(%entUniId)))
#define IKBLACKLISTBITS(%offset) ^||%IK.BlackListsBit(%offset)
#define IKCLEANBLACKLIST kill ^||%IK.BlackLists, ^||%IK.BlackListsBit

#define IKNORMALIZE(%str) $zconvert($zstrip(%str,"<>=W"),"L")

#define IKDEVBUILDGLOBAL ^||%ISC.iKnowDevBuild
#define IKISDEVBUILD ($G($$$IKDEVBUILDGLOBAL) = 1)
#define IKDEVBUILDON Set $$$IKDEVBUILDGLOBAL = 1
#define IKDEVBUILDOFF Kill $$$IKDEVBUILDGLOBAL

/// Macro's for query performance tracking
#define IKQTIC(%cat) set:$g(%TICTOC)'="" @("TIC"_%cat) = $zh
#define IKQTOC(%cat) set:$g(%TICTOC)'="" @%TICTOC@(%cat) = $g(@%TICTOC@(%cat))+($zh-@("TIC"_%cat))

/// Macro's for query cost calculations
#define IKCADD(%name,%cost)	if ($d(^||%IK.Cost(%name),d)) { set ^||%IK.Cost(%name) = d+(%cost) } else { set ^||%IK.Cost(%name) = %cost }
#define IKCFILTERFREQ(%filter) 10
#define IKCFILTERSPREAD(%filter) 10
#define IKCFILTER(%filter) 1
#define IKCRAND(%glob) +$g(^ISC.IK.Sys.Costs(%glob),1)
#define IKCSEQ(%glob) +$g(^ISC.IK.Sys.Costs(%glob),0.1)
#define IKCLOWEST(%name)	set n="",lc=-1 ##continue
	for { ##continue
		set n = $o(^||%IK.Cost(n),1,c) q:n="" ##continue
		if (c<lc) || (lc<0) { set lc=c, %name=n } ##continue
	}
	
/// OLD Macro's for query cost calculations *DEPRECATED*
#define IKQADDCOST(%name,%reads,%bsReads)	if ($d(^||%IK.Cost(%name),d)) { set ^||%IK.Cost(%name) = $lb($li(d,1)+%reads, $li(d,2)+%bsReads) } else { set ^||%IK.Cost(%name) = $lb(%reads, %bsReads) }
#define IKQADDRECALCCOST(%name,%count,%filter,%filtermode)	if ($$$CHECKFILTERFREQ(%filter,%filtermode)) { $$$IKQADDCOST(%name,%count*10,0) }  // needs refining ##continue
			if ($$$CHECKFILTERSPREAD(%filter,%filtermode)) { $$$IKQADDCOST(%name,%count*10,0) } // needs refining
#define IKQLOWESTCOST(%name)	set n="",lc=-1 ##continue
	for { ##continue
		set n = $o(^||%IK.Cost(n),1,d) q:n="" ##continue
		set c = $li(d,1) + $li(d,2)*2 ##continue
		if (c<lc) || (lc<0) { set lc=c, %name=n } ##continue
	}
	

#define IKQDURATION(%t,%d) set t = %t, %d = (t#60)\1_"s" ##continue
		if (t>=60) { set t = t\60, %d = (t#60)_"m "_%d ##continue
		if (t>=60) { set t = t\60, %d = (t#24)_"h "_%d ##continue
		if (t>=24) { set %d = (t\24)_"d "_%d } } }


/// Macro's for version checking
#define IKCURRENTVERSION	5
#define IKVERSION(%domainId)		$s(%domainId:$lg($g(^ISC.IK.Sys.DomainD(%domainId)),3,1),1:$$$IKCURRENTVERSION)
#define IKVERSIONATLEAST(%domainId,%version)	($$$IKVERSION(%domainId)>=%version)
#define IKVERSIONBEFORE(%domainId,%version)		($$$IKVERSION(%domainId)<%version)
#define IKVERSIONATMOST(%domainId,%version)		($$$IKVERSION(%domainId)<=%version)
#define IKCHECKVERSIONATLEAST(%domainId,%version)			quit:$$$IKVERSIONBEFORE(%domainId,%version) $$$ERROR($$$IKFeatureRequiresVersion, %version)
#define IKCHECKVERSIONATLEASTX(%domainId,%version,%sc)		if $$$IKVERSIONBEFORE(%domainId,%version) { set %sc = $$$ERROR($$$IKFeatureRequiresVersion, %version)  quit }
#define IKCHECKVERSIONATLEASTR(%domainId,%version,%sc,%ret)	if $$$IKVERSIONBEFORE(%domainId,%version) { set %sc = $$$ERROR($$$IKFeatureRequiresVersion, %version)  quit %ret }

#define IKVERSION20122 2
#define IKVERSIONATTRIBUTES 3
#define IKVERSIONMETRICS 3
#define IKVERSIONMATCHING20131 3
#define IKVERSIONXDOMAIN 4
#define IKVERSIONCASEINSENSITIVENAMES 4
#define IKVERSIONOPTIONALGLOBALS 4
#define IKVERSIONSTEMMING 5
#define IKVERSIONTABLES 5
#define IKVERSIONDOMINANCE2 5


/// Macro's for locking
#define IKLOCKG(%glo)			lock +%glo:5   if '$test { quit $$$ERROR($$$IKFailedToAcquireLock) } else { set iLocked("%glo") = 1 }
#define IKLOCKGX(%glo,%sc)		lock +%glo:5   if '$test { set %sc = $$$ERROR($$$IKFailedToAcquireLock)  quit } else { set iLocked("%glo") = 1 }
#define IKLOCKGR(%glo,%sc,%ret)	lock +%glo:5   if '$test { set %sc = $$$ERROR($$$IKFailedToAcquireLock)  quit %ret } else { set iLocked("%glo") = 1 }
#define IKLOCK(%domId,%glo)				lock +%glo(%domId):5   if '$test { quit $$$ERROR($$$IKFailedLockDomain,%domId) } else { set iLocked("%glo") = 1 }
#define IKLOCKX(%domId,%glo,%sc)		lock +%glo(%domId):5   if '$test { set %sc = $$$ERROR($$$IKFailedLockDomain,%domId)  quit } else { set iLocked("%glo") = 1 }
#define IKLOCKR(%domId,%glo,%sc,%ret)	lock +%glo(%domId):5   if '$test { set %sc = $$$ERROR($$$IKFailedLockDomain,%domId)  quit %ret } else { set iLocked("%glo") = 1 }
#define IKLOCKLOAD(%domId)				$$$IKLOCK(%domId,^ISC.IKM.LOAD)
#define IKLOCKLOADX(%domId,%sc)			$$$IKLOCKX(%domId,^ISC.IKM.LOAD,%sc)
#define IKLOCKLOADR(%domId,%sc,%ret)	$$$IKLOCKR(%domId,^ISC.IKM.LOAD,%sc,%ret)
#define IKLOCKUPGR(%domId)				$$$IKLOCK(%domId,^ISC.IKM.Upgrade)
#define IKLOCKUPGRX(%domId,%sc)			$$$IKLOCKX(%domId,^ISC.IKM.Upgrade,%sc)
#define IKLOCKUPGRR(%domId,%sc,%ret)	$$$IKLOCKR(%domId,^ISC.IKM.Upgrade,%sc,%ret)
#define IKLOCKED(%glo)	($g(iLocked("%glo"),0)=1)

#define IKUNLOCKG(%glo)			if $$$IKLOCKED(%glo) { lock -%glo  kill iLocked("%glo") }
#define IKUNLOCK(%domId,%glo)	if $$$IKLOCKED(%glo) { lock -%glo(%domId)  kill iLocked("%glo") }
#define IKUNLOCKLOAD(%domId)	$$$IKUNLOCK(%domId,^ISC.IKM.LOAD)
#define IKUNLOCKUPGR(%domId)	$$$IKUNLOCK(%domId,^ISC.IKM.Upgrade)


/// BDB348: Domain manager features
#define IKCHECKMGR(%o,%n,%str)	if (%str'="") { set a=0 ##continue
		set $ECODE="" for b=$stack:-1:1 { s a = ($p($p($p($stack(b,"PLACE"),"^",2)," ",1),".",1,*-1)=%str)  q:a } ##continue
		if 'a { quit $$$ERROR($$$IKObjectIsManaged,%o,%n,%str) } ##continue
	}
#define IKCHECKMGRX(%o,%n,%str,%sc)	if (%str'="") { set a=0 ##continue
		set $ECODE="" for b=$stack:-1:1 { s a = ($p($p($p($stack(b,"PLACE"),"^",2)," ",1),".",1,*-1)=%str)  q:a } ##continue
		if 'a { set %sc = $$$ERROR($$$IKObjectIsManaged,%o,%n,%str) quit } ##continue
	}
#define IKCHECKMGRR(%o,%n,%str,%sc,%ret)	if (%str'="") { set a=0 ##continue
		set $ECODE="" for b=$stack:-1:1 { s a = ($p($p($p($stack(b,"PLACE"),"^",2)," ",1),".",1,*-1)=%str)  q:a } ##continue
		if 'a { set %sc = $$$ERROR($$$IKObjectIsManaged,%o,%n,%str) quit %ret } ##continue
	}
#define IKCHECKDOMMGR(%domId)	set a=$g(^ISC.IK.Sys.Params(%domId,$$$IKPMANAGEDBY)) ##continue
	if (a'="") { set b=0 ##continue
		set $ECODE="" for c=$stack:-1:1 { s b = (a=$p($p($p($stack(c,"PLACE"),"^",2)," ",1),".",1,*-1))>0  q:b } ##continue
		if 'b { quit $$$ERROR($$$IKDomainIsManaged,%domId,a) } ##continue
	} 
#define IKCHECKDOMMGRX(%domId,%sc)	set a=$g(^ISC.IK.Sys.Params(%domId,$$$IKPMANAGEDBY)) ##continue
	if (a'="") { set b=0 ##continue
		set $ECODE="" for c=$stack:-1:1 { s b = (a=$p($p($p($stack(c,"PLACE"),"^",2)," ",1),".",1,*-1))  q:b } ##continue
		if 'b { set %sc = $$$ERROR($$$IKDomainIsManaged,%domId,a) quit } ##continue
	}
#define IKCHECKDOMMGRR(%domId,%sc,%ret)	set a=$g(^ISC.IK.Sys.Params(%domId,$$$IKPMANAGEDBY)) ##continue
	if (a'="") { set b=0 ##continue
		set $ECODE="" for c=$stack:-1:1 { s b = (a=$p($p($p($stack(c,"PLACE"),"^",2)," ",1),".",1,*-1))  q:b } ##continue
		if 'b { set %sc = $$$ERROR($$$IKDomainIsManaged,%domId,a) quit %ret } ##continue
	}
	

/// BDB287: Metrics macro's
#define IKMTRTARGETID(%target) $case(%target,$$$IKMTRENTITY:0,$$$IKMTRCRC:1,$$$IKMTRCC:2,$$$IKMTRPATH:3,$$$IKMTRSENTENCE:4,$$$IKMTRSOURCE:5)
#define IKMTRTARGETSTR(%target) $case(%target,0:$$$IKMTRENTITY,1:$$$IKMTRCRC,2:$$$IKMTRCC,3:$$$IKMTRPATH,4:$$$IKMTRSENTENCE,5:$$$IKMTRSOURCE)


/// BDB322: Macro's regarding attributes and their types
#define IKATTTYPENAME(%type)	$case(%type,$$$IKATTNEGATION:"negation",$$$IKATTTIME:"time",$$$IKATTMODIFIER:"modifier",$$$IKATTNONSEMANTIC:"nonsemantic",$$$IKATTSENPOSITIVE:"sentpositive",$$$IKATTSENNEGATIVE:"sentnegative",$$$IKATTENTITYVECTOR:"entity_vector", $$$IKATTTOPIC:"topic",:"unknown")
#define IKATTTYPEPROPS(%type)	$case(%type,$$$IKATTNEGATION:"",$$$IKATTTIME:"",$$$IKATTMODIFIER:"",:"")
#define IKATTWORDPOS(%attpos,%str)	set %str="" if %attpos="" { set %str = "0" } else { set b=$factor($a(%attpos)),c=$bitcount(b)  for p=1:1:c { set %str=%str_$bit(b,p) q:'$bitfind(b,1,p+1) } }


/// BDB328: Macro's for using the Query Result Cache
#define IKQRCCHECK(%domId,%filter,%qName,%params,%page,%pageSize,%result) ##continue
		set f = $s($isobject(%filter):%filter, 1:##class(%iKnow.Filters.NoFilter).%New(%domId))  ##continue
		do f.CheckResultCache($classname(),%qName,%params,%page,%pageSize,.c,.%result)  ##continue
		quit:c
#define IKQRCCHECKSINGLE(%domId,%filter,%qName,%params,%result) ##continue
		set f = $s($isobject(%filter):%filter, 1:##class(%iKnow.Filters.NoFilter).%New(%domId))  ##continue
		do f.CheckResultCacheSingle($classname(),%qName,%params,.c,.%result)  ##continue
		quit:c
#define IKQRCSTORE(%domId,%filter,%qName,%params,%page,%pageSize,%result,%sc) ##continue
		set f = $s($isobject(%filter):%filter, 1:##class(%iKnow.Filters.NoFilter).%New(%domId)) ##continue
		set %sc = f.StoreResultCache($classname(),%qName,%params,%page,%pageSize,.%result)  quit:$$$ISERR(%sc)
#define IKQRCSTORESINGLE(%domId,%filter,%qName,%params,%result,%sc) ##continue
		set f = $s($isobject(%filter):%filter, 1:##class(%iKnow.Filters.NoFilter).%New(%domId)) ##continue
		set %sc = f.StoreResultCacheSingle($classname(),%qName,%params,.%result)  quit:$$$ISERR(%sc)

/// BDB354: query support for minimal data structures
#define IKBFLAGS(%dom,%f) set %f=$lg($g(^ISC.IK.Sys.DomainD(%dom)),4), %f=$s(%f="":$$$DEFBUILDFLAGS,1:%f) 
#define IKBUPTODATE(%dom) ($o(^ISC.IK.SrcId(%dom,""),-1)<=$g(^ISC.IK.Sys.Loc(%dom,"Src")))
#define IKQBCHECKX(%dom,%globs,%sc)	if $$$IKVERSIONATLEAST(%dom,$$$IKVERSIONOPTIONALGLOBALS) && (%globs'="") { $$$IKBFLAGS(%dom,f) ##continue
		set bp=$$$GETPARAM(%dom,$$$IKPQUERYBUILDPOLICY,$$$IKPDEFQUERYBUILDPOLICY), utd=$$$IKBUPTODATE(%dom) ##continue
		set gl=$s($lv(%globs):%globs, 1:$lfs(%globs)), p=0 ##continue
		while $listnext(gl,p,g) { set fg = $a(f,g) ##continue
			set:fg=-1 fg = $a($$$VERSIONBUILDFLAGS($$$IKVERSION(%dom)),g) ##continue
			if (fg=$$$IKBFALWAYS) {} ##continue
			elseif (fg=$$$IKBFNEVER) || (fg=-1) { set %sc = $$$ERROR($$$IKGlobalsNotBuilt,g) quit } ##continue
			elseif (bp=$$$IKQBPERROR) || 'utd { set %sc = $$$ERROR($$$IKGlobalsNotBuilt,g) quit } ##continue
		} quit:$$$ISERR(%sc) ##continue
	}
#define IKQBCHECKR(%dom,%globs,%sc,%ret)	if $$$IKVERSIONATLEAST(%dom,$$$IKVERSIONOPTIONALGLOBALS) && (%globs'="") { $$$IKBFLAGS(%dom,f) ##continue
		set bp=$$$GETPARAM(%dom,$$$IKPQUERYBUILDPOLICY,$$$IKPDEFQUERYBUILDPOLICY), utd=$$$IKBUPTODATE(%dom) ##continue
		set gl=$s($lv(%globs):%globs, 1:$lfs(%globs)), p=0 ##continue
		while $listnext(gl,p,g) { set fg = $a(f,g) ##continue
			set:fg=-1 fg = $a($$$VERSIONBUILDFLAGS($$$IKVERSION(%dom)),g) ##continue
			if (fg=$$$IKBFALWAYS) {} ##continue
			elseif (fg=$$$IKBFNEVER) || (fg=-1) { set %sc = $$$ERROR($$$IKGlobalsNotBuilt,g) quit } ##continue
			elseif (bp=$$$IKQBPERROR) || 'utd { set %sc = $$$ERROR($$$IKGlobalsNotBuilt,g) quit } ##continue
		} quit:$$$ISERR(%sc) %ret ##continue
	}
#define IKQBCHECKT(%dom,%globs)	if $$$IKVERSIONATLEAST(%dom,$$$IKVERSIONOPTIONALGLOBALS) && (%globs'="") { $$$IKBFLAGS(%dom,f) ##continue
		set bp=$$$GETPARAM(%dom,$$$IKPQUERYBUILDPOLICY,$$$IKPDEFQUERYBUILDPOLICY), utd=$$$IKBUPTODATE(%dom) ##continue
		set gl=$s($lv(%globs):%globs, 1:$lfs(%globs)), p=0, s=$$$OK ##continue
		while $listnext(gl,p,g) { set fg = $a(f,g) ##continue
			set:fg=-1 fg = $a($$$VERSIONBUILDFLAGS($$$IKVERSION(%dom)),g) ##continue
			if (fg=$$$IKBFALWAYS) {} ##continue
			elseif (fg=$$$IKBFNEVER) || (fg=-1) { set s = $$$ERROR($$$IKGlobalsNotBuilt,g) quit } ##continue
			elseif (bp=$$$IKQBPERROR) || 'utd { set s = $$$ERROR($$$IKGlobalsNotBuilt,g) quit } ##continue
		} throw:$$$ISERR(s) ##class(%Exception.StatusException).CreateFromStatus(s) ##continue
	}


/// BDB385, BDB386 - macro's for cross-domain dictionary / blacklist use
#define IKXDOMVERSIONX(%g,%v,%sc)	s %v = $g(%g)  s:%v="" %v=$$$IKCURRENTVERSION  s:%v<$$$IKVERSIONXDOMAIN %sc=$$$ERROR($$$IKFeatureRequiresVersion,$$$IKVERSIONXDOMAIN)  quit:$$$ISERR(%sc)
#define IKXDOMVERSION(%g,%v)	s sc=$$$OK $$$IKXDOMVERSIONX(%g,%v,sc) sc
#define IKXDOMVERSIONR(%g,%v,%sc,%ret)	$$$IKXDOMVERSIONX(%g,%v,%sc) %ret

#define IKXDOMDICTVERSIONX(%v,%sc)	$$$IKXDOMVERSIONX(^ISC.IK.Mat.DictId,%v,%sc)
#define IKXDOMDICTVERSION(%v)	$$$IKXDOMVERSION(^ISC.IK.Mat.DictId,%v)
#define IKXDOMDICTVERSIONR(%v,%sc,%ret)	$$$IKXDOMVERSIONR(^ISC.IK.Mat.DictId,%v,%sc,%ret)

/// This macro checks if a cross-domain dictionary of version %xVersion can be used in a domain
/// of version %domVersion. Currently there is no compatibility requirement as the first version
/// capable of using them, but for future backwards compatibility, we request %xVersion<=%domVersion
#define IKXDOMDICTCOMPATIBLEX(%xVersion,%domVersion,%sc) if (%xVersion>%domVersion) { set %sc = $$$ERROR($$$GeneralError, "The version of this cross-domain dictionary is not compatible with the domain version.") quit } 

#define IKXDOMDICTS(%dicts,%xd,%v,%sc)	$$$IKENSURELISTNUM(%dicts) ##continue
		set %xd = $s((%dicts=$$$ALLXDOMDICTIONARIES):1, 1:($lg(%dicts,1)<0)), ptr=0 ##continue
		if $lv(%dicts) { while $listnext(%dicts,ptr,d) { if ((d<0)'=%xd) { set %sc = $$$ERROR($$$GeneralError, "Cannot mix cross-domain and normal dictionaries") } } quit:$$$ISERR(%sc) } ##continue
		if (%xd) { $$$IKXDOMDICTVERSIONX(%v,%sc) }

#define IKXDOMBLVERSIONX(%v,%sc)	$$$IKXDOMVERSIONX(^ISC.IK.BlackListId,%v,%sc)
#define IKXDOMBLVERSION(%v)	$$$IKXDOMVERSION(^ISC.IK.BlackListId,%v)
#define IKXDOMBLVERSIONR(%v,%sc,%ret)	$$$IKXDOMVERSIONR(^ISC.IK.BlackListId,%v,%sc,%ret)


/// MAB930 - MAB937
#define IKDDTaskGLVN 		^CacheTemp.ISC.IK.DD.Task
#define IKOutputGLNM 		^||ISC.IK.OutputGlobalName
/// #define IKOutputGLVN 		^||ISC.IK.OutputRedirect
#define IKOutputGLVN 		@^||ISC.IK.OutputGlobalName@

/// #define IKOutputGLVN 		^CacheTemp.ISC.IK.OutputRedirect
#define IKOutputState		$$$IKOutputGLVN($j)
#define IKOutputCursor		$$$IKOutputGLVN($j,0)
#define IKOutputCounter 	$$$IKOutputGLVN($j,$$$IKOutputCursor)
#define IKOutputLine 		$$$IKOutputGLVN($j,$$$IKOutputCursor,$$$IKOutputCounter)
/// MAB933
#define IKTempSetGLVN		^||ISC.IK.TmpSubsets

#define IKEXWRAP(%cmd) Set sc = $$$OK Try { Do %cmd } Catch e { Set sc = e.AsStatus() } Quit sc


#define TraceLevel					$g(^ISC.IK.Trace)
#define Trace(%l,%key,%msg)			if ($$$TraceLevel >= %l) { set ^ISC.IK.Trace(%l,$j,%key) = %msg }

#define IKModelCheck(%sc, %src, %line, %content)	If ('%sc) Throw ##class(%iKnow.ModelException).Create(%sc, %src, %line, %content)

/// Internal-only domain parameter to indicate Source IDs are provided from an external
/// source, such as DeepSee fact IDs or record IDs in a %iKnow.Index (BDB461)
#define IKPUSEEXTSRCIDS "UseExternalSourceIds"



/// STEMMING RULES

/// Plugin IDs
#define IKSTEMPLUGINALL 0
#define IKSTEMPLUGINHUNSPELL 1

/// Rule types
#define IKSTEMEXCEPTION 0
#define IKSTEMENDING 1
#define IKSTEMAFFIX 2

/// Rules 
#define IKSTEMNOCONCEPT 0
#define IKSTEMNORELATION 1


/// DECOMPOUND PROPERTY TYPES
#define IKDCConnector	0
#define IKDCNoSplit 	1
#define IKDCNoSplitEnd	2
#define IKDCPrefix		3
#define IKDCSuffix		4
#define IKDCNotFirstChar 5
#define IKDCHyphen		6


/// %iKnow.Utils.Tables 
#define IKTablesDataLocation(%pfx,%domid,%loc,%cl) $s(%pfx="":"^ISC.IK."_%loc_"("_%domid_$s(%cl:")", 1:","), $e(%pfx,*)=")":$e(%pfx,1,*-1)_","_$$$QUOTE(%loc)_$s(%cl:")", 1:","), 1:%pfx_%loc_$s(%cl:"", 1:"("))

/// BDB572 - journalling behavior
#define IKDisableJournal(%domId) set tDisableJournal = $$$GETPARAM(%domId,$$$IKPDISABLEJOURNALLING,$$$IKPDEFDISABLEJOURNALLING) ##continue
		if tDisableJournal { ##continue
			set tRestoreJournal = $$CURRENT^%SYS.NOJRN ##continue
			do:tRestoreJournal DisableJournal^%SYS.NOJRN ##continue
		}
#define IKRestoreJournal do:$g(tRestoreJournal) EnableJournal^%SYS.NOJRN


/// BDB630/BDB556 - decompounding
#define IKSDCNEVERSEPARATE $c(0)