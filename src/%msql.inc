ROUTINE %msql [Type=INC]
	; %msql.inc - General-purpose macros for Cache' SQL environment
#IF 0   ;-------------------------------------------------------------
	; Description:   General Purpose MACROS for Cache' SQL
	; Author:        
	; Date Started:  
	; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
	;
	;  DPV3320 (12/10/2008) - Support ECPSync config setting
	;  DPV3236 (08/11/2008) - Implement support for getVersionColumns and update what isRowVersion means
	;  DPV3231 (08/05/2008) - Use process private global for ptln, ptrel
	;  DPV3173 (06/09/2008) - Reduce use of %Library.Float, some functions return DOUBLE or NUMERIC
	;  DPV3127 (03/18/2008) - Support for different default schemas in different namespaces
	;  DPV3121 (03/05/2008) - Implement LinkedTableMap to define fake master map for Linked tables
	;  DPV3096 (01/23/2008) - Fix pathifn for view fields
	;  DPV3095 (01/22/2008) - Support for column-level privileges
	;  DPV3089 (01/07/2008) - Support TCP KEEP ALIVE configuration setting
	;  DPV3076 (11/30/2007) - Changes to ^||%sql.smd lifetime, fixes for views updated WHERE CURRENT OF
	;  PVA147  (08/27/2007) - A query with an unnecessary DISTINCT and a subquery might return duplicates
	;  DPV2999 (08/17/2007) - PRIVATE TEMP TABLES do not acquire locks for filing or read-committed checks
	;  DPV2994 (08/06/2008) - Revert stream oref change.  Implement %OBJECT()
	;  DPV2912 (04/24/2007) - Add bitslice scale and collection type to map subscripts
	;  DPV2873 (03/08/2007) - Change logic for GlobalInReadOnlyDB - remove GlobalInReadOnlyDB macro
	;                         SQL Fix ProdLog 56681:  Test for Read only DB is incorrect
	;  DPV2863 (02/23/2007) - Define MaxLocalLength
	;                         SQL Fix ProdLog 55803: %SQL.Migration.Import.cls limited to 32000 characters
	;  DPV2800 (11/27/2006) - Turn on new TSQL Compiler by default
	;  JLF127  (10/30/2006) - Add anyofAlg macro
	;  DPV2755 (10/11/2006) - Fix definition of GlobalInReadOnlyDB macro
	;  DPV2744 (09/25/2006) - Allow missing IDENTITY column in INSERT/UPDATE
	;  DPV2725 (09/05/2006) - TSQL: Implement %TSQL.sys.objects table
	;  DPV2672 (08/30/2006) - Add macro to get field name from irn/icol - used in statement level triggers	
	;  JO2062  (08/04/2006) - Remove IdentifyAsSystemProcess() macro
	;  JLF115  (07/17/2006) - Add smdImp macro
	;  DPV2697 (07/12/2006) - Use $e(...,*) and $e(...,...,*) in SQL code
	;  DPV2694 (07/10/2006) - Allow SQL Empty String input value to be configurable per namespace
	;  DPV2692 (07/07/2006) - Change names of private globals used by SQL.  Removed some unused macros
	;  DPV2673 (06/07/2006) - Implement Fast DISTINCT switch
	;  DPV2654 (05/18/2006) - SQL Fix: Have H_Variable length use ODBCVarcharMaxlen config setting
	;  DPV2644 (05/10/2006) - Fix init of temp files with new temp global name (comments only)
	;  DPV2616 (04/10/2006) - Support Fieldname(ELEMENTS)/Fieldname(KEYS) in map data
	;  DPV2607 (03/07/2006) - Handle fup and xac lists that are greater than 32K in length
	;  DPV2593 (02/21/2006) - SQL Enhancement: Use private global for SQL instead of ^mtemp0
 	;  DPV2587 (02/16/2006) - SQL Enhancement: Move ^CacheTempSMD($J) to ^||smd()
 	;  DPV2580 (01/25/2006) - Add DelIds and DefSchema which reference ^%SYS("sql","sys") for faster processing
	;  DPV2579 (01/25/2006) - Use $zu(115,11) as flag for allowing PUBLIC RowID value insertion
	;  DPV2554 (11/16/2005) - Rebuild view column list in RebuildView if we generated it ourselves in AddView
	;                         SQL Fix ProdLog 47188: Problems with a View after compiling a class it references
	;  DPV2546 (11/08/2005) - Implement new MVR collation function.  Change collation implementations to use $zu(28)
	;  DPV2542 (10/25/2005) - Don't try to Set/Kill ^oddEXTR/"cq" index if database is readonly
	;                         SQL Fix ProdLog 46812:  <PROTECT> error in %SYS.SQLSRV
	;  DPV2541 (10/24/2005) - Add isAutoIncrement, isCaseSensitive, isCurrency, IsReadOnly, IsRowVersion, IsUnique, IsAliased, IsExpression, IsHidden, IsIdentity, IsKeyColumn do xDBC metadata
	;  DPV2498 (10/05/2005) - Suspend writing to the journal file when creating/deleting cached query definitions
	;  DPV2524 (09/22/2005) - Moved Cached Query metadata back to ^mcq
	;  DPV2523 (09/20/2005) - Change BlockPadding to BlockCount
	;                         SQL Implement ProdLog 43624: Query Optimizer needs a better way to get Map size
	;  DPV2501 (08/25/2005) - Add BlockPadding value to map definition
	;  DPV2488 (08/17/2005) - Keep NextRtn node and other namespace specific cached query settings in ^mcq
	;                         SQL Fix ProdLog 45368: another <NOROUTINE> cached query related issue
	;  DPV2483 (08/04/2005) - Moved the cached queries from ^CQ[I] to ^ISCCQ[I]
	;  DPV2474 (07/28/2005) - Reset cached query privileges when a role is removed from a user or role.
        ;                         SQL Fix ProdLog 44183: Use of cached query does not check table privilege
	;  DPV2455 (07/05/2005) - Bind Index on Collection information to run-time extent
	;  DPV2454 (07/19/2005) - Move ^mcq global to ^|"%SYS"|CQ[I] subscripted by namespace
	;  DPV2446 (06/17/2005) - Get list of kids from $$$smd, not the extent
	;  DPV2445 (06/15/2005) - Calculate $$lockref at SQL binding time instead of each time it is needed by a query
	;  DPV2443 (06/08/2005) - Add more macros for map definition rowid/parid pieces
	;  DPV2408 (04/11/2005) - Don't let non-defined user increment error count if checking if superuser
	;                         SQL Fix ProdLog 42477: Compilation errors occur when compile upgraded view
	;  DPV2384 (03/15/2005) - Carlos Lopes, Fix ProdLog 41831: <PROPERTY DOES NOT EXIST>SetReferencialChecks+2^%SYS.CONFIG
	;  DPV2351 (01/28/2005) - Support BitSlice indices in SQL Filer
	;  DPV2348 (01/21/2005) - SQL Fix:  Report SQLStatistics for master map with single field PKey/IDKey
	;  STC748  (01/18/2005) - Macroize Security global 
	;  DPV2324 (11/24/2004) - Eliminate %msqlgrp for SQL Role list, use $Roles now
	;  DPV2323 (11/24/2004) - Move %qarPrivileges and %qadUsers into %SYS.SQLSEC
	;  DPV2322 (11/23/2004) - Add BIGINT to GetOdbcTypeNumber and GetJdbcTypeNumber
	;  STC666  (10/10/2004) - Move some security defines to %sySecurity.inc
	;  DPV2279 (09/09/2004) - Add Scale MapSubscript for BitSlice indices
	;  DPV2274 (08/27/2004) - Bind class's System Flag setting to SQL
	;  DPV2264 (08/11/2004) - Move SQL System privileges to per-namespace, eliminate system-wide privieges
	;  DPV2259 (08/09/2004) - Subscript SQL privileges by Namespace, not database
	;  DPV2256 (08/04/2004) - Move SQL privileges to $$$SecurityGlobal,"SQL","priv",<database>,...)
	;  DPV2253 (07/23/2004) - Add READONLY flag to smd structure
	;  DPV2233 (06/16/2004) - Bind OIDType to SQL
	;  DPV2227 (06/08/2004) - Remove IsASuperUser function - use system function, just not during ^build
	;  DPV2198 (03/17/2004) - Use $Username instead of %msql, use new privilege global
	;  DPV2124 (11/14/2003) - Add support for ReadOnly fields
	;  DPV2060 (08/21/2003) - Eliminate ^mdd - Add new 'smd' macros
	;  DPV2053 (07/25/2003) - Fix privileges checking with privileges granted indirectly through roles
	;  DPV2014 (06/13/2003) - Use new "select privs" structure in mtc() for privilege checking
	;  DPV1990 (05/22/2003) - Eliminate ^mdd from table compiler
	;  DPV1987 (05/09/2003) - New SQLTabConnect macro uses new metadata
	;  DPV1972 (04/14/2003) - New macros for new metadata
	;  DPV1965 (03/18/2003) - Build new SQL metadata
	;  DPV1964 (03/14/2003) - Add SQLTableUsesCacheStorage
	;  DPV1963 (03/14/2003) - Eliminate RoutinePrefix binding to ^mdd, Connection and ExternalTableName
	;  DPV1929 (02/11/2003) - Add new macro ExtentName
	;  DPV1832 (09/20/2002) - Add new Map macros
	;  DPV1809 (08/27/2002) - Add RowIDBitMapFriendly
	;  DPV1742 (06/10/2002) - Support DB Object Definition system privileges
	;  DPV1693 (03/28/2002) - Add ViewUpdatable, ViewCheckOption
	;  DPV1687 (03/18/2002) - Fix FieldName definition to use irn instead of ifn twice.
	;  DPV1680 (03/06/2002) - Add FieldExternalName
	;  DPV1674 (03/04/2002) - Add FieldContainerField
	;  DPV1668 (02/11/2002) - Defined ParentTableName
	;  DPV1655 (01/24/2002) - Define DefaultSchemaCG for use in code generation
	;  DPV1637 (01/15/2002) - New macros GetOdbcTypeNumber and GetJdbcTypeNumber
	;  DPV1643 (01/14/2002) - A bunch of new map macros
	;  DPV1620 (12/06/2001) - new macro ViewClassName
	;  DPV1619 (11/19/2001) - Change RoutineSize macro definition to $g(%rsize,31000)
	;  DPV1575 (08/20/2001) - Use $zu(115,4) for Lock Timeout
	;  DPV1567 (07/12/2001) - Modify some collation expression to handle '   ' data better
	;  DPV1560 (06/26/2001) - Add StripLeadingWhiteSpace, StripTrailingWhiteSpace
	;  DPV1559 (06/21/2001) - Add Support for Default Schema == Current User Name
	;  DPV1557 (06/19/2001) - Add support for sysNEWLOCK
	;  DPV1531 (06/05/2001) - Add ReadOnly macro for tables
	;  DPV1522 (04/12/2001) - Removed unused macro definitions and #include %site
	;  DPV1505 (03/08/2001) - Remove unused Rtn* macros
	;  DPV1480 (01/10/2001) - Add AllButLastChar
	;  DPV1456 (11/27/2000) - Add SupportDelimitedIdentifiers
	;  DPV1441 (11/14/2000) - Add RequiredField
	;  DPV1446 (11/08/2000) - Add AllButLastPiece
	;  DPV1432 (10/25/2000) - Add GetOdbcTypeName
	;  DPV1414 (10/11/2000) - Add LastPiece and IsOneOf macro definitions
	;  DPV1381 (10/02/2000) - Add GetHiddenFieldListUpper, GetNonHiddenFieldList GetHiddenFieldList GetExternalTableName macros
	;  DPV1392 (09/07/2000) - Define DefaultSchema macro
	;  DPV1382 (08/24/2000) - Add GetExternalTableName for external tables
	;  DPV1345 (07/20/2000) - Add GetTableRoutinePrefix macro
	;  DPV1329 (06/26/2000) - Add list of fields, non-hidden fields for Aviel
	;  DPV1319 (06/07/2000) - Schema changes for privileges
	;  DPV1310 (05/30/2000) - Schema support
	;  DPV1296 (04/25/2000) - Define StripQuotes
	;  DPV1278 (03/14/2000) - Define GetRowIDName(%irn)
	;  DPV1267 (02/28/2000) - Define GetFieldIcol
	;  DPV1260 (02/09/2000) - Some new meta-data macros, clean up all unused macros
	;  DPV1184 (11/03/1999) - Implement CACHESQL macro for %qserver common code
	;  DPV1151 (10/01/1999) - Support SQLSTRING and SQLUPPER Collations
	;  AK392   (09/02/1999) - Query Optimizer alg() counter
	;  DPV1109 (07/20/1999) - Support delimited identifiers
	;  DPV1095 (06/28/1999) - Add truncate parameter to STRING function
	;  AK363   (05/13/1999) - Improve ODBC run-time variables
	;  DPV1006 (04/07/1999) - String collation support
	;  DPV1007 (03/17/1999) - Preserve '_' in identifier names
	;  DPV903  (11/05/1998) - Move ^%qCacheSQLSys("sys") to ^%qCacheSQL("sys")
	;  AK335   (10/02/1998) - Empty string and NULL
	;  DPV889  (10/19/1998) - New object privileges
	;  DPV849  (09/14/1998) - Use new system functions for ALPHAUP/UPPER
	;  AK329   (09/04/1998) - Named scratch run-time variables
	;  AK327   (07/28/98)   - Replace LOCK +^mtemp with $INCREMENT(^mtemp0)
	;  DPV832  (03/21/98)   - Increase Max Routine line length to 4K
	;  DPV822  (02/27/98)   - make expansion of nsqline macro occur on 1 line
	;  DPV802  (01/19/98)   - Removed all DSM, MSM, DTM stuff
	;  AK304   (01/06/98)   - List Fields in the Query Processor
	;  DPV793  (12/03/97)   - Added macro IdentifyAsSystemProcess for
	;                         Relational Server Master
	;  DPV791  (12/01/97)   - Add more routine global macro definitions
	;  DPV777  (09/15/97)   - Add macro defined to release license slot used
	;                         by the process.
	;  DPV756  (07/21/97)   - New EDMaxRtnLineLength macro
	;  DPV752  (06/27/97)   - New MaxStringLength macro
	;  DPV748  (06/16/97)   - New routine global name (rMAC, ...)
	;  MRP691  (05/13/97)   - Optimize Server Code...
	;  DPV725  (04/02/97)   - Define %nextgen macro
	;  DPV710  (02/11/97)   - Increase allowed maximum line length from
	;                         255 to 511.
	;  MRP671  (02/11/97)   - System Wide Lock Timeout for SQL...
	;  DPV700  (01/13/97)   - Created $$$NullSubscriptMarker
	;  MRP643  (10/02/96)   - Modularize Embedded SQL Code: 'gvar' to
	;                         '$$$MSQLModuleVariable'...
	;  AFH218  (08/13/96)   - ROUTINE global changes
	;  DPV650  (07/29/96)   - Make charactersetg use $g() of ^%SYS("sql","user"
	;  MRP600  (04/17/96)   - Added a [lower] definition...
	;  MRP597  (03/03/96)   - Consolidate the SQL Reserved Word List...
	;                         New Macr: SQLReservedWordForParsing(%word)
	;  DPV603  (03/05/96)   - New macro MaxRtnLineLength
	;  DPV600  (02/29/96)   - Make %rsize a system setting definable by
	;                         system managers.  Cleaned up this file
	;  AFH177  (09/21/95)   - Make sql text as comment optional
	;  DPV528  (08/21/95)   - Set up DTMixinterpDEF properly.
	;  RLL599  (05/09/95)   - Add IOP to $$$pushradev
	;  AFH145  (04/05/95)   - Change piece of %msql for DTMixinterpOLD
	;  TJ005   (03/01/94)   - Fix special case for security check to update
	;                         Users Table.  ---  OFF -BMS 3/2/95 xxx
	;  RLL548  (01/05/94)   - Add $$$formfielderrormessage and
	;                         $$$formfieldhelpmessage
	;  SSG018  (05/23/94)   - Avoid code generation >255 characters
	;  MRP384  (03/30/94)   - Error Trapping Fuctions...
	;  MRP376  (02/08/94)   - Use Character Set for NLI Objects...
	;  MRP362  (01/12/94)   - Add #define NLImsg(%context) for NLI messages
	;                         used in Menu Objects (Also in #library %mtrans)
	;  RLL356  (10/20/93)   - fix $$$nsqline to handle MSM/DSM syntax
	;  RLL353  (10/13/93)   - support big intergration for DTM-PC
	;  PRT002  (09/21/93)   - enhance privilege checking for roles
	;  VGG050  (07/06/93)   - add $$$ieimport,$$$fldref
	;  MRP311  (06/04/93)   - Use new Macro Keywords ##beginlit, ##endlit
	;                         to handle literals with unbalanced quotes,
	;                         right parens, etc... inside
	;  MRP310  (05/28/93)   - Add some Schema Support for extended global
	;                         referencing...
	;  DPV047               - fix $na for DataTree
	;  RGG232+              - Fix this include file according to Scott
	;  ALL001+              - fix $g()
	;  RLL040               - move #define %vendor to top of file
	;  MRP151+              - Define Vendor... ALL004+ nice text and fix
	;                          other macros vendor can be 1 of the following:
	;                          Datatree,DSM,InterSystems,MSM
	;
	;-------------------------------------------------------------
	;     I N F O R M A T I O N
	;-------------------------------------------------------------
	;
	;  Start your information here...
	;
#ENDIF  ;-------------------------------------------------------------
 
#include %sySecurity

        // Note:
        // If the macros MaxStringLengh is updated, update %occSqlfunc.inc too
#define MaxStringLength 3641144
#define MaxLocalLength $zutil(96,39)
#DEFINE MaxCacheInt 9223372036854775807
#DEFINE MinCacheInt -9223372036854775808
#define IDName(%s) $zcvt(%s,"U")
#define IDNameRetain(%s,%r) $zcvt(%s,"U")
#define LOWER(%a) $zcvt(%a,"L")
#define MASK(%a) $$MASK(%a)
 
	; Collation functions
        ; #define ALPHAUP(%a) $zcvt($zstrip(%a,"*P",,",?"),"U")
        ; #define SQLSTRING(%s) (" "_$s(%s="":"",$zstrip(%s,">W")'="":$zstrip(%s,">W"),1:$c(0)))
        ; #define SQLSTRINGT(%s,%l) $e(" "_$s(%s="":"",$zstrip(%s,">W")'="":$zstrip(%s,">W"),1:$c(0)),1,%l)
        ; #define SQLUPPER(%s) (" "_$s(%s="":"",$zstrip(%s,">W")'="":$zcvt($zstrip(%s,">W"),"U"),1:$c(0)))
        ; #define SQLUPPERT(%s,%l) $e(" "_$s(%s="":"",$zstrip(%s,">W")'="":$zcvt($zstrip(%s,">W"),"U"),1:$c(0)),1,%l)
        ; #define STRING(%s) (" "_$s(%s="":"",$zstrip(%s,"*P",,",")'="":$zcvt($zstrip(%s,"*P",,","),"U"),1:$c(0)))
        ; #define STRINGT(%s,%l) $e(" "_$s(%s="":"",$e($zstrip(%s,"*P",,","),1,%l-1)'="":$zcvt($zstrip(%s,"*P",,","),"U"),1:$c(0)),1,%l)
        ; #define UPPER(%a) $zcvt(%a,"U")
        ; #define ALPHAUPCodeGen(%a) "$zcvt($zstrip("_%a_",""*P"",,"",?""),""U"")"
        ; #define ALPHAUPCodeGenNameP1(%a) "$p($zcvt($zstrip("_%a_",""*P"",,"",?""),""U""),"","")"
        ; #define ALPHAUPCodeGenNameP2(%a) "$p($zcvt($zstrip("_%a_",""*P"",,"",?""),""U""),"","",2)"
        ; #define SQLSTRINGCodeGen(%s) "("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zstrip("_%s_","">W""),1:$c(0)))"
        ; #define SQLSTRINGCodeGenNameP1(%s) "$p("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zstrip("_%s_","">W""),1:$c(0)),"","")"
        ; #define SQLSTRINGCodeGenNameP2(%s) "$p("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zstrip("_%s_","">W""),1:$c(0)),"","",2)"
        ; #define SQLSTRINGTCodeGen(%s,%l) "$e("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zstrip("_%s_","">W""),1:$c(0)),1,"_%l_")"
        ; #define SQLUPPERCodeGen(%s) "("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zcvt($zstrip("_%s_","">W""),""U""),1:$c(0)))"
        ; #define SQLUPPERCodeGenNameP1(%s) "$p("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zcvt($zstrip("_%s_","">W""),""U""),1:$c(0)),"","")"
        ; #define SQLUPPERCodeGenNameP2(%s) "$p("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zcvt($zstrip("_%s_","">W""),""U""),1:$c(0)),"","",2)"
        ; #define SQLUPPERTCodeGen(%s,%l) "$e("" ""_$s("_%s_"="""":"""",$zstrip("_%s_","">W"")'="""":$zcvt($zstrip("_%s_","">W""),""U""),1:$c(0)),1,"_%l_")"
        ; #define STRINGCodeGen(%s) "("" ""_$s("_%s_"="""":"""",$zstrip("_%s_",""*P"",,"","")'="""":$zcvt($zstrip("_%s_",""*P"",,"",""),""U""),1:$c(0)))"
        ; #define STRINGCodeGenNameP1(%s) "$p("" ""_$s("_%s_"="""":"""",$zstrip("_%s_",""*P"",,"","")'="""":$zcvt($zstrip("_%s_",""*P"",,"",""),""U""),1:$c(0)),"","")"
        ; #define STRINGCodeGenNameP2(%s) "$p("" ""_$s("_%s_"="""":"""",$zstrip("_%s_",""*P"",,"","")'="""":$zcvt($zstrip("_%s_",""*P"",,"",""),""U""),1:$c(0)),"","",2)"
        ; #define STRINGTCodeGen(%s,%l) "$e("" ""_$s("_%s_"="""":"""",$zstrip("_%s_",""*P"",,"","")'="""":$zcvt($zstrip("_%s_",""*P"",,"",""),""U""),1:$c(0)),1,"_%l_")"
        ; #define UPPERCodeGen(%a) "$zcvt("_%a_",""U"")"
        ; #define UPPERCodeGenNameP1(%a) "$p($zcvt("_%a_",""U""),"","")"
        ; #define UPPERCodeGenNameP2(%a) "$p($zcvt("_%a_",""U""),"","",2)"
        ; #define StripQuotes(%s) $$strrep($e(%s,2,$l(%s)-1),"""""","""")

        // Note:
        // If the macros ALPHAUP, MVR, SQLSTRINGT, SQLUPPERT, STRINGT, TRUNCATET, or UPPER is updated, update %occSqlfunc.inc too
#define ALPHAUP(%s) $zu(28,%s,6)
#define MVR(%s) $zu(28,%s,2)
#define SQLSTRING(%s) $zu(28,%s,8)
#define SQLSTRINGT(%s,%l) $zu(28,%s,8,%l)
#define SQLUPPER(%s) $zu(28,%s,7)
#define SQLUPPERT(%s,%l) $zu(28,%s,7,%l)
#define STRING(%s) $zu(28,%s,9)
#define STRINGT(%s,%l) $zu(28,%s,9,%l)
#define TRUNCATE(%s) %s
#define TRUNCATET(%s,%l) $e(%s,1,%l)
#define UPPER(%s) $zu(28,%s,5)
#define ALPHAUPCodeGen(%s) "$zu(28,"_%s_",6)"
#define ALPHAUPCodeGenNameP1(%s) "$p($zu(28,"_%s_",6),"","")"
#define ALPHAUPCodeGenNameP2(%s) "$p($zu(28,"_%s_",6),"","",2)"
#define MVRCodeGen(%s) "$zu(28,"_%s_",2)"
#define MVRCodeGenNameP1(%s) "$p($zu(28,"_%s_",2),"","")"
#define MVRCodeGenNameP2(%s) "$p($zu(28,"_%s_",2),"","",2)"
#define SQLSTRINGCodeGen(%s) "$zu(28,"_%s_",8)"
#define SQLSTRINGCodeGenNameP1(%s) "$p($zu(28,"_%s_",8),"","")"
#define SQLSTRINGCodeGenNameP2(%s) "$p($zu(28,"_%s_",8),"","",2)"
#define SQLSTRINGTCodeGen(%s,%l) "$zu(28,"_%s_",8,"_%l_")"
#define SQLUPPERCodeGen(%s) "$zu(28,"_%s_",7)"
#define SQLUPPERCodeGenNameP1(%s) "$p($zu(28,"_%s_",7),"","")"
#define SQLUPPERCodeGenNameP2(%s) "$p($zu(28,"_%s_",7),"","",2)"
#define SQLUPPERTCodeGen(%s,%l) "$zu(28,"_%s_",7,"_%l_")"
#define STRINGCodeGen(%s) "$zu(28,"_%s_",9)"
#define STRINGCodeGenNameP1(%s) "$p($zu(28,"_%s_",9),"","")"
#define STRINGCodeGenNameP2(%s) "$p($zu(28,"_%s_",9),"","",2)"
#define STRINGTCodeGen(%s,%l) "$zu(28,"_%s_",9,"_%l_")"
#define TRUNCATECodeGen(%s) %s
#define TRUNCATECodeGenNameP1(%s) "$p("_%s_"),"","")"
#define TRUNCATECodeGenNameP2(%s) "$p("_%s_"),"","",2)"
#define TRUNCATETCodeGen(%s,%l) "$e("_%s_",1,"_%l_")"
#define TRUNCATETCodeGenNameP1(%s,%l) "$e($p("_%s_"),"",""),1,"_%l_")"
#define TRUNCATETCodeGenNameP2(%s,%l) "$e($p("_%s_"),"","",2),1,"_%l_")"
#define UPPERCodeGen(%s) "$zu(28,"_%s_",5)"
#define UPPERCodeGenNameP1(%s) "$p($zu(28,"_%s_",5),"","")"
#define UPPERCodeGenNameP2(%s) "$p($zu(28,"_%s_",5),"","",2)"
 
#define quote(%val) $zutil(144,1,%val)
#define StripQuotes(%s) $replace($e(%s,2,*-1),"""""","""")
 
#DEFINE TransSuspended $ZU(139)
#DEFINE SuspendTrans Do $ZU(139,1)
#DEFINE ResumeTrans Do $ZU(139,0)
#DEFINE DisableJournal I '($V(0,-1,4)\1024#2) { V 0:-1:4:$V(0,-1,4)+1024 s jflag=1 }
#DEFINE EnableJournal I $g(jflag),$V(0,-1,4)\1024#2 { V 0:-1:4:$V(0,-1,4)-1024 }
 
	; SQL System Configuration settings (DPV2321)
#define GetAllowRowIDUpdate $$GetAllowRowIDUpdate^%SYS.CONFIG()
#define SetAllowRowIDUpdate(%val) $$SetAllowRowIDUpdate^%SYS.CONFIG(,%val)
#define GetComments $$GetComments^%SYS.CONFIG()
#define SetComments(%val) $$SetComments^%SYS.CONFIG(,%val)
	; DPV2580 #define GetDaysBeforePurge $$GetDaysBeforePurge^%SYS.CONFIG()
	; DPV2580 #define SetDaysBeforePurge(%val) $$SetDaysBeforePurge^%SYS.CONFIG(,%val)
#define GetDBMSSecurity $$GetDBMSSecurity^%SYS.CONFIG()
#define SetDBMSSecurity(%val) $$SetDBMSSecurity^%SYS.CONFIG(,%val)
#define GetddlNo30 $$GetddlNo30^%SYS.CONFIG()
#define SetddlNo30(%val) $$SetddlNo30^%SYS.CONFIG(,%val)
#define GetddlNo201 $$GetddlNo201^%SYS.CONFIG()
#define SetddlNo201(%val) $$SetddlNo201^%SYS.CONFIG(,%val)
#define GetddlNo307 $$GetddlNo307^%SYS.CONFIG()
#define SetddlNo307(%val) $$SetddlNo307^%SYS.CONFIG(,%val)
#define GetddlNo311 $$GetddlNo311^%SYS.CONFIG()
#define SetddlNo311(%val) $$SetddlNo311^%SYS.CONFIG(,%val)
#define GetddlNo315 $$GetddlNo315^%SYS.CONFIG()
#define SetddlNo315(%val) $$SetddlNo315^%SYS.CONFIG(,%val)
#define GetddlNo324 $$GetddlNo324^%SYS.CONFIG()
#define SetddlNo324(%val) $$SetddlNo324^%SYS.CONFIG(,%val)
#define GetddlNo333 $$GetddlNo333^%SYS.CONFIG()
#define SetddlNo333(%val) $$SetddlNo333^%SYS.CONFIG(,%val)
#define GetDDLSQLOnlyCompile $$GetDDLSQLOnlyCompile^%SYS.CONFIG()
#define SetDDLSQLOnlyCompile(%val) $$SetDDLSQLOnlyCompile^%SYS.CONFIG(,%val)
#define GetDDLDefineBitmapExtent $$GetDDLDefineBitmapExtent^%SYS.CONFIG()
#define SetDDLDefineBitmapExtent(%val) $$SetDDLDefineBitmapExtent^%SYS.CONFIG(,%val)
#define GetDDLFinal $$GetDDLFinal^%SYS.CONFIG()
#define SetDDLFinal(%val) $$SetDDLFinal^%SYS.CONFIG(,%val)
#define GetDDLUseSequence $$GetDDLUseSequence^%SYS.CONFIG()
#define SetDDLUseSequence(%val) $$SetDDLUseSequence^%SYS.CONFIG(,%val)
#define GetDefaultSchema $$GetDefaultSchema^%SYS.CONFIG()
#define SetDefaultSchema(%val) $$SetDefaultSchema^%SYS.CONFIG(,%val)
#define GetDelimitedIds $$GetDelimitedIds^%SYS.CONFIG()
#define SetDelimitedIds(%val) $$SetDelimitedIds^%SYS.CONFIG(,%val)
#define GetDropDelete $$GetDropDelete^%SYS.CONFIG()
#define SetDropDelete(%val) $$SetDropDelete^%SYS.CONFIG(,%val)
#define GetExtrinsicFunctions $$GetExtrinsicFunctions^%SYS.CONFIG()
#define SetExtrinsicFunctions(%val) $$SetExtrinsicFunctions^%SYS.CONFIG(,%val)
#define GetIdKey $$GetIdKey^%SYS.CONFIG()
#define SetIdKey(%val) $$SetIdKey^%SYS.CONFIG(,%val)
#define GetIdTrxFrom $$GetIdTrxFrom^%SYS.CONFIG()
#define SetIdTrxFrom(%val) $$SetIdTrxFrom^%SYS.CONFIG(,%val)
#define GetIdTrxTo $$GetIdTrxTo^%SYS.CONFIG()
#define SetIdTrxTo(%val) $$SetIdTrxTo^%SYS.CONFIG(,%val)
#define GetLockThreshold $$GetLockThreshold^%SYS.CONFIG()
#define SetLockThreshold(%val) $$SetLockThreshold^%SYS.CONFIG(,%val)
#define GetLockTimeout $$GetLockTimeout^%SYS.CONFIG()
#define SetLockTimeout(%val) $$SetLockTimeout^%SYS.CONFIG(,%val)
#define GetODBCVarcharMaxlen $$GetODBCVarcharMaxlen^%SYS.CONFIG()
#define SetODBCVarcharMaxlen(%val) $$SetODBCVarcharMaxlen^%SYS.CONFIG(,%val)
#define GetPrefix $$GetPrefix^%SYS.CONFIG()
#define SetPrefix(%val) $$SetPrefix^%SYS.CONFIG(,%val)
#define GetReferentialChecks $$GetReferentialChecks^%SYS.CONFIG()
#define SetReferentialChecks(%val) $$SetReferentialChecks^%SYS.CONFIG(,%val)
#define GetSaveMAC $$GetSaveMAC^%SYS.CONFIG()
#define SetSaveMAC(%val) $$SetSaveMAC^%SYS.CONFIG(,%val)
#define GetSysDatatypes(%val) $$GetSysDatatypes^%SYS.CONFIG(,%val)
#define GetUserDatatypes(%val) $$GetUserDatatypes^%SYS.CONFIG(,%val)
#define GetTimePrecision $$GetTimePrecision^%SYS.CONFIG()
#define SetTimePrecision(%val) $$SetTimePrecision^%SYS.CONFIG(,%val)
#define GetTODATEDefaultFormat $$GetTODATEDefaultFormat^%SYS.CONFIG()
#define SetTODATEDefaultFormat(%val) $$SetTODATEDefaultFormat^%SYS.CONFIG(,%val)
#define GetFastDistinct $$GetFastDistinct^%SYS.CONFIG()
#define SetFastDistinct(%val) $$SetFastDistinct^%SYS.CONFIG(,%val)
#define GetTCPKeepAlive $$GetTCPKeepAlive^%SYS.CONFIG()
#define SetTCPKeepAlive(%val) $$SetTCPKeepAlive^%SYS.CONFIG(,%val)
#define GetECPSync $$GetECPSync^%SYS.CONFIG()
#define SetECPSync(%val) $$SetECPSync^%SYS.CONFIG(,%val)
#define GetQueryProcedures $$GetQueryProcedures^%SYS.CONFIG()
#define SetQueryProcedures(%val) $$SetQueryProcedures^%SYS.CONFIG(,%val)
 
	; SQL Configuration settings that can be checked without going into the configuration
		; Default is Delimited Identifiers are ON
#define AllowExtrinsicFunctions $g(^%SYS("sql","sys","allow extfunc calls"),0)
#define AllowRowIDInsert $zu(115,11)
#define CollectionProjectionGet $g(^%SYS("sql","sys","collection projection"),0)
#define CollectionProjectionSet(%value) set ^%SYS("sql","sys","collection projection")=%value
#define CQSaveMAC $g(^%SYS("sql","server","Save .MAC"),0)
#define CQPrefix "%sqlcq"
#define DelIds +$g(^%SYS("sql","sys","delimited identifiers"),1)
	; If $zu(115,11) is TRUE, we allow the insert of a RowID value if the RowID field is not Private
#define DefineTSQLMetadata $zcvt($g(^%SYS("tsql","COMPILER")),"U")'="OLD"
#define DefSchema $g(^%SYS("sql","sys","default schema",$namespace),$g(^%SYS("sql","sys","default schema")))
#define DefSchemaNaked $g(^("default schema"))
#define ECPSync $g(^%SYS("sql","sys","ECP Sync"),0)
#define FastDistinct $g(^%SYS("sql","sys","fast distinct"),1)
#define JDBCGatewayPort $g(^%SYS("sql","sys","JDBC Gateway Port"),21000)
#define JDBCGatewayLog $g(^%SYS("sql","sys","JDBC Gateway Log"))
#define JavaHome $g(^%SYS("sql","sys","Java Home"))
#define JDBCGatewayJVMArgs $g(^%SYS("sql","sys","JDBC Gateway JVMArgs"))
#define JavaClassPath $g(^%SYS("sql","sys","Java Class Path"))
#define ODBCVarcharMaxlen $g(^%SYS("sql","sys","ODBCVarcharMaxlen"),4096)
#define QueryProcedures $g(^%SYS("sql","sys","query procedures"),0)
#define RetainSQLTextAsComments $g(^%SYS("sql","sys","retain-sql"),0)
#define SQLCheckBitmapFriendly $g(^%SYS("sql","sys","check bitmap friendly"),0)
#define SQLEmptyString $g(^%SYS("sql","sys","namespace",$namespace,"empty string"),$c(0))
	; First Day of Week:  7 = Sunday (default), 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, used for DATEPART(dw) and 
#define SQLFirstDayOfWeek $g(^%SYS("sql","sys","day of week",$namespace),$g(^%SYS("sql","sys","day of week"),7))
#define SQLSecurityOff '$zu(115,8)
#define SQLSecurityOn $zu(115,8)
#define SQLServerDisconnectCode       ^%SYS("sql","server","disconnect code",$namespace)
#define SQLServerInitCode       ^%SYS("sql","server","init code",$namespace)
#define TCPKeepAlive $g(^%SYS("sql","sys","TCP Keep-Alive Interval"),1)
#define TimePrecision $g(^%SYS("sql","sys","time precision"),0)
#define WeekISO8601 $g(^%SYS("sql","sys","week ISO8601"),$g(^%SYS("sql","sys","week ISO6801"),0))
#define SQLFunctionArgConversion ^%SYS("sql","sys","SQL Func Arg Conversion")
#define SQLFunctionArgConversionG $g(^%SYS("sql","sys","SQL Func Arg Conversion"),0)
 
	; DPV2580 - No longer call DefaultSchema^%apiSQL for most cases of getting the default schema.
	;           These macros should allow us to get the default schema faster
#define SchemaExpression $s($$$UPPER($p($$$DefSchema,"/"))'="_CURRENT_USER":$$$DefSchema,1:$s($$$aid'="":$$$aid,1:$s($p($$$DefSchema,"/",2)="":"SQLUser",1:$p($$$DefSchema,"/",2))))
#define DefaultSchema $$$SchemaExpression
#define DEFAULTSCHEMA $$$UPPER($$$SchemaExpression)
	; The Q macros return a quoted (if needed) version of the schema name.  It calls quoter2 because it only needs quoting
	; if it cannot be represented as a regular identifier.
#define DefaultSchemaQ $$quoter2^%apiSQL($$$SchemaExpression)
#define DEFAULTSCHEMAQ $$quoter2^%apiSQL($$$UPPER($$$SchemaExpression))
	; QL is the same as Q except that the quoter2 function has to be in the routine the macro is
	; referenced in.  This saves the overhead of the routine call.
#define DefaultSchemaQL $$quoter2($$$SchemaExpression)
#define DEFAULTSCHEMAQL $$quoter2($$$UPPER($$$SchemaExpression))
	; These two are only used by the DDL Parser
#define DefaultSchemaCGQ $$DefaultSchema^%apiSQL($$$DefSchema,0,1)
#define DEFAULTSCHEMACGQ $$$UPPER($$DefaultSchema^%apiSQL($$$DefSchema,0,1))
 
#define aid $Username
	
	; *** BE CAREFUL OF THE NAKED REFERENCES IN THE PRIV MACROS ***
#define nopriv(%obj,%act,%dir,%grant) '$$$IAmSuperUser,'$d($$$SecurityGlobalSQLPriv(%dir,+$g(%grant),%obj,%act,$$$aid)),'$d(^("_PUBLIC")),$$$SQLSecurityOn,$$rolechek^%SYS.SQLSEC(%dir,%obj,%act,+$g(%grant)),$$SchemaCheck^%SYS.SQLSEC(%dir,%obj,+$g(%grant),%act),$$OwnerCheck^%SYS.SQLSEC(%obj)
	; rolechek(dir,obj,act,grant)
	; ROLECHEKUSER(dir,grant,obj,act,user,roles)
#define noprivnoschema(%obj,%act,%dir,%grant) '$$$IAmSuperUser,'$d($$$SecurityGlobalSQLPriv(%dir,+$g(%grant),%obj,%act,$$$aid)),'$d(^("_PUBLIC")),$$$SQLSecurityOn,$$rolechek^%SYS.SQLSEC(%dir,%obj,%act,+$g(%grant)),$$OwnerCheck^%SYS.SQLSEC(%obj)
	; Same as nopriv, but we know the user is not a superuser
#define nopriv2(%obj,%act,%dir,%grant) '$d($$$SecurityGlobalSQLPriv(%dir,+$g(%grant),%obj,%act,$$$aid)),'$d(^("_PUBLIC")),$$$SQLSecurityOn,$$rolechek^%SYS.SQLSEC(%dir,%obj,%act,+$g(%grant)),$$SchemaCheck^%SYS.SQLSEC(%dir,%obj,+$g(%grant),%act),$$OwnerCheck^%SYS.SQLSEC(%obj)
#define nopriv2noschema(%obj,%act,%dir,%grant) '$d($$$SecurityGlobalSQLPriv(%dir,+$g(%grant),%obj,%act,$$$aid)),'$d(^("_PUBLIC")),$$$SQLSecurityOn,$$rolechek^%SYS.SQLSEC(%dir,%obj,%act,+$g(%grant)),$$OwnerCheck^%SYS.SQLSEC(%obj)
#define noprivuser(%user,%obj,%act,%dir,%grant,%roles,%sc) '$$$IsASuperUser(%user,.%sc),'$d($$$SecurityGlobalSQLPriv(%dir,%grant,%obj,%act,%user)),'$d(^("_PUBLIC")),$$$SQLSecurityOn,$$rolechekuser^%SYS.SQLSEC(%dir,%grant,%obj,%act,%user,%roles),$$SchemaCheckUser^%SYS.SQLSEC(%dir,%obj,%grant,%act,%user,%roles),$$OwnerCheckUser^%SYS.SQLSEC(%user,%roles,%obj)
	; Same as noprivuser, but we know the user is not a superuser
#define noprivuser2(%user,%obj,%act,%dir,%grant,%roles) '$d($$$SecurityGlobalSQLPriv(%dir,%grant,%obj,%act,%user)),'$d(^("_PUBLIC")),$$$SQLSecurityOn,$$rolechekuser^%SYS.SQLSEC(%dir,%grant,%obj,%act,%user,%roles),$$SchemaCheckUser^%SYS.SQLSEC(%dir,%obj,%grant,%act,%user,%roles),$$OwnerCheckUser^%SYS.SQLSEC(%user,%roles,%obj)
#define ReleaseUserLicenseSlot i $zu(112,2,1)
 ; BuildFlag/BuildSysFlag is also defined in build.mac
#define BuildFlag                 %000b000u000i000l000d
#define BuildSysFlag              ^b000u000i000l000d
 
 
	; SQL System privilege checking
#define DBObjectDefinitionPriv(%u,%a)	$$haspriv^%SYS.SQLSEC(%u,"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1",%a)
#define CreateFunctionPriv(%u,%a)	$$haspriv^%SYS.SQLSEC(%u,"1,,,,,,,,,,,,,,,,,,,",%a)
#define DropFunctionPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",1,,,,,,,,,,,,,,,,,,",%a)
#define CreateMethodPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,1,,,,,,,,,,,,,,,,,",%a)
#define DropMethodPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,1,,,,,,,,,,,,,,,,",%a)
#define CreateProcedurePriv(%u,%a)	$$haspriv^%SYS.SQLSEC(%u,",,,,1,,,,,,,,,,,,,,,",%a)
#define DropProcedurePriv(%u,%a)	$$haspriv^%SYS.SQLSEC(%u,",,,,,1,,,,,,,,,,,,,,",%a)
#define CreateQueryPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,1,,,,,,,,,,,,,",%a)
#define DropQueryPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,1,,,,,,,,,,,,",%a)
#define CreateTablePriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,1,,,,,,,,,,,",%a)
#define AlterTablePriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,1,,,,,,,,,,",%a)
#define DropTablePriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,1,,,,,,,,,",%a)
#define CreateViewPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,1,,,,,,,,",%a)
#define AlterViewPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,1,,,,,,,",%a)
#define DropViewPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,1,,,,,,",%a)
#define CreateTriggerPriv(%u,%a)	$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,,1,,,,,",%a)
#define DropTriggerPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,,,1,,,,",%a)
#define NoCheckPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,,,,1,,,",%a)
#define NoTriggerPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,,,,,1,,",%a)
#define NoIndexPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,,,,,,1,",%a)
#define NoLockPriv(%u,%a)		$$haspriv^%SYS.SQLSEC(%u,",,,,,,,,,,,,,,,,,,,1",%a)
 
	;  ***NOTE!!! If the length of the temp global name changes, you must check the code in
	;             %aaanull.  It uses a $f(code,"(")+$l(somevar)... to find where to get a temp file number from
	;             very kludgy and dependent on the length of the temp file name!!!
#define tFileRoot ^||%sql.temp
#def1arg tFile(%a) ^||%sql.temp(%a)
#define tFileQ "^||%sql.temp"
#define tFileQNoCarat "||%sql.temp"

#define MalgItself %malg
#def1arg Malg(%a) %malg(%a)
#define McostItself %mcost
#def1arg Mcost(%a) %mcost(%a)

#define fsave fsave
	
#define PtinitsItself ptinits
#def1arg Ptinits(%a) ptinits(%a)
	;  NEW vsqline,sqline, also kill if in global
#define nsqline n sqline,vsqline s vsqline="sqline"
#define popsqline   k @vsqline
	;  the following replaces "k $$$sqlineitself" everywhere  ;  AK244
#define  ksqline    k @vsqline
#define sqlineitself  @vsqline
#def1arg  sqline(%a)  @vsqline@(%a)
#def1arg qsqline(%a) "@vsqline@(%a)"
#define  qsqlineitself vsqline
	
	;  Some Cache' System Helpers
	        ; Steve Clay said on 06/19/2001:  
	        ; Use bit 21 for this test which is the code for USEBIGDB. NEWLOCK will be on when this is on.
#define sysUNICODE $zbitget($zversion(0),1)
 
	;  Some SQL helpers
	;#define VarcharType $s('$$$sysUNICODE:12,1:-9)
	
	;  Some general Cache' ObjectScript helper macros
#define LastPiece(%s,%p) $p(%s,%p,*)
#define AllButLastPiece(%s,%p) $p(%s,%p,1,*-1)
#define IsOneOf(%item,%list) ((","_%list_",")[(","_%item_","))
#define AllButFirstChar(%s) $e(%s,2,*)
#define AllButLastChar(%s) $e(%s,1,*-1)
#define StripLeadingWhiteSpace(%s) $zstrip(%s,"<W")
#define StripTrailingWhiteSpace(%s) $zstrip(%s,">W")
#define GlobalRefs $zu(67,9,$j)
	
#define DisplayQualifiedTableName(%t) ($$quoter2($p(%t,".",1,*-1))_"."_$$quoter2($tr($p(%t,".",*),$c(2),".")))
 
	; New table stuff using extents
#define SQLTabConnect(%e) $$$comMemberKeyGet(%e,$$$cCLASSparameter,"CONNECTION",$$$cPARAMdefault)
#define SQLTabExternalTableName(%e) $$$comMemberKeyGet(%e,$$$cCLASSparameter,"EXTERNALTABLENAME",$$$cPARAMdefault)
	
	; ODBC Stuff
	; Namespace name translation used for the Routine/Class name
#define NameSpaceTranslationRC(%ns) $tr(%ns,"%_-$@:/\[]^ ","pudsssssssss")
	; Namespace name translation used for the ^%sqlcq(...) global
#define NameSpaceTranslationG(%ns) $s($e(%ns)'="^":%ns,1:$tr(%ns,"%_-$@:/\[]^ ","pudsssssssss"))

#def1arg CQ(%1) ^%sqlcq($$$NameSpaceTranslationG($namespace),%1)
	// Used in %SYS.SQLSRV, cached query in a specified namespace, namespace is the variable ns
#def1arg CQns(%1) ^%sqlcq($$$NameSpaceTranslationG(ns),%1)
#def1arg CQPackageIndex(%1) ^%sqlcq($$$NameSpaceTranslationG($namespace),"Package",%1)
#def1arg CQPackageIndexns(%1) ^%sqlcq($$$NameSpaceTranslationG(ns),"Package",%1)
#define CQPackage "%sqlcq."_$$$NameSpaceTranslationRC($namespace)
#define CQPackagens "%sqlcq."_$$$NameSpaceTranslationRC(ns)
#define CQShortPackage "%sqlcq"
#define CQRoutinePrefix "%sqlcq."_$$$NameSpaceTranslationRC($namespace)_"."
#define CQRoutinePrefixns "%sqlcq."_$$$NameSpaceTranslationRC(ns)_"."
#define CQShortRoutinePrefix "%sqlcq."
#define CQroot ^%sqlcq
#define CQrootExtended(%database) ^|%database|%sqlcq
#define CQnsroot ^%sqlcq($$$NameSpaceTranslationG($namespace))
#define ExtentDB(%e) $p($$GetGlobalSourceDatabase^%SYS.SECURITY($name(^oddEXTR(%e))),"^",3)
#define ExtentDBNS(%ns,%e) $p($$GetGlobalSourceDatabase^%SYS.SECURITY($name(^|%ns|oddEXTR(%e))),"^",3)
#define CQSQLMarker $c(1)
#define CQSQLMarkerR $c(1)
#define CQGetLockTO	$system.Context.SQL().CQLockTimeout
#define LTTPackage "%sqlcq."_$$$NameSpaceTranslationRC($namespace)
#define LTTSchema "%sqlcq_"_$$$NameSpaceTranslationRC($namespace)
 
#define GetOdbcTypeName(%type) $lg(^%qCacheSQL("odbcdt25",%type))
#define GetJdbcTypeName(%type) $lg(^%qCacheSQL("jdbcdt",%type))
#define GetOdbcTypeNumber(%t) $case(%t,"GUID":-11,"BIT":-7,"TINYINT":-6,"BIGINT":-5,"LONGVARBINARY":-4,"VARBINARY":-3,"LONGVARCHAR":-1,"NUMERIC":2,"INTEGER":4,"SMALLINT":5,"DOUBLE":8,"DATE":9,"TIME":10,"TIMESTAMP":11,:12)
#define GetJdbcTypeNumber(%t) $case(%t,"GUID":-11,"BIT":-7,"TINYINT":-6,"BIGINT":-5,"LONGVARBINARY":-4,"VARBINARY":-3,"LONGVARCHAR":-1,"NUMERIC":2,"INTEGER":4,"SMALLINT":5,"DOUBLE":8,"DATE":91,"TIME":92,"TIMESTAMP":93,:12)
	
	; New post-^mdd metadata
	
 	; ^rINDEXSQL("rv",$$$UPPER(schema),$$$UPPER(table)) = $LB(classname,extentname,Relation Type - 1 or 3,InternalQualifiedName)
#define GetClassNameFromTableName(%schema,%table) $lg($g(^rINDEXSQL("rv",$$$UPPER(%schema),$$$UPPER(%table))))
#define GetExtentNameFromTableName(%schema,%table) $lg($g(^rINDEXSQL("rv",$$$UPPER(%schema),$$$UPPER(%table))),2)
#define GetTableTypeFromTableName(%schema,%table) $lg($g(^rINDEXSQL("rv",$$$UPPER(%schema),$$$UPPER(%table))),3)
#define GetIQNFromTableName(%schema,%table) $lg($g(^rINDEXSQL("rv",$$$UPPER(%schema),$$$UPPER(%table))),4)
#define GetExactIntQualifiedName(%schema,%table) $lg($g(^rINDEXSQL("rv",$$$UPPER(%schema),$$$UPPER(%table))),4)
 
#define BuildIQN(%schema,%name) (%schema_"."_$tr(%name,".",$c(2)))
#define SchemaFromIQN(%s) $$$AllButLastPiece(%s,".")
#define TableFromIQN(%s) $tr($$$LastPiece(%s,"."),$c(2),".")
#define GetClassNameFromIQN(%t) $lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t)))))
#define GetExtentNameFromIQN(%t) $lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t)))),2)
#define GetTableTypeFromIQN(%t) $lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t)))),3)
#define GetExactIQNFromIQN(%t) $lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t)))),4)
#define GetTimeStampFromIQN(%t) $lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t)))),5)
#define GetRVIdxDataFromIQN(%t) $g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t))))
#define GetExtentNameFromIQNNS(%ns,%t) $lg($g(^|%ns|rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%t)),$$$UPPER($$$TableFromIQN(%t)))),2)
 

#DEF1ARG ptln(%a) %ptln(%a)
#define ptlnRoot %ptln

#DEF1ARG ptrel(%a) %ptrel(%a)
#define ptrelRoot %ptrel

	; The following are macros used when refering to metadata in the temp structure with compile-time irn/ifn/imp values
	
#DEF1ARG smd(%a) ^||%sql.smd(%a)
#DEF1ARG smdG(%a) $g(^||%sql.smd(%a))
#define smdRoot ^||%sql.smd
#define smdRootQuoted "^||%sql.smd"
				#; Create temp metadata if not already defined
#define smdexists(%iqn) 				$d($$$smd("rv",$$$UPPER(%iqn)))&&($$$smdRoot=$namespace)&&($p($$$smd("rv",$$$UPPER(%iqn)),$c(1),4)=$lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%iqn)),$$$UPPER($$$TableFromIQN(%iqn)))),5))&&($s($$$GetClassNameFromIQN(%iqn)="":1,1:$p($$$smd("rv",$$$UPPER(%iqn)),$c(1),5)=$g($$$comClassKeyRaw($$$GetClassNameFromIQN(%iqn),$$$cCLASStimechanged))))
	; smdOK will return 1 if the tabletimestamp from smd and ^rINDEXSQL match AND the classtimestamp from smd and ^oddCOM match
#define smdOK(%iqn) 					($p($$$smd("rv",$$$UPPER(%iqn)),$c(1),4)=$lg($g(^rINDEXSQL("rv",$$$UPPER($$$SchemaFromIQN(%iqn)),$$$UPPER($$$TableFromIQN(%iqn)))),5) && $s($$$GetClassNameFromIQN(%iqn)="":1,1:$p($$$smd("rv",$$$UPPER(%iqn)),$c(1),5)=$g($$$comClassKeyRaw($$$GetClassNameFromIQN(%iqn),$$$cCLASStimechanged))))
	//#define smdLoadGetIrn(%iqn)		$s($$$smdexists(%iqn):$$$smdGetIrn(%iqn),1:$$LoadIntoTemp^%qTable($$$GetExtentNameFromIQN(%iqn)))
#def1arg smdLoadGetIrn(%val)				$$smdLoadGetIrn^%qTable(%val)
#define smdRVData(%iqn)					$g($$$smd("rv",$$$UPPER(%iqn)))
#define smdGetIrn(%iqn)					$p($$$smd("rv",$$$UPPER(%iqn)),$c(1),2)
#define smdGetTType(%iqn)				$p($$$smd("rv",$$$UPPER(%iqn)),$c(1),3)
#define smdGetIfn(%ttype,%irn,%fname)			$o($$$smd(%ttype,%irn,"f",$$$IDName(%fname),""))
#define smdGetViewColNum(%irn,%fname)			$o($$$smd(3,%irn,"f",$$$IDName(%fname),""))
#define smdGetViewColIfn(%irn,%fname,%vcol)		$p($$$smd(3,%irn,"f",$$$IDName(%fname),%vcol),$c(1),2)
#define smdFieldExists(%ttype,%irn,%fname)		$d($$$smd(%ttype,%irn,"f",$$$IDName(%fname)))
#define smdImp(%imp) 					$s($d(mt("smdimp",+%imp)):mt("smdimp",+%imp),1:+%imp)
#define smdSchema(%ttype,%irn) 				$lg($$$smdG(%ttype,%irn),1)
#define smdName(%ttype,%irn)	 			$lg($$$smdG(%ttype,%irn),2)
#define smdClassname(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),3)
#define smdOwner(%ttype,%irn) 				$lg($$$smdG(%ttype,%irn),4)
#define smdExtentSize(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),5)
#define smdLastCompileTime(%ttype,%irn) 		$lg($$$smdG(%ttype,%irn),6)
#define smdReadOnly(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),7)
#define smdCacheStorage(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),8)
#define smdRowIDFieldName(%ttype,%irn)	 		$lg($$$smdG(%ttype,%irn),9)
#define smdRowIDBased(%ttype,%irn)		 	$lg($$$smdG(%ttype,%irn),10)
#define smdRowIDLogicalFields(%ttype,%irn)	 	$lg($$$smdG(%ttype,%irn),11)
#define smdRowIDPhysicalFields(%ttype,%irn) 		$lg($$$smdG(%ttype,%irn),12)
#define smdBitMapFriendly(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),13)
#define smdPhysicalNumright(%ttype,%irn) 		$lg($$$smdG(%ttype,%irn),14)
#define smdLogicalNumright(%ttype,%irn) 		$lg($$$smdG(%ttype,%irn),15)
#define smdParentTable(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),16)
#define smdChildTableType(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),17)
#define smdParentExtent(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),18)
#define smdReferences(%ttype,%irn)	 		$lg($$$smdG(%ttype,%irn),19)
#define smdParentRefField(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),20)
#define smdMasterMapName(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),21)
#define smdSystemFlag(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),22)
#define smdLockReference(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),23)
#define smdExtent(%ttype,%irn)	 			$lg($$$smdG(%ttype,%irn),24)
#define smdRowIDField(%ttype,%irn)	 		$lg($$$smdG(%ttype,%irn),25)
#define smdMasterMap(%ttype,%irn) 			$lg($$$smdG(%ttype,%irn),26)
#define smdTempTableType(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),27)
#define smdConnection(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),28)
#define smdPreventFullScan(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),29)
#define smdBitmapExtentMap(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),34)
#define smdIsATVF(%ttype,%irn)				$lg($$$smdG(%ttype,%irn),35)
#define smdSharded(%ttype,%irn)				$lg($$$smdG(%ttype,%irn),36)
#define smdShardKey(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),37)
#define smdShardReferences(%ttype,%irn)			$lg($$$smdG(%ttype,%irn),38)

#define smdRowLevelSecurityParam(%ttype,%irn)	$lg($$$smdG(%ttype,%irn),39)
#define smdJSONTABLE(%ttype,%irn)				$$$smd(%ttype,%irn,13)
#define smdKids(%ttype,%irn)					$g($$$smd(%ttype,%irn,20))
#define smdAllUpperFields(%ttype,%irn)			$$$smd(%ttype,%irn,30)
#define smdAllExactFields(%ttype,%irn)			$$$smd(%ttype,%irn,32)
	; The rest are for Views only
#define smdViewUpdateable(%irn)	 			$lg($$$smd(3,%irn),30)
#define smdViewCheckOption(%irn)	 		$lg($$$smd(3,%irn),31)
#define smdViewDependsOn(%irn)	 			$lg($$$smd(3,%irn),32)
	; Misc
#define smdTType(%irn)					$s($d($$$smd(1,%irn)):1,$d($$$smd(3,%irn)):3,1:"")
#define smdGetIqnFromIrn(%irn)				$$$smdSchema($$$smdTType(%irn),%irn)_"."_$tr($$$smdName($$$smdTType(%irn),%irn),".",$c(2))
#define smdTableRoutinePrefix(%irn) 			$$$nameTableRoutinePrefixGet($$$smdExtent(1,%irn))
 
 
	; For Table Columns
#define smdGetFieldName(%ifn)					$p($g($$$smd(1,"ifn",%ifn)),$c(1))
#define smdGetIrnFromIfn(%ifn)					$p($g($$$smd(1,"ifn",%ifn)),$c(1),2)
#define smdGetIcolFromIfn(%ifn)					$p($g($$$smd(1,"ifn",%ifn)),$c(1),3)
#define smdGetNameFromIcol(%ttype,%irn,%icol)			$$$smdGetFieldName($$$smdG(%ttype,%irn,"col",%icol))
#define smdColName(%ttype,%irn,%ifn) 				$lg($$$smdG(%ttype,%irn,2,%ifn),1)
#define smdColNumber(%ttype,%irn,%ifn) 				$lg($$$smdG(%ttype,%irn,2,%ifn),2)
#define smdColRequired(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),3)
#define smdColDatatype(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),4)
#define smdColHidden(%ttype,%irn,%ifn) 				$lg($$$smdG(%ttype,%irn,2,%ifn),5)
#define smdColUnique(%ttype,%irn,%ifn) 				$lg($$$smdG(%ttype,%irn,2,%ifn),6)
#define smdColMaxLength(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),7)
#define smdColSelectivity(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),8)
#define smdColCollation(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),9)
#define smdColxDBCType(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),10)
#define smdColArrayCollection(%ttype,%irn,%ifn)			$lg($$$smdG(%ttype,%irn,2,%ifn),11)
#define smdColStream(%ttype,%irn,%ifn) 				$lg($$$smdG(%ttype,%irn,2,%ifn),12)
#define smdColSystemGeneratedValue(%ttype,%irn,%ifn)		$lg($$$smdG(%ttype,%irn,2,%ifn),13)
#define smdColContainerField(%ttype,%irn,%ifn)			$lg($$$smdG(%ttype,%irn,2,%ifn),14)
#define smdColListCollection(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),15)
#define smdColListType(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),16)
#define smdColListDelimiter(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),17)
#define smdColListCollectionType(%ttype,%irn,%ifn) 		$lg($$$smdG(%ttype,%irn,2,%ifn),18)
#define smdColComputed(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),19)
#define smdColComputedAlways(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),20)
	//#define smdColComputedTriggerFields(%ttype,%irn,%ifn) 		$lg($$$smd(%ttype,%irn,2,%ifn),21)
#define smdColComputedReferencedFields(%ttype,%irn,%ifn)	$lg($$$smdG(%ttype,%irn,2,%ifn),22)
	//#define smdColDefaultValue(%ttype,%irn,%ifn) 			$lg($$$smd(%ttype,%irn,2,%ifn),23)
#define smdColExternalFieldName(%ttype,%irn,%ifn) 		$lg($$$smdG(%ttype,%irn,2,%ifn),24)
#define smdColRecIDBased(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),25)
#define smdColRecIDBasedFields(%ttype,%irn,%ifn)		$lg($$$smdG(%ttype,%irn,2,%ifn),26)
#define smdColRecIDDisplayable(%ttype,%irn,%ifn) 		$lg($$$smdG(%ttype,%irn,2,%ifn),27)
#define smdColReferencedTable(%ttype,%irn,%ifn) 		$lg($$$smdG(%ttype,%irn,2,%ifn),28)
#define smdColPropertyName(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),29)
#define smdColReadOnly(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),30)
#define smdColIsKeyColumn(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),31)
#define smdColIsIdentityColumn(%ttype,%irn,%ifn) 		$lg($$$smdG(%ttype,%irn,2,%ifn),32)
#define smdColOIDType(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),33)
#define smdColIsRowVersion(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),34)
#define smdColCategory(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),35)
#define smdColCollectionType(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),36)
#define smdColContainerType(%ttype,%irn,%ifn) 			$lg($$$smdG(%ttype,%irn,2,%ifn),37)
#define smdColOutlierSelectivity(%ttype,%irn,%ifn)		$lg($$$smdG(%ttype,%irn,2,%ifn),38)
#define smdColOrigin(%ttype,%irn,%ifn)				$lg($$$smdG(%ttype,%irn,2,%ifn),39)
#define smdColBiasQueriesAsOutlier(%ttype,%irn,%ifn)		$lg($$$smdG(%ttype,%irn,2,%ifn),40)
#define smdColAverageFieldSize(%ttype,%irn,%ifn)		$lg($$$smdG(%ttype,%irn,2,%ifn),41)
#define smdColEXTERNALSQLTYPE(%ttype,%irn,%ifn)			$g($$$smd(%ttype,%irn,2,%ifn,"adtp","EXTERNALSQLTYPE"))
#define smdColVALUELIST(%ttype,%irn,%ifn) 			$g($$$smd(%ttype,%irn,2,%ifn,"adtp","VALUELIST"))
	//#define smdColTypeParameters(%ttype,%irn,%ifn) 			$lg($$$smd(%ttype,%irn,2,%ifn),30)
 
	// For JSON_TABLE (node 13)
#define smdJSONTABLECollection(%ttype,%irn)				$lg($$$smdG(%ttype,%irn),1)
#define smdJSONTABLEIndex(%ttype,%irn,%index)			$$$smd(%ttype,%irn,13,%index)

	; For Maps
#define smdMapName(%imp) 				$lg($$$smd(12,+%imp),1)
#define smdMapGlobal(%imp) 				$lg($$$smd(12,+%imp),2)
#define smdMapMaster(%imp) 				$lg($$$smd(12,+%imp),3)
#define smdMapPopulateType(%imp) 			$lg($$$smd(12,+%imp),4)
#define smdMapDataType(%imp) 				$lg($$$smd(12,+%imp),5)
#define smdMapUnique(%imp) 				$lg($$$smd(12,+%imp),6)
#define smdMapIndexType(%imp) 				$lg($$$smd(12,+%imp),7)
#define smdMapIndexFields(%imp) 			$lg($$$smd(12,+%imp),8)
#define smdMapFromThisTable(%imp) 			$lg($$$smd(12,+%imp),9)
#define smdMapConditional(%imp) 			$lg($$$smd(12,+%imp),10)
#define smdMapConditionalCode(%imp) 			$lg($$$smd(12,+%imp),11)
#define smdMapConditionalHostVariables(%imp) 		$lg($$$smd(12,+%imp),12)
#define smdMapConditionalFields(%imp) 			$lg($$$smd(12,+%imp),13)
#define smdMapConditionalPercent(%imp) 			$lg($$$smd(12,+%imp),14)
#define smdMapRowReference(%imp) 			$lg($$$smd(12,+%imp),15)
#define smdMapNullMarkers(%imp) 			$lg($$$smd(12,+%imp),16)
#define smdMapNumberOfBlocksAlone(%imp)			$lg($$$smd(12,+%imp),17)
#define smdMapNumberOfBlocks(%imp)			$lg($$$smd(12,+%imp),18)
#define smdMapParIDInSub(%imp)				$lg($$$smd(12,+%imp),19)
#define smdMapParIDStartLev(%imp)			$lg($$$smd(12,+%imp),20)
#define smdMapParIDLastLev(%imp)			$lg($$$smd(12,+%imp),21)
#define smdMapParIDInOrder(%imp)			$lg($$$smd(12,+%imp),22)
#define smdMapRowIDStartLev(%imp)			$lg($$$smd(12,+%imp),23)
#define smdMapRowIDLastLev(%imp)			$lg($$$smd(12,+%imp),24)
#define smdMapRowIDInOrder(%imp)			$lg($$$smd(12,+%imp),25)
#define smdMapRowIDNumLevs(%imp)			$lg($$$smd(12,+%imp),26)
#define smdMapParIDLevWOCon(%imp)			$lg($$$smd(12,+%imp),27)
#define smdMapParIDStartLevWOCon(%imp)			$lg($$$smd(12,+%imp),28)
#define smdMapCompiledTopLevelPieces(%imp)		$lg($$$smd(12,+%imp),34)
#define smdMapParentMapUnder(%imp)			$lg($$$smd(12,+%imp),35)
#define smdMapIrn(%imp)					$lg($$$smd(12,+%imp),37)
#define smdMapBitSliceScale(%imp)			$lg($$$smd(12,+%imp),38)
#define smdMapAllFieldsInMainNode(%imp)			$lg($$$smd(12,+%imp),39)
#define smdMapTVFCall(%imp)				$lg($$$smd(12,+%imp),40)
 
	; For Map Subscripts
#define smdMSFieldName(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),1)
#define smdMSConstant(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),2)
#define smdMSFunction(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),3)
#define smdMSExpression(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),4)
#define smdMSStartValue(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),5)
#define smdMSStopValue(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),6)
#define smdMSStopExpression(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),7)
#define smdMSAccessType(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),8)
#define smdMSPieceDelimiter(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),9)
#define smdMSNullMarker(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),10)
#define smdMSDefaultInvalidConditions(%imp,%lev)	$lg($g($$$smd(12,+%imp,6,%lev)),11)
#define smdMSOverrideInvalidCondition(%imp,%lev)	$lg($g($$$smd(12,+%imp,6,%lev)),12)
	; DPV3485 #define smdMSDefaultNextCode(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),13)
#define smdMSOverrideNextCode(%imp,%lev)		$lg($g($$$smd(12,+%imp,6,%lev)),14)
#define smdMSOverrideDataExpression(%imp,%lev)		$lg($g($$$smd(12,+%imp,6,%lev)),15)
#define smdMSLoopInitValue(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),16)
#define smdMSFieldSchema(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),17)
#define smdMSFieldTable(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),18)
#define smdMSFieldIfn(%imp,%lev)			$lg($g($$$smd(12,+%imp,6,%lev)),19)
 
	; For Map Variables
#define smdMVName(%imp,%lev,%ivar)			$lg($$$smd(12,+%imp,6,%lev,"expr",%ivar))
#define smdMVCode(%imp,%lev,%ivar)			$lg($$$smd(12,+%imp,6,%lev,"expr",%ivar),2)
 
	; For Map Data
#define smdMDifn(%imp,%lev)				$lg($g($$$smd(12,+%imp,7,%lev)),1)
#define smdMDNode(%imp,%lev)				$lg($g($$$smd(12,+%imp,7,%lev)),2)
#define smdMDPiece(%imp,%lev)				$lg($g($$$smd(12,+%imp,7,%lev)),3)
#define smdMDDelimiter(%imp,%lev)			$lg($g($$$smd(12,+%imp,7,%lev)),4)
#define smdMDRetrievalCode(%imp,%lev)			$lg($g($$$smd(12,+%imp,7,%lev)),5)
 
	; For Map RowID Specs
#define smdMRIfn(%imp,%lev)				$lg($$$smd(12,+%imp,8.5,%lev)
#define smdMRExpression(%imp,%lev)			$lg($$$smd(12,+%imp,8.5,%lev)
 
	; The following macros are used for referencing data from the sqlinfo data string in the
	; Extent definition after the sqlinfo data string has been set to the local variable '%data'
	
	; For Table sqlinfo in $$$EXTsqlinfo($$$rEXT,extentname)
 
#define SQLLocTableSchema(%data) 			$lg(%data)
#define SetSQLLocTableSchema(%data) 			$li(%data)
#define SQLLocTableName(%data)	 			$lg(%data,2)
#define SetSQLLocTableName(%data) 			$li(%data,2)
#define SQLLocTableClassname(%data) 			$lg(%data,3)
#define SetSQLLocTableClassname(%data) 			$li(%data,3)
#define SQLLocTableOwner(%data) 			$lg(%data,4)
#define SetSQLLocTableOwner(%data) 			$li(%data,4)
#define SQLLocTableExtentSize(%data) 			$lg(%data,5)
#define SetSQLLocTableExtentSize(%data)			$li(%data,5)
#define SQLLocTableLastCompileTime(%data) 		$lg(%data,6)
#define SetSQLLocTableLastCompileTime(%data) 		$li(%data,6)
#define SQLLocTableReadOnly(%data)		 	$lg(%data,7)
#define SetSQLLocTableReadOnly(%data) 			$li(%data,7)
#define SQLLocTableCacheStorage(%data)	 		$lg(%data,8)
#define SetSQLLocTableCacheStorage(%data) 		$li(%data,8)
#define SQLLocTableRowIDField(%data)	 		$lg(%data,9)
#define SetSQLLocTableRowIDField(%data) 		$li(%data,9)
#define SQLLocTableRowIDBased(%data)		 	$lg(%data,10)
#define SetSQLLocTableRowIDBased(%data)	 		$li(%data,10)
#define SQLLocTableRowIDLogicalFields(%data)	 	$lg(%data,11)
#define SetSQLLocTableRowIDLogicalFields(%data) 	$li(%data,11)
#define SQLLocTableRowIDPhysicalFields(%data)	 	$lg(%data,12)
#define SetSQLLocTableRowIDPhysicalFields(%data) 	$li(%data,12)
#define SQLLocTableBitMapFriendly(%data)	 	$lg(%data,13)
#define SetSQLLocTableBitMapFriendly(%data) 		$li(%data,13)
#define SQLLocTablePhysicalNumright(%data) 		$lg(%data,14)
#define SetSQLLocTablePhysicalNumright(%data)	 	$li(%data,14)
#define SQLLocTableLogicalNumright(%data) 		$lg(%data,15)
#define SetSQLLocTableLogicalNumright(%data)	 	$li(%data,15)
#define SQLLocTableParentTable(%data)	 		$lg(%data,16)
#define SetSQLLocTableParentTable(%data)	 	$li(%data,16)
#define SQLLocTableChildTableType(%data)	 	$lg(%data,17)
#define SetSQLLocTableChildTableType(%data)	 	$li(%data,17)
#define SQLLocTableParentExtent(%data)	 		$lg(%data,18)
#define SetSQLLocTableParentExtent(%data)	 	$li(%data,18)
#define SQLLocTableReferences(%data)	 		$lg(%data,19)
#define SetSQLLocTableReferences(%data)		 	$li(%data,19)
#define SQLLocTableParentRefField(%data) 		$lg(%data,20)
#define SetSQLLocTableParentRefField(%data)	 	$li(%data,20)
#define SQLLocTableMasterMap(%data) 			$lg(%data,21)
#define SetSQLLocTableMasterMap(%data)		 	$li(%data,21)
#define SQLLocTableSystemFlag(%data) 			$lg(%data,22)
#define SetSQLLocTableSystemFlag(%data)		 	$li(%data,22)
#define SQLLocTableLockReference(%data) 		$lg(%data,23)
#define SetSQLLocTableLockReference(%data)	 	$li(%data,23)
#define SQLLocTableType(%data)		 		$lg(%data,24)
#define SetSQLLocTableType(%data)		 	$li(%data,24)
#define SQLLocTableFinalized(%data)	 		$lg(%data,25)
#define SetSQLLocTableFinalized(%data)		 	$li(%data,25)
#define SQLLocFilerReadOnly(%data)	 		$lg(%data,26)
#define SetSQLLocFilerReadOnly(%data)		 	$li(%data,26)
#define SQLLocTableSharded(%data)			$lg(%data,27)
#define SetSQLLocTableSharded(%data)		 	$li(%data,27)
#define SQLLocTableShardKey(%data)			$lg(%data,28)
#define SetSQLLocTableShardKey(%data)			$li(%data,28)
	; The rest are for Views only
#define SQLLocView(%data)	 			$lg(%data,29)
#define SetSQLLocView(%data)		 		$li(%data,29)
#define SQLLocViewUpdateable(%data)	 		$lg(%data,30)
#define SetSQLLocViewUpdateable(%data)		 	$li(%data,30)
#define SQLLocViewCheckOption(%data)	 		$lg(%data,31)
#define SetSQLLocViewCheckOption(%data)		 	$li(%data,31)
#define SQLLocViewDependsOn(%data)	 		$lg(%data,32)
#define SetSQLLocViewDependsOn(%data)		 	$li(%data,32)
#define SQLLocViewAliasListGenerated(%data)		$lg(%data,33)
#define SetSQLLocViewAliasListGenerated(%data)		$li(%data,33)
 
	; For Table Column sqlinfo in $$$EXTCOLsqlinfo($$$rEXT,class,columnname)
 
#define SQLLocColNumber(%data) 				$lg(%data)
#define SetSQLLocColNumber(%data) 			$li(%data)
#define SQLLocColRequired(%data) 			$lg(%data,2)
#define SetSQLLocColRequired(%data) 			$li(%data,2)
#define SQLLocColDatatype(%data) 			$lg(%data,3)
#define SetSQLLocColDatatype(%data) 			$li(%data,3)
#define SQLLocColHidden(%data) 				$lg(%data,4)
#define SetSQLLocColHidden(%data) 			$li(%data,4)
#define SQLLocColUnique(%data) 				$lg(%data,5)
#define SetSQLLocColUnique(%data) 			$li(%data,5)
#define SQLLocColMaxLength(%data) 			$lg(%data,6)
#define SetSQLLocColMaxLength(%data) 			$li(%data,6)
#define SQLLocColSelectivity(%data) 			$lg(%data,7)
#define SetSQLLocColSelectivity(%data) 			$li(%data,7)
#define SQLLocColCollation(%data) 			$lg(%data,8)
#define SetSQLLocColCollation(%data) 			$li(%data,8)
#define SQLLocColxDBCType(%data) 			$lg(%data,9)
#define SetSQLLocColxDBCType(%data) 			$li(%data,9)
#define SQLLocColArrayCollection(%data) 		$lg(%data,10)
#define SetSQLLocArrayCollection(%data) 		$li(%data,10)
#define SQLLocColStream(%data) 				$lg(%data,11)
#define SetSQLLocColStream(%data) 			$li(%data,11)
#define SQLLocColSystemGeneratedValue(%data)		$lg(%data,12)
#define SetSQLLocColSystemGeneratedValue(%data)		$li(%data,12)
#define SQLLocColContainerField(%data)			$lg(%data,13)
#define SetSQLLocColContainerField(%data)		$li(%data,13)
#define SQLLocColListCollection(%data) 			$lg(%data,14)
#define SetSQLLocColListCollection(%data) 		$li(%data,14)
#define SQLLocColListType(%data) 			$lg(%data,15)
#define SetSQLLocColListType(%data) 			$li(%data,15)
#define SQLLocColListDelimiter(%data) 			$lg(%data,16)
#define SetSQLLocColListDelimiter(%data) 		$li(%data,16)
#define SQLLocColListCollectionType(%data) 		$lg(%data,17)
#define SetSQLLocColListCollectionType(%data) 		$li(%data,17)
#define SQLLocColComputed(%data) 			$lg(%data,18)
#define SetSQLLocColComputed(%data) 			$li(%data,18)
#define SQLLocColComputedAlways(%data) 			$lg(%data,19)
#define SetSQLLocColComputedAlways(%data) 		$li(%data,19)
#define SQLLocColComputedTriggerFields(%data) 		$lg(%data,20)
#define SetSQLLocColComputedTriggerFields(%data)	$li(%data,20)
#define SQLLocColComputedReferencedFields(%data) 	$lg(%data,21)
#define SetSQLLocColComputedReferencedFields(%data) 	$li(%data,21)
#define SQLLocColDefaultValue(%data) 			$lg(%data,22)
#define SetSQLLocColDefaultValue(%data) 		$li(%data,22)
#define SQLLocColExternalFieldName(%data) 		$lg(%data,23)
#define SetSQLLocColExternalFieldName(%data)		$li(%data,23)
#define SQLLocColRecIDBased(%data) 			$lg(%data,24)
#define SetSQLLocColRecIDBased(%data) 			$li(%data,24)
#define SQLLocColRecIDBasedFields(%data)		$lg(%data,25)
#define SetSQLLocColRecIDBasedFields(%data) 		$li(%data,25)
#define SQLLocColRecIDDisplayable(%data) 		$lg(%data,26)
#define SetSQLLocColRecIDDisplayable(%data) 		$li(%data,26)
#define SQLLocColReferencedTable(%data) 		$lg(%data,27)
#define SetSQLLocColReferencedTable(%data) 		$li(%data,27)
#define SQLLocColPropertyName(%data) 			$lg(%data,28)
#define SetSQLLocColPropertyName(%data)			$li(%data,28)
#define SQLLocColTypeParameters(%data) 			$lg(%data,29)
#define SetSQLLocColTypeParameters(%data) 		$li(%data,29)
#define SQLLocColReadOnly(%data) 			$lg(%data,30)
#define SetSQLLocColReadOnly(%data) 			$li(%data,30)
#define SQLLocColOIDType(%data) 			$lg(%data,31)
#define SetSQLLocColOIDType(%data) 			$li(%data,31)
#define SQLLocColIdentity(%data) 			$lg(%data,32)
#define SetSQLLocColIdentity(%data) 			$li(%data,32)
#define SQLLocColQualifiedProperty(%data) 		$lg(%data,33)
#define SetSQLLocColQualifiedProperty(%data) 		$li(%data,33)
#define SQLLocColContainerType(%data) 			$lg(%data,34)
#define SetSQLLocColContainerType(%data) 		$li(%data,34)
#define SQLLocColOutlierSelectivity(%data)		$lg(%data,35)
#define SetSQLLocColOutlierSelectivity(%data)		$li(%data,35)
#define SQLLocColOrigin(%data)				$lg(%data,36)
#define SetSQLLocColOrigin(%data)			$li(%data,36)
#define SQLLocColBiasQueriesAsOutlier(%data)		$lg(%data,37)
#define SetSQLLocColBiasQueriesAsOutlier(%data)		$li(%data,37)
#define SQLLocColAverageFieldSize(%data)		$lg(%data,38)
#define SetSQLLocColAverageFieldSize(%data)		$li(%data,38)
#define SQLLocColSQLCategory(%data)			$lg(%data,39)
#define SetSQLLocColSQLCategory(%data)			$li(%data,39)
#define SQLLocColCollectionType(%data)			$lg(%data,40)
#define SetSQLLocColCollectionType(%data)		$li(%data,40)
 
	; For View Column sqlinfo in $$$EXTCOLsqlinfo($$$rEXT,class,columnname)
 
#define SQLLocViewColNumber(%data) 			$lg(%data)
#define SetSQLLocViewColNumber(%data) 			$li(%data)
#define SQLLocViewColExtent(%data) 			$lg(%data,2)
#define SetSQLLocViewColExtent(%data) 			$li(%data,2)
#define SQLLocViewColTableFieldName(%data) 		$lg(%data,3)
#define SetSQLLocViewColTableFieldName(%data)		$li(%data,3)
#define SQLLocViewColName(%data) 			$lg(%data,4)
#define SetSQLLocViewColName(%data) 			$li(%data,4)
#define SQLLocViewColxDBCType(%data) 			$lg(%data,5)
#define SetSQLLocViewColxDBCType(%data) 		$li(%data,5)
#define SQLLocViewColMaxLength(%data) 			$lg(%data,6)
#define SetSQLLocViewColMaxLength(%data) 		$li(%data,6)
#define SQLLocViewColPrecision(%data)	 		$lg(%data,7)
#define SetSQLLocViewColPrecision(%data) 		$li(%data,7)
#define SQLLocViewColScale(%data) 			$lg(%data,8)
#define SetSQLLocViewColScale(%data) 			$li(%data,8)
#define SQLLocViewColNullable(%data) 			$lg(%data,9)
#define SetSQLLocViewColNullable(%data) 		$li(%data,9)
#define SQLLocViewColLabel(%data) 			$lg(%data,11)
#define SetSQLLocViewColLabel(%data) 			$li(%data,11)
#define SQLLocViewColSchema(%data)			$lg(%data,12)
#define SetSQLLocViewColSchema(%data)			$li(%data,12)
#define SQLLocViewColTable(%data) 			$lg(%data,14)
#define SetSQLLocViewColTable(%data) 			$li(%data,14)
#define SQLLocViewColCollation(%data) 			$lg(%data,15)
#define SetSQLLocViewColCollation(%data) 		$li(%data,15)
#define SQLLocViewColObjType(%data) 			$lg(%data,16)
#define SetSQLLocViewColObjType(%data) 			$li(%data,16)
 
	; For Map sqlinfo in $$$EXTSQLMAPsqlinfo($$$rEXT,class,mapname)
 
#define SQLLocMapGlobal(%data) 				$lg(%data)
#define SetSQLLocMapGlobal(%data) 			$li(%data)
#define SQLLocMapMaster(%data) 				$lg(%data,2)
#define SetSQLLocMapMaster(%data) 			$li(%data,2)
#define SQLLocMapPopulateType(%data) 			$lg(%data,3)
#define SetSQLLocMapPopulateType(%data)			$li(%data,3)
#define SQLLocMapDataType(%data) 			$lg(%data,4)
#define SetSQLLocMapDataType(%data) 			$li(%data,4)
#define SQLLocMapUnique(%data) 				$lg(%data,5)
#define SetSQLLocMapUnique(%data) 			$li(%data,5)
#define SQLLocMapIndexType(%data) 			$lg(%data,6)
#define SetSQLLocMapIndexType(%data) 			$li(%data,6)
#define SQLLocMapIndexFields(%data) 			$lg(%data,7)
#define SetSQLLocMapIndexFields(%data) 			$li(%data,7)
#define SQLLocMapFromThisTable(%data) 			$lg(%data,8)
#define SetSQLLocMapFromThisTable(%data) 		$li(%data,8)
#define SQLLocMapConditional(%data) 			$lg(%data,9)
#define SetSQLLocMapConditional(%data) 			$li(%data,9)
#define SQLLocMapConditionalCode(%data) 		$lg(%data,10)
#define SetSQLLocMapConditionalCode(%data)		$li(%data,10)
#define SQLLocMapConditionalHostVariables(%data) 	$lg(%data,11)
#define SetSQLLocMapConditionalHostVariables(%data) 	$li(%data,11)
#define SQLLocMapConditionalFields(%data) 		$lg(%data,12)
#define SetSQLLocMapConditionalFields(%data) 		$li(%data,12)
#define SQLLocMapConditionalPercent(%data) 		$lg(%data,13)
#define SetSQLLocMapConditionalPercent(%data) 		$li(%data,13)
#define SQLLocMapRowReference(%data) 			$lg(%data,14)
#define SetSQLLocMapRowReference(%data) 		$li(%data,14)
#define SQLLocMapNullMarkers(%data) 			$lg(%data,15)
#define SetSQLLocMapNullMarkers(%data) 			$li(%data,15)
#define SQLLocMapNumberOfBlocksAlone(%data)		$lg(%data,16)
#define SetSQLLocMapNumberOfBlocksAlone(%data)		$li(%data,16)
#define SQLLocMapNumberOfBlocks(%data)			$lg(%data,17)
#define SetSQLLocMapNumberOfBlocks(%data)		$li(%data,17)
#define SQLLocMapParIDInSubs(%data)			$lg(%data,18)
#define SQLLocMapParIlevStart(%data)			$lg(%data,19)
#define SQLLocMapParIlevEnd(%data)			$lg(%data,20)
#define SQLLocMapParIDInOrder(%data)			$lg(%data,21)
#define SQLLocMapRowIDIlevStart(%data)			$lg(%data,22)
#define SQLLocMapRowIDIlevEnd(%data)			$lg(%data,23)
#define SQLLocMapNumIDLevels(%data)			$lg(%data,24)
#define SQLLocMapRowIDInOrder(%data)			$lg(%data,25)
#define SQLLocMapNumParIDLevels(%data)			$lg(%data,26)
#define SQLLocMapParIDStartLevel(%data)			$lg(%data,27)
#define SQLLocMapIndexOnCollection(%data)		$lg(%data,28)
#define SQLLocMapBlockCount(%data)			$lg(%data,29)
#define SetSQLLocMapBlockCount(%data)			$li(%data,29)
#define SQLLocMapIndexName(%data)			$lg(%data,30)
#define SQLLocMapCompiledTopLevelPieces(%data)		$lg(%data,33)
#define SetSQLLocMapCompiledTopLevelPieces(%data)	$li(%data,33)
#define SQLLocMapParentMapUnder(%data)			$lg(%data,34)
#define SetSQLLocMapParentMapUnder(%data)		$li(%data,34)
#define SQLLocMapMapUnder(%data)			$lg(%data,35)
#define SetSQLLocMapMapUnder(%data)			$li(%data,35)
#define SQLLocMapAllFieldsInMainNode(%data)		$lg(%data,36)
#define SetSQLLocMapAllFieldsInMainNode(%data)		$li(%data,36)
#define SQLLocMapBlockCountType(%data)			$lg(%data,37)
#define SetSQLLocMapBlockCountType(%data)		$li(%data,37)
 
	; For Map Subscript sqlinfo in $$$EXTSQLMAPSUBsqlinfo($$$rEXT,class,mapname,ilev)
 
#define SQLLocMapSubFieldName(%data)			$lg(%data)
#define SetSQLLocMapSubFieldName(%data) 		$li(%data)
#define SQLLocMapSubConstant(%data)			$lg(%data,2)
#define SetSQLLocMapSubConstant(%data) 			$li(%data,2)
#define SQLLocMapSubFunction(%data)			$lg(%data,3)
#define SetSQLLocMapSubFunction(%data) 			$li(%data,3)
#define SQLLocMapSubExpression(%data)			$lg(%data,4)
#define SetSQLLocMapSubExpression(%data)		$li(%data,4)
#define SQLLocMapSubStartValue(%data)			$lg(%data,5)
#define SetSQLLocMapSubStartValue(%data)		$li(%data,5)
#define SQLLocMapSubStopValue(%data)			$lg(%data,6)
#define SetSQLLocMapSubStopValue(%data)			$li(%data,6)
#define SQLLocMapSubStopExpression(%data)		$lg(%data,7)
#define SetSQLLocMapSubStopExpression(%data)		$li(%data,7)
#define SQLLocMapSubAccessType(%data)			$lg(%data,8)
#define SetSQLLocMapSubAccessType(%data) 		$li(%data,8)
#define SQLLocMapSubPieceDelimiter(%data)		$lg(%data,9)
#define SetSQLLocMapSubPieceDelimiter(%data) 		$li(%data,9)
#define SQLLocMapSubNullMarker(%data)			$lg(%data,10)
#define SetSQLLocMapSubNullMarker(%data) 		$li(%data,10)
#define SQLLocMapSubDefaultInvalidConditions(%data)	$lg(%data,11)
#define SetSQLLocMapSubDefaultInvalidConditions(%data)	$li(%data,11)
#define SQLLocMapSubOverrideInvalidCondition(%data)	$lg(%data,12)
#define SetSQLLocMapSubOverrideInvalidConditions(%data)	$li(%data,12)
	; DPV3485 #define SQLLocMapSubDefaultNextCode(%data)		$lg(%data,13)
	; DPV3485 #define SetSQLLocMapSubDefaultNextCode(%data)		$li(%data,13)
#define SQLLocMapSubOverrideNextCode(%data)		$lg(%data,14)
#define SetSQLLocMapSubOverrideNextCode(%data) 		$li(%data,14)
#define SQLLocMapSubOverrideDataExpression(%data)	$lg(%data,15)
#define SetSQLLocMapSubOverrideDataExpression(%data)	$li(%data,15)
#define SQLLocMapSubLoopInitValue(%data)		$lg(%data,16)
#define SetSQLLocMapSubLoopInitValue(%data)		$li(%data,16)
#define SQLLocMapSubFieldSchema(%data)			$lg(%data,17)
#define SetSQLLocMapSubFieldSchema(%data) 		$li(%data,17)
#define SQLLocMapSubFieldTable(%data)			$lg(%data,18)
#define SetSQLLocMapSubFieldTable(%data) 		$li(%data,18)
#define SQLLocMapSubBSScale(%data)			$lg(%data,19)
#define SetSQLLocMapSubBSScale(%data)	 		$li(%data,19)
#define SQLLocMapSubSwappedFieldName(%data)		$lg(%data,20)
#define SetSQLLocMapSubSwappedFieldName(%data)		$li(%data,20)
#define SQLLocMapSubCollectionFieldType(%data)		$lg(%data,21)
#define SetSQLLocMapSubCollectionFieldType(%data)	$li(%data,21)
#define SQLLocMapSubSubField(%data)			$lg(%data,22)
#define SetSQLLocMapSubSubField(%data)			$li(%data,22)
 
	; For Map Data sqlinfo in $$$EXTSQLMAPDATAsqlinfo($$$rEXT,extent,mapname,idata)
 
#define SQLLocMapDataFieldName(%data)			$lg(%data)
#define SQLLocMapDataNode(%data)			$lg(%data,2)
#define SQLLocMapDataPiece(%data)			$lg(%data,3)
#define SQLLocMapDataDelimiter(%data)			$lg(%data,4)
#define SQLLocMapDataFieldSchema(%data)			$lg(%data,5)
#define SQLLocMapDataFieldTable(%data)			$lg(%data,6)
#define SQLLocMapDataRetrievalCode(%data)		$lg(%data,7)
#define SetSQLLocMapDataRetrievalCode(%data)		$li(%data,7)
#define SQLLocMapFieldCollectionType(%data)		$lg(%data,8)
 
	; For Map RowID Specs sqlinfo in $$$EXTSQLMAPROWIDSPECsqlinfo($$$rEXT,extent,mapname,ilev)
 
#define SQLLocMapRowIDDpecFieldName(%data)		$lg(%data)
#define SQLLocMapRowIDSpecExpression(%data)		$lg(%data,2)
#define SQLLocMapRowIDSpecFieldExtent(%data)		$lg(%data,3)
 
	; For Map Variables sqlinfo in $$$EXTSQLMAPSUBVARSsqlinfo($$$rEXT,extent,mapname,ilev,ivar)
 
#define SQLLocMapVariableName(%data)			$lg(%data)
#define SQLLocMapVariableCode(%data)			$lg(%data,2)
 
#define complength 3800
#define MaxRtnLineLength 4095
	
#define Abort x "*"
	
#def1arg SQLIndex(%a) ^rINDEXSQL("sqlidx",%a)
#define  SQLIndexRoot ^rINDEXSQL("sqlidx")
#define  SQLIndexVersion ^rINDEXSQL("sqlidx",1)
#define  SQLIndexCurrentVersion 2

#define SQLReservedWordForParsing(%word) ($p($g(^%qCacheSQL("reservewords",%word)),$c(1),2)="Y")
	;** #define SQLReservedWordForParsing(%word) $d(rw(%word))
#define MSQLModuleVariable %msqlvar
#define MSQLModuleTag %msqltag
#define %msqlvarIsLocalVar (%msqlvar?0.1"%"1"sqldata")

#define MakeMSQLModuleVariable(%1) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_")",$$$%msqlvarIsLocalVar:%sqldatavar_%1,1:%msqlvar_%1)
	
	; --- Function May Quote the 2nd Parameter ---
#define MakeMSQLModuleVarArray(%1,%2) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_","_$zu(144,1,%2)_")",1:%msqlvar_%1_"("_$zu(144,1,%2)_")")
	
	; --- Function Will NOT Quote the 2nd Parameter ---
#define MakeMSQLModuleVarArrayNoQuote(%1,%2) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_","_%2_")",1:%msqlvar_%1_"("_%2_")")
	
	; --- Function May Quote the 2nd & 3rd Parameters ---
	#; Not used... #define MakeMSQLModuleVarArray3(%1,%2,%3) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_","_$zu(144,1,%2)_","_$zu(144,1,%3)_")",1:%msqlvar_%1_"("_$zu(144,1,%2)_","_$zu(144,1,%3)_")")
	
	; --- Function Will NOT Quote the 2nd & 3rd Parameters ---
	#; Not used... #define MakeMSQLModuleVarArray3NoQuote(%1,%2,%3) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_","_%2_","_%3_")",1:%msqlvar_%1_"("_%2_","_%3_")")
	
	; --- Function May Quote the 2nd, 3rd & 4th Parameters ---
#define MakeMSQLModuleVarArray4(%1,%2,%3,%4) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_","_$zu(144,1,%2)_","_$zu(144,1,%3)_","_$zu(144,1,%4)_")",1:%msqlvar_%1_"("_$zu(144,1,%2)_","_$zu(144,1,%3)_","_$zu(144,1,%4)_")")
	
	; --- Function Will NOT Quote the 2nd, 3rd & 4th Parameters ---
	#; Not used... #define MakeMSQLModuleVarArray4NoQuote(%1,%2,%3,%4) $s(%msqlvar["(":$p(%msqlvar,"(")_%1_"("_$p(%msqlvar,"(",2)_","_%2_","_%3_","_%4_")",1:%msqlvar_%1_"("_%2_","_%3_","_%4_")")

	; -1E14 is used as the NULL subscript marker because it is the
	; largest negative integer DSM can reliably store in a subscript
	; even though NextGen won't run on DSM, it should serve as a 
	; database server for SQL via DCP.  (Per request of PTR)
#define NULLSubscriptMarker -1E14
#define NULLSubscriptMarkerq "-1E14"
#define LockTimeout $zu(115,4)
#define LockTimeoutQ "$zu(115,4)"
	//#define LockClassShared(%class) Set $test=$$$ISOK($$LockClassRef^%occLock(%class,$name(^oddDEF(%class)),1))
	//#define UnLockClassSharedImmediate(%class) Do UnlockClassRef^%occLock(%class,$name(^oddDEF(%class)),1,1)
#define NULLParameterMacroList ",CharToDec,DecToChar,"
#define NULLParameterMacroTest(%macro) $case(%macro,"CharToDec":1,"DecToChar":1,:0)
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;                      Value tree property macros
	#;  (AK304 - moved here from ^pdt)
	#;  vtr properties stored at top node
#define storetop(%this,%p) $p(mt("vtr",%this),";",%p)
#define getstoretop(%this,%p) $p($g(mt("vtr",%this)),";",%p)
	#;  vtr properties stored in subscripts
#define storesub(%this,%s) mt("vtr",%this,%s)
#define getstoresub(%this,%s) $g(mt("vtr",%this,%s))
	#;  define individual properties - at top node
#define VTRtype(%this) $$$storetop(%this,1)
#define VTRgettype(%this) $$$getstoretop(%this,1)
#define VTRdt(%this) $$$storetop(%this,2)
#define VTRgetdt(%this) $$$getstoretop(%this,2)
#define VTRcat(%this) $$$storetop(%this,3)
#define VTRgetcat(%this) $$$getstoretop(%this,3)
#define VTRqno(%this) $$$storetop(%this,4)
#define VTRsetqno(%this) $$$getstoretop(%this,4)
#define VTRstr(%this) $$$storetop(%this,5)
#define VTRgetstr(%this) $$$getstoretop(%this,5)
#define VTRirn(%this) $$$storetop(%this,6)
#define VTRgetirn(%this) $$$getstoretop(%this,6)
#define VTRifn(%this) $$$storetop(%this,7)
#define VTRgetifn(%this) $$$getstoretop(%this,7)
#define VTRnarg(%this) $$$storetop(%this,8)
#define VTRgetnarg(%this) $$$getstoretop(%this,8)
	#;  list-fields information
	#;  VTRIsLF(%v) - Whether it is a list-field ("Y") or not
#define VTRIsLF(%this) $$$storetop(%this,9)
#define VTRgetIsLF(%this) $$$getstoretop(%this,9)
	#;  VTRLFDel(%v) - Serialized format delimiter, or NULL for $LIST
#define VTRLFDel(%this) $$$storetop(%this,10)
#define VTRgetLFDel(%this) $$$getstoretop(%this,10)
	#;  VTRLFStorage(%v) - storage type, serialized (1) or one-per-node (2)
#define VTRLFStorage(%this) $$$storetop(%this,11)
#define VTRgetLFStorage(%this) $$$getstoretop(%this,11)
	#;  VTRoref(%v) - 1/0 flag 1 means the value is an oref, 0 or "" means it is not
#define VTRoref(%this) $$$storetop(%this,12)
#define VTRgetoref(%this) $$$getstoretop(%this,12)
	#;  VTRcollation(%v) - Used to store the collation function for non fields (user defined functions to start with)
#define VTRcollation(%this) $$$storetop(%this,13)
#define VTRgetcollation(%this) $$$getstoretop(%this,13)
#define VTRscale(%this) $$$storetop(%this,14)
#define VTRgetscale(%this) $$$getstoretop(%this,14)
	#;  define individual properties - in subscripts
	#;  to GET these properties, you should probably use $g()
#define VTRname(%this) $$$storesub(%this,"name")
#define VTRgetname(%this) $$$getstoresub(%this,"name")
#define VTRlarg(%this) $$$storesub(%this,"larg")
#define VTRgetlarg(%this) $$$getstoresub(%this,"larg")
#define VTRlpar(%this) $$$storesub(%this,"lpar")
#define VTRgetlpar(%this) $$$getstoresub(%this,"lpar")
#define VTRlfld(%this) $$$storesub(%this,"lfld")
#define VTRgetlfld(%this) $$$getstoresub(%this,"lfld")
#define VTRlstr(%this) $$$storesub(%this,"lstr")
#define VTRgetlstr(%this) $$$getstoresub(%this,"lstr")
#define VTRagginfo(%this) $$$storesub(%this,"agginfo")
#define VTRgetagginfo(%this) $$$getstoresub(%this,"agginfo")
#define VTRqinfo(%this) $$$storesub(%this,"qinfo")
#define VTRgetqinfo(%this) $$$getstoresub(%this,"qinfo")
#define VTRomsinfo(%this) $$$storesub(%this,"omsinfo")
#define VTRgetomsinfo(%this) $$$getstoresub(%this,"omsinfo")
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  Get val# or run-time variable name for a named scratch variable
#define VarNum(%n) mt("var",%n)
#define VarName(%n) pti($$$VarNum(%n))
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	#;  NULL/empty-string attributes of a value
	#;  (stubs for now, independent of actual value)
	#;  All NES attributes
#define NES(%v) 1
	#;  Empty string supported (1/0)
#define NESes(%v) 1
	#;  Local value for NULL (quoted-quoted)
#define NESLocN(%v) """"""
	#;  Local value for empty string (quoted-quoted)
#define NESLocES(%v) "$c(0)"
	#;  Global value for NULL (quoted-quoted)
#define NESGloN(%v) """"""
	#;  Global value for empty string (quoted-quoted)
#define NESGloES(%v) "$c(0)"
#IF 1	; JLF005
#define SQLTRUE	1
#define SQLFALSE 0
#define SQLUNKNOWNQ """"""
#define SQLUNKNOWN ""
 
	#;  Values stored in ^mtemp0 by the set-valued subquery optimization
	#;  
#define	SQLEMPTYq					""""""					
#define SQLCONTAINSNULL				1
#define SQLMULTIDISTINCTVALUED		2
#define	SQLOTHER					3
#define SQLNULLREPLACEMENT			$c(0)
#define SQLNULLREPLACEMENTq			"$c(0)"
 
#define SQLMINFACTCARD				10000
#define SQLMINDIMRATIO				100
 
#ENDIF	; JLF005	
#IF 1	; JLF066+
#define SQLCOLLATIONS	",%ALPHAUP,%UPPER,%SPACE,%PLUS,%MINUS,%MVR,%STRING,%SQLSTRING,%SQLUPPER,%TRUNCATE,"
#ENDIF	; JLF066-
#IF 1	; JLF127+
		#; Set to 1 for the old anyof algorithm that runs after pushdownPreds, or
		#; Set to 0 for the new anyof algorithm that runs before pushdownPreds
#define SQLORIGANYOFALG				1
#ENDIF	; JLF127-
#define SQLELIMINATEDUPS	"ELIMINATE"
#define SQLPRESERVEDUPS		"PRESERVE"
#define SQLDONTCAREDUPS		"DONTCARE"
 		#; PVA147: introduce NODUPSPRESENT state; for use only inside distinctOpt^%qaqpre
#define SQLNODUPSPRESENT    "NODUPSPRESENT"
		#; mt("ON",m,*) fields
		#; OPERATOR field values
#define SQLONINNERJOIN		"INNER"
#define SQLONLEFTJOIN		"LEFT"
#define SQLONCROSSJOIN		"CROSS"
#define SQLONFULLJOIN		"FULL"
 		#; CATEGORY field values
#define SQLONCATGOOD		"good"
#define SQLONCATSIMPLE		"simple"
#define SQLONCATNULLREJECT	"nullreject"
		#; ON Fields
#define SQLONOPERATOR		1
#define SQLONPREDICATE		2
#define SQLONLEFTSTREAMS	3
#define SQLONRIGHTSTREAMS	4
#define SQLONCATEGORY		5
#define SQLONSTREAMSBITMAP	6
#define SQLONPARENT			7
#define	SQLONPARENTSIDE		8
		#; translation macros, for deepcopyqb
#define xlateQb(%m) $s('$d(xlate("qb",%m)):%m,1:xlate("qb",%m))
#define xlateStr(%str) $s('$d(xlate("r",%str)):%str,1:xlate("r",%str))
#define xlateVal(%val,%m) $s($d(viewFvals(%val,%m)):viewFvals(%val,%m),$d(xlate("v",%val)):xlate("v",%val),1:%val)
#define xlateLog(%log) $s('$d(xlate("l",%log)):%log,1:xlate("l",%log))
 
		#; ptv(val) fields
#define PTVEQUIVCLASS	1
#define PTVVALTYPE		2
#define PTVLOGREFS		3
#define PTVCONTYPE		4
#define PTVRANGEINFO	5
#define PTVVALSINCLASS	6
#define PTVQB			7
#define PTVSTR			8
#define	PTVIFN			9
#define PTVCONEQLSEL	10
#define PTVLENGTH		11
#define PTVNEEDEDFOROUTPUT		12
#define PTVOJSTR		13
#define PTVMAPS			14
#define PTVREFERENCED	15
#define PTVTOPINFO		16

	// SQL Dialect all values
#define SQLDIALECTALL			$lb("","CACHE","FDBMS","Informix","InterBase","MSSQL","MySQL","Oracle","Sybase")
#define SQLDIALECTALLUPPER		$lb("","CACHE","FDBMS","INFORMIX","INTERBASE","MSSQL","MYSQL","ORACLE","SYBASE")

	// SQL Dialects supported in dynamic statements
#define SQLDIALECTDYNAMIC		$lb("","CACHE","MSSQL","MSSQL","Sybase")
#define SQLDIALECTDYNAMICUPPER	$lb("","CACHE","MSSQL","MSSQLSERVER","SYBASE")

	// SQL Dialects individual values
#define SQLDIALECTDEFAULT		""
#define SQLDIALECTCACHE			"CACHE"
#define SQLDIALECTFDBMS			"FDBMS"
#define SQLDIALECTINFORMIX		"Informix"
#define SQLDIALECTINTERBASE		"InterBase"
#define SQLDIALECTMSSQL			"MSSQL"
#define SQLDIALECTMSSQLSERVER	"MSSQL"
#define SQLDIALECTMYSQL			"MySQL"
#define SQLDIALECTORACLE		"Oracle"
#define SQLDIALECTSYBASE		"Sybase"

#define SQLQueryInto(%class,%query) ##safeexpression($$QueryColInto^%SYS.DynamicQuery(%class,%query))
#define SQLQueryIntoODBC(%class,%query) ##safeexpression($$QueryColIntoODBC^%SYS.DynamicQuery(%class,%query))
#define SQLQueryIntoSendODBC(%class,%query,%withcolon) ##safeexpression($$QueryColIntoSendODBC^%SYS.DynamicQuery(%class,%query,%withcolon))
#define SQLQueryExpr(%class,%query) ##safeexpression($$QueryColExpr^%SYS.DynamicQuery(%class,%query))
#define SQLQuerySQLInfoItem(%class,%query,%piece,%name) ##safeexpression($$QuerySQLInfoItem^%SYS.DynamicQuery(%class,%query,%piece,%name))
#define SQLQueryInfoItem(%class,%query,%piece,%name) ##safeexpression($$QueryInfoItem^%SYS.DynamicQuery(%class,%query,%piece,%name))
#define SQLQueryOdbcItem(%schema,%proc,%version,%name) ##safeexpression($$QueryOdbcItem^%SYS.DynamicQuery(%schema,%proc,%version,%name))
