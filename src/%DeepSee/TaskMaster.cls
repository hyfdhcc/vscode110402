Include (%DeepSee, %syPidtab)

IncludeGenerator (%occUtility, %DeepSee)

///  Utility class that provides an API for managing
///  DeepSee tasks.<br/>
///  This is an internal utility used by DeepSee.
Class %DeepSee.TaskMaster Extends %RegisteredObject [ System = 3 ]
{

///  Name of system used to talk to agents.
Parameter EVENTNAME = "^DeepSee.Tasks.";

///  Timeout value (seconds) for events.
///  If no events are received, then the agent will shut itself down.
Parameter TIMEOUT = 0;

///  If true, maintain archive of processed tasks (for diagnostics).
Parameter USEARCHIVE = 0;

///  Number of items to store in the task master event log.
Parameter LOGSIZE = 100;

///  If true, log additional information (for diagnostics).
Parameter LOGALL = 0;

/// Turn on logging for the DeepSee background agents. These will be reset during a call to <method>%KillLog</method>.
ClassMethod %SetLoggingOptions(pUseArchive = 0, pLogSize = 100, pLogAll = 0)
{
	// Method added by DTB256
	Set $$$DeepSeeAgentLogGLVN("settings","useArchive") = pUseArchive
	Set $$$DeepSeeAgentLogGLVN("settings","logSize") = pLogSize
	Set $$$DeepSeeAgentLogGLVN("settings","logAll") = pLogAll
}

///  Reset the TaskMaster.<br/>
///  This stops all running agents, clears out all tasks, and clears the logs.
ClassMethod %Reset() As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ##class(%DeepSee.TaskMaster).%KillAgents(1)
		If $$$ISERR(tSC) Quit

		Set tSC = ##class(%DeepSee.TaskMaster).%KillLog()
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  This is called from the foreground to 
///  test if the task agents are running.
ClassMethod %IsActive() As %Boolean
{
	Quit ($D($$$DeepSeeAgentsGLVN)=11)&&($System.Event.Defined(..#EVENTNAME_"H"))&&($System.Event.Defined(..#EVENTNAME_"L"))
}

///  This is called from the foreground to 
///  wait for a group of related tasks to complete.<br/>
///  You cannot queue additional tasks to a task group once
///  you have called this method.<br/>
///  If <var>pCompleted</var> is set true if the task group is complete.<br/>
///  If <var>pTimeOut</var> is non-zero, specifies number of seconds to wait.<br/>
ClassMethod %WaitForTaskGroup(pTaskGroup As %String, Output pCompleted As %Boolean, pTimeOut As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		Set pCompleted = 0
		If ('..%IsActive()) {
			Set tSC = $$$ERROR($$$GeneralError,"No active agents to process task group: " _pTaskGroup)
			Do ..%Log("ERROR: No active agents to process task group: "_pTaskGroup)
			Quit
		}

		If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
			Do ..%Log("%WaitForTaskGroup: "_pTaskGroup_" "_$G(%dsCubeName))
		}

		If ('$System.Event.Defined(pTaskGroup)) {
			Set tSC = $$$ERROR($$$GeneralError,"TaskGroup does not have an event queue: " _pTaskGroup)
			Do ..%Log("ERROR: Task group does not have an event queue: "_pTaskGroup_" "_$G(%dsCubeName))
			Quit
		}

		// wait until all tasks for this group have been completed
		Set pCompleted = 1
		Set tAttempts = pTimeOut
		While ($D($$$DeepSeeTaskGroupGLVN(pTaskGroup,"tasks"))) {
			// check for errors-- if any, clear out this group
			If ($G($$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode"))'="") {
				Set pCompleted = 1
				Set tSC = $$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode")
				Quit
			}

			If (pTimeOut > 0) {
				Set tAttempts = tAttempts - 1
				If (tAttempts=0) {
					// timed out
					Set pCompleted = 0
					Quit
				}
			}
			Set tCode = $System.Event.Wait(pTaskGroup,1)
			
			If tCode&&(pTimeOut>0) {
				// DTB304 - Signal has been sent (tcode=1) or the resource has been deleted 
				// rendering signaling unreliable tCode=-1). A timeout has been specified.
				Hang 1
			}
		}

		// the loop may have ended before checking for errors
		If ($$$ISOK(tSC) && ($G($$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode"))'="")) {
			Set pCompleted = 1
			Set tSC = $$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode")
		}

		If (pCompleted) {
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Task group complete: "_pTaskGroup_" "_$G(%dsCubeName))
			}
			
			// delete event and taskgroup info
			Do $System.Event.Delete(pTaskGroup)

			Kill $$$DeepSeeTaskGroupGLVN(pTaskGroup)
		}
		Else {
			// Do ..%Log("Task group timed out: "_pTaskGroup)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  Create a new task group.<br/>
///  A task group is a set of related tasks.
///  If <var>pNotify</var> is true then you will be notified via 
///  an event (named <var>pTaskGroup</var>) when
///  the last task in the group is complete.<br/>
///  <var>pName</var> is an optional label used as part of the
///  group name to track who created the task group.
ClassMethod %CreateTaskGroup(Output pTaskGroup As %String, pNotify As %Boolean = 0, pName As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		// JMD: Do not let event name get longer than 31 chars!
		Set pTaskGroup = "^DeepSee.TG." _ pName _ $I($$$DeepSeeTaskGroupGLVN)
		If (pNotify) {
			Do $System.Event.Create(pTaskGroup)
		}
		Kill $$$DeepSeeTaskGroupGLVN(pTaskGroup)
		If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
			Do ..%Log("Task group created: "_pTaskGroup_" "_$G(%dsCubeName))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  This is called from the foreground to create a set of background agents.
ClassMethod %CreateAgents(pNumAgents As %Integer = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tNewAgentCount = pNumAgents
		// DTB253 - Use JMD1384 logic to avoid over-producing agents
		Set tAgentsNeeded = ##class(%DeepSee.Utils).%GetAgentCount()
		If (tAgentsNeeded="") {
			// set agents equal to 4*cores
			Set tCPU = ##class(%SYSTEM.CPU).%New()
			Set tAgentsNeeded = tCPU.nCores * 4
		}
		#; JMD: we always need at least 2 agents
		Set:tAgentsNeeded<2 tAgentsNeeded = 2
		Set:tAgentsNeeded>128 tAgentsNeeded = 128

		#; Has event queue (High and Low) been defined?
		If '$System.Event.Defined(..#EVENTNAME_"H") {
			Do $System.Event.Create(..#EVENTNAME_"H")
		}
		If '$System.Event.Defined(..#EVENTNAME_"L") {
			Do $System.Event.Create(..#EVENTNAME_"L")
		}

		// JMD1384: hold lock while we are starting up
		Lock +$$$DeepSeeAgentsGLVN:120 
		if '$t { 
			Set tSC = $$$ERROR($$$GeneralError,"Unable to acquire lock for DeepSee Agents in %CreateAgents method")
			Do ..%Log($System.Status.GetErrorText(tSC))
			Quit
		}
		
		// +DTB253 - This was called without any argument, calculate the number needed
		If (tNewAgentCount="") {
			// Count the real number of live agents within the lock. Call in clean mode
			Set tAgentCount = ..%CountLiveAgents(,.tSC,1)
			If $$$ISERR(tSC) Quit
			Set tNewAgentCount = tAgentsNeeded - tAgentCount
		}
		If (tNewAgentCount<=0) {
			// No more agents needed!
			Set tNewAgentCount = 0
		}
		
		If +tNewAgentCount {
			Do ..%Log("Create Background agents..")
			Set tSC=$$StartDeepSeeAgents^%SYS.DeepSee(tNewAgentCount,.tCount)
			Do ..%Log("Background agents created: " _ tCount)
			// give jobs *some* time to start
			// this reduces the chance of another process filling the same request
			Hang 0.1
		}
		// -DTB253
		
		Set ^DeepSee.CurrAgentCount = tAgentsNeeded		// DTB253 - Record the number of agents there are now
		Lock -$$$DeepSeeAgentsGLVN#"I"
		
		If $$$ISERR(tSC) Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Catch(ex) {
		Lock -$$$DeepSeeAgentsGLVN#"I"	// DTB253
		Set tSC = ex.AsStatus()
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  This is called from the foreground to 
///  kill all background agents.
ClassMethod %KillAgents(pPurgeTasks As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		Lock +$$$DeepSeeAgentsGLVN:120
		if '$t { 
			Set tSC = $$$ERROR($$$GeneralError,"Unable to acquire lock for DeepSee Agents in %KillAgents method")
			Do ..%Log($System.Status.GetErrorText(tSC))
			Quit
		}
		Set tAgentId = $O($$$DeepSeeAgentsGLVN(""))
		While (tAgentId'="") {
			// should this be more graceful?, nope, just kill 'em
			// DTB530 - Yes it should! Use the JO2965 tag to make sure the process being targeted
			// for the kill is in fact a DeepSee agent process.
			Set tAgentPid = $LG($$$DeepSeeAgentsGLVN(tAgentId),1)
			If ($$$dsReadProcessType(tAgentPid)=$$$DEEPSEEAGENT) {
				Do $ZU(4,tAgentPid)
			}
			Kill $$$DeepSeeAgentsGLVN(tAgentId)
			Set tAgentId = $O($$$DeepSeeAgentsGLVN(tAgentId))
		}
		Do $System.Event.Delete(..#EVENTNAME_"H")
		Do $System.Event.Delete(..#EVENTNAME_"L")
		Kill $$$DeepSeeAgentsGLVN
		Kill $$$DeepSeeActiveTasksGLVN
		If (pPurgeTasks) {
			Kill $$$DeepSeeTasksGLVN
			Kill $$$DeepSeeTaskGroupGLVN
		}
		Kill ^DeepSee.CurrAgentCount
		Lock -$$$DeepSeeAgentsGLVN#"I"

		Do ..%Log("Background agents killed")
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Lock -$$$DeepSeeAgentsGLVN#"I"
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  Remove all tasks queued for a given task group.
///  This is called when the user cancels a query, for example.
ClassMethod %KillTasksForGroup(pTaskGroup As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tTaskId = $O($$$DeepSeeTasksGLVN(""))
		While (tTaskId'="") {
			Set tDetails = $G($$$DeepSeeTasksGLVN(tTaskId))
			Set tGroup = $LG(tDetails,2)
			If (tGroup = pTaskGroup) {
				Kill $$$DeepSeeTasksGLVN(tTaskId)
			}
			Set tTaskId = $O($$$DeepSeeTasksGLVN(tTaskId))
		}
		Do ..%Log("KillTasksForGroup: "_pTaskGroup)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Lock -$$$DeepSeeAgentsGLVN#"I"
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  This is called from the foreground to 
///  add a task to the queue of background tasks.<br/>
///  <var>pNotify</var>, if not "", indicates that a signal should
///  be sent to this event when the task is complete.<br/>
///  <var>pTaskGroup</var>, if not "", indicates that this
///  task is part of a group of related tasks.<br/>
///  <var>pPriority</var> must be "H" or "L".
ClassMethod %QueueTask(pPriority As %String, pNotify As %String, pTaskGroup As %String, pTaskType As %String, pCubeName As %String, pQueryKey As %String = "", pData As %String = "", pData2 As %String = "", pData3 As %String = "", pSQLParams As %String, pSuppressArchive As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	Try {
		If ((pPriority'="H")&&(pPriority'="L")) {
			Set tSC = $$$ERROR($$$GeneralError,"%QueueTask: priority must be H or L")
			Quit
		}

		If '..%IsActive() {
			Set tSC = $$$ERROR($$$GeneralError,"No agents are active")
			Quit
		}

		Set tTask = $LB(pNotify,pTaskGroup,pTaskType,pCubeName,pQueryKey,pData,pData2,pData3)
		Set tTaskId = $I($$$DeepSeeTasksGLVN)
		If (pTaskGroup'="") {
			If ($G($$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode"))'="") {
				// don't even queue this task
				Set tSC = $$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode")
				Quit
			}

			Set $$$DeepSeeTaskGroupGLVN(pTaskGroup,"tasks",tTaskId) = tTask
			Set x = $I($$$DeepSeeTaskGroupGLVN(pTaskGroup,"count"))
		}
		Set $$$DeepSeeTasksGLVN(tTaskId) = tTask
		Merge:$d(pSQLParams) $$$DeepSeeTasksGLVN(tTaskId,"params") = pSQLParams

		// JMD1047: add foreground context to task
		// Set $$$DeepSeeTasksGLVN(tTaskId,"CTX","NAMESPACE") = $ZU(5)
		If $IsObject($G(%session)) {
			Set $$$DeepSeeTasksGLVN(tTaskId,"CTX","SESSIONID") = %session.SessionId
			Set $$$DeepSeeTasksGLVN(tTaskId,"CTX","LANGUAGE") = %session.Language
		}
		
		// DTB302 - Send flag to suppress archive of this task
		Do $System.Event.Signal(..#EVENTNAME_pPriority,tTaskId_":"_pSuppressArchive)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  This is called when a new agent process is created.
///  (i.e. this is what the JOB command invokes to start a background agent).<br/>
///  <var>pPriority</var> specifies whether to use a "H" (high) priority
///  queue or a "L" low priority queue.
ClassMethod %StartAgent(pAgentId As %String, pPriority As %String) [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set origtype = $$$dsTagDeepSeeAgent		// DTB530 - Tag the current process as a DeepSee Agent
		
		Set $HALT = "Halt"
		New %dsAgentId,%dsTaskId
		Set %dsAgentId = pAgentId
		// Do ..%Log("Agent started:" _ pAgentId)

		// JMD1047 -- provide CSP session to background task if needed
		New %session

		// set priority of this process to LOW
		If (pPriority="L") {
			Do LOW^%PRIO
		}

		// run server init code
		Set tSC = ##class(%DeepSee.Utils).%RunServerInitCode()
		If $$$ISERR(tSC) {
			Do ..%Log("Failure user-defined ServerInit code: " _ $System.Status.GetErrorText(tSC))
			Quit
		}

		Set tMaxErrors = 5000000
		Set tErrorCount = 0
		Set tTaskId = ""
		Set tTimedOut = 0
		While (tErrorCount < tMaxErrors) {
			// JMD1384: check if there are the correct number of agents
			// if start lock is in place, skip this
			Lock +$$$DeepSeeAgentsGLVN#"S":10
			If '$Test Continue
			Lock -$$$DeepSeeAgentsGLVN#"SI"

			Set tAgentsNeeded = ##class(%DeepSee.Utils).%GetAgentCount()	// DTB253 - Use common reference
			// DTB258 - Calculate agents needed in the default case
			If (tAgentsNeeded="") {
				// set agents equal to 4*cores
				Set tCPU = ##class(%SYSTEM.CPU).%New()
				Set tAgentsNeeded = tCPU.nCores * 4
			}
			Set:tAgentsNeeded>16 tAgentsNeeded = 16

			If (tAgentsNeeded) {
				Set tAgentCount = ..%CountLiveAgents("H",.tSC,1)	// DTB253 - Count and clean the agents index
				
				If (tAgentCount < tAgentsNeeded) {
					// this will create extra agents of the other priority!
					Lock +$$$DeepSeeAgentsGLVN:120
					if '$t { 
						Set tSC = $$$ERROR($$$GeneralError,"Unable to acquire lock for DeepSee Agents in %StartAgent method")
						Do ..%Log($System.Status.GetErrorText(tSC))
						Quit
					}
					// compute count *again*; this time within the exclusive lock
					Set tAgentCount = ..%CountLiveAgents("H",.tSC,1)	// DTB253 - Count and clean the agents index
					
					If (tAgentCount < tAgentsNeeded) {
						Set tSC=$$StartDeepSeeAgents^%SYS.DeepSee(tAgentsNeeded-tAgentCount,.tCount)
						If $$$ISOK(tSC) {
							Do ..%Log("Additional agents created: " _ tCount)
						}
						// give jobs *some* time to start
						// this reduces the chance of another process filling the same request
						Hang 1
					}
					Lock -$$$DeepSeeAgentsGLVN#"I"
					If $$$ISERR(tSC) {
						Do ..%Log($System.Status.GetErrorText(tSC))
						Quit
					}
				}
			}

			Set tSC = ..%DequeueTask(pPriority,.tTimedOut,.tNotify,.tTaskGroup,.tTaskId,.tTaskType,.tCubeName,.tQueryKey,.tData,.tData2,.tData3,.tContext,.tSQLParams)
			If (tTimedOut) Quit
			Set %dsTaskId = tTaskId
			If $$$ISERR(tSC) {
				Set tErrorCount = tErrorCount + 1
				Do ..%Log("ERROR dequeing: " _ $System.Status.GetErrorText(tSC))
			}
			
			// JMD1047: apply context
			Kill %session
			If ($G(tContext("SESSIONID"))'="") {
				Set %session = ##class(%CSP.Session).%New(tContext("SESSIONID"),0)
				Set %session.Language = $G(tContext("LANGUAGE"))
				// WAL020
				Set $$$SessionLanguageNode = $G(tContext("LANGUAGE"))
			}

			If ((tTaskGroup'="")&&($G($$$DeepSeeTaskGroupGLVN(tTaskGroup,"errorCode"))'="")) {
				// if there has already been an error in this task group, then do nothing
				If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
					Do ..%Log(tTaskType _ ": " _ "SKIP TASK BECAUSE OF PRIOR ERROR")
				}
				Set tSC = $$$DeepSeeTaskGroupGLVN(tTaskGroup,"errorCode")
			}
			Else {
				Set t1 = $ZH
				Set tSC = ..%ExecuteTask(tTaskGroup,tTaskType,tCubeName,tQueryKey,tData,tData2,tData3,.tSQLParams)
				If $$$ISERR(tSC) {
					Set tErrorCount = tErrorCount + 1
					// error should aready be logged
				}

				If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
					Do ..%Log("POST: "_ tTaskType _ ": " _ ($ZH-t1) _ "s" _ " " _ tCubeName _ ":" _ tQueryKey _ ":" _ tData _ ":" _ tData2 _ " (" _ tErrorCount_")")
				}
			}

			Do RemoveItemFromGroup($G(tNotify),$G(tTaskGroup),tSC)
			Do Notify($G(tNotify))

			// remove task from active list
			Kill $$$DeepSeeActiveTasksGLVN(tTaskId)
		}
		If (tErrorCount >= tMaxErrors) {
			Set tSC = $$$ERROR($$$GeneralError,"Maximum error count exceeded for agent")
			Do RemoveItemFromGroup($G(tNotify),$G(tTaskGroup),tSC)
			Do Notify($G(tNotify))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Do ..%Log($System.Status.GetErrorText(tSC))

		// make sure group does not get hung up
		Do RemoveItemFromGroup($G(tNotify),$G(tTaskGroup),tSC)
		Do Notify($G(tNotify))
	}
	Quit

Halt
	Set $Halt=""
	Kill $$$DeepSeeAgentsGLVN(%dsAgentId)
	Do ..%Log("HALT  PID:"_$J)

	Set tSC = $$$ERROR($$$GeneralError,"Agent halted")
	Do RemoveItemFromGroup($G(tNotify),$G(tTaskGroup),tSC)
	Do Notify($G(tNotify))
	Halt
	Quit

RemoveItemFromGroup(tNotify,tTaskGroup,tSC)
	If (tTaskGroup'="") {
		// remove this item from group
		Kill $$$DeepSeeTaskGroupGLVN(tTaskGroup,"tasks",tTaskId)
		Set x = $I($$$DeepSeeTaskGroupGLVN(tTaskGroup,"complete"))
		If $$$ISERR(tSC) {
			Set x = $I($$$DeepSeeTaskGroupGLVN(tTaskGroup,"error"))
		}
		// no listener, *we* have to check if task group is complete
		If ('tNotify) {
			If ('$D($$$DeepSeeTaskGroupGLVN(tTaskGroup,"tasks"))) {
				If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
					Do ..%Log("Task group complete: "_tTaskGroup)
				}

				// preserve error if present
				Set tTaskSC = $$$OK
				If ($G($$$DeepSeeTaskGroupGLVN(tTaskGroup,"errorCode"))'="") {
					Set tTaskSC = $$$DeepSeeTaskGroupGLVN(tTaskGroup,"errorCode")
				}
				Kill $$$DeepSeeTaskGroupGLVN(tTaskGroup)
				If $$$ISERR(tTaskSC) {
					Set $$$DeepSeeTaskGroupGLVN(tTaskGroup,"errorCode") = tTaskSC
				}
			}
		}
	}
	Quit

Notify(tNotify)
	If (tNotify'="") {
		// + WAL035 -- Protect against race condition
		Try {
			// someone wants to know we finished
			If $System.Event.Defined(tNotify) {
				Do $System.Event.Signal(tNotify)
			}
		}
		Catch(ex) {
			If (ex.Name '= "<UNDEFINED>") {
				Set tSC = ex.AsStatus()
				Do ..%Log($System.Status.GetErrorText(tSC))
			}
		}
		// - WAL035
	}
	Quit
}

///  This is called by agents when they wish to wait on a new task.
ClassMethod %DequeueTask(pPriority As %String, Output pTimedOut As %Boolean, Output pNotify As %String, Output pTaskGroup As %String, Output pTaskId As %String, Output pTaskType As %String, Output pCubeName As %String, Output pQueryKey As %String, Output pData As %String, Output pData2 As %String, Output pData3 As %String, Output pContext, Output pSQLParams) As %Status
{
	Set tSC = $$$OK
	Try {
		// JMD1047
		Kill pContext

		// JMD: reset status
		Set:$G(%dsAgentId)'="" $List($$$DeepSeeAgentsGLVN(%dsAgentId),2) = "READY"

		#; wait for event
		Set tMsg = $System.Event.WaitMsg(..#EVENTNAME_pPriority)
		Set tCode = $LG(tMsg,1)
		If (tCode <= 0) {
			Set pTimedOut = 1
			Do ..%Log("Agent has timed out: "_tCode)
			Quit
		}
		Set pTimedOut = 0
		// DTB302 - Tasks executing an archived task can suppress the archive
		Set pTaskId = $P($LG(tMsg,2),":",1)
		Set tSuppressArchive = $P($LG(tMsg,2),":",2)
		Set tDetails = ""

		#; get details
		Set:pTaskId'="" tDetails = $G($$$DeepSeeTasksGLVN(pTaskId))
		If (tDetails = "") {
			Set tSC = $$$ERROR($$$GeneralError,"No task data found")
			Quit
		}
		Set pNotify = $LG(tDetails,1)
		Set pTaskGroup = $LG(tDetails,2)
		Set pTaskType = $LG(tDetails,3)
		Set pCubeName = $LG(tDetails,4)
		Set pQueryKey = $LG(tDetails,5)
		Set pData = $LG(tDetails,6)
		Set pData2 = $LG(tDetails,7)
		Set pData3 = $LG(tDetails,8)
		Merge pContext = $$$DeepSeeTasksGLVN(pTaskId,"CTX")
		Merge pSQLParams  = $$$DeepSeeTasksGLVN(pTaskId,"params")

		// JMD: show status of working agent
		Set:$G(%dsAgentId)'="" $List($$$DeepSeeAgentsGLVN(%dsAgentId),2) = pTaskType

		If (..#USEARCHIVE)||$G($$$DeepSeeAgentLogGLVN("settings","useArchive"),0)&&'tSuppressArchive {		// DTB302 - Check for archive suppression
			Set ^DeepSee.TaskArchive(pTaskId) = tDetails
		}

		// Mark this as an active task; remove item from queue
		Set $$$DeepSeeActiveTasksGLVN(pTaskId) = $LB($ZDT($ZTS,3,,3),$J) _ tDetails
		Kill $$$DeepSeeTasksGLVN(pTaskId)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
		Do ..%Log($System.Status.GetErrorText(tSC))
	}
	Quit tSC
}

///  This is called by agents in order to execute a given task.
ClassMethod %ExecuteTask(pTaskGroup As %String, pTaskType As %String, pCubeName As %String, pQueryKey As %String, pData As %String, pData2 As %String, pData3 As %String, pSQLParams) As %Status
{
	Set tSC = $$$OK
	Try {
		If (pTaskType = "EXECQUERY") {

			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pQueryKey)
			}

			// clear stats
  			Kill ^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"Cells")
  			Kill ^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"Calcs")

			// re-open query object and calculate cells
			Set tRS = ##class(%DeepSee.ResultSet).%New()
			Set tSC = tRS.%PrepareKey(pCubeName,pQueryKey)
			If $$$ISERR(tSC) Quit

			// JMD: find out if there are available agents for background work
			Set tAgentsAvailable = 0
			Set tSC = ..%CleanAgentsGlobal()		// DTB253 - Clean the agents global
			If $$$ISERR(tSC) Quit
			
			Set k = $O($$$DeepSeeAgentsGLVN(""),1,tAgentInfo)
			While (k'="") {
				If ((k'=$G(%dsAgentId))&&($LG(tAgentInfo,3)="H")&&($LG(tAgentInfo,2)="READY")) {
					Set tAgentsAvailable = 1
					Quit
				}
				Set k = $O($$$DeepSeeAgentsGLVN(k),1,tAgentInfo)
			}

			// make sure execute uses background tasks (if there are agents available)
			Set tQuery = tRS.%GetQuery()
			Set tQuery.useAgents = tAgentsAvailable

			If 'tAgentsAvailable {
				Do ..%Log("Not enough agents: " _ pTaskType _ ":" _ pCubeName)
				// get another agent next time
				// + WAL174 -- only suggest we create more agents if we've lost some -- not just because
				//             the current number wasn't enough
				If (+$G(^DeepSee.CurrAgentCount) < +##class(%DeepSee.Utils).%GetAgentCount()) {
					Set x = $I(^DeepSee.CurrAgentCount)
				}
				// - WAL174
			}

			Set tSC = tRS.%ExecuteCells()
			If $$$ISERR(tSC) Quit

			// update stats
  			Set ^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"Cells") = +$G(tQuery.%Statistics("Cells"))
  			Set ^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"Calcs") = $G(tQuery.%Statistics("Calcs"))
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pQueryKey)
			}
		}
		ElseIf (pTaskType = "EXECAXES") {
			// JMD1156
			Set tMDX = pData
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pQueryKey)
			}

			// JMD1387 ignore concurrency checks when executing axes in the bacckground
			Set %dsForceQuery=1

			// JMD1395 pass filterSpec from foreground along
			Set %dsFilterSpec=pData2

			// re-prepare query object
			Set tRS = ##class(%DeepSee.ResultSet).%New()
			Set tSC = tRS.%PrepareMDX(tMDX)
			If $$$ISERR(tSC) Quit

			If (tRS.%QueryKey="") {
				// if query key is present, then assume parameters are already executed
				Set tSC = tRS.%ExecuteParameters(.tParms)
				If $$$ISERR(tSC) Quit
			}

			Kill %dsForceQuery
			Kill %dsFilterSpec

			// make sure execute uses background tasks
			Set tQuery = tRS.%GetQuery()
			Set tQuery.useAgents = 1
			Set tSC = tRS.%ExecuteAxes()
			// + WAL071 -- Axes only queries must do their own cleanup
			Set tCubeIndex = $$$DeepSeeIndex(tQuery.cube)
			Set tQueryKey = tQuery.%QueryKey
			Set tSC = ##class(%DeepSee.Query.query).%ReleaseReservedAxes(tCubeIndex,tQueryKey)		// DTB168 - Use API
			// - WAL071
			If $$$ISERR(tSC) Quit

			// clear zprocessing
			Kill $$$DeepSeeResultsGLVN($$$UPPER(pCubeName),pQueryKey,"zprocessing")

			// update stats
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pQueryKey)
			}
		}
		ElseIf (pTaskType = "EXECBUCKET") {
			// execute query for one bucket/section
			Set tBucket = pData
			Set tSlotNo = pData2
			Set tSectionList = pData3 // axis:start:end;
			Kill tSections
			If (tSectionList '= "") {
				For i = 1:1:$L(tSectionList,";") {
					Set x = $P(tSectionList,";",i)
					Set a = $P(x,":",1)
					Set tStart = $P(x,":",2)
					Set tEnd = $P(x,":",3)
					Set tSections(a) = $LB(tStart,tEnd)
				}
			}
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pQueryKey _ ":" _ tBucket _ " {" _tSectionList_"}")
			}

			Set tSC = ##class(%DeepSee.Query.Engine).%ExecuteForBucket(pCubeName,pQueryKey,tBucket,tSlotNo,.tSections,,.tStats)
			If $$$ISERR(tSC) Quit

			// update stats
  			Set x = $I(^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"Computes"),+$G(tStats($$$dsqStatCompute)))
  			Set x = $I(^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"CacheHits"),+$G(tStats($$$dsqStatCache)))

			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pQueryKey _ ":" _ tBucket _  " {" _tSectionList_"}")
			}
		}
		ElseIf (pTaskType = "UPDATEFACTS") {
			// update a range of rows within a fact table
			// pData is starting id, pData2 is ending id
			New %dsMissingRef
			Set %dsMissingRef = 0
			Set tExtentHasData = 1		// DTB371 - Assume extent has data at the start
			
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}
			Set tClass = ##class(%DeepSee.Utils).%GetCubeClass(pCubeName,.tSC)
			If $$$ISERR(tSC) Quit
			// Use batch mode
			Set tBatch = 1
			
			// DTB371 - If the startId is 0, check to make sure there is actually data in the table!
			If pData=0 {
				Set tSC = $zobjclassmethod(tClass,"%GetSourceIds",.tExtentStartId)
				Set:tExtentStartId="" tExtentHasData=0
			}

			If (tExtentHasData) {
				// DTB371 - Only call update facts if the extent actually contains source records
				Set tSC = $zobjclassmethod(tClass,"%UpdateFacts",pData,pData2,tBatch,0,pTaskGroup)
			}
			If $$$ISERR(tSC) {
				// JMD1474: ignore
				Set tSC = $$$OK
				Quit
			}
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}
			
			// DTB301
			Set inc=$I(^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"missing"),%dsMissingRef)
		}
		ElseIf (pTaskType = "UPDATEFACTSTEMP") {
			// update a range of rows within a fact table
			// using source ids in a temp file (global)
			// pData is temp file key, pData2 is chunk
			New %dsMissingRef
			Set tExtentHasData=1
			
			// Synchronize will turn off the batch mode, build uses it (the default)
			Set tBatch = '+pData3
			
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2 _ " ("_$S(tBatch:"build",1:"synchronize")_")")
			}
			Set tClass = ##class(%DeepSee.Utils).%GetCubeClass(pCubeName,.tSC)
			If $$$ISERR(tSC) Quit

			// Loop over temp file
			Set tFactCount = 0
			Set tErrorCount = 0
			Set %dsMissingRef = 0
			
			Set tOffset = $O(^CacheTemp.DeepSeeSourceId(pData,pData2,""),1,tSourceId)
			
			// DTB371 - If the startId is 0, check to make sure there is actually data in the table!
			If tSourceId=0 {
				Set tSC = $zobjclassmethod(tClass,"%GetSourceIds",.tExtentStartId)
				Set:tExtentStartId="" tExtentHasData=0
			}
			
			If (tExtentHasData) {
				// DTB371 - Only call update facts if the extent actually contains source records
				While (tOffset'="") {
					Set tSC = $zobjclassmethod(tClass,"%UpdateFacts",tSourceId,,tBatch,0,pTaskGroup)
					
					If $$$ISERR(tSC) {
						Set tErrorCount = tErrorCount+1
						Set tSC = $$$OK		// DTB300 - This does not halt the task
					}
					Set tOffset = $O(^CacheTemp.DeepSeeSourceId(pData,pData2,tOffset),1,tSourceId)
				}
				If $$$ISERR(tSC) Quit
			}

			// DTB300 - Log for reporting
			Set inc=$I(^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"errors"),tErrorCount)
			Set inc=$I(^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"missing"),%dsMissingRef)

			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}
		}
		ElseIf (pTaskType = "BUILDINDICES") {
			// build indices for a range of rows within a fact table
			// pData is starting id, pData2 is ending id
			Set tRangeStartId = pData
			Set tRangeEndId = pData2
			Set tDelta = tRangeEndId - tRangeStartId + 1
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}

			Set tClass = ##class(%DeepSee.Utils).%GetCubeFactClass(pCubeName,.tSC)
			If $$$ISERR(tSC) Quit
			Set tSC = $zobjclassmethod(tClass,"%ConstructIndices",tRangeStartId,tRangeEndId)
			If $$$ISERR(tSC) Quit
  			Set inc=$I(^CacheTemp.DeepSeeUpdate($ZU(5),pTaskGroup,"facts"),tDelta)
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}
		}
		ElseIf (pTaskType = "PRECOMPUTE") {
			// precompute aggregates a range of rows within a fact table
			// pData is starting chunk, pData2 is ending chunk, pData3 is the bucket slot number
			Set tStartChunk = pData
			Set tEndChunk = pData2
			Set tSlotNo = pData3
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("Start " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}

			Set tClass = ##class(%DeepSee.Utils).%GetCubeFactClass(pCubeName,.tSC)
			If $$$ISERR(tSC) Quit

			// construct process private GLVN to hold results
			// We use a global to avoid <STORE> errors and indirection to avoid contention!
			Set tAggGLVN = "^||DeepSee.Agg."_$ZCRC(pCubeName,7)_"."_tSlotNo
			Kill @tAggGLVN
			Set tSC = $zobjclassmethod(tClass,"%PrecomputeAggregates",tStartChunk,tEndChunk,tAggGLVN,,pTaskGroup)
			If $$$ISERR(tSC) {
				Kill @tAggGLVN
				Quit
			}
			Kill $$$DeepSeeCellsGLVN($$$UPPER(pCubeName),tSlotNo)
			Merge $$$DeepSeeCellsGLVN($$$UPPER(pCubeName),tSlotNo) = @tAggGLVN
			Kill @tAggGLVN
			If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
				Do ..%Log("End " _ pTaskType _ ":" _ pCubeName _ ":" _ pData _ "->" _ pData2)
			}
		}
		ElseIf (pTaskType = "JOININDEX") {
			// execute a "bitflip"
			// Cube,RemoteCube,FactNo,Key
			Set tSC = ##class(%DeepSee.Query.Engine).%CreateJoinIndex(pCubeName, pData, pData2,pData3,pQueryKey)
			If $$$ISERR(tSC) Quit
		}
		ElseIf (pTaskType = "COMPUTEKPI") {
			// JMD900
			// compute values for a KPI
			// KPIClass,CacheKey
			Set tSC = $classmethod(pCubeName,"%ComputeKPI",pQueryKey)
			If $$$ISERR(tSC) Quit
		}
		ElseIf (pTaskType = "EXECSQL") {
			// Execute an SQL statement
			Set tSQL = pCubeName
			Set tTempIndex = pQueryKey
			Set tSelectMode = pData
			Set tReadCommitted = pData2
			Set tSC = ##class(%SQL.Agent).%ExecuteQuery(tSQL,tTempIndex,tSelectMode,tReadCommitted)
			If $$$ISERR(tSC) Quit
		}
		ElseIf (pTaskType = "TEST") {
			// Used by %Test method
			Set ^%tmx($I(^%tmx)) = $J _ ":" _ pData
			If pData["6" HALT
			Hang 1
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError,"TaskMaster encountered unknown tasktype: " _pTaskType)
			Quit
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	// Drop any Gateway connections in case queries were run against external tables
	do DropAll^%apiGTW()
	
	// log errors
	If $$$ISERR(tSC) {
		// make note of the error in our task group
		Set:pTaskGroup'="" $$$DeepSeeTaskGroupGLVN(pTaskGroup,"errorCode") = tSC
		Do ..%Log($System.Status.GetErrorText(tSC))
	}

	Quit tSC
}

///  Log a message to the agent log.
ClassMethod %Log(pMsg As %String)
{
	// Log is a ring buffer of size LOGSIZE
	Set tID = $I($$$DeepSeeAgentLogGLVN)
	Set tLogSize = $G($$$DeepSeeAgentLogGLVN("settings","logSize"),..#LOGSIZE)
	Set $$$DeepSeeAgentLogGLVN(tID#tLogSize) = $LB(tID,$ZDT($ZTS,3,,3),+$J,+$G(%dsAgentId),+$G(%dsTaskId),pMsg)

	// also log to log file
	Do ##class(%DeepSee.Utils).%WriteToLog("TaskMaster",pMsg)
}

///  Print contents of the (global-based) agent log to the console.
ClassMethod %PrintLog()
{
	If $D($$$DeepSeeAgentLogGLVN) {
		// log is ring buffer; first build list sorted by time
		Set tID = $O($$$DeepSeeAgentLogGLVN(""),1,tItem)
		While (tID'="") {
			Set tLogID = $LG(tItem,1)
			Set tTime = $LG(tItem,2)
			Set tList(tTime,tID) = tItem
			Set tID = $O($$$DeepSeeAgentLogGLVN(tID),1,tItem)
		}

		// now print out items
		Write "#",?3,"Time",?18,"Agt",?24,"Tsk",?28,"Message",!
		Set n = 0
		Set tTime = $O(tList(""))
		While (tTime'="") {
			Set tID = $O(tList(tTime,""),1,tItem)
			While (tID'="") {
				Set n = n + 1
				Set tAgentId = $LG(tItem,4)
				Set tTaskId = $LG(tItem,5)
				Set:tTaskId=0 tTaskId="-"
				Set tMsg = $LG(tItem,6)
				Write n,?3,$P(tTime," ",2),?17,$J(tAgentId,4),?22,$J(tTaskId,5),?28,tMsg,!
				Set tID = $O(tList(tTime,tID),1,tItem)
			}
			Set tTime = $O(tList(tTime))
		}
	}
	Else {
		Write "No events in log.",!
	}

	// now print out current active tasks & agents
	Do ..%PrintActiveTasks()
	Do ..%PrintPendingTasks()
	Do ..%PrintAgents()
	Do ..%PrintTaskGroups()
}

///  Print current task groups to the console.
ClassMethod %PrintTaskGroups()
{
	If $D($$$DeepSeeTaskGroupGLVN) {
		Set n = 0
		Set tTaskGroup = $O($$$DeepSeeTaskGroupGLVN(""))
		While (tTaskGroup'="") {
			Write:n>0 !,"Current Task Groups:",!
			Set n = n+1
			Set tCount = +$G($$$DeepSeeTaskGroupGLVN(tTaskGroup,"count"))
			Set tComplete = +$G($$$DeepSeeTaskGroupGLVN(tTaskGroup,"complete"))
			Set tErrors = +$G($$$DeepSeeTaskGroupGLVN(tTaskGroup,"error"))
			Set tOpen = tCount - tComplete
			Write:tCount>0 tTaskGroup,?20,$J($FN(tOpen,",",0),7)," open task(s)",?45,$FN(((tComplete/tCount)*100),",",2),"%"
			If (tErrors) {
				Write ?50,tErrors," errors(s)"
			}
			Write !
			Set tTaskGroup = $O($$$DeepSeeTaskGroupGLVN(tTaskGroup))
		}
	}
}

///  Print list of active tasks out to the console.
ClassMethod %PrintActiveTasks()
{
	If $D($$$DeepSeeActiveTasksGLVN) {
		Write !,"Tasks actively being worked on:",!
		Write "#",?4,"Tsk",?11,"Job",?15,"Group",?22,"Time",?47,"Type",!
		Set n = 0
		Set tTaskId = $O($$$DeepSeeActiveTasksGLVN(""),1,tDetails)
		While (tTaskId'="") {
			Set n = n + 1
			Set tTime = $P($LG(tDetails,1)," ",2)
			Set tJob = $LG(tDetails,2)
			Set tGroup = $LG(tDetails,4)
			Set tType = $LG(tDetails,5)
			Write n,?3,$J(tTaskId,4),?10,$J(tJob,4),?15,tGroup,?22,tTime,?47,tType,!
			Set tTaskId = $O($$$DeepSeeActiveTasksGLVN(tTaskId),1,tDetails)
		}
	}
}

/// Print list of pending (queued) tasks out to the console.
ClassMethod %PrintPendingTasks()
{
	If $D($$$DeepSeeTasksGLVN) {
		Set n = 0
		Set tTaskId = $O($$$DeepSeeTasksGLVN(""),1,tDetails)
		While (tTaskId'="") {
			If (n=0) {
				Write !,"Tasks pending in work list:",!
				Write "#",?4,"Type",!
			}
			Set n = n + 1
			Set tType = $LG(tDetails,3)
			Write n,?4,tType,?30,$LG(tDetails,4),!
			Set tTaskId = $O($$$DeepSeeTasksGLVN(tTaskId),1,tDetails)
		}
	}
}

///  Print list of agents out to the console.
ClassMethod %PrintAgents()
{
	If $D($$$DeepSeeAgentsGLVN) {
		Do ..%CleanAgentsGlobal()		// DTB530
		
		Write !,"Active Agents:",!
		Write "#",?6,"Job",?13,"Prio",?20,"State",!
		Set tID = $O($$$DeepSeeAgentsGLVN(""),1,tItem)
		While (tID'="") {
			Set tJob = $LG(tItem,1)
			Set tState = $LG(tItem,2)
			Set tPriority = $LG(tItem,3)
			Write tID,?4,$J(tJob,6),?13,tPriority,?20,tState,!
			Set tID = $O($$$DeepSeeAgentsGLVN(tID),1,tItem)
		}

	}
}

///  Kill the agent log.
ClassMethod %KillLog(pMsg As %String) As %Status
{
	// DTB300 - Preserve the log settings
	If $D($$$DeepSeeAgentLogGLVN("settings")) {
		Merge tLogSettings = $$$DeepSeeAgentLogGLVN("settings")
	}
	Kill $$$DeepSeeAgentLogGLVN
	Merge $$$DeepSeeAgentLogGLVN("settings") = tLogSettings
	
	Kill ^DeepSee.TaskArchive
	Quit $$$OK
}

///  Diagnostic method.
ClassMethod %RunArchivedTask(pTaskId As %Integer, pVerbose As %Boolean = 1) As %Status [ Internal ]
{
	Set tSC = $$$OK

	Try {
		If '(..#USEARCHIVE||$G($$$DeepSeeAgentLogGLVN("settings","useArchive"),0)) {
			Set tSC = $$$ERROR($$$GeneralError,"Task archive not enabled")
			Quit
		}

		#; get details
		Set tDetails = $G(^DeepSee.TaskArchive(pTaskId))
		If (tDetails = "") {
			Set tSC = $$$ERROR($$$GeneralError,"No task data found")
			Quit
		}
		Set tNotify = $LG(tDetails,1)
		Set tTaskGroup = $LG(tDetails,2)
		Set tTaskType = $LG(tDetails,3)
		Set tCubeName = $LG(tDetails,4)
		Set tQueryKey = $LG(tDetails,5)
		Set tData = $LG(tDetails,6)
		Set tData2 = $LG(tDetails,7)
		Set tData3 = $LG(tDetails,8)

		Write:pVerbose "EXECUTE: ",tTaskType,":",tCubeName,":",tData,!
		Set tSC = ..%ExecuteTask(tTaskGroup,tTaskType,tCubeName,tQueryKey,tData,tData2,tData3)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		Do:pVerbose $System.Status.DisplayError(tSC)
	}
	Quit tSC
}

/// Diagnostic method to dispatch an archived task to a DeepSee background agent. Several tasks can be grouped into a single
/// batch of archived tasks by supplying a <var>pTaskGroup</var>. If <var>pSuppressArchive</var> = 1, the re-execution of an
/// archived task will not get archived.
ClassMethod %QueueArchivedTask(pTaskId As %Integer, pTaskGroup As %String = "", pVerbose As %Boolean = 1, pSuppressArchive As %Boolean = 1) As %Status [ Internal ]
{
	/// Method added by DTB302
	Set tSC = $$$OK
	Try {
		If '(..#USEARCHIVE||$G($$$DeepSeeAgentLogGLVN("settings","useArchive"),0)) {
			Set tSC = $$$ERROR($$$GeneralError,"Task archive not enabled")
			Quit
		}
		If '+pTaskId {
			Set tSC = $$$ERROR($$$GeneralError,"Task ID is required to execute archived task")
			Quit
		}

		#; get details
		Set tDetails = $G(^DeepSee.TaskArchive(pTaskId))
		If (tDetails = "") {
			Set tSC = $$$ERROR($$$GeneralError,"No task data found")
			Quit
		}
		
		Set tNotify = $LG(tDetails,1)
		Set tTaskGroup = $G(pTaskGroup,$LG(tDetails,2))
		Set tTaskType = $LG(tDetails,3)
		Set tCubeName = $LG(tDetails,4)
		Set tQueryKey = $LG(tDetails,5)
		Set tData = $LG(tDetails,6)
		Set tData2 = $LG(tDetails,7)
		Set tData3 = $LG(tDetails,8)

		Set tSC = ..%QueueTask("H",tNotify,tTaskGroup,tTaskType,tCubeName,tQueryKey,tData,tData2,tData3,,pSuppressArchive)		
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This is a diagnostic utility which will run a group of tasks from the task archive. Siunce the task archive is a ring buffer,
/// <var>pTaskEndId</var> may be set to 0 to indicate that the method should run to the end of the log. By default the method will 
/// re-queue the entire task archive beginning at position #1 for processing by DeepSee background agents. When using background 
/// processing, if <var>pSuppressArchive</var> = 1, then the re-execution of an archived task will not get archived.
/// <br>
/// The method can be switched to execute each task sequentially in the foreground by setting <var>pAsync</var>=0. 
ClassMethod %RunArchivedTaskGroup(pTaskStartId As %Integer = 1, pTaskEndId As %String = 0, pAsync As %Boolean = 1, pSuppressArchive As %Boolean = 1, pWaitTimeout As %Integer = 30, pVerbose As %Boolean = 1) As %Status [ Internal ]
{
	// Method added by DTB302
	If pTaskEndId=0 {
		Set tTaskEndId = $O(^DeepSee.TaskArchive(""),-1)
	}
	Else {
		Set tTaskEndId = pTaskEndId
	}
	Set tTaskEndId = $O(^DeepSee.TaskArchive(tTaskEndId+1),-1)
	
	Set tMaxTaskCount = tTaskEndId-pTaskStartId		// There could be holes in the list of ID's!
	Set tReportDelta = $Select(tMaxTaskCount<10:1,tMaxTaskCount<100:5,1:50)

	Set tSC = $$$OK
	Try {
		If '(..#USEARCHIVE||$G($$$DeepSeeAgentLogGLVN("settings","useArchive"),0)) {
			Set tSC = $$$ERROR($$$GeneralError,"Task archive not enabled")
			Quit
		}

		// Get the group from first task
		Set tDetails = $G(^DeepSee.TaskArchive(pTaskStartId))
		If (tDetails = "") {
			Set tSC = $$$ERROR($$$GeneralError,"No task data found for archived task "_pTaskStartId)
			Quit
		}
		Set tArchivedGroup = $LG(tDetails,2)
		
		Set tSC = ..%CreateTaskGroup(.tTaskGroup,1,"Archive")
		Write:pVerbose "Task group for archived task execution is " _ tTaskGroup,!
		
		Set tStartTime = $ZH
		
		Set tTaskCount = 0
		Set tTaskId = $O(^DeepSee.TaskArchive(pTaskStartId-1))
		Write:pVerbose ?2,"Begin queueing tasks...",!
		While (tTaskId'="")&&(tTaskId<=tTaskEndId) {
			Set x = $I(tTaskCount)
			
			If pAsync {
				If pVerbose&&'((tTaskCount)#tReportDelta) {
					Write ?2,"Queueing archived task # "_tTaskId,!
				}
				Set tSC = ..%QueueArchivedTask(tTaskId,tTaskGroup)
			}
			Else {
				If pVerbose&&'((tTaskCount)#tReportDelta) {
					Write ?2,"Executing archived task # "_tTaskId,!
				}
				Set tSC =  ..%RunArchivedTask(tTaskId,0)
			}
			
			If $$$ISERR(tSC) $$$ThrowStatus(tSC)
			Set tTaskId = $O(^DeepSee.TaskArchive(tTaskId))
		}
		
		If pAsync {
			If pVerbose {
				Write "Time to queue " _ tTaskCount _ " tasks: " _ ($ZH-tStartTime) _ "s",!
				Write ?2,"Waiting for task group",!
			}
			
			Set tCompleted = 0
			Set tAttempt = 0
			Set tMaxAttempts=5
			While 'tCompleted&&(tAttempt<tMaxAttempts) {
				Set tSC = ..%WaitForTaskGroup(tTaskGroup,.tCompleted,pWaitTimeout)
				If $$$ISERR(tSC) $$$ThrowStatus(tSC)
				
				If ('tCompleted) {
					Set tAttempt = tAttempt + 1
					Write ?2,"Task Group not completed.",!
				}
			}
			
			If 'tCompleted {
				Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Task Group not completed after %1 attempts",tMaxAttempts))
				Quit
			}
			Else {
				Write:pVerbose ?2,"Task group complete",!
			}
		}
		
		Write:pVerbose "Elapsed Time: " _ ($ZH-tStartTime)
	}
	Catch ex {
		If tTaskGroup'="" {
			Do ..%KillTasksForGroup(tTaskGroup)
		}
		Set tSC = ex.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Write:pVerbose "ERROR: " _ $system.Status.GetOneStatusText(tSC),!
	}

	Quit tSC
}

/// Count the number of live agents. If <var>pPriority</var> is ommitted,
/// count only the high priority agents. <var>pPriority</var> can be 
/// either: <br>
/// "H" - count only high priority agents (the default)<br>
/// "L" - count only low priority agents<br>
/// "HL" - count all agents 
ClassMethod %CountLiveAgents(pPriority = "H", Output pStatus, pCleanDeadAgents = 0) As %Integer [ Internal ]
{
	// Method added by DTB253
	Set pStatus = $$$OK
	Set tAgentCount = 0
	Set tPriority = $$$UPPER(pPriority)
	
	Try {
		// DTB258 - Count within a lock subservient to the lock used in %CreateAgents to avoid counting
		// while agents are being created
		Lock +$$$DeepSeeAgentsGLVN("countAgents")#"S":10		// DTB - Use shared lock
		If '$Test {
			Set tSC = $$$ERROR($$$GeneralError,"Cannot acquire lock to count available agents")
			Do ..%Log($System.Status.GetErrorText(tSC))
			Quit
		}
		
		// DTB304 - Merge to a private variable to avoid collisions while counting the contents
		Merge tDeepSeeAgents = $$$DeepSeeAgentsGLVN
		
		// Walk the agents global and check for an active process that matches that PID.
		// Optionally fix the global if the processes are missing.
		Set k = $O(tDeepSeeAgents(""),1,tAgentInfo)
		While (k'="") {
			Set tAgentPid = $LG(tAgentInfo,1)
			Set tAgentPriority = $LG(tAgentInfo,3)
			
			Set tAgentJobType = $$$dsReadProcessType(tAgentPid)		// DTB304 - Directly query the process table for speed. DTB530 - Use new macro to read type.
			
			If (tAgentJobType=$$$DEEPSEEAGENT) { 
				If (tPriority[tAgentPriority) {
					Set tAgentCount = tAgentCount + 1
				}
			}
			Else {
				// Clear the global of any dead agents
				If pCleanDeadAgents {
					Do ..%Log("Agent missing and removed from global: "_tAgentPid)
					// DTB304 - Directly kill the original global entry so other processes won't
					// look for it
					Kill $$$DeepSeeAgentsGLVN(k)
				}
			}

			Set k = $O(tDeepSeeAgents(k),1,tAgentInfo)
		}
		Lock -$$$DeepSeeAgentsGLVN("countAgents")#"SI"		// DTB304 - Release shared lock
	}
	Catch ex {
		Set pStatus = ex.AsStatus()
		Set tAgentCount=-1
		Lock -$$$DeepSeeAgentsGLVN("countAgents")#"SI"		// DTB304 - Release shared lock
	}
	Quit tAgentCount
}

/// Return the number of High priority agents available for background tasks.
ClassMethod %AgentsAvailable(pPriority = "H", Output pStatus) As %Integer
{
	// Method added by DTB256
	Set tAgentCount = 0
	Set pStatus = $$$OK
	Try {	
		If ((pPriority'="H")&&(pPriority'="L")) {
			Set tSC = $$$ERROR($$$GeneralError,"%AgentsAvailable: priority must be H or L")
			Quit
		}
		
		Set tTotalAgents = ..%CountLiveAgents(pPriority,.pStatus,1)
		If $$$ISERR(pStatus) Quit
		
		If tTotalAgents>0 {
			Merge tDeepSeeAgents = $$$DeepSeeAgentsGLVN		// DTB304 - Only reference the global once
			
			Set k = $O(tDeepSeeAgents(""),1,tAgentInfo)
			While (k'="") {
				If (($LG(tAgentInfo,3)=pPriority)&&($LG(tAgentInfo,2)="READY")) {
					Set tAgentCount = tAgentCount+1
				}
				Set k = $O(tDeepSeeAgents(k),1,tAgentInfo)
			}
		}
		Else {
			// DTB258 - Indicate that there were no agents at all
			Set tAgentCount = -1
			Quit	
		}
	}
	Catch ex {
		Set pStatus = ex.AsStatus()
	}
	
	// DTB258 - Log the number of available agents counted
	If (..#LOGALL)||$G($$$DeepSeeAgentLogGLVN("settings","logAll"),0) {
			Do ..%Log("Agents available for background tasks: "_tAgentCount_" "_$G(%dsCubeName))
		}
	
	Quit tAgentCount
}

/// True up the agents global
ClassMethod %CleanAgentsGlobal() As %Status
{
	Set tSC = $$$OK
	Try {
		Do ..%CountLiveAgents("HL",.tSC,1)
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  Perform simple test of DeepSee TaskMaster.
///  This will kill any pending task.
ClassMethod %Test(pClean = 1)
{
	Set tTaskCount = 100

	Do ..%KillAgents(1)

	If '..%IsActive() {
		Kill ^%tmx
		Do ..%KillLog()
		Write "Create agents"
		Do ..%CreateAgents()
		Write !
	}

	Write "Create task group: "
	Set tSC = ..%CreateTaskGroup(.tGroupId,1)	
	If $$$ISERR(tSC) {
		Write !,"Error creating task group:",!
		Do $System.Status.DisplayError(tSC)
		Quit
	}
	Write "'",tGroupId,"'",!

	Write "Create tasks"
	For n=1:1:tTaskCount {
		Set tSC = ..%QueueTask("L",tGroupId, tGroupId, "TEST","","",n*100)
		If $$$ISERR(tSC) Quit
		Write "."
	}
	Write !
	If $$$ISERR(tSC) {
		Write !,"Error queuing task",!
		Do $System.Status.DisplayError(tSC)
		Quit
	}
	Set tAttempt = 0
Wait
	Set tTimeOut = 10
	Write "Waiting for tasks: '",tGroupId,"'"
	Set tSC = ..%WaitForTaskGroup(tGroupId,.tCompleted,tTimeOut)
	If $$$ISERR(tSC) {
		Write !,"Error in WaitForTaskGroup:",!
		Do $System.Status.DisplayError(tSC)
		Quit
	}
	Write !

	If ('tCompleted) {
		Set tAttempt = tAttempt + 1
		Write "Task Group not completed.",!
		Goto:tAttempt<10 Wait
	}

	Write "Task Group completed.",!
	Write "Results: x(task) = JOB:DATA",!
	ZW ^%tmx

	If (pClean) {
		Write "Kill agents..."
		Do ..%KillAgents()
		Write !
	}
}

}
