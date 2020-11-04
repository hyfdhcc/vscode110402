Class %SYSTEM.WorkMgrIPQ Extends (IPQSet, WorkMgr)
{

Method %OnNew(ByRef qspec As %String, numberjobs As %Integer) As %Status [ Internal, Private, ServerOnly = 1 ]
{
	$$$qualifierParseFull(sc,qspec,qstruct) If $$$ISERR(sc) Quit sc
	For i=$zutil(41)-1:-1:1 Set routine=$piece($zutil(41,i),"^",3) Quit:routine'=""
	If routine'["%SYSTEM.WorkMgr" Quit $$$ERROR($$$GeneralError,"Must create instance through Initialize method")
	Set group=-1
	Do ..Init()
	Set sc=$$CreateWorkers^%SYS.WorkQueueMgr(.qstruct,.group,,.numberjobs,1)
	#; Call DeleteAll on error in case %OnClose is not called for a partially constructed oref
	If $$$ISERR(sc) Do ..DeleteAll() Quit sc
	Merge i%qstruct=qstruct
	Set i%group=group
	Set i%NumWorkers=numberjobs
	Quit sc
}

Method %OnClose() As %Status [ Internal, Private ]
{
	#; Delete the IPQs first to make the workers exit from this task quickly before removing the group
	Do ..DeleteAll()
	Quit $$DeleteGroup^%SYS.WorkQueueMgr(i%group)
}

/// Queues a specific unit of work, you pass the entry point to call in 'work' argument. This can be either '##class(Classname).ClassMethod'
/// or '$$entry^rtn' and it is expected to return a %Status code on completion. If you want to call a function
/// that does not return any value on completion then prepend the class syntax with '=' such as '=##class(Classname).ClassMethod'
/// or for calling a function do not include the '$$' for example 'entry^rtn'.
/// The item being called may also throw exceptions in order to indicate an error happened which is trapped and converted
/// to a %Status value to be returned in the master process.
/// The item called will communicate back to this process by writing to the interprocess queue:
/// <example>
/// ; From worker job put data on the IPQ to send back to the main process
/// Set len=($system.Context.WorkMgr().IPQ).Put(data)
/// </example>
/// The 'data' can be anything wanted as long as it is not "" as this is used as a signal that we have worker status information.
/// Often it will be a $listbuild of some information. The master process reads from the queue with:
/// <example>
/// Set atend=0
/// While 'atend {
/// 	Set data=workqueue.Get(timeout)
/// 	If data="",workqueue.SessionNum'=0 {
/// 		Set sc=workqueue.Decode(,.atend) If $$$ISERR(sc) ; Handle error
/// 	} Else {
/// 		; Process data returned
/// 	}
/// }
/// </example>
/// As can be seen if data="" and this is not a timeout (SessionNum=0) this signals some output from a worker job or an error
/// in the worker job so the <method>Decode</method> must be called to handle this.
/// You can also pass additional
/// arguments including arrays by reference. Note that the size of the data passed in these arguments should be kept
/// relatively small, if there is a large amount of information that needs to be passed then put this in a global.
/// The security context of the caller is also recorded when this function is called so it can be used when the work
/// is executed.
Method Queue(work As %String, args... As %String) As %Status
{
	Quit $$realQueue^%SYS.WorkQueueMgr(i%group,.work,,.args)
}

/// SQL Speicific queue function
Method SQLQueue(rtnidx As %Binary, work As %String, args... As %String) [ Internal ]
{
	Set sc=$$realQueue^%SYS.WorkQueueMgr(i%group,":"_$listbuild(work,rtnidx),,.args)
	If $$$ISERR(sc) {
		Set SQLCODE=$$StatusToSQLCODE^%apiOBJ(sc,.msg)
		Do SQERror^%apiSQL(242,"Parallel query run-time error: -"_SQLCODE_" "_msg)
	}
}

/// This is called when the <var>data</var> received from the IPQ is "" in order to return
/// any error information or output anything to the current device and to take care of 
/// book keeping. It will set <var>AtEnd</var> if we are at the end of the data and will
/// run any callback methods and will return to the caller.
Method Decode(qspec As %String, ByRef AtEnd As %Boolean) As %Status
{
	If '$data(qspec) {
		Merge qstruct=i%qstruct
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,,,i%group,2,.AtEnd)
	} ElseIf $data(qspec)\10 {
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qspec,,,i%group,2,.AtEnd)
	} Else {
		$$$qualifierParseFull(sc,qspec,qstruct) If $$$ISERR(sc) Quit sc
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,,,i%group,2,.AtEnd)
	}
}

/// SQL Specific decode function. Returns true if we are at the end of the work.
/// Not for general use, use the <method>Decode</method> method.
Method SQLDecode() As %Boolean [ Internal ]
{
	Merge qstruct=i%qstruct
	Set sc=$$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,,,i%group,2,.atend)
	If $$$ISERR(sc) {
		Set SQLCODE=$$StatusToSQLCODE^%apiOBJ(sc,.msg)
		Do SQERror^%apiSQL(242,"Parallel query run-time error: -"_SQLCODE_" "_msg)
	}
	Quit atend
}

/// SQL Specific initialize function.
/// Not for general use, use the <method>Initialize</method> method.
ClassMethod SQLInitialize(numberjobs As %Integer) As WorkMgr [ Internal ]
{
	If $get(numberjobs)>0 {
		Set defaultjobs=$$calcJobs^%SYS.WorkQueueMgr()
		If numberjobs>defaultjobs Set numberjobs=defaultjobs
	}
	Set oref=..%New("-d /multicompile=1",.numberjobs)
	If oref=$$$NULLOREF {
		Set sc=$get(%objlasterror)
		If $$$ISERR(sc) {
			Set SQLCODE=$$StatusToSQLCODE^%apiOBJ(sc,.msg)
		} Else {
			Set SQLCODE=-400,msg="Unknown error creating WorkMmgrIPQ class"
		}
		Do SQERror^%apiSQL(242,"Parallel query run-time error: -"_SQLCODE_" "_msg)
	} Else {
		If $data(%ISCSNRemoteTables) {
			Set sc=oref.Setup("##class(%SYSTEM.WorkMgrIPQ).SQLSetup",.%ISCSNRemoteTables)
			If $$$ISOK(sc) Set sc=oref.TearDown("##class(%SYSTEM.WorkMgrIPQ).SQLTearDown")
			If $$$ISERR(sc) {
				Set SQLCODE=$$StatusToSQLCODE^%apiOBJ(sc,.msg)
				Do SQERror^%apiSQL(242,"Parallel query run-time error: -"_SQLCODE_" "_msg)
			}
		}
	}
	Quit oref
}

ClassMethod SQLSetup(args As %String) As %Status [ Internal ]
{
	Kill %ISCSNRemoteTables
	Merge %ISCSNRemoteTables=args
	Quit $$$OK
}

ClassMethod SQLTearDown() As %Status [ Internal ]
{
	Kill %ISCSNRemoteTables
	Quit $$$OK
}

}
