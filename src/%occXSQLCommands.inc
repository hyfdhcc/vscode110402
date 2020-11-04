ROUTINE %occXSQLCommands [Type=INC]
#; %occXSQLCommands.inc -	Macro definitions for common XSQL Tasks

#define TraceOn			d $zu(115,14,1)
#define TraceOff		d $zu(115,14,0)

#define TraceMessage(%message)	if $zu(115,14) { do ##class(%XSQL.Log).logMessage(%message) }

	#; try the %XSQLStatement and handle any thrown exceptions, also dispatch to the exception handler if any error is reported - either a caught exception or an error in %sqlcontext.Error
#; def1arg informixTryCatch(%XSQLStatement)	"try { %XSQLStatement } catch "_$$$SymbolLiteral(%%ISC_XSQLEXCEPTION,p)_" { set %sqlcontext.Error = ##class(%SYSTEM.Error).FromException("_$$$SymbolLiteral(%%ISC_XSQLEXCEPTION,p)_") } if $Isobject(%sqlcontext.Error) { do "_$List($$$top(..exceptionStack),1)_"(."_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_") if '"_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" { quit } elseif "_$$$SymbolLiteral(%%ISC_XSQLRESUMELVAR,p)_" = -1 { goto "_$$$SymbolLiteral(%%ISC_EXIT,l)_" } }"

	#; Catch an SPL (Informix stored procedure language) Exception
#define SPLCatchException(%xsqlException)											set %sqlcontext.Error = ##class(%SYSTEM.Error).FromException(%xsqlException)

	#; Call the SPL Exception Dispatcher with the current exception
#define SPLDispatchException(%xsqlExceptionDispatcher,%xsqlResumeLvar,%xsqlExit)	do %xsqlExceptionDispatcher(.%xsqlResumeLvar) if '%xsqlResumeLvar { quit } elseif %xsqlResumeLvar = -1 { goto %xsqlExit }

	#; Conditionally dispatch to the exception handler if %sqlcontext.Error is an object
#define SPLThrowError(%xsqlExceptionDispatcher,%xsqlResumeLvar,%xsqlExit)			if $Isobject(%sqlcontext.Error) { $$$SPLDispatchException(%xsqlExceptionDispatcher,%xsqlResumeLvar,%xsqlExit) }

	#; Conditionally dispatch to the exception handler if SQLCODE
#define SPLThrowSQLCODE(%xsqlExceptionDispatcher,%xsqlResumeLvar,%xsqlExit)			if 'SQLCODE { set %sqlcontext.Error=$$$NULLOREF } else { set %sqlcontext.Error=##class(%SYSTEM.Error).FromSQLCODE(SQLCODE,$Get(%msg)) $$$SPLDispatchException(%xsqlExceptionDispatcher,%xsqlResumeLvar,%xsqlExit) }

	#; expression to determine if %val is NULL
#define isNull(%val)		(%val="")
	#; this one assumes %val is a $$$SQLSTRING collated value
#define isNullSQLSTRING(%val)	(%val=" ")

#define emptyString $$$SQLEmptyString
#define StringToNumber(%val) $select($$$isNull(%val):"",%val=$c(0):"",1:+%val)
#define StringToInteger(%val) $select($$$isNull(%val):"",%val=$c(0):"",1:%val\1)
#define Spaces(%len) $Justify(" ",%len)
#define SpacePad(%val,%len) $select($$$isNull(%val):"",1:$reverse($justify($reverse(%val),%len)))
#define SpacePadTrunc(%val,%len) $select($$$isNull(%val):"",1:$reverse($justify($reverse($e(%val,1,%len)),%len)))

	#;  Used for subscript expressions on character data to get a substring of the original string
	#;  If the entire value is NULL, return NULL.  Otherwise if the SubString value is "", return the empty string.
#define SubString(%val,%from,%to) $select($get(%val)="":"",$extract(%val,%from,%to)="":$c(0),1:$extract(%val,%from,%to))
#define SubString1(%val,%from) $select($get(%val)="":"",$extract(%val,%from)="":$c(0),1:$extract(%val,%from))