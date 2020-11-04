ROUTINE %occXSQLTRACE [Type=INC]
/// IconSystems - Icon.CT.Macros
/// Module: Concepto Total (CT)
/// Description: Define general purpose macros for tracing, error handling, etc.

#define TRACEON						$zu(115,14)
#define TRACECLASS					##class(%XSQL.Log)
#define SETTRACE(%value)			$zu(115,14,%value)
#define TRACETIMESTAMP				$zdatetime($zts,,,3)," "


#if $zu(115,14)

/// <P> Trace a context object (statement result object returned by a CALL statement)
/// <P>
/// <UL>
///  <LI><P> %context	- the procedure context object to trace
/// </UL>
#define TRACECONTEXT(%context)						do:$$$TRACEON $$$TRACECLASS.traceContext(%context)


/// <P> Trace a deferred mode embedded SQL statement
/// <P>
/// <UL>
///  <LI><P> %type		- the staement type code (1 = SELECT, and so on)
///  <LI><P> %sql		- the SQL statement source
///  <LI><P> %args		- an array of the statement arguments
/// </UL>
#define TRACEDEFERREDSTATEMENT(%type,%sql,%args)	do:$$$TRACEON $$$TRACECLASS.traceDeferredStatement(%type,.%sql,.%args)

/// <P> Report a execution of embedded/deferred SQL, its arguments, and status.
/// <P>
/// <UL>
///  <LI><P> %statement	- the text of the SQL Statement executed
///  <LI><P> %sqlcode	- the resulting SQLCODE
///  <LI><P> %msg		- the resuting %msg (if any)
///  <LI><P> %rowcount	- the resulting %ROWCOUNT (if any)
///  <LI><P> %time		- the execution time (if any)
///  <LI><P> %arguments	- the Arguments and their values
/// </UL>
#def1Arg TRACEEMBEDDEDSQL(%arguments)				do:$$$TRACEON $$$TRACECLASS.traceEmbeddedSQL(%arguments)

/// <P> Report a function call and its arguments. This trace does not bump the call paths, otherwise it is the same as TRACEENTERPROC.
/// <P>
/// <UL>
///  <LI><P> %procedure	- the name of the procedure executed
///  <LI><P> %arguments	- the Arguments and their values in $Listbuild format, one list for each value to trace
/// </UL>
#def1Arg TRACEENTERFUNC(%arguments)	do:$$$TRACEON $$$TRACECLASS.traceEnterFunction(%arguments)

/// <P> Report a procedure call and its arguments
/// <P>
/// <UL>
///  <LI><P> %procedure	- the name of the procedure executed
///  <LI><P> %arguments	- the Arguments and their values in $Listbuild format, one list for each value to trace
/// </UL>
#def1Arg TRACEENTERPROC(%arguments)					do:$$$TRACEON $$$TRACECLASS.traceEnterProcedure(%arguments)

/// <P> Report an error from a %SYSTEM.Error object
/// <P>
/// <UL>
///  <LI><P> %error	 - an instance of %SYSTEM.Error
/// </UL>
#define TRACEERROR(%error)							do:$$$TRACEON $$$TRACECLASS.traceError(%error)

/// <P> Report an exception from a trace
/// <P>
/// <UL>
///  <LI><P> pException - pass as an exception oref
///  <LI><P> pOutcome - pass an array of messages to be logged (optional)
/// </UL>
#define TRACEEXCEPTION(%exception)					do:$$$TRACEON $$$TRACECLASS.traceException(%exception)

/// <P> Report that a a procedure is returning to the caller. This only pops the logged call stack. To report the
/// status of the procedure use TRACECONTEXT.
#define TRACEEXITPROC								do:$$$TRACEON $$$TRACECLASS.traceExitProcedure()

/// <P> Report a function and its return value.
/// <P>
/// <UL>
///  <LI><P> %name	 - the name of the function method
///  <LI><P> %value	 - the return value
/// </UL>
#define TRACEFUNCTION(%name,%value)					do:$$$TRACEON $$$TRACECLASS.traceFunction(%name,%value)

/// <P> Trace a literal message
/// <P>
/// <UL>
///  <LI><P> %message	- message to be written to the log (or "") (optional)
/// </UL>
#define TRACEMESSAGE(%message)						do:$$$TRACEON $$$TRACECLASS.traceMessage(%message)

#define TRACERESULT(%context)						do:$$$TRACEON $$$TRACECLASS.traceResult(%context)

#define TRACERESULTSET(%context,%result)			do:$$$TRACEON $$$TRACECLASS.traceResultSet(%context,%result)

/// <P>Log an SQLCODE and %msg value</P>
/// <P>
/// <UL>
/// <LI><P>pSQLCODE	- the SQLCODE value</P>
///	<LI><P>pMessage	- the %msg value</P>
/// </UL>
/// </P>
#define TRACESQLCODE(%sqlcode,%message)				do:$$$TRACEON $$$TRACECLASS.traceSQLCODE(%sqlcode,%message)

/// <P> Report a status message from a trace
/// <P>
/// <UL>
///  <LI><P> %status - pass as status code
///  <LI><P> %message - pass a message to be written both to the current device and to the log (or "") (optional)
///  <LI><P> %outcome - pass an array of stats (optional)
/// </UL>
#define TRACESTATUS(%status,%message)				do:$$$TRACEON $$$TRACECLASS.traceStatus(%status,%message)

/// <P> Report a named value
/// <P>
/// <UL>
///  <LI><P> %name	 - the name of the value, for example, 'pFormal1' as the name of a formal argument
///  <LI><P> %value	 - the value
/// </UL>
#define TRACEVALUE(%name,%value)					do:$$$TRACEON $$$TRACECLASS.traceValue(%name,%value)

#else

#define TRACECONTEXT(%context)
#define TRACEDEFERREDSTATEMENT(%type,%sql,%args)
#def1Arg TRACEEMBEDDEDSQL(%arguments)
#def1Arg TRACEENTERPROC(%arguments)
#define TRACEERROR(%error)
#define TRACEEXCEPTION(%exception)
#define TRACEEXITPROC
#define TRACEFUNCTION(%name,%value)
#define TRACEMESSAGE(%message)
#define TRACERESULT(%context)
#define TRACERESULTSET(%context,%result)
#define TRACESQLCODE(%sqlcode,%message)
#define TRACESTATUS(%status,%message)
#define TRACEVALUE(%name,%value)

#endif