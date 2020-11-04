Class %TSQL.sys.log Extends %Library.RegisteredObject [ System = 2 ]
{

Property logFile As %String;

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
Method %OnNew(logFile As %CacheString = "", initialize As %Boolean = 0) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set ..logFile = $Select(logFile="":"tsql"_$j_".log",1:logFile)
	if '(##class(%Library.File).Exists(..logFile)) { set newFile = 1 }
	else {
		if 'initialize { set newFile = 0 }
		else {
			do ##class(%Library.File).Delete(logFile)
			set newFile = 1
		}
	}
	open ..logFile:"WAS":0 If '$test Quit $$$ERROR($$$FileCanNotOpen,..logFile)
	if newFile { do ..logHeader() }	else { set currDevice = $IO use ..logFile write !!,"Log restarted: ",$zdt($h),! use currDevice }
	quit $$$OK
}

Method %OnClose() As %Status [ Private ]
{
	if ..logFile '= "" close ..logFile
	Quit $$$OK
}

/// write() - write a message to the current log file
Method write(message As %String(MAXLEN=""), linesBefore As %Integer = 0, linesAfter As %Integer = 1) As %Status
{
	set currDevice = $IO use ..logFile for ptr = 1:1:linesBefore { write ! } write message for ptr = 1:1:linesAfter { write ! }  use currDevice
	quit $$$OK
}

/// <P> Report an error from a %SYSTEM.Error object
/// <P>
/// <UL>
///  <LI><P> error	 - an instance of %SYSTEM.Error
/// </UL>
Method logError(error As %SYSTEM.Error)
{
	set currDevice = $IO
	use ..logFile
	do error.getOdbcError(.sqlcode,.message)
	write $Char(9,9),"ERROR: ",sqlcode," ",message,!
	use currDevice
	quit $$$OK
}

/// <P> Copy the contents of a stream to the log
/// <P>
/// <UL>
///  <LI><P> stream - stream to copy to the file.
/// </UL>
Method logStream(stream As %Stream.Object, pNumbered As %Integer = 0)
{
	set currDevice = $IO
	use ..logFile
	do stream.Rewind()
	set tLine = 0
	while 'stream.AtEnd { do ..write($select('pNumbered:"",1:$Justify($Increment(tLine),4)_". ")_stream.ReadLine()) }
	use currDevice
	quit $$$OK
}

/// <P> Report a status message from a trace
/// <P>
/// <UL>
///  <LI><P> sc - pass as status code
///  <LI><P> message - pass a message to be written both to the current device and to the log (or "") (optional)
///  <LI><P> outcome - pass an array of stats (optional)
/// </UL>
Method logStatus(StatusCode As %Status, Message As %String, ByRef Outcome)
{
	set currDevice = $IO
	use ..logFile
	write "-----",!
	If $Get(Message)'="" {
		write Message,!
	}
	Kill errorlist
	Do DecomposeStatus^%apiOBJ(StatusCode,.errorlist)
	For i=1:1:$Get(errorlist) { write errorlist(i),! }
	If $Data(Outcome)\10 { write "["_##class(%XSQL.Format).Flatten(.Outcome)_"]",! }
	write "-----",!
	use currDevice
	quit $$$OK
}

Method logHeader() As %Status
{
	set currDevice = $IO
	use ..logFile
	write "Cache TSQL Log, created ",$zdt($h)," by process ",$j,!
	write $c(9),"Version: ",$zv,!
	write $c(9),"   User: ",$username,!!
	use currDevice
	quit $$$OK
}

Method logResults(context As %Library.ProcedureContext) As %Status
{
	#dim tException as %Exception.AbstractException
	set tStatus = $$$OK
	try {
		set currDevice = $IO
		use ..logFile
		if context.Error '= $$$NULLOREF { do ..logError(context.Error) }
		if (context.SQLCode) && ( context.SQLCode '= 100) { write $Char(9,9),"SQLCODE = ",context.SQLCode,$Select(context.Message'="":" "_context.Message,1:"") }
		do context.DumpResults()
		use currDevice
	}
	catch tException { set tStatus = tException.AsStatus() }
	quit tStatus
}

ClassMethod startLog(logFile As %CacheString = "", initialize As %Boolean = 0) As %Status
{
	set %tsqlLog = ..%New(.logFile,.initialize)
	quit $$$OK
}

ClassMethod stopLog() As %Status
{
	kill %tsqlLog
	quit $$$OK
}

ClassMethod traceMessage(message As %String(MAXLEN="")) As %Status
{
	if '$Isobject($Get(%tsqlLog)) { do ..startLog() }
	set currDevice = $IO use %tsqlLog.logFile write message,! use currDevice
	quit $$$OK
}

ClassMethod traceDeferredStatement(statementType, sql) As %Status
{
	if '$Isobject($Get(%tsqlLog)) { do ..startLog() }
	set currDevice = $IO
	use %tsqlLog.logFile
	write $justify("PREPARE "_statementType_": ",16),$Select(sql:sql(1),1:sql),!
	if sql { for line = 2:1:sql { write ?16,sql(line),! } }
	use currDevice
	quit $$$OK
}

ClassMethod traceContext(context As %Library.ProcedureContext) As %Status
{
	if '$Isobject($Get(%tsqlLog)) { do ..startLog() }
	set currDevice = $IO
	use %tsqlLog.logFile
	write $c(9),"context object: "_context,!
	write $c(9,9),"",!
	write $c(9,9),"",!
	if '$Isobject(context.Error) { write $c(9,9),"Context status is OK",!! } else { write $c(9,9),"      Error: " do $system.OBJ.DisplayError(context.Error.Status) write !! }
	use currDevice
	quit $$$OK
}

/// <P> Report a status message from a trace
/// <P>
/// <UL>
///  <LI><P> sc - pass as status code
///  <LI><P> message - pass a message to be written both to the current device and to the log (or "") (optional)
///  <LI><P> outcome - pass an array of stats (optional)
/// </UL>
ClassMethod traceStatus(StatusCode As %Status, Message As %String, ByRef Outcome)
{
	if '$Isobject($Get(%tsqlLog)) { do ..startLog() }
	set currDevice = $IO
	use %tsqlLog.logFile
	Do %tsqlLog.logMessage("-----")
	If $Get(Message)'="" {
		Do %tsqlLog.logMessage(Message)
	}
	Kill errorlist
	Do DecomposeStatus^%apiOBJ(StatusCode,.errorlist)
	For i=1:1:$Get(errorlist) {Do %tsqlLog.logMessage(errorlist(i))}
	If $Data(Outcome)\10 {Do %tsqlLog.logMessage("["_##class(%XSQL.Format).Flatten(.Outcome)_"]")}
	Do %tsqlLog.logMessage("-----")
	use currDevice
	quit $$$OK
}

/// <P> Report an error from a %SYSTEM.Error object
/// <P>
/// <UL>
///  <LI><P> error	 - an instance of %SYSTEM.Error
/// </UL>
ClassMethod traceError(pError As %SYSTEM.Error) As %Status
{
	if '$Isobject($Get(%tsqlLog)) { do ..startLog() }
	quit %tsqlLog.logError(.pError)
}

ClassMethod traceResult(pContext As %Library.ProcedureContext) As %Status
{
	if '$Isobject($Get(%tsqlLog)) { do ..startLog() }
	quit %tsqlLog.logResults(.pContext)
}

}
