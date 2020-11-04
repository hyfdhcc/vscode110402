/// Information about Processes in a Cache instance. 
/// The List() query is used by the SYS.WSMon.Service.EnumProcess() Web method, 
/// to provide a list and details for the most active processes in the instance.
/// The list may be sorted by the recent activity of either CommandsExecuted 
/// (roughly analogous to CPU used) or by GlobalReferences (database activity).
Class SYS.WSMon.wsProcess Extends (SYS.WSMon.wsResource, %SYS.ProcessQuery) [ System = 4 ]
{

/// Returns the top Processes as measured by the recent activity of either
/// CommandsExecuted or GlobalReferences<br><br>
/// Parameters:<br>
/// Sort - sort by "COMMANDS" (default) or "GLOREFS"<br>
/// Number - number of processes to list. Default is 10 and max is 50<br><br>
/// Note that the evaluation of the actual 'top' process list is handled by the
/// Application Monitor (%MONAPP) using the %Monitor.System.Dashboard2 class. This 
/// is 'on' by default and can be managed using the %MONAPPMGR utility. Also, the 
/// counts of CommandsExecuted and GlobalReferences returned are for the latest sample
/// period and not the total for the life of the process. 
Query List(Sort As %String = "COMMANDS", Number As %Integer = 10) As %Query(ROWSPEC = "Process:%Integer,UserName:%String,CurrentDevice:%String,Namespace:%String,Routine:%String,CommandsExecuted:%BigInt,GlobalReferences:%BigInt,State:%String,ClientName:%String,ClientExecutable:%String,ClientIPAddress:%String")
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Sort, Number) As %Status [ Internal ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

}
