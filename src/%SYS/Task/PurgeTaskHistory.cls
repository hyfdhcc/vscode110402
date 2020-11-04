Class %SYS.Task.PurgeTaskHistory Extends %SYS.Task.Definition [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
JB519 	05/14/09 James Bourette, Document the KeepDays parameter 
STC1429 07/29/08 Steve Clay, System tasks always run in %SYS namespace 
JB242 	10/25/05 James Bourette  re-add PurgeTaskHistory 
-------------------End Documentation----------------------------------
*/
Parameter TaskName = "PurgeTaskHistory";

/// # of Log History Days to keep not including current day, minimum value is 1
Property KeepDays As %Integer(MINVAL = 1);

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
/// In order to execute a real task, override this method in a subclass.
Method OnTask() As %Status
{
#;We must run in %SYS
	d $zu(5,"%SYS")
	Set keepDays=..KeepDays
	Set:keepDays="" keepDays=##class(%SYS.Task).HistoryPurgeGet()
	Quit ##class(%SYS.Task.History).PurgeHistory(keepDays)
}

}
