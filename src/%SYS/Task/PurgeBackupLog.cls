Class %SYS.Task.PurgeBackupLog Extends %SYS.Task.Definition [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
HYY1601 11/19/10 Huayong Yang, created this class
-------------------End Documentation----------------------------------
*/
Parameter TaskName = "PurgeBackupLog";

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
Method OnTask() As %Status
{
#;We must run in %SYS
	d $zu(5,"%SYS")
	s Status=$$PurgeLog^DBACK()
	Quit Status
}

}
