Class %DeepSee.CubeManager.Task.Build Extends %SYS.Task.Definition [ System = 4 ]
{

Parameter TaskName = "Cube Manager Build";

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
/// In order to execute a real task, override this method in a subclass.
Method OnTask() As %Status
{
	// All of the intelligence will be in BuildGroup
	Set tSC = $$$OK
	try {
		Set tRegistry = ##class(%DeepSee.CubeManager.Utils).BuildRegistryMap(.tSC,,1)
	 	If $$$ISERR(tSC) Quit
	 	
	 	Set tGroupIndex = ""
	 	For ii=1:1:tRegistry.Groups.Count() {
		 	Set tGroup = tRegistry.Groups.GetNext(.tGroupIndex)
		 	If tRegistry.SerialUpdates {
		 		Do ##class(%DeepSee.CubeManager.RegistryMapGroup).BuildGroup(tGroupIndex)
		 	} Else {
			 	Job ##class(%DeepSee.CubeManager.RegistryMapGroup).BuildGroup(tGroupIndex)
		 	}
	 	}
	}
	catch (ex) {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		Do ##class(%DeepSee.Utils).%WriteToLog("Task.Build",$system.Status.GetErrorText(tSC))
	}
	Quit $$$OK
}

/// This method will make sure the task is registered with the 
/// Task Manager to run on the schedule defined by the arguments. <br><br>
/// If there is currently no task scheduled, this will create one, otherwise
/// it will modify any pre-existing task. The default settings will run the 
/// build task once a day
ClassMethod Schedule(pSuspend = 0, pTimePeriod = 0, pTimePeriodEvery = 1, pTimePeriodDay = "", pStartTime = 0) As %Status
{
	Set tSc = $$$OK
	Try {
		Set tFullName = ..#TaskName _ " - " _ $NAMESPACE
		Set tTaskID = ##class(%SYS.Task).FindId(tFullName)
		If tTaskID = "" {
			// Task is not present, need to create one
			Set tTask = ##class(%SYS.Task).%New()
			Set tTask.Name = tFullName
			Set tTask.NameSpace = $NAMESPACE
			// DTB006 - Make this task work on Any mirror member
			Set tTask.MirrorStatus = 3
		} Else {
			// Task has already been defined, save it with the current schedule
			Set tTask = ##class(%SYS.Task).%OpenId(tTaskID)
		}
		
		Set tTask.TaskClass = "%DeepSee.CubeManager.Task.Build"
		Set tTask.RunAsUser = "_SYSTEM"
		Set tTask.Type = 0
		Set tTask.Description = "Build DeepSee Cubes according to the Cube Registry schedule"
		
		// Set schedule according to passed in parameters
		Set tTask.TimePeriod = pTimePeriod			
		Set tTask.TimePeriodEvery = pTimePeriodEvery   	
		Set tTask.TimePeriodDay = pTimePeriodDay
		
		// Build runs at most once every day
		Set tTask.DailyFrequency = 0
		Set tTask.DailyFrequencyTime = ""
		Set tTask.DailyIncrement = ""
		Set tTask.DailyStartTime = pStartTime
		Set tTask.DailyEndTime = "" 
		
		// The task should be operational at the next available build time
		If pStartTime < $P($H,",",2) {
			Set tSC = tTask.StartDateSet(+$h + 1)
		} Else {
			Set tSC = tTask.StartDateSet(+$h)
		}
		If $$$ISERR(tSC) Quit 
			
		Set tSC = tTask.%Save()
		If $$$ISERR(tSC) Quit
		
		If pSuspend {
			Set tSC = tTask.Suspend(tTask.%Id())
		} Else {
			Set tSC = tTask.Resume(tTask.%Id())
		}	
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		Do ##class(%DeepSee.Utils).%WriteToLog("Task.Build",$system.Status.GetErrorText(tSC))
	}

	Quit tSC
}

}
