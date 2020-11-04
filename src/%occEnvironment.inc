ROUTINE %occEnvironment [Type=INC]
#include %sySecurity
	#;      DLP497 02/28/2000 - Implement UNIQUEINDEXTYPE environment setting.
#;
#; Environment variables
#;
#define cENVbinarystreamclassname       "binarystreamclassname"
#define cENVcallererrorinfo             "callererrorinfo"
#define cENVcharacterstreamclassname    "characterstreamclassname"
#define cENVcollation                   "collation"
#define cENVdefaultdatatypeclassname    "defaultdatatypeclassname"
#define cENVdefaultohandleclassname     "defaultohandleclassname"
#define cENVdefaultpropertyclassname    "defaultpropertyclassname"
#define cENVdefaultstorageclassname     "defaultstorageclassname"
#define cENVdefaultserialstateclassname "defaultserialstateclassname"
#define cENVdefaultstreampropertyclassname    "defaultstreampropertyclassname"
#define cENVdefaultflags                "defaultflags"
#define cENVdefaultqualifiers           "defaultqualifiers"
#define cENVdefaultlocale               "defaultlocale"
#define cENVroutinesize                 "routinesize"
#define cENVstoragestrategy             "storagestrategy"
#define cENVstoragestrategylist         "storagestrategylist"
#define cENVtimechanged                 "timechanged"
#define cENVuniqueindextype             "uniqueindextype"
#define cENVuseoldjavagenerator         "useoldjavagenerator"
#define cENVusejavagenerator1           "usejavagenerator1"
#define cENVusejavagenerator2           "usejavagenerator2"
#define cENVusejavagenerator3           "usejavagenerator3"
#define cENVusesort                     "usesort"
	
#; DEFAULT values for Environment settings:
#;
#define envBinaryStreamClassNameGet             "%Library.GlobalBinaryStream"
#define envCharacterStreamClassNameGet          "%Library.GlobalCharacterStream"
#define envDefaultDataTypeClassNameGet          $g(^%oddENV($$$cENVdefaultdatatypeclassname,$namespace),$g(^%oddENV($$$cENVdefaultdatatypeclassname),"%Library.String"))
#define envDefaultFlagsGet                      $g(^%oddENV($$$cENVdefaultflags,$namespace),$g(^%oddENV($$$cENVdefaultflags)))
#define envDefaultQualifiersGet                 $g(^%oddENV($$$cENVdefaultqualifiers,$namespace),$g(^%oddENV($$$cENVdefaultqualifiers)))
#define envDefaultLocaleGet                     $g(^%oddENV($$$cENVdefaultlocale,$namespace),$g(^%oddENV($$$cENVdefaultlocale)))
#define envDefaultOHandleClassNameGet           $g(^%oddENV($$$cENVdefaultohandleclassname,$namespace),$g(^%oddENV($$$cENVdefaultohandleclassname),"%Library.ObjectHandle"))
#define envDefaultPropertyClassNameGet          "%Library.CacheLiteral"
#define envDefaultSerialStateClassNameGet       $g(^%oddENV($$$cENVdefaultserialstateclassname,$namespace),$g(^%oddENV($$$cENVdefaultserialstateclassname),"%Library.CacheSerialState"))
#define envDefaultStreamPropertyClassNameGet    "%Library.CacheStream"
#define envDefaultStorageClassNameGet           $g(^%oddENV($$$cENVdefaultstorageclassname,$namespace),$g(^%oddENV($$$cENVdefaultstorageclassname),"%Library.CacheStorage"))
#define envRoutineSizeGet                       $g(^%oddENV($$$cENVroutinesize,$namespace),$g(^%oddENV($$$cENVroutinesize),24000))
#define envUniqueIndexTypeGet                   $g(^%oddENV($$$cENVuniqueindextype,$namespace),$g(^%oddENV($$$cENVuniqueindextype),"index"))
#define envUseOldJavaGeneratorGet               $g(^%oddENV($$$cENVuseoldjavagenerator,$namespace),$g(^%oddENV($$$cENVuseoldjavagenerator),0))
#define envUseJavaGenerator1Get                 $g(^%oddENV($$$cENVusejavagenerator1,$namespace),$g(^%oddENV($$$cENVusejavagenerator1),0))
#define envUseJavaGenerator2Get                 $g(^%oddENV($$$cENVusejavagenerator2,$namespace),$g(^%oddENV($$$cENVusejavagenerator2),0))
#define envUseJavaGenerator3Get                 $g(^%oddENV($$$cENVusejavagenerator3,$namespace),$g(^%oddENV($$$cENVusejavagenerator3),0))
#define envUseSortGet                           $g(^%oddENV($$$cENVusesort,$namespace),$g(^%oddENV($$$cENVusesort),1))
#define envTimeChangedGet                       $g(^%oddENV($$$cENVtimechanged,$namespace),$g(^%oddENV($$$cENVtimechanged)))
#define envCallerErrorInfoGet                   $g(^%oddENV($$$cENVcallererrorinfo,$namespace),$g(^%oddENV($$$cENVcallererrorinfo)))
 
#define envSourceDir                            $get(^%SYS("SourceRoot",$namespace),$get(^%SYS("SourceRoot"),"u:/"))
#;
 