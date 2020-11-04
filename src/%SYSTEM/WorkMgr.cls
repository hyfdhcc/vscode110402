/// This class provides an interface to the work queue manager code that allows work to be distributed to multiple
/// processes in order to improve performance. In order to use this you need to divide the work up into units that
/// can be processed independently then you initialize the worker jobs, then queue each unit of work and finally you
/// wait for the work to be completed. The units of work can output to the current device which will be buffered up
/// and output to the main job's device when that unit of work is signalled as complete. Also all units of work by
/// default are expected to return a <class>%Status</class> value so it can indicate errors, these are displayed and
/// returned by the <method>WaitForComplete</method> method.<p>
/// A typical calling sequence is:
/// <example>
/// Set queue=$system.WorkMgr.Initialize("/multicompile=1",.sc) If $$$ISERR(sc) ; Report Error
/// For i=1:1:100 {
/// 	Set sc=queue.Queue("##class(MyClass).ClassMethod",i) If $$$ISERR(sc) ; Report Error
/// }
/// Set sc=queue.WaitForComplete() If $$$ISERR(sc) ; Report Error
/// </example>
/// The call to <method>Initialize</method> will allocate some worker jobs from the pool to the work group you are
/// creating, if there are not enough worker jobs in the pool then a daemon process will start additional worker
/// automatically. The number of worker jobs we start determined by the work queue manager based on current machine
/// load and characteristics of the CPU the machine is running on. If '/multicompile=0' then we will not use any worker
/// jobs at all and will do all the processing in the current job in the <method>WaitForComplete</method> call.<p>
/// Then you call <method>Queue</method> to queue a unit of work to be completed, this takes either a class method
/// call, or a '$$func^rtn' reference and then any arguments you need to pass to this function. As soon as the
/// first <method>Queue</method> is called a worker will start processing this item of work. It is important to make
/// sure that all the units of work are totally independent and they do not rely on other work units. You can not
/// rely on the order in which the units of work are processed. If the units may be changing a common global you
/// will need to add locking to ensure one worker can not change a global while another worker is in the middle of
/// reading this global. When a unit of work is queued the current security context is stored so when the work
/// is run it will use the current security context. Note that the worker jobs are started by the super server
/// and so will run as the operating system user that the super server process is setup to use, this may be different
/// to your current logged in operating system user.<p>
/// Finally you call <method>WaitForComplete</method> to wait for all the units of work to be complete, display any
/// output each unit produced and report any errors reported from the work units. The <method>WaitForComplete</method>
/// will use the qualifiers provided in the <method>Initialize</method>.<p>
/// Worker jobs are owned by the master process while they are performing work in this group, so when the master exits
/// the worker jobs will be released immediately. When the object returned by Initialize is destroyed this will remove all work associated
/// with this group automatically, and release any workers.<p>
/// Note that the work queued should not use exclusive news, kills or unlocks as this will interfere with the framework.
/// Also if you use process private globals to store data during the processing note that as multiple Cache jobs will
/// be processing each chunk you can not rely on accessing these from the master process (or even from another chunk).
/// The size of each chunk should be on the order of thousands of lines of COS code to ensure the overhead of the framework is
/// not a significant factor, also rather than a few very large chunks (e.g. 4 big chunks) if possible it is better
/// to have a fairly large number (100 say) of chunks as this allows us to scale with CPU cores. Worker jobs once started
/// will remain until they time out given a long enough period of inactivity.
Class %SYSTEM.WorkMgr Extends %SystemBase
{

Method %OnNew(ByRef qspec As %String, numberjobs As %Integer) As %Status [ Internal, Private, ServerOnly = 1 ]
{
	$$$qualifierParseFull(sc,qspec,qstruct) If $$$ISERR(sc) Quit sc
	Set group=-1
	Set sc=$$CreateWorkers^%SYS.WorkQueueMgr(.qstruct,.group,,.numberjobs)
	If $$$ISERR(sc) Quit sc
	Merge i%qstruct=qstruct
	Set i%group=group
	Set i%NumWorkers=numberjobs
	Quit $$$OK
}

Method %OnClose() As %Status [ Internal, Private ]
{
	Quit $$DeleteGroup^%SYS.WorkQueueMgr(i%group)
}

/// Copy of qualifiers passed on initialize.
Property qstruct As %String [ Internal, MultiDimensional, Private ];

/// Group assocaited with this work.
Property group As %Integer [ Internal, Private ];

/// After the work group is created the number of workers allocated to this group.
Property NumWorkers As %Integer;

/// Initialize the worker jobs so they are ready to start accepting work items. In the qspec that is passed
/// you can determine if you want output with the 'd' flag and if you wish to disable multiple jobs and process
/// the work in this master process with '/multicompile=0'. This returns an instance of the worker queue manager
/// which you can then queue work against. If you wish to specify how many workers you require then pass
/// the <var>numberjobs</var> equal to the number you require. You may also pass the number in the
/// /multicompile=NUM as long as NUM is greater than 1 or for 1 worker specify '-1' i.e. /multicompile=-1.
ClassMethod Initialize(qspec As %String = "", ByRef sc As %Status, numberjobs As %Integer) As WorkMgr
{
	Set oref=..%New(.qspec,.numberjobs)
	If oref=$$$NULLOREF { Set sc=$get(%objlasterror) } Else { Set sc=$$$OK }
	Quit oref
}

/// Queues a specific unit of work, you pass the entry point to call in 'work' argument. This can be either '##class(Classname).ClassMethod'
/// or '$$entry^rtn' and it is expected to return a %Status code on completion. If you want to call a function
/// that does not return any value on completion then prepend the class syntax with '=' such as '=##class(Classname).ClassMethod'
/// or for calling a function do not include the '$$' for example 'entry^rtn'.
/// The item being called may also throw exceptions in order to indicate an error happened which is trapped and converted
/// to a %Status value to be returned in the master process. You can also pass additional
/// arguments including arrays by reference. Note that the size of the data passed in these arguments should be kept
/// relatively small, if there is a large amount of information that needs to be passed then put this in a global.
/// The security context of the caller is also recorded when this function is called so it can be used when the work
/// is executed.
Method Queue(work As %String, args... As %String) As %Status
{
	Quit $$realQueue^%SYS.WorkQueueMgr(i%group,.work,,.args)
}

/// Similar to <method>Queue</method> except you can also pass in a 'callback' which is a function or class method that
/// is called in the master process when this unit of work is complete. This function is called with the same arguments
/// the original 'work' is called with so it knows which unit of work is complete. Also the callback function can access
/// the '%job' public variable which is the $job of the process which really did the work.
/// If using the <method>Wait</method> to wait for the work to be completed the callback can signal that it should
/// return to the caller rather than waiting for more events by setting the public variable '%exit' to 1.
Method QueueCallback(work As %String, callback As %String, args... As %String) As %Status
{
	Quit $$realQueue^%SYS.WorkQueueMgr(i%group,.work,.callback,.args)
}

/// Internal method, not for customer use.
Method QueueLocalEntry(rtnidx As %Binary, func As %String, args... As %String) As %Status [ Internal ]
{
	Quit $$realQueue^%SYS.WorkQueueMgr(i%group,":"_$listbuild(func,rtnidx),,.args)
}

/// If this queue needs some setup work before we process the first item in this queue or if switching from processing
/// items in another queue to one in this queue then specify the function to call here. The arguments are the same
/// as for <method>Queue</method>. This must be called before you queue work.
Method Setup(work As %String, args... As %String) As %Status
{
	Quit $$realQueue^%SYS.WorkQueueMgr("0:"_i%group,.work,,.args)
}

/// If this queue needs some work done to restore a process to the previous state before we process the first item
/// in another queue when switching from processing items in this queue then specify the function to call here.
/// The arguments are the same as for <method>Queue</method>. This must be called before you queue work.
Method TearDown(work As %String, args... As %String) As %Status
{
	Quit $$realQueue^%SYS.WorkQueueMgr("1:"_i%group,.work,,.args)
}

/// After work has been queued this will wait for all the workers to complete. It will display any output the work
/// writes to the current device and it will also combine all the %Status codes that the units of work report and
/// return this combined %Status. If there are no workers then this will execute all the work in this main job
/// during this phase. When this returns all the work queued up to this point has been completed. Also this is the
/// phase that will run the <method>QueueCallback</method> callbacks as the workers jobs report that various
/// units are complete.
Method WaitForComplete(qspec As %String, errorlog As %String) As %Status
{
	If '$data(qspec) {
		Merge qstruct=i%qstruct
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,.errorlog,,i%group)
	} ElseIf $data(qspec)\10 {
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qspec,.errorlog,,i%group)
	} Else {
		$$$qualifierParseFull(sc,qspec,qstruct) If $$$ISERR(sc) Quit sc
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,.errorlog,,i%group)
	}
}

/// After work has been queued this will wait for a signal from a callback to exit back to the caller.
/// This is done by in the callback queued with <method>QueueCallback</method> setting the public
/// variable '%exit' to 1. This method returns <var>AtEnd</var> to show if all the work is complete or
/// if there are still items outstanding.
Method Wait(qspec As %String, ByRef AtEnd As %Boolean) As %Status
{
	If '$data(qspec) {
		Merge qstruct=i%qstruct
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,,,i%group,1,.AtEnd)
	} ElseIf $data(qspec)\10 {
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qspec,,,i%group,1,.AtEnd)
	} Else {
		$$$qualifierParseFull(sc,qspec,qstruct) If $$$ISERR(sc) Quit sc
		Quit $$WaitForComplete^%SYS.WorkQueueMgr(.qstruct,,,i%group,1,.AtEnd)
	}
}

/// Clear any existing work from this work queue, it does this by removing the queue and creating a new one.
/// The <var>timeout</var> is not used.
Method Clear(timeout As %Integer = 0) As %Status
{
	Set sc=$$DeleteGroup^%SYS.WorkQueueMgr(i%group)
	If $$$ISERR(sc) Quit sc
	Merge qstruct=i%qstruct
	Set group=-1
	Set sc=$$CreateWorkers^%SYS.WorkQueueMgr(.qstruct,.group)
	If $$$ISERR(sc) Quit sc
	Set i%group=group
	Quit $$$OK
}

/// Pause any work in this work queue, this stops any workers from picking up additional items from
/// this specific queue, but leaves the work itself so you can call <method>Resume</method>.
Method Pause() As %Status
{
	Quit $$PauseGroup^%SYS.WorkQueueMgr(i%group)
}

/// Free any workers associated with this group to put them back into general pool.
/// You can do this after you have queued all the work.
Method Free() As %Status
{
	Quit $$FreeGroup^%SYS.WorkQueueMgr(i%group)
}

/// Resume any work in this work queue which was paused with a call to <method>Pause</method>.
Method Resume() As %Status
{
	Quit $$ResumeGroup^%SYS.WorkQueueMgr(i%group)
}

/// Deprecated method
ClassMethod SignalAll(work As %String) As %Status [ Internal ]
{
	Quit $$$ERROR($$$MethodNotImplemented,"%SYSTEM.WorkMgr:SignalAll")
}

/// Deprecated method
ClassMethod StopWorkers(timeout As %Integer = 5) As %Status [ Internal ]
{
	Quit $$$OK
}

/// After the <method>Initialize</method> is called this will return the current number of worker jobs that are active for this group.
Method NumberWorkers() As %Integer
{
	Quit $$NumWorkerJobs^%SYS.WorkQueueMgr(i%group)
}

/// Called from a worker job to flush any output produced so far to the master process.
/// Without this all output from a worker job is buffered until this unit of work is complete and only
/// then is it displayed in the master process.
ClassMethod Flush() As %Status
{
	Quit $$Flush^%SYS.WorkQueueMgr()
}

/// Return the default number of worker jobs we will use if no specific number is specified
ClassMethod DefaultNumWorkers() As %Integer
{
	Quit $$calcJobs^%SYS.WorkQueueMgr()
}

/// If you do not pass in any arguments returns true/false based on if the current process
/// is a worker job or not.
ClassMethod IsWorkerJob() As %Boolean
{
	Quit $zutil(67,10,$job)=$$$WORKQUEUESRV
}

/// Write out a list of the methods of this object to the console.
/// Pass the method name as an argument to see the full description for
/// this item.
ClassMethod Help(method As %String = "") As %String
{
	If method="" {
		Set class=##class(%Dictionary.CompiledClass).%OpenId($classname())
		If class=$$$NULLOREF Write "Internal error",! Quit
		
		Write "'Do "_$replace($classname(),"%SYSTEM.","$system.")_".Help(method)' "_$$$GetSimpleMessage("%Compiler","OBJHelp"),!!
		Write $$$GetSimpleMessage("%Compiler","OBJMethodList")_$classname(),!
		For index=1:1:class.Methods.Count() {
			Set method=class.Methods.GetAt(index)
			If $extract(method.Name)="%" Continue
			Set description=method.Description
			If description'="",method.Private'=1,'method.Internal {
				Set spec=method.FormalSpec
				Set s=""
				For a=1:1:$L(spec,",")  Set s=s_$S(s="":"",1:",")_$P($P(spec,",",a),":")
				Write !,method.Name,"(",s,")",!
				Write ?5,$zconvert($piece(description,$char(13)),"I","HTML"),!
			}
		}
	} Else {
		Write $$$GetSimpleMessage("%Compiler","OBJMethodDesc")_method_":"_$classname(),!
		Set obj=##class(%Dictionary.CompiledMethod).%OpenId($classname()_"||"_method)
		If obj=$$$NULLOREF||(obj.Internal) {
			Write !,"'"_method_"'"_$$$GetSimpleMessage("%Compiler","OBJMethodNotExist"),!
		} Else {
			Write !,method,"(",obj.FormalSpec,")",!
			Write $zconvert(obj.Description,"I","HTML"),!
		}
	}
}

}
