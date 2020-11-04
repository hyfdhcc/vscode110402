ROUTINE %occODBC [Type=INC]
#; ODBC/JDBC Stored Procedure constants
  
#define QUOTE                           "
  
#; Stored Procedure Type
 
 
#; ODBC Datatype Names
#define ODBCTYPENAMEunknown             "Unknown"
#define ODBCTYPENAMEbit                 "BIT"
#define ODBCTYPENAMEchar                "Char"
#define ODBCTYPENAMEnumeric             "NUMERIC"
#define ODBCTYPENAMEdecimal             "Decimal"
#define ODBCTYPENAMEinteger             "INTEGER"
#define ODBCTYPENAMEsmallint            "SMALLINT"
#define ODBCTYPENAMEbigint            	"BIGINT"
#define ODBCTYPENAMEtinyint             "TINYINT"
#define ODBCTYPENAMEfloat               "Float"
#define ODBCTYPENAMEreal                "Real"
#define ODBCTYPENAMEdouble              "DOUBLE"
#define ODBCTYPENAMEdate                "DATE"
#define ODBCTYPENAMEtime                "TIME"
#define ODBCTYPENAMEtimestamp           "TIMESTAMP"
#define ODBCTYPENAMEvarchar             "VARCHAR"
#define ODBCTYPENAMElongvarchar         "LONGVARCHAR"
#define ODBCTYPENAMEbinary              "Binary"
#define ODBCTYPENAMEvarbinary           "VARBINARY"
#define ODBCTYPENAMElongvarbinary       "LONGVARBINARY"
#define ODBCTYPENAMEresultset		"RESULTSET"
#define ODBCTYPENAMEstruct		"STRUCT"
#define ODBCTYPENAMEoref		"OREF"
#define ODBCTYPENAMEguid		"GUID"
  
#define ODBCTYPEnames                   ",,BIT,LONGVARBINARY,VARBINARY,LONGVARCHAR,INTEGER,SMALLINT,BIGINT,DOUBLE,NUMERIC,DATE,TIME,TIMESTAMP,TINYINT,VARCHAR,RESULTSET,STRUCT,OREF,GUID,"
  
#; ODBC Datatype Codes
#define ODBCTYPEunknown                 0
#define ODBCTYPEchar                    1
#define ODBCTYPEnumeric                 2
#define ODBCTYPEdecimal                 3
#define ODBCTYPEinteger                 4
#define ODBCTYPEsmallint                5
#define ODBCTYPEfloat                   6
#define ODBCTYPEreal                    7
#define ODBCTYPEdouble                  8
#define ODBCTYPEdate                    9
#define ODBCTYPEtime                   10
#define ODBCTYPEtimestamp              11
#define ODBCTYPEvarchar                12
#define ODBCTYPElongvarchar            -1
#define ODBCTYPEbinary                 -2
#define ODBCTYPEvarbinary              -3
#define ODBCTYPElongvarbinary          -4
#define ODBCTYPEbigint          	   -5
#define ODBCTYPEtinyint                -6
#define ODBCTYPEbit                    -7
#define ODBCTYPEguid                  -11
#define ODBCTYPEresultset				-51
#define ODBCTYPEstruct					2002
  
#; SQL data type codes
#define SQLUNKNOWNTYPE                  0
#define SQLCHAR                         1
#define SQLNUMERIC                      2
#define SQLDECIMAL                      3
#define SQLINTEGER                      4
#define SQLSMALLINT                     5
#define SQLFLOAT                        6
#define SQLREAL                         7
#define SQLDOUBLE                       8
#define SQLDATETIME                     9
#define SQLVARCHAR                     12
#define SQLLONGVARCHAR                 -1
#define SQLBINARY                      -2
#define SQLVARBINARY                   -3
#define SQLLONGVARBINARY               -4
#define SQLTINYINT                     -6
#define SQLBIT                         -7
#define SQLGUID                       -11
  
  
#define SQLNONULLS                      0
#define SQLNULLABLE                     1
#define SQLNULLABLUNKNOWN               2
  
#; Defines for SQLBindParameter and SQLProcedureColumns
#define SQLPARAMTYPEUNKNOWN             0
#define SQLPARAMINPUT                   1
#define SQLPARAMINPUTOUTPUT             2
#define SQLRESULTCOL                    3
#define SQLPARAMOUTPUT                  4
#define SQLRETURNVALUE                  5
  
#; Defines for ODBC/JDBC Errors
#define ODBCERRok                       0
#define ODBCERRprivilege		99
#define ODBCERRatend                    100
#define ODBCERRprocedureexecute         425
#define ODBCERRprocedureprepare         426
#define ODBCERRprocedurenameinvalid     427
#define ODBCERRprocedurenotfound        428
#define ODBCERRparametercount           429
#define ODBCERRprocedurecontextparm     430
  
#; Defines for ODBC/JDBC Procedure state
#define ODBCstate(%ref)                 %odbc(%ref
#define ODBCSTATEall(%ref)              %odbc(%ref)
#define ODBCSTATEhandle(%ref)           $$$ODBCstate(%ref),1)
#define ODBCSTATEfetchcount(%ref)       $$$ODBCstate(%ref),2)
#define ODBCSTATEreturnlist(%ref)       $$$ODBCstate(%ref),3)
  
#define QODBCstate(%ref)                "%odbc(%ref
#define QODBCSTATEall(%ref)             $$$QODBCstate(%ref))"
#define QODBCSTATEhandle(%ref)          $$$QODBCstate(%ref),1)"
#define QODBCSTATEfetchcount(%ref)      $$$QODBCstate(%ref),2)"
#define QODBCSTATEreturnlist(%ref)      $$$QODBCstate(%ref),3)"
  
#define ODBCVARresponsecode             %qscrc
#define ODBCVARrowsprocessed            %qscrpc
  
#define QODBCVARresponsecode            "%qscrc"
#define QODBCVARrowsprocessed           "%qscrpc"
  