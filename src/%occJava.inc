ROUTINE %occJava [Type=INC]
#; %occJava.INC
#;
#; Constants for anything that deals with Java and Cache'
 
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
 
#define cachePKGdefault         "User"
#define cachePKGsystem          "%Library"

#define javaMaxSupportedVersion	"1.8"
#define javaMinSupportedVersion	"1.7"
#define javaGatewayJAR			"cachegateway.jar"
#define javaJDBCJAR				"cachejdbc.jar"
#define javaGatewayClass		"com.intersys.gateway.JavaGateway"
 
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
#define javaTYPEObjectHandle    "Oref"
 
#define javaTYPEoref            "Oref"
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
 
#define javaTYPErelationshipobject "RelationshipObject"
 
#define javaCLASSint            "Int"
#define javaCLASSlong           "Long"
#define javaCLASSfloat          "Float"
#define javaCLASSdouble         "Double"
#define javaCLASSchar           "Char"
#define javaCLASSbinary         "Byte"
#define javaCLASSboolean        "Boolean"
 
 