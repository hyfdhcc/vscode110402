ROUTINE %sqlMigration [Type=INC]
 
#IF 0    
 ;--------------------------------------------------------------------
 ; File:          %sqlMigration.INC
 ; Description:   SQL/ODBC/SqlGateWay Definitions for the %SQL.Migration package
 ; Author         Pierre-Yves Duquesnoy
 ; Date Started:  
 ; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
 ;
 ;  DPV3127 (03/18/2008) - Support for different default schemas in different namespaces
 ;  PYD108  (08/24/2006) - Fix ProdLog 52190
 ;  PYD107  (09/20/2005) - Fix Prodlog 45896
 ;  PYD106  (09/05/2005) - fix various ProdLogs
 ;  PYD103  (04/01/2005) - fix Foreign Key import from MS-Access 
 ;  PYD105  (02/17/2005) - transform value returned by %SYS.CONFIG  //$$$GetDelimitedIds
 ;  DPV2321 (11/10/2004) - Use new %SYS.CONFIG API for SQL Configuration settings
 ;  PYD102  (05/10/04) - fix and enhance for Oracle
 ;  PYD101  (04/30/04) - remove %msql for new security 
 ;  PYD100  (04/30/04) - Fix <NULL VALUE> with Unicode Cache on Unix 
 ;  PYD099  (03/19/04) - Allow Schema change & fix various Prodlogs
 ;  PYD098  (02/03/04) - Fix copy of Stream data into %String
 ;  PYD095  (06/21/03) - allow import routine split if too big
 ;  PYD093  (04/22/03) - INFORMIX NOT NULL
 ;  PYD092  (01/30/03) - various fixes
 ;  PYD085  (09/26/02) - use ^CacheTempSQL($j) 
 ;  PYD083  (08/31/02) - detect and import AutoIncrement columns
 ;  PYD082  (08/22/02) - various bug fixes
 ;  PYD080  (06/26/02) - support for MS-ACCESS 
 ;  PYD065  (04/26/02) - workaround ProdLog 27597 that prevents returning $ZF into Object property
 ;  PYD063  (04/16/02) - corrected bugs and added SQLWLONGVARCHAR support
 ;  PYD051  (04/16/02) - Initial Implementation
 ;                        
 ;
 ;--------------------------------------------------------------------
 ;                       I N F O R M A T I O N
 ;--------------------------------------------------------------------
#ENDIF 
 
#define SQLConnect(%cgate,%dsn,%usr,%pwd)		$zf(-5,%cgate,1,%dsn,%usr,%pwd)
#define SQLDisconnect(%cgate,%hdbc)				$zf(-5,%cgate,6,%hdbc)
#define SQLAllocStatement(%cgate,%hdbc)			$zf(-5,%cgate,5,%hdbc)
#define SQLFreeStmt(%cgate,%hstmt)				$zf(-5,%cgate,17,%hstmt)			
#define DropStmt(%cgate,%hstmt)					$zf(-5,%cgate,16,%hstmt)
 
#define SQLGetInfo(%cgate,%hdbc,%fInfoType)    $zf(-5,%cgate,28,%hdbc,%fInfoType)
 
#define SQLTables(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName,%Type) 	$zf(-5,%cgate,15,%hstmt,%TbQualifier,%TbOwner,%TbName,%Type)
#define SQLTablesW(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName,%Type) 	$zf(-5,%cgate,34,%hstmt,%TbQualifier,%TbOwner,%TbName,%Type)
 
#define DescribeCols(%cgate,%hstmt) 			$zf(-5,%cgate,10,%hstmt)
#define SQLFetch(%cgate,%hstmt)					$zf(-5,%cgate,7,%hstmt)
#define GetOneRow(%cgate,%hstmt)				$zf(-5,%cgate,26,%hstmt,"")
 
#define TestSQLError(%cgate)					$zf(-5,%cgate,13)
 //return first error in list only
#define SQLError(%cgate,%hdbc,%hstmt)			$zf(-5,%cgate,12,%hdbc,%hstmt)
#define SQLDataSources(%cgate,%fposition)		$zf(-5,%cgate,39,%fposition) 
#define SQLGetTypeInfo(%cgate,%hstmt,%fType)	$zf(-5,%cgate,40,%hstmt,%fType)
 
 
#define SQLColumns(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName)	$zf(-5,%cgate,14,%hstmt,%TbQualifier,%TbOwner,%TbName,"")
#define SQLColumnsW(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName)	$zf(-5,%cgate,35,%hstmt,%TbQualifier,%TbOwner,%TbName,"")
 
#define SQLPrimaryKeys(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName) $zf(-5,%cgate,30,%hstmt,%TbQualifier,%TbOwner,%TbName,"")
#define SQLPrimaryKeysW(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName) $zf(-5,%cgate,36,%hstmt,%TbQualifier,%TbOwner,%TbName,"")
 
#define SQLForeignKeys(%cgate,%hstmt,%PkQualifier,%PkOwner,%PkName,%FkQualifier,%FkOwner,%FkName) $zf(-5,%cgate,43,%hstmt,%PkQualifier,%PkOwner,%PkName,%FkQualifier,%FkOwner,%FkName) 
#define SQLForeignKeysW(%cgate,%hstmt,%PkQualifier,%PkOwner,%PkName,%FkQualifier,%FkOwner,%FkName) $zf(-5,%cgate,44,%hstmt,%PkQualifier,%PkOwner,%PkName,%FkQualifier,%FkOwner,%FkName) 
 
#define SQLStatistics(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName,%fUnique) $zf(-5,%cgate,41,%hstmt,%TbQualifier,%TbOwner,%TbName,%fUnique,"")
#define SQLStatisticsW(%cgate,%hstmt,%TbQualifier,%TbOwner,%TbName,%fUnique) $zf(-5,%cgate,42,%hstmt,%TbQualifier,%TbOwner,%TbName,%fUnique,"")
 
#define SQLSpecialColumns(%cgate,%hstmt,%ColType,%TbQualifier,%TbOwner,%TbName,%Scope,%fNullable)  $zf(-5,%cgate,29,%hstmt,%ColType,%TbQualifier,%TbOwner,%TbName,%Scope,%fNullable,"")
#define SQLSpecialColumnsW(%cgate,%hstmt,%ColType,%TbQualifier,%TbOwner,%TbName,%Scope,%fNullable)  $zf(-5,%cgate,49,%hstmt,%ColType,%TbQualifier,%TbOwner,%TbName,%Scope,%fNullable,"")
 
#define SQLPrepare(%cgate,%hstmt,%sql)			$zf(-5,%cgate,3,%hstmt,%sql)
#define SQLPrepareW(%cgate,%hstmt,%sql)			$zf(-5,%cgate,37,%hstmt,%sql)
#define SQLExecute(%cgate,%hstmt)				$zf(-5,%cgate,4,%hstmt)
 
  //PYD108+
#define SQLColAttributeStr(%cgate,%hstmt,%icol,%fDescType) $zf(-5,%cgate,59,%hstmt,%icol,%fDescType)
#define SQLColAttributeStrW(%cgate,%hstmt,%icol,%fDescType) $zf(-5,%cgate,72,%hstmt,%icol,%fDescType)
#define SQLColAttributeNum(%cgate,%hstmt,%icol,%fDescType) $zf(-5,%cgate,60,%hstmt,%icol,%fDescType)
#define SQLNumResultsCols(%cgate,%hstmt) 				 $zf(-5,%cgate,61,%hstmt)
#define GTWSetLogOption(%cgate,%option)  $zf(-5,%cgate,51,%option)  
        //Definitions of values for SQLColAttribute
#define SQLDESCNAME        1011
#define SQLDESCCONCISETYPE 2
        //Maximum desirable Line Length in generated routine
#define MAXLINELENGTH     2048	
  //PYD108-
  
#define SQLIDENTIFIERQUOTECHAR		29
 
#define DelimitedIdValue $s($$$DelIds=1:"""",1:"") 
 
 //Definitions for MetaList Returned By DescribeCols
#define DCColName(%clist)		$li(%clist,1)
#define DCSqlType(%clist)		$li(%clist,2)
#define DCPrecision(%clist)		$li(%clist,3)
#define DCScale(%clist)			$li(%clist,4)
#define DCNullable(%clist)		$li(%clist,5)
#define DCDatatype(%clist)		$li(%clist,6)
#define DCDisplaySize(%clist)	$li(%clist,7)
#define DCIsMoney(%clist)		$li(%clist,8)
 //----
#define SQLGetData(%cgate,%hstmt,%col,%dtype)	$zf(-5,%cgate,25,%hstmt,%col,%dtype) 
#define SQLGetDataW(%cgate,%hstmt,%col,%dtype)  $zf(-5,%cgate,50,%hstmt,%col,%dtype)
 //---- PYD082+
#define GTWUnicode(%cgate) $zf(-5,%cgate,52)
#define CacheUnicode $zbitget($zversion(0),1)
#define GTWSetUnicode(%cgate)  $zf(-5,%cgate,33,$zbitget($zversion(0),1))
 //---  PYD082-
 
 
 
 
 //ODBC & SQL_GateWay Null and Empty Strings 
#define NULL ""
#define EMPTYSTR $c(0)
 
#define SQLSUCCESS 0
#define SQLNODATA  100
 
#define FullTbName(%TbOwner,%TbName,%Did)  $S(%TbOwner="":%Did_%TbName_%Did,%TbOwner=$c(0):%Did_%TbName_%Did,%TbOwner="[null schema]":%Did_%TbName_%Did,1:%Did_%TbOwner_%Did_"."_%Did_%TbName_%Did)
	//#define DefaultSchema	$S($$$GetDefaultSchema="_CURRENT_USER":$$$DefaultSchemaQ,1:$$$GetDefaultSchema)
#define TbNameCache(%TbOwner,%TbName)      $S(%TbOwner="":$$$DefaultSchema_"."_%TbName,%TbOwner=$c(0):$$$DefaultSchema_"."_%TbName,%TbOwner="[null schema]":$$$DefaultSchema_"."_%TbName,1:%TbOwner_"."_%TbName)
  //PYD103 
  //PYD107+: #define NORMSCHEMA(%Schema) $S(%Schema="[null schema]":$$$NULL,1:$ZCVT(%Schema,"U"))
 #define NORMSCHEMA(%Schema) $S(%Schema="[null schema]":$$$NULL,1:%Schema)
  //PYD107-
 /* List of Options to Add for more functionality:
 1- Schema Copy: - Keep original Datatype Name. -> Allows user to redefine some specific user datatypes in
 Cache with all the functionality...Good for translating UDTs of SQL_Server
 
 2- Improve CopyTableSchema to Get Only the Columns of SQLColumns (GetOneRow) that are needed...faster
 
  */
 
#define SQLCCHAR	1  
#define SQLCWCHAR  -8
#define SQLCBINARY -2
 
  //ODBC DataType Definitions 1.0 and 2.0
#define SQLALLTYPES 0
#define SQLCHAR 1
#define SQLBIGINT -5
#define SQLBINARY -2
#define SQLBIT -7
#define SQLDATE 9
#define SQLDECIMAL 3
#define SQLDOUBLE 8
#define SQLFLOAT 6
#define SQLGUID -11
#define SQLINTEGER 4
#define SQLLONGVARCHAR -1
#define SQLLONGVARBINARY -4
#define SQLNUMERIC 2
#define SQLREAL 7
#define SQLSMALLINT 5
#define SQLTINYINT -6
#define SQLTIME 10
#define SQLTIMESTAMP 11
#define SQLVARBINARY -3
#define SQLVARCHAR 12
#define SQLWLONGVARCHAR -10
#define SQLWVARCHAR -9
#define SQLWCHAR -8
 	//ODBC Types Found on IBM DB2 Samples. PYD083
#define SQLBLOB -98
#define SQLCLOB -99
	//ODBC 3.0 Datatypes. PYD106
#define SQLTYPEDATE  91
#define SQLTYPETIME  92
#define SQLTYPETIMESTAMP 93
	// JDBC SQL SERVER Datatypes
#define JDBCTYPENTEXT -16
	// JDBC Datatypes, seen on Oracle and DB2
#define JDBCTYPEBINARYDOUBLE 101
#define JDBCTYPEBLOB 2004
#define JDBCTYPECLOB 2005
	
	//ODBC Constants for SQLDataSources %fposition parameter
#define SQLFETCHFIRST 2
#define SQLFETCHNEXT 1
 
	//ODBC Constants for SQLColumns
#define SQLNONULLS  0
#define SQLNULLABLE 1
	
	//Constants for SQLStatistics
#define SQLINDEXUNIQUE 0
#define SQLINDEXALL	1
#define SQLTABLESTAT 0
 
 
	//Parse a %Status Message, Get First Errno and First Error Message
  //#define ERRNO(%stat)	$s(%stat=1:0,1:$lg($li($e(%stat,3,$l(%stat)),1),1,""))	
  //#define ERRMSG(%stat)	$s(%stat=1:"",1:$li($li($e(%stat,3,$l(%stat)),1),2,""))
#define ERRNO(%stat) $p($SYSTEM.Status.GetErrorCodes(%stat),",",1)
#define ERRMSG(%stat) $SYSTEM.Status.GetErrorText(%stat)
 
#DEFINE ERRTABLENOTFOUND ($g(SQLCODE)=-30) 
	//Stream Types in CopyData
#define CHARACTERSTREAM 1
#define BINARYSTREAM 2	
	
	//Foreign Keys Update/Delete Rules
#define SQLCASCADE 0
#define SQLRESTRICT 1
#define SQLSETNULL 2
#define SQLNOACTION 3
#define SQLSETDEFAULT 4
#define RuleToString(%x) $s(%x=0:"CASCADE",%x=1:"",%x=2:"SET NULL",%x=3:"NO ACTION",%x=4:"SET DEFAULT",1:"")	
 
	//definitions for SqlSpecialColumns
#define SQLBESTROWID	1
#define SQLSCOPECURROW	0
	//#define SQLNONULLS	0
	//#define SQLNULLABLE 	1
 
	
 
	;-----------------------------------------------------------------------
	//Database types
#define MSACCESS	(..DBMSName="ACCESS")	
	//Sybase Adaptive Server 12.5: DBMSName="SQL SERVER",DBMS_VER="12.50.0000", SqlDriverName(6)="SYODASE.DLL"
#define SYBASE		($ZCVT(..DBMSName,"U")="SQL SERVER")
	//Microsoft Sql Server 2000: DBMSName="Microsoft SQL Server",DBMS_VER="08.00.0194", SqlDriverName="SQLSRV32.DLL"
#define SQLSERVER 	(..DBMSName="Microsoft SQL Server")	
	//Cache 5.0: DBMSName="InterSystems Cache",DBMS_VER="Cache Objects Version 5.0.1375.0 Cache JDBC/ODBC ...", SqlDriverName="CacheODBC.DLL"	
#define CACHE		(..DBMSName="InterSystems Cache")
	//IBM DB2: DBMSName="DB2/NT", DBMS_VER="07.02.0000", SqlDriverrName="DB2CLI.DLL"
#define DB2			($e(..DBMSName,1,3)="DB2")
	//MySQL 4.0:  DBMSName="mysqld-4.0.2-alpha-nt", DBMS_Ver="4.0.2-alpha-nt", DriverName="myodbc3.dll"
#define MYSQL		($e(..DBMSName,1,5)="mysql")
 	//Informix
#define INFORMIX	((($ZCVT(..DBMSName,"U")["INFORMIX"))||($ZCVT(..DBMSVersion,"U")["INFORMIX"))
 	//PYD102: Oracle
#define ORACLE 		($ZCVT(..DBMSName,"U")["ORACLE")
	//PYD102: Oracle ODBC Driver does not support Wide interface on CLOB/SQL_LONGVARCHAR
#define DRIVERORACLE  (($$$ORACLE)&&($ZCVT(..DriverName,"U")["SQORA"))
	//DPV3061: EXCEL - DBMSName="EXCEL", DBMS_Ver="08.00.0000", DriverName="odbcjt32.dll"
#define EXCEL	(..DBMSName="EXCEL")	
 