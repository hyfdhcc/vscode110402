ROUTINE %HadoopGateway [Type=INC]
#; %HadoopGateway.INC
#; Include file for %HadoopGateway
 
#include %DeepSee
#include %occErrors
#define HGTempGlobal ^["%SYS"]CacheTemp.ISC.HadoopGateway
#define HGConfigGlobal ^["%SYS"]SYS
#define HGConfigSubscrs "gateway","hadoop"
#define HGKillCheckpoint k %ISCHGsavedConsumerClass,%ISCHGsavedSyncedClass,%ISCHGsavedCheckpoint
#define HGSanityCheckString "Do not pass this string from user code, or results are unpredictable"
#define HGValidOptions ",delimiter,lineseparator,pause,hadoophome,jarpath,host,port,rootpath,format,importtableexists,showremotegatewayerror,showjavaexceptionname,showjavastacktrace,"
#define HGInvalidConnectionOptions ",showremotegatewayerror,showjavaexceptionname,showjavastacktrace,"
#define HGValidClassOptions ",delimiter,lineseparator,pause,pathname,format,"
#define HGValidClassAndGlobalOptions ",delimiter,lineseparator,pause,format,"
#define HGValidNamespaceOptions ",pathname,"
#define HGValidImportTableExistsValues ",error,drop,reuse,"
#define HGDefaultDelimiter ","
 // HGDefaultLineSeparator (LF)
#define HGDefaultLineSeparator $c(10)
#define HGDefaultPause 1
#define HGDefaultFormat "delimitedtext"
#define HGDefaultHadoopHome "/hadoophome"
#define HGDefaultJarPath "hadoopgateway/hadoopgateway.jar"
#define HGDefaultHost "localhost"
#define HGDefaultPort "56789"
#define HGDefaultRootPath ""
#define HGDefaultDataFileSuffix ".data"
#define HGDefaultImportTableExists "error"
#define HGMaxMsgLength 32767
#define HGDefaultExceptionName "Hadoop Gateway Exception"
#define HGDefaultExceptionCode 9000
#define HGDefaultExceptionMsg "Internal error"
#define HGDefaultShowRemoteGatewayError ""
#define HGDefaultShowJavaExceptionName ""
#define HGDefaultShowJavaStacktrace ""
#define HGSQLDatatypes ",varbinary,bit,money,smallmoney,date,double,float,real,int,integer,smallint,tinyint,dec,decimal,number,numeric,char,character,national,varchar,nvarchar,nchar,varchar2,time,timestamp,image,long,longtext,longvarbinary,longvarchar,ntext,text,serial,smalldatetime,sysname,"
#define HGSupportedDatatypes ",%BigInt,%Binary,%Boolean,%Counter,%Currency,%Date,%DateTime,%Decimal,%Double,%Float,%Integer,%List,%Name,%Numeric,%SmallInt,%Status,%Stream.GlobalBinary,%Stream.GlobalCharacter,%String,%Text,%Time,%TimeStamp,%TinyInt,"
#define HGMAXVALDatatypes ",%BigInt,%Boolean,%Counter,%Currency,%Date,%DateTime,%Decimal,%Double,%Float,%Integer,%Numeric,%SmallInt,%Time,%TimeStamp,%TinyInt,"
#define HGMAXLENDatatypes ",%Binary,%Name,%String,%Text,"
#define HGSCALEDatatypes ",%Decimal,%Double,%Float,%Numeric,"
#define HGNumericDatatypes ",%BigInt,%Boolean,%Counter,%Currency,%Decimal,%Double,%Float,%Integer,%Numeric,%SmallInt,%TinyInt,"

 // For measuring performance of MapReduceResult %Import, enable the non-empty definitions
 // of the following macros:
#define HGstartMeasuringImportPerformance s %ISCHGimportStart=$p($ztimestamp,",",2),%ISCHGimportedBytes=0,%ISCHGimportedRows=0
#define HGstopMeasuringImportPerformance s %ISCHGimportEnd=$p($ztimestamp,",",2),%ISCHGimportElapsedTime=%ISCHGimportEnd-%ISCHGimportStart,%ISCHGimportedBytesThroughput=%ISCHGimportedBytes/%ISCHGimportElapsedTime,%ISCHGimportedRowsThroughput=%ISCHGimportedRows/%ISCHGimportElapsedTime
#define HGtallyImportedBytes(%num) s %ISCHGimportedBytes=%ISCHGimportedBytes+%num
#define HGtallyImportedRows(%num) s %ISCHGimportedRows=%ISCHGimportedRows+%num
#define HGinitializeImportPerformanceCounters s %ISCHGimportedBytes=0,%ISCHGimportedRows=0