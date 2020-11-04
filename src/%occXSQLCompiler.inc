ROUTINE %occXSQLCompiler [Type=INC]
#; %occXSQLCompiler.inc
#;
#;	Define macros used by the %Compiler.[XSQL Migration] classes
#;

	#; DATA TYPE SPEC
	#; 		type priority		- Integer value representing the type precedence for type promotion/demotion used when expressions contain mixed types
	#;		sql category		- lcase normalized SQL Category, supposedly a little more generic than the data type itself
	#;		odbc type name		- ODBC data type name
	#;		operand category	- operand category, used as a more generic type category
	#;		type qualifier 1	- ODBC type qualifier 1, this is often the length or precision
	#;		type qualifier 2	- ODBC type qualifier 2, this is often the scale
	
	#; DTS constructor
#define xsqlDataTypeSpec(%pri,%cat,%type,%opcat,%lit,%qual1,%qual2)	$ListBuild(%pri_":"_%cat,%type,%opcat,%lit,%qual1,%qual2)
	#; DTS constructor that accepts the priority:category as one argument
#define xsqlDataTypeCatSpec(%pricat,%type,%opcat,%lit,%qual1,%qual2)	$ListBuild(%pricat,%type,%opcat,%lit,%qual1,%qual2)
#define xsqlDTStypecat(%descriptor)								$$$ucase($Listget(%descriptor,1,"128:UNKNOWN"))
#define xsqlDTSpriority(%descriptor)							+$$$xsqlDTStypecat(%descriptor)
	// category is just the XSQL type category. The type category represents a standardized type category that merges compatible datatypes into a single type category
	// This value is converted to upper case. Perhaps macros should define those categories! Look at the Informix Datatype Priorities below for a list of categories.
#define xsqlDTScategory(%descriptor)							$$$ucase($Piece($$$xsqlDTStypecat(%descriptor),":",2))
	// CatSpec is the priority:category string, converted to upper case
	// xsqlDTStype is the SQL type specification, CHAR[10] for example.
#define xsqlDTStype(%descriptor)								$Listget(%descriptor,2)
	// opcat is the Operand Category. DTS is often used in the operand stack. This value defines the type of the operand. These categories need to be
	// standardized as well - perhaps a list of opcat macros is needed?
#define xsqlDTSopcat(%descriptor)								$$$ucase($Listget(%descriptor,3))
#define xsqlDTSliteral(%descriptor)								$Listget(%descriptor,4)
#define xsqlDTSqualifier1(%descriptor)							$Listget(%descriptor,5)
#define xsqlDTSqualifier2(%descriptor)							$Listget(%descriptor,6)
	#; Macros for setting DTS properties
#define xsqlDTSSETpriority(%descriptor,%value)					set $List(%descriptor,1) = %value_":"_$$$xsqlDTScategory(%descriptor)
#define xsqlDTSSETcategory(%descriptor,%value)					set $List(%descriptor,1) = $$$xsqlDTSpriority(%descriptor)_":"_$$$ucase(%value)
#define xsqlDTSSETtype(%descriptor,%value)						set $List(%descriptor,2) = %value
#define xsqlDTSSETopcat(%descriptor,%value)						set $List(%descriptor,3) = %value
#define xsqlDTSSETliteral(%descriptor,%value)					set $List(%descriptor,4) = %value
#define xsqlDTSSETqualifier1(%descriptor,%value)				set $List(%descriptor,5) = %value
#define xsqlDTSSETqualifier2(%descriptor,%value)				set $List(%descriptor,6) = %value


	#; try the %XSQLStatement and handle any thrown exceptions, also dispatch to the exception handler if any error is reported - either a caught exception or an error in %sqlcontext.Error
#def1arg informixTryCatch(%XSQLStatement)	"try { %XSQLStatement } catch "_$$$SymbolLiteral(%%ISC_XSQLEXCEPTION,p)_" { set %sqlcontext.Error = ##class(%SYSTEM.Error).fromException("_$$$SymbolLiteral(%%ISC_XSQLEXCEPTION,p)_") } if $Isobject(%sqlcontext.Error) { do "_$List($$$top(..exceptionStack),1)_"(."_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_") if '"_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" { quit } elseif "_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" = -1 { goto "_$$$SymbolLiteral(%%ISC_EXIT,l)_" } }"
	#; The CATCH block with DispatchHandler - catching an exception will instantiate an error object in %sqlcontext.Error and then dispatch to the exception handler
#define informixCatch 						"catch "_$$$SymbolLiteral(%%ISC_XSQLEXCEPTION,p)_" { set %sqlcontext.Error = ##class(%SYSTEM.Error).fromException("_$$$SymbolLiteral(%%ISC_XSQLEXCEPTION,p)_") }"
#; Dispatch to the exception handler conditionally on SQLCODE
#define informixSQLCODEDispatch				"if 'SQLCODE { set %sqlcontext.Error=$$$NULLOREF } else { set %sqlcontext.Error=%sqlcontext.ErrorNewObject(),%sqlcontext.Error.Code=SQLCODE,%sqlcontext.Error.Message=$Get(%msg),%sqlcontext.Error.Status=$$$ERROR($$$SQLCode,SQLCODE,$g(%msg)) do "_$List($$$top(..exceptionStack),1)_"(."_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_") if '"_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" { quit } elseif "_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" = -1 { goto "_$$$SymbolLiteral(%%ISC_EXIT,l)_" } }"
#define informixAddSQLToContext				"if SQLCODE'<0 { set %sqlcontext.Error=$$$NULLOREF,%sqlcontext.RowCount=$Get(%ROWCOUNT) } else { set %sqlcontext.Error=%sqlcontext.ErrorNewObject(),%sqlcontext.Error.Code=SQLCODE,%sqlcontext.Error.Message=$Get(%msg),%sqlcontext.Error.Status=$$$ERROR($$$SQLCode,SQLCODE,$g(%msg)) do "_$List($$$top(..exceptionStack),1)_"(."_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_") if '"_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" { quit } elseif "_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" = -1 { goto "_$$$SymbolLiteral(%%ISC_EXIT,l)_" } }"

	#; Unconditionally dispatch to the exception handler
#define informixDispatchHandler				"do "_$List($$$top(..exceptionStack),1)_"(."_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_") if '"_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" { quit } elseif "_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" = -1 { goto "_$$$SymbolLiteral(%%ISC_EXIT,l)_" }"
	#; Conditionally dispatch to the exception handler if %sqlcontext.Error is an object
#define informixErrorDispatch				"if $Isobject(%sqlcontext.Error) { do "_$List($$$top(..exceptionStack),1)_"(."_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_") if '"_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" { quit } elseif "_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" = -1 { goto "_$$$SymbolLiteral(%%ISC_EXIT,l)_" } }"


	#; This macro encapsulates the tablename resolution for Informix temporary tables and synonyms
	#; THESE EXPRESSIONS ARE SET TO SOMETHING ARBITRARY FOR NOW. Change when a better mechanism is implemented.
#define informixResolveTableName(%XSQLTableName)	"%sqlcontext.ResolveTableName("_$$$informixQuoteString(%XSQLTableName)_")"
#define informixTableIsTemp(%XSQLTableName)			"%sqlcontext.TableIsTemporary("_$$$informixQuoteString(%XSQLTableName)_")"

#define informixQuoteString(%XSQLString)			$zu(144,1,%XSQLString)

#;---------------------------------------- 
#; Some useful functions
#;---------------------------------------- 
#; Operator Precedence for TSQL:
#;	90	
#;	80	* (Multiply), / (Division), % (Modulo)
#;	70	+ (Add), (+ Concatenate), - (Subtract), & (Bitwise AND)
#;	60	=,  >,  <,  >=,  <=,  <>,  !=,  !>,  !< (Comparison operators)
#;	50	^ (Bitwise Exlusive OR), | (Bitwise OR)
#;	40	NOT
#;	30	AND
#;	20	ALL, ANY, BETWEEN, IN, LIKE, OR, SOME
#;	 1	= (Assignment)
#define tsqlOperatorPriority(%operator)		$case(%operator,"*":80,"/":80,"%":80,"+":70,"(+ Concatenate)":70,"-":70,"&":70,"=":60,">":60,"<":60,">=":60,"<=":60,"<>":60,"!=":60,"!>":60,"!<":60,"^":50,"|":50,"NOT":40,"AND":30,"ALL":20, "ANY":20, "BETWEEN":20, "IN":20, "LIKE":20, "OR":20, "SOME":20,:1)
 
	#; UNKNOWN category priority is 128 so that any numeric type will win when promoting types. Type promotion for Cache TSQL is only important during compilation of the TSQL_PLUS operator
	#; Priority <n>9, for example, 129, is used to promote within a specific category. 129 will promote an unknown integer type to the proper integer type based on the expression context
#define tsqlDatatypePriority(%type)			$case(%type,"unknown":129,"sql variant":240,"datetime":230,"timestamp":230,"time":230,"smalldatetime":220,"date":220,"float":210,"real":200,"double":200,"decimal":190,"numeric":190,"money":180,"smallmoney":170,"bigint":160,"int":150,"integer":150,"smallint":140,"tinyint":130,"bit":120,"ntext":110,"text":100,"image":90,"timestamp":80,"uniqueidentifier":70,"nvarchar":60,"nchar":50,"varchar":40,"string":40,"name":40,"char":30,"varbinary":20,"binary":10,:0)
 
#; Operator Precedence for Informix:
#;	90	
#;	80	* (Multiply), / (Division), % (Modulo)
#;	70	+ (Add), (+ Concatenate), - (Subtract), & (Bitwise AND)
#;	60	=,  >,  <,  >=,  <=,  <>,  !=,  !>,  !< (Comparison operators)
#;	50	^ (Bitwise Exlusive OR), | (Bitwise OR)
#;	40	NOT
#;	30	AND
#;	20	ALL, ANY, BETWEEN, IN, LIKE, OR, SOME
#;	 1	= (Assignment)
#define informixOperatorPriority(%operator)		$case(%operator,"*":80,"/":80,"%":80,"+":70,"(+ Concatenate)":70,"-":70,"&":70,"=":60,">":60,"<":60,">=":60,"<=":60,"<>":60,"!=":60,"!>":60,"!<":60,"^":50,"|":50,"NOT":40,"AND":30,"ALL":20, "ANY":20, "BETWEEN":20, "IN":20, "LIKE":20, "OR":20, "SOME":20,:1)
 
	#; UNKNOWN category priority is 128 so that any numeric type will win when promoting types. Type promotion for Cache TSQL is only important during compilation of the TSQL_PLUS operator
	#; Priority <n>9, for example, 129, is used to promote within a specific category. 129 will promote an unknown integer type to the proper integer type based on the expression context
#define informixDatatypePriority(%type)			$case(%type,"unknown":129,"sql variant":240,"datetime":230,"timestamp":230,"time":230,"smalldatetime":220,"date":220,"float":210,"real":200,"double":200,"decimal":190,"numeric":190,"money":180,"smallmoney":170,"bigint":160,"int":150,"integer":150,"smallint":140,"tinyint":130,"bit":120,"ntext":110,"text":100,"image":90,"timestamp":80,"uniqueidentifier":70,"nvarchar":60,"nchar":50,"varchar":40,"string":40,"name":40,"char":30,"varbinary":20,"binary":10,:0)
