ROUTINE %occTSQLCompiler [Type=INC]
#; %occTSQLCompiler.inc
#;
#;	Define macros used by the %TSQL.Compiler classes
#;

#;---------------------------------------- 
#; Some useful functions
#;---------------------------------------- 
#;
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
 