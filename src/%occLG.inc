ROUTINE %occLG [Type=INC]
#include %occInclude
 
#define StripQuotes(%s) $$strrep^%occLGUtil($e(%s,2,$l(%s)-1),"""""","""")
 
#define GETCONNFORPK "getConnection"
 
#define MyClassShortName(%class,%genflags) $$MyClassShortName^%occJava5(%class,%genflags,0)
#define MyClassPackageName(%class,%genflags) $$MyClassPackageName^%occJava5(%class,%genflags,0)
#define isSysClass(%class) ($$$ClassPackageName(%class)="%Library")
	#;
#define DisplayOnError(%call) s sc=%call i $$$ISERR(sc) d DisplayError^%apiOBJ(sc)
	#;
#define javaReservedWords "/abstract/default/if/private/this/boolean/do/implements/protected/throw/break/double/import/public/throws/byte/else/instanceof/return/transient/case/extends/int/short/try/catch/final/interface/static/void/char/finally/long/strictfp/volatile/class/float/native/super/while/const/for/new/switch/continue/goto/package/synchronized/null/true/false/"
#define GEN(%c)         s Status=..Output.%WriteNoIndent(%c) q:$$$ISERR(Status) Status
#define GENLN(%c)       s Status=..Output.%WriteLn(%c) q:$$$ISERR(Status) Status 
#define GENB(%c)        s Status=..Output.%Write(%c) q:$$$ISERR(Status) Status
#define GENE(%c)        s Status=..Output.%WriteLnNoIndent(%c) q:$$$ISERR(Status) Status
#define INC s Output=..Output d Output.%IncIndent()
#define DEC s Output=..Output d Output.%DecIndent()      
#define RESETINDENT s Output=..Output d Output.%ResetIndent()
 
#define GENBTRY s Status=..GenBeginTry(Class) i $$$ISERR(Status) q Status
#define GENETRY s Status=..GenEndTry(Class) i $$$ISERR(Status) q Status
#define DGENBTRY s Status=..GenBeginTry(Class) i $$$ISERR(Status) q
#define DGENETRY s Status=..GenEndTry(Class) i $$$ISERR(Status) q
#define GENBTRYM s Status=..GenBeginTryMethod(Class,Method) i $$$ISERR(Status) q Status
#define GENETRYM s Status=..GenEndTryMethod(Class,Method) i $$$ISERR(Status) q Status
#define DGENBTRYM s Status=..GenBeginTryMethod(Class,Method) i $$$ISERR(Status) q
#define DGENETRYM s Status=..GenEndTryMethod(Class,Method) i $$$ISERR(Status) q
 
#define JEI ..JavaExceptionIndentForMethod(Class,Method)
 
#define CPPLANGUAGE 1
#define JAVALANGUAGE 2
	 
#; because of stupid M rules we can't return status within Do 
#define DGEN(%c)         s Status=..Output.%WriteNoIndent(%c) q:$$$ISERR(Status) 
#define DGENLN(%c)       s Status=..Output.%WriteLn(%c) q:$$$ISERR(Status)  
#define DGENB(%c)        s Status=..Output.%Write(%c) q:$$$ISERR(Status) 
#define DGENE(%c)        s Status=..Output.%WriteLnNoIndent(%c) q:$$$ISERR(Status) 
	
#define OGEN(%c)         s Status=OutputFile.%WriteNoIndent(%c) q:$$$ISERR(Status) Status
#define OGENLN(%c)       s Status=OutputFile.%WriteLn(%c) q:$$$ISERR(Status) Status 
#define OGENB(%c)        s Status=OutputFile.%Write(%c) q:$$$ISERR(Status) Status
#define OGENE(%c)        s Status=OutputFile.%WriteLnNoIndent(%c) q:$$$ISERR(Status) Status
#define OINC d OutputFile.%IncIndent()
#define ODEC d OutputFile.%DecIndent()      
#define ORESETINDENT d OutputFile.%ResetIndent()
	 
#define ODGEN(%c)         s Status=OutputFile.%WriteNoIndent(%c) q:$$$ISERR(Status)
#define ODGENLN(%c)       s Status=OutputFile.%WriteLn(%c) q:$$$ISERR(Status)
#define ODGENB(%c)        s Status=OutputFile.%Write(%c) q:$$$ISERR(Status)
#define ODGENE(%c)        s Status=OutputFile.%WriteLnNoIndent(%c) q:$$$ISERR(Status)
	 
#define DO(%x) s Status=%x i $$$ISERR(Status) q Status  
	
#define NOGEN(%c) $$nogen^%occJava5(%c)
#define NOGENMETHOD(%c) ((($$sessionbean^%occJava5(%c)=0)&($$$getClassType(%c)'=$$$cCLASSCLASSTYPEPERSISTENT))!($$$CMP(%c)=1))
#define SESSIONBEAN(%c) $$sessionbean^%occJava5(%c)
#define TRANSACTIONTYPE(%c) $$sessionbeanTransactionType^%occLGUtil(%c)
#define STATEFUL(%c) $$sessionbeanStateful^%occLGUtil(%c)
#define BMP(%c) (($$$getClassType(%c)=$$$cCLASSCLASSTYPEPERSISTENT)&(i%CMP=0))
#define BMPORSESS(%c) ((($$$getClassType(%c)=$$$cCLASSCLASSTYPEPERSISTENT)&(i%CMP=0))!($$$SESSIONBEAN(%c)=1))
#define BMPORDEP(%c) ((($$$getClassType(%c)=$$$cCLASSCLASSTYPEPERSISTENT)&(i%CMP=0))!(($$$SESSIONBEAN(%c)=0)&(i%CMP=0)))
#define CMP(%c) (($$$getClassType(%c)=$$$cCLASSCLASSTYPEPERSISTENT)&(i%CMP=1))
	
#define xxxCACHEiswin32 $$$isWINDOWS
#define xxxOREFTYPE(%t) ($p(%t,"^")#128="4")
#; if a thing is an oref type, it has an element type
#; code^type^collectontype^code^elementtype
#; collectiontype 0 not a collection
#; collectiontype 1 ListOfDataTypes
#; collectiontype 2 ArrayOfDataTypes
#; collectiontype 3 ListOfObjects
#; collectiontype 4 ArrayOfObjects
#define xxxCOLLECTIONTYPE(%t) (+($p(%t,"^",3)))
#define xxxELEMENTTYPE(%t) ($s(($p(%t,"^",4)#128)=4:$p(%t,"^",4)_"^"_$p(%t,"^",5),1:$p(%t,"^",4)))
#define xxxSTREAMTYPE(%t) (($p(%t,"^")#128="12")!($p(%t,"^")#128="13"))
#define xxxOREFCLASS(%t) $p(%t,"^",2)
#define xxxMETHisdt(%m) ($e(%m,2,$l(%m))["%")
#define xxxFLAGdtmethods "m"
	
#define javaGENdefaultext       ".java"
#define javaGENpackage          "COM.intersys"
#define javaGENpkgobjects       $$$javaGENpackage_".objects"
#define javaGENdefaultsysprefix "sys_"
#define javaGENpackageparam     "JAVAPACKAGE"
#define javaGENextendsparam     "JAVAEXTENDS"
#define javaGENclassname        "JAVACLASS"
#define javaGENpropvisibility   "private"
#define javaGENpropprefix       "m_"
#define javaGENgetprefix        "get"
#define javaGENsetprefix        "set"
#define javaGENreservedwords    "/private/static/throws/throw/try/catch/finally/synchronized/abstract/class/for/while/do/if/else/continue/break/switch/case/void/int/float/double/boolean/"
	       
#define cppGENdefaultext       ".cpp"
#define cppGENpackage          "COM.intersys"
#define cppGENpkgobjects       $$$cppGENpackage_".objects"
#define cppGENdefaultsysprefix "sys_"
#define cppGENpackageparam     "CPPPACKAGE"
#define cppGENextendsparam     "CPPEXTENDS"
#define cppGENclassname        "clientname"
#define cppGENpropertyname     "clientname"
#define cppGENmethodname       "clientname"
#define cppGENpropvisibility   "private"
#define cppGENpropprefix       "m_"
#define cppGENgetprefix        "get"
#define cppGENsetprefix        "set"
#; following needs to be corrected, hacked from "Java" list rather than cpp
#define cppGENreservedwords    "/and/and_eq/asm/auto/bitand/bitor/bool/break/case/catch/char/class/compl/const/const_cast/continue/default/delete/do/double/dynamic_cast/else/enum/explicit/export/extern/false/float/for/friend/goto/if/inline/int/long/mutable/namespace/new/not/not_eq/operator/or/or_eq/private/protected/public/register/reinterpret_cast/return/short/signed/sizeof/static/static_cast/struct/switch/template/this/throw/true/try/typedef/typeid/typename/union/unsigned/using/virtual/void/volatile/wchar_t/while/xor/xor_eq/"
	
#define JBIT -7
#define JTINYINT -6
#define JLONGVARBINARY -4
#define JVARBINARY -3
#define JLONGVARCHAR -1
#define JNUMERIC 2
#define JINTEGER 4
#define JLONG -5
#define JSMALLINT 5
#define JDOUBLE 8
#define JVARCHAR 12
#define JDATE 91
#define JTIME 92
#define JTIMESTAMP 93
#define JLIST 500
#define JARRAY 501
#define JLISTREFERENCES 502
#define JARRAYREFERENCES 503
#define JLISTSERIALS 504
#define JARRAYSERIALS 505
#define JCTLISTSERIALS 506
#define JCTARRAYSERIALS 507
#define JCTLISTRELATA 508
#define JSERIAL 509
#define JMANY 510
#define JONE 511
	 
#define EJBDataStore "DataStore"
#define EJBDataSourceJNDISuffix "DB"
#define EJBCacheHost "EJBCACHEHOST"
#define EJBCachePort "EJBCACHEPORT"
#define EJBCacheNameSpace "EJBCACHENAMESPACE"
#define EJBRMIIIOPHost "EJBRMIIIOPHOST"
#define EJBRMIIIOPPort "EJBRMIIIOPPORT"
	
#define cachePKGdefault         "User"
#define cachePKGsystem          "%Library"
	
#define cacheTYPEvoid           "%Library.Void"
#define cacheTYPEint            "%Library.Integer" 
#define cacheTYPEstring         "%Library.String"
#define cacheTYPEregistered     "%Library.RegisteredObject"
#define cacheTYPEserial         "%Library.SerialObject"
#define cacheTYPEpersistent     "%Library.Persistent"
#define cacheTYPElistofdatatypes "%Library.ListOfDataTypes"
#define cacheTYPElistofobjects  "%Library.ListOfObjects"
#define cacheTYPEarrayofdatatypes "%Library.ArrayOfDataTypes"
#define cacheTYPEarrayofobjects  "%Library.ArrayOfObjects"
#define cacheTYPEproplistofdatatypes "%Collection.ListOfDT"
#define cacheTYPEproplistofobjects "%Collection.ListOfObj"
#define cacheTYPEproparrayofdatatypes "%Collection.ArrayOfDT"
#define cacheTYPEproparrayofobjects "%Collection.ArrayOfObj"
#define cacheTYPEsqlproccontext "%Library.SQLProcContext"
#define cacheTYPEbinarystream   "%Library.BinaryStream"
#define cacheTYPEcharstream     "%Library.CharacterStream"
#define cacheTYPErelationshipobject "%Library.RelationshipObject"
#define cacheTYPEnumeric         "%Library.Numeric"
#define cacheTYPEcurrency        "%Library.Currency"
#define cacheTYPEboolean         "%Library.Boolean"
#define cacheTYPEdtlist          "%Library.ListOfDataTypes"
#define cacheTYPEobjlist         "%Library.ListOfObjects"
#define cacheTYPEdtarray         "%Library.ArrayOfDataTypes"
#define cacheTYPEobjarray        "%Library.ArrayOfObjects"
#define cacheTYPEresultset       "%Library.ResultSet"
#define cacheTYPEchar            "%Library.Char"
#define cacheTYPEdate            "%Library.Date"
#define cacheTYPEtime            "%Library.Time"
#define cacheTYPEtimestamp       "%Library.TimeStamp"
#define cacheTYPEdouble          "%Library.Float"
#define cacheTYPEdecimal         "%Library.Decimal"
#define cacheTYPEbinary          "%Library.Binary"
#define cacheTYPElist            "%Library.List"
#define cacheTYPEstatus          "%Library.Status"
#define cacheTYPEbinstream   "%Library.BinaryStream"
	
	 
#define javaATTRisvalid         "isValidInCache"
#define javaATTRsetdirty        "setDirty"
#define javaATTRsetvalid        "setValid"
#define javaATTRsetfetch        "setFetch"
	
#define javaTYPEvoid            "void"
#define javaTYPEint             "int"
#define javaTYPEintmax          2147483647
#define javaTYPEintmin          -2147483648
#define javaTYPElong            "long"
#define javaTYPEfloat           "float"
#define javaTYPEdouble          "double"
#define javaTYPEstring          "String"
#define javaTYPEchar            "char"
#define javaTYPEdate            "Date"
#define javaTYPEtime            "Time"
#define javaTYPEtimestamp       "Timestamp"
#define javaTYPElist            "SysList"
#define javaTYPEbinary          "byte[]"
#define javaTYPEstatus          "Status"
#define javaTYPEbinstream       "BinaryStream"
#define javaTYPEcharstream      "CharacterStream"
#define javaTYPEnumeric         "BigDecimal"
#define javaTYPEcurrency        "BigDecimal"
#define javaTYPEboolean         "boolean"
	       
#define cppTYPEvoid            "void"
#define cppTYPEint             "d_int"
#define cppTYPElong            "long"
#define cppTYPEfloat           "float"
#define cppTYPEdouble          "d_double"
#define cppTYPEstring          "d_string"
#define cppTYPEchar            "char"
#define cppTYPEdate            "d_date"
#define cppTYPEtime            "d_time"
#define cppTYPEtimestamp       "d_timestamp"
#define cppTYPElist            "d_list"
#define cppTYPEbinary          "d_binary"
#define cppTYPEstatus          "d_status"
#define cppTYPEbinstream       "d_bin_stream"
#define cppTYPEcharstream      "d_char_stream"
#define cppTYPEnumeric         "d_double"
#define cppTYPEcurrency        "d_currency"
#define cppTYPEboolean         "d_bool"
#define cppTYPEmvdate          "d_mv_date"
#define cppTYPEdtlist          "sys_Library_ListOfDataTypes"
#define cppTYPEobjlist         "sys_Library_ListOfObjects"
#define cppTYPEdtarray         "sys_Library_ArrayOfDataTypes"
#define cppTYPEobjarray        "sys_Library_ArrayOfObjects"
#define cppTYPEresultset       "sys_Library_ResultSet"
	       
#define javaTYPErelationshipobject "RelationshipObject"
#define cppTYPErelationshipobject "sys_Collection_RelationshipObject"
	       
	
#define sqlTYPEvoid            "Unsupported"
#define sqlTYPEint             "java.sql.Types.INTEGER"
#define sqlTYPEintmax          2147483647
#define sqlTYPEintmin          -2147483648
#define sqlTYPElong            "java.sql.Types.BIGINT"
#define sqlTYPEfloat           "java.sql.Types.REAL"
#define sqlTYPEdouble          "java.sql.Types.DOUBLE"
#define sqlTYPEstring          "java.sql.Types.VARCHAR"
#define sqlTYPEchar            "UnsupportedForNowchar"
#define sqlTYPEdate            "UnsupportedForNowDate"
#define sqlTYPEtime            "UnsupportedForNowTime"
#define sqlTYPEtimestamp       "UnsupportedForNowTimestamp"
#define sqlTYPElist            "UnsupportedForNowSysList"
#define sqlTYPEbinary          "java.sql.Types.VARBINARY"
#define sqlTYPEstatus          "Status"
#define sqlTYPEbinstream       "UnsupportedForNowBinaryStream"
#define sqlTYPEcharstream      "UnsupportedForNowCharacterStream"
#define sqlTYPEnumeric         "UnsupportedForNowBigDecimal"
#define sqlTYPEcurrency        "UnsupportedForNowBigDecimal"
#define sqlTYPEboolean         "UnsupportedForNowboolean"
#define sqlTYPEunsupported      "UnsupportedForNow"
	
#define setTYPEvoid            "Unsupported"
#define setTYPEint             "setInt"
#define setTYPEintmax          2147483647
#define setTYPEintmin          -2147483648
#define setTYPElong            "setLong"
#define setTYPEfloat           "setFloat"
#define setTYPEdouble          "setDouble"
#define setTYPEstring          "setString"
#define setTYPEchar            "UnsupportedForNowchar"
#define setTYPEdate            "setDate"
#define setTYPEtime            "setTime"
#define setTYPEtimestamp       "setTimestamp"
#define setTYPElist            "UnsupportedForNowSysList"
#define setTYPEbinary          "setBytes"
#define setTYPEstatus          "UnsupportedForNowStatus"
#define setTYPEbinstream       "UnsupportedForNowBinaryStream"
#define setTYPEcharstream      "UnsupportedForNowCharacterStream"
#define setTYPEnumeric         "UnsupportedForNowBigDecimal"
#define setTYPEcurrency        "UnsupportedForNowBigDecimal"
#define setTYPEboolean         "setBoolean"
#define setTYPEunsupported      "UnsupportedForNow"
	
#define getTYPEvoid            "Unsupported"
#define getTYPEint             "getInt"
#define getTYPEintmax          2147483647
#define getTYPEintmin          -2147483648
#define getTYPElong            "getLong"
#define getTYPEfloat           "getFloat"
#define getTYPEdouble          "getDouble"
#define getTYPEstring          "getString"
#define getTYPEchar            "UnsupportedForNowchar"
#define getTYPEdate            "getDate"
#define getTYPEtime            "getTime"
#define getTYPEtimestamp       "getTimestamp"
#define getTYPElist            "UnsupportedForNowSysList"
#define getTYPEbinary          "getBytes"
#define getTYPEstatus          "UnsupportedForNowStatus"
#define getTYPEbinstream       "UnsupportedForNowBinaryStream"
#define getTYPEcharstream      "UnsupportedForNowCharacterStream"
#define getTYPEnumeric         "UnsupportedForNowBigDecimal"
#define getTYPEcurrency        "UnsupportedForNowBigDecimal"
#define getTYPEboolean         "getBoolean"
#define getTYPEunsupported      "UnsupportedForNow"
	
#define javaTYPEoref            "Oref"
#define sqlTYPEoref            "UnsupportedForNowOref"
#define setTYPEoref            "UnsupportedForNowOref"
#define getTYPEoref            "UnsupportedForNowOref"
#define javaTYPEoid             "Oid"
#define javaTYPEtransient       "Transient"
#define javaTYPEstatic          "Static"
#define javaTYPEpersistent      "Persistent"
#define javaTYPEsqlproccontext  "SQLProcContext"
#define javaTYPEdtlist          "ListOfDataTypes"
#define javaTYPEobjlist         "ListOfObjects"
#define javaTYPEdtarray         "ArrayOfDataTypes"
#define javaTYPEobjarray        "ArrayOfObjects"
#define javaTYPEresultset       "ResultSet"
	       
#define cppTYPEoref            "Oref"
#define sqlTYPEoref            "UnsupportedForNowOref"
#define setTYPEoref            "UnsupportedForNowOref"
#define getTYPEoref            "UnsupportedForNowOref"
#define cppTYPEoid             "d_oid"
#define cppTYPEtransient       "Transient_t"
#define cppTYPEembedded        "Embedded_t"
#define cppTYPEstatic          "Transient_t"
#define cppTYPEpersistent      "Persistent_t"
#define cppTYPEsqlproccontext  "SQLProcContext"
	        
#define EJBDBOP "_"
#define EJBServer "%Library.EJB"
#define EJBSETSP $$$EJBServer_"_Set"
#define EJBGETSP $$$EJBServer_"_Get"
#define EJBSETSPID $$$EJBServer_"_SetID"
#define EJBGETSPID $$$EJBServer_"_GetID"
#define EJBGETNEXTSP $$$EJBServer_"_GetNext"
#define EJBGETNEXTSPID $$$EJBServer_"_GetNextID"
#define EJBSAVEOREF $$$EJBServer_"_Save"
#define EJBNEWOREFSP $$$EJBServer_"_NewOref"
#define EJBSAVEANDCLOSEOREFSP $$$EJBServer_"_SaveAndCloseOref"
#define EJBCLOSEOREFSP $$$EJBServer_"_CloseOref"
#define EJBLOADOREFSP $$$EJBServer_"_LoadOref"
#define EJBLOADEMBEDDEDOREFSP $$$EJBServer_"_LoadEmbeddedOref"
#define EJBDELETEIDSP $$$EJBServer_"_DeleteId"
 	
#define javaCLASSint            "Int"
#define javaCLASSlong           "Long"
#define javaCLASSfloat          "Float"
#define javaCLASSdouble         "Double"
#define javaCLASSchar           "Char"
#define javaCLASSbinary         "Byte"
#define javaCLASSboolean        "Boolean"
#define refClassValue ""
 
#define CTListOfDataTypes 1
#define CTArrayOfDataTypes 2
#define CTListOfSerials 3
#define CTArrayOfSerials 4
#define CTListOfReferences 5
#define CTArrayOfReferences 6
#define CTListOfRelata 7
#define CTListOfMany 8
#define CTListOfStreams 9
#define CTArrayOfStreams 10
 
#define FLListOfDataTypes 1
#define FLArrayOfDataTypes 2
#define FLListOfSerials 3
#define FLArrayOfSerials 4
#define FLListOfReferences 5
#define FLArrayOfReferences 6
#define FLListOfRelata 7
 
#define LB(%t,%v) d LBVar^%occLGUtil(%t,%v)
 
#define LgSetPropNode(%class,%compiled,%name,%node,%value) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo",%compiled,"properties",%name,%node)=%value
#define LgGetPropNode(%class,%compiled,%name,%node) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo",%compiled,"properties",%name,%node))
#define LgKillProperties(%class,%compiled) k ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo",%compiled,"properties") i $D(^CacheTemp.oddBIND($ZU(5),"debugjava")) s ^CacheTemp("oddBIND",Class,$i(^CacheTemp("oddBIND",Class)))="killing properties in Class "_Class
#define LgNextProp(%class,%compiled,%key) $o(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo",%compiled,"properties",%key))
#define LgGetAllPropNode(%class,%compiled,%node) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo",%compiled,"propertiesAll",%node))
#define LgSetAllPropNode(%class,%compiled,%node,%value) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo",%compiled,"propertiesAll",%node)=%value
 
#define LgSetMethNode(%class,%name,%node,%value) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","methods",%name,%node)=%value
#define LgGetMethNode(%class,%name,%node) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","methods",%name,%node))
#define LgKillMethods(%class) k ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","methods") i $D(^CacheTemp.oddBIND($ZU(5),"debugjava")) s ^CacheTemp("oddBIND",Class,$i(^CacheTemp("oddBIND",Class)))="killing methods in Class "_Class
#define LgNextMeth(%class,%key) $o(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","methods",%key))
#define LgGetAllMethNode(%class,%node) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","methodsAll",%node))
#define LgSetAllMethNode(%class,%node,%value) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","methodsAll",%node)=%value
#define LgSetDependencies(%class,%languagetype,%static,%timestamp,%dep) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","dependencies",%languagetype,%static)=%dep s ^CacheTemp.oddBIND($ZU(5),"bindinfo","dependencies",%class,%languagetype,%static,"timestamp")=%timestamp
#define LgGetDependencies(%class,%languagetype,%static) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","dependencies",%languagetype,%static))
#define LgGetDependciesTimestamp(%class,%languagetype,%static) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","dependencies",%languagetype,%static,"timestamp"))
#define LgKillDependencies(%class,%languagetype,%static) k ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","dependencies",%languagetype,%static) i $D(^CacheTemp.oddBIND($ZU(5),"debugjava")) s ^CacheTemp("oddBIND",Class,$i(^CacheTemp("oddBIND",Class)))="killing dependencies in Class "_Class
 
#define LgSetDependsTimestamp(%class,%languagetype,%static,%ejb,%timestamp) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","dependencies",%languagetype,%static,%ejb,%pojo,"timestamp")=%timestamp
#define LgDepends(%class,%languagetype,%static,%ejb,%pojo) "^CacheTemp.oddBIND("""_$ZU(5)_""","""_%class_""""_"""bindinfo"",""dependencies"","_%languagetype_","_%static_","_%ejb_","_%pojo
#define LgGetDependsTimestamp(%class,%languagetype,%static,%ejb) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","dependencies",%languagetype,%static,%ejb,%pojo,"timestamp"))
 
#define LgSetJavaClassDefTimestamp(%class,%static,%timestamp) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","JavaClassDef",%static,"timestamp")=%timestamp
#define LgGetJavaClassDefTimestamp(%class,%static) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","JavaClassDef",%static,"timestamp"))
#define LgSetJavaClassDefSerialState(%class,%static,%SerialState) s ^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","JavaClassDef",%static,"SerialState")=%SerialState
#define LgGetJavaClassDefSerialState(%class,%static) $g(^CacheTemp.oddBIND($ZU(5),%class,"bindinfo","JavaClassDef",%static,"SerialState"))
 
#define GetCT(%c,%t) $$GetCT^%occLGUtil(%c,%t)
 
#define BINDCOMVERSION 2
 
#define DeepestBaseMethod(%c,%m) $$DeepestBaseMethod^%occLGUtil(%c,%m)
#define DeepestBaseProperty(%c,%p) $$DeepestBaseProperty^%occLGUtil(%c,%m)
 
#define VALIDSTREAM ",com.intersys.classes.AbstractStream,com.intersys.classes.BinaryStream,com.intersys.classes.CharacterStream,com.intersys.classes.FileBinaryStream,com.intersys.classes.FileCharacterStream,com.intersys.classes.GlobalBinaryStream,com.intersys.classes.GlobalCharacterStream,com.intersys.classes.SerialStream,com.intersys.classes.File,"