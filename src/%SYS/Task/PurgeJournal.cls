Class %SYS.Task.PurgeJournal Extends %SYS.Task.Definition [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC1429 07/29/08 Steve Clay, System tasks always run in %SYS namespace 
JB203	04/07/05 James Bourette	 Ensure system tasks are initialized
-------------------End Documentation----------------------------------
*/
Parameter TaskName = "PurgeJournal";

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
Method OnTask() As %Status
{
#;We must run in %SYS
	d $zu(5,"%SYS")
	D PPURGE^JRNUTIL
	Quit $$$OK
}

}
